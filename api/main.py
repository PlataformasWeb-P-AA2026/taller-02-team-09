from fastapi import FastAPI
from base import conectar  # Importamos la función desde base.py

app = FastAPI()

@app.get("/empleados")
def empleados():
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("SELECT nombre, departamento, salario FROM empleados")
        datos = cur.fetchall()
        cur.close()
        conn.close()
        
        # Formateamos la respuesta
        return [{"nombre": d[0], "departamento": d[1], "salario": d[2]} for d in datos]
    except Exception as e:
        return {"error": str(e)}
