import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, loaded, updating, uploadingAvatar, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  bool get isLoading => status == ProfileStatus.loading;
  bool get isUpdating => status == ProfileStatus.updating;
  bool get isUploadingAvatar => status == ProfileStatus.uploadingAvatar;
  bool get hasError => status == ProfileStatus.error;
  bool get hasProfile => profile != null;

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? profile,
    bool clearProfile = false,
    String? errorMessage,
    bool clearError = false,
    String? avatar,
    bool clearAvatar = false,
  }) {
    UserEntity? newProfile = clearProfile ? null : (profile ?? this.profile);
    // Handle avatar updates
    if (avatar != null && newProfile != null) {
      newProfile = newProfile.copyWith(profilePicture: avatar);
    } else if (clearAvatar && newProfile != null) {
      newProfile = newProfile.copyWith(clearProfilePicture: true);
    }
    return ProfileState(
      status: status ?? this.status,
      profile: newProfile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  ProfileState clearError() {
    return copyWith(
      status: hasProfile ? ProfileStatus.loaded : ProfileStatus.initial,
      clearError: true,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
