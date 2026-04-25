enum PrivacyAction { none, changePassword }

class PrivacySecurityState {
  final bool isLoading;
  final PrivacyAction activeAction;
  final String? errorMessage;
  final bool isSuccess;

  const PrivacySecurityState({
    this.isLoading = false,
    this.activeAction = PrivacyAction.none,
    this.errorMessage,
    this.isSuccess = false,
  });

  PrivacySecurityState copyWith({
    bool? isLoading,
    PrivacyAction? activeAction,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return PrivacySecurityState(
      isLoading: isLoading ?? this.isLoading,
      activeAction: activeAction ?? this.activeAction,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
