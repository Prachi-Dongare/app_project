import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_player_page.dart';

class CoursePage extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CoursePage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<Map<String, dynamic>> allVideos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAllVideos();
  }

  Future<void> loadAllVideos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        allVideos = [];
      });

      print('\n=== LOADING VIDEOS FOR: ${widget.courseId} ===');

      final courseDoc = FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId);

      List<Map<String, dynamic>> videos = [];

      // Try loading video1 through video20
      for (int i = 1; i <= 20; i++) {
        String collectionName = 'video$i';

        try {
          print('Trying to load: $collectionName');

          // Get the document inside the collection
          final docSnapshot = await courseDoc
              .collection(collectionName)
              .doc(collectionName)
              .get();

          if (docSnapshot.exists) {
            print('✓ Found $collectionName');
            final data = docSnapshot.data() as Map<String, dynamic>;

            // Add metadata
            data['collectionName'] = collectionName;
            data['documentId'] = collectionName;

            // Extract order (handle both 'order' and 'Order')
            final order = data['order'] ?? data['Order'] ?? i;
            data['_sortOrder'] = order;

            videos.add(data);

            print('  Title: ${data['title']}');
            print('  Order: $order');
            print('  Duration: ${data['duration'] ?? data['Duration']}');
          } else {
            print('✗ $collectionName does not exist');
          }
        } catch (e) {
          print('✗ Error loading $collectionName: $e');
          // Continue to next video
        }
      }

      // Sort by order
      videos.sort((a, b) {
        final orderA = a['_sortOrder'] as int;
        final orderB = b['_sortOrder'] as int;
        return orderA.compareTo(orderB);
      });

      print('\n=== SUMMARY ===');
      print('Total videos found: ${videos.length}');
      print('Videos: ${videos.map((v) => v['title']).join(', ')}');
      print('================\n');

      setState(() {
        allVideos = videos;
        isLoading = false;
      });
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          // Debug button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadAllVideos,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading videos...'),
          ],
        ),
      )
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Error loading videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadAllVideos,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      )
          : allVideos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined,
                size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No videos found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Course: ${widget.courseId}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadAllVideos,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Video count header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.video_library,
                    color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  '${allVideos.length} ${allVideos.length == 1 ? 'Video' : 'Videos'} Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          // Video list
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadAllVideos,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allVideos.length,
                itemBuilder: (context, index) {
                  final video = allVideos[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Get video URL (handle different casings)
                        final videoUrl = video['VideoUrl'] ??
                            video['videoUrl'] ??
                            video['videourl'] ??
                            '';

                        print('\n=== PLAYING VIDEO ===');
                        print('Title: ${video['title']}');
                        print('URL: $videoUrl');
                        print('==================\n');

                        if (videoUrl.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                              Text('Video URL not found'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerPage(
                                  videoUrl: videoUrl,
                                  videoTitle:
                                  video['title'] ?? 'Video',
                                  courseId: widget.courseId,
                                  videoId:
                                  video['documentId'] ?? 'video1',
                                ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Play Icon
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[400]!,
                                    Colors.blue[700]!
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius:
                                BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Video Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['title'] ?? 'Untitled',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        video['duration'] ??
                                            video['Duration'] ??
                                            '0 min',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius:
                                          BorderRadius
                                              .circular(4),
                                        ),
                                        child: Text(
                                          'Lesson ${video['_sortOrder']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.w500,
                                            color:
                                            Colors.blue[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Arrow Icon
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
