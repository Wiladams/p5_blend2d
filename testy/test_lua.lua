local ffi = require("ffi")

local buf = ffi.new"float[10][3]"
local buftype = ffi.typeof(buf)
print(buftype)

local buf2 = ffi.cast("float*",buf)
local buf3 = ffi.cast("float",ffi.cast("void *",buf2))
