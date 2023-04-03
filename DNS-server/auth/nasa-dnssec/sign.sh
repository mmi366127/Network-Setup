
ID=9

# generate ZSK (zone-signing-key)
ZSK=$(dnssec-keygen -a 13 -b 2048 -n ZONE $ID.nasa | head -2 | tail -1)

# generate KSK (key-signing-key)
KSK=$(dnssec-keygen -a 13 -b 2048 -n ZONE -f KSK $ID.nasa | head -2 | tail -1)

# add key to zone file
cp nasa.hosts.origin nasa.hosts
cat *.key >> nasa.hosts

# sign zone
dnssec-signzone -o $ID.nasa -k $KSK.key nasa.hosts $ZSK.key

# generate DS record to submit
echo "Your DS record:"
dnssec-dsfromkey $KSK.key

 


