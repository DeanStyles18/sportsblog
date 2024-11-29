import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'blog_post.dart';
import 'blog_post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<BlogPost>> _blogPosts;
  final TextEditingController _searchController = TextEditingController();
  List<BlogPost> _filteredBlogPosts = [];
  List<BlogPost> _originalBlogPosts = [];
  bool _isSearching = false;
  bool _isShimmerActive = true;

  @override
  void initState() {
    super.initState();
    // Fetching blog posts from Firebase when the page is initialized
    _blogPosts = _firebaseService.fetchBlogPosts();

    // Stopping the shimmer effect after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isShimmerActive = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<BlogPost>>(
        future: _blogPosts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Display an error message if fetching fails
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            // Show a loading image if data hasn't been loaded yet
            return Container(
              color: Color(0xff0F2940),
              child: Center(
                child: Image.asset(
                  'assets/image.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }

          List<BlogPost> blogPosts = snapshot.data!;

          // Store the original list of blog posts when they are first fetched
          if (_originalBlogPosts.isEmpty) {
            _originalBlogPosts = blogPosts;
            _filteredBlogPosts = blogPosts;
          }

          // Determine which list of blog posts to display based on search state
          List<BlogPost> displayPosts =
              _isSearching ? _filteredBlogPosts : blogPosts;

          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  color: const Color(0xff0F2940),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 22,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                  if (!_isSearching) {
                                    
                                    _searchController.clear();
                                    _filteredBlogPosts = _originalBlogPosts;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isSearching)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (query) {
                            setState(() {
                              // Filter blog posts based on the search query
                              _filterBlogPosts(query);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search by title...',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 40.0, bottom: 30.0),
                      child: Text(
                        "Blog\nPosts",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildRows(displayPosts),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildRows(List<BlogPost> blogPosts) {
    List<Widget> rows = [];
    int totalPosts = blogPosts.length;

    for (int i = 0; i < totalPosts; i++) {
      if ((i + 1) % 5 == 0) {
        
        rows.add(
          Row(
            children: [
              Expanded(
                  child: BlogPostCard(
                      post: blogPosts[i], isShimmerActive: _isShimmerActive)),
            ],
          ),
        );
        rows.add(SizedBox(height: 20));
      } else {
        // Add two blog posts side by side in a row
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: BlogPostCard(
                    post: blogPosts[i], isShimmerActive: _isShimmerActive),
              ),
              const SizedBox(width: 10),
              if (i + 1 < totalPosts)
                Expanded(
                  flex: 1,
                  child: BlogPostCard(
                      post: blogPosts[i + 1],
                      isShimmerActive: _isShimmerActive),
                ),
            ],
          ),
        );
        rows.add(SizedBox(height: 20));
        i++; 
      }
    }
    return rows;
  }

  void _filterBlogPosts(String query) {
    setState(() {
      if (query.length >= 3) {
        // Filter posts if the search query is at least 3 characters long
        _filteredBlogPosts = _originalBlogPosts
            .where((post) =>
                post.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        // Reset filtered posts if the query is shorter than 3 characters
        _filteredBlogPosts = _originalBlogPosts;
      }
    });
  }
}
