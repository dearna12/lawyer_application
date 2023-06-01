import 'package:flutter/material.dart';
// import 'package:flutter_laywer_app/constants.dart';
// import 'package:flutter_laywer_app/models/laywer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lawyers/models/lawyer.dart';
import 'package:lawyers/utils/constants.dart';

class TopLaywersCard extends StatelessWidget {
  const TopLaywersCard({Key? key, this.laywer}) : super(key: key);

  final Laywer? laywer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        color: Colors.transparent,
        height: 80,
        width: MediaQuery.of(context).size.width - 32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: laywer!.laywerPicture != "null"
                  ? 'assets/images/${laywer!.laywerPicture}'
                  : 'DefaultIcon',
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: laywer!.laywerPicture != "null"
                          ? AssetImage(
                              'assets/images/img-men-01.png',
                            )
                          : AssetImage(
                              'assets/images/default_avatar.jpg',
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: laywer!.laywerName,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        laywer!.laywerName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  Text(
                    '${laywer!.laywerSpecialty} • ${laywer!.laywerHospital}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 136,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: laywer!.laywerIsOpen
                                ? kGreenLightColor
                                : kRedLightColor,
                          ),
                          child: Text(
                            laywer!.laywerIsOpen ? 'Open' : 'Close',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontSize: 18,
                                      color: laywer!.laywerIsOpen
                                          ? kGreenColor
                                          : kRedColor,
                                    ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
