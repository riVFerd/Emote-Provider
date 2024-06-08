// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/repositories/emoji_pack_hive_repository.dart' as _i8;
import '../data/repositories/sticker_pack_hive_repository.dart' as _i6;
import '../domain/repositories/emoji_pack_repository.dart' as _i7;
import '../domain/repositories/sticker_pack_repository.dart' as _i5;
import '../presentation/bloc/emoji_pack/emoji_pack_bloc.dart' as _i10;
import '../presentation/bloc/sticker_pack/sticker_pack_bloc.dart' as _i9;
import '../services/clipboard_service.dart' as _i3;
import '../services/file_service.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.ClipboardService>(() => _i3.ClipboardService());
    gh.lazySingleton<_i4.FileService>(() => _i4.FileService());
    gh.singleton<_i5.StickerPackRepository>(
        () => _i6.StickerPackHiveRepository());
    gh.singleton<_i7.EmojiPackRepository>(() => _i8.EmojiPackHiveRepository());
    gh.lazySingleton<_i9.StickerPackBloc>(() => _i9.StickerPackBloc(
        stickerPackRepository: gh<_i5.StickerPackRepository>()));
    gh.lazySingleton<_i10.EmojiPackBloc>(() =>
        _i10.EmojiPackBloc(emojiPackRepository: gh<_i7.EmojiPackRepository>()));
    return this;
  }
}
