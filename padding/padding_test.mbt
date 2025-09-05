///|
test "paddint/Left" {
  let buffer = @illusory0x0/fmt.Memory::make(1024, b'%')
  fn str(data : &@illusory0x0/fmt.Format) -> String {
    let offset = @illusory0x0/fmt.Format::write(data, buffer, 1)
    memory_to_string(buffer, offset + 2)
  }

  // Original test - basic left padding with space
  inspect(
    str(@padding.Left(123456789, width=10, padding=b' ')),
    content="% 123456789%",
  )

  // Test with different padding characters
  inspect(str(@padding.Left(42, width=5, padding=b'0')), content="%000425")
  inspect(str(@padding.Left(123, width=8, padding=b'*')), content="%*****1238")
  inspect(str(@padding.Left(100, width=6, padding=b'-')), content="%---1002")

  // Test with exact width (no padding needed)
  inspect(str(@padding.Left(12345, width=5, padding=b' ')), content="%123450")

  // Test with width smaller than content (no padding)
  inspect(
    str(@padding.Left(123456789, width=5, padding=b' ')),
    content="%1234567899",
  )

  // Test with single byte
  inspect(str(@padding.Left(b'X', width=4, padding=b' ')), content="%   X5")

  // Test with zero width
  inspect(str(@padding.Left(42, width=0, padding=b' ')), content="%42 ")

  // Test with different data types
  inspect(str(@padding.Left(42, width=6, padding=b'0')), content="%0000427")
  inspect(str(@padding.Left(3.14, width=8, padding=b' ')), content="%    3.149")
  inspect(str(@padding.Left(-123, width=7, padding=b' ')), content="%   -1234")

  // Test with bytes content
  inspect(str(@padding.Left(b"hi", width=5, padding=b'#')), content="%###hi2")

  // Test with larger padding width
  inspect(
    str(@padding.Left(b'X', width=10, padding=b'.')),
    content="%.........X%",
  )

  // Test with UInt type
  inspect(str(@padding.Left(42U, width=6, padding=b'0')), content="%000042.")

  // Test with negative numbers and different padding
  inspect(str(@padding.Left(-999, width=8, padding=b'_')), content="%____-999.")

  // Test with very small positive number
  inspect(str(@padding.Left(7, width=5, padding=b'*')), content="%****79")

  // Test with bytes view
  inspect(
    str(@padding.Left(b"test"[0:2], width=6, padding=b'=')),
    content="%====te9",
  )

  // Test count method for different scenarios
  inspect(
    @illusory0x0/fmt.Format::count(@padding.Left(123, width=10, padding=b' ')),
    content="12",
  )
  inspect(
    @illusory0x0/fmt.Format::count(
      @padding.Left(123456789, width=5, padding=b' '),
    ),
    content="12",
  )
  inspect(
    @illusory0x0/fmt.Format::count(@padding.Left(12345, width=5, padding=b' ')),
    content="12",
  )

  // Test with tuple (composite type that implements Format)
  inspect(
    str(@padding.Left((42, 100), width=12, padding=b' ')),
    content="%   (42,100).%",
  )

  // Test edge case: width of 1 with single digit
  inspect(str(@padding.Left(5, width=1, padding=b'0')), content="%5 ")

  // Test with double precision numbers
  inspect(str(@padding.Left(1.5, width=6, padding=b'0')), content="%0001.5,")
}
