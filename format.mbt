///|
/// if contract is violated, behavior is undefined
pub(open) trait Format {
  /// Write the `value` into `buffer` as the `start` position,
  /// and return the number of bytes written.
  ///
  /// The number of bytes written must not exceed count().
  write(value : Self, buffer : Memory, start : Int) -> Int
  /// Upper bound on the number of bytes written
  count(value : Self) -> Int
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
pub fn format_write(
  format : Bytes,
  data : Array[&Format],
  buffer : Memory,
  start : Int,
) -> Int raise {
  match find_first_placeholder(format) {
    None => {
      guard format.length() <= buffer.length() else { fail("out of bound") }
      guard data.length() == 0 else {
        raise DebugError("data.length() mismatch with placeholder's count")
      }
      Format::write(format, buffer, start)
    }
    Some(prefix_fst_end) => {
      let prefix = format[0:prefix_fst_end]
      let rest = format[prefix_fst_end + 2:]
      let (snippets, count) = split_format(rest)
      guard data.length() == count else {
        raise DebugError("data.length() mismatch with placeholder's count")
      }
      let upper_bound_count = snippets.fold(init=0, (acc, x) => acc + x.length()) +
        data.fold(init=0, (acc, x) => acc + x.count())
      guard upper_bound_count < buffer.length() else { fail("out of bound") }
      let mut offset = start
      offset += Format::write(prefix, buffer, offset)
      guard data.length() == snippets.length() else {
        raise DebugError("internal error")
      }
      for i in 0..<data.length() {
        offset += Format::write(data[i], buffer, offset)
        offset += Format::write(snippets[i], buffer, offset)
      }
      offset - start
    }
  }
}

///|
suberror DebugError String derive(Show)
