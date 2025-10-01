///|
pub impl Format for Byte with write(value, buffer, start) {
  buffer[start] = value
  1
}

///|
/// supremum
pub impl Format for Byte with count(_) -> Int {
  1
}
