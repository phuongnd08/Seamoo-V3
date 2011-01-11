def skip_timestamps(clazz)
  clazz.record_timestamps = false
  return_value = yield
  clazz.record_timestamps = true
  return_value
end