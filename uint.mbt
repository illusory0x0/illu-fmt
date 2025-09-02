///|
fn reverse(xs : Memory, start : Int, end : Int) -> Unit {
  let mut i = start
  let mut j = end - 1
  while i < j {
    let temp = xs[i]
    xs[i] = xs[j]
    xs[j] = temp
    i += 1
    j -= 1
  }
}

///|
pub impl Format for UInt with write(value, buffer, offset) {
  if value == 0 {
    buffer[offset + 0] = '0'
    return 1
  }
  let start = offset
  let mut value = value
  let mut offset = offset
  while value > 0 {
    let rem = value % 10
    buffer[offset] = upper_digit_table[rem.reinterpret_as_int()]
    value /= 10
    offset += 1
  }
  reverse(buffer, start, offset)
  offset - start
}

///|
/// supremum
pub impl Format for UInt with count(self) -> Int {
  11
}

///|
pub impl LittleEndianFormat for UInt with write(value, buffer, offset) {
  let b0 = (value & 0xFF).to_byte()
  let b1 = ((value >> 8) & 0xFF).to_byte()
  let b2 = ((value >> 16) & 0xFF).to_byte()
  let b3 = ((value >> 24) & 0xFF).to_byte()
  buffer[offset + 0] = b0
  buffer[offset + 1] = b1
  buffer[offset + 2] = b2
  buffer[offset + 3] = b3
  4
}

///|
/// supremum
pub impl LittleEndianFormat for UInt with count(self) -> Int {
  4
}

///|
pub impl BigEndianFormat for UInt with write(value, buffer, offset) {
  let b0 = ((value >> 24) & 0xFF).to_byte()
  let b1 = ((value >> 16) & 0xFF).to_byte()
  let b2 = ((value >> 8) & 0xFF).to_byte()
  let b3 = (value & 0xFF).to_byte()
  buffer[offset + 0] = b0
  buffer[offset + 1] = b1
  buffer[offset + 2] = b2
  buffer[offset + 3] = b3
  4
}

///|
/// supremum
pub impl BigEndianFormat for UInt with count(self) -> Int {
  4
}
