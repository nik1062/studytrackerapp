import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is in HomeScreen
      body: Consumer<AppThemeProvider>(
        builder: (context, appThemeProvider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: appThemeProvider.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  appThemeProvider.toggleTheme(value);
                },
                secondary: const Icon(Icons.dark_mode),
              ),
              ListTile(
                title: const Text('Export Data'),
                leading: const Icon(Icons.import_export),
                onTap: () {
                  // TODO: Implement data export functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export functionality not yet implemented.')),
                  );
                },
              ),
              ListTile(
                title: const Text('About'),
                leading: const Icon(Icons.info),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'FocusFlow',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2026 Your Company',
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const Text('A simple app to track your study sessions and goals.'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
