@external(javascript, "../../perf_ffi.mjs", "start")
pub fn start() -> Int {
  panic as "Not implemented for any targets other than javascript"
}

@external(javascript, "../../perf_ffi.mjs", "stop")
pub fn stop(start_time: Int) -> Int {
  let _ = start_time
  panic as "Not implemented for any targets other than javascript"
}

@external(javascript, "../../perf_ffi.mjs", "split_test")
pub fn split_test(input: String) -> String {
  input
}
