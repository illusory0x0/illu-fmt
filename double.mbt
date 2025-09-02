///|
pub impl Format for Double with write(value, buffer, offset) {
  let repr = ryu_to_repr(value)
  match repr {
    Nan => memcpy(buffer, offset, b"NaN")
    Negative(Zero) => memcpy(buffer, offset, b"0")
    Negative(Infinity) => memcpy(buffer, offset, b"-Infinity")
    Negative(Normal(v)) =>
      write_floating_decimal64_to_memory(buffer, offset, v, true)
    Positive(Zero) => memcpy(buffer, offset, b"0")
    Positive(Infinity) => memcpy(buffer, offset, b"Infinity")
    Positive(Normal(v)) =>
      write_floating_decimal64_to_memory(buffer, offset, v, false)
  }
}

///|
/// upper bound
pub impl Format for Double with count(self) -> Int {
  50
}
