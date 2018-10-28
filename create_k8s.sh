#!/bin/bash

# spin the new cluster
gcloud config set project yesiddo-215009

gcloud beta container --project "yesiddo-215009" clusters create "alpha" --zone "europe-west1-b" --username "admin" --cluster-version "1.9.7-gke.6" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --network "projects/yesiddo-215009/global/networks/default" --subnetwork "projects/yesiddo-215009/regions/europe-west1/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard --enable-autoupgrade --enable-autorepair

# the ip adress should be in the same region
gcloud compute addresses create alpha-ip --region=europe-west1

IP=$(gcloud compute addresses describe alpha-ip --region=europe-west1 | head -n1 | awk '{print $2}')

#set-up helm part
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm init --service-account tiller --upgrade

#set-up traefik (modify the IP with the definition of the static one)
helm install -f ./alpha-values.yml stable/traefik --name traefik-lb --namespace kube-system

# Create and expose web application
kubectl run web --image=gcr.io/google-samples/hello-app:1.0 --port=8080
kubectl expose deployment web --target-port=8080 --type=NodePort

# do not forget to set the host name
kubectl apply -f ingress-resource.yml
