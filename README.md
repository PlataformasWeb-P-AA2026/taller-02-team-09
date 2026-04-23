# taller02

# Taller: IaaS local con Multipass, FastAPI, PostgreSQL y Streamlit

## Objetivo

Construir un sistema distribuido con tres máquinas virtuales:

* base1: base de datos PostgreSQL
* api1: API con FastAPI
* visualizacion1: dashboard con Streamlit

---
# PARTE 0

Antes de iniciar la práctica considerar

* En su máquina local tener instalado python y un manejador de entornos
* En su máquina local instalar docker (MUY IMPORTANTE), para ello, revisar la información del archivo llamado **instalacion_docker_ubuntu_24_04.md**


---

# PARTE 1: Desarrollo local (entorno local)

## 1. Levantar PostgreSQL con Docker

```
docker run -d \
--name postgres-local \
-e POSTGRES_DB=empresa \
-e POSTGRES_USER=apiuser \
-e POSTGRES_PASSWORD=1234 \
-p 5432:5432 \
postgres

```

### CAPTURA EVIDENCIA 
<img width="1192" height="870" alt="imagen" src="https://github.com/user-attachments/assets/39fcbde4-3fbe-40e5-a9be-52c0697c4f1b" />


---

## 2. Crear datos
Ejecutar en el terminal:

```
docker exec -it postgres-local psql -U apiuser -d empresa
```
Ingresar este sql

```
CREATE TABLE empleados (
id SERIAL PRIMARY KEY,
nombre VARCHAR(100),
departamento VARCHAR(100),
salario INT
);

INSERT INTO empleados VALUES
(1,'Ana','TI',1200),
(2,'Luis','Finanzas',1500),
(3,'Carlos','Marketing',1100),
(4,'Maria','TI',1400);

```

### CAPTURA EVIDENCIA 

<img width="750" height="529" alt="imagen" src="https://github.com/user-attachments/assets/d746dc40-10be-4780-891f-74f44c7d0cf3" />

---

## 3. API FastAPI
Crear un entorno con virtualenv

### CAPTURA EVIDENCIA 
<img width="1198" height="747" alt="imagen" src="https://github.com/user-attachments/assets/faa9754c-edc0-4ea3-9506-7f572b98bc32" />
Crear carpeta api/
### CAPTURA EVIDENCIA 
<img width="400" height="93" alt="imagen" src="https://github.com/user-attachments/assets/a8126755-8ab6-4e28-a66e-8cdce1afd979" />

Crear archivo main.py:


```
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
```
### CAPTURA EVIDENCIA 
<img width="793" height="553" alt="imagen" src="https://github.com/user-attachments/assets/e46ddee9-9b92-4a41-b28e-57fb7aa90a76" />

Instalar:

```
pip install fastapi uvicorn psycopg2-binary
```

Ejecutar:

```
uvicorn main:app --reload

```
Probar:

```
http://127.0.0.1:8000/empleados
```
### CAPTURA EVIDENCIA 
<img width="844" height="444" alt="imagen" src="https://github.com/user-attachments/assets/efbc1ca9-1d54-480e-8014-a4fd5d67ea5e" />
<img width="785" height="224" alt="imagen" src="https://github.com/user-attachments/assets/a0f341d3-d9e1-4c54-8834-441172571301" />

---

## 4. Streamlit

Crear carpeta visualizacion/
Crear el archivo 

app.py:

```
import streamlit as st
import requests
import pandas as pd

st.title("Dashboard")

data = requests.get("http://127.0.0.1:8000/empleados").json()
df = pd.DataFrame(data)

st.dataframe(df)
st.write(df["salario"].mean())
```
### CAPTURA EVIDENCIA 
<img width="636" height="532" alt="imagen" src="https://github.com/user-attachments/assets/86a38601-d23b-468e-9530-5e3ccbbdc4ba" />


Instalar:


```
pip install streamlit pandas requests
```

Ejecutar:

```
streamlit run app.py
```
### CAPTURA EVIDENCIA 
<img width="1849" height="1112" alt="imagen" src="https://github.com/user-attachments/assets/f8a7c4bf-8528-4343-b6e1-f99a1561f677" />

## 5. Probar que todo funcione

* Importante verificar que todo funcione en el local, para pasar a la siguiente fase

## 6. Agregar archivos importantes

* Crear un archivo requeriments.txt con pip freeze
* Crear una nueva carpeta llamada base_datos
* Dentro de la carpeta base_datos, crear un respaldo de la base de datos mediante consola, en un archivo llamado respaldo.sql

## 7. Datos de base de datos y url de acceso a fastAPI

* La configuración de la base de datos debe estar en un archivo llamado base.py
* La configuración de la URL del API, en la visualización, debe estar en un archivo llamado config.py
* Estos dos archivos no deben estar en la dinámica de git, agregarlos al .gitignore


---

# PARTE 2: GitHub

```
Crear un repositorio y vincular con lo realizado en el local
Subir los cambios
git add .
git commit -a -m "version funcional local"
git push

```

  > En estos instantes su proyecto de GitHub tendrá mínimo tres carpetas para usar. Se usará el mismo repositorio en las máquinas virtuales.
---

# PARTE 3: Infraestructura con Multipass

* Crear las siguientes máquinas virtuales, a través de multipass

```
multipass launch --name base1 --mem 1G
multipass launch --name api1 --mem 1G
multipass launch --name visualizacion1 --mem 1G
```
* Verificar las maquinas, atención con los datos como la IP local de cada server creado

```
multipass list
```

---

# PARTE 4: base1 (BASE DE DATOS)

multipass shell base1

```
sudo apt update
sudo apt install postgresql git -y
```
Igresar a postgres

```
sudo -i -u postgres
psql

CREATE DATABASE empresa;
CREATE USER apiuser WITH PASSWORD '1234';
GRANT ALL PRIVILEGES ON DATABASE empresa TO apiuser;

\q
exit

```
* Clonar el repositorio

```
git clone URL_REPO
```
* Cargar datos:

```
sudo -u postgres psql -d empresa -f CARPETA_REPO/base_datos/respaldo.sql
```

* Agregar permisos para el user

```
sudo -u postgres psql -d empresa

GRANT ALL PRIVILEGES ON TABLE empleados TO apiuser;
GRANT USAGE, SELECT ON SEQUENCE empleados_id_seq TO apiuser;

\q
```
### CAPTURA EVIDENCIA 
<img width="1047" height="598" alt="imagen" src="https://github.com/user-attachments/assets/069a2cc3-f2f2-4241-bbfd-2f73504fd8c9" />



* Permitir acceso remoto:

```
sudo vim /etc/postgresql/*/main/postgresql.conf

Cambiar:

listen_addresses='*'

sudo vim /etc/postgresql/*/main/pg_hba.conf

Agregar:
host all all 0.0.0.0/0 md5
```
## CAPTURA EVIDENCIA 

<img width="1600" height="479" alt="imagen" src="https://github.com/user-attachments/assets/fc37d34a-eba0-4d93-9bae-04b085b5e13f" />


* Reiniciar postgres

```
sudo systemctl restart postgresql
```



---

# PARTE 5: api1
Ingresar a la máquina
```
multipass shell api1
```
Dentro de máquina ejecutar

```
sudo apt install python3-pip git -y
sudo pip install virtualenv --break-system-packages

virtualenv entorno
source entorno/bin/activate
git clone URL_REPOSITORIO
pip install -r requirements.txt
cd api
crear y editar el archivo base.py en función de base.py.bk
```

Ejecutar:

```
uvicorn main:app --host 0.0.0.0 --port 8000
```

---

# PARTE 6: visualizacion1
Ingresar a 

```
multipass shell visualizacion1
```

Ejecuar los siguiente comandos

```
sudo apt install python3-pip git -y
sudo pip install virtualenv --break-system-packages

virtualenv entorno
source entorno/bin/activate
pip install -r requirements.txt
git clone URL_REPO
cd visualizacion
pip install -r requirements.txt
crear y editar el archivo config.py en función de config.py.bk
```

Ejecutar:

```
streamlit run app.py --server.address 0.0.0.0
```

---

# PARTE 8: Verificar

  * En función de la IP del server de visualización, verificar que todo funcione
  * Agregar capturas de pantalla del funcionamiento de todas las máquinas virtuales, API funcionando, Streamlit funcionando, base de datos con datos
  * Agregar las capturas de pantalla en un archivo llamado EVIDENCIAS.md

## CAPTURA EVIDENCIA 
<img width="1600" height="969" alt="imagen" src="https://github.com/user-attachments/assets/af36bb2d-b8be-4fbe-84ff-188956fc3c1d" />


---

Se implementó una arquitectura real separando:

* datos (base1)
* lógica (api1)
* visualización (visualizacion1)

usando flujo profesional con GitHub y despliegue en infraestructura virtual.
