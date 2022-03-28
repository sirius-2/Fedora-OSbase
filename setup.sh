#!/bin/bash

## Variables
result_dir='./Result'
tmp_dir='./tmp'
dsdt_ori='/sys/firmware/acpi/tables/DSDT'

## chmod && makedir
mkdir $result_dir $tmp_dir
sudo chmod -R 777 .

## Get DSDT.dsl
if [[ -f $dsdt_ori ]];then
	sudo cat $dsdt_ori > $result_dir/DSDT.dat
	cp -f iasl-prebuilt/linux/iasl iasl && sudo chmod +x ./iasl
	./iasl -d $result_dir/DSDT.dat
else
	echo '[ x ] No DSDT found'
fi

## lspci
lspci > $result_dir/lspci.txt

## Get Codec#0 for ApppleALC
cp /proc/asound/card0/codec* $tmp_dir
sudo cp -R /sys/firmware/acpi/tables $tmp_dir
if [[ -f '$tmp_dir/codec#0' ]];then
	sudo chmod a+x verbit.sh
	./verbit.sh '$tmp_dir/codec#0' > $tmp_dir/ALC_dump.txt
else
	echo '[ x ] No codec#0 found'
fi

## cp files & zip
cp -f 'codec#0' $result_dir
cp -f 'ALC_dump.txt' $result_dir
cd ..
zip -q -r $result_dir OpenCoreBase.zip

## More FakeEC
cat<<EOF
[ - ] More eg.: FakeEC
                  https://github.com/corpnewt/SSDTTime
[ √ ] Done
EOF