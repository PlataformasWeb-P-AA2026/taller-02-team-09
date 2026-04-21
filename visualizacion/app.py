import streamlit as st
import requests
import pandas as pd

st.title("Dashboard")

data = requests.get("http://127.0.0.1:8000/empleados").json()
df = pd.DataFrame(data)

st.dataframe(df)
st.write(df["salario"].mean())
