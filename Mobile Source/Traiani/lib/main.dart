import 'dart:async';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutterbuyandsell/constant/router.dart' as router;
import 'package:flutterbuyandsell/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/config/ps_theme_data.dart';
import 'package:flutterbuyandsell/provider/common/ps_theme_provider.dart';
import 'package:flutterbuyandsell/provider/ps_provider_dependencies.dart';
import 'package:flutterbuyandsell/repository/ps_theme_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'db/common/ps_shared_preferences.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    _fcm.requestNotificationPermissions(const IosNotificationSettings());
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', null);
    await prefs.setString('codeL', null);
  }
  Admob.initialize(Utils.getAdAppId());

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  //runApp(EasyLocalization(child: PSApp()));
  runApp(EasyLocalization(
      // data: data,
      // assetLoader: CsvAssetLoader(),
      path: 'assets/langs',
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  // bool _isLanguageLoaded = false;

  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();

    // _isLanguageLoaded = false;
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      //SharedPreferences sh = await
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        //independentProviders.add(Provider.value(value: psSharedPreferences));
        //providerList = [...providers];
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  // Future<dynamic> getCurrentLang(EasyLocalizationProvider provider) async {
  //   if (!_isLanguageLoaded) {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     provider.data.changeLocale(Locale(
  //         prefs.getString(PsConst.LANGUAGE__LANGUAGE_CODE_KEY) ??
  //             PsConfig.defaultLanguage.languageCode,
  //         prefs.getString(PsConst.LANGUAGE__COUNTRY_CODE_KEY) ??
  //             PsConfig.defaultLanguage.countryCode));
  //     _isLanguageLoaded = true;
  //   }
  // }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);
    print('*** ${Utils.convertColorToString(PsColors.mainColor)}');
    // final EasyLocalization provider2 = EasyLocalization.of(context);
    // final dynamic data = provider2.data;

    // getCurrentLang(provider2);
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.dark,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Panacea-Soft',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
                // routes: <String, Widget Function(BuildContext)>{},
                // initialRoute: RoutePaths.appLoading,
                // onGenerateRoute: Router.generateRoute,
                // localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   //app-specific localization
                //   // EasylocaLizationDelegate(
                //   //     locale: data.locale ??
                //   //         Locale(PsConfig.defaultLanguage.languageCode,
                //   //             PsConfig.defaultLanguage.countryCode),
                //   // path: 'assets/langs'),
                // ],
                // supportedLocales: getSupportedLanguages(),

                //ps_language_list,
                // locale: data.locale ??
                //     Locale(PsConfig.defaultLanguage.languageCode,
                //         PsConfig.defaultLanguage.countryCode),
                // ),
              );
            }));
  }
}

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'dart:async';
// import 'dart:io' show Platform;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutterbuyandsell/utils/utils.dart';
// import 'package:flutterbuyandsell/viewobject/chat.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final FirebaseApp app = await FirebaseApp.configure(
//     name: 'flutter-buy-and-sell',
//     options: Platform.isIOS
//         ? const FirebaseOptions(
//             googleAppID: '1:505384053995:ios:85beace4987a7e894ae2ae',
//             gcmSenderID: '505384053995',
//             databaseURL: 'https://flutter-buy-and-sell.firebaseio.com',
//             apiKey: 'AIzaSyATAyoY0jwNqHA281sFD9JkgBYaqgF6KHE')
//         : const FirebaseOptions(
//             googleAppID: '1:505384053995:android:ee25be13120e023b4ae2ae',
//             apiKey: 'AIzaSyBtTRnm8XIQqcFo2B-eao0oelE4T0etKhM',
//             databaseURL: 'https://flutter-buy-and-sell.firebaseio.com',
//           ),
//   );
//   runApp(MaterialApp(
//     title: 'Flutter Database Example',
//     home: MyHomePage(app: app),
//   ));
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({this.app});
//   final FirebaseApp app;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   DatabaseReference _messagesRef;
//   StreamSubscription<Event> _counterSubscription;
//   StreamSubscription<Event> _messagesSubscription;
//   bool _anchorToBottom = true;

//   @override
//   void initState() {
//     super.initState();
//     // Demonstrates configuring the database directly
//     final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
//     _messagesRef = database.reference().child('messages');

//     if (database != null && database.databaseURL != null) {
//       database.setPersistenceEnabled(true);
//       database.setPersistenceCacheSizeBytes(10000000);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _messagesSubscription.cancel();
//     _counterSubscription.cancel();
//   }

//   Future<void> _increment() async {
//     final Chat chat = Chat();
//     chat.offerStatus = 'hello';
//     chat.message = 'world #';
//     chat.type = 'fancy';
//     chat.isSold = '1';

//     final String newkey = _messagesRef.child('userid1_userid2').push().key;
//     chat.id = newkey;

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutterbuyandsell/viewobject/chat.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final FirebaseApp app = await FirebaseApp.configure(
//     name: 'flutter-buy-and-sell',
//     options: Platform.isIOS
//         ? const FirebaseOptions(
//             googleAppID: '1:505384053995:ios:85beace4987a7e894ae2ae',
//             gcmSenderID: '505384053995',
//             databaseURL: 'https://flutter-buy-and-sell.firebaseio.com',
//             apiKey: 'AIzaSyATAyoY0jwNqHA281sFD9JkgBYaqgF6KHE')
//         : const FirebaseOptions(
//             googleAppID: '1:505384053995:android:ee25be13120e023b4ae2ae',
//             apiKey: 'AIzaSyBtTRnm8XIQqcFo2B-eao0oelE4T0etKhM',
//             databaseURL: 'https://flutter-buy-and-sell.firebaseio.com',
//           ),
//   );
//   runApp(MaterialApp(
//     title: 'Flutter Database Example',
//     home: MyHomePage(app: app),
//   ));
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({this.app});
//   final FirebaseApp app;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   DatabaseReference _messagesRef;
//   StreamSubscription<Event> _counterSubscription;
//   StreamSubscription<Event> _messagesSubscription;
//   bool _anchorToBottom = true;

//   @override
//   void initState() {
//     super.initState();
//     // Demonstrates configuring the database directly
//     final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
//     _messagesRef = database.reference().child('messages');

//     if (database != null && database.databaseURL != null) {
//       database.setPersistenceEnabled(true);
//       database.setPersistenceCacheSizeBytes(10000000);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _messagesSubscription.cancel();
//     _counterSubscription.cancel();
//   }

//   Future<void> _increment() async {
//     final Chat chat = Chat();
//     chat.status = 'hello 88';
//     chat.message = 'world #';

//     final String newkey = _messagesRef.child('userid1_userid2').push().key;
//     chat.chatKey = newkey;
//     // Add / Update
//   }

//   @override
//   Widget build(BuildContext context) {
//     Utils.sortingUserId('zoo', 'orange').then((String onValue) {
//       sortUserId = onValue;
//     });
//       appBar: AppBar(
//         title: const Text('Flutter Database Example'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           ListTile(
//             leading: Checkbox(
//               onChanged: (bool value) {

//                   _anchorToBottom = value;
//                 });
//               },
//               value: _anchorToBottom,
//             ),
//             title: const Text('Anchor to bottom'),
//           ),
//           Flexible(
//             child: FirebaseAnimatedList(
//               key: ValueKey<bool>(_anchorToBottom),
//               query: _messagesRef.child('userid1_userid2'),
//               reverse: _anchorToBottom,
//                   ? (DataSnapshot a, DataSnapshot b) {
//                       return b.key.compareTo(a.key);
//                     }
//                   : null,
//               itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                   Animation<double> animation, int index) {
//               itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

//                 print(chat.message);
//                 return SizeTransition(
//                   sizeFactor: animation,
//                   child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       child: snapshot.value.toString().contains('88')
//                           ? Text(
//                               textAlign: TextAlign.right,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .body1
//                                   .copyWith(color: Colors.red),
//                             )
//                           : Text(
//                               '$index: ${chat.offerStatus} ${chat.message} ${chat.type} ${snapshot.key.toString()}')),

//                               textAlign: TextAlign.right,
//                               style: Theme.of(context).textTheme.body1.copyWith(color: Colors.red),
//                             )
//                           : Text('$index: ${chat.status} ${chat.message} ${snapshot.key.toString()}')),

//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _increment,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
