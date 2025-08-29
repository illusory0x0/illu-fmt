///|
test "Double" {
  let buffer = Array::make(1024, Byte::default())
  let b = buffer[:]
  let value = 3.14
  inspect(to_string(b, value), content="3.14")
}

///|
test "UInt" {
  let value : UInt = 0xAABBCCEE
  let buffer = Array::make(1024, Byte::default())
  let b = buffer[:]
  let v0 = value
  let v1 = @fmt.BigEndian(v0)
  let v2 = @fmt.LittleEndian(value)
  inspect(value, content="2864434414")
  inspect(ascii_bytes_to_string(to_bytes(b, v0)), content="2864434414")
  inspect(
    to_bytes(b, v1),
    content=(
      #|b"\xaa\xbb\xcc\xee"
    ),
  )
  inspect(
    to_bytes(b, v2),
    content=(
      #|b"\xee\xcc\xbb\xaa"
    ),
  )
  inspect(ascii_bytes_to_string(to_bytes(b, 123456789U)), content="123456789")
  inspect(ascii_bytes_to_string(to_bytes(b, 12345678U)), content="12345678")
}

///|
test "Int" {
  let value : Int = 0xAABBCCEE
  let buffer = Array::make(1024, Byte::default())
  let b = buffer[:]
  let v0 = value
  let v1 = @fmt.BigEndian(v0)
  let v2 = @fmt.LittleEndian(value)
  inspect(value, content="-1430532882")
  inspect(ascii_bytes_to_string(to_bytes(b, v0)), content="-1430532882")
  inspect(
    to_bytes(b, v1),
    content=(
      #|b"\xaa\xbb\xcc\xee"
    ),
  )
  inspect(
    to_bytes(b, v2),
    content=(
      #|b"\xee\xcc\xbb\xaa"
    ),
  )
  inspect(ascii_bytes_to_string(to_bytes(b, 123456789U)), content="123456789")
  inspect(ascii_bytes_to_string(to_bytes(b, 12345678U)), content="12345678")
  // test trait object
  let v : &Format = 0
  inspect(ascii_bytes_to_string(to_bytes(b, v)), content="0")
}
