import 'package:flutter/material.dart';
// import 'package:flutter_laywer_app/models/laywer.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:lawyers/models/lawyer.dart';
import 'package:lawyers/screens/lawyers_screen.dart';
import 'package:lawyers/utils/constants.dart';

class LaywerAppGridMenu extends StatelessWidget {
  const LaywerAppGridMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LawyersScreen(category: categories[index]);
            }));
          },
          child: Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  child: Icon(
                    icons_list[index],
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.pink,
                      Colors.pink.shade300,
                      //add more colors
                    ]),
                    borderRadius: BorderRadius.circular(12),
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,

                    //   // image:
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  categories[index],
                  textAlign: TextAlign.center,
                  // laywerMenu[index].name,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
