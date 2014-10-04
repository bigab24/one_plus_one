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

export ARCH=arm
export SUBARCH=arm
make franco_defconfig
make -j$CPU_JOB_NUM
echo "End of compiling kernel!"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
./build.sh
