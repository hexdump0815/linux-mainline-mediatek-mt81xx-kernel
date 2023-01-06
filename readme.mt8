# directories:
# - /compile/doc/stable-mt - the files in this dir
# - /compile/source/linux-stable-mt8 - the kernel sources checked out from gitrepo
# - /compile/result/stable-mt - the resulting kernel, modules etc. tar.gz files
# - /compile/doc/kernel-config-options - https://github.com/hexdump0815/kernel-config-options
# name: stb-mt8 - chromebook mediatek mt818x

cd /compile/source/linux-stable-mt8

# patches for mt8183/kukui
for i in /compile/doc/stable-mt/misc.cbm/patches/v6.1/mt8183*.patch; do
  echo === $i
  patch -p1 < $i
done

# patches for mt81xx
for i in /compile/doc/stable-mt/misc.cbm/patches/v6.1/mt81xx*.patch; do
  echo === $i
  patch -p1 < $i
done

# patches to add some extra dtbs not yet in mainline to mt8183/kukui
for i in /compile/doc/stable-mt/misc.cbm/patches/v6.1/more-dtbs/*.patch; do
  echo === $i
  patch -p1 < $i
done

export ARCH=arm64
scripts/kconfig/merge_config.sh -m arch/arm64/configs/defconfig /compile/doc/kernel-config-options/chromebooks-aarch64.cfg /compile/doc/kernel-config-options/mediatek.cfg /compile/doc/kernel-config-options/docker-options.cfg /compile/doc/kernel-config-options/options-to-remove-generic.cfg /compile/doc/stable-mt/misc.cbm/options/options-to-remove-special.cfg /compile/doc/kernel-config-options/additional-options-generic.cfg /compile/doc/kernel-config-options/additional-options-aarch64.cfg /compile/doc/stable-mt/misc.cbm/options/additional-options-special.cfg
( cd /compile/doc/kernel-config-options ; git rev-parse --verify HEAD ) > /compile/doc/stable-mt/misc.cbm/options/kernel-config-options.version
make olddefconfig
./scripts/config --set-str CONFIG_LOCALVERSION "-stb-mt8"
make -j 8 Image dtbs modules
cd tools/perf
make
cd ../power/cpupower
make
cd ../../..
export kver=`make kernelrelease`
echo ${kver}
# remove debug info if there and not wanted
#find . -type f -name '*.ko' | sudo xargs -n 1 objcopy --strip-unneeded
make modules_install
mkdir -p /lib/modules/${kver}/tools
cp -v tools/perf/perf /lib/modules/${kver}/tools
cp -v tools/power/cpupower/cpupower /lib/modules/${kver}/tools
cp -v tools/power/cpupower/libcpupower.so.0.0.1 /lib/modules/${kver}/tools/libcpupower.so.0
# make headers_install INSTALL_HDR_PATH=/usr
cp -v .config /boot/config-${kver}
cp -v arch/arm64/boot/Image /boot/Image-${kver}
mkdir -p /boot/dtb-${kver}
cp -v arch/arm64/boot/dts/mediatek/mt8183*.dtb /boot/dtb-${kver}
cp -v System.map /boot/System.map-${kver}
# start chromebook special - required: apt-get install liblz4-tool vboot-kernel-utils
cp arch/arm64/boot/Image Image
lz4 -f Image Image.lz4
dd if=/dev/zero of=bootloader.bin bs=512 count=1
cp /compile/doc/stable-mt/misc.cbm/misc/cmdline cmdline
ls arch/arm64/boot/dts/mediatek/mt8183-*.dtb | xargs printf " -b %s" | xargs mkimage -D "-I dts -O dtb -p 2048" -f auto -A arm64 -O linux -T kernel -C lz4 -a 0 -d Image.lz4 kernel.itb
vbutil_kernel --pack vmlinux.kpart --keyblock /usr/share/vboot/devkeys/kernel.keyblock --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk --version 1 --config cmdline --bootloader bootloader.bin --vmlinuz kernel.itb --arch arm
cp -v vmlinux.kpart /boot/vmlinux.kpart-${kver}
rm -f Image Image.lz4 cmdline bootloader.bin kernel.itb vmlinux.kpart
# end chromebook special
cd /boot
update-initramfs -c -k ${kver}
#mkimage -A arm64 -O linux -T ramdisk -a 0x0 -e 0x0 -n initrd.img-${kver} -d initrd.img-${kver} uInitrd-${kver}
tar cvzf /compile/source/linux-stable-mt8/${kver}.tar.gz /boot/Image-${kver} /boot/System.map-${kver} /boot/config-${kver} /boot/dtb-${kver} /boot/initrd.img-${kver} /boot/vmlinux.kpart-${kver} /lib/modules/${kver}
cp -v /compile/doc/stable-mt/config.mt8 /compile/doc/stable-mt/config.mt8.old
cp -v /compile/source/linux-stable-mt8/.config /compile/doc/stable-mt/config.mt8
cp -v /compile/source/linux-stable-mt8/.config /compile/doc/stable-mt/config.mt8-${kver}
cp -v /compile/source/linux-stable-mt8/*.tar.gz /compile/result/stable-mt
