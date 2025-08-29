///|
pub(all) struct BigEndian[T](T)

///|
pub(open) trait BigEndianFormat {
  /// The number of bytes written must not exceed count().
  write(Self, ArrayView[Byte]) -> Int
  /// Upper bound on the number of bytes written
  count(Self) -> Int
}

///|
pub impl[T : BigEndianFormat] Format for BigEndian[T] with write(value, buffer) {
  T::write(value.inner(), buffer)
}

///|
pub impl[T : BigEndianFormat] Format for BigEndian[T] with count(self) {
  T::count(self.inner())
}
