import type { AWS } from '@serverless/typescript';

import ping from '@functions/ping';

const serverlessConfiguration: AWS = {
  service: '${env:SERVICE}',
  frameworkVersion: '3',
  custom: {
    webpack: {
      webpackConfig: './webpack.config.js',
      includeModules: true,
    },
    // Custom port to run the functions locally
    'serverless-offline': {
      httpPort: '${param:serverlessOfflineHttpPort}' as any,
    },
  },
  plugins: ['serverless-webpack','serverless-offline'],
  
  provider: {
    name: 'aws',
    runtime: 'nodejs18.x',
    apiGateway: {
      minimumCompressionSize: '${param:minimumCompressionSize}' as any,
      shouldStartNameWithService: true,
    },
    environment: {
      AWS_NODEJS_CONNECTION_REUSE_ENABLED: '${param:awsNodejsConnectionReuseEnabled}',
    },
    tags: {
      createdBy : '${param:createdBy}' as any,
      project : '${param:project}' as any,
      projectComponent : '${param:projectComponent}' as any
    }
  },
  // import the function via paths
  functions: { ping },
};

module.exports = serverlessConfiguration;