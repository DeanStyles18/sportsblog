import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'blog_post.dart';

class BlogProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;

  BlogProvider(this._firebaseService);

  List<BlogPost> _blogPosts = [];
  List<BlogPost> get blogPosts => _blogPosts;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Method to fetch blog posts from Firestore
  Future<void> fetchBlogPosts() async {
    _isLoading = true;
    notifyListeners(); // Notifying listeners to update UI
    try {
      _blogPosts = await _firebaseService.fetchBlogPosts();
    } catch (error) {
      print("Error fetching blog posts: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to fetch a single blog post by ID
  Future<void> fetchBlogPostDetails(String postId) async {
    _isLoading = true;
    notifyListeners(); // Notifying listeners to update UI
    try {} catch (error) {
      print("Error fetching blog post details: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
