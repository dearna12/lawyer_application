import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const loginRoute = "/login";
const registerRoute = "/register";
const homeRoute = "/dashboard";
const landingRoute = "/home";
const appointmentsRoute = "/appointments";
const lawyerRegisterRoute = "/lawyer-register";
const profileRoute = "/profile";
const lawyersRoute = "/laywers";
const lawyersDetailsRoute = "/laywer_details";
const lawyerMakeAppointment = "/makeappointment";

// Color constant
const kBlueColor = Color(0xFF4485FD);
const kGreenColor = Color(0xFF00CC6A);
const kGreenLightColor = Color(0xffCCF5E1);
const kRedColor = Color(0xffCC4900);
const kRedLightColor = Color(0xffF7E4D9);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor900 = Color(0xFF25282B);
const kBlackColor800 = Color(0xFF404345);
const kGreyColor900 = Color(0xFFA0A4A8);
const kGreyColor800 = Color(0xFFAAAAAA);
const kGreyColor700 = Color(0xFFC4C4C4);
const kGreyColor600 = Color(0xFFEAEAEA);
const kGreyColor500 = Color(0xFFF6F6F6);
const kGreyColor400 = Color(0x50CACCCF);
const kYellowColor = Color(0xFFFFE848);

List<String> categories = [
  'Estate Planning',
  'Criminal Cases',
  'Certifying Certificates',
  'Employment',
];
List<IconData> icons_list = [
  Icons.real_estate_agent,
  Icons.personal_injury,
  MdiIcons.certificateOutline,
  Icons.work,
];
