import { mocked } from 'ts-jest/utils';
import { Handler } from 'aws-lambda';

import { middyfy } from '@libs/lambda';

jest.mock('@libs/lambda');

describe('ping', () => {
  let main;
  let mockedMiddyfy: jest.MockedFunction<typeof middyfy>;

  beforeEach(async () => {
    mockedMiddyfy = mocked(middyfy);
    mockedMiddyfy.mockImplementation((handler: Handler) => {
      return handler as never;
    });

    main = (await import('../ping/handler')).main;
  });

  afterEach(() => {
    jest.resetModules();
  });

  it('should return ping response', async () => {
    const res ={
      status:200,
     message:"Ping Successful!!"
  }as any;
    const actual = await main();
    const response=(actual.body)
    
    expect(response).toEqual(
        JSON.stringify(res)
  );
})
})