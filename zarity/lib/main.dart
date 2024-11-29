import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'blog_detail_page.dart';
import 'firebase_service.dart';
import 'blog_provider.dart';

// GlobalKey for managing app navigation.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeDeepLinkHandling();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _initializeDeepLinkHandling(); // Handle deep links on app resume.
    }
  }

  /// Initializes deep link handling for both cold start and runtime scenarios.
  Future<void> _initializeDeepLinkHandling() async {
    const platform = MethodChannel('com.example.deepLink');
    try {
      // Handle the initial link if the app starts from a deep link.
      final String? initialLink = await platform.invokeMethod('getInitialLink');
      if (initialLink != null) {
        _processDeepLink(initialLink);
      }

      // Listen for new deep links arriving while the app is running.
      platform.setMethodCallHandler((MethodCall call) async {
        if (call.method == 'onLink') {
          final String link = call.arguments as String;
          _processDeepLink(link);
        }
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to handle deep link: $e');
    }
  }

  /// Extracts the post ID from a deep link and navigates to the correct page.
  void _processDeepLink(String link) {
    final String? postId = _extractPostIdFromLink(link);
    if (postId != null) {
      _navigateToBlogDetailPage(postId);
    } else {
      debugPrint('Invalid deep link format: $link');
    }
  }

  /// Extracts the post ID from a deep link URL.
  String? _extractPostIdFromLink(String link) {
    try {
      final Uri uri = Uri.parse(link);
      // Ensure the deep link matches the expected structure.
      if (uri.host == 'zarity.page.link' && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.length > 1 ? uri.pathSegments.last : null;
      }
    } catch (e) {
      debugPrint('Error parsing link: $link, Error: $e');
    }
    return null; // Return null if the URL is invalid.
  }

  /// Navigates to the BlogDetailPage if not already there.
  void _navigateToBlogDetailPage(String postId) {
    final currentRoute = ModalRoute.of(navigatorKey.currentContext!);
    if (currentRoute?.settings.name != '/blogDetail_$postId') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => BlogDetailPage(postId: postId),
          settings: RouteSettings(name: '/blogDetail_$postId'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlogProvider(FirebaseService()),
      child: MaterialApp(
        title: 'Blog App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: const HomePage(),
      ),
    );
  }
}
