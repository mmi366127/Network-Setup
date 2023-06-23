# LDAP settings

## install LDAP
[install LDAP on ubuntu](https://ubuntu.com/server/docs/service-ldap)

- ``sudo apt install slapd ldap-utils``

- configure LDAP with ``sudo dpkg-reconfigure slapd``

````=bash
dpkg-reconfigure slapd
> no
> DNS: loli
> Organization: loli
> Administrator password
> Confirm password
> Do you want the database to be removed when slapd is purged? yes
> Move old database? no
````
- update ``/etc/ldap/ldap.conf``

````
BASE    dc=loli
URI     ldap://ldap.loli
````

- check status

````
service slapd status
journalctl -u slapd
tail -f /var/log/syslog
````

- check user

````
ldapwhoami -D "cn=admin,dc=loli" -W
ldapwhoami -Y EXTERNAL -H ldapi:///
````

- check config

````
ldapsearch -Y EXTERNAL -H ldapi:/// -o ldif-wrap=no -b "cn=config" | less
````

## Sign CA for LDAP over TLS

- sign CA and server key and cert

````=bash
# CA
openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -keyout ca.key -x509 -days 3650 -out ca.cert -subj "/CN=loli"
# cert
openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -keyout server.key -out server.req -subj "/CN=ldap.loli"

openssl x509 -req -in server.req -days 3650 -CA ca.cert -CAkey ca.key -CAcreateserial -out server.cert

openssl verify -show_chain -CAfile ca.cert server.cert
````

- move file and set owner

````=bash
sudo mv server.key /etc/ssl/private/
sudo mv ca.key /etc/ssl/private/

sudo mv ca.cert /etc/ssl/certs/
sudo mv server.cert /etc/ssl/certs/

sudo chown :ssl-cert /etc/ssl/private/server.key
sudo chown :ssl-cert /etc/ssl/private/ca.key

sudo chmod 640 /etc/ssl/private/server.key
````

- update trusted CA

````=bash
ln -s /etc/ssl/certs/ca.cert /usr/local/share/ca-certificates/ca.crt
update-ca-certificates
````

## Force using TLS

````=bash
# Update config
ldapmodify -Y EXTERNAL -H ldapi:///
dn: cn=config
changetype: modify
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/ssl/certs/ca.cert
-
add: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ssl/certs/server.cert
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ssl/private/server.key

# test TLS
ldapwhoami -H ldap://ldap.loli -x -ZZ

# Force using TLS
ldapmodify -Y EXTERNAL -H ldapi:///
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcSecurity
olcSecurity: tls=1

# Test if forcing TLS
ldapsearch -H ldap://ldap.loli -x -LLL
````

## Create User

- Create ssh object class

````=bash
# Add ssh object class to schema
ldapadd -Y EXTERNAL -H ldapi:///
dn: cn={4}opensshLPK,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: {4}opensshLPK
olcAttributeTypes: ( 1.3.6.1.4.1.24552.500.1.1.1.13 NAME 'sshPublicKey' DESC 'OpenSSH Public key' EQUALITY octetStringMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.40 )
olcObjectClasses: ( 1.3.6.1.4.1.24552.500.1.1.2.0 NAME 'ldapPublicKey' SUP top AUXILIARY DESC 'OpenSSH LPK objectclass' MUST uid MAY sshPublicKey )

# set ACL for 
ldapmodify -Y EXTERNAL -H ldapi:///
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {2}to attrs=sshPublicKey by self write by * read
````

- Create ``ou=People`` and ``ou=Group``

````=bash
ldapadd -D "cn=admin,dc=loli" -W -ZZ

dn: ou=Group,dc=loli
objectclass: organizationalUnit
ou: Group

dn: ou=People,dc=loli
objectclass: organizationalUnit
ou: People
````

- add user

````=bash
dn: uid=<userName>,ou=People,dc=loli
objectclass: account
objectclass: posixAccount
objectclass: shadowAccount
objectclass: ldapPublicKey
cn: <userName>
uid: <userName>
uidNumber: <uid>
gidNumber: <gid>
homeDirectory: /home/<userName>
userPassword: <password>
sshPublicKey: <ssh-key>
````
