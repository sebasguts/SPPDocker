#!/bin/bash -e

echo "installing gap options"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

mkdir -p /opt/gap/local/pkg

sudo cat > /usr/bin/gap <<EOF
#!/bin/bash
/opt/gap/bin/gap.sh -l "/opt/gap/local;/opt/gap" "\$@"
EOF
sudo chmod 0755 /usr/bin/gap

sudo cat > /usr/bin/gapL <<EOF
#!/bin/bash
/opt/gap/bin/gap.sh -l "/opt/gap/local;/opt/gap" -L /opt/gap/bin/wsgap4 "\$@"
EOF
sudo chmod 0755 /usr/bin/gapL

mkdir /home/spp/.gap
cat > /home/spp/.gap/gap.ini <<EOF
SetUserPreference( "UseColorPrompt", true );
SetUserPreference( "UseColorsInTerminal", true );
SetUserPreference( "HistoryMaxLines", 10000 );
SetUserPreference( "SaveAndRestoreHistory", true );
EOF

cd /opt/gap
wget http://www.gap-system.org/Download/CreateWorkspace.sh
chmod +x CreateWorkspace.sh
./CreateWorkspace.sh
rm CreateWorkspace.sh
