///|
pub impl Format for UInt16 with write(value, buffer, start) {
  let value32 = value.to_uint()
  Format::write(value32, buffer, start)
}

///|
/// supremum
pub impl Format for UInt16 with count(_) -> Int {
  UInt16_Digits10
}

///|
pub impl LittleEndianFormat for UInt16 with write(value, buffer, start) {
  let b0 = (value.to_uint() & 0xFF).to_byte()
  let b1 = ((value.to_uint() >> 8) & 0xFF).to_byte()
  buffer[start + 0] = b0
  buffer[start + 1] = b1
  2
}

///|
/// supremum
pub impl LittleEndianFormat for UInt16 with count(_) -> Int {
  2
}

///|
pub impl BigEndianFormat for UInt16 with write(value, buffer, start) {
  let b0 = ((value.to_uint() >> 8) & 0xFF).to_byte()
  let b1 = (value.to_uint() & 0xFF).to_byte()
  buffer[start + 0] = b0
  buffer[start + 1] = b1
  2
}

///|
/// supremum
pub impl BigEndianFormat for UInt16 with count(_) -> Int {
  2
}

///|
pub impl HexLowerFormat for UInt16 with write(value, buffer, start) {
  let value_uint = value.to_uint() & 0xFFFF
  HexLowerFormat::write(value_uint, buffer, start)
}

///|
/// supremum
pub impl HexLowerFormat for UInt16 with count(_) -> Int {
  4
}

///|
pub impl HexUpperFormat for UInt16 with write(value, buffer, start) {
  let value_uint = value.to_uint() & 0xFFFF
  HexUpperFormat::write(value_uint, buffer, start)
}

///|
/// supremum
pub impl HexUpperFormat for UInt16 with count(_) -> Int {
  4
}
