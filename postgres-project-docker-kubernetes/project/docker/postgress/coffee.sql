--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Debian 12.3-1.pgdg100+1)
-- Dumped by pg_dump version 12.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: bean_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bean_type (
    id integer NOT NULL,
    name text,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bean_type OWNER TO postgres;

--
-- Name: bean_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bean_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bean_type_id_seq OWNER TO postgres;

--
-- Name: bean_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bean_type_id_seq OWNED BY public.bean_type.id;


--
-- Name: carrier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carrier (
    id integer NOT NULL,
    name text,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.carrier OWNER TO postgres;

--
-- Name: carrier_bean_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carrier_bean_type (
    id integer NOT NULL,
    carrier_id integer,
    bean_type_id integer,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.carrier_bean_type OWNER TO postgres;

--
-- Name: carrier_bean_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carrier_bean_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carrier_bean_type_id_seq OWNER TO postgres;

--
-- Name: carrier_bean_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carrier_bean_type_id_seq OWNED BY public.carrier_bean_type.id;


--
-- Name: carrier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carrier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carrier_id_seq OWNER TO postgres;

--
-- Name: carrier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carrier_id_seq OWNED BY public.carrier.id;


--
-- Name: delivery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery (
    id integer NOT NULL,
    supplier_id integer,
    driver_id integer,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.delivery OWNER TO postgres;

--
-- Name: delivery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivery_id_seq OWNER TO postgres;

--
-- Name: delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivery_id_seq OWNED BY public.delivery.id;


--
-- Name: driver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.driver (
    id integer NOT NULL,
    name text,
    carrier_id integer,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.driver OWNER TO postgres;

--
-- Name: driver_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.driver_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.driver_id_seq OWNER TO postgres;

--
-- Name: driver_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.driver_id_seq OWNED BY public.driver.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    id integer NOT NULL,
    name text,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Name: suplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suplier_id_seq OWNER TO postgres;

--
-- Name: suplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suplier_id_seq OWNED BY public.supplier.id;


--
-- Name: supplier_bean_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier_bean_type (
    id integer NOT NULL,
    supplier_id integer,
    bean_type_id integer,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.supplier_bean_type OWNER TO postgres;

--
-- Name: supplier_bean_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_bean_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_bean_type_id_seq OWNER TO postgres;

--
-- Name: supplier_bean_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_bean_type_id_seq OWNED BY public.supplier_bean_type.id;


--
-- Name: bean_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bean_type ALTER COLUMN id SET DEFAULT nextval('public.bean_type_id_seq'::regclass);


--
-- Name: carrier id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrier ALTER COLUMN id SET DEFAULT nextval('public.carrier_id_seq'::regclass);


--
-- Name: carrier_bean_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrier_bean_type ALTER COLUMN id SET DEFAULT nextval('public.carrier_bean_type_id_seq'::regclass);


--
-- Name: delivery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery ALTER COLUMN id SET DEFAULT nextval('public.delivery_id_seq'::regclass);


--
-- Name: driver id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver ALTER COLUMN id SET DEFAULT nextval('public.driver_id_seq'::regclass);


--
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN id SET DEFAULT nextval('public.suplier_id_seq'::regclass);


--
-- Name: supplier_bean_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_bean_type ALTER COLUMN id SET DEFAULT nextval('public.supplier_bean_type_id_seq'::regclass);


--
-- Data for Name: bean_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bean_type (id, name, updated_at, created_at) FROM stdin;
1	Arabica	2020-06-19 18:51:27.239904+00	2020-06-19 18:51:27.239904+00
2	Robusta	2020-06-19 18:51:27.239904+00	2020-06-19 18:51:27.239904+00
3	Liberica	2020-06-19 18:51:27.239904+00	2020-06-19 18:51:27.239904+00
\.


--
-- Data for Name: carrier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carrier (id, name, updated_at, created_at) FROM stdin;
1	FedEx	2020-06-19 18:49:30.775341+00	2020-06-19 18:49:30.775341+00
2	UPS	2020-06-19 18:49:30.775341+00	2020-06-19 18:49:30.775341+00
3	USPS	2020-06-19 18:49:30.775341+00	2020-06-19 18:49:30.775341+00
4	DHL	2020-06-19 18:49:30.775341+00	2020-06-19 18:49:30.775341+00
5	EMS	2020-06-19 18:49:30.775341+00	2020-06-19 18:49:30.775341+00
\.


--
-- Data for Name: carrier_bean_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carrier_bean_type (id, carrier_id, bean_type_id, updated_at, created_at) FROM stdin;
1	1	1	2020-06-19 20:00:03.320853+00	2020-06-19 20:00:03.320853+00
3	2	2	2020-06-19 20:00:03.320853+00	2020-06-19 20:00:03.320853+00
4	4	3	2020-06-19 20:00:03.320853+00	2020-06-19 20:00:03.320853+00
5	5	1	2020-06-19 20:00:03.320853+00	2020-06-19 20:00:03.320853+00
6	5	2	2020-06-19 20:00:03.320853+00	2020-06-19 20:00:03.320853+00
2	1	2	2020-06-19 20:00:03.320853+00	2020-06-19 20:00:03.320853+00
\.


--
-- Data for Name: delivery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery (id, supplier_id, driver_id, updated_at, created_at) FROM stdin;
1	1	1	2020-06-19 19:41:04.774421+00	2020-06-19 19:41:04.774421+00
3	8	3	2020-06-19 19:41:04.774421+00	2020-06-19 19:41:04.774421+00
4	4	3	2020-06-19 19:53:09.561976+00	2020-06-19 19:53:09.561976+00
2	8	2	2020-06-19 19:41:04.774421+00	2020-06-19 19:41:04.774421+00
\.


--
-- Data for Name: driver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.driver (id, name, carrier_id, updated_at, created_at) FROM stdin;
1	Driver 1	1	2020-06-19 18:52:27.522188+00	2020-06-19 18:52:27.522188+00
2	Driver 2	2	2020-06-19 18:52:27.522188+00	2020-06-19 18:52:27.522188+00
3	Driver 3	4	2020-06-19 18:52:27.522188+00	2020-06-19 18:52:27.522188+00
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier (id, name, updated_at, created_at) FROM stdin;
1	Vietnam	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
2	Brazil	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
3	Colombia	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
4	Indonesia	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
5	Honduras	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
6	India	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
7	Ethioia	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
8	Uganda	2020-06-19 18:53:18.243051+00	2020-06-19 18:53:18.243051+00
\.


--
-- Data for Name: supplier_bean_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier_bean_type (id, supplier_id, bean_type_id, updated_at, created_at) FROM stdin;
1	1	2	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
2	4	2	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
3	4	1	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
4	6	2	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
5	6	1	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
6	2	1	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
7	3	1	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
8	7	1	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
9	8	1	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
10	8	2	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
11	5	3	2020-06-19 18:56:53.040374+00	2020-06-19 18:56:53.040374+00
12	2	3	2020-06-19 19:57:55.354076+00	2020-06-19 19:57:55.354076+00
\.


--
-- Name: bean_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bean_type_id_seq', 3, true);


--
-- Name: carrier_bean_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carrier_bean_type_id_seq', 6, true);


--
-- Name: carrier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carrier_id_seq', 5, true);


--
-- Name: delivery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivery_id_seq', 4, true);


--
-- Name: driver_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.driver_id_seq', 3, true);


--
-- Name: suplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suplier_id_seq', 8, true);


--
-- Name: supplier_bean_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_bean_type_id_seq', 12, true);


--
-- Name: bean_type bean_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bean_type
    ADD CONSTRAINT bean_type_pkey PRIMARY KEY (id);


--
-- Name: carrier_bean_type carrier_bean_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrier_bean_type
    ADD CONSTRAINT carrier_bean_type_pkey PRIMARY KEY (id);


--
-- Name: carrier carrier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrier
    ADD CONSTRAINT carrier_pkey PRIMARY KEY (id);


--
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (id);


--
-- Name: driver driver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_pkey PRIMARY KEY (id);


--
-- Name: supplier suplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT suplier_pkey PRIMARY KEY (id);


--
-- Name: supplier_bean_type supplier_bean_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_bean_type
    ADD CONSTRAINT supplier_bean_type_pkey PRIMARY KEY (id);


--
-- Name: carrier_bean_type carrier_bean_type_bean_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrier_bean_type
    ADD CONSTRAINT carrier_bean_type_bean_type_id_fkey FOREIGN KEY (bean_type_id) REFERENCES public.bean_type(id);


--
-- Name: carrier_bean_type carrier_bean_type_carrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrier_bean_type
    ADD CONSTRAINT carrier_bean_type_carrier_id_fkey FOREIGN KEY (carrier_id) REFERENCES public.carrier(id);


--
-- Name: delivery delivery_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.driver(id);


--
-- Name: delivery delivery_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: driver driver_carrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_carrier_id_fkey FOREIGN KEY (carrier_id) REFERENCES public.carrier(id);


--
-- Name: supplier_bean_type supplier_bean_type_bean_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_bean_type
    ADD CONSTRAINT supplier_bean_type_bean_type_id_fkey FOREIGN KEY (bean_type_id) REFERENCES public.bean_type(id);


--
-- Name: supplier_bean_type supplier_bean_type_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_bean_type
    ADD CONSTRAINT supplier_bean_type_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- PostgreSQL database dump complete
--

