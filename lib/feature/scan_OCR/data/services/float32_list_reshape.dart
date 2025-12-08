import 'dart:typed_data';

extension Float32ListReshape on Float32List {
  List reshape(List<int> shape) {
    int totalElements = shape.reduce((a, b) => a * b);
    if (totalElements != length) {
      throw Exception('Cannot reshape: $totalElements != $length');
    }

    if (shape.length == 4) return _reshape4D(shape);
    if (shape.length == 3) return _reshape3D(shape);

    throw Exception('Unsupported reshape: ${shape.length}D');
  }

  List _reshape4D(List<int> shape) {
    return List.generate(
      shape[0],
      (b) => List.generate(
        shape[1],
        (h) => List.generate(
          shape[2],
          (w) => List.generate(shape[3], (c) {
            int index =
                b * (shape[1] * shape[2] * shape[3]) +
                h * (shape[2] * shape[3]) +
                w * shape[3] +
                c;
            return this[index];
          }),
        ),
      ),
    );
  }

  List _reshape3D(List<int> shape) {
    return List.generate(
      shape[0],
      (b) => List.generate(
        shape[1],
        (c) => List.generate(shape[2], (d) {
          int index = b * (shape[1] * shape[2]) + c * shape[2] + d;
          return this[index];
        }),
      ),
    );
  }
}
