#!/bin/bash

## Variables
cDir=`pwd`
tmp_dir="$cDir/tmp"
dsdt_ori='/sys/firmware/acpi/tables/DSDT'

## makedir
if [[ ! -d $tmp_dir ]];then mkdir -p $tmp_dir;else sudo rm -rf $tmp_dir && mkdir $tmp_dir;fi
rm -f *.zip

## Get DSDT.dsl
if [[ -f $dsdt_ori ]];then
	sudo cp -R /sys/firmware/acpi/tables $tmp_dir
	cp -f iasl-prebuilt/linux/iasl iasl && sudo chmod +x ./iasl
else
	echo '[ x ] No DSDT found'
fi

## lspci
lspci > $tmp_dir/lspci.txt

## Get Codec#0 for ApppleALC
sudo cp /proc/asound/card0/codec* $tmp_dir
cp verbit.sh $tmp_dir
sudo chmod a+x $tmp_dir/verbit.sh

### Handle
sudo chmod -R 777 $tmp_dir
./iasl -d $tmp_dir/tables/DSDT
cd $tmp_dir
if [[ -f 'codec#0' ]];then
	./verbit.sh 'codec#0' > ALC_dump.txt
else
	echo '[ x ] No codec#0 found'
fi

## cp files & zip
cp -f $tmp_dir/tables/DSDT.dsl $tmp_dir
zip -q -r ../OpenCoreBase.zip ./* -x=./verbit.sh
sudo rm -rf $tmp_dir
cd ..
### Handle End

## More FakeEC
clear
cat<<EOF
[ - ] More eg.: FakeEC
                  https://github.com/corpnewt/SSDTTime
[ √ ] Done
EOF