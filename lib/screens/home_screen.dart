import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adoption_app/model/pet_model.dart';
import 'package:pet_adoption_app/screens/details_screen.dart';
import 'package:pet_adoption_app/screens/history_screen.dart';
import 'package:pet_adoption_app/state/pet_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String searchText;
  late TextEditingController _controller;
  late bool showMiniFilter;
  String? miniFilter;
  AsyncValue<List<PetModel>>? localPetData;
  bool isEndReachedOnce = false;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    searchText = '';
    showMiniFilter = true;
    _controller = TextEditingController();
    controller.addListener(_scrollListener);
  }

  List<PetModel> localPetList = [];

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PetModel>> petData =
        ref.watch(coinStateFuture(isEndReachedOnce));
    localPetData = petData;
    if (searchText == "") {
      localPetList = petData.value ?? [];
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Adoption",
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.history,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white60,
        ),
        child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                if (showMiniFilter)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 52,
                      child: Row(
                        children: [
                          _buildMiniFilter(
                            "Dogs",
                            localPetData,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          _buildMiniFilter(
                            "Cats",
                            localPetData,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (searchText != '') {
                                searchText = '';
                                _controller.clear();
                              }
                              miniFilter = null;
                              localPetList = localPetData?.value ?? [];
                              showMiniFilter = false;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.search,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!showMiniFilter)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            // style: TextStyle(color: Colors.pinkAccent),
                            controller: _controller,
                            onChanged: (value) {
                              _controller.text = value;
                              setState(() {
                                searchText = value;
                              });
                              if (value == '') {
                                localPetList = localPetData?.value ?? [];
                                setState(() {});
                                return;
                              }
                              localPetList =
                                  localPetData?.value?.where((element) {
                                        if (element.name == null) return false;
                                        return element.name!
                                            .toLowerCase()
                                            .contains(searchText.toLowerCase());
                                      }).toList() ??
                                      [];
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.red,
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    // color: Colors.blue,
                                    ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    // color: Colors.blue,
                                    ),
                              ),
                              // filled: true,
                              contentPadding: const EdgeInsets.only(
                                bottom: 10.0,
                                left: 10.0,
                                right: 10.0,
                              ),
                              labelText: "Search",
                              suffixIcon: searchText != ''
                                  ? InkWell(
                                      onTap: () {
                                        localPetList =
                                            localPetData?.value ?? [];
                                        _controller.clear();
                                        searchText = '';
                                        setState(() {});
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            showMiniFilter = true;
                            searchText = '';
                            _controller.clear();
                            miniFilter = null;
                            localPetList = localPetData?.value ?? [];
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.tune,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final currentPet = localPetList[index];

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
                                            color: Colors.black,
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
                    itemCount: localPetList.length,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildMiniFilter(
    String label,
    AsyncValue<List<PetModel>>? petData,
  ) {
    return InkWell(
      onTap: () {
        miniFilter = label;
        searchText = label;
        localPetList = petData?.value?.where((element) {
              if (element.name == null) return false;
              return searchText
                  .toLowerCase()
                  .contains(element.type!.toLowerCase());
            }).toList() ??
            [];
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          border: miniFilter == label
              ? null
              : Border.all(
                  // color: Colors.blue,
                  ),
          color: miniFilter == label ? Colors.blue : null,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: miniFilter == label ? Colors.white : null,
              ),
            ),
            if (miniFilter == label) ...[
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () {
                  miniFilter = null;
                  searchText = '';
                  _controller.clear();
                  localPetList = petData?.value ?? [];
                  setState(() {});
                },
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      isEndReachedOnce = true;
      setState(() {});
    }
  }
}
