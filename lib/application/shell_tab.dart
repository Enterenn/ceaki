import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom navigation index: 0 Scan · 1 Bibliothèque · 2 Profil.
class ShellTab extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

final shellTabProvider = NotifierProvider<ShellTab, int>(ShellTab.new);
