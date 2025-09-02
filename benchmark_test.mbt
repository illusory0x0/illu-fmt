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
fn reverse(xs : FixedArray[Byte], start~ : Int, end~ : Int) -> Unit {
  let mut start = start
  let mut end = end - 1
  while start < end {
    let temp = xs[start]
    xs[start] = xs[end]
    xs[end] = temp
    start += 1
    end -= 1
  }
}

///|
fn write_uint_text_fixedarray(
  value : UInt,
  buffer : FixedArray[Byte],
  offset : Int,
) -> Int {
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
  reverse(buffer, start=offset, end=i)
  i
}

///|
test {
  let xs : FixedArray[Byte] = FixedArray::make(4096, 0)
  let offset = write_uint_text_fixedarray(123456789, xs, 0)
  let buf = StringBuilder::new()
  for i in 0..<offset {
    buf.write_char(xs[i].to_char())
  }
  inspect(buf, content="123456789")
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
  let fbuf = FixedArray::make(409600, b'\x00')
  b.bench(name="fixedarray", fn() {
    let mut offset = 0
    for _ in 0..<1000 {
      offset += write_uint_text_fixedarray(num, fbuf, offset)
    }
  })
}
