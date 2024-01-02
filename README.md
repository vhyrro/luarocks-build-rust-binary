# Rust Binary Bundler for Luarocks

This module allows users to compile any arbitrary binary from `crates.io` by using `cargo install`
under the hood. 
The compiled binary is placed into the appropriate location under a `bin/` subdirectory.

# Usage

Within your rockspec supply the following build step:

```lua
build = {
    type = "rust-build",
    binary = "<binary name>",
}
```

Where `<binary name>` is any binary available on [`crates.io`](https://crates.io). If you would
like to install a specific version of the binary, set `binary` to the following (replacing
`1.0.0` with your preferred version):
```lua
build = {
    type = "rust-build",
    binary = "binary@1.0.0",
}
```

For user convenience it may make sense to pack your rocks as [binary rocks](https://github.com/luarocks/luarocks/wiki/Hosting-binary-rocks) to save the user
the compilation hassle.

# Known Limitations

- Installing many binaries is not supported.
- Installing to a custom directory is not yet supported.
