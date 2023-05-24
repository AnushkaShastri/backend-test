const request = require("supertest");
const app = require('../index');

beforeAll(() => app.listen());



describe('Sample Test', () => {
    it('should test that true === true', () => {
      expect(true).toBe(true)
    })
    it('should fetch a single post', async () => {
        
        let resp = await request(app).get("/service/ping");
      
         expect(resp.body).toEqual({ status: 200, message: 'Ping Successful!!' })
        console.log(resp.body);
        
      } );
  })
