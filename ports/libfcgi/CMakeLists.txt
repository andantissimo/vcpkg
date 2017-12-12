cmake_minimum_required(VERSION 3.4)

project(libfcgi C CXX)

configure_file(fcgi_config.h.in ${CMAKE_CURRENT_SOURCE_DIR}/include/fcgi_config.h)
file(READ include/fcgi_config.h fcgi_config)
string(REPLACE "#undef HAVE_FPOS" "#define HAVE_FPOS 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_LIMITS_H" "#define HAVE_LIMITS_H 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_MEMORY_H" "#define HAVE_MEMORY_H 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_STDINT_H" "#define HAVE_STDINT_H 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_STDLIB_H" "#define HAVE_STDLIB_H 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_STREAMBUF_CHAR_TYPE" "#define HAVE_STREAMBUF_CHAR_TYPE 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_STRERROR" "#define HAVE_STRERROR 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef HAVE_STRING_H" "#define HAVE_STRING_H 1" fcgi_config "${fcgi_config}")
string(REPLACE "#undef STDC_HEADERS" "#define STDC_HEADERS 1" fcgi_config "${fcgi_config}")
file(WRITE include/fcgi_config.h "${fcgi_config}")

include_directories(include)

if(BUILD_SHARED_LIBS)
    add_definitions(-DDLLAPI=__declspec(dllexport))
else()
    add_definitions(-DDLLAPI=)
endif()
add_definitions(-D_CRT_SECURE_NO_WARNINGS)

add_library(libfcgi
    libfcgi/fcgi_stdio.c
    libfcgi/fcgiapp.c
    libfcgi/fcgio.cpp
    libfcgi/os_win32.c
)
target_link_libraries(libfcgi)

install(TARGETS libfcgi
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(FILES
    include/fastcgi.h
    include/fcgi_config.h
    include/fcgi_stdio.h
    include/fcgiapp.h
    include/fcgimisc.h
    include/fcgio.h
    include/fcgios.h
    DESTINATION include
)
