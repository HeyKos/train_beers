extension StringFormatting on num {
  String toTwoDigitString() {
    if (this >= 10) {
      return "$this";
    }
    return "0$this";
  }
}