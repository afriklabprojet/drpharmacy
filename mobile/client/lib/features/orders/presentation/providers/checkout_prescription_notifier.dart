import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CheckoutPrescriptionState {
  final List<XFile> images;
  final String? notes;
  final String? errorMessage;

  const CheckoutPrescriptionState({this.images = const [], this.notes, this.errorMessage});

  CheckoutPrescriptionState copyWith({
    List<XFile>? images,
    String? notes,
    bool clearNotes = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutPrescriptionState(
      images: images ?? this.images,
      notes: clearNotes ? null : (notes ?? this.notes),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasImages => images.isNotEmpty;
  bool get hasValidPrescription => images.isNotEmpty;
}

class CheckoutPrescriptionNotifier
    extends StateNotifier<CheckoutPrescriptionState> {
  CheckoutPrescriptionNotifier()
      : super(const CheckoutPrescriptionState());

  void addImage(XFile image) {
    state = state.copyWith(images: [...state.images, image]);
  }

  void addImages(List<XFile> images) {
    state = state.copyWith(images: [...state.images, ...images]);
  }

  void removeImage(int index) {
    final updated = List<XFile>.from(state.images)..removeAt(index);
    state = state.copyWith(images: updated);
  }

  void reset() {
    state = const CheckoutPrescriptionState();
  }
}
