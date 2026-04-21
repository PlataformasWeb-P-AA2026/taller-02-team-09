from fastapi import FastAPI
import psycopg2

app = FastAPI()

def conectar():
    return psycopg2.connect(
    host="localhost",
    dbname="empresa",
    user="apiuser",
    password="1234"
)

@app.get("/empleados")
def empleados():
    conn = conectar()
    cur = conn.cursor()
    cur.execute("SELECT nombre, departamento, salario FROM empleados")
    datos = cur.fetchall()
    conn.close()

    return [{"nombre":d[0],"departamento":d[1],"salario":d[2]} for d in datos]
