# aws-sls-backend-nodejs-lambda

This component consists of three folders
| S.no | Name |	Description |
| ---- | ------ | ------ |
| 1 | app | Contains a simple ping API with Node.js running on AWS Lambda and API Gateway using the Typescript based Serverless Framework. |
| 3 | deploy | Contains .sh files for creating and destroying resources |

## Requirements

| Name |	Version|
| ------ | ------ |
| [Serverless](https://www.serverless.com/framework/docs/getting-started) | >= 3.26.0 |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |	>= 2.9.6 |
| [Node.JS](https://nodejs.org/en/download) | >= 18.12.1 |

## Providers

| Name |	Version|
| ------ | ------ |
| AWS CLI |	>= 2.9.6 |

## Inputs

| Name | Description | Type |	Default	| Required |
| ------ | ------ | ------ | ------ | ------ |
| access_key | AWS Access Key ID | string | - | Yes |
| secret_key | AWS Secret Access Key | string | - | Yes |
| region | AWS Region in which resources will be deployed | string | us-east-1 | Yes |
| service | Name of the Service | string | aws-sls-backend-nodejs-lambda | Yes |
| serverlessOfflineHttpPort | Port number for offline deployment | number | 3000 | Yes |
| minimumCompressionSize | Enables compression of the method response payload, To enable compression on an API, set the minimumCompressionsSize property to a non-negative integer between 0 and 10485760. To disable compression on the API, set the minimumCompressionSize to null or remove it altogether | number | 1024 | Yes |
| awsNodejsConnectionReuseEnabled | To avoid the cost of establishing a new connection, you can reuse an existing connection. | string | 1 | Yes |
| env | Environment for resource provisioning | string | dev | Yes |
| createdBy | Tag for each resource, reflects author name | string | KloudJet | Yes |
| project | Tag for each resource, reflects Project ID (Find your Project ID on the Kloudjet Portal, passing incorrect or null value will disturb the metrics) | string | PID123 | Yes |
| projectComponent | Tag for each resource, reflects Component ID (Find your Project Component ID on the Kloudjet Portal, passing incorrect or null value will disturb the metrics) | string | CID123 | Yes |
| mode | Mode of resources deployment. Possible values are - "cicd" and "manual" | string | cicd | Yes |

##  Outputs
| Name | Description |
| ------ | ------ |
| endpoint | API Endpoint |
| functions | AWS Lambda functions name |

## Resources Created

Following resources will be created:

  - AWS Lambda Function
  - AWS API Gateway


## Manual Deployment of Resources

  - Install the tools, services, CLI, languages and frameworks mentioned under the [Requirements](#requirements) section.
  - Run the following command under the root folder. 
    - Update the values of *access_key* and *secret_key* with your AWS Access Key and AWS Secret Key respectively.
    - Update the value of *env* with the environment of resource provisioning. The default environment for resource provisioning is `dev`.
    - Provisioning of each resource will require three mandatory tags: *createdBy*, *project* and *projectComponent*. Update the value of *project* and *projectComponent* with the values available on KloudJet portal. Value of *createdBy* tag should be `KloudJet`.

    ```
    bash deploy/deploy.sh file=deploy/kloudjet-configurations.json access_key=<ENTER_YOUR_AWS_ACCESS_KEY> secret_key=<ENTER_YOUR_AWS_SECRET_KEY> env=<ENTER_THE_ENVIRONMENT> createdBy=KloudJet project=<ENTER_THE_PROJECT_ID> projectComponent=<ENTER_THE_PROJECT_COMPONENT_ID>
    ```

  - To destroy all resources, run the following command

    ```
    bash deploy/destroy.sh file=deploy/kloudjet-configurations.json access_key=<ENTER_YOUR_AWS_ACCESS_KEY> secret_key=<ENTER_YOUR_AWS_SECRET_KEY> env=<ENTER_THE_ENVIRONMENT> createdBy=KloudJet project=<ENTER_THE_PROJECT_ID> projectComponent=<ENTER_THE_PROJECT_COMPONENT_ID>
    ```