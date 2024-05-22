// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:chat_with_bisky/main.dart' as _i10;
import 'package:chat_with_bisky/model/db/MessageRealm.dart' as _i17;
import 'package:chat_with_bisky/model/GroupAppwrite.dart' as _i16;
import 'package:chat_with_bisky/model/UserAppwrite.dart' as _i18;
import 'package:chat_with_bisky/pages/dashboard/chat/MessageScreen.dart' as _i9;
import 'package:chat_with_bisky/pages/dashboard/DashboardPage.dart' as _i2;
import 'package:chat_with_bisky/pages/dashboard/groups/details/GroupDetailsScreen.dart'
    as _i4;
import 'package:chat_with_bisky/pages/dashboard/groups/messages/details/GroupMessageDetailsScreen.dart'
    as _i5;
import 'package:chat_with_bisky/pages/dashboard/groups/messages/GroupMessageScreen.dart'
    as _i6;
import 'package:chat_with_bisky/pages/friend_details/FriendDetailsScreen.dart'
    as _i3;
import 'package:chat_with_bisky/pages/groups/create/CreateGroupScreen.dart'
    as _i1;
import 'package:chat_with_bisky/pages/introduction/IntroPage.dart' as _i7;
import 'package:chat_with_bisky/pages/login/Login.dart' as _i8;
import 'package:chat_with_bisky/pages/otp/OtpPage.dart' as _i11;
import 'package:chat_with_bisky/pages/update_name/UpdateNamePage.dart' as _i12;
import 'package:flutter/foundation.dart' as _i15;
import 'package:flutter/material.dart' as _i14;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    CreateGroupRoute.name: (routeData) {
      final args = routeData.argsAs<CreateGroupRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CreateGroupScreen(
          key: args.key,
          myUserId: args.myUserId,
        ),
      );
    },
    DashboardPage.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.DashboardPage(),
      );
    },
    FriendDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<FriendDetailsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.FriendDetailsScreen(
          key: args.key,
          friendId: args.friendId,
          myUserId: args.myUserId,
          name: args.name,
        ),
      );
    },
    GroupDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<GroupDetailsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.GroupDetailsScreen(
          key: args.key,
          group: args.group,
          myUserId: args.myUserId,
        ),
      );
    },
    GroupMessageDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<GroupMessageDetailsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.GroupMessageDetailsScreen(
          key: args.key,
          group: args.group,
          myUserId: args.myUserId,
          message: args.message,
        ),
      );
    },
    GroupMessageRoute.name: (routeData) {
      final args = routeData.argsAs<GroupMessageRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.GroupMessageScreen(
          displayGroupName: args.displayGroupName,
          myUserId: args.myUserId,
          friendUserId: args.friendUserId,
          group: args.group,
          profilePicture: args.profilePicture,
        ),
      );
    },
    IntroPage.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.IntroPage(),
      );
    },
    LoginPage.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.LoginPage(),
      );
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.MessageScreen(
          displayName: args.displayName,
          myUserId: args.myUserId,
          friendUserId: args.friendUserId,
          friendUser: args.friendUser,
          profilePicture: args.profilePicture,
        ),
      );
    },
    MyHomePage.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.MyHomePage(),
      );
    },
    OtpPage.name: (routeData) {
      final args = routeData.argsAs<OtpPageArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.OtpPage(args.userId),
      );
    },
    UpdateNamePage.name: (routeData) {
      final args = routeData.argsAs<UpdateNamePageArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.UpdateNamePage(
          args.userId,
          initial: args.initial,
          user: args.user,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.CreateGroupScreen]
class CreateGroupRoute extends _i13.PageRouteInfo<CreateGroupRouteArgs> {
  CreateGroupRoute({
    _i14.Key? key,
    required String myUserId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          CreateGroupRoute.name,
          args: CreateGroupRouteArgs(
            key: key,
            myUserId: myUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateGroupRoute';

  static const _i13.PageInfo<CreateGroupRouteArgs> page =
      _i13.PageInfo<CreateGroupRouteArgs>(name);
}

class CreateGroupRouteArgs {
  const CreateGroupRouteArgs({
    this.key,
    required this.myUserId,
  });

  final _i14.Key? key;

  final String myUserId;

  @override
  String toString() {
    return 'CreateGroupRouteArgs{key: $key, myUserId: $myUserId}';
  }
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardPage extends _i13.PageRouteInfo<void> {
  const DashboardPage({List<_i13.PageRouteInfo>? children})
      : super(
          DashboardPage.name,
          initialChildren: children,
        );

  static const String name = 'DashboardPage';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i3.FriendDetailsScreen]
class FriendDetailsRoute extends _i13.PageRouteInfo<FriendDetailsRouteArgs> {
  FriendDetailsRoute({
    _i15.Key? key,
    required String friendId,
    required String myUserId,
    required String name,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          FriendDetailsRoute.name,
          args: FriendDetailsRouteArgs(
            key: key,
            friendId: friendId,
            myUserId: myUserId,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'FriendDetailsRoute';

  static const _i13.PageInfo<FriendDetailsRouteArgs> page =
      _i13.PageInfo<FriendDetailsRouteArgs>(name);
}

class FriendDetailsRouteArgs {
  const FriendDetailsRouteArgs({
    this.key,
    required this.friendId,
    required this.myUserId,
    required this.name,
  });

  final _i15.Key? key;

  final String friendId;

  final String myUserId;

  final String name;

  @override
  String toString() {
    return 'FriendDetailsRouteArgs{key: $key, friendId: $friendId, myUserId: $myUserId, name: $name}';
  }
}

/// generated route for
/// [_i4.GroupDetailsScreen]
class GroupDetailsRoute extends _i13.PageRouteInfo<GroupDetailsRouteArgs> {
  GroupDetailsRoute({
    _i15.Key? key,
    required _i16.GroupAppwrite group,
    required String myUserId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          GroupDetailsRoute.name,
          args: GroupDetailsRouteArgs(
            key: key,
            group: group,
            myUserId: myUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'GroupDetailsRoute';

  static const _i13.PageInfo<GroupDetailsRouteArgs> page =
      _i13.PageInfo<GroupDetailsRouteArgs>(name);
}

class GroupDetailsRouteArgs {
  const GroupDetailsRouteArgs({
    this.key,
    required this.group,
    required this.myUserId,
  });

  final _i15.Key? key;

  final _i16.GroupAppwrite group;

  final String myUserId;

  @override
  String toString() {
    return 'GroupDetailsRouteArgs{key: $key, group: $group, myUserId: $myUserId}';
  }
}

/// generated route for
/// [_i5.GroupMessageDetailsScreen]
class GroupMessageDetailsRoute
    extends _i13.PageRouteInfo<GroupMessageDetailsRouteArgs> {
  GroupMessageDetailsRoute({
    _i15.Key? key,
    required _i16.GroupAppwrite group,
    required String myUserId,
    required _i17.MessageRealm message,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          GroupMessageDetailsRoute.name,
          args: GroupMessageDetailsRouteArgs(
            key: key,
            group: group,
            myUserId: myUserId,
            message: message,
          ),
          initialChildren: children,
        );

  static const String name = 'GroupMessageDetailsRoute';

  static const _i13.PageInfo<GroupMessageDetailsRouteArgs> page =
      _i13.PageInfo<GroupMessageDetailsRouteArgs>(name);
}

class GroupMessageDetailsRouteArgs {
  const GroupMessageDetailsRouteArgs({
    this.key,
    required this.group,
    required this.myUserId,
    required this.message,
  });

  final _i15.Key? key;

  final _i16.GroupAppwrite group;

  final String myUserId;

  final _i17.MessageRealm message;

  @override
  String toString() {
    return 'GroupMessageDetailsRouteArgs{key: $key, group: $group, myUserId: $myUserId, message: $message}';
  }
}

/// generated route for
/// [_i6.GroupMessageScreen]
class GroupMessageRoute extends _i13.PageRouteInfo<GroupMessageRouteArgs> {
  GroupMessageRoute({
    required String displayGroupName,
    required String myUserId,
    required String friendUserId,
    required _i16.GroupAppwrite group,
    String? profilePicture,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          GroupMessageRoute.name,
          args: GroupMessageRouteArgs(
            displayGroupName: displayGroupName,
            myUserId: myUserId,
            friendUserId: friendUserId,
            group: group,
            profilePicture: profilePicture,
          ),
          initialChildren: children,
        );

  static const String name = 'GroupMessageRoute';

  static const _i13.PageInfo<GroupMessageRouteArgs> page =
      _i13.PageInfo<GroupMessageRouteArgs>(name);
}

class GroupMessageRouteArgs {
  const GroupMessageRouteArgs({
    required this.displayGroupName,
    required this.myUserId,
    required this.friendUserId,
    required this.group,
    this.profilePicture,
  });

  final String displayGroupName;

  final String myUserId;

  final String friendUserId;

  final _i16.GroupAppwrite group;

  final String? profilePicture;

  @override
  String toString() {
    return 'GroupMessageRouteArgs{displayGroupName: $displayGroupName, myUserId: $myUserId, friendUserId: $friendUserId, group: $group, profilePicture: $profilePicture}';
  }
}

/// generated route for
/// [_i7.IntroPage]
class IntroPage extends _i13.PageRouteInfo<void> {
  const IntroPage({List<_i13.PageRouteInfo>? children})
      : super(
          IntroPage.name,
          initialChildren: children,
        );

  static const String name = 'IntroPage';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LoginPage]
class LoginPage extends _i13.PageRouteInfo<void> {
  const LoginPage({List<_i13.PageRouteInfo>? children})
      : super(
          LoginPage.name,
          initialChildren: children,
        );

  static const String name = 'LoginPage';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MessageScreen]
class MessageRoute extends _i13.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({
    required String displayName,
    required String myUserId,
    required String friendUserId,
    required _i18.UserAppwrite friendUser,
    String? profilePicture,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          MessageRoute.name,
          args: MessageRouteArgs(
            displayName: displayName,
            myUserId: myUserId,
            friendUserId: friendUserId,
            friendUser: friendUser,
            profilePicture: profilePicture,
          ),
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const _i13.PageInfo<MessageRouteArgs> page =
      _i13.PageInfo<MessageRouteArgs>(name);
}

class MessageRouteArgs {
  const MessageRouteArgs({
    required this.displayName,
    required this.myUserId,
    required this.friendUserId,
    required this.friendUser,
    this.profilePicture,
  });

  final String displayName;

  final String myUserId;

  final String friendUserId;

  final _i18.UserAppwrite friendUser;

  final String? profilePicture;

  @override
  String toString() {
    return 'MessageRouteArgs{displayName: $displayName, myUserId: $myUserId, friendUserId: $friendUserId, friendUser: $friendUser, profilePicture: $profilePicture}';
  }
}

/// generated route for
/// [_i10.MyHomePage]
class MyHomePage extends _i13.PageRouteInfo<void> {
  const MyHomePage({List<_i13.PageRouteInfo>? children})
      : super(
          MyHomePage.name,
          initialChildren: children,
        );

  static const String name = 'MyHomePage';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i11.OtpPage]
class OtpPage extends _i13.PageRouteInfo<OtpPageArgs> {
  OtpPage({
    required String userId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          OtpPage.name,
          args: OtpPageArgs(userId: userId),
          initialChildren: children,
        );

  static const String name = 'OtpPage';

  static const _i13.PageInfo<OtpPageArgs> page =
      _i13.PageInfo<OtpPageArgs>(name);
}

class OtpPageArgs {
  const OtpPageArgs({required this.userId});

  final String userId;

  @override
  String toString() {
    return 'OtpPageArgs{userId: $userId}';
  }
}

/// generated route for
/// [_i12.UpdateNamePage]
class UpdateNamePage extends _i13.PageRouteInfo<UpdateNamePageArgs> {
  UpdateNamePage({
    required String userId,
    bool? initial = true,
    _i18.UserAppwrite? user,
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          UpdateNamePage.name,
          args: UpdateNamePageArgs(
            userId: userId,
            initial: initial,
            user: user,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UpdateNamePage';

  static const _i13.PageInfo<UpdateNamePageArgs> page =
      _i13.PageInfo<UpdateNamePageArgs>(name);
}

class UpdateNamePageArgs {
  const UpdateNamePageArgs({
    required this.userId,
    this.initial = true,
    this.user,
    this.key,
  });

  final String userId;

  final bool? initial;

  final _i18.UserAppwrite? user;

  final _i14.Key? key;

  @override
  String toString() {
    return 'UpdateNamePageArgs{userId: $userId, initial: $initial, user: $user, key: $key}';
  }
}
