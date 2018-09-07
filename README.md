# k8s-cluster
Deploy a k8s cluster

## Installation of gcloud SDK

cd google-cloud-sdk
./install.sh
gcloud init

## Creation of the k8s cluster

TODO

## List & Access k8s cluster

```
gcloud container clusters list
gcloud container clusters get-credentials cluster-1
gcloud config set compute/global
gcloud config set compute/zone europe-west1-b
gcloud container clusters get-credentials cluster-1
kubectl get pods
```

## Creation of static IP

https://cloud.google.com/kubernetes-engine/docs/tutorials/configuring-domain-name-static-ip

```
gcloud compute addresses create public-ingress --global
gcloud compute addresses describe public-ingress --global
```

## Add SSL cert-manager for Certificate issuing

https://github.com/jetstack/cert-manager

ingress :  traeffic via helm.
service / annotation pour que traeffic prenne.

## Ingress

https://docs.traefik.io/user-guide/kubernetes/

### Helm initialization and installation

https://cloud.google.com/community/tutorials/nginx-ingress-gke

```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'      
helm init --service-account tiller --upgrade
```

### Ingress itself

```
helm install --values values.yml stable/traefik
```

https://medium.com/google-cloud/global-ingress-in-practice-on-google-container-engine-part-1-discussion-ccc1e5b27bd0

watch the status :

```
kubectl get svc fashionable-kudu-traefik --namespace default -w
```

## Deploy a service

https://github.com/kelseyhightower/ingress-with-static-ip

```
kubectl run nginx --image nginx:1.11 --port 80 --replicas=3

kubectl expose deployment nginx --type NodePort
kubectl expose deployment DEPLOYMENT --type=LoadBalancer
```

## Deploy the ingress

 kubectl create -f ingress.yml

## FINAL THOUGHTS

https://cloud.google.com/community/tutorials/nginx-ingress-gke

```
kubectl run hello-app --image=gcr.io/google-samples/hello-app:1.0 --port=8080
kubectl expose deployment hello-app
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true
kubectl get service nginx-ingress-controller
curl -I http://35.240.18.83
curl -I http://35.240.18.83/healthz
kubectl apply -f ingress3.yml
kubectl get ingress ingress-resource
curl -I http://35.240.18.83/hello
curl http://35.240.18.83/hello
kubectl get ingress ingress-resource
```
