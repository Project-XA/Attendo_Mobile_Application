class DigitDetection {
  final int digit;
  final double confidence;
  final double x;
  final double y;
  final double width;   
  final double height;  

  DigitDetection({
    required this.digit,
    required this.confidence,
    required this.x,
    required this.y,
    this.width = 0.0,   
    this.height = 0.0,  
  });
}