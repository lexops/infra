# Infra Repo

## Install ApplicationSet Updater

Create applicationset updater manifest

```sh
cat << EOF > applicationset-updater.yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: applicationset-updater
  namespace: argocd
spec:
  source:
    repoURL: 'https://github.com/lexops/infra.git'
    path: argocd
    targetRevision: HEAD
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF
```
Apply on cluster

```sh
kubectl apply -f applicationset-updater.yml
```