import { afterAll, beforeAll, describe, expect, it, test } from '@jest/globals';
import request from 'supertest';

import app from '../app';
import { closeDb, syncDb } from './_db';


describe("Test Loan Application Routes", () => {

  beforeAll(syncDb)

  afterAll(closeDb)

  test("POST /api/loan_application", async () => {
    let res = await request(app)
      .post("/api/loan_application")
      .set('Content-Type', 'application/json')
      .send({ data: {
        requested_amount_cents: 10000,
        currency: "USD",
        merchant_id: 1,
      }})
      .expect('Content-Type', /json/)
      .expect(200);

    expect(res.body).toStrictEqual({
      loan_application_id: 1,
      next_step: 'identity',
      submit_url: 'POST /api/loan_application/1/identity'
    })
  });
});
