import 'package:codegram/presentation/views/story_view/widgets/story_handler.dart';
import 'package:codegram/presentation/widgets/buttons/custom_button_extended.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 309),
          Image.asset("assets/images/logo.png"),
          const Spacer(flex: 265),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomButtonExtended(
              text: "Discover Stories",
              buttonColor: const Color(0xFFf4784c),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoryHandler()),
                );
              },
              buttonTextColor: Colors.white,
            ),
          ),
          const Spacer(flex: 60),
        ],
      ),
    );
  }
}
