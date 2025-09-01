# illusory0x0/fmt

A destination passing style formatting library for MoonBit with extensible API design and efficient memory management.

## Key Features

### 1. Destination Passing Style API

This library implements a destination passing style API where you provide a buffer, and the formatting functions write directly into it. This approach eliminates intermediate allocations and provides predictable memory usage.

```moonbit
test "basic formatting" {
  let buffer = Array::make(1024, Byte::default())
  fn str(fmt : Bytes, data : Array[&Format]) -> String raise {
    let offset = @fmt.write(buffer, fmt, data) 
    ascii_bytes_to_string_helper(buffer[0:offset])
  }

  inspect(try? str(b"hello {} world", [123]), content="Ok(\"hello 123 world\")")
}

fn ascii_bytes_to_string_helper(avb : ArrayView[Byte]) -> String {
  let buf = StringBuilder::new()
  for b in avb {
    buf.write_char(b.to_char())
  }
  buf.to_string()
}
```

### 2. Memory Allocation with `count`

The API uses a `count()` method to provide an upper bound on the number of bytes that will be written. This allows users to allocate appropriately sized buffers upfront.

```moonbit
test "count allocation" {
  let value = 12345
  let buffer_size = Format::count(value)
  let buffer = Array::make(buffer_size, Byte::default())
  let written = Format::write(value, buffer)
  inspect(written <= buffer_size, content="true")
}
```

### 3. Write Method with Return Size

The `write` method writes data to the provided buffer and returns the actual number of bytes written, which may be less than the `count()` upper bound.

```moonbit
test "write with return size" {
  let buffer = Array::make(10, Byte::default())
  let written = Format::write(42, buffer)
  inspect(written, content="2") // "42" uses 2 bytes
}
```

### 4. Bump Pointer Memory Management

The library uses a simple bump pointer allocation strategy within the provided buffer. Memory is allocated sequentially, making it very fast and predictable.

### 5. Extensible API Design

The library features an extensible API design using a clever trait implementation pattern that allows different behavior for different type instances.

## Extensible API Pattern

The library uses a sophisticated pattern to implement methods for generic types with different behaviors for different instances:

```mbt skip
pub(all) struct BigEndian[T](T)

pub(open) trait BigEndianFormat {
  /// The number of bytes written must not exceed count().
  write(Self, ArrayView[Byte]) -> Int
  /// Upper bound on the number of bytes written
  count(Self) -> Int
}

pub impl[T : BigEndianFormat] Format for BigEndian[T] with write(value, buffer) {
  T::write(value.inner(), buffer)
}

pub impl[T : BigEndianFormat] Format for BigEndian[T] with count(self) {
  T::count(self.inner())
}
```

### How It Works

- `BigEndian[T]` is a wrapper type that holds a value of type `T`
- `BigEndianFormat` is a trait that defines the specific behavior for big-endian formatting
- The `Format` trait is implemented for `BigEndian[T]` only when `T` implements `BigEndianFormat`
- This forwards the method calls to the specific `BigEndianFormat` implementation

This pattern allows you to:

1. Customize behavior for specific endianness formats
2. Maintain type safety
3. Provide different implementations for the same base type
4. Keep the API clean and extensible

[Read more about this trick here](https://moonbit.community/#blog-trick-impl_trait_for_generic_type_with_different_instances.mbt)

## Core API

### Format Trait

```mbt skip
pub(open) trait Format {
  /// The number of bytes written must not exceed count().
  write(Self, ArrayView[Byte]) -> Int
  /// Upper bound on the number of bytes written
  count(Self) -> Int
}
```

### Formatting Function

```mbt skip
pub fn write(
  buffer : ArrayView[Byte],
  format : Bytes,
  data : Array[&Format],
) -> ArrayView[Byte] raise
```

## Supported Types

The library provides formatting support for:

- **Basic Types**: `Int`, `UInt`, `Double`
- **Endianness Wrappers**: `BigEndian[T]`, `LittleEndian[T]`
- **Custom Types**: Through trait implementation

## Examples

### Basic Formatting

```moonbit
test "string interpolation" {
  let buffer = Array::make(1024, Byte::default())
  fn str(fmt : Bytes, data : Array[&Format]) -> String raise {
    let offset = @fmt.write(buffer, fmt, data) 
    ascii_bytes_to_string_helper(buffer[0:offset])
  }

  inspect(
    try? str(b"Value: {}, Count: {}", [42, 10]),
    content="Ok(\"Value: 42, Count: 10\")",
  )
}
```

### Endianness-Specific Formatting

```moonbit
test "endianness formatting" {
  let buffer = Array::make(8, Byte::default())
  let big_endian_int = @fmt.BigEndian(0x80818283)
  let written = Format::write(big_endian_int, buffer)
  inspect(written, content="4")
  // Buffer now contains [0x80, 0x81, 0x82, 0x83]
}
```

### Custom Type Implementation

```mbt
struct Point {
  x : Int
  y : Int
}

impl Format for Point with write(self, buf) {
  let mut offset = 0
  buf[offset] = '('
  offset += 1

  offset += Format::write(self.y, buf[offset:])

  buf[offset] = ','
  offset += 1

  offset += Format::write(self.x, buf[offset:])

  buf[offset] = ')'
  offset += 1
  offset
}

impl Format for Point with count(self) {
  3 + Format::count(self.x) + Format::count(self.y)
}

test {
  let point = Point:: { x: 1, y: 2 };
  let buffer = Array::make(1024, Byte::default());
  fn str(fmt : Bytes, data : Array[&Format]) -> String raise {
    let offset = @fmt.write(buffer, fmt, data) 
    ascii_bytes_to_string_helper(buffer[0:offset])
  }
  inspect(try? str("{}",[point]), content=(#|Ok("(2,1)")
  ))
}

```

## Error Handling

The library uses checked exceptions for error handling:

```mbt skip
suberror DebugError String derive(Show)
```

Common errors include:

- Buffer overflow when the provided buffer is too small
- Placeholder count mismatch in format strings

## Performance Benefits

1. **Zero-copy**: Direct writing to destination buffer
2. **Predictable allocation**: Upper bounds provided by `count()`
3. **Minimal overhead**: Bump pointer allocation strategy
4. **Type-safe**: Compile-time checking of format implementations
