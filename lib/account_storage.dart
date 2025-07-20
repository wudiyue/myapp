import 'package:shared_preferences/shared_preferences.dart';

class AccountStorage {
  static const String _accountsKey = 'accounts';

  Future<List<Map<String, String>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getStringList(_accountsKey) ?? [];
    return accountsJson.map((accountString) {
      final parts = accountString.split(':');
      return {'username': parts[0], 'password': parts[1]};
    }).toList();
  }

  Future<void> saveAccounts(List<Map<String, String>> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = accounts.map((account) {
      return '${account['username']}:${account['password']}';
    }).toList();
    await prefs.setStringList(_accountsKey, accountsJson);
  }

  Future<void> addAccount(String username, String password) async {
    final accounts = await getAccounts();
    if (accounts.length < 5) {
      accounts.add({'username': username, 'password': password});
      await saveAccounts(accounts);
    } else {
      // Handle case where maximum accounts reached
      print('Maximum 5 accounts allowed.');
    }
  }
}