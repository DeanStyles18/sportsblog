import 'package:cloud_firestore/cloud_firestore.dart';
import 'blog_post.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // To fetch all blog posts from the Firestore collection
  Future<List<BlogPost>> fetchBlogPosts() async {
    QuerySnapshot snapshot = await _db.collection('Sportsblog').get();
    return snapshot.docs.map((doc) {
      // To create a BlogPost object from Firestore data and pass the document ID
      return BlogPost.fromFirestore(doc.data() as Map<String, dynamic>,
          id: doc.id);
    }).toList();
  }

  // To fetch a specific blog post by ID from Firestore
  Future<BlogPost> fetchBlogPostDetails(String postId) async {
    DocumentSnapshot snapshot =
        await _db.collection('Sportsblog').doc(postId).get();

    if (snapshot.exists) {
      // To create a BlogPost object from Firestore data and pass the document ID
      return BlogPost.fromFirestore(snapshot.data() as Map<String, dynamic>,
          id: snapshot.id);
    } else {
      throw Exception('Blog post not found');
    }
  }
}
