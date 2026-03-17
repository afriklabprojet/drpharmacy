import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/providers.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/usecases/delete_avatar_usecase.dart';
import 'profile_notifier.dart';
import 'profile_state.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);

  return ProfileNotifier(
    getProfileUseCase: GetProfileUseCase(repository),
    updateProfileUseCase: UpdateProfileUseCase(repository),
    uploadAvatarUseCase: UploadAvatarUseCase(repository),
    deleteAvatarUseCase: DeleteAvatarUseCase(repository),
  );
});
