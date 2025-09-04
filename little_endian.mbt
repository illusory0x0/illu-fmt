///|
pub(all) struct LittleEndian[T](T)

///|
pub(open) trait LittleEndianFormat {
  /// The number of bytes written must not exceed count().
  write(value : Self, buffer : Memory, start : Int) -> Int
  /// Upper bound on the number of bytes written
  count(value : Self) -> Int
}

///|
pub impl[T : LittleEndianFormat] Format for LittleEndian[T] with write(
  value,
  buffer,
  start,
) {
  T::write(value.inner(), buffer, start)
}

///|
pub impl[T : LittleEndianFormat] Format for LittleEndian[T] with count(self) {
  T::count(self.inner())
}
