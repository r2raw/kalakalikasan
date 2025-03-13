import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/content.dart';
import 'package:kalakalikasan/model/order_request.dart';

class ContentProviderNotifier extends StateNotifier<List<Content>> {
  ContentProviderNotifier() : super([]);

  void loadContent(List<Content> contents) {
    state = contents;
  }

  bool hasReacted(String contentId, String userId) {
    bool hasReacted = false;
    final List<Content> contentList = List.from(state);
    final contentIndex =
        contentList.indexWhere((content) => content.contentId == contentId);
    if (contentIndex != -1) {
      final List<Map<String, dynamic>> reacts =
          List.from(contentList[contentIndex].reacts);

      final reactIndex =
          reacts.indexWhere((react) => react['reactId'] == userId);
      if (reactIndex != -1) {
        hasReacted = true;
      }
    }
    return hasReacted;
  }

  void addReact(String contentId, String userId) {
    final List<Content> contentList = List.from(state);
    final contentIndex =
        contentList.indexWhere((content) => content.contentId == contentId);

    if (contentIndex != -1) {
      contentList[contentIndex].reacts.add({'reactId': userId});
    }
    state = contentList;
  }
  void addComment(String contentId, Map<String, dynamic> comment) {

    print('contentId: $contentId');
    print('comment: $comment');
    final List<Content> contentList = List.from(state);
    final contentIndex =
        contentList.indexWhere((content) => content.contentId == contentId);

    if (contentIndex != -1) {
      contentList[contentIndex].comments.add(comment);

      print('comments: ${contentList[contentIndex].comments}');
    }
    state = contentList;
  }

  void removeReact(String contentId, String userId) {
    final List<Content> contentList = List.from(state);
    final contentIndex =
        contentList.indexWhere((content) => content.contentId == contentId);

    if (contentIndex != -1) {
      contentList[contentIndex]
          .reacts
          .removeWhere((reaction) => reaction['reactId'] == userId);
    }

    state = contentList;
  }
}

final contentProvider =
    StateNotifierProvider<ContentProviderNotifier, List<Content>>((ref) {
  return ContentProviderNotifier();
});
