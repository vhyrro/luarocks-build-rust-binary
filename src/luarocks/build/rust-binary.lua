local fs = require("luarocks.fs")
local dir = require("luarocks.dir")
local builtin_build = require("luarocks.build.builtin")
local util = require("luarocks.util")
local cjson = require("cjson.safe")

local rust_build = {}

--- Locate the directory of the cargo package `package` within the source tree.
---@param package string
---@return string|nil
local function find_package_dir(package)
    local output = util.popen_read("cargo metadata --no-deps --format-version 1 2>/dev/null", "*a")
    if output == "" then
        return nil
    end
    local metadata = cjson.decode(output)
    if not metadata or not metadata.packages then
        return nil
    end
    for _, pkg in ipairs(metadata.packages) do
        if pkg.name == package then
            return dir.dir_name(pkg.manifest_path)
        end
    end
    return nil
end

function rust_build.run(rockspec, _)
    assert(rockspec:type() == "rockspec")

    if not fs.is_tool_available("cargo", "Cargo") then
        return nil,
            "'cargo' is not installed.\n"
                .. "This rock uses a binary written in Rust: make sure you have a Rust\n"
                .. "development environment installed and try again."
    end

    local cmd = { "cargo install --root . --bins" }

    if not rockspec.build then
        return
    end

    -- Add additional features
    local features = {}
    if type(rockspec.build.features) == "table" then
        for _, feature in ipairs(rockspec.build.features) do
            table.insert(features, feature)
        end
    elseif type(rockspec.build.features) == "string" then
        table.insert(features, rockspec.build.features)
    end
    if #features > 0 then
        table.insert(cmd, "--features")
        table.insert(cmd, table.concat(features, ","))
    end

    local package = rockspec.build.package
    local package_dir
    if package then
        package_dir = find_package_dir(package)
        if not package_dir then
            return nil, "Could not locate cargo package '" .. package .. "' in the source."
        end
    else
        package_dir = "."
    end

    table.insert(cmd, "--path")
    table.insert(cmd, package_dir)

    if not fs.execute(table.concat(cmd, " ")) then
        return nil, "Installation failed."
    end

    local _, install, _ = builtin_build.autodetect_modules({}, {}, {})
    rockspec.build.install = rockspec.build.install or install

    return true
end

return rust_build
