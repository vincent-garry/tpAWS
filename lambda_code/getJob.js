const AWS = require('aws-sdk');

const dynamoDB = new AWS.DynamoDB.DocumentClient();

exports.handler = async () => {
  try {
    const params = {
      TableName: 'jobs_table',
    };

    const result = await dynamoDB.scan(params).promise();
    const jobs = result.Items;

    return {
      statusCode: 200,
      body: JSON.stringify(jobs),
    };
  } catch (error) {
    console.error('Erreur:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Une erreur est survenue : ' + error }),
    };
  }
};
