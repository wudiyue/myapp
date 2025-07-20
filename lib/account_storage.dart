import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class AccountStorage {
  static const String _accountsKey = 'user_accounts';

  Future<void> saveAccounts(List<Map<String, String>> accounts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = accounts.map((account) => '${account["email"]},${account["password"]}').toList();
      await prefs.setStringList(_accountsKey, accountsJson);
      developer.log('Accounts saved successfully.', name: 'AccountStorage');
    } catch (e) {
      developer.log('Error saving accounts: $e', name: 'AccountStorage', level: 1000); // SEVERE
    }
  }

  Future<List<Map<String, String>>> loadAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = prefs.getStringList(_accountsKey) ?? [];
      final accounts = accountsJson.map((accountJson) {
        final parts = accountJson.split(',');
        return {'email': parts[0], 'password': parts[1]};
      }).toList();
      developer.log('Accounts loaded successfully.', name: 'AccountStorage');
      return accounts;
    } catch (e) {
      developer.log('Error loading accounts: $e', name: 'AccountStorage', level: 1000); // SEVERE
      return [];
    }
  }
}