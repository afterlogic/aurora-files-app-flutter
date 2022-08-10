import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressLoader extends StatelessWidget {
  final double progress;

  const ProgressLoader(this.progress, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        height: 53.0,
        width: 53.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircularPercentIndicator(
            lineWidth: 3.0,
            circularStrokeCap: CircularStrokeCap.round,
            radius: 45.0,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 150,
            percent: progress,
            backgroundColor: Colors.grey.withOpacity(0.3),
            progressColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
