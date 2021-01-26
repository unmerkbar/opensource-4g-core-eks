#!/usr/bin/env bash

#Script written to install the pre-requisite resources that are needed

echo -e "Creating open5gs namespace....\n"

echo

kubectl create ns open5gs

echo -e "Creating the needed certificates....\n"

echo

cd ca-tls-certificates

kubectl -n open5gs create secret generic mongodb-ca --from-file=rds-combined-ca-bundle.pem

kubectl -n open5gs create secret generic diameter-ca --from-file=cacert.pem

kubectl -n open5gs create secret tls hss-tls \
  --cert=hss.cert.pem \
  --key=hss.key.pem
  
kubectl -n open5gs create secret tls mme-tls \
  --cert=mme.cert.pem \
  --key=mme.key.pem

kubectl -n open5gs create secret tls pcrf-tls \
  --cert=pcrf.cert.pem \
  --key=pcrf.key.pem

kubectl -n open5gs create secret tls smf-tls \
  --cert=smf.cert.pem \
  --key=smf.key.pem

echo -e "Installing multus daemonset\n"  

echo

kubectl apply -f https://github.com/intel/multus-cni/raw/master/images/multus-daemonset.yml

cd ..

echo -e "Creating the multus network attachments\n"

echo

kubectl apply -f multus-networks/

echo -e "Creating RBAC entries and deployments for the required controllers\n"

echo

kubectl apply -f controllers/rbac/

kubectl apply -f controllers/deployments/

echo -e "The pre-requisite resources have been installed, see below for the status\n"

echo

kubectl get -n kube-system po

echo

kubectl -n open5gs get secret

echo "You can now proceed to install the Helm chart"