if [ $# -gt 0 ]; then
echo $1 > .version
fi
make -j6
../AK-OnePone-AnyKernel2/tools/dtbToolCM -2 -o ../AK-OnePone-AnyKernel2/dtb -s 2048 -p ../one_plus_one/scripts/dtc/ ../one_plus_one/arch/arm/boot/
cp arch/arm/boot/zImage ../AK-OnePone-AnyKernel2/zImage
cd ../AK-OnePone-AnyKernel2/
zip -r9 `echo Tyr`.zip *
mv Tyr.zip ../one_plus_one/zip
