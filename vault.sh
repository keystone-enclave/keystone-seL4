#!/bin/bash

set -e

################################################################
#                   Replace the variables                      #
################################################################
NAME=sel4test
VAULT_DIR=`dirname $0`
OUTPUT_DIR=$KEYSTONE_SDK_DIR/../buildroot_overlay/root/$NAME
SEL4_KERNEL=build/kernel/kernel.elf
PACKAGE_FILES="build/projects/sel4test/apps/sel4test-driver/sel4test-driver \
               host/runner \
               $SEL4_KERNEL"
PACKAGE_SCRIPT="./runner sel4test-driver kernel.elf"

################################################################
#                       Sanity Check                           #
################################################################

# check if KEYSTONE_SDK_DIR is set
if [[ $KEYSTONE_SDK_DIR = "" ]]; then
  echo "KEYSTONE_SDK_DIR is not set"
  exit 1
fi

if [[ ! -d $KEYSTONE_SDK_DIR ]]; then
  echo "Invalid KEYSTONE_SDK_DIR '$KEYSTONE_SDK_DIR'"
  exit 1
fi

# check if riscv tools are in PATH
if ! (
  $(command -v riscv64-unknown-elf-g++ > /dev/null) &&
  $(command -v riscv64-unknown-elf-gcc > /dev/null)
  ); then
  echo "riscv tools are not in PATH"
  exit 1
fi

# check if OUTPUT_DIR is set
if [[ $OUTPUT_DIR = "" ]]; then
  echo "OUTPUT_DIR is not set"
  exit 1
fi

################################################################
#                       Build Enclave                          #
################################################################

# create a build directory
OUTPUT_FILES_DIR=$OUTPUT_DIR/files
mkdir -p $OUTPUT_FILES_DIR

# build the app
pushd $VAULT_DIR
make -C host
mkdir -p build
cd build
../init-build.sh -DPLATFORM=spike -DRISCV64=TRUE
ninja
cd ..
for output in $PACKAGE_FILES; do
  cp $output $OUTPUT_FILES_DIR
done
popd

# create vault archive & remove output files
makeself --noprogress "$OUTPUT_FILES_DIR" "$OUTPUT_DIR/$NAME.ke" "Keystone vault archive" $PACKAGE_SCRIPT
#rm -rf $OUTPUT_FILES_DIR
