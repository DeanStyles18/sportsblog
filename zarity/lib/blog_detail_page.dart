import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import to use Clipboard
import 'firebase_service.dart';
import 'blog_post.dart';

class BlogDetailPage extends StatefulWidget {
  final String postId;

  const BlogDetailPage({super.key, required this.postId});

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<BlogPost> _post;

  @override
  void initState() {
    super.initState();
    _post = _firebaseService.fetchBlogPostDetails(
        widget.postId); // To fetch the blog post details on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<BlogPost>(
        future: _post,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // To show a loading indicator while fetching data
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Error: ${snapshot.error}'), // To handle errors during data fetching
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                  'Blog post not found'), // To show an error message if no data is found
            );
          }

          BlogPost post = snapshot.data!;

          return Stack(
            children: [
              // Background Image
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: Image.network(
                  post.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              buttonArrow(context),
              // Scrollable Content
              scroll(context, post),
            ],
          );
        },
      ),
    );
  }

  // To create a back button with a blur effect
  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // To navigate back to the previous page
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10), // To apply a blur effect on the background
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // To create a scrollable section for displaying the blog post details
  scroll(BuildContext context, BlogPost post) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1.0,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Color(0xff0F2940),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title container with a background color
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        43, 75, 113, 1), // rgba(43, 75, 113, 255)
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 20),

                // Content container with a background color
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        43, 75, 113, 1), // rgba(43, 75, 113, 255)
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Deep link box at the bottom
                // Inside the scroll() method where the deep link box is created:
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(43, 75, 113, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // To space out the deep link and button
                    children: [
                      // Deep link text
                      Expanded(
                        child: Text(
                          post.deeplink ?? 'No deep link available',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // To handle long deep links
                          maxLines: 1, // Ensure it stays in one line
                        ),
                      ),

                      // Copy Button
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                                text:
                                    post.deeplink ?? 'No deep link available'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Link copied to clipboard')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                              0xff0F2940), // Black background for the button
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical:
                                  10), // Add padding to make the button rectangular
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                4), // Slight rounding for rectangle
                          ),
                        ),
                        child: const Text(
                          'Copy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
