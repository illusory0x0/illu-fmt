///|
pub impl Format for Int with write(value, buffer, start) {
  if value >= 0 {
    let value = value.reinterpret_as_uint()
    Format::write(value, buffer, start)
  } else {
    let value = (-value).reinterpret_as_uint()
    buffer[start] = '-'
    Format::write(value, buffer, start + 1) + 1
  }
}

///|
/// supremum
pub impl Format for Int with count(self) -> Int {
  Int_Digits10
}

///|
pub impl LittleEndianFormat for Int with write(value, buffer, start) {
  LittleEndianFormat::write(value.reinterpret_as_uint(), buffer, start)
}

///|
/// supremum
pub impl LittleEndianFormat for Int with count(self) -> Int {
  4
}

///|
pub impl BigEndianFormat for Int with write(value, buffer, start) {
  BigEndianFormat::write(value.reinterpret_as_uint(), buffer, start)
}

///|
/// supremum
pub impl BigEndianFormat for Int with count(self) -> Int {
  4
}

///|
pub impl HexLowerFormat for Int with write(value, buffer, start) {
  HexLowerFormat::write(value.reinterpret_as_uint(), buffer, start)
}

///|
/// supremum
pub impl HexLowerFormat for Int with count(self) -> Int {
  8
}

///|
pub impl HexUpperFormat for Int with write(value, buffer, start) {
  HexUpperFormat::write(value.reinterpret_as_uint(), buffer, start)
}

///|
/// supremum
pub impl HexUpperFormat for Int with count(self) -> Int {
  8
}
