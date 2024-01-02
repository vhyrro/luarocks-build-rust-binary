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

Where `<binary name>` is any binary available on [`crates.io`](https://crates.io).

For user convenience it may make sense to pack your rocks as [binary rocks](https://github.com/luarocks/luarocks/wiki/Hosting-binary-rocks) to save the user
the compilation hassle.

# Known Limitations

- Providing a version is not yet supported
- Installing to a custom directory is not yet supported
