///|
pub impl Format for Int with write(value, buffer, offset) {
  if value >= 0 {
    let value = value.reinterpret_as_uint()
    Format::write(value, buffer, offset)
  } else {
    let value = (-value).reinterpret_as_uint()
    buffer[offset] = '-'
    Format::write(value, buffer, offset + 1) + 1
  }
}

///|
/// 
/// TODO
pub impl Format for Int with count(self) -> Int {
  50
}

///|
pub impl LittleEndianFormat for Int with write(value, buffer, offset) {
  LittleEndianFormat::write(value.reinterpret_as_uint(), buffer, offset)
}

///|
/// supremum
pub impl LittleEndianFormat for Int with count(self) -> Int {
  4
}

///|
pub impl BigEndianFormat for Int with write(value, buffer, offset) {
  BigEndianFormat::write(value.reinterpret_as_uint(), buffer, offset)
}

///|
/// supremum
pub impl BigEndianFormat for Int with count(self) -> Int {
  4
}
