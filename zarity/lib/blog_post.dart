class BlogPost {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageURL;
  final String? deeplink; // Adding deepLink as an optional String

  BlogPost({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageURL,
    this.deeplink, // Allowing deepLink to be optional
  });

  // To create a BlogPost from Firestore document data
  factory BlogPost.fromFirestore(Map<String, dynamic> data,
      {required String id}) {
    return BlogPost(
      id: id, // To pass the 'id' as a named argument
      title: data['title'] ??
          '', // To assign a default value if 'title' is not found
      summary: data['summary'] ??
          '', // To assign a default value if 'summary' is not found
      content: data['content'] ??
          '', // To assign a default value if 'content' is not found
      imageURL: data['imageURL'] ??
          '', // To assign a default value if 'imageURL' is not found
      deeplink: data['deeplink'], // Assign the 'deepLink' if available
    );
  }
}
