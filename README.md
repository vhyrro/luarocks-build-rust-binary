# Rust Binary Bundler for Luarocks

This module compiles a Rust binary from the rock's source tree using `cargo install`.
The compiled binary is placed into a `bin/` subdirectory in the luarocks tree.

# Usage

Within your rockspec supply the following build step:

```lua
build = {
    type = "rust-binary",
    package = "<cargo package name>", -- (optional)
}
```

`package` is the name of the cargo package to build. It is only required when the
source is a workspace containing multiple packages; for a single-package source it may be
omitted and the source directory is used directly.

You may also enable cargo features:

```lua
build = {
    type = "rust-binary",
    package = "<cargo package name>",
    features = { "extra", "features" },
}
```

For user convenience it may make sense to pack your rocks as [binary rocks](https://github.com/luarocks/luarocks/wiki/Hosting-binary-rocks) to save the user
the compilation hassle.

# Known Limitations

- Installing to a custom directory is not yet supported.
