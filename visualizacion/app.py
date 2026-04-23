import streamlit as st
import requests
import pandas as pd

st.title("Dashboard de Empleados")

# Asegúrate de que esta IP sea la de tu máquina api1
url = "http://10.253.88.116:8000/empleados"

try:
    response = requests.get(url)
    data = response.json()

    # Verificamos si data es una lista (lo que espera pandas)
    if isinstance(data, list):
        df = pd.DataFrame(data)
        st.dataframe(df)
        if not df.empty:
            st.write(f"Salario promedio: ${df['salario'].mean():,.2f}")
    else:
        # Si no es lista, mostramos el error que mandó la API
        st.error("La API no devolvió una lista. Respuesta recibida:")
        st.json(data)

except Exception as e:
    st.error(f"Error de conexión: {e}")
