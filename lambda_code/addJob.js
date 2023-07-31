const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const { job_type, fichier } = JSON.parse(event.body);
    
    const contenuFichier = Buffer.from(fichier, 'base64').toString();
    
    const tableName = 'jobs_table';
    const attributeName = 'job_id';

    // Récupérer la valeur actuelle du compteur
    const currentCounter = await getCurrentCounter(tableName, attributeName);

    // Incrémenter le compteur
    const newCounter = currentCounter + 1;
    
    const job_id = newCounter;

    // Mettre à jour la valeur du compteur dans la table de compteur
    await updateCounter(tableName, attributeName, newCounter);

    const params = {
        TableName: 'jobs_table',
        Item: {
          job_id,
          job_type,
          file_content: contenuFichier,
        },
      };
      
      // Ajouter le job dans la table DynamoDB
      await dynamoDB.put(params).promise();

    // Retourner le nouveau ID auto-incrémenté
    return {
      statusCode: 200,
      body: JSON.stringify({ job_id: newCounter }),
    };
  } catch (error) {
    console.error('Erreur:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Une erreur est survenue' }),
    };
  }
};

// Fonction pour récupérer la valeur actuelle du compteur
async function getCurrentCounter(tableName, attributeName) {
  const params = {
    TableName: 'counters',
    Key: {
      table_name: tableName,
      attribute_name: attributeName,
    },
  };

  const result = await dynamoDB.get(params).promise();

  // Vérifier si le compteur existe dans la table de compteur
  if (result.Item && result.Item.counter_value) {
    return result.Item.counter_value;
  } else {
    // Si le compteur n'existe pas, initialiser le compteur à 1
    return 1;
  }
}

// Fonction pour mettre à jour la valeur du compteur
async function updateCounter(tableName, attributeName, newCounter) {
  const params = {
    TableName: 'counters',
    Key: {
      table_name: tableName,
      attribute_name: attributeName,
    },
    UpdateExpression: 'SET counter_value = :newCounter',
    ExpressionAttributeValues: {
      ':newCounter': newCounter,
    },
  };

  await dynamoDB.update(params).promise();
}
