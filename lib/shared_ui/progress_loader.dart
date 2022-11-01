import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressLoader extends StatelessWidget {
  final double progress;

  const ProgressLoader(this.progress, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: CircularPercentIndicator(
          lineWidth: 3.0,
          circularStrokeCap: CircularStrokeCap.round,
          radius: 25.0,
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 150,
          percent: progress,
          backgroundColor: Colors.grey.withOpacity(0.3),
          progressColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
