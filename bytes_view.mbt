///|
pub impl Format for @bytes.View with write(value, buffer, offset) {
  for i in 0..<value.length() {
    buffer[offset + i] = value[i]
  }
  value.length()
}

///|
/// supremum
pub impl Format for @bytes.View with count(self) -> Int {
  self.length()
}
