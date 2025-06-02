import joblib
import pandas as pd

def predict_soc_soh(cycle, voltage, current):
    models = joblib.load('hybrid_soh_soc_model.pkl')
    input_data = pd.DataFrame([{
        'cycle': cycle,
        'voltage': voltage,
        'current': current
    }])
    model = models['rf_model'] if cycle <= 168 else models['lin_model']
    soc, soh = model.predict(input_data)[0]
    return soc, soh
