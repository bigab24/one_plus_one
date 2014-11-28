#!/bin/bash
if [ "$CPU_JOB_NUM" = "" ] ; then
CPU_JOB_NUM=`grep -c processor /proc/cpuinfo`
fi
echo "Cleaning old files"
rm -f ../one_plus_one/zip/Tyr*
rm -f ../one_plus_one/zip/boot.img
rm -f ../ram*/image-new*
rm -f ../ram*/ramdisk-new.cpio*
rm -f ../ram*/spl*/boot.img-dtb
rm -f ../ram*/spl*/boot.img-zImage
echo "Making oneplus one kernel"
DATE_START=$(date +"%s")

make clean && make mrproper

VER_NR=45
export LOCALVERSION=~Tyr.Kernel-CM12
export KBUILD_BUILD_VERSION=$VER_NR
export ARCH=arm
export SUBARCH=arm
make Tyr_defconfig
make -j$CPU_JOB_NUM
echo "End of compiling kernel!"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

if [ $# -gt 0 ]; then
echo $1 > .version
fi
make -j6
../ramdisk_one_plus_one/dtbToolCM -2 -o ../ramdisk_one_plus_one/split_img/boot.img-dtb -s 2048 -p ../one_plus_one/scripts/dtc/ ../one_plus_one/arch/arm/boot/
cp arch/arm/boot/zImage ../ramdisk_one_plus_one/split_img/boot.img-zImage
cd ../ramdisk_one_plus_one/
./repackimg.sh
cd ../one_plus_one/
zipfile="TyrV$VER_NR.zip"
echo "making zip file"
cp ../ramdisk_one_plus_one/image-new.img zip/boot.img
cd zip/
rm -f *.zip
zip -r -9 $zipfile *
rm -f /tmp/*.zip
cp *.zip /tmp
