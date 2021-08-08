import 'package:codegram/presentation/views/story_view/widgets/animated_bar.dart';
import 'package:codegram/presentation/widgets/cube_transition/cube_page_view.dart';
import 'package:codegram/data/model/story.dart';
import 'package:codegram/presentation/widgets/custom_loading/custom_loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryView extends StatefulWidget {
  final List<dynamic>? stories;
  const StoryView({Key? key, @required this.stories}) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<List<VideoPlayerController>> userControllerList = [];
  final List<List<Story>> userStoryList = [];
  final PageController controller = PageController(initialPage: 0);
  List<int> storyIndexForUser = [];
  List<int> storyNumberForUser = [];

  int userIndex = 0;
  int userNumber = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onLongPressStart: (LongPressStartDetails details) {
              userControllerList[userIndex][storyIndexForUser[userIndex]].pause();
              _animationController.stop();
            },
            onLongPressEnd: (LongPressEndDetails details) {
              userControllerList[userIndex][storyIndexForUser[userIndex]].play();
              _animationController.forward();
            },
            child: CubePageView.builder(
              controller: controller,
              onPageChanged: (index) {
                _animationController.stop();
                _animationController.reset();
                setState(() {
                  userIndex = index;

                  userControllerList[userIndex][storyIndexForUser[userIndex]].play();
                  _animationController.forward();
                });
                userControllerList[userIndex][storyIndexForUser[userIndex]].initialize().then((_) {
                  setState(() {
                    userControllerList[userIndex][storyIndexForUser[userIndex]].play();
                  });
                });
              },
              itemCount: userNumber,
              itemBuilder: (context, index, notifier) {
                if (userStoryList[index][storyIndexForUser[index]].type == "image") {
                  _animationController.duration = const Duration(seconds: 5);
                  _animationController.forward();
                  return buildImage(index, notifier);
                } else {
                  if (userControllerList[index][storyIndexForUser[index]].value.isInitialized) {
                    _animationController.duration = userControllerList[index][storyIndexForUser[index]].value.duration;

                    _animationController.forward();
                    return buildVideo(index, notifier);
                  }
                  return CubeWidget(index: index, pageNotifier: notifier, child: const Center(child: CustomLoading()));
                }
              },
            ),
          ),
          buildUserTapGestures(),
          buildAnimatedBar(),
        ],
      ),
    );
  }

  //Widgets

  Positioned buildAnimatedBar() {
    return Positioned(
      top: 40.0,
      left: 10.0,
      right: 10.0,
      child: Row(
        children: userStoryList[userIndex]
            .asMap()
            .map((i, e) {
              return MapEntry(
                i,
                AnimatedBar(
                  animController: _animationController,
                  position: i,
                  currentIndex: storyIndexForUser[userIndex],
                ),
              );
            })
            .values
            .toList(),
      ),
    );
  }

  Row buildUserTapGestures() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                prevStory();
              });
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              setState(() {
                nextStory(true);
              });
            },
          ),
        )
      ],
    );
  }

  CubeWidget buildVideo(int index, double notifier) =>
      CubeWidget(index: index, pageNotifier: notifier, child: VideoPlayer(userControllerList[index][storyIndexForUser[index]]));

  CubeWidget buildImage(int index, double notifier) {
    return CubeWidget(
      index: index,
      pageNotifier: notifier,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Image.network(
          userStoryList[index][storyIndexForUser[index]].url!,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {});
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          nextStory(false);
        });
      }
    });

    initializeStories();
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    for (int i = 0; i < userNumber; i++) {
      for (int j = 0; j < widget.stories!.length; j++) {
        userControllerList[i][j].dispose();
      }
    }
    super.dispose();
  }

  //Functions

  nextStory(bool isTap) {
    if (storyIndexForUser[userIndex] < (storyNumberForUser[userIndex]) - 1) {
      userControllerList[userIndex][storyIndexForUser[userIndex]].pause();
      storyIndexForUser[userIndex]++;
      if (isTap) {
        _animationController.reset();
      }
      userControllerList[userIndex][storyIndexForUser[userIndex]].initialize().then((_) {
        setState(() {
          userControllerList[userIndex][storyIndexForUser[userIndex]].play();
        });
      });
    } else {
      if (userIndex < (userNumber - 1)) {
        userControllerList[userIndex][storyIndexForUser[userIndex]].pause();
        userIndex++;
        controller.animateToPage(userIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
      } else {
        Navigator.pop(context);
      }
    }
  }

  prevStory() {
    if (storyIndexForUser[userIndex] > 0) {
      userControllerList[userIndex][storyIndexForUser[userIndex]].pause();
      storyIndexForUser[userIndex]--;
      _animationController.reset();
      userControllerList[userIndex][storyIndexForUser[userIndex]].initialize().then((_) {
        setState(() {
          userControllerList[userIndex][storyIndexForUser[userIndex]].play();
        });
      });
    } else {
      if (userIndex > 0) {
        userControllerList[userIndex][storyIndexForUser[userIndex]].pause();
        userIndex--;
        controller.animateToPage(userIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
      } else {
        Navigator.pop(context);
      }
    }
  }

  initializeStories() {
    for (int j = 0; j < userNumber; j++) {
      List<VideoPlayerController> videoControllerList = [];
      List<Story> storyList = [];
      storyNumberForUser.add(0);
      for (int i = 0; i < widget.stories!.length; i++) {
        if (j == widget.stories![i].id) {
          VideoPlayerController controller = VideoPlayerController.network(widget.stories![i].url)
            ..initialize().then((_) {
              setState(() {});
            });
          storyList.add(widget.stories![i]);
          videoControllerList.add(controller);
          storyNumberForUser[j]++;
        }
      }
      userStoryList.add(storyList);
      storyIndexForUser.add(0);
      userControllerList.add(videoControllerList);
    }
    userControllerList[userIndex][storyIndexForUser[userIndex]].play();
  }
}
