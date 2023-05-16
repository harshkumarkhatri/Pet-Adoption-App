import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption_app/model/pet_model.dart';

List<DocumentSnapshot> petData = [];

List<PetModel> parseCoinData(List<DocumentSnapshot> responseBody) {
  List<PetModel> finalModel = [];
  for (var item in responseBody) {
    finalModel.add(
      PetModel.fromJson(
        json.decode(
          json.encode(
            item.data(),
          ),
        ),
      ),
    );
  }

  return finalModel;
}

Future<List<PetModel>> getPetsData() async {
  final response = await FirebaseFirestore.instance
      .collection('pets-to-adopt')
      .limit(10)
      .get();
  if (response.size > 0) {
    petData = response.docs;
    return parseCoinData(petData);
  } else if (response.size == 0) {
    return [];
  } else {
    throw Exception("Cannot fetch coin data");
  }
}

Future<List<PetModel>> getNextPetsData() async {
  final response = await FirebaseFirestore.instance
      .collection('pets-to-adopt')
      .startAfterDocument(petData[petData.length - 1])
      .limit(10)
      .get();
  if (response.size > 0) {
    petData.addAll(response.docs);
    return parseCoinData(petData);
  } else if (response.size == 0) {
    return [];
  } else {
    throw Exception("Cannot fetch coin data");
  }
}
