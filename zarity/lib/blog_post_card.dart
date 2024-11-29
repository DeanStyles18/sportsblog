// blog_post_card.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'blog_post.dart';
import 'blog_detail_page.dart';

class BlogPostCard extends StatelessWidget {
  final BlogPost post;
  final bool isShimmerActive;

  const BlogPostCard({
    super.key,
    required this.post,
    required this.isShimmerActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showZoomedInPost(context,
            post); // To show a zoomed-in view of the post when long pressed
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: isShimmerActive
                  ? Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 200, 229, 243),
                      highlightColor: const Color.fromARGB(255, 255, 255, 255),
                      child: Image.network(
                        post.imageURL,
                        height: 220,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Image.network(
                      post.imageURL,
                      height: 220,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Text(
                      post.summary,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetailPage(
                                postId: post
                                    .id), // To navigate to the blog detail page
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Read More',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // To display a zoomed-in view of the blog post image and summary
  void _showZoomedInPost(BuildContext context, BlogPost post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  post.imageURL,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      post.summary,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
