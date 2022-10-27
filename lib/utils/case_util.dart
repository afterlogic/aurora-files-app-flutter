extension CaseUtil on String {
  String firstCharTo(bool toUpper) {
    if (isEmpty) {
      return this;
    } else {
      return toUpper
          ? this[0].toUpperCase()
          : this[0].toLowerCase() + substring(1);
    }
  }
}
