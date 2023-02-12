const functions = require("firebase-functions");
const vision = require('@google-cloud/vision');
const app = functions.region('asia-northeast3');


exports.getOcrText = app.https.onRequest(async (request, response) => {
    response.send(await quickstart(request.body.base64Image));
});

async function quickstart(arrByte) {
    const regex = /[^0-9]/g;  // 숫자 체크
    const client = new vision.ImageAnnotatorClient({ keyFilename: 'running-heart-vision-api-key.json' });
    const [textDetection] = await client.textDetection({
        image: { content: arrByte }
    });
    const textAnnotations = textDetection.textAnnotations;

    console.log('Text:');
    var results = [];
    textAnnotations.forEach(text => {
        var tmp = text.description.replace(regex, '');
        if (tmp.length != 0 && !tmp.includes('651')) {
            results.push(tmp);
        }
    });

    return results;
}

