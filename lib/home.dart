import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header at the top
            const Header(),
      
            // ListView for images
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: 10, // Total number of images
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Scroll to the next image when tapped
                      if (index < 9) {  // Updated condition
                        _scrollController.animateTo(
                          (index + 1) * MediaQuery.of(context).size.height,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: BackgroundImage(imagePath: 'assets/images/image${index + 1}.jpg'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final String imagePath;

  const BackgroundImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.of(context).size.height, // Full height for each image
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),  // Rounded corners for a modern look
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,  // Ensures the image fits the container size
        ),
      ),
    );
  }
}


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.only( top: 20,bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            child: Image.asset(
              'assets/images/aab.jpg',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}


