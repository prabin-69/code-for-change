import dotenv from 'dotenv';
import path from 'path';

// Load test environment
dotenv.config({ path: path.join(__dirname, '../../.env.test') });

// Increase timeout for integration tests
jest.setTimeout(30000);