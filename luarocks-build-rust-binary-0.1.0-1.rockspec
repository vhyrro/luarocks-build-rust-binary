rockspec_format = "3.0"
package = "luarocks-build-rust-binary"
version = "0.1.0-1"

source = {
    url = "git+https://github.com/vhyrro/luarocks-build-rust-binary",
    tag = "0.1.0",
}

description = {
    summary = "A luarocks build step allowing rocks to bundle Rust binaries with the library.",
    homepage = "https://github.com/vhyrro/luarocks-build-rust-binary",
    license = "GPLv3",
}

dependencies = {
    "lua >= 5.1"
}
