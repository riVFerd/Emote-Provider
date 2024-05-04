// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/repositories/emoji_pack_hive_repository.dart' as _i7;
import '../data/repositories/sticker_pack_hive_repository.dart' as _i5;
import '../domain/repositories/emoji_pack_repository.dart' as _i6;
import '../domain/repositories/sticker_pack_repository.dart' as _i4;
import '../presentation/bloc/emoji_pack/emoji_pack_bloc.dart' as _i9;
import '../presentation/bloc/sticker_pack/sticker_pack_bloc.dart' as _i8;
import '../services/file_service.dart' as _i3;

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
    gh.lazySingleton<_i3.FileService>(() => _i3.FileService());
    gh.singleton<_i4.StickerPackRepository>(
        () => _i5.StickerPackHiveRepository());
    gh.singleton<_i6.EmojiPackRepository>(() => _i7.EmojiPackHiveRepository());
    gh.lazySingleton<_i8.StickerPackBloc>(() => _i8.StickerPackBloc(
        stickerPackRepository: gh<_i4.StickerPackRepository>()));
    gh.lazySingleton<_i9.EmojiPackBloc>(() =>
        _i9.EmojiPackBloc(emojiPackRepository: gh<_i6.EmojiPackRepository>()));
    return this;
  }
}
