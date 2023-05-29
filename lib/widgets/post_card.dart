import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {Key? key,
      required title,
      required location,
      required imageUrl,
      required category})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

void onRatingUpdate(double rating) {
  debugPrint("rating value is $rating");
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/PostDetailsScreen");
      },
      // borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxWidth: 260,
            maxHeight: 325,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400, width: 2.0),
          ),
          child: Column(children: [
            const Placeholder(
              fallbackHeight: 235,
              fallbackWidth: 256,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'National Museum',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.pin_drop),
                          Text('Cairo'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  RatingBar.builder(
                    itemBuilder: (context, _) {
                      return Icon(Icons.star, color: Colors.yellow.shade700);
                    },
                    onRatingUpdate: onRatingUpdate,
                    itemSize: 18,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
