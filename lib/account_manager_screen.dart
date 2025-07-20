import 'package:flutter/material.dart';
import 'account_storage.dart';
import 'apk_manager.dart';
import 'apk_installer.dart';

class AccountManagerScreen extends StatefulWidget {
  const AccountManagerScreen({super.key});

  @override
  _AccountManagerScreenState createState() => _AccountManagerScreenState();
}

class _AccountManagerScreenState extends State<AccountManagerScreen> {
  final AccountStorage _accountStorage = AccountStorage();
  List<Map<String, String>> _accounts = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApkManager _apkManager = ApkManager('/path/to/your/apk/folder'); // Replace with your APK folder path
  final ApkInstaller _apkInstaller = ApkInstaller();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    _accounts = await _accountStorage.getAccounts();
    setState(() {});
  }

  Future<void> _addAccount() async {
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      await _accountStorage.addAccount(_usernameController.text, _passwordController.text);
      _usernameController.clear();
      _passwordController.clear();
      _loadAccounts();
    }
  }

  Future<void> _installApks() async {
    final apkFiles = await _apkManager.getApkFiles();
    for (final apkFile in apkFiles) {
      await _apkInstaller.installApk(apkFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(onPressed: _addAccount, child: const Text('Add Account')),
            const SizedBox(height: 20),
            const Text('Stored Accounts:'),
            Expanded(
              child: ListView.builder(
                itemCount: _accounts.length,
                itemBuilder: (context, index) {
                  final account = _accounts[index];
                  return ListTile(
                    title: Text(account['username']!),
                    subtitle: Text(account['password']!),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: _installApks, child: const Text('Install APKs')),
            // Add button to trigger auto-login (requires native implementation)
            // ElevatedButton(onPressed: _triggerAutoLogin, child: const Text('Auto Login')),
          ],
        ),
      ),
    );
  }
}
