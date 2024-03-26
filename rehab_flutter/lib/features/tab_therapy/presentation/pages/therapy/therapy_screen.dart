import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/continue_card.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/music_therapy/music_therapy.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/specific_genre/specific_genre.dart';
import 'package:rehab_flutter/injection_container.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  Widget buildTherapyScreenHome() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserDone) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContinueCard(user: state.currentUser!),
                AppButton(
                  onPressed: () => _onPassiveTherapyButtonPressed(context),
                  child: const Text('Passive Therapy'),
                ),
                AppButton(
                  onPressed: () => _onMTButtonPressed(),
                  child: const Text('Music Therapy'),
                ),
                AppButton(
                  onPressed: () => _onCTButtonPressed(),
                  child: const Text('Cutaneous Therapy'),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget getScreenFromTabTherapy(TabTherapyEnum currentTabTherapy) {
    switch (currentTabTherapy) {
      case TabTherapyEnum.home:
        return buildTherapyScreenHome();
      case TabTherapyEnum.music:
        return const MusicTherapyScreen();
      case TabTherapyEnum.specificGenre:
        return const SpecificGenre();
      default:
        return buildTherapyScreenHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<NavigationController>(
      builder: (context) {
        final currentTabTherapy = sl<NavigationController>().getTherapyTab();
        return getScreenFromTabTherapy(currentTabTherapy);
      },
    );
  }

  void _onMTButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Music Therapy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _onBasicMTButtonPressed(context),
                child: const Text("Basic"),
              ),
              ElevatedButton(
                onPressed: () => _onIntermediateMTButtonPressed(context),
                child: const Text("Intermediate"),
              ),
              ElevatedButton(
                onPressed: () => _onBackButtonPressed(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPassiveTherapyButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PassiveTherapy');
  }

  void _onBasicMTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    sl<SongController>().setMTType(MusicTherapy.basic);
    sl<SongController>().setSong(null);
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
  }

  void _onIntermediateMTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    sl<SongController>().setMTType(MusicTherapy.intermediate);
    sl<SongController>().setSong(null);
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
  }

  void _onCTButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cutaneous Therapy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _onATButtonPressed(context),
                child: const Text('Actuator Therapy'),
              ),
              ElevatedButton(
                onPressed: () => _onPTButtonPressed(context),
                child: const Text('Pattern Therapy'),
              ),
              ElevatedButton(
                onPressed: () => _onTTButtonPressed(context),
                child: const Text('Texture Therapy'),
              ),
              ElevatedButton(
                onPressed: () => _onBackButtonPressed(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onATButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/ActuatorTherapy');
  }

  void _onPTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/PatternTherapy');
  }

  void _onTTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/TextureTherapy');
  }

  void _onBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
