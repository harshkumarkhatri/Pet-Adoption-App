import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adoption_app/model/pet_model.dart';

void main() {
  group('PetModel conversion test suite 💼', () {
    test('fromJson() and toJson() should be compatible ⏱️', () {
      final petJson = <String, dynamic>{
        'name': 'Fluffy',
        'age': '2 years',
        'price': 100.0,
        'image_url': 'https://example.com/images/fluffy.jpg',
        'is_adopted': true,
        'gender': 'female',
        'type': 'cat',
        'color': 'white',
        'description': 'A cute fluffy cat',
        'owner': {
          'name': 'Alice',
          'image_url': 'https://example.com/images/alice.jpg'
        }
      };

      final pet = PetModel.fromJson(petJson);
      expect(pet.toJson(), equals(petJson));
      expect(pet.name, equals(petJson['name']));
    });
  });
}
