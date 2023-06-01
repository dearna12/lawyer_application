import 'package:cloud_firestore/cloud_firestore.dart';

class Laywer {
  Laywer(
      {this.laywerName = '',
      this.laywerSpecialty = '',
      this.laywerRating = '',
      this.laywerHospital = '',
      this.laywerNumberOfPatient = '',
      this.laywerYearOfExperience = '',
      this.laywerDescription = '',
      this.laywerPicture = '',
      this.laywerIsOpen = false});

  String laywerName;
  String laywerSpecialty;
  String laywerRating;
  String laywerHospital;
  String laywerNumberOfPatient;
  String laywerYearOfExperience;
  String laywerDescription;
  String laywerPicture;
  String uid = "DrOSyPFCZhQyqJQCobEBaEvIkXI2";
  bool laywerIsOpen;

  //convert all lawyer request of the firestore to data type lawayer
  Laywer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : laywerName = snapshot.data()?["laywerName"],
        laywerSpecialty = snapshot.data()?["laywerSpecialty"],
        laywerRating = snapshot.data()?["laywerRating"],
        laywerHospital = snapshot.data()?["laywerHospital"],
        laywerNumberOfPatient = snapshot.data()?["laywerNumberOfPatient"],
        laywerYearOfExperience = snapshot.data()?["laywerYearOfExperience"],
        laywerDescription = snapshot.data()?["laywerDescription"],
        laywerPicture = snapshot.data()?["laywerPicture"],
        laywerIsOpen = snapshot.data()?["laywerIsOpen"];

  Map<String, dynamic> toFirestore() {
    return {
      if (laywerName != null) "laywerName": laywerName,
      if (laywerSpecialty != null) "laywerSpecialty": laywerSpecialty,
      if (laywerRating != null) "laywerRating": laywerRating,
      if (laywerHospital != null)
        "laywerHospital": laywerHospital,
      if (laywerNumberOfPatient != null) "laywerNumberOfPatient": laywerNumberOfPatient,
      if (laywerYearOfExperience != null) "laywerYearOfExperience": laywerYearOfExperience,
      if (laywerDescription != null) "laywerDescription": laywerDescription,
      if (laywerPicture != null) "laywerPicture": laywerPicture,
      if (laywerIsOpen != null) "laywerIsOpen": laywerIsOpen,
    };
  }
}

var topLaywers = [
  Laywer(
      laywerName: 'dr. Gilang Segara Bening',
      laywerSpecialty: 'Heart',
      laywerRating: '4.8',
      laywerHospital: 'Persahabatan Hospital',
      laywerNumberOfPatient: '1221',
      laywerYearOfExperience: '3',
      laywerDescription:
          'is one of the best laywers in the Persahabat Hospital. He has saved more than 1000 patients in the past 3 years. He has also received many awards from domestic and abroad as the best laywers. He is available on a private or schedule.',
      laywerPicture: 'img-men-01.png',
      laywerIsOpen: true),
  Laywer(
      laywerName: 'dr. Shabil Chan',
      laywerSpecialty: 'Dental',
      laywerRating: '4.7',
      laywerHospital: 'Columbia Asia Hospital',
      laywerNumberOfPatient: '964',
      laywerYearOfExperience: '4',
      laywerDescription:
          'is one of the best laywers in the Columbia Asia Hospital. He has saved more than 900 patients in the past 4 years. He has also received many awards from domestic and abroad as the best laywers. He is available on a private or schedule.',
      laywerPicture: 'img-women-01.png',
      laywerIsOpen: false),
  Laywer(
      laywerName: 'dr. Mustakim',
      laywerSpecialty: 'Eye',
      laywerRating: '4.9',
      laywerHospital: 'Salemba Carolus Hospital',
      laywerNumberOfPatient: '762',
      laywerYearOfExperience: '5',
      laywerDescription:
          'is one of the best laywers in the Salemba Carolus Hospital. He has saved more than 700 patients in the past 5 years. He has also received many awards from domestic and abroad as the best laywers. He is available on a private or schedule.',
      laywerPicture: 'img-men-02.png',
      laywerIsOpen: true),
  Laywer(
      laywerName: 'dr. Suprihatini',
      laywerSpecialty: 'Heart',
      laywerRating: '4.8',
      laywerHospital: 'Salemba Carolus Hospital',
      laywerNumberOfPatient: '1451',
      laywerYearOfExperience: '6',
      laywerDescription:
          'is one of the best laywers in the Salemba Carolus Hospital. He has saved more than 1400 patients in the past 6 years. He has also received many awards from domestic and abroad as the best laywers. He is available on a private or schedule.',
      laywerPicture: 'img-women-02.png',
      laywerIsOpen: false),
  Laywer(
      laywerName: 'dr. Robert Posy',
      laywerSpecialty: 'Child',
      laywerRating: '4.6',
      laywerHospital: 'Kariadi Hospital',
      laywerNumberOfPatient: '551',
      laywerYearOfExperience: '3',
      laywerDescription:
          'is one of the best laywers in the Kariadi Carolus Hospital. He has saved more than 500 patients in the past 3 years. He has also received many awards from domestic and abroad as the best laywers. He is available on a private or schedule.',
      laywerPicture: 'img-men-03.png',
      laywerIsOpen: true),
  Laywer(
      laywerName: 'dr. Matilde Hani',
      laywerSpecialty: 'Heart',
      laywerRating: '4.7',
      laywerHospital: 'Wiloso Hospital',
      laywerNumberOfPatient: '888',
      laywerYearOfExperience: '4',
      laywerDescription:
          'is one of the best laywers in the Wiloso Hospital. He has saved more than 800 patients in the past 4 years. He has also received many awards from domestic and abroad as the best laywers. He is available on a private or schedule.',
      laywerPicture: 'img-women-03.png',
      laywerIsOpen: true),
];

class LaywerMenu {
  String name;
  String image;

  LaywerMenu({this.name = '', this.image = ''});
}

var laywerMenu = [
  LaywerMenu(name: 'Consultation', image: 'img-consultation.svg'),
  LaywerMenu(name: 'Dental', image: 'img-dental.svg'),
  LaywerMenu(name: 'Heart', image: 'img-heart.svg'),
  LaywerMenu(name: 'Hospitals', image: 'img-hospital.svg'),
  LaywerMenu(name: 'Medicines', image: 'img-medicine.svg'),
  LaywerMenu(name: 'Physician', image: 'img-physician.svg'),
  LaywerMenu(name: 'Skin', image: 'img-skin.svg'),
  LaywerMenu(name: 'Surgeon', image: 'img-surgeon.svg'),
];
