class FaceLandmarks {
  final Point leftEye;
  final Point rightEye;
  final Point nose;
  final Point leftMouth;
  final Point rightMouth;

  const FaceLandmarks({
    required this.leftEye,
    required this.rightEye,
    required this.nose,
    required this.leftMouth,
    required this.rightMouth,
  });

  List<Point> get allPoints => [
        leftEye,
        rightEye,
        nose,
        leftMouth,
        rightMouth,
      ];

  @override
  String toString() {
    return 'FaceLandmarks(leftEye: $leftEye, rightEye: $rightEye, nose: $nose)';
  }
}

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  @override
  String toString() => 'Point($x, $y)';
}