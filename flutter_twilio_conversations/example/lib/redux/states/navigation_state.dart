class NavigationState {
  final bool isAuthorized;
  final bool isDialogOpened;

  NavigationState({
    required this.isAuthorized,
    required this.isDialogOpened,
  });

  NavigationState.initial()
      : isAuthorized = false,
        isDialogOpened = false;

  NavigationState copyWith({
    bool? isAuthorized,
    bool? isDialogOpened,
  }) =>
      NavigationState(
        isAuthorized: isAuthorized ?? this.isAuthorized,
        isDialogOpened: isDialogOpened ?? this.isDialogOpened,
      );
}
