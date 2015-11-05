#!/bin/bash -e

echo "installing gap options"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

cd /opt/gap
mkdir local
cd local
mkdir pkg
sudo bash -c "echo '#!/bin/bash' > /usr/bin/gap"
sudo bash -c "echo '/opt/gap/bin/gap.sh -l \"/opt/gap/local;/opt/gap\" \"\$@\"' >> /usr/bin/gap"
sudo chmod +x /usr/bin/gap
sudo bash -c "echo '#!/bin/bash' > /usr/bin/gapL"
sudo bash -c "echo '/opt/gap/bin/gap.sh -l \"/opt/gap/local;/opt/gap\" -L /opt/gap/bin/wsgap4 \"\$@\"' >> /usr/bin/gapL"
sudo chmod +x /usr/bin/gapL
mkdir /home/spp/.gap
echo 'SetUserPreference( "UseColorPrompt", true );' > /home/spp/.gap/gap.ini
echo 'SetUserPreference( "UseColorsInTerminal", true );' >> /home/spp/.gap/gap.ini
echo 'SetUserPreference( "HistoryMaxLines", 10000 );' >> /home/spp/.gap/gap.ini
echo 'SetUserPreference( "SaveAndRestoreHistory", true );' >> /home/spp/.gap/gap.ini
cd /opt/gap
wget http://www.gap-system.org/Download/CreateWorkspace.sh
chmod +x CreateWorkspace.sh
./CreateWorkspace.sh
rm CreateWorkspace.sh
