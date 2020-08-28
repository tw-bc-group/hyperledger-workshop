#!/bin/bash

if [[ -z $1 ]] ; then
  cat <<EOF
$0 <org>

example:
$0 org1
EOF

  exit 1
fi

org=$1
subj="/C=CN/ST=Beijin/L=TW/O=$org.example.com/CN=ca.$org.example.com"
ca_home="$PWD/ca/$org/root"
cnf_template="$PWD/cnf/root-ca.cnf"


[ -d $ca_home ] || mkdir -p $ca_home;

pushd $ca_home

  mkdir certs crl newcerts private;
  cat "$cnf_template" | sed "s:^dir.*:dir = $ca_home:" > openssl.cnf
  chmod 700 private;

  touch index.txt;
  echo 1000 > serial
  echo 1000 > crlnumber

  
  openssl ecparam -name prime256v1 -genkey -noout \
    -out private/ca.key.pem
  chmod 400 private/ca.key.pem;


  openssl req -config openssl.cnf \
    -new -x509 -sha256 -extensions v3_ca \
    -key private/ca.key.pem \
    -out certs/ca.cert.pem \
    -days 3650 \
    -subj "$subj"
  chmod 444 certs/ca.cert.pem;

  openssl x509 -noout -text -in certs/ca.cert.pem;

popd
