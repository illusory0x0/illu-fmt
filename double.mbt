///|
pub impl Format for Double with write(value, buffer) {
  @ryu.write_to_arrayview_byte(value, buffer)
}

///|
/// upper bound
pub impl Format for Double with count(self) -> Int {
  50
}
