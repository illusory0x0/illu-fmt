// ///|
// // use for testing
// fn buffer_to_bytes(xs : ArrayView[Byte], ofs : Int) -> Bytes {
//   Bytes::makei(ofs, i => xs[i])
// }

// ///|
// /// use for testing 
// fn[T : Format] to_bytes(buffer : ArrayView[Byte], val : T) -> Bytes {
//   let offset = Format::write(val, buffer)
//   buffer_to_bytes(buffer, offset)
// }

// ///|
// // use for testing 
// fn ascii_bytes_to_string(bs : Bytes) -> String {
//   let buf = StringBuilder::new()
//   for b in bs {
//     buf.write_char(b.to_char())
//   }
//   buf.to_string()
// }

// ///|
// fn[T : Format] to_string(b : ArrayView[Byte], v : T) -> String {
//   ascii_bytes_to_string(to_bytes(b, v))
// }

// fn memory_to_string(memory : Memory, end : Int) -> String {
//   let buf = StringBuilder::new()
//   for i in 0..<end {
//     buf.write_char(memory[i].to_char())
//   }
//   buf.to_string()
// }
