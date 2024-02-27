# ST2DCE-PRJ - SUPERCOOL TEAM

## Prerequisites:

- docker
- kubernetes
- Jenkins with access to kubernetes
- helm

## Installation

In order to make this project run, please follow the [Setup Jenkins](#setup-jenkins) and [Setup Grafana](#setup-grafana) sections.

## Setup Jenkins

### Kubernetes credentials

Jenkins needs access to kubernetes. By default, kubernetes only allows access to its api to the main user of the cluster. We need to create a "Service Account" in order to make kubernetes accessible in pipelines.

Please start to create a service account for jenkins by running the following command:

```bash
kubectl apply -f serviceAccount.yml
```

It will also generate a token, which you can retrieve with: 


```bash
kubectl get secret jenkins-secret -o jsonpath="{.data.token}" | base64 --decode
```

You will need the token for the next part.

### Jenkins Plugins

Go to `Manage Jenkins` > `Plugins` > `Available plugins` and search for `Kubernetes CLI`. This is the only one we need.

### Add Kubernetes credentials to Jenkins

Go to `Manage Jenkins` > `Credentials` > `globals` and add a new credential:
- Select `Secret text` as the **type** of the secret
- In **secret**, paste the decoded json token of the user.
- In **ID**, paste `jenkins-credentials`.
- Click on **create**

### Create your multibranch pipeline

Click on "new item". Give a name and select "multibranches pipeline".

The configuration needs to be as follow:

- Branch Sources:
  - Github
    - Repository HTTPS URL: `https://github.com/Faust1-2/ST2DCE-PRJ`

- Build configuration: `by Jenkinsfile`
  - Script Path: `Jenkins`

Click on "save" and you can now set a build by clicking on `Scan repository now`

## Setup Grafana

### Launch Grafana

Run:
```bash
helm repo add grafana https://grafana.github.io/helm-charts
```

And then run the `prometheus-grafana.sh` script if you are on linux or mac:
```bash
./prometheus-grafana.sh
```

OR

Run:
```bash
helm upgrade --install grafana grafana/grafana --set service.type=LoadBalancer,service.port=3000 -n production
```

You can now retrieve the `admin` password:
```bash
kubectl get secret -n production grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

To access grafana, you must retrieve the pod it is running on:
```bash
kubectl get pods -n production
```

Take the pod name that contains "grafana" and replace it in the followind command: 
```bash
kubectl port-forward -n production <POD_NAME> 3000
```

### Setup your prometheus datasource

First of all, deploy your prometheus application:

```bash
kubectl apply -f prometheus.yml
```

Grafana will ask you to add a datasource. Since we are using prometheus to provide metrics about our wonderfull app, we will take a `prometheus` datasource.

You only have to provide the `prometheus server url`, where grafana will get the metrics from.

For us, it is equal to `http://prometheus-service:9090`. This is because our grafana is runned as a kubernetes deployment and service, and so, will use the internal DNS of kubernetes to retrieve the metrics.

Once you added it, try the url, it should work fine, and create a dashboard with the exported metrics on grafana.

### Setup your loki datasource

First of all, deploy your loki stack: 
```bash
helm install loki loki/loki-stack --set grafana.enabled=false --namespace=production
```

Let's head one more time to the data sources. This time, we will look for a `loki` datasource.
In the URL field, pase `http://loki:3100`. You can now click on "Save and test". Even if the test fail, it should be fine.

You can now access the logs from loki in the "Explorer" and "Dashboard" views. 