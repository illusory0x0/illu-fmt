///|
pub(all) struct LittleEndian[T](T)

///|
pub(open) trait LittleEndianFormat {
  /// The number of bytes written must not exceed count().
  write(Self, ArrayView[Byte]) -> Int
  /// Upper bound on the number of bytes written
  count(Self) -> Int
}

///|
pub impl[T : LittleEndianFormat] Format for LittleEndian[T] with write(
  value,
  buffer,
) {
  T::write(value.inner(), buffer)
}

///|
pub impl[T : LittleEndianFormat] Format for LittleEndian[T] with count(self) {
  T::count(self.inner())
}
