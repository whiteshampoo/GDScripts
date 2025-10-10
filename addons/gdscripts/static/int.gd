class_name INT
## Constants for variable-type [int]


# https://github.com/godotengine/godot-proposals/issues/2411#issuecomment-791928063
const U_8_MAX  = (1 << 8)  - 1 # 255
const U_16_MAX = (1 << 16) - 1 # 65535
const U_32_MAX = (1 << 32) - 1 # 4294967295

const S_8_MIN  = -(1 << 7)  # -128
const S_16_MIN = -(1 << 15) # -32768
const S_32_MIN = -(1 << 31) # -2147483648
const S_64_MIN = -(1 << 63) # -9223372036854775808

const S_8_MAX  = (1 << 7)  - 1 # 127
const S_16_MAX = (1 << 15) - 1 # 32767
const S_32_MAX = (1 << 31) - 1 # 2147483647
const S_64_MAX = (1 << 63) - 1 # 9223372036854775807
