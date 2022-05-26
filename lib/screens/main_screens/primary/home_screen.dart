import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';

import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget tile(
      {required String label,
      void Function()? onTapLabel,
      required List<MediaItem> items,
      int maxCount = 10}) {
    if (items.length > maxCount) {
      items = items.sublist(maxCount);
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: onTapLabel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: AppConstants.textStyles.kAudioTitleTextStyle),
                ExtendedButton(icon: Icons.chevron_right),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Row(
              children: items.map((e) {
                if (e.artUri != null) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(-2, 2),
                              blurRadius: 3.0,
                            ),
                          ]),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.file(
                          File(e.artUri!.path),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VerticalScroll(
      screenSize: MediaQuery.of(context).size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(),
              tile(
                label: 'Local',
                onTapLabel: () {
                  Provider.of<ScreenStateTracker>(context, listen: false)
                      .setScreenIndex = 1;
                },
                items: Provider.of<AudioHandlerAdmin>(context)
                    .getCurrentPlaylistMediaItems,
                maxCount: 10,
              ),
            ],
          ),
          Provider.of<ScreenStateTracker>(context).getAudioPlayerMini
        ],
      ),
    );
  }
}
