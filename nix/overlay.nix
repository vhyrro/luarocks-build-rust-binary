{self}: final: prev: let
  luaPackage-override = luaself: luaprev: {
    luarocks-build-rust-binary = luaself.callPackage ({
      buildLuarocksPackage,
      luaOlder,
      lua-cjson,
    }:
      buildLuarocksPackage {
        pname = "luarocks-build-rust-binary";
        version = "scm-1";
        knownRockspec = "${self}/luarocks-build-rust-binary-scm-1.rockspec";
        src = self;
        disabled = luaOlder "5.1";
        propagatedBuildInputs = [
          lua-cjson
        ];
      }) {};

    vimcats = (luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-rust-binary,
    }: let
      src = fetchFromGitHub {
        owner = "lumen-oss";
        repo = "vimcats";
        rev = "v1.2.0";
        hash = "sha256-Pg6vIp/2H4YyqaGKF/pvuhsD/j3hBms/+4cAbH89oKs=";
      };
      vendorDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        name = "vimcats-1.2.0";
        hash = "sha256-EeCp1VFNFrlPmJnqthZoFBEzi4VV+U53lmXT0NmJWI8=";
      };
    in
      buildLuarocksPackage {
        pname = "vimcats";
        version = "1.2.0-1";
        knownRockspec = "${self}/fixtures/vimcats-1.2.0-1.rockspec";
        inherit src;
        cargoDeps = vendorDeps;
        nativeBuildInputs = with final; [
          cargo
          rustc
          rustPlatform.cargoSetupHook
        ];
        dontWrapLuaPrograms = true;
        propagatedBuildInputs = [
          luarocks-build-rust-binary
        ];
        disabled = luaOlder "5.1";
      }) {})
      .overrideAttrs (oa: {
      fixupPhase = ''
        if [ ! -x $out/bin/vimcats ]; then
          echo "Build did not install the vimcats binary"
          exit 1
        fi
      '';
    });
  };

  lua5_1_base = prev.lua5_1;
in {
  lua5_1 = lua5_1_base.override {
    packageOverrides = luaPackage-override;
  };
  lua51Packages = final.lua5_1.pkgs;
}
