seL4 in Keystone
==============================

Thanks to Keystone's simple memory abstraction, an off-the-shelf microkernel (i.e., seL4) can run in Keystone with a small modification.
This repository contains the patch for the kernel and `vault.sh` for building the seL4 enclave package.

The eapp is sel4test-driver which is a test suite for seL4.
To run native seL4 in RISC-V, refer to [RISC-V seL4](https://docs.sel4.systems/Hardware/RISCV.html).

Build Instruction
===============================

See [Build Enclave with seL4](https://docs.keystone-enclave.org/Getting-Started/Tutorials/Build-Enclave-App-seL4.html).
