import type { AWS } from '@serverless/typescript';

import ping from '@functions/ping';

const serverlessConfiguration: AWS = {
  service: '${env:SERVICE}',
  frameworkVersion: '2',
  custom: {
    webpack: {
      webpackConfig: './webpack.config.js',
      includeModules: true,
    },
    // Custom port to run the functions locally
    'serverless-offline': {
      httpPort: '${env:SERVERLESS_OFFLINE_HTTP_PORT}',
    },
  },
  plugins: ['serverless-webpack','serverless-offline'],
  
  provider: {
    name: 'aws',
    runtime: 'nodejs14.x',
    apiGateway: {
      minimumCompressionSize: '${env:MINIMUM_COMPRESSION_SIZE}',
      shouldStartNameWithService: true,
    },
    environment: {
      AWS_NODEJS_CONNECTION_REUSE_ENABLED: '${env:AWS_NODEJS_CONNECTION_REUSE_ENABLED}',
    }
  },
  // import the function via paths
  functions: { ping },
};

module.exports = serverlessConfiguration;