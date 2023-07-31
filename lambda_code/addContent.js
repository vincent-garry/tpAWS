exports.handler = async (event) => {
  try {
    // Vérifier le type d'événement
    if (event.Records && event.Records.length > 0) {
      // Traiter chaque enregistrement ajouté
      for (const record of event.Records) {
        if (record.eventName === 'INSERT') {
          const newItem = record.dynamodb.NewImage;
          const job_id = newItem.job_id.S;
          const job_type = newItem.job_type.S;
          const file_content = newItem.file_content.B;
          
          // Traiter les données nouvellement ajoutées
          console.log(`Nouvel élément ajouté - job_id: ${job_id}, job_type: ${job_type}`);
          console.log('Contenu du fichier:', file_content);
          if(job_type == "addToDynamoDB"){
            const params = {
              TableName: 'content_database',
              Item: {
                content_id: job_id,
                content_file: file_content,
              },
            };
  
            // Ajouter le job dans la table DynamoDB
            await dynamoDB.put(params).promise();
            
          } else if (job_type === "addToS3") {
            const bucketName = 'bucket-content-for-tp';
            const fileName = `${job_id}.txt`;
            
            const params = {
              Bucket: bucketName,
              Key: fileName,
              Body: file_content,
            };
  
            // Ajouter le contenu du fichier dans le bucket S3
            await s3.putObject(params).promise();
          }
          // Ajouter ici la logique supplémentaire que vous souhaitez exécuter lorsque de nouveaux éléments sont ajoutés
        }
      }
    }
    
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Fonction Lambda exécutée avec succès' }),
    };
  } catch (error) {
    console.error('Erreur:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Une erreur est survenue' }),
    };
  }
};
