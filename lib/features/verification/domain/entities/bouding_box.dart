class BoundingBox {
  final double x;      
  final double y;      
  final double width;  
  final double height; 

  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  double get left => x;
  double get top => y;
  double get right => x + width;
  double get bottom => y + height;
  
  // Helper: get center
  double get centerX => x + (width / 2);
  double get centerY => y + (height / 2);

  @override
  String toString() {
    return 'BoundingBox(x: $x, y: $y, w: $width, h: $height)';
  }
}