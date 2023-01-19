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
      httpPort: 3000,
    },
  },
  plugins: ['serverless-webpack','serverless-offline'],
  
  provider: {
    name: 'aws',
    runtime: 'nodejs18.x',
    apiGateway: {
      minimumCompressionSize: 1024,
      shouldStartNameWithService: true,
    },
    environment: {
      AWS_NODEJS_CONNECTION_REUSE_ENABLED: '${param:awsNodejsConnectionReuseEnabled}',
    }
  },
  // import the function via paths
  functions: { ping },
};

module.exports = serverlessConfiguration;