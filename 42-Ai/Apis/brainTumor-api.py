import os
import numpy as np
import tensorflow as tf
from flask import Flask, request, jsonify
from tensorflow.keras.preprocessing import image
from werkzeug.utils import secure_filename

TFLITE_MODEL_PATH = "BrainTumor_model_updated.tflite" 
interpreter = tf.lite.Interpreter(model_path=TFLITE_MODEL_PATH)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

class_labels = ['glioma', 'meningioma', 'no_tumor', 'pituitary']


app = Flask(__name__)

def preprocess_image(img_path, target_size=(150, 150)):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img) / 255.0  # Normalize
    img_array = np.expand_dims(img_array, axis=0).astype(np.float32)
    return img_array

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    filename = secure_filename(file.filename)
    filepath = os.path.join("temp", filename)
    os.makedirs("temp", exist_ok=True)
    file.save(filepath)

    try:
        img_tensor = preprocess_image(filepath, target_size=(150, 150))

        interpreter.set_tensor(input_details[0]['index'], img_tensor)
        interpreter.invoke()
        output = interpreter.get_tensor(output_details[0]['index'])

        class_index = int(np.argmax(output))
        label = class_labels[class_index]

        if label == "no_tumor":
            message = "No Tumor"
        else:
            message = f"This scan may indicate signs of {label.replace('_', ' ').title()}"

        return jsonify({
            "label": label,
            "message": message
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if os.path.exists(filepath):
            os.remove(filepath)

# === Start app ===
if __name__ == '__main__':
    app.run(debug=True)
