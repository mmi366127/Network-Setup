
ID=9

# generate ZSK (zone-signing-key)
ZSK=$(dnssec-keygen -a 13 -b 2048 -n ZONE $ID.168.192.in-addr.arpa | head -2 | tail -1)

# generate KSK (key-signing-key)
KSK=$(dnssec-keygen -a 13 -b 2048 -n ZONE -f KSK $ID.168.192.in-addr.arpa | head -2 | tail -1)

# add key to zone file
cp nasa.rev.origin nasa.rev
cat *.key >> nasa.rev

# sign zone
dnssec-signzone -o $ID.168.192.in-addr.arpa -k $KSK.key nasa.rev $ZSK.key

# generate DS record to submit
echo "Your DS record:"
dnssec-dsfromkey $KSK.key

 


