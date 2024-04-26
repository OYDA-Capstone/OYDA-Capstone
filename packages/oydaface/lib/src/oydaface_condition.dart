/// #### Represents a condition used in database queries.
class Condition {
  /// * A condition consists of a [columnName], an [operator], and a [value].
  /// * The [columnName] represents the name of the column in the database table.
  /// * The [operator] represents the comparison operator used in the condition.
  /// * The [value] represents the value to be compared against in the condition.
  final String columnName;
  final String operator;
  final dynamic value;

  /// Constructs a new [Condition] with the given [columnName], [operator], and [value].
  Condition(this.columnName, this.operator, this.value);

  @override
  /// #### Returns a string representation of the condition.
  ///
  /// * If the value is a string, the returned string will be in the format:
  ///   "$columnName $operator '$value'"
  /// * Otherwise, the returned string will be in the format:
  ///   "$columnName $operator $value"
  String toString() {
    if (value is String) {
      return '$columnName $operator \'$value\'';
    }
    return '$columnName $operator $value';
  }
}
