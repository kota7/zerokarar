import numpy as np
import pickle
with open("sample_weight.pkl", "rb") as f:
    data = pickle.load(f)
for key in data:
    np.savetxt(key, data[key])