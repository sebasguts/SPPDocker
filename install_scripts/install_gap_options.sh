#!/bin/bash -e

echo "installing gap options"

number_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

mkdir -p /opt/gap/local/pkg

sudo touch /usr/bin/gap
sudo chown spp:spp /usr/bin/gap
sudo chmod 0755 /usr/bin/gap
cat > /usr/bin/gap <<EOF
#!/bin/bash
/opt/gap/bin/gap.sh -l "/opt/gap/local;/opt/gap" "\$@"
EOF

sudo touch /usr/bin/gapL
sudo chown spp:spp /usr/bin/gapL
sudo chmod 0755 /usr/bin/gapL
cat > /usr/bin/gapL <<EOF
#!/bin/bash
/opt/gap/bin/gap.sh -l "/opt/gap/local;/opt/gap" -L /opt/gap/bin/wsgap4 "\$@"
EOF

mkdir /home/spp/.gap
cat > /home/spp/.gap/gap.ini <<EOF
SetUserPreference( "UseColorPrompt", true );
SetUserPreference( "UseColorsInTerminal", true );
SetUserPreference( "HistoryMaxLines", 10000 );
SetUserPreference( "SaveAndRestoreHistory", true );
EOF
