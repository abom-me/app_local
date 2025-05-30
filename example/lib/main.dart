import 'package:flutter/material.dart';
import 'package:app_local/app_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(
      localeNames: ['en', 'ar'],
      localPath: "assets/a/",
      // phoneLocale: true
      ); // get last saved language
  // remove await async (to get system language as default)

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        title: 'Flutter Locales',
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: LocaleText('localization')),
      body: Center(
        child: LocaleText('welcome', style: TextStyle(fontSize: 32)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SettingScreen()));
        },
        child: Icon(Icons.settings),
      ),
    );
  }
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Locales.string(context, 'setting'))),
      // with extension
      // appBar: AppBar(title: Text(context.localeString('setting'))),
      body: Column(
        children: [
          ListTile(
            onTap: () => Locales.change(context, 'en'),
            title: LocaleText('english'),
          ),
          ListTile(
            onTap: () => Locales.change(context, 'ar'),
            title: LocaleText('arabic'),
          ),
          // to change language with Extension
          ListTile(
            onTap: () => context.changeLocale('auto'),
            title: LocaleText('auto'),
          ),
          Text('Current Locale: ' +
              Locales.currentLocale(context)!.languageCode),
          // Text('Current Locale: ' + context.currentLocale.languageCode), // with Extension
        ],
      ),
    );
  }
}
