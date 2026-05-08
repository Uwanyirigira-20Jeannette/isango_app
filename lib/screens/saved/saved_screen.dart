import 'package:flutter/material.dart';
import 'package:isango_app/screens/shared/placeholder_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IsangoPlaceholderScreen(
        title: "Saved Events",
        message: "Saved Events screen will be added later",
        currentIndex: 1,
        showBottomNavigation: true
    );
  }
}

