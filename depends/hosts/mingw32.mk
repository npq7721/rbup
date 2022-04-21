ifneq ($(shell $(SHELL) $(.SHELLFLAGS) "command -v $(host)-g++-posix"),)
mingw32_CXX := $(host)-g++-posix
endif
ifneq ($(shell $(SHELL) $(.SHELLFLAGS) "command -v $(host)-gcc-posix"),)
mingw32_CC := $(host)-gcc-posix
endif

mingw32_CFLAGS=-pipe
mingw32_CXXFLAGS=$(mingw32_CFLAGS) -static-libstdc++

mingw32_release_CFLAGS=-O2
mingw32_release_CXXFLAGS=$(mingw32_release_CFLAGS)

mingw32_debug_CFLAGS=-O1
mingw32_debug_CXXFLAGS=$(mingw32_debug_CFLAGS)

mingw32_debug_CPPFLAGS=-D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC

mingw32_cmake_system=Windows