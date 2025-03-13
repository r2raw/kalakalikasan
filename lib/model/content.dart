class Content {

  const Content(this.contentId, this.images,this.title, this.description, this.timeAgo, this.type, this.reacts, this.comments);
  final String contentId;
  final List images;
  final String description;
  final String title;
  final Map<String, dynamic> timeAgo;
  final String type;
  final List reacts;
  // final int commentsLength;
  final List comments;
  // final int num_of_comments;
  // final int num_of_reacts;
}

class Comments{
  const Comments(this.commentId, this.commentedBy, this.dateCommented, this.message);

  final String commentId;
  final String commentedBy;
  final Map<String, dynamic> dateCommented;
  final String message;

}