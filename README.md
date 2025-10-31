# 🍍 Pineapple Picture Frame

A Flutter digital picture frame application that displays images from AWS S3 storage with automatic rotation and a beautiful pineapple-themed border.

## Author Contributions

This application was designed and implemented with the following key contributions:

### Design & Architecture

- **Custom Pineapple Theme**: Created a unique triple-layer border design using gradient colors (yellow/orange) to reflect a tropical pineapple aesthetic with a wood-like frame
- **Responsive Layout**: Implemented a scrollable, centered layout with size constraints (max 600x450px) to ensure the entire interface, including controls, is visible on various screen sizes
- **State Management**: Designed a clean stateful widget architecture to manage image rotation, pause/resume functionality, and UI updates

### Core Features Implementation

- **Auto-Rotation Timer**: Implemented a `Timer.periodic` mechanism that automatically cycles through images every 10 seconds, with proper state checking to respect pause state
- **Pause/Resume Control**: Developed toggle functionality that allows users to pause and resume the slideshow while maintaining timer efficiency
- **AWS S3 Integration**: Configured direct image loading from S3 bucket using proper URL formatting and CORS setup
- **Image Caching**: Integrated `cached_network_image` package for efficient network image loading with placeholder and error handling
- **Error Handling**: Implemented comprehensive error widgets with user-friendly messages for failed image loads

### UI/UX Design

- **Visual Hierarchy**: Designed clear visual flow with title, image frame, counter, and controls properly spaced
- **Accessibility**: Added image counter showing current position (e.g., "Image 1 of 4") for better user awareness
- **Status Indicators**: Created visual feedback with a "Rotation Paused" indicator when slideshow is paused
- **Shadow Effects**: Applied multi-layer shadows for depth and 3D frame effect

### Code Quality

- **Comprehensive Comments**: Added detailed inline comments explaining timer logic, state management, and UI structure (see code below)
- **Clean Code Structure**: Organized code with clear separation of concerns, proper disposal of resources, and lifecycle management
- **Cross-Platform Support**: Ensured compatibility across Android, iOS, and Web platforms

## Features

- 🖼️ **Digital Picture Frame**: Displays images with a decorative pineapple-themed border
- 🔄 **Auto-Rotation**: Automatically cycles through images every 10 seconds
- ⏯️ **Pause/Resume**: Control the image rotation with a pause/resume button
- 📱 **Cross-Platform**: Works on both Android and iOS devices
- ☁️ **AWS S3 Integration**: Loads high-resolution images directly from AWS S3
- 🎨 **Custom Border**: Unique pineapple-themed gradient border with wood-like frame

## Screenshots

The app features a warm pineapple-themed design with:

- Golden/orange gradient outer border
- Wood-like inner frame
- 4:3 aspect ratio display area
- Image counter
- Pause/Resume control button

## Images

The app displays 4 images from AWS S3:

- `s3://pineapplepictures/art.jpg`
- `s3://pineapplepictures/artwork.jpg`
- `s3://pineapplepictures/music.jpg`
- `s3://pineapplepictures/pineapple.jpg`

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode for mobile development
- AWS S3 bucket with public read access for images

## AWS S3 Setup

### 1. Create S3 Bucket

1. Log in to AWS Console
2. Navigate to S3
3. Create a bucket named `pineapplepictures` (or your preferred name)

### 2. Upload Images

Upload your 4 JPG images:

- art.jpg
- artwork.jpg
- music.jpg
- pineapple.jpg

### 3. Configure Bucket Permissions

**Option A: Make Bucket Public (Simple, but less secure)**

Add this bucket policy (replace with your bucket name):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::pineapplepictures/*"
    }
  ]
}
```

**Option B: Use CloudFront (Recommended)**

1. Create a CloudFront distribution for your S3 bucket
2. Update the image URLs in `lib/main.dart` to use your CloudFront domain
3. This provides better performance and security

### 4. Update Image URLs

If your bucket name is different, update the URLs in `lib/main.dart`:

```dart
final List<String> imageUrls = [
  'https://YOUR-BUCKET-NAME.s3.amazonaws.com/art.jpg',
  'https://YOUR-BUCKET-NAME.s3.amazonaws.com/artwork.jpg',
  'https://YOUR-BUCKET-NAME.s3.amazonaws.com/music.jpg',
  'https://YOUR-BUCKET-NAME.s3.amazonaws.com/pineapple.jpg',
];
```

Or use your region-specific endpoint:

```
https://YOUR-BUCKET-NAME.s3.YOUR-REGION.amazonaws.com/image.jpg
```

## Installation

1. **Clone or navigate to the project directory**

   ```bash
   cd c:\Users\laxmi\OneDrive\Desktop\lab3
   ```

2. **Install Flutter dependencies**

   ```bash
   flutter pub get
   ```

3. **Run on Android**

   ```bash
   flutter run
   ```

4. **Run on iOS** (requires macOS)

   ```bash
   flutter run
   ```

5. **Build for Release**

   Android:

   ```bash
   flutter build apk --release
   ```

   iOS:

   ```bash
   flutter build ios --release
   ```

## Android Configuration

Add internet permission to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application>
        ...
    </application>
</manifest>
```

## iOS Configuration

Add the following to `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## How It Works

1. **Auto-Rotation**: A `Timer.periodic` runs every 10 seconds to advance to the next image
2. **Pause/Resume**: The timer continues running but only advances images when not paused
3. **Image Loading**: Uses `cached_network_image` package for efficient loading and caching
4. **Border Design**: Multiple nested containers create the pineapple-themed frame effect

## Customization

### Change Rotation Speed

Edit the duration in `lib/main.dart`:

```dart
rotationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
  // Change seconds to your preferred interval
```

### Modify Border Colors

Update the gradient colors:

```dart
gradient: LinearGradient(
  colors: [
    Colors.yellow[700]!,
    Colors.orange[600]!,
    // Add your custom colors
  ],
```

### Add More Images

Simply add more URLs to the `imageUrls` list:

```dart
final List<String> imageUrls = [
  'https://...',
  'https://...',
  // Add more image URLs
];
```

## Troubleshooting

### Images Not Loading

- Verify S3 bucket permissions (must allow public read)
- Check image URLs are correct
- Ensure internet connectivity
- Verify CORS settings on S3 bucket if needed

### CORS Configuration for S3

If needed, add this CORS policy to your S3 bucket:

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": []
  }
]
```

## Dependencies

- `flutter`: SDK
- `cached_network_image`: ^3.3.0 - Efficient image loading and caching
- `amazon_s3_cognito`: ^0.5.0 - AWS S3 support
- `http`: ^1.1.0 - HTTP requests

## License

This project is created for educational purposes.

## Notes

- Images are cached for better performance
- High-resolution images are automatically scaled to fit the display
- The app maintains a 4:3 aspect ratio for the picture frame
- Pineapple theme includes yellow/orange gradients and tropical vibes 🍍

# lab3-with-flutter
"# lab3-with-flutter" 
