# Create a Wordpress / MySQL deployment

https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-disk

## 1. Create the PersistentVolumeClaims

```
kubectl apply -f mysql-vc.yaml
kubectl apply -f wordpress-vc.yaml
```

### Check status

```
kubectl get pvc
```

## 2. Create MySQL

```
sh ./secret.sh
kubectl create -f mysql.yaml
```

### Check status

```
kubectl get pod -l app=mysql
```

## 3. Create the MySQL Service

```
kubectl create -f mysql-service.yaml
```

### Check status

```
kubectl get service mysql
```

## 4. Wordpress deployment

```
kubectl create -f wordpress.yaml
```

### Check status

```
kubectl get pod -l app=wordpress
```

## 5. Expose wordpress service

```
kubectl create -f wordpress-service.yaml
```

### Check status

```
kubectl get svc -l app=wordpress
```
