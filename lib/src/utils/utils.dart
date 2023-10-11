class Utils {
  /// Map the value x from the range [x1, x2] to the range [a, b]
  double mapRange(double x, double x1, double x2, double a, double b) {
    return ((x - x1) / (x2 - x1)) * (b - a) + a;
  }

  /// The pixels for the left edge of the sticker
  double stickerLeading(double max, double perc) {
    return max * (2 * perc - 1);
  }
}
