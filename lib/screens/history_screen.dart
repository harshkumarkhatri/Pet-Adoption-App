import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pet_adoption_app/model/pet_model.dart';
import 'package:pet_adoption_app/screens/details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PetModel> adoptedPets = [];

  @override
  void initState() {
    super.initState();
    getAdoptedPets();
  }

  getAdoptedPets() async {
    var box = await Hive.openBox('adopted_pets');
    final tempData = box.get("adopted_pets");
    if (tempData.isNotEmpty) {
      for (var item in tempData) {
        adoptedPets.add(PetModel.fromJson(item));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adopted",
        ),
      ),
      body: adoptedPets.isEmpty
          ? const Center(
              child: Text(
                "No pets adopted.",
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final currentPet = adoptedPets[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewDetailsScreen(
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: currentPet.isAdopted == true
                            ? Colors.grey.shade200
                            : Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Hero(
                            tag: "imageHero$index",
                            child: Container(
                              height: 128,
                              width: 128,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    currentPet.imageUrl ?? '',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentPet.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 14,
                                      color: Colors.yellow.shade700,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      currentPet.price.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.transgender,
                                      size: 14,
                                      color: currentPet.gender == "Male"
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      currentPet.gender ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      currentPet.age ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.color_lens_outlined,
                                      size: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      currentPet.color ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: adoptedPets.length,
              ),
            ),
    );
  }
}
