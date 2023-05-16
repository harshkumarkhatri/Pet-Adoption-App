import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_adoption_app/model/pet_model.dart';
import 'package:pet_adoption_app/request/pets_data.dart';

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('PetService', () {
    test('parseCoinData should throw an error when given an empty list', () {
      expect(parseCoinData([]), equals([]));
    });

    test(
        'parseCoinData should parse a list of QueryDocumentSnapshot into a list of PetModel',
        () {
      final pet1 = MockQueryDocumentSnapshot();
      final pet2 = MockQueryDocumentSnapshot();

      when(pet1.data()).thenReturn({'name': 'Fluffy', 'age': '2 months'});
      when(pet2.data()).thenReturn({
        'name': 'Max',
        'age': '4 months',
      });

      expect(
        parseCoinData([pet1, pet2]).length,
        equals([
          PetModel(name: 'Fluffy', age: "2 months"),
          PetModel(name: 'Max', age: "4 months"),
        ].length),
      );
    });
  });
}
