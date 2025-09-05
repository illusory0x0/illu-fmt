///|
pub(all) enum Right[T] {
  Right(T, width~ : Int, padding~ : Byte)
}

///|
pub impl[T : @fmt.Format] @fmt.Format for Right[T] with write(
  value : Right[T],
  buffer : @fmt.Memory,
  start : Int,
) {
  let Right(value, width~, padding~) = value
  let cnt = @fmt.Format::write(value, buffer, start)
  let padding_len = width - cnt
  if padding_len > 0 {
    let offset = start + cnt
    memory_fill(memory=buffer, start=offset, len=padding_len, value=padding)
    width
  } else {
    cnt
  }
}

///|
pub impl[T : @fmt.Format] @fmt.Format for Right[T] with count(value : Right[T]) {
  let Right(value, width~, padding~) = value
  let cnt = @fmt.Format::count(value)
  if cnt < width {
    width
  } else {
    cnt
  }
}
