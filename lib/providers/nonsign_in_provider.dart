import 'package:hooks_riverpod/hooks_riverpod.dart';

class NonSignInNotifier extends StateNotifier<SignInModel> {
  NonSignInNotifier() : super(_initialState);

  static final _initialState = SignInModel(
    ButtonState.signIn,
  );

  void switchButtons() {
    if (state.buttonState == ButtonState.signIn) {
      state = SignInModel(ButtonState.createUser);
    } else {
      state = SignInModel(ButtonState.signIn);
    }
  }
}

class SignInModel {
  const SignInModel(this.buttonState);
  final ButtonState buttonState;
}

enum ButtonState {
  createUser,
  signIn,
}
