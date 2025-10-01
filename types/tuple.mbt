///|
pub impl[A : Format, B : Format] Format for (A, B) with write(
  value,
  buffer,
  start,
) {
  let mut offset = start
  offset += Format::write(b'(', buffer, offset)
  offset += Format::write(value.0, buffer, offset)
  offset += Format::write(b',', buffer, offset)
  offset += Format::write(value.1, buffer, offset)
  offset += Format::write(b')', buffer, offset)
  offset - start
}

///|
pub impl[A : Format, B : Format] Format for (A, B) with count(self) -> Int {
  // 3 for '(', ',', ')'
  3 + self.0.count() + self.1.count()
}
