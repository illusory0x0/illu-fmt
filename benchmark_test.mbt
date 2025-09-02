///|
let upper_digit_table : FixedArray[Byte] = [
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
]

///|
test {
  let buf = @buffer.new(size_hint=100)
  write_uint_text(123456789, buf)
  inspect(buf.to_bytes() |> ascii_bytes_to_string, content="123456789")
}

///|
test {
  let buf = Array::make(1024, Byte::default())
  let offset = @fmt.Format::write(123456789, buf[:])
  inspect(
    buf[:offset].to_array() |> Bytes::from_array |> ascii_bytes_to_string,
    content="123456789",
  )
}

///|
fn write_uint_text(num : UInt, buffer : @buffer.T) -> Unit {
  let mut value = num
  let temp = []
  while value > 0 {
    let rem = value % 10
    temp.push(upper_digit_table[rem.reinterpret_as_int()])
    value /= 10
  }
  for x in temp.rev_iter() {
    buffer.write_byte(x)
  }
}

///|
test "buffer vs arrayview" (b : @bench.T) {
  let num : UInt = 123456789
  let buf = @buffer.new(size_hint=409600)
  b.bench(name="buffer", fn() {
    for _ in 0..<1000 {
      write_uint_text(num, buf)
    }
    buf.reset()
  })
  let fbuf = Array::make(409600, b'\x00')
  b.bench(name="arrayview", fn() {
    let mut offset = 0
    for _ in 0..<1000 {
      offset += @fmt.Format::write(num, fbuf[offset:])
    }
  })
}
