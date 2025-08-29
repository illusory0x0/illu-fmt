///|
fn reverse(xs : ArrayView[Byte], from~ : Int) -> Unit {
  let mut start = 0
  let mut end = from - 1
  while start < end {
    xs.swap(start, end)
    start += 1
    end -= 1
  }
}

///|
pub impl Format for UInt with write(value, buffer) {
  if value == 0 {
    buffer[0] = '0'
    return 1
  }
  let mut value = value
  let mut i = 0
  while value > 0 {
    let rem = value % 10
    buffer[i] = upper_digit_table[rem.reinterpret_as_int()]
    value /= 10
    i += 1
  }
  reverse(buffer, from=i)
  i
}

///|
/// TODO
pub impl Format for UInt with count(self) -> Int {
  50
}

///|
pub impl LittleEndianFormat for UInt with write(value, buffer) {
  let b0 = (value & 0xFF).to_byte()
  let b1 = ((value >> 8) & 0xFF).to_byte()
  let b2 = ((value >> 16) & 0xFF).to_byte()
  let b3 = ((value >> 24) & 0xFF).to_byte()
  buffer[0] = b0
  buffer[1] = b1
  buffer[2] = b2
  buffer[3] = b3
  4
}

///|
/// supremum
pub impl LittleEndianFormat for UInt with count(self) -> Int {
  4
}

///|
pub impl BigEndianFormat for UInt with write(value, buffer) {
  let b0 = ((value >> 24) & 0xFF).to_byte()
  let b1 = ((value >> 16) & 0xFF).to_byte()
  let b2 = ((value >> 8) & 0xFF).to_byte()
  let b3 = (value & 0xFF).to_byte()
  buffer[0] = b0
  buffer[1] = b1
  buffer[2] = b2
  buffer[3] = b3
  4
}

///|
/// supremum
pub impl BigEndianFormat for UInt with count(self) -> Int {
  4
}
