# MLFlow Model Service in Kubernetes
<table><tr>
<td><img src="https://res.cloudinary.com/practicaldev/image/fetch/s--qDyZSKeq--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://cdn-images-1.medium.com/max/960/1*vYjNPycxLPi6nv7fDPoBwQ.png" alt="helm and k8s" width="150"/></td>
<td><img src="https://www.mlflow.org/docs/latest/_static/MLflow-logo-final-black.png" alt="mlflow" width="150"/></td>
<td><img src="https://logos-world.net/wp-content/uploads/2021/02/Docker-Symbol.png" alt="docker" width="150"/></td>
</tr></table>
This repo covers the deployment of your MLFLOW models to Kubernetes. We will make use of Helm and Docker to complete the deployment

## MLFlow Serve Helm Chart
This repo already contains a Helm Chart created specifically for mlflow serve. In most cases this will be a good starting point. I have made a few changes to templates to accomodate for environment variables.

## How to use
One could clone this repo and update the environment variables in [values.yaml](https://github.com/aarunjith/mlflow-serve/blob/main/mlflow-serve/values.yaml). If you dont have helm installed [please follow this to install Helm](https://helm.sh/docs/intro/install/). These steps assume you have kubectl configured and are able to access it through your CLI. For AWS EKS follow [this](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

**Step 1** : Build the docker image
```bash
$ docker build . -t mlflow-serve:latest
```
_OPTIONAL_ : If you want to build and push your images to ECR or any other service for a particular architecture you can use this
```bash
$ docker buildx build --platform linux/amd64 --push -t <id>.dkr.ecr.us-east-1.amazonaws.com/mlflow-serving:latest --file Dockerfile .
```

**Step 2** : Modify the helm variables
Update [values.yaml](https://github.com/aarunjith/mlflow-serve/blob/main/mlflow-serve/values.yaml) with the docker image name you built. In this case it will sort of look like this
```yaml
replicaCount: 1

image:
  repository: mlflow-serve
  pullPolicy: Always
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""
```
Tag of the image is specified in [Charts.yaml](https://github.com/aarunjith/mlflow-serve/blob/main/mlflow-serve/Charts.yaml)
```yaml
# This is the version number of the application being deployed. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
# It is recommended to use it with quotes.
appVersion: "latest"
```
Set up environment variables in [values.yaml](https://github.com/aarunjith/mlflow-serve/blob/main/mlflow-serve/values.yaml).
```yaml
tolerations: []

affinity: {}
examplemap:
  - name: "MLFLOW_TRACKING_URI"
    value: "<your ml-flow tracking url here>"
  - name: "SERVING_PORT"
    value: "80"
  - name: "MODEL_NAME"
    value: "<put your model name here>"
  - name: "AWS_ACCESS_KEY_ID"
    value: "<AWS Access key here if your artifacts are in s3>"
  - name: "AWS_SECRET_ACCESS_KEY"
    value: "<AWS Secret acces key here if your artifacts are in s3>"
  - name: "MLFLOW_CONDA_HOME"
    value: "/opt/conda/"
```
**Step 3**: Use helm to install 
```bash
$ helm install mlflow-serve ./mlflow-serve -n <your k8s namespace>
```
