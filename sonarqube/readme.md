# Create those PVCs

```bash
kubectl apply -f sonar-data.yaml
kubectl apply -f sonar-extensions.yaml
```

# Create a Secret to store PostgreSQL password

```bash
andrei@Azure:~$ echo -n 'mediumpostgres' | base64
bWVkaXVtcG9zdGdyZXM=
```

# and create a k8s secret using YAML file

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres
type: Opaque
data:
  password: bWVkaXVtcG9zdGdyZXM=
```

# Create a SonarQube deployment
After creating PVCs and Postgres secret we are ready to deploy using the following YAML file

```bash
andrei@Azure:~$ kubectl apply -f sonar-deployment.yaml
deployment.extensions/sonarqube created
andrei@Azure:~$ kubectl get pods
NAME                         READY     STATUS    RESTARTS   AGE
sonarqube-55746f4d56-pzb57   1/1       Running   0          5m

```
You can now inspect the logs of the SonarQube pod to determine if the service is up and running

```bash
andrei@Azure:~$ kubectl logs sonarqube-55746f4d56-pzb57 --follow
....

2018.11.06 07:56:13 INFO  ce[][o.s.ce.app.CeServer] Compute Engine is operational
2018.11.06 07:56:14 INFO  app[][o.s.a.SchedulerImpl] Process[ce] is up
2018.11.06 07:56:14 INFO  app[][o.s.a.SchedulerImpl] SonarQube is up
```

# Publish SonarQube via Kubernetes Service
After SonarQube is up and running we need to create a public endpoint to access our service

```bash
andrei@Azure:~$ kubectl apply -f sonar-svc.yaml
service/sonarqube created
andrei@Azure:~$ kubectl get svc
NAME        TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
sonarqube   LoadBalancer   10.0.7.213     54.164.220.88   80:31284/TCP   13m
```