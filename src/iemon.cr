require "./lib_shm"
require "./exceptions"
require "./object"
require "./primitives"
require "./property"

include Iemon::Primitives
#
# Override primitive types so that they can respond to `detach` and `clean`.
# These method do nothing.
#
define_struct
define_class
