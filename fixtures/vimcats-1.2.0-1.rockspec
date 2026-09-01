rockspec_format = "3.0"
package = "vimcats"
version = "1.2.0-1"

source = {
  url = "https://github.com/lumen-oss/vimcats/archive/refs/tags/v1.2.0.tar.gz",
  dir = "vimcats-1.2.0",
}

dependencies = {
  "lua >= 5.1",
}

build = {
  type = "rust-binary",
  package = "vimcats",
  features = { "cli" },
}
