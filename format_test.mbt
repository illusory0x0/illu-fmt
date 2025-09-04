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
  let offset = Format::write(0.123456789, buffer, 0)
  inspect(memory_to_string(buffer, offset), content="0.123456789")
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

///|
test "Iter" {
  let buffer = Memory::make(1024, Byte::default())
  let offset = Format::write([1, 2, 3].iter(), buffer, 0)
  inspect(memory_to_string(buffer, offset), content="[1,2,3]")
  let offset = Format::write([1.23, 2.34, 3.45].iter(), buffer, 0)
  inspect(memory_to_string(buffer, offset), content="[1.23,2.34,3.45]")
}

///|
test "Iter2" {
  let buffer = Memory::make(1024, Byte::default())
  let map : Map[Bytes, Double] = { "pi": 3.14, "e": 2.71 }
  let offset = Format::write(map.iter2(), buffer, 0)
  inspect(memory_to_string(buffer, offset), content="[(pi,3.14),(e,2.71)]")
}

///|
test "format_write" {
  let buffer = Memory::make(1024, b'%')
  fn str(fmt : Bytes, data : Array[&Format]) -> String raise {
    let offset = format_write(fmt, data, buffer, 1)
    memory_to_string(buffer, offset + 2)
  }

  inspect(try! str(b"hello {} world", [123]), content="%hello 123 world%")
  inspect(try! str(b"{}{}", [1, 2]), content="%12l")
  inspect(try! str(b"={}={}=", [1, 2]), content="%=1=2= ")
  inspect(try! str(b"={}={}", [1, 2]), content="%=1=2=")
  inspect(try! str(b"{}={}", [1, 2]), content="%1=22")
  inspect(try! str(b"{}", [@fmt.BigEndian(0x80818283)]), content="%=")
}

///|
test "format_write format dsl error" {
  let buffer = Memory::make(1024, b'%')
  fn str(fmt : Bytes, data : Array[&Format]) -> String raise {
    let offset = format_write(fmt, data, buffer, 0)
    memory_to_string(buffer, offset)
  }

  inspect(
    try? str(b"hello {} world", []),
    content=(
      #|Err(DebugError("data.length() mismatch with placeholder's count"))
    ),
  )
  inspect(
    try? str(b"hello {} world", [1, 2]),
    content=(
      #|Err(DebugError("data.length() mismatch with placeholder's count"))
    ),
  )
}
