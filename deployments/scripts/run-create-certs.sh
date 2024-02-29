#!/bin/bash
#
# Copyright 2019 Globo.com authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# This script will create certs to build the enviroment via Makefile.
#
if [ -d $HUSKYCI_CERT_PATH ]
then
    echo "Skipping certificate creation because \$HUSKYCI_CERT_PATH already exist."
    exit 0
else
    mkdir -p $HUSKYCI_CERT_PATH && cd $HUSKYCI_CERT_PATH
    # CA certificate
    $HUSKYCI_SCRIPTS/create-certs.sh -m ca -pw $HUSKYCI_CERT_PASSPHRASE -t . -e 900
    # Docker API server certificate
    $HUSKYCI_SCRIPTS/create-certs.sh -m server -h $HUSKYCI_DOCKERAPI_HOST -hip $HUSKYCI_DOCKERAPI_ADDR -pw $HUSKYCI_CERT_PASSPHRASE -t . -e 365
    mkdir -p docker
    cp -a ca.pem docker/
    mv server-cert.pem server-key.pem docker/
    # Docker API client certificate
    $HUSKYCI_SCRIPTS/create-certs.sh -m client -h $HUSKYCI_DOCKERAPI_HOST -pw $HUSKYCI_CERT_PASSPHRASE -t . -e 365
    mkdir -p api
    cp -a ca.pem api/
    mv cert.pem key.pem api/
    cd -
fi
