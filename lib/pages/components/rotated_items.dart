import 'package:flutter/material.dart';
import 'package:flutter_doughnut_animation/pages/models/doughnut.dart';
import 'package:flutter_doughnut_animation/utils/sizing.dart';
import 'dart:math' as math;

SizedBox rotatedItems({
  required BuildContext context,
  required AnimationController controller,
  required Animation<double> animatedAngle,
  required Duration duration,
  required int activeIndex,
  required List<Doughnut> items,
}) {
  return SizedBox(
    width: Sizing.width(context),
    height: Sizing.height(context),
    child: Row(
      children: [
        Container(
          transform: Matrix4.identity()..translate(-700.0),
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, a) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ(animatedAngle.value)
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
  );
}
