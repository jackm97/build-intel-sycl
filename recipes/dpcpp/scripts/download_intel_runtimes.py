import os
import json
import subprocess
import shutil


def run_cmd(cmd, dry_run=True, ignore_error=False):
    print(f"Running command: {cmd}")
    if dry_run:
        return
    result = subprocess.run(cmd, shell=True, check=True)
    if result.returncode != 0 and not ignore_error:
        raise subprocess.CalledProcessError(result.returncode, cmd)

    print("\n")


if __name__ == "__main__":
    dependencies_location = (
        os.environ.get("PIXI_PROJECT_ROOT", "") + "/llvm/devops/dependencies.json"
    )
    if not os.path.exists(dependencies_location):
        print("Could not find dependencies.json file")
        raise SystemError("Could not find dependencies.json file")

    with open(dependencies_location, "r") as f:
        dependencies = json.load(f)["linux"]

    required_deps = ["oclcpu", "fpgaemu", "tbb"]
    zipfiles_out = ["oclcpu.tar.gz", "fpgaemu.tar.gz", "tbb.tar.gz"]
    download_dir = os.environ.get("PIXI_PROJECT_ROOT", "") + "/deps"
    install_dir = f"{os.environ['DPCPP_ROOT']}"
    if not os.path.exists(download_dir):
        os.makedirs(download_dir)
    if not os.path.exists(install_dir):
        os.makedirs(install_dir)

    if not os.path.exists(f"{install_dir}/etc/OpenCL/vendors"):
        mkdir_cmd = f"mkdir -p {install_dir}/etc/OpenCL/vendors"
        run_cmd(mkdir_cmd, dry_run=False)

    dep_install_roots = []
    dep_install_rel_roots = []
    for dep, zipout in zip(required_deps, zipfiles_out):
        download_url = dependencies[dep]["url"]
        dep_install_root = f"{dependencies[dep]['root']}"
        dep_install_rel_root = dep_install_root.replace("{DEPS_ROOT}", "")
        dep_install_root = dep_install_root.replace("{DEPS_ROOT}", install_dir)
        if dep == "tbb":
            dep_install_root = f"{install_dir}/tbb"
        if os.path.exists(dep_install_root):
            shutil.rmtree(dep_install_root)
        os.makedirs(dep_install_root)
        dep_install_roots.append(dep_install_root)
        dep_install_rel_roots.append(dep_install_rel_root)

        download_cmd = f"wget {download_url} -O {download_dir}/{zipout}"
        install_cmd = f"tar -xzf {download_dir}/{zipout} -C {dep_install_root}"
        run_cmd(download_cmd, dry_run=False)
        run_cmd(install_cmd, dry_run=False)

        if dep == "tbb":
            dep_install_root = f"{dep_install_root}/oneapi-tbb-2021.12.0"
            dep_install_rel_root = f"{dep_install_rel_root}/oneapi-tbb-2021"
            dep_install_roots[-1] = dep_install_root
            dep_install_rel_roots[-1] = dep_install_rel_root

        if dep == "fpgaemu":
            for item in os.listdir(f"{dep_install_root}/x64"):
                if item.endswith(".so") and "libintelocl_emu" in item:
                    oclicd_cmd = f"echo {dep_install_root}/x64/{item} | tee {install_dir}/etc/OpenCL/vendors/intel_fpgaemu.icd"
                    run_cmd(oclicd_cmd, dry_run=False, ignore_error=True)
                    break

        if dep == "oclcpu":
            for item in os.listdir(f"{dep_install_root}/x64"):
                if item.endswith(".so") and "libintelocl" in item:
                    oclicd_cmd = f"echo {dep_install_root}/x64/{item} | tee {install_dir}/etc/OpenCL/vendors/intel_oclcpu.icd"
                    run_cmd(oclicd_cmd, dry_run=False, ignore_error=True)
                    break

    user = os.environ.get("USER", None)
    if not user:
        raise EnvironmentError("$USER not found")
    permissions_cmd = (
        f"sudo chown -R {user} {install_dir} && sudo chmod -R u+rwx {install_dir}"
    )
    run_cmd(permissions_cmd, dry_run=False, ignore_error=True)

    link_ocl_vendors_cmd = (
        f"ln -sf {install_dir}/etc/OpenCL/vendors/* $CONDA_PREFIX/etc/OpenCL/vendors"
    )
    run_cmd(link_ocl_vendors_cmd, dry_run=False, ignore_error=True)
