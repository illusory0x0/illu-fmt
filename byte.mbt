///|
pub impl Format for Byte with write(value, buffer, offset) {
  buffer[offset] = value
  1
}

///|
/// supremum
pub impl Format for Byte with count(self) -> Int {
  1
}
