import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilecomputing_project/user_detail.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Total number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Categories',style: TextStyle(fontWeight: FontWeight.bold),),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,

            tabs: [
              Tab(icon: SizedBox.shrink(), text: 'Casual'),
              Tab(icon: SizedBox.shrink(), text: 'Events'),
              Tab(icon: SizedBox.shrink(), text: 'Prayer'),
              Tab(icon: SizedBox.shrink(), text: 'Kaftan'),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TabBarView(
            children: [
              CategoryPage(categoryName: 'Casual'),
              CategoryPage(categoryName: 'Events'),
              CategoryPage(categoryName: 'Prayer'),
              CategoryPage(categoryName: 'Kaftan'),
            ],
          ),
        ),
      ),
    );
  }
}


class CategoryPage extends StatelessWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(categoryName) // Use dynamic category name
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No items found."));
          }

          final items = snapshot.data!.docs;

          return GridView.builder(
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return HeartImageCard(
                imageUrl: item['imageUrl'],
                imageName: item['fileName'],
                description: item['description'],
                category: categoryName, // Pass category name
              );
            },
          );
        },
      ),
    );
  }
}

class HeartImageCard extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final String description;
  final String category;

  const HeartImageCard({
    super.key,
    required this.imageUrl,
    required this.imageName,
    required this.description,
    required this.category,
  });

  @override
  HeartImageCardState createState() => HeartImageCardState();
}

class HeartImageCardState extends State<HeartImageCard> {
  Future<void> _toggleLikeStatus() async {
    final userId = UserDetails().userId;
    final docRef = FirebaseFirestore.instance
        .collection('favourites')
        .doc(userId)
        .collection('items')
        .doc(widget.imageName);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
      } else {
        await docRef.set({
          'imageUrl': widget.imageUrl,
          'imageName': widget.imageName,
          'description': widget.description,
          'category': widget.category,
          'likedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error toggling like status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = UserDetails().userId;

    return GestureDetector(
      onTap: () {
        _navigateToDetailPage(
          context,
          widget.imageUrl,
          widget.description,
        );
      },
      child: Stack(
        children: [
          // Image Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Heart Icon
          Positioned(
            top: 10,
            right: 10,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('favourites')
                  .doc(userId)
                  .collection('items')
                  .doc(widget.imageName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  );
                }

                final isLiked = snapshot.data?.exists ?? false;

                return GestureDetector(
                  onTap: _toggleLikeStatus,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.pink : Colors.white,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailPage(
      BuildContext context,
      String imageUrl,
      String description,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailPage(
          imageUrl: imageUrl,
          description: description,
        ),
      ),
    );
  }
}


class ImageDetailPage extends StatelessWidget {
  final String imageUrl;
  final String description;

  const ImageDetailPage({
    super.key,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Details')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

        ],
      ),
    );
  }
}