# postal

A helm-chart to deploy [Postal](https://postal.atech.media/) on kubernetes.

## Introduction

This chart bootstraps a deployment of Postal, MariaDB and RabbitMQ on a
[Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9
- PV provisioner support in the underlying infrastructure

## Optional prerequisites

- An ingress controller
- A functioning [cert-manager](https://github.com/jetstack/cert-manager) for certificate management

## Installing the Chart

To install the chart with the release name my-release:

```console
helm install --name my-release stable/postal
```

The command deploys postal on the Kubernetes cluster in the default confiugraiotn. The [configuration](#confguration)
section lists parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration - MariaDB and RabbitMQ

This chart pulls in [stable/mariadb](https://github.com/helm/charts/blob/master/stable/mariadb) and
[stable/rabbitmq-ha](https://github.com/helm/charts/tree/master/stable/rabbitmq-ha) as dependencies.

Please refer to the respective documentation for configuration parameters of those components.

### Note about configuring RabbitMQ

If you want to override any of RabbitMQ's configuration parameters, make sure your `values.yaml`
contains a YAML node `rabbitmq` with an anchor `&rabbitmq` that is referenced in a `rabbitmq-ha`
node.

We do this, because referencing values of sub-charts with a dash in the name (i.e. `rabbitmq-ha`)
can be difficult and dashes in chart names are discouraged by helm ([helm/#4379](https://github.com/helm/helm/pull/4379)).

Example:

```yaml
rabbitmq: &rabbitmq
  replicaCount: 3
rabbitmq-ha: *rabbitmq
```

## Configuration

We set the following default configuration parameters for MariaDB and RabbitMQ:

Parameter | Description | Default
--- | --- | ---
`mariadb.rootUser.password` | Password for the MariaDB root user. Change this from the default! | see [values.yaml](values.yaml)
`mariadb.replication.enabled` | Enable MariaDB replication | `false`
`mariadb.slave.replicas` | Number of MariaDB slave replicas | `0`
`mariadb.metrics.enabled` | Enable prometheus metrics | `true`
`rabbitmq.definitions.vhosts` | RabbitMQ vhosts definitions. Our default adds one for Postal. | see [values.yaml](values.yaml)
`rabbitmq.definitions.permissions` | RabbitMQ vhosts permissions. Our default adds permission to the `/postal` vhost for the `postal` user. | see [values.yaml](values.yaml)
`rabbitmq.replicaCount` | Number of RabbitMQ replicas. | `1`
`rabbitmq.rabbitmqUsername` | Username for RabbitMQ. | `postal`
`rabbitmq.rabbitmqPassword` | Password for RabbitMQ. Change this from the default! | see [values.yaml](values.yaml)
`rabbitmq.managementPassword` | Password for RabbitMQ management operations. Change this from the default! | see [values.yaml](values.yaml)

The following table lists the configurable parameters of the postal chart and their default values.

Parameter | Description | Default
--- | --- | ---
`postal.nameOverride` | override the name of the chart | ``
`postal.image` | postal container image repository | `linkyard/postal`
`postal.imageTag` | postal container image tag | `latest`
`postal.imagePullPolicy` | postal container image pull policy | `Always`
`postal.signingKey` | RSA private key in PEM format used for DKIM signing. Change this from the default! | see [values.yaml](values.yaml)
`postal.railsSecretKey` | The secret key for rails. Change this from the default! | see [values.yaml](values.yaml)
`postal.letsEncryptKey` | RSA private key in PEM format. Used by Postal to acquire and renew certificates for the click-tracking-server from Let's Encrypt. Change this from the default! | see [values.yaml](values.yaml)
`postal.smtpPassword` | Password for the SMTP server. Change this from the default! | see [values.yaml](values.yaml)
`postal.web.ingress.enabled` | if an `ingress` resource should be deployed for the web interface | `true`
`postal.web.ingress.hostname` | public hostname for the web interface; this is a required value  | ``
`postal.web.ingress.ingressClass` | ingress class to use | `nginx`
`postal.web.ingress.tlsEnabled` | enable TLS on the ingress | `true`
`postal.web.ingress.certManager.enabled` | enable management of the TLS secret with [cert-manager](https://github.com/jetstack/cert-manager) | `true`
`postal.web.ingress.certManager.ingressClass` | ingress class to use for HTTP01 challenge | `nginx`
`postal.web.ingress.certManager.issuerName` | name of the cert-manager issuer; this is a required value | ``
`postal.web.ingress.certManager.issuerKind` | kind of the cert-manager issuer; this is a required value | ``
`postal.web.ingress.existingTlsSecret` | name of an existing TLS secret to use for the ingress (if cert-manager is not used); must be in the same namespace | ``
`postal.smtp.hostname` | public hostname of postal's SMTP server; this is a required value | ``
`postal.smtp.serviceType` | what kind of service the SMTP server is exposed as | `LoadBalancer`
`postal.smtp.certManager.enabled` | enable management of the TLS secret with [cert-manager](https://github.com/jetstack/cert-manager) | `true`
`postal.smtp.certManager.ingressClass` | ingress class to use for HTTP01 challenge | `nginx`
`postal.smtp.certManager.issuerName` | name of the cert-manager issuer; this is a required value | ``
`postal.smtp.certManager.issuerKind` | kind of the cert-manager issuer; this is a required value | ``
`postal.smtp.ingress.existingTlsSecret` | name of an existing TLS secret to use for the SMTP server (if cert-manager is not used); must be in the same namespace | ``
