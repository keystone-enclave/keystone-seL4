seL4 in Keystone
==============================

Thanks to Keystone's simple memory abstraction, an off-the-shelf microkernel (i.e., seL4) can run in Keystone with a small modification.
This repository contains the patch for the kernel and `vault.sh` for building the seL4 enclave package.

The eapp is sel4test-driver which is a test suite for seL4.
To run native seL4 in RISC-V, refer to [RISC-V seL4](https://docs.sel4.systems/Hardware/RISCV.html).

Build Instruction
===============================

(1) Clone this repository

```
https://github.com/keystone-enclave/keystone-seL4
```

(2) Build multilib RISC-V toolchain configured with "--with-arch=rv64imafdc --with-abi=lp64 --enable-multilib" flags
This is because current RISC-V seL4 doesn't support hard float, and building with non-multilib toolchain will break the build.
See details in https://docs.sel4.systems/Hardware/RISCV.html 

You need to be very careful because you can end up having two toolchains in your system (one for Keystone, one for seL4).

(3) Clone seL4 (10.1.1) and apply our patch for Keystone

```
repo init -u https://github.com/seL4/sel4test-manifest.git -b refs/tags/10.1.1
repo sync
patch -d kernel -p0 < seL4_kernel_keystone.patch
```

(4) Build seL4 runtime with vault.sh script

Open `vault.sh` and change OUTPUT_DIR to your `<build_dir>/overlay/root`.

```
./vault.sh
```

The script will create `sel4test` directory under the overlay directory.
You can insert the driver, and run `./sel4test.ke` to run seL4 tests.
