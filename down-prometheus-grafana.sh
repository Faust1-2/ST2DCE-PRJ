helm uninstall --namespace production grafana
kubectl delete configmap prometheus-config -n production
kubectl delete -f prometheus.yml
unset POD_NAME