import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adoption_app/model/pet_model.dart';
import 'package:pet_adoption_app/request/pets_data.dart';

final coinStateFuture = FutureProvider.family<List<PetModel>, bool>(
  (ref, fetchNext) async {
    final data = fetchNext ? await getNextPetsData() : await getPetsData();
    return data;
  },
);
