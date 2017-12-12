# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/fcgi-2.4.1-SNAP-0910052249)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/FastCGI-Archives/FastCGI.com/raw/master/original_snapshot/fcgi-2.4.1-SNAP-0910052249.tar.gz"
    FILENAME "fcgi-2.4.1-SNAP-0910052249.tar.gz"
    SHA512 7ae7542ef0934f44d8c7a120366a5cd92639d0bc283a16be320c9218a73a0302c961cc004074e3915209690f1e2b67fc234c9ba55d35af11e31566d79f081c87
)
vcpkg_extract_source_archive(${ARCHIVE})

# Since libfcgi uses automake, make and configure, we use a custom CMake file
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-fix-dllexport.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.TERMS DESTINATION ${CURRENT_PACKAGES_DIR}/share/libfcgi RENAME copyright)

# clean out the debug include
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
