import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';



import 'package:circular_countdown_timer/circular_countdown_timer.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home: const MyHomePage(title: 'Mindful Meal Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _duration = 30;
  final CountDownController _controller = CountDownController();
  Stopwatch stopwatch = Stopwatch();


  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  Future<void> preLoadSound() async {
    try {
      await audioPlayer.open(Audio('assets/sounds/countdown_tick.mp3'));
    } catch (e) {
      debugPrint('Error preloading sound: $e');
    }
  }

  @override
  initState() {
    super.initState();
    preLoadSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text(widget.title!),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            Container(
              width: MediaQuery.of(context).size.width / 2 + 40,
              height: MediaQuery.of(context).size.height / 2 + 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),


              CircularCountDownTimer(

                duration: _duration,
              

                initialDuration: 0,
              

                controller: _controller,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: Colors.grey[300]!,

                ringGradient: null,
              
                // Filling Color for Countdown Widget.
                fillColor: Colors.green,
              
                // Filling Gradient for Countdown Widget.
                fillGradient: null,
              
                // Background Color for Countdown Widget.
                backgroundColor: Colors.white,
              
                // Background Gradient for Countdown Widget.
                backgroundGradient: null,
              
                // Border Thickness of the Countdown Ring.
                strokeWidth: 12.0,
              
                // Begin and end contours with a flat edge and no extension.
                strokeCap: StrokeCap.square,
              
                // Text Style for Countdown Text.
                textStyle: const TextStyle(
                  fontSize: 33.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              
                // Format for the Countdown Text.
                textFormat: CountdownTextFormat.S,
              
                // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                isReverse: true,
              
                // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                isReverseAnimation: true,
              

                isTimerTextShown: true,
              

                autoStart: false,
              
                // This Callback will execute when the Countdown Starts.
                onStart: () {
                  // Here, do whatever you want
                  stopwatch.reset();
                  stopwatch.start();
                  debugPrint('Countdown Started');
                },
              
                // This Callback will execute when the Countdown Ends.
                onComplete: () {
                  // Here, do whatever you want
                  debugPrint('Countdown Ended');
                },
              
                // This Callback will execute when the Countdown Changes.
                onChange: (String timeStamp) {
                  if (_controller.getTime() == Duration(seconds: 5 )) {
                    preLoadSound();
                  }
                  debugPrint('Countdown Changed $timeStamp');
                },

                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (duration.inSeconds == 0) {
                    // only format for '0'
                    return "Start";
                  } else {
                    // other durations by it's default format
                    return Function.apply(defaultFormatterFunction, [duration]);
                  }
                },
              ),

            Positioned(
              left: MediaQuery.of(context).size.width / 4 - 76, // Adjust the left position as needed
              top: MediaQuery.of(context).size.height / 4 - 78, // Adjust the top position as needed
              child: CustomPaint(
                painter: ClockTimerPainter(),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.88,
                  height: MediaQuery.of(context).size.height / 2.88,
                ),
              ),
            ),

          ],

        ),

      ),
      floatingActionButton: Row(

        children: [
          const SizedBox(
            width: 30,
          ),
          _button(
            title: "Start",
            color: Colors.greenAccent,
            onPressed: () => _controller.start(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            color: Colors.grey,
            title: "Pause",
            onPressed: () => _controller.pause(),
          ),

          const SizedBox(
            width: 10,
          ),

          _button(
            color: Colors.grey,
            title: "Stop",
            onPressed: () => _controller.reset(),
          ),
          const SizedBox(
            width: 10,
          ),

          const SizedBox(
            width: 10,
          ),
        ],
      ),

    );


  }

  Widget _button({required String title, VoidCallback? onPressed, required Color color}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

}





class ClockTimerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 1.3;
    var centerY = size.height / 2.66;
    var radius = min(centerX, centerY);

    var dashBrush = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;

    var outerCircleRadius = radius;
    var innerCircleRadius = radius - 14;
    for (var i = 0; i < 360; i += 6) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}




