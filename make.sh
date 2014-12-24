#!/bin/bash
if [ "$CPU_JOB_NUM" = "" ] ; then
CPU_JOB_NUM=`grep -c processor /proc/cpuinfo`
fi
echo "Cleaning old files"
rm -f ../one_plus_one/zip/Tyr*
rm -f ../AK-OnePone-AnyKernel2/dtb
rm -f ../AK-OnePone-AnyKernel2/zImage
echo "Making oneplus one kernel"
DATE_START=$(date +"%s")

make clean && make mrproper

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
make -j$CPU_JOB_NUM
../AK-OnePone-AnyKernel2/tools/dtbToolCM -2 -o ../AK-OnePone-AnyKernel2/dtb -s 2048 -p ../one_plus_one/scripts/dtc/ ../one_plus_one/arch/arm/boot/
cp arch/arm/boot/zImage ../AK-OnePone-AnyKernel2/zImage
cd ../AK-OnePone-AnyKernel2/
zip -r9 `echo Tyr`.zip *
mv Tyr.zip ../one_plus_one/zip
