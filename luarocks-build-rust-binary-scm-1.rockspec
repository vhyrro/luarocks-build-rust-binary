local _MODREV, _SPECREV = "scm", "-1"
rockspec_format = "3.0"
package = "luarocks-build-rust-binary"
version = _MODREV .. _SPECREV

dependencies = {
    "lua >= 5.1",
    "lua-cjson ~> 2",
}

test_dependencies = {
    "lua >= 5.1",
}

source = {
    url = "git://github.com/mrcjkb/" .. package,
}
