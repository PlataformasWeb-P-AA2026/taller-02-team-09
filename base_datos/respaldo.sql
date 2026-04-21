--
-- PostgreSQL database dump
--

\restrict jWn0KDWipgUScOSzEDu4fk9x7D80DRaef9NOWZ2ufozWa5L2FQW53IaRuyjQjIc

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg13+1)
-- Dumped by pg_dump version 18.3 (Debian 18.3-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: empleados; Type: TABLE; Schema: public; Owner: apiuser
--

CREATE TABLE public.empleados (
    id integer NOT NULL,
    nombre character varying(100),
    departamento character varying(100),
    salario integer
);


ALTER TABLE public.empleados OWNER TO apiuser;

--
-- Name: empleados_id_seq; Type: SEQUENCE; Schema: public; Owner: apiuser
--

CREATE SEQUENCE public.empleados_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empleados_id_seq OWNER TO apiuser;

--
-- Name: empleados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiuser
--

ALTER SEQUENCE public.empleados_id_seq OWNED BY public.empleados.id;


--
-- Name: empleados id; Type: DEFAULT; Schema: public; Owner: apiuser
--

ALTER TABLE ONLY public.empleados ALTER COLUMN id SET DEFAULT nextval('public.empleados_id_seq'::regclass);


--
-- Data for Name: empleados; Type: TABLE DATA; Schema: public; Owner: apiuser
--

COPY public.empleados (id, nombre, departamento, salario) FROM stdin;
1	Ana	TI	1200
2	Luis	Finanzas	1500
3	Carlos	Marketing	1100
4	Maria	TI	1400
\.


--
-- Name: empleados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiuser
--

SELECT pg_catalog.setval('public.empleados_id_seq', 1, false);


--
-- Name: empleados empleados_pkey; Type: CONSTRAINT; Schema: public; Owner: apiuser
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict jWn0KDWipgUScOSzEDu4fk9x7D80DRaef9NOWZ2ufozWa5L2FQW53IaRuyjQjIc

