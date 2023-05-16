import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pet_adoption_app/model/pet_model.dart';
import 'package:pet_adoption_app/screens/widget/image_preview.dart';
import 'package:pet_adoption_app/state/pet_state.dart';

class NewDetailsScreen extends ConsumerStatefulWidget {
  const NewDetailsScreen({
    super.key,
    required this.index,
  });

  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewDetailsScreenState();
}

class _NewDetailsScreenState extends ConsumerState<NewDetailsScreen> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PetModel>> petData = ref.watch(coinStateFuture(false));
    final currentPetItem = petData.value?[widget.index];
    return Scaffold(
      body: Container(
        color: Colors.grey.shade100,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      _buildPetImage(currentPetItem),
                      _buildPetNameAndPrice(currentPetItem),
                    ],
                  ),
                  _buildConfettiWidget(),
                  _buildPropertySection(
                    currentPetItem,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  _buildOwnerSection(currentPetItem),
                  const SizedBox(
                    height: 28,
                  ),
                  _buildDescription(currentPetItem),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
            _buildBackButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(currentPetItem),
    );
  }

  Widget _buildPetNameAndPrice(PetModel? currentPetItem) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            32,
          ),
          topRight: Radius.circular(
            32,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        top: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentPetItem?.name ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.currency_rupee,
                size: 16,
                color: Colors.black,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                currentPetItem?.price == null
                    ? '0'
                    : currentPetItem?.price.toString() ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiWidget() {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _controllerCenter,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: true,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
        createParticlePath: drawStar,
      ),
    );
  }

  Widget _buildPropertySection(PetModel? currentPetItem) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 4),
        child: Row(
          children: [
            _buildProperty(
              "Sex",
              currentPetItem?.gender ?? '',
            ),
            _buildProperty(
              "Color",
              currentPetItem?.color ?? '',
            ),
            _buildProperty(
              "Age",
              currentPetItem?.age ?? '',
            ),
            _buildProperty(
              "Type",
              currentPetItem?.type ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetImage(PetModel? currentPetItem) {
    return InkWell(
      onTap: () {
        final image = Image.network(
          currentPetItem?.imageUrl ?? '',
        );

        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return ImagePreview(
              image: image,
              petName: currentPetItem?.name ?? '',
            );
          }),
        );
      },
      child: Hero(
        tag: "imageHero${widget.index}",
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                currentPetItem?.imageUrl ?? '',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProperty(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        height: 108,
        width: 108,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            16,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(
                0,
                5,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key,
              style: TextStyle(
                color: Colors.redAccent.withOpacity(.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: WidgetsBinding.instance.window.platformBrightness ==
                        Brightness.light
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerSection(PetModel? currentPetItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 84,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            12,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            _buildOwnerImage(currentPetItem),
            const SizedBox(
              width: 12,
            ),
            _buildOwnerLabel(currentPetItem),
            const Spacer(),
            _buildOwnerMessage(),
            const SizedBox(
              width: 12,
            ),
            _buildOwnerCall(),
            const SizedBox(
              width: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerImage(PetModel? currentPetItem) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            currentPetItem?.owner?.imageUrl ?? '',
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerLabel(PetModel? currentPetItem) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentPetItem?.owner?.name ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "Pet's Owner",
          style: TextStyle(
            color: WidgetsBinding.instance.window.platformBrightness ==
                    Brightness.light
                ? Colors.grey
                : Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerMessage() {
    return InkWell(
      onTap: () {
        const snackBar = SnackBar(
          content: Text('This will open messages'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(
                0,
                5,
              ),
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOwnerCall() {
    return InkWell(
      onTap: () {
        const snackBar = SnackBar(
          content: Text('This will open dialer'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(
                0,
                5,
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(
            12,
          ),
          // shape: BoxShape.circle,
          color: Colors.redAccent.withOpacity(.9),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.call,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Call",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16.0),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.7),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Icon(
              Icons.arrow_back_ios,
              size: 28,
              color: Colors.black.withOpacity(.8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(PetModel? currentPetItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          currentPetItem?.description ?? '',
          style: TextStyle(
            color: Colors.black.withOpacity(.7),
            letterSpacing: .5,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(PetModel? currentPetItem) {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          bottom: 8,
        ),
        child: InkWell(
          onTap: () {
            if (currentPetItem?.isAdopted ?? false) return;
            var collection =
                FirebaseFirestore.instance.collection('pets-to-adopt');

            collection
                .doc(currentPetItem?.name)
                .update({'is_adopted': true}).then((_) async {
              _controllerCenter.play();
              var box = await Hive.openBox('adopted_pets');
              List<dynamic> preExistingAdoptedPets = box.get("adopted_pets");
              preExistingAdoptedPets.add(currentPetItem?.toJson());

              box.put(
                "adopted_pets",
                preExistingAdoptedPets,
              );

              var _ = ref.refresh(coinStateFuture(false));
              if (mounted) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Pet Adopted🙌🏼'),
                    content: Text('${currentPetItem?.name} is now adopted'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          _controllerCenter.stop();
                        },
                        child: const Text('Okay'),
                      ),
                    ],
                  ),
                );
              }
            }).catchError((error) {
              _controllerCenter.stop();
              final snackBar = SnackBar(
                content: Text('Failed: $error'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          },
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12,
              ),
              color: currentPetItem?.isAdopted ?? false
                  ? Colors.grey
                  : Colors.redAccent.withOpacity(.9),
            ),
            alignment: Alignment.center,
            child: Text(
              currentPetItem?.isAdopted ?? false
                  ? "Already Adopted"
                  : "Adopt Me",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
