# Create configmap for prometheus config. Will permit to retrieve metrics from the application.
kubectl create configmap prometheus-config --from-file=prometheus.yml=prometheus-config.yml -n production -o yaml | kubectl apply -f -
kubectl apply -f prometheus.yml

# Install Grafana via Helm on the production namespace.
helm upgrade --install grafana grafana/grafana -n production

# Get the password for the Grafana admin user.
kubectl get secret --namespace production grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Get the name of the Grafana pod.
echo PODNAME = $(kubectl get pods --namespace production -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")