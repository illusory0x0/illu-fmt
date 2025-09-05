///|
pub(all) enum Center[T] {
  Center(T, width~ : Int, padding~ : Byte)
}

///|
pub impl[T : @fmt.Format] @fmt.Format for Center[T] with write(
  value : Center[T],
  buffer : @fmt.Memory,
  start : Int,
) {
  let Center(value, width~, padding~) = value
  let cnt = @fmt.Format::write(value, buffer, start)
  let padding_len = width - cnt
  if padding_len > 0 {
    let left_padding_len = padding_len / 2
    let right_padding_len = padding_len - left_padding_len
    memory_copy_backward(
      dst=buffer,
      dst_start=start + left_padding_len,
      src=buffer,
      src_start=start,
      len=cnt,
    )
    memory_fill(memory=buffer, start~, len=left_padding_len, value=padding)
    memory_fill(
      memory=buffer,
      start=start + left_padding_len + cnt,
      len=right_padding_len,
      value=padding,
    )
    width
  } else {
    cnt
  }
}

///|
pub impl[T : @fmt.Format] @fmt.Format for Center[T] with count(
  value : Center[T],
) {
  let Center(value, width~, padding~) = value
  let cnt = @fmt.Format::count(value)
  if cnt < width {
    width
  } else {
    cnt
  }
}
