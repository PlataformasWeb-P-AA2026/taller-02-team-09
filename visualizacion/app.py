import streamlit as st
import requests
import pandas as pd
import config  # Importa el config local de esta carpeta

st.title("Dashboard de Empleados")

# Usa la variable del config
url = config.API_URL

try:
    data = requests.get(url).json()
    df = pd.DataFrame(data)
    st.dataframe(df)
    st.write(f"Promedio salarial: {df['salario'].mean():.2f}")
except Exception as e:
    st.error(f"Error: {e}")
