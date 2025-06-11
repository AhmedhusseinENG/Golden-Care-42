import os
import json
import base64
import numpy as np
from flask import Flask, jsonify
import firebase_admin
from firebase_admin import credentials, db
import tensorflow as tf
from datetime import datetime

app = Flask(__name__)

firebase_key_b64 = os.getenv("FIREBASE_KEY_B64")
if not firebase_key_b64:
    raise EnvironmentError("FIREBASE_KEY_B64 not set in environment variables.")
firebase_key_json = base64.b64decode(firebase_key_b64).decode("utf-8")
with open("firebase_key.json", "w") as f:
    f.write(firebase_key_json)

cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(
    cred, {"databaseURL": "https://goldencare-68364-default-rtdb.firebaseio.com/"}
)

interpreter = tf.lite.Interpreter(model_path="best_bp_model.tflite")
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

def preprocess(ecg_seq, ppg_seq):
    ecg = np.array(ecg_seq, dtype=np.float32)
    ppg = np.array(ppg_seq, dtype=np.float32)
    
    if len(ecg) != 250 or len(ppg) != 250:
        raise ValueError(f"Expected 250 samples, got ECG: {len(ecg)}, PPG: {len(ppg)}")
    
    ppg_norm = (ppg - ppg.min()) / (ppg.max() - ppg.min()) * 4  # 0-4 range
    ecg_norm = (ecg - ecg.min()) / (ecg.max() - ecg.min()) * 8 - 3.5  # -3.5 to +4.5 range
    
    data = np.stack((ppg_norm, ecg_norm), axis=-1)
    data_final = data.reshape(1, 250, 2)
    
    return data_final

def postprocess_prediction(prediction_norm):
    if len(prediction_norm.shape) == 3 and prediction_norm.shape[-1] == 1:
        prediction_2d = prediction_norm.squeeze(-1)
    else:
        prediction_2d = prediction_norm.squeeze()
    
    prediction_mmhg = prediction_2d * 150 + 50
    return prediction_mmhg

def extract_bp_metrics(waveform):
    waveform = np.array(waveform)
    sbp = np.percentile(waveform, 90)  
    dbp = np.percentile(waveform, 10)  
    return sbp, dbp

def classify_bp(sbp, dbp):
    if sbp < 120 and dbp < 80:
        return "Normal"
    elif sbp < 130 and dbp < 80:
        return "Elevated"
    elif (120 <= sbp < 140) or (80 <= dbp < 90):
        return "Hypertension Stage 1"
    elif sbp >= 140 or dbp >= 90:
        return "Hypertension Stage 2"
    else:
        return "Hypertensive Crisis"

def get_sequence_data(sequence_str):
    if not sequence_str:
        return []
    try:
        return list(map(float, sequence_str.split(',')))
    except ValueError:
        return []

@app.route('/predict-abp', methods=['GET'])
def predict_abp():
    try:
        ref = db.reference("/patients/patient_123/readings")
        all_data = ref.get()

        if not all_data:
            return jsonify({"error_code": 404, "error_message": "No data found in Firebase"}), 404

        timestamped = [(k, v) for k, v in all_data.items() if k != "latest"]

        if not timestamped:
            return jsonify({"error_code": 404, "error_message": "No timestamped readings found"}), 404

        def extract_datetime_key(entry):
            try:
                return datetime.strptime(entry[0][:19], "%Y-%m-%dT%H:%M:%S")
            except ValueError:
                return datetime.min

        sorted_entries = sorted(timestamped, key=extract_datetime_key, reverse=True)

        if len(sorted_entries) < 2:
            return jsonify({"error_code": 400, "error_message": "Need at least 2 timestamped readings for prediction"}), 400

        previous1 = sorted_entries[1][1]  
        previous2 = sorted_entries[2][1]  

        required_keys = ["ecg_sequence", "ppg_ir_sequence"]
        for k in required_keys:
            if k not in previous1 or k not in previous2:
                return jsonify({"error_code": 400, "error_message": f"Missing key '{k}' in Firebase data"}), 400

        ecg_previous1 = get_sequence_data(previous1["ecg_sequence"])
        ppg_previous1 = get_sequence_data(previous1["ppg_ir_sequence"])
        ecg_previous2 = get_sequence_data(previous2["ecg_sequence"])
        ppg_previous2 = get_sequence_data(previous2["ppg_ir_sequence"])

        ecg_all = ecg_previous2 + ecg_previous1
        ppg_all = ppg_previous2 + ppg_previous1

        if len(ecg_all) < 250 or len(ppg_all) < 250:
            return jsonify({
                "error_code": 400,
                "error_message": f"Insufficient combined samples. Need 250, got ECG: {len(ecg_all)}, PPG: {len(ppg_all)}"
            }), 400

        ecg_final = ecg_all[-250:]
        ppg_final = ppg_all[-250:]

        X_input = preprocess(ecg_final, ppg_final)

        interpreter.set_tensor(input_details[0]['index'], X_input)
        interpreter.invoke()
        prediction = interpreter.get_tensor(output_details[0]['index'])[0].squeeze()
        
        prediction = postprocess_prediction(prediction)

        sbp, dbp = extract_bp_metrics(prediction)
        bp_category = classify_bp(sbp, dbp)

        return jsonify({
            "sbp": float(round(sbp, 2)),
            "dbp": float(round(dbp, 2)),
            "bp_category": bp_category,
        }), 200

    except FileNotFoundError as e:
        return jsonify({"error_code": 404, "error_message": str(e)}), 404
    except (KeyError, ValueError) as e:
        return jsonify({"error_code": 400, "error_message": str(e)}), 400
    except Exception as e:
        return jsonify({"error_code": 500, "error_message": f"Server error: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)