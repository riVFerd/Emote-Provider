import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

/// Wrapper for the main app.
/// Handling window events and hotkeys.
class MyWindow extends StatefulWidget {
  final Widget child;

  const MyWindow({super.key, required this.child});

  @override
  State<MyWindow> createState() => _MyWindowState();
}

class _MyWindowState extends State<MyWindow> with WindowListener {
  final _hotKey = HotKey(
    key: PhysicalKeyboardKey.keyQ,
    modifiers: [HotKeyModifier.alt],
  );

  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    hotKeyManager.register(_hotKey, keyDownHandler: (_) async {
      if (await windowManager.isFocused()) {
        windowManager.hide();
        return;
      }
      windowManager.waitUntilReadyToShow(
        const WindowOptions(
          title: 'Emote provider',
          size: Size(680, 540),
          titleBarStyle: TitleBarStyle.normal,
        ),
        () async {
          await windowManager.show();
          await windowManager.focus();
        },
      );
    });
    initSystemTray();
    super.initState();
  }

  @override
  void dispose() {
    hotKeyManager.unregister(_hotKey);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    windowManager.hide();
    super.onWindowClose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> initSystemTray() async {
  String path = Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

  final AppWindow appWindow = AppWindow();
  final SystemTray systemTray = SystemTray();

  // We first init the systray menu
  await systemTray.initSystemTray(
    title: "system tray",
    iconPath: path,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
    MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => windowManager.destroy()),
  ]);

  // set context menu
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) {
    debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
    }
  });
}
