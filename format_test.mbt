///|
fn memory_to_string(memory : Memory, end : Int) -> String {
  let buf = StringBuilder::new()
  for i in 0..<end {
    buf.write_char(memory[i].to_char())
  }
  buf.to_string()
}

///|
fn bytes_of_memory(memory : Memory) -> Bytes = "%identity"

///|
fn bytes_view_of_memory(memory : Memory, start : Int, end : Int) -> @bytes.View {
  bytes_of_memory(memory)[start:end]
}

///|
test "Double" {
  let buffer = Memory::make(1024, Byte::default())
  let offset = Format::write(3.14, buffer, 0)
  inspect(memory_to_string(buffer, offset), content="3.14")
}

///|
test "UInt" {
  let buffer = Memory::make(1024, Byte::default())
  let offset = Format::write(0xAABBCCEEU, buffer, 0)
  inspect(memory_to_string(buffer, offset), content="2864434414")
  let offset = Format::write(@fmt.LittleEndian(0xAABBCCEEU), buffer, 0)
  inspect(
    bytes_view_of_memory(buffer, 0, offset),
    content=(
      #|b"\xee\xcc\xbb\xaa"
    ),
  )
  let offset = Format::write(@fmt.BigEndian(0xAABBCCEEU), buffer, 0)
  inspect(
    bytes_view_of_memory(buffer, 0, offset),
    content=(
      #|b"\xaa\xbb\xcc\xee"
    ),
  )
}

///|
test "Int" {
  let buffer = Memory::make(1024, Byte::default())
  let offset = Format::write(123456789, buffer, 0)
  inspect(memory_to_string(buffer, offset), content="123456789")
  let offset = Format::write(-123456789, buffer, 0)
  inspect(memory_to_string(buffer, offset), content="-123456789")
  let offset = Format::write(0xAABBCCEE, buffer, 0)
  inspect(memory_to_string(buffer, offset), content="-1430532882")
  let offset = Format::write(@fmt.LittleEndian(0xAABBCCEE), buffer, 0)
  inspect(
    bytes_view_of_memory(buffer, 0, offset),
    content=(
      #|b"\xee\xcc\xbb\xaa"
    ),
  )
  let offset = Format::write(@fmt.BigEndian(0xAABBCCEE), buffer, 0)
  inspect(
    bytes_view_of_memory(buffer, 0, offset),
    content=(
      #|b"\xaa\xbb\xcc\xee"
    ),
  )
}
