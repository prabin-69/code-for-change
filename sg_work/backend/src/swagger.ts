import swaggerJsdoc from 'swagger-jsdoc';

const options = {
  definition: {
    openapi: '3.0.0',

    info: {
      title: 'Service Marketplace API',
      version: '1.0.0',
      description: 'API for Home & Professional Services Marketplace',
    },

    servers: [
      {
        url: 'http://localhost:4000/api/v1',
        description: 'Development server',
      },
    ],

    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },

    security: [
      {
        bearerAuth: [],
      },
    ],
  },

  apis: [
    './dist/modules/**/*.controller.js',
    './dist/modules/**/*.routes.js',
  ],
};

export const specs = swaggerJsdoc(options);