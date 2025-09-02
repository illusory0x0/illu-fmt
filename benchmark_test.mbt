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
  let temp = FixedArray::make(10, b'\x00')
  for i = 9, value = num; i >= 0 && value > 0; i = i - 1, value = value / 10 {
    temp[i] = upper_digit_table[(value % 10).reinterpret_as_int()]
  } else {
    buffer.write_bytesview(temp.unsafe_reinterpret_as_bytes()[i + 1:])
  }
}

///|
test {
  let num : UInt = 123456789
  let buf = @buffer.new(size_hint=100)
  write_uint_text(num, buf)
  inspect(buf.to_bytes() |> ascii_bytes_to_string, content="123456789")
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
