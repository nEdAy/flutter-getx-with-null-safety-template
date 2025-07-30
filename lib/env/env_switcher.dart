import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';
import 'env_banner_config.dart';

enum DefaultEnv { production, staging, development }

const _defaultEnv = DefaultEnv.production;

String _currentEnv = _defaultEnv.name;
final Map<String, Env> _environments = {};

/// Returns the current environment's configuration.
///
/// Example:
/// ```dart
/// var config = switcher.currentConfig;
/// print(config['api_url']);
/// ```
@riverpod
Map<String, dynamic> currentConfig() {
  return _environments[_currentEnv]?.config ?? {};
}

/// Returns the name of the current environment.
@riverpod
String currentEnv() {
  return _currentEnv;
}

/// Manages development environments and switching between them.
class EnvSwitcher {
  static const _prefKey = 'current_env';

  /// Adds an environment with a [name] and [config].
  ///
  /// Example:
  /// ```dart
  /// switcher.addEnvironment('staging', {'api_url': 'https://staging.example.com'});
  /// ```
  static void addEnvironment(String name, Map<String, dynamic> config) {
    _environments[name] = Env(name, config);
  }

  /// Switches to the environment with the given [name].
  ///
  /// Persists the selected environment using `SharedPreferences`.
  /// Throws an exception if the environment does not exist.
  ///
  /// Example:
  /// ```dart
  /// await switcher.switchTo('production');
  /// ```
  static Future<void> switchTo(String name) async {
    if (!_environments.containsKey(name)) throw Exception('Env not found');
    _currentEnv = name;
    EnvBannerConfig(_currentEnv);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, name);
  }

  static bool isProduction() {
    return currentEnv == DefaultEnv.production;
  }

  static bool isStaging() {
    return currentEnv == DefaultEnv.staging;
  }

  static bool isDevelopment() {
    return currentEnv == DefaultEnv.development;
  }

  /// Exports all environments to a JSON string.
  ///
  /// Example:
  /// ```dart
  /// String jsonStr = switcher.exportToJson();
  /// print(jsonStr);
  /// ```
  static String exportToJson() {
    final data = _environments.map((key, env) => MapEntry(key, env.toJson()));
    return jsonEncode(data);
  }

  /// Imports environments from a JSON string.
  ///
  /// Example:
  /// ```dart
  /// switcher.importFromJson(jsonString);
  /// ```
  static void importFromJson(String jsonStr) {
    final Map<String, dynamic> data = jsonDecode(jsonStr);
    _environments.clear();
    data.forEach((key, value) {
      _environments[key] = Env.fromJson(key, value);
    });
  }

  /// Loads the last selected environment from persistent storage.
  static Future<void> loadCurrentEnv() async {
    final prefs = await SharedPreferences.getInstance();
    _currentEnv = prefs.getString(_prefKey) ?? _defaultEnv.name;
    EnvBannerConfig(_currentEnv);
  }

  static Future<Env?> showEnvSwitcherDialog(BuildContext context) async {
    return await showDialog<Env>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select an environment'),
          children: _environments.values
              .map(
                (env) => SimpleDialogOption(
                  onPressed: () {
                    switchTo(env.name);
                    Navigator.pop(context, env);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      env.name,
                      style: _currentEnv == env.name
                          ? TextStyle(fontSize: 16, color: Colors.red)
                          : TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
