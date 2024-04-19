import 'package:dc_universal_emot/data/repositories/emoji_pack_hive_repository.dart';
import 'package:dc_universal_emot/my_app.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await hotKeyManager.unregisterAll();
  await Hive.initFlutter();
  runApp(
    BlocProvider(
      create: (context) => EmojiPackBloc(emojiPackRepository: EmojiPackHiveRepository()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyApp(
          child: HomePage(),
        ),
      ),
    ),
  );
}
