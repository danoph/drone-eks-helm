# Drone helm stuff

In order to push to an ECR registry and deploy using helm to kubernetes
cluster, drone server needs an IAM role (with programmatic access) with following policies attached:

- AmazonEKSClusterPolicy
- AmazonEKSWorkerNodePolicy
- AmazonEC2ContainerRegistryPowerUser
- AmazonEKSServicePolicy

This should be eventually automated, using cloudformation maybe.

Also need to set these variables in the drone secrets section of the UI:

- ecr_access_key
- ecr_secret_key
- aws_access_key_id
- aws_secret_access_key

This should be eventually automated, using drone CLI maybe, or pulling
secrets from kubernetes secrets in drone build config.

## Drone instructions:

In pipeline step, environment variables need to be set for EKS:
ex:

```
pipeline:
  ...
  rails-deploy:
   image: danoph/drone-eks-helm
   secrets: [ aws_access_key_id, aws_secret_access_key ]
   environment:
     EKS_CLUSTER_NAME: k8s-dev
     AWS_REGION: us-west-2
   helm: upgrade --install --set image.tag=ci-${DRONE_COMMIT_SHA:0:8} --namespace [K8s namespace here] [deployment name] [chart path]
   when:
     branch: dev
     event: [push, tag, deployment]
```

### Additional Notes

Add drone IAM to roles defined in aws-auth-cm.yaml to be able to deploy to kubernetes.
https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html
