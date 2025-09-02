///|
pub(all) struct BigEndian[T](T)

///|
pub(open) trait BigEndianFormat {
  /// The number of bytes written must not exceed count().
  write(value : Self, buffer : Memory, offset : Int) -> Int
  /// Upper bound on the number of bytes written
  count(value : Self) -> Int
}

///|
pub impl[T : BigEndianFormat] Format for BigEndian[T] with write(
  value,
  buffer,
  offset,
) {
  T::write(value.inner(), buffer, offset)
}

///|
pub impl[T : BigEndianFormat] Format for BigEndian[T] with count(self) {
  T::count(self.inner())
}
