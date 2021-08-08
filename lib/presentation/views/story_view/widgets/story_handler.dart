import 'package:codegram/logic/generic_state/generic_state.dart';
import 'package:codegram/logic/story_cubit/story_cubit.dart';
import 'package:codegram/presentation/widgets/custom_loading/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../story_view.dart';

class StoryHandler extends StatefulWidget {
  const StoryHandler({Key? key}) : super(key: key);

  @override
  _StoryHandlerState createState() => _StoryHandlerState();
}

class _StoryHandlerState extends State<StoryHandler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBuilder(),
    );
  }

  Builder buildBuilder() {
    return Builder(builder: (context) {
      final GenericState storyState = context.watch<StoryCubit>().state;
      if (storyState is GenericInitial) {
        context.read<StoryCubit>().getStories();
        return Container();
      } else if (storyState is GenericLoading) {
        return const Center(child: CustomLoading());
      } else if (storyState is GenericCompleted) {
        return StoryView(stories: storyState.response);
      } else {
        final error = storyState as GenericError;
        return Center(child: Text("${error.message}\n${error.statusCode}"));
      }
    });
  }
}
