import 'package:dc_universal_emot/presentation/bloc/emoji_pack/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/bloc/sticker_pack/sticker_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/emoji_pack_page.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/emoji_pack_provider.dart';
import 'package:dc_universal_emot/presentation/pages/sticker_pack/sticker_pack_page.dart';
import 'package:dc_universal_emot/presentation/pages/sticker_pack/sticker_pack_provider.dart';
import 'package:dc_universal_emot/presentation/widgets/my_window.dart';
import 'package:dc_universal_emot/presentation/widgets/top_bar.dart';
import 'package:dc_universal_emot/services/platform_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'constants/color_constant.dart';
import 'injections/injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<EmojiPackBloc>()),
        BlocProvider(create: (context) => getIt<StickerPackBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyWindow(
          child: Scaffold(
            backgroundColor: darkGray100,
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => EmojiPackProvider()),
                ChangeNotifierProvider(create: (_) => StickerPackProvider()),
                ChangeNotifierProvider(create: (_) => AppProvider()),
              ],
              child: Column(
                children: [
                  const TopBar(),
                  Expanded(
                    child: Consumer<AppProvider>(
                      builder: (_, state, __) {
                        // check if the state is not null
                        return switch (state.currentTab) {
                          TabMode.emoji => const EmojiPackPage(),
                          TabMode.sticker => const StickerPackPage(),
                          TabMode.settings => Container(
                              child: TextButton(
                                onPressed: () {
                                  PlatformServices().simulatePaste();
                                },
                                child: const Text('Simulate Paste'),
                              ),
                            ),
                        };
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppProvider with ChangeNotifier {
  TabMode _currentTab = TabMode.emoji;
  final _searchController = TextEditingController();

  TabMode get currentTab => _currentTab;

  TextEditingController get searchController => _searchController;

  void setCurrentTab(TabMode tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void clearSearch() {
    _searchController.clear();
  }
}

enum TabMode {
  emoji,
  sticker,
  settings,
}
