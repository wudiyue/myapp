import 'package:flutter/material.dart';
import 'account_storage.dart';
import 'apk_manager.dart';
import 'apk_installer.dart';
import 'dart:developer' as developer;

class AccountManagerScreen extends StatefulWidget {
  const AccountManagerScreen({super.key});

  @override
  AccountManagerScreenState createState() => AccountManagerScreenState();
}

class AccountManagerScreenState extends State<AccountManagerScreen> {
  final _accountStorage = AccountStorage();
  final _apkInstaller = ApkInstaller();
  List<Map<String, String>> _accounts = [];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    _accounts = await _accountStorage.loadAccounts();
    setState(() {});
  }

  Future<void> _saveAccount() async {
    if (_accounts.length >= 5) {
      if (!mounted) return; // Add mounted check
      _showSnackBar('最多只能保存 5 个账号');
      return;
    }

    final newAccount = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    _accounts.add(newAccount);
    await _accountStorage.saveAccounts(_accounts);
    _emailController.clear();
    _passwordController.clear();
    if (!mounted) return; // Add mounted check
    setState(() {});

    _showSnackBar('账号已保存');
  }

  Future<void> _installAndLogin(String apkPath, String email, String password) async {
    // 安装 APK
    final installResult = await _apkInstaller.installApk(apkPath);
    developer.log('Install result: $installResult', name: 'AccountManagerScreen');

    // 自动化登录 (需要在原生 Android 中实现辅助功能服务)
    final loginResult = await _apkInstaller.automateLogin(email, password);
     developer.log('Login result: $loginResult', name: 'AccountManagerScreen');

     _showSnackBar('安装结果: $installResult, 登录尝试结果: $loginResult');
  }

  // 添加一个私有方法用于显示 SnackBar
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账号管理'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '邮箱'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '密码'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveAccount,
              child: const Text('保存账号'),
            ),
            const SizedBox(height: 24.0),
            Text('已保存账号 (${_accounts.length}/5):'),
            Expanded(
              child: ListView.builder(
                itemCount: _accounts.length,
                itemBuilder: (context, index) {
                  final account = _accounts[index];
                  return ListTile(
                    title: Text(account['email']!),
                    subtitle: Text(account['password']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () async {
                        // 获取 tool_apks 文件夹下的第一个 APK 文件路径
                        final apkFiles = await getApkFilePaths('tool_apks');

                        if (!mounted) return; // 在使用 context 之前进行 mounted 检查

                        if (apkFiles.isNotEmpty) {
                           // 调用安装并登录方法
                           _installAndLogin(apkFiles.first, account['email']!, account['password']!);
                        } else {
                           _showSnackBar('在 tool_apks 文件夹中未找到 APK 文件'); // 调用新的方法
                        }
                      },
                      tooltip: '安装并自动登录',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
