import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsState {
  const AppSettingsState({required this.currencyCode});

  final String currencyCode;

  String get currencySymbol {
    switch (currencyCode) {
      case 'USD':
        return r'$';
      case 'EUR':
        return 'EUR';
      case 'GBP':
        return 'GBP';
      case 'INR':
        return 'Rs';
      case 'LKR':
      default:
        return 'Rs';
    }
  }

  String get pricePerLiterUnit => '$currencySymbol/L';

  AppSettingsState copyWith({String? currencyCode}) {
    return AppSettingsState(currencyCode: currencyCode ?? this.currencyCode);
  }
}

class AppSettingsNotifier extends AsyncNotifier<AppSettingsState> {
  static const _currencyKey = 'settings.currency_code';

  @override
  Future<AppSettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString(_currencyKey) ?? 'LKR';
    return AppSettingsState(currencyCode: currencyCode);
  }

  Future<void> setCurrencyCode(String currencyCode) async {
    final previous =
        state.valueOrNull ?? const AppSettingsState(currencyCode: 'LKR');
    state = AsyncValue.data(previous.copyWith(currencyCode: currencyCode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
  }
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettingsState>(
  AppSettingsNotifier.new,
);
