import 'source-map-support/register';

// import type { ValidatedEventAPIGatewayProxyEvent } from '@libs/apiGateway';
// import { formatJSONResponse } from '@libs/apiGateway';
import { middyfy } from '@libs/lambda';

// import schema from './schema';

const ping = async () => {
  const response={
    status:200,
   message:"Ping Successful!!"
};
  return {
    statusCode: 200,
    headers: {
      "Access-Control-Allow-Headers" : "*",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
  },
    body: JSON.stringify(response),
    
  
    
  };
}

export const main = middyfy(ping);
// export const main = middy.default(async () => { return {}; }).use(cors());