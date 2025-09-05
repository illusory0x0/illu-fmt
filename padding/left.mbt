///|
pub(all) enum Left[T] {
  Left(T, width~ : Int, padding~ : Byte)
}

///|
pub impl[T : @fmt.Format] @fmt.Format for Left[T] with write(
  value : Left[T],
  buffer : @fmt.Memory,
  start : Int,
) {
  let Left(value, width~, padding~) = value
  let cnt = @fmt.Format::write(value, buffer, start)
  let padding_len = width - cnt
  if padding_len > 0 {
    memory_copy_backward(
      dst=buffer,
      dst_start=start + padding_len,
      src=buffer,
      src_start=start,
      len=cnt,
    )
    memory_fill(memory=buffer, start~, len=padding_len, value=padding)
    width
  } else {
    cnt
  }
}

///|
pub impl[T : @fmt.Format] @fmt.Format for Left[T] with count(value : Left[T]) {
  let Left(value, width~, padding~) = value
  let cnt = @fmt.Format::count(value)
  if cnt < width {
    width
  } else {
    cnt
  }
}
