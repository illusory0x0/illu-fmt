///|
pub impl Format for @bytes.View with write(value, buffer) {
  for i in 0..<value.length() {
    buffer[i] = value[i]
  }
  value.length()
}

///|
/// supremum
pub impl Format for @bytes.View with count(self) -> Int {
  self.length()
}
