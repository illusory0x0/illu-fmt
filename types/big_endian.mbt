///|
pub(all) struct BigEndian[T](T)

///|
/// if contract is violated, behavior is undefined
pub(open) trait BigEndianFormat {
  /// Write the `value` into `buffer` as the `start` position,
  /// and return the number of bytes written.
  ///
  /// The number of bytes written must not exceed count().
  write(value : Self, buffer : Memory, start : Int) -> Int
  /// Upper bound on the number of bytes written
  count(value : Self) -> Int
}

///|
pub impl[T : BigEndianFormat] Format for BigEndian[T] with write(
  value,
  buffer,
  start,
) {
  T::write(value.inner(), buffer, start)
}

///|
pub impl[T : BigEndianFormat] Format for BigEndian[T] with count(self) {
  T::count(self.inner())
}
