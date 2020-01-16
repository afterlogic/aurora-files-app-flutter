extension CaseUtil on String {
  String firstCharTo(bool toUpper) {
    if (this.isEmpty) {
      return this;
    } else {
      return toUpper
          ? this[0].toUpperCase()
          : this[0].toLowerCase() + this.substring(1);
    }
  }
}
