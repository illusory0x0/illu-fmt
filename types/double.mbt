///|
pub impl Format for Double with write(value, buffer, start) {
  let repr = ryu_to_repr(value)
  match repr {
    Nan => memcpy(buffer, start, b"NaN")
    Negative(Zero) => memcpy(buffer, start, b"0")
    Negative(Infinity) => memcpy(buffer, start, b"-Infinity")
    Negative(Normal(v)) =>
      write_floating_decimal64_to_memory(buffer, start, v, true)
    Positive(Zero) => memcpy(buffer, start, b"0")
    Positive(Infinity) => memcpy(buffer, start, b"Infinity")
    Positive(Normal(v)) =>
      write_floating_decimal64_to_memory(buffer, start, v, false)
  }
}

///|
/// upper bound
pub impl Format for Double with count(_) -> Int {
  /// https://en.cppreference.com/w/cpp/types/numeric_limits/max_digits10.html
  25
}
