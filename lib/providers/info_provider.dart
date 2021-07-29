import 'package:crazy_tweets_2/models/info_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InfoProvider extends StateNotifier<Info> {
  InfoProvider() : super(_initialState);

  static final _initialState = Info(page: 0);

  void setPage(int index) {
    state = Info(page: index);
  }
}
