///|
pub fnalias @types.(format_write, format_count)

///|
pub fnalias @types.Format::(count, write)

///|
pub fn[T] big_endian(x : T) -> @types.BigEndian[T] {
  @types.BigEndian(x)
}

///|
pub fn[T] little_endian(x : T) -> @types.LittleEndian[T] {
  @types.LittleEndian(x)
}

///|
pub fn[T] hex_lower(x : T) -> @types.HexLower[T] {
  @types.HexLower(x)
}

///|
pub fn[T] hex_upper(x : T) -> @types.HexUpper[T] {
  @types.HexUpper(x)
}

///|
pub fn[T] padding_center(
  x : T,
  width~ : Int,
  padding~ : Byte,
) -> @padding.Center[T] {
  @padding.Center(x, width~, padding~)
}

///|
pub fn[T] padding_left(
  x : T,
  width~ : Int,
  padding~ : Byte,
) -> @padding.Left[T] {
  @padding.Left(x, width~, padding~)
}

///|
pub fn[T] padding_right(
  x : T,
  width~ : Int,
  padding~ : Byte,
) -> @padding.Right[T] {
  @padding.Right(x, width~, padding~)
}

///|
pub typealias @types.Memory

///|
pub traitalias @types.Format
