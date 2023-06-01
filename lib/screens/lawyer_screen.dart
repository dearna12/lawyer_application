import 'package:flutter/material.dart';
import 'package:lawyers/models/lawyer.dart';
import 'package:lawyers/utils/constants.dart';
// import 'package:flutter_laywer_app/constants.dart';
// import 'package:flutter_laywer_app/models/laywer.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LaywerDetailScreen extends StatelessWidget {
  Laywer lawyer;
  LaywerDetailScreen({Key? key, required this.lawyer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Laywer;

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.bookmark))
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              tag: lawyer.laywerPicture != 'null'
                  ? lawyer.laywerPicture
                  : 'assets/images/img.jpg',
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: kGreyColor600,
                  ),
                  child: lawyer.laywerPicture!= "null"?Image.network(lawyer.laywerPicture) :Image.asset('assets/images/default_avatar.jpg'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Layer Name:",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        Hero(
                          tag: lawyer.laywerName,
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              lawyer.laywerName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.black,fontWeight: FontWeight.w400,),
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lawyer Speciality:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '${lawyer.laywerSpecialty}',
                          style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w400,),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lawyer Hospital:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        VerticalDivider(
                          width: 20,
                        ),
                        Text(
                          '${lawyer.laywerHospital}',
                          style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w400,),
                        ),
                      ]),
                  const SizedBox(
                    height: 16,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Experience',
                        style:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            lawyer.laywerYearOfExperience,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'yr',
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kGreenColor,
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, lawyerMakeAppointment,arguments:lawyer);
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenColor)),
                      child: Text(
                        'Make an Appoinment',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: kWhiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
