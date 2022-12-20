// Extension on String
import 'package:clean_architecture_mvvm/data/mapper/mapper.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return empty;
    } else {
      return this!;
    }
  }
}

// Extension on Integer
extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return zero;
    } else {
      return this!;
    }
  }
}
