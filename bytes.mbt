///|
pub impl Format for Bytes with write(value, buffer, offset) {
  for i in 0..<value.length() {
    buffer[offset + i] = value[i]
  }
  value.length()
}

///|
/// supremum
pub impl Format for Bytes with count(self) -> Int {
  self.length()
}
