# Learn Terraform - Provision a GKE Cluster

This repo is a companion repo to the [Provision a GKE Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke), containing Terraform configuration files to provision an GKE cluster on GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.

## 配置

根据文档，配置 gcloud，安装 terraform，创建项目。
修改 `terraform.tfvars` 文件，填入项目 ID，和创建的 region。

```yaml
project_id = <PROJECT_ID>
region     = <REGION>
```

## TODO

- [ ] 给 instance 配置 ssh，gcloud，kubectl 以及 kubeconfig