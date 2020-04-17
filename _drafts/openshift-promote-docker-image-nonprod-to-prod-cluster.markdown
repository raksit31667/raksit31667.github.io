---
layout: post
title:  "นำ Docker image จาก non-production ขึ้น production cluster บน OpenShift"
date:   2020-04-16
tags: [docker, openshift, jenkins, skopeo]
---
### diagram ว่าเราจะทำอะไร
### คำศัพท์​ service account, rolebinding, secret, pipeline
### Use the non-prod account to create a service account and add a rolebinding in the Non-Prod-OpenShift.

`oc process -f openshift/promotion-policies.yaml | oc apply -f -`

```yaml
apiVersion: v1
kind: Template
labels:
  template: promotion-policies 
metadata:
  annotations:
    description: Policies for managing promotion policies
    tags: policies
  name: ${RESOURCE_NAME}
objects:
- apiVersion: v1
  kind: RoleBinding
  metadata:
    labels:
      template: promotion-policies
    name: ${RESOURCE_NAME}-system-image-puller
  roleRef:
    name: system:image-puller
  subjects:
  - kind: ServiceAccount
    name: ${RESOURCE_NAME}
- apiVersion: v1
  kind: ServiceAccount
  metadata:
    creationTimestamp: null
    name: ${RESOURCE_NAME}
parameters:
- description: Name of the Service Account to apply permissions.
  displayName: Promotion Service Account
  name: RESOURCE_NAME
  value: promotion-client

```

### Use the non-prod account to save the secret for this service account in the Non-Prod-OpenShift. Get token for promotion-client in your non-prod environment by following command.
`oc serviceaccounts get-token promotion-client`


### Create the secret resource file
oc create secret generic non-prod-promotion --dry-run=true -o yaml \
    --from-literal=token=<token string from previous command> \
    > non-prod-promotion-secret.yaml


### Use the prod account to load the saved secret from step 3 to the Prod-OpenShift.
oc apply -f non-prod-promotion-secret.yaml

prod-pipeline-trigger


### This secret is required by both nonprod and prod jenkins. It is used to trigger prod pipeline from nonprod jenkins pipeline. Create pipeline trigger secret in Non-Production. If the secret prod-pipeline-trigger already exists, you can skip this step. Replace ${secret} by the secret text you've generated.

```
oc create secret generic prod-pipeline-trigger --from-literal=secrettext=${secret}
oc annotate secret prod-pipeline-trigger --overwrite jenkins.openshift.io/secret.name=prod-pipeline-trigger
oc label secret prod-pipeline-trigger --overwrite credential.sync.jenkins.openshift.io="true"
```


### Use the prod account to create pipeline trigger secret in Production. If the secret prod-pipeline-trigger already exists, you can skip this step. Replace ${secret} by the same secret text you've used in previous step.

`oc create secret generic prod-pipeline-trigger --from-literal=WebHookSecretKey=${secret}`

Since upgrading the Openshift Sync Plugin to version 1.0.36, the secrets can be converted to Jenkins Credentials automatically. All Jenkins Credentials should be synced from secrets to avoid loss of configuration when restarting Jenkins server.

### Skopeo

```yaml
apiVersion: v1
kind: BuildConfig
metadata:
  name: starter-kit-jenkins
spec:
  runPolicy: Serial
  source:
    git:
      ref: master
      uri: git@gitserver.xtonet.com:SMKT-CST/common/jenkins/starter-kit-jenkins.git
    sourceSecret:
      name: gitlab
    type: Git
  strategy:
    jenkinsPipelineStrategy:
      jenkinsfilePath: Jenkinsfile
    type: JenkinsPipeline

```

```dockerfile
FROM openshift3/jenkins-slave-base-rhel7:v3.11

LABEL com.redhat.component="jenkins-slave-image-mgmt" \
      name="jenkins-slave-image-mgmt" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Image Management" \
      io.k8s.description="Image management tools on top of the jenkins slave base image" \
      io.openshift.tags="openshift,jenkins,slave,copy"
USER root

RUN yum repolist > /dev/null && \
    yum clean all && \
    INSTALL_PKGS="skopeo" && \
    yum install -y --enablerepo=rhel-7-server-extras-rpms --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

USER 1001
```


