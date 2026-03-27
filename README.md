# FluxCD setup

Example on how to setup FluxCD via Terraform provider + flux Kustomization.

## Useful resources

- https://github.com/fluxcd/flux2-kustomize-helm-example

## FluxCD Concepts

FluxCD is pull-based, but it can also be extended with **webhook receiver** to respond to external events, it is part of **notification controller**.

### source controller

Agent responsible for fetching the artifacts files containing Kubernetes Resource manifest data.

### kustomize controller

Agent responsible for make the cluster to match the desired state described in the manifests fetched thorugh source controller.
The `Kustomization` is the CR (Custom Resource) or API through which a FLux user defines how Kustomize controller delivers workloads from sources.

It is responsible for:
- pruning resources from the cluster when they are removed from the source
- valida kubernetes manifests fetched from source to Kubernetes API
- checks deployed resources and ordering

### helm controller

The helm-controller allows you to declaratively manage Helm chart releases with Kubernetes manifests. It makes use of the artifacts produced by the source-controller from `HelmRepository`, `GitRepository`, `Bucket` and `HelmChart` resources. The helm-controller is part of the default toolkit installation.

Example of `HelmRepository` with credentials, where you define what's the source where you can fetch the Helm chart:
```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: podinfo
  namespace: default
spec:
  interval: 1m
  url: https://stefanprodan.github.io/podinfo
  secretRef:
    name: example-user
---
apiVersion: v1
kind: Secret
metadata:
  name: example-user
  namespace: default
stringData:
  username: example
  password: "123456"
```

To react immediately to changes in references Secrets and ConfigMaps, just add the label below:
```yaml
metadata:
  labels:
    reconcile.fluxcd.io/watch: Enabled
```

## notification controller

The Notification Controller is a Kubernetes operator, specialized in handling inbound and outbound events. The controller handles:

- events coming from external systems (GitHub, GitLab, Bitbucket, Harbor, Jenkins, etc) and notifies the GitOps toolkit controllers about source changes.
- events emitted by the GitOps toolkit controllers (source, kustomize, helm) and dispatches them to external systems (Slack, Microsoft Teams, Discord, RocketChat) based on event severity and involved objects.
