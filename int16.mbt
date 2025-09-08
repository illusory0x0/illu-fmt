///|
pub impl Format for Int16 with write(value, buffer, start) {
  let value32 = value.to_int()
  Format::write(value32, buffer, start)
}

///|
/// supremum
pub impl Format for Int16 with count(self) -> Int {
  12
}

///|
pub impl LittleEndianFormat for Int16 with write(value, buffer, start) {
  let b0 = (value.to_int() & 0xFF).to_byte()
  let b1 = ((value.to_int() >> 8) & 0xFF).to_byte()
  buffer[start + 0] = b0
  buffer[start + 1] = b1
  2
}

///|
/// supremum
pub impl LittleEndianFormat for Int16 with count(self) -> Int {
  2
}

///|
pub impl BigEndianFormat for Int16 with write(value, buffer, start) {
  let b0 = ((value.to_int() >> 8) & 0xFF).to_byte()
  let b1 = (value.to_int() & 0xFF).to_byte()
  buffer[start + 0] = b0
  buffer[start + 1] = b1
  2
}

///|
/// supremum
pub impl BigEndianFormat for Int16 with count(self) -> Int {
  2
}

///|
pub impl HexLowerFormat for Int16 with write(value, buffer, start) {
  let value_uint = value.to_int().reinterpret_as_uint() & 0xFFFF
  HexLowerFormat::write(value_uint, buffer, start)
}

///|
/// supremum
pub impl HexLowerFormat for Int16 with count(self) -> Int {
  4
}

///|
pub impl HexUpperFormat for Int16 with write(value, buffer, start) {
  let value_uint = value.to_int().reinterpret_as_uint() & 0xFFFF
  HexUpperFormat::write(value_uint, buffer, start)
}

///|
/// supremum
pub impl HexUpperFormat for Int16 with count(self) -> Int {
  4
}
