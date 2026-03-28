import 'package:equatable/equatable.dart';

class NotInfectedState extends Equatable {
  const NotInfectedState({
    this.playRemoteVideoUrl,
    this.snackbarError,
  });

  final String? playRemoteVideoUrl;
  final String? snackbarError;

  NotInfectedState copyWith({
    String? playRemoteVideoUrl,
    bool clearPlayRemoteVideoUrl = false,
    String? snackbarError,
    bool clearSnackbarError = false,
  }) {
    return NotInfectedState(
      playRemoteVideoUrl: clearPlayRemoteVideoUrl
          ? null
          : (playRemoteVideoUrl ?? this.playRemoteVideoUrl),
      snackbarError:
          clearSnackbarError ? null : (snackbarError ?? this.snackbarError),
    );
  }

  @override
  List<Object?> get props => [playRemoteVideoUrl, snackbarError];
}
