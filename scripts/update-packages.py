from typing import cast
import tomllib
import tomlkit
from tomlkit.items import Table
import os

if __name__ == "__main__":
    print(os.curdir)
    with open("pixi.toml", "rb") as f:
        config = tomllib.load(f)
    with open("pixi.toml", "r") as f:
        config_all: Table = cast(Table, tomlkit.parse(string=f.read()))

    os.rename("pixi.toml", "pixi.toml.bak")
    try:
        os.system(
            "pixi init -c https://software.repos.intel.com/python/conda -c conda-forge"
        )
        all_deps = set()
        for feature, fconfig in config["feature"].items():
            print(feature)
            for dep in fconfig.get("dependencies", {}):
                dep: str
                if "sysroot" in dep:
                    continue
                all_deps.add(dep)

        non_feature_deps = ["dependencies", "host-dependencies", "build-dependencies"]
        for dep_spec in non_feature_deps:
            for dep in config.get(dep_spec, {}):
                dep: str
                if "sysroot" in dep:
                    continue
                all_deps.add(dep)


        os.system(f"pixi add {' '.join(all_deps)}")

        with open("pixi.toml", "rb") as f:
            updated_deps = tomllib.load(f)["dependencies"]

        features_table = cast(Table, config_all["feature"])
        for feature, fconfig in config["feature"].items():
            feature_table: Table = cast(Table, features_table[feature])
            deps_table: Table = cast(
                Table, feature_table.get("dependencies", tomlkit.table())
            )
            for dep in fconfig.get("dependencies", {}):
                dep: str
                if "sysroot" in dep:
                    continue
                deps_table[dep] = updated_deps[dep]

        for dep_spec in non_feature_deps:
            deps_table: Table = cast(Table, config_all[dep_spec])
            for dep in config.get(dep_spec, {}):
                dep: str
                if "sysroot" in dep:
                    continue
                deps_table[dep] = updated_deps[dep]

        with open("pixi.toml", "w") as f:
            f.write(tomlkit.dumps(config_all))

    except Exception as e:
        os.rename("pixi.toml.bak", "pixi.toml")
        raise e
