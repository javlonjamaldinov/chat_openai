import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/localization/ar/ar_translations.dart';
import 'package:chat_with_bisky/localization/de/de_translations.dart';
import 'package:chat_with_bisky/localization/en_us/en_us_translations.dart';
import 'package:chat_with_bisky/localization/es/es_translations.dart';
import 'package:chat_with_bisky/localization/fr/fr_translations.dart';
import 'package:chat_with_bisky/localization/hi/hi_translations.dart';
import 'package:chat_with_bisky/localization/nl/nl_translations.dart';
import 'package:chat_with_bisky/localization/zh/zh_translations.dart';
import 'package:chat_with_bisky/main.dart';
import 'package:chat_with_bisky/model/AppLanguage.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

const String LAGUAGE_CODE = 'languageCode';
//languages code
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String ARABIC = 'ar';
const String HINDI = 'hi';
const String SPANISH = 'es';
const String DUTCH = 'nl';
const String CHINESE = 'zh';
const String GERMAN = 'de';

class AppLocalization {
  
  AppLocalization(this.locale);

  Locale locale;

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': enUs,
    'fr':fr,
    'ar':ar,
    'es':es,
    'hi':hi,
    'nl':nl,
    'zh':zh,
    'de':de,
  };

  static AppLocalization of() {
    return Localizations.of<AppLocalization>(
        appRouter.ctx!, AppLocalization)!;
  }

  static List<String> languages() => _localizedValues.keys.toList();
  String getString(String text) =>
      _localizedValues[locale.languageCode]![text] ?? text;
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalization.languages().contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

Future<Locale> setLocale(String languageCode) async {
  await LocalStorageService.putString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = await LocalStorageService.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case FRENCH:
      return const Locale(FRENCH, "FR");
    case ARABIC:
      return const Locale(ARABIC, "SA");
    case HINDI:
      return const Locale(HINDI, "IN");
    case SPANISH:
      return const Locale(SPANISH, "ES");
    case DUTCH:
      return const Locale(DUTCH, "NL");
    case CHINESE:
      return const Locale(CHINESE, "CN");
    case GERMAN:
      return const Locale(GERMAN, "DE");
    default:
      return const Locale(ENGLISH, 'UK');
  }
}

languageList(){
  List<AppLanguage> languages = [];
  languages.add(AppLanguage('ar','SA','arabic'.tr,''));
  languages.add(AppLanguage('en','US','english'.tr,''));
  languages.add(AppLanguage('fr','FR','french'.tr,''));
  languages.add(AppLanguage('es','ES','spanish'.tr,''));
  languages.add(AppLanguage('zh','CN','chinese'.tr,''));
  languages.add(AppLanguage('nl','NL','dutch'.tr,''));
  languages.add(AppLanguage('hi','IN','hindi'.tr,''));
  languages.add(AppLanguage('de','IN','german'.tr,''));
  return languages;
}

