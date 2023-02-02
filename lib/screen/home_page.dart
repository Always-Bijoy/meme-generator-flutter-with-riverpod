import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../riverpod_/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera),
          onPressed: () {
            provider.attachedImage(context);
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'meme \ngenerator'.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                RepaintBoundary(
                  key: provider.globalKey,
                  child: Stack(
                    children: [
                      provider.imagePath != null
                          ? Image.file(
                              provider.imagePath!,
                              fit: BoxFit.cover,
                              height: 250,
                              width: double.infinity,
                            )
                          : Container(
                              height: 270,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0),
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: ClipRRect(
                                child: Lottie.asset('assets/booring_doodle.json',
                                    height: 250, fit: BoxFit.fill),
                              ),
                            ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Center(child: Text(provider.onChangeText ?? '', style: TextStyle(
                          color: provider.currentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600
                        ),)),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Center(child: Text(provider.onBottomChangeText ?? '', style: TextStyle(
                            color: provider.currentColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                        ),)),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Visibility(
                          visible: provider.isColorPlatterVisibility,
                          replacement: const SizedBox(),
                          child: IconButton(
                            onPressed: () {
                              provider.colors(context);
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                                child: const Center(child: Icon(Icons.color_lens))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 18),
                    hintText: "Text Here",
                    // hintStyle: const TextStyle(color: AppColors.hintTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFEAEAEA),
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    provider.onValueChanged(value);
                  },
                ),
                const SizedBox(
                  height: 22.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 18),
                    hintText: "Bottom Text Here",
                    // hintStyle: const TextStyle(color: AppColors.hintTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFEAEAEA),
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    provider.onBottomValueChanged(value);
                  },
                ),
                const SizedBox(
                  height: 22.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                      onPressed: () {
                        if (provider.imagePath != null) {
                          provider.takeScreenshot();
                        } else {
                          Fluttertoast.showToast(msg: 'Select Image');
                        }
                      },
                      child: const Text('GENERATE')),
                ),
                provider.ssImage != null
                    ? Image.file(provider.ssImage!)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
