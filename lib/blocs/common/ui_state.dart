abstract class UiState<T> {
  const UiState();
}

class Loading<T> extends UiState<T> {
  const Loading();
}

class Success<T> extends UiState<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends UiState<T> {
  final String message;
  const Error(this.message);
}

class NotLogged<T> extends UiState<T> {
  const NotLogged();
}

class NotAuthenticated<T> extends UiState<T> {
  const NotAuthenticated();
}
