///|
pub impl[A : Format] Format for Iter[A] with write(value, buffer, offset) {
  let mut offset = 0
  offset += Format::write(b'[', buffer, offset)
  for x in value {
    offset += Format::write(x, buffer, offset)
    offset += Format::write(b',', buffer, offset)
  }
  // overwrite last ',' with ']'
  buffer[offset - 1] = b']'
  offset
}

///|
/// supremum
pub impl[A : Format] Format for Iter[A] with count(self) -> Int {
  self.fold(init=0, (acc, x) => acc + x.count() + 1) + 1
}
