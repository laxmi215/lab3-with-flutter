/*
 * Pineapple Picture Frame Application
 * 
 * This Flutter app displays a digital picture frame with images from AWS S3.
 * Features include:
 * - Auto-rotation every 10 seconds
 * - Pause/Resume functionality
 * - Pineapple-themed decorative border
 * - Cross-platform support (Android, iOS, Web)
 * 
 * Author: Laxmi
 * Date: October 31, 2025
 */

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

/// Entry point of the application
void main() {
  runApp(const PineapplePictureFrameApp());
}

/// Root widget of the application
/// Sets up the MaterialApp with theme and initial route
class PineapplePictureFrameApp extends StatelessWidget {
  const PineapplePictureFrameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pineapple Picture Frame',
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Pineapple color theme
        useMaterial3: true, // Use Material Design 3
      ),
      home: const PictureFrameScreen(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

/// Main screen widget containing the picture frame
/// This is a StatefulWidget because it manages dynamic state (image rotation, pause state)
class PictureFrameScreen extends StatefulWidget {
  const PictureFrameScreen({super.key});

  @override
  State<PictureFrameScreen> createState() => _PictureFrameScreenState();
}

/// State class for PictureFrameScreen
/// Manages image rotation timer, current image index, and pause/resume functionality
class _PictureFrameScreenState extends State<PictureFrameScreen> {
  /// List of image URLs from AWS S3 bucket
  /// These images must be publicly accessible or have proper CORS configuration
  final List<String> imageUrls = [
    'https://pineapplepictures.s3.amazonaws.com/art.jpg',
    'https://pineapplepictures.s3.amazonaws.com/artwork.jpg',
    'https://pineapplepictures.s3.amazonaws.com/music.jpg',
    'https://pineapplepictures.s3.amazonaws.com/pineapple.jpg',
  ];

  /// Current image index being displayed (0-based)
  int currentImageIndex = 0;

  /// Timer that controls automatic image rotation
  /// Nullable because it may not be initialized yet or could be cancelled
  Timer? rotationTimer;

  /// Flag to track whether the slideshow is paused
  /// When true, timer continues running but images don't advance
  bool isPaused = false;

  /// Called when the widget is first created
  /// Initializes the auto-rotation timer
  @override
  void initState() {
    super.initState();
    startRotation(); // Begin automatic image rotation
  }

  /// Starts the periodic timer for automatic image rotation
  /// Timer fires every 10 seconds and advances to the next image
  /// Only advances if not paused (checked in the callback)
  void startRotation() {
    rotationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Only advance to next image if not paused
      if (!isPaused) {
        setState(() {
          // Use modulo to wrap around to first image after last image
          // Example: if at index 3 (last) and length is 4, (3+1) % 4 = 0
          currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
        });
      }
    });
  }

  /// Toggles the pause state of the slideshow
  /// When paused, the timer continues running but images don't change
  /// This is more efficient than stopping and restarting the timer
  void togglePause() {
    setState(() {
      isPaused = !isPaused; // Flip the pause state
    });
  }

  /// Called when the widget is removed from the widget tree
  /// Critical for preventing memory leaks by cancelling the timer
  @override
  void dispose() {
    rotationTimer
        ?.cancel(); // Cancel timer to prevent it running after disposal
    super.dispose();
  }

  /// Builds the UI for the picture frame screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark brown background matching the pineapple/tropical theme
      backgroundColor: const Color(0xFF2E1A0A),
      body: SafeArea(
        // SingleChildScrollView allows scrolling if content exceeds screen height
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Title with pineapple emojis and shadow effect
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '🍍 Pineapple Picture Frame 🍍',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700], // Golden yellow color
                      shadows: const [
                        // Orange shadow for depth and glow effect
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.orange,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Main picture frame container with triple-layer border design
                Container(
                  // Constrain maximum size to ensure controls are visible
                  constraints:
                      const BoxConstraints(maxWidth: 600, maxHeight: 450),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    // LAYER 1: Outer pineapple-themed gradient border
                    // Uses yellow and orange colors to create tropical look
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow[700]!,
                        Colors.orange[600]!,
                        Colors.yellow[600]!,
                        Colors.orange[700]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    // Drop shadow for 3D depth effect
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10), // Shadow below the frame
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.all(10), // Thickness of outer border
                  child: Container(
                    decoration: BoxDecoration(
                      // LAYER 2: Middle decorative wood-like border
                      color: const Color(0xFF8B4513), // Saddle brown color
                      borderRadius: BorderRadius.circular(12),
                      // Yellow accent border around the wood layer
                      border: Border.all(color: Colors.yellow[800]!, width: 2),
                    ),
                    padding:
                        const EdgeInsets.all(6), // Thickness of middle border
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // LAYER 3: Inner shadow for depth
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        // Clip image to rounded corners
                        borderRadius: BorderRadius.circular(8),
                        // Maintain 4:3 aspect ratio (standard photo frame ratio)
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          // CachedNetworkImage provides efficient image loading and caching
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[currentImageIndex],
                            fit: BoxFit
                                .cover, // Fill the frame while maintaining aspect ratio
                            // Placeholder shown while image is loading
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            // Error widget shown if image fails to load
                            // Common causes: wrong URL, S3 permissions, CORS issues
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[300],
                                    size: 64,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Unable to load image',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Check AWS S3 permissions',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Image counter showing current position (e.g., "Image 1 of 4")
                // Helps users know how many images are in the slideshow
                Text(
                  'Image ${currentImageIndex + 1} of ${imageUrls.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.yellow[200],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 15),

                // Pause/Resume button with icon that changes based on state
                ElevatedButton.icon(
                  onPressed: togglePause,
                  // Icon changes: play arrow when paused, pause icon when playing
                  icon:
                      Icon(isPaused ? Icons.play_arrow : Icons.pause, size: 24),
                  // Label changes: "Resume" when paused, "Pause" when playing
                  label: Text(
                    isPaused ? 'Resume' : 'Pause',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700], // Pineapple color
                    foregroundColor: const Color(0xFF2E1A0A), // Dark brown text
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded pill shape
                    ),
                    elevation: 8, // Button shadow
                    shadowColor: Colors.orange.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 20),

                // Status indicator only shown when paused
                // Uses conditional rendering (if statement in widget tree)
                if (isPaused)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[900]!.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⏸ Rotation Paused',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
