-- NOTE: This file takes the code from [here](https://github.com/khvzak/luarocks-build-rust-mlua/blob/main/src/luarocks/build/rust-mlua.lua)
-- as a template!

local fs = require("luarocks.fs")
-- local cfg = require("luarocks.core.cfg")
-- local dir = require("luarocks.dir")
-- local path = require("luarocks.path")

local rust_build = {}

function rust_build.run(rockspec, _)
    assert(rockspec:type() == "rockspec")

    if not fs.is_tool_available("cargo", "Cargo") then
        return nil, "'cargo' is not installed.\n" .. "This rock uses a binary written in Rust: make sure you have a Rust\n" ..
            "development environment installed and try again."
    end

    local features = {}
    local cmd = {"cargo install --root . --bins"}

    if not rockspec.build then
        return
    end

    -- Add additional features
    if type(rockspec.build.features) == "table" then
        for _, feature in ipairs(rockspec.build.features) do
            table.insert(features, feature)
        end
    elseif type(rockspec.build.features) == "string" then
        table.insert(features, rockspec.build.features)
    end

    assert(type(rockspec.build.binary) == "string", "Expected a `build.binary` variable of type string in the rockspec!")

    table.insert(cmd, rockspec.build.binary)

    if not fs.execute(table.concat(cmd, " ")) then
        return nil, "Installation failed."
    end

    return true
end

return rust_build
