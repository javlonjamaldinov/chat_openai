import 'dart:io';
import 'dart:ui';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/dependency-injection/injection.dart';
import 'package:chat_with_bisky/firebase_options.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/ChatAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/values/values.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kiwi/kiwi.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:chat_with_bisky/core/providers/GroupMessagesInfoRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';

import 'localization/app_localization.dart';

ProviderContainer _containerGlobal = ProviderContainer();

Future<void> main() async {
  initializeKiwi();
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  container.read(realtimeProvider);
  container.read(realtimeNotifierProvider);
  container.read(realmRepositoryProvider);
  container.read(databaseProvider);
  container.read(storageProvider);
  container.read(messageRepositoryProvider);
  _containerGlobal = container;
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelGroupKey: 'category_tests',
          channelKey: 'CodeWithBiskyChannelId',
          channelName: 'Calls Channel',
          channelDescription: 'Channel with call ringtone',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.Max,
          ledColor: Colors.white,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone),
    ],
  );

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  await initializeService();
  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ));
}

Future<void> initializeService() async {


  if (WebRTC.platformIsAndroid) {

    final androidConfig = const FlutterBackgroundAndroidConfig(
    notificationTitle: "CodeWithBisky",
    notificationText: "Background notification for keeping the CodeWithBisky running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );



    await FlutterBackground.initialize(androidConfig: androidConfig).then(
        (value) async {
      // value is false
      if (value) {
         bool enabled = await FlutterBackground.enableBackgroundExecution();
      }
      return value;
    }, onError: (e) {
      print('error>>>> $e');
    });
  }


  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
        foregroundServiceNotificationId: 888),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  _realtimeSynchronisation();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  _realtimeSynchronisation();
}

_realtimeSynchronisation() async {

  String? userId =
  await LocalStorageService.getString(LocalStorageService.userId);

  _containerGlobal.listen<RealtimeNotifier?>(
      realtimeNotifierProvider.select((value) => value.asData?.value),
      (previous, next) async {
    if (next?.document.$collectionId == Strings.collectionMessagesId) {
      final message = MessageAppwrite.fromJson(next!.document.data);


      if (userId != null) {
        if (message.senderUserId == userId ||
            message.receiverUserId == userId) {
          _containerGlobal
              .read(realmRepositoryProvider)
              .saveMessage(message, next.document, next.type, userId);

          if (!myMessage(message, userId) &&
              (message.delivered == false || message.delivered == null)) {
            _containerGlobal
                .read(messageRepositoryProvider)
                .updateMessageDelivered(next.document.$id);

            print('Message delivered');
          }
        }
      }
    }

    if (next?.document.$collectionId == Strings.collectionChatsId) {
      final chat = ChatAppwrite.fromJson(next!.document.data);


      if (userId != null) {
        if (chat.receiverUserId == userId) {
          _containerGlobal
              .read(realmRepositoryProvider)
              .createOrUpdateChatHead(chat, next.document, next.type, userId);
        }
      }
    }

    if (next?.document.$collectionId == Strings.collectionGroupId) {
      final group = GroupAppwrite.fromJson(next!.document.data);

      if (userId != null) {

        final member = await _containerGlobal
            .read(groupRepositoryProvider).getGroupMemberByUserId(group.id??"", userId);


        if (member != null && group.sendUserId != userId) {

          _containerGlobal
              .read(groupMessagesInfoRepositoryProvider)
              .updateGroupMemberMessagesInfoDelivered(group,userId,group.messageId??"");
        }
      }
    }
  });
}

myMessage(MessageAppwrite message, String myUserId) {
  return message.senderUserId == myUserId;
}
final appRouter = AppRouter();
class MyApp extends StatefulWidget {


  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(Locale newLocale) {
    _MyAppState? state = appRouter.ctx?.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Locale? _locale;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'Bisky Chat App',
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale(
          'en',
          'US',
        ),  Locale(
          'fr',
          'FR',
        ),
        Locale("es", "ES"),
        Locale("ar", "SA"),
        Locale("hi", "IN"),
        Locale("nl", "NL"),
        Locale("zh", "CN"),
        Locale("de", "DE"),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }
}

@RoutePage()
class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final LocalStorageService appWriteClientService =
      KiwiContainer().resolve<LocalStorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Chat with Bisky"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImagePath.logo,
              width: 200,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

       WidgetsBinding.instance.addPostFrameCallback((_) => initialization());

  }

  initialization() async {
    Future<void>.delayed(const Duration(seconds: 3));
    String? stage =
        await LocalStorageService.getString(LocalStorageService.stage);

    Locale locale = await getLocale();
    MyApp.setLocale(locale);
    if (stage != null) {
      if (stage == LocalStorageService.dashboardPage) {
        AutoRouter.of(context).push(const DashboardPage());
      } else if (stage == LocalStorageService.updateNamePage) {
        String? userId =
            await LocalStorageService.getString(LocalStorageService.userId);

        final user = await ref.read(userRepositoryProvider).getUser(userId??"");
        AutoRouter.of(context).push(UpdateNamePage(userId: userId ?? "",user: user));
      } else {
        AutoRouter.of(context).push(const IntroPage());
      }
    } else {
      // navigate to intro screen
      AutoRouter.of(context).push(const IntroPage());
    }
  }
}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  final map = message.toMap();

  print('background message ${map.toString()}');
  final data = map['data'];

  if (data.containsKey('messageType')) {
    final messageType = data['messageType'];

    if (messageType == AttachmentType.text) {
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) return;

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 888,
        channelKey: 'CodeWithBiskyChannelId',
        title: 'Message: ${data['fromName']}',
        body: "${data['message']}",
      ));
    }
  }
}
