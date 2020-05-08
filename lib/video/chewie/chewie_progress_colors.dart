import 'package:flutter/rendering.dart';

import '../../basics/colors.dart';

// class ChewieProgressColors {
//   ChewieProgressColors({
//     Color playedColor: const Color.fromRGBO(255, 0, 0, 0.7),
//     Color bufferedColor: const Color.fromRGBO(30, 30, 200, 0.2),
//     Color handleColor: const Color.fromRGBO(200, 200, 200, 1.0),
//     Color backgroundColor: const Color.fromRGBO(200, 200, 200, 0.5),
//   })  {
//     ColorTheme colorTheme = ColorTheme();
//         this.playedPaint = Paint()..color = colorTheme.primary.withOpacity(0.7);
//         this.bufferedPaint = Paint()..color = colorTheme.primary.withOpacity(0.2);
//         this.handlePaint = Paint()..color = colorTheme.white.withOpacity(1);
//         this.backgroundPaint = Paint()..color = colorTheme.background.withOpacity(0.5);
//   }

//   Paint playedPaint;
//   Paint bufferedPaint;
//   Paint handlePaint;
//   Paint backgroundPaint;
// }

class ChewieProgressColors {
  ChewieProgressColors({
    Color playedColor: const Color.fromRGBO(255, 0, 0, 0.7),
    Color bufferedColor: const Color.fromRGBO(30, 30, 200, 0.2),
    Color handleColor: const Color.fromRGBO(200, 200, 200, 1.0),
    Color backgroundColor: const Color.fromRGBO(200, 200, 200, 0.5),
  })  : playedPaint = Paint()..color = playedColor,
        bufferedPaint = Paint()..color = bufferedColor,
        handlePaint = Paint()..color = handleColor,
        backgroundPaint = Paint()..color = backgroundColor;

  final Paint playedPaint;
  final Paint bufferedPaint;
  final Paint handlePaint;
  final Paint backgroundPaint;
}