///|
/// if contract is violated, behavior is undefined
pub(open) trait Format {
  /// The number of bytes written must not exceed count().
  write(Self, ArrayView[Byte]) -> Int

  /// Upper bound on the number of bytes written
  count(Self) -> Int
}

///|
fn find_first_placeholder(format : Bytes) -> Int? {
  loop (0, format[:]) {
    (index, []) => None
    (index, ['{', '}', .. cs]) => Some(index)
    (index, [_, .. cs]) => continue (index + 1, cs)
  }
}

///|
fn split_format(format : @bytes.View) -> (Array[@bytes.View], Int) {
  let mut count = 1
  let snippets = []
  let mut start = 0
  let mut index = 0
  loop format[:] {
    [] => snippets.push(format[start:index])
    ['{', '}', .. cs] => {
      snippets.push(format[start:index])
      start = index + 2
      index += 2
      count += 1
      continue cs
    }
    [_, .. cs] => {
      index += 1
      continue cs
    }
  }
  (snippets, count)
}

///|
pub fn write(
  buffer : ArrayView[Byte],
  format : Bytes,
  data : Array[&Format],
) -> ArrayView[Byte] raise {
  match find_first_placeholder(format) {
    None => {
      guard format.length() <= buffer.length() else { fail("out of bound") }
      guard data.length() == 0 else {
        raise DebugError("data.length() mismatch with placeholder's count")
      }
      for i in 0..<format.length() {
        buffer[i] = format[i]
      }
      buffer[0:format.length()]
    }
    Some(offset) => {
      let prefix = format[0:offset]
      let rest = format[offset + 2:]
      let (snippets, count) = split_format(rest)
      guard data.length() == count else {
        raise DebugError("data.length() mismatch with placeholder's count")
      }
      let upper_bound_count = snippets.fold(init=0, (acc, x) => acc + x.length()) +
        data.fold(init=0, (acc, x) => acc + x.count())
      guard upper_bound_count < buffer.length() else { fail("out of bound") }
      let mut offset = 0
      let mut totol_offset = 0
      for b in prefix {
        buffer[offset] = b
        offset += 1
      }
      totol_offset += offset
      let mut buf = buffer[offset:]
      for i = 0, j = 0
          i < data.length() && j < snippets.length()
          i = i + 1, j = j + 1 {
        let offset = data[i].write(buf)
        totol_offset += offset
        buf = buf[offset:]
        let offset = Format::write(snippets[j], buf)
        totol_offset += offset
        buf = buf[offset:]
      }
      buffer[0:totol_offset]
    }
  }
}

///|
fn arrayview_byte_to_string(avb : ArrayView[Byte]) -> String {
  let buf = StringBuilder::new()
  for b in avb {
    buf.write_char(b.to_char())
  }
  buf.to_string()
}

///|
suberror DebugError String derive(Show)

///|
test {
  let buffer = Array::make(1024, Byte::default())
  fn str(fmt : Bytes, data : Array[&Format]) -> String raise {
    write(buffer, fmt, data) |> arrayview_byte_to_string
  }

  inspect(
    try? str(b"hello {} world", [123]),
    content=(
      #|Ok("hello 123 world")
    ),
  )
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
  inspect(
    try? str(b"{}{}", [1, 2]),
    content=(
      #|Ok("12")
    ),
  )
  inspect(
    try? str(b"={}={}=", [1, 2]),
    content=(
      #|Ok("=1=2=")
    ),
  )
  inspect(
    try? str(b"={}={}", [1, 2]),
    content=(
      #|Ok("=1=2")
    ),
  )
  inspect(
    try? str(b"{}={}", [1, 2]),
    content=(
      #|Ok("1=2")
    ),
  )
  inspect(
    try? str(b"{}%%", [BigEndian(0x80818283)]),
    content=(
      #|Ok("%%")
    ),
  )
}
