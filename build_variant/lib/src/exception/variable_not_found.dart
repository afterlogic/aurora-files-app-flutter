class VariableNotFound {
  final String variable;
  final String path;
  final int line;

  VariableNotFound(this.variable, this.path, this.line);

  @override
  String toString() {
    return "\tVariable $variable not found\n\tLine number $line\n\tIn file $path";
  }
}
