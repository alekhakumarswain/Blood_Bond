from flask import Flask, request, jsonify
import joblib
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# Load model
model = joblib.load(os.getenv('MODEL_PATH'))

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    features = [data['feature1'], data['feature2']]  # Adjust based on your model
    prediction = model.predict([features])[0]
    return jsonify({'prediction': int(prediction)})

if __name__ == '__main__':
    app.run(port=int(os.getenv('FLASK_PORT', 5001)))
