pwd
cp /proc/asound/card0/codec* .
sudo cp -R /sys/firmware/acpi/tables .

if [[ -f 'codec#0' ]];then
sudo chmod a+x verbit.sh
./verbit.sh 'codec#0' > ALC_dump.txt
fi
