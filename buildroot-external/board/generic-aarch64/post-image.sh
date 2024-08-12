#!/bin/sh

# Stop on error
set -e

BOARD_DIR="$(dirname "$0")"
#BOARD_NAME="$(basename "${BOARD_DIR}")"

# Use our own cmdline.txt
cp "${BOARD_DIR}/cmdline.txt" "${BINARIES_DIR}/"

#
# Create user filesystem
#
echo "Create user filesystem"
mkdir -p "${BUILD_DIR}/userfs"
touch "${BUILD_DIR}/userfs/.doFactoryReset"
rm -f "${BINARIES_DIR}/userfs.ext4"
"${HOST_DIR}/sbin/mkfs.ext4" -d "${BUILD_DIR}/userfs" -F -L userfs -I 256 -E lazy_itable_init=0,lazy_journal_init=0 "${BINARIES_DIR}/userfs.ext4" 3000

#
# VERSION File
#
cp "${TARGET_DIR}/boot/VERSION" "${BINARIES_DIR}"

# copy our grub.cfg to the EFI dir
cp -a "${BOARD_DIR}/grub.cfg" "${BINARIES_DIR}/efi-part/EFI/BOOT/"

# create *.img file using genimage
support/scripts/genimage.sh -c "${BOARD_DIR}/genimage.cfg"
