///|
pub impl[A : Format, B : Format] Format for Iter2[A, B] with write(
  value,
  buffer,
  start,
) {
  let mut offset = start
  offset += Format::write(b'[', buffer, offset)
  for x, y in value {
    offset += Format::write(b'(', buffer, offset)
    offset += Format::write(x, buffer, offset)
    offset += Format::write(b',', buffer, offset)
    offset += Format::write(y, buffer, offset)
    offset += Format::write(b')', buffer, offset)
    // delimiter for pairs
    offset += Format::write(b',', buffer, offset)
  }
  // overwrite last ',' with ']'
  buffer[offset - 1] = b']'
  offset - start
}

///|
/// supremum
pub impl[A : Format, B : Format] Format for Iter2[A, B] with count(self) -> Int {
  let mut supremum = 1 // for '['
  for x, y in self {
    // 4 for '(', ',', ')', ','
    supremum += 4 + x.count() + y.count()
  }
  // overwrite last ',' with ']'
  supremum
}
