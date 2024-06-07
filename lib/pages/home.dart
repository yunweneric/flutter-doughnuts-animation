import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_doughnut_animation/utils/colors.dart';
import 'package:flutter_doughnut_animation/utils/sizing.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animatedAngle;

  double rotationFactor = 1.58;
  int activeIndex = 0;
  final duration = const Duration(milliseconds: 500);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animatedAngle = Tween<double>(begin: -rotationFactor, end: 0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  animate(Doughnut item) {
    _animatedAngle = Tween<double>(begin: activeIndex * -rotationFactor, end: rotationFactor * -item.index).animate(
      _controller,
    );
    _controller.reset();
    _controller.forward();
    setState(() {
      activeIndex = item.index;
    });
  }

  List<Doughnut> items = [
    Doughnut(index: 0, color: AppColors.yellow, falseIndex: 0),
    Doughnut(index: 1, color: AppColors.blue, falseIndex: 3),
    Doughnut(index: 2, color: AppColors.red, falseIndex: 2),
    Doughnut(index: 3, color: AppColors.green, falseIndex: 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1000),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              // curve: Curves.elasticOut,
              key: ValueKey(activeIndex),
              builder: (context, value, c) {
                return AnimatedOpacity(
                  duration: duration,
                  opacity: value,
                  child: SvgPicture.asset(
                    "assets/images/clipper.svg",
                    fit: BoxFit.cover,
                    color: items[activeIndex].color,
                    // color: Colors.red,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: duration,
              color: items[activeIndex].color.withOpacity(0.4),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1500),
                // tween: Tween<Offset>(begin: Offset(-Sizing.width(context) * 0.65, 0), end: Offset.zero),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.ease,
                key: ValueKey(activeIndex),
                builder: (context, value, c) {
                  return AnimatedOpacity(
                    opacity: value,
                    duration: duration,
                    child: AnimatedContainer(
                      duration: duration,
                      color: items[activeIndex].color.withOpacity(0.4),
                    ),
                  );
                }),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1500),
                // tween: Tween<Offset>(begin: Offset(-Sizing.height(context), 0), end: Offset.zero),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.ease,
                key: ValueKey(activeIndex),
                builder: (context, value, c) {
                  return Transform.translate(
                    offset: Offset.zero,
                    child: AnimatedOpacity(
                      opacity: value,
                      duration: duration,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/bg_doughnut_$activeIndex.png"),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Positioned(
            right: 60,
            top: 0,
            child: Container(
              // color: Colors.amber,
              width: Sizing.width(context) * 0.4,
              height: Sizing.height(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icons/title.svg", color: AppColors.white),
                  SizedBox(height: 30),
                  const Text(
                    "Lorem ipsum dolor sit amet consectetur adipisicing elit. Obcaecati similique cupiditate laboriosam consequuntur facere maxime necessitatibus nemo eius perferendis ea eum laudantium iste a asperiores libero tempore, saepe cum! Ratione?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.white),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...items.map((item) {
                        return Container(
                          margin: EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () => animate(item),
                            child: AnimatedScale(
                              duration: duration,
                              scale: item.index == activeIndex ? 1 : 0.8,
                              child: Image.asset("assets/images/doughnut_${item.index}.png", scale: 5.5),
                            ),
                          ),
                        );
                      })
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: Sizing.width(context),
            height: Sizing.height(context),
            child: Row(
              children: [
                Container(
                  transform: Matrix4.identity()..translate(-700.0),
                  child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, a) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateZ(_animatedAngle.value)
                            ..scale(1.8),
                          child: Container(
                            width: Sizing.height(context),
                            height: Sizing.height(context),
                            alignment: Alignment.center,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ...items.map((item) {
                                  return Builder(builder: (context) {
                                    const mainRadius = 300.0;
                                    // Calculate angle for each index
                                    double angle = (item.index * (2 * math.pi)) / 4;
                                    // Calculate x and y position using trigonometry
                                    double x = mainRadius + mainRadius * math.cos(angle);
                                    double y = mainRadius + mainRadius * math.sin(angle);

                                    return Positioned(
                                      top: y,
                                      left: x,
                                      child: AnimatedOpacity(
                                        duration: duration,
                                        opacity: item.index == activeIndex ? 1 : 1,
                                        child: Image.asset("assets/images/doughnut_${item.index}.png", width: 300, height: 300),
                                      ),
                                    );
                                  });
                                })
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 1.569

class Doughnut {
  final int index;
  final int falseIndex;
  final Color color;

  Doughnut({required this.index, required this.color, required this.falseIndex});
}
