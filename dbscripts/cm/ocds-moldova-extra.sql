--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Debian 14.7-1.pgdg110+1)
-- Dumped by pg_dump version 14.7

-- Started on 2023-06-13 12:52:39 UTC

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

--
-- TOC entry 6 (class 2615 OID 215337)
-- Name: extra; Type: SCHEMA; Schema: -; Owner: superset
--

CREATE SCHEMA extra;


ALTER SCHEMA extra OWNER TO superset;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 259 (class 1259 OID 215339)
-- Name: focus_town; Type: TABLE; Schema: extra; Owner: superset
--

CREATE TABLE extra.focus_town (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE extra.focus_town OWNER TO superset;

--
-- TOC entry 260 (class 1259 OID 215346)
-- Name: town_institutions; Type: TABLE; Schema: extra; Owner: superset
--

CREATE TABLE extra.town_institutions (
    fiscal_code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    focus_town_id integer NOT NULL
);


ALTER TABLE extra.town_institutions OWNER TO superset;

--
-- TOC entry 262 (class 1259 OID 215469)
-- Name: cahul_releases; Type: MATERIALIZED VIEW; Schema: extra; Owner: superset
--

CREATE MATERIALIZED VIEW extra.cahul_releases AS
 SELECT tpi._link_release
   FROM moldova.tender_procuringentity tpi,
    extra.town_institutions ti,
    extra.focus_town ft
  WHERE (((ti.fiscal_code)::text = tpi._party_identifier_id) AND ((ft.name)::text = 'Cahul'::text) AND (ft.id = ti.focus_town_id))
  WITH NO DATA;


ALTER TABLE extra.cahul_releases OWNER TO superset;

--
-- TOC entry 263 (class 1259 OID 215477)
-- Name: calarasi_releases; Type: MATERIALIZED VIEW; Schema: extra; Owner: superset
--

CREATE MATERIALIZED VIEW extra.calarasi_releases AS
 SELECT tpi._link_release
   FROM moldova.tender_procuringentity tpi,
    extra.town_institutions ti,
    extra.focus_town ft
  WHERE (((ti.fiscal_code)::text = tpi._party_identifier_id) AND ((ft.name)::text = 'Calarasi'::text) AND (ft.id = ti.focus_town_id))
  WITH NO DATA;


ALTER TABLE extra.calarasi_releases OWNER TO superset;

--
-- TOC entry 261 (class 1259 OID 215361)
-- Name: chisinau_releases; Type: MATERIALIZED VIEW; Schema: extra; Owner: superset
--

CREATE MATERIALIZED VIEW extra.chisinau_releases AS
 SELECT tpi._link_release
   FROM moldova.tender_procuringentity tpi,
    extra.town_institutions ti,
    extra.focus_town ft
  WHERE (((ti.fiscal_code)::text = tpi._party_identifier_id) AND ((ft.name)::text = 'Chisinau'::text) AND (ft.id = ti.focus_town_id))
  WITH NO DATA;


ALTER TABLE extra.chisinau_releases OWNER TO superset;

--
-- TOC entry 258 (class 1259 OID 215338)
-- Name: focus_town_id_seq; Type: SEQUENCE; Schema: extra; Owner: superset
--

CREATE SEQUENCE extra.focus_town_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE extra.focus_town_id_seq OWNER TO superset;

--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 258
-- Name: focus_town_id_seq; Type: SEQUENCE OWNED BY; Schema: extra; Owner: superset
--

ALTER SEQUENCE extra.focus_town_id_seq OWNED BY extra.focus_town.id;


--
-- TOC entry 264 (class 1259 OID 215484)
-- Name: straseni_releases; Type: MATERIALIZED VIEW; Schema: extra; Owner: superset
--

CREATE MATERIALIZED VIEW extra.straseni_releases AS
 SELECT tpi._link_release
   FROM moldova.tender_procuringentity tpi,
    extra.town_institutions ti,
    extra.focus_town ft
  WHERE (((ti.fiscal_code)::text = tpi._party_identifier_id) AND ((ft.name)::text = 'Straseni'::text) AND (ft.id = ti.focus_town_id))
  WITH NO DATA;


ALTER TABLE extra.straseni_releases OWNER TO superset;

--
-- TOC entry 265 (class 1259 OID 215491)
-- Name: ungheni_releases; Type: MATERIALIZED VIEW; Schema: extra; Owner: superset
--

CREATE MATERIALIZED VIEW extra.ungheni_releases AS
 SELECT tpi._link_release
   FROM moldova.tender_procuringentity tpi,
    extra.town_institutions ti,
    extra.focus_town ft
  WHERE (((ti.fiscal_code)::text = tpi._party_identifier_id) AND ((ft.name)::text = 'Ungheni'::text) AND (ft.id = ti.focus_town_id))
  WITH NO DATA;


ALTER TABLE extra.ungheni_releases OWNER TO superset;

--
-- TOC entry 3332 (class 2604 OID 215342)
-- Name: focus_town id; Type: DEFAULT; Schema: extra; Owner: superset
--

ALTER TABLE ONLY extra.focus_town ALTER COLUMN id SET DEFAULT nextval('extra.focus_town_id_seq'::regclass);


--
-- TOC entry 3492 (class 0 OID 215339)
-- Dependencies: 259
-- Data for Name: focus_town; Type: TABLE DATA; Schema: extra; Owner: superset
--

COPY extra.focus_town (id, name) FROM stdin;
1	Chisinau
2	Cahul
3	Calarasi
4	Straseni
5	Ungheni
\.


--
-- TOC entry 3493 (class 0 OID 215346)
-- Dependencies: 260
-- Data for Name: town_institutions; Type: TABLE DATA; Schema: extra; Owner: superset
--

COPY extra.town_institutions (fiscal_code, name, focus_town_id) FROM stdin;
1007601010448	DETS s. Botanica	1
1017620006193	Liceul Teoretic „Vasile Vasilache”	1
1007601009484	Primăria municipiului Chişinău	1
1007601009576	Direcţia generală finanţe	1
1007601009406	Pretura sectorului Centru	1
1007601009602	Pretura sectorului Botanica	1
1007601009509	Pretura sectorului Buiucani	1
1007601010518	Pretura sectorului Ciocana	1
1007601009853	Pretura sectorului Râşcani	1
1006601003393	Centrul militar al mun. Chişinău	1
1007601010600	Direcţia generală educație tineret și sport	1
1007601009967	DETS s. Buiucani	1
1007601009417	DETS s. Centru	1
1007601009565	DETS s. Ciocana	1
1007601009716	DETS s.  Râşcani	1
1007601010585	Direcţia cultură	1
1007601011353	Centrul municipal de plasament și reabilitare a copiilor de vârsta fragedă	1
1007601010541	Direcţia generală asistenţă socială și sănătate	1
1007601010530	Centrul de găzduirea și orientare pentru persoanele fără domiciliu stabil	1
1007601010563	Centrul de zi şi activităţi „Start”	1
1012600035466	Centru social regional „Renașterea”	1
1007601009543	Direcţia municipală pentru protecţia drepturilor copilului	1
1007601010323	Direcţia generală arhitectură,urbanism	1
1007601009657	Direcția generală mobilitate urbana	1
1020601000059	Direcția generală economie, comerț și turism	1
1007601010493	Direcţia generală locativ-comunală și amenajare	1
1002600047080	Direcţia construcţii capitale	1
1014620004381	Liceul Teoretic „Mircea Eliade”	1
1013620006470	Liceul Teoretic „Alexandr Puşkin”	1
1013620005772	Liceul Teoretic „Spiru Haret” 	1
1013620007189	Şcoala primară-grădiniţă nr.152 „Pas cu pas”	1
1013620005820	Liceul Teoretic „Liviu Rebreanu”	1
1013620005875	Liceul Teoretic „Tudor Vladimirescu”	1
1013620005864	Liceul Teoretic „Traian”	1
1014620002044	Liceul Teoretic „Petru Movilă”	1
1013620007178	Liceul Teoretic „Ştefan cel Mare”	1
1016620000128	Liceul Teoretic ,, Principesa Natalia Dadiani”	1
1013620005842	Liceul Teoretic „Onisifor Ghibu”	1
1015620000209	Liceul Teoretic ,,Petru Rareș’’	1
1013620005901	Liceul Teoretic „Liviu Deleanu”	1
1013620006355	Liceul Teoretic „Ginta Latină”	1
1014620001782	Liceul Teoretic cu Profil Sportiv nr.2	1
1014620005137	Liceul Teoretic „Olimp”	1
1013620007352	Liceul Teoretic „Constantin Negruzzi”	1
1015620000173	Gimnaziul nr. 41 „Dumitru Matcovschi”	1
1013620005853	Liceul Teoretic „Minerva”	1
1013620005886	Leceul Teoretic „Mihai Viteazul”	1
1013620006193	Liceul Teoretic „Alexandru Ioan Cuza”	1
1013620007857	Liceul Teoretic „Universul”	1
1013620006230	Liceul Teoretic „Hyperion”or. Durleşti	1
1013620006344	Liceul Teoretic „Alexandru cel Bun”, or. Sîngera	1
1013620006366	Liceul Teoretic „Toader Bubuiog”, com Bubuieci	1
1014620005023	Liceul Teoretic „Nicolae Bălcescu” com Ciorscu	1
1013620006322	Liceul Teoretic „Budeşti” com. Budeşti	1
1013620006241	Liceul Teoretic „Grigore Vieru” com. Băcioi	1
1014620000132	Şcoala primară-gradiniţă „Ilie Fulga” com. Stâuceni	1
1015620000106	Școala primară-grădiniță nr. 199	1
1007601010552	Şcoala sportivă de polo pe apă „Delfin”	1
1017620003787	Liceul Teoretic „Ion și Doina Aldea-Teodorovici” 	1
1017620003075	Liceul Teoretic „Georghe Asachi”	1
1016620007582	Liceul Teoretic „Mihail Berezovschi”	1
1017620000845	Liceul Teoretic „Nicolae Iorga”	1
1017620000834	Liceul Teoretic „Milescu Spătaru”	1
1019620001008	Liceul Teoretic „Beniamin Zeev Herțli”	1
1018620000417	Liceul Teoretic „Alexei Mateevici” com. Cricova	1
1016620007593	Liceul Teoretic „Dmitrii Cantemir”	1
1014620001298	Liceul Teoretic „Gaudeamus”	1
1019620000975	Liceul Teoretic „Academia copiilor”	1
1019620000805	Școala primară nr. 101 com Bacioi	1
1019620000713	Gimnaziul nr. 42 com. Codru	1
1014620002147	Școala primară nr. 12 A. Popovici	1
1018620000428	Liceul seral nr. 1	1
1019620005475	Liceul Seral nr. 2	1
1019620008144	Liceul Teoretic „Mihail Kogâlniceanu”	1
1021620003524	Liceul Teoretic Gratiesti    	1
1021620003591	Liceul Teoretic M. Kotiubinski, 	1
1021620003627	Scoala Primara-Gradinita nr.88 	1
1021620003535	Gimnaziul NR. 31	1
1021620003605	Liceul Teoretic Anton Cehov	1
1021620003502	Liceul Teoretic Dragoș - Vodă	1
1021620003638	Liceul Teoretic Matei Basarab	1
1021620003454	Liceul Teoretic cu profil de arte Nicolae Sulac	1
1021620003384	Liceul Teoretic Ramban ORT	1
1021620005182	Liceul Teoretic Ion Creanga	1
1021620007913	Liceul Teoretic „ Waldorf ”	1
1022620000520	Liceul Teatral Orășinesc „ Iurie Harmelin”	1
1007601008340	Primăria mun. Cahul	2
1007601010297	Consiliul Raional Cahul	2
1012601000018	Direcția Generală Învățământ Cahul	2
1012620009740	LT ”M. Eminescu”	2
1012620009784	LT ”I. Vodă”	2
1012620010081	L.T. ”I. Creanga”	2
1012620010069	L.T. ”D. Cantemir”	2
1012620009924	L.T.”P. Rumeantev”	2
1012620010759	Gimnaziul-grădinita ”S. Rahmaninov”	2
1012620009706	Scoala primară ”A. Donici„	2
1012620010955	Scoala primară ”A. Mateevici„	2
1012620010748	Gimnaziul ”M. Kogălniceanu” din s. Cotihana	2
1009603003860	IMSP Spitalul Raional Cahul	2
1013603001636	IMSP Centrul de Sanatate Cahul	2
1002603000457	IM Piata Centrală	2
1002603000859	SA Apă-Canal Cahul	2
1003603003307	IM Gospodăria Comunal-Locativa	2
1003603002023	IM CRDSL Cahul	2
1003603006711	IM Centrul Sanatații Femeii ”Virginia”	2
1003609007259	IM Gospodăria Comunal-Locativa Călărași	3
1007601009004	Primăria orașului Călărași	3
1011600041978	IM Gospodăria Comunală Strășeni	4
1003600129174	IM Apă Canal Strășeni	4
1008601000042	Primăria municipiului Strășeni	4
1002609000747	IM Apa-Canal Ungheni	5
1002609001375	SA Comgaz Plus	5
1008609004839	SRL Ave Ungheni 	5
1022609000853	IM Ungheni Proiect	5
1007601001787	Primăria orașului Ungheni 	5
\.


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 258
-- Name: focus_town_id_seq; Type: SEQUENCE SET; Schema: extra; Owner: superset
--

SELECT pg_catalog.setval('extra.focus_town_id_seq', 1, true);


--
-- TOC entry 3334 (class 2606 OID 215344)
-- Name: focus_town focus_town_pkey; Type: CONSTRAINT; Schema: extra; Owner: superset
--

ALTER TABLE ONLY extra.focus_town
    ADD CONSTRAINT focus_town_pkey PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 215350)
-- Name: town_institutions town_institutions_pkey; Type: CONSTRAINT; Schema: extra; Owner: superset
--

ALTER TABLE ONLY extra.town_institutions
    ADD CONSTRAINT town_institutions_pkey PRIMARY KEY (fiscal_code);


--
-- TOC entry 3342 (class 1259 OID 215475)
-- Name: cahul_releases_id_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE INDEX cahul_releases_id_idx ON extra.cahul_releases USING btree (_link_release);


--
-- TOC entry 3343 (class 1259 OID 215483)
-- Name: calarasi_releases_id_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE INDEX calarasi_releases_id_idx ON extra.calarasi_releases USING btree (_link_release);


--
-- TOC entry 3341 (class 1259 OID 215367)
-- Name: chisinau_releases_id_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE INDEX chisinau_releases_id_idx ON extra.chisinau_releases USING btree (_link_release);


--
-- TOC entry 3335 (class 1259 OID 215345)
-- Name: name_unique; Type: INDEX; Schema: extra; Owner: superset
--

CREATE UNIQUE INDEX name_unique ON extra.focus_town USING btree (name);


--
-- TOC entry 3344 (class 1259 OID 215490)
-- Name: straseni_releases_id_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE INDEX straseni_releases_id_idx ON extra.straseni_releases USING btree (_link_release);


--
-- TOC entry 3336 (class 1259 OID 215358)
-- Name: ti_fiscal_code_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE UNIQUE INDEX ti_fiscal_code_idx ON extra.town_institutions USING btree (fiscal_code);


--
-- TOC entry 3337 (class 1259 OID 215360)
-- Name: ti_focus_town_id_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE INDEX ti_focus_town_id_idx ON extra.town_institutions USING btree (focus_town_id);


--
-- TOC entry 3338 (class 1259 OID 215476)
-- Name: town_institutions_name_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE UNIQUE INDEX town_institutions_name_idx ON extra.town_institutions USING btree (name);


--
-- TOC entry 3345 (class 1259 OID 215497)
-- Name: ungheni_releases_id_idx; Type: INDEX; Schema: extra; Owner: superset
--

CREATE INDEX ungheni_releases_id_idx ON extra.ungheni_releases USING btree (_link_release);


--
-- TOC entry 3346 (class 2606 OID 215351)
-- Name: town_institutions town_institutions_focus_town_id_fkey; Type: FK CONSTRAINT; Schema: extra; Owner: superset
--

ALTER TABLE ONLY extra.town_institutions
    ADD CONSTRAINT town_institutions_focus_town_id_fkey FOREIGN KEY (focus_town_id) REFERENCES extra.focus_town(id);


--
-- TOC entry 3495 (class 0 OID 215469)
-- Dependencies: 262 3500
-- Name: cahul_releases; Type: MATERIALIZED VIEW DATA; Schema: extra; Owner: superset
--

REFRESH MATERIALIZED VIEW extra.cahul_releases;


--
-- TOC entry 3496 (class 0 OID 215477)
-- Dependencies: 263 3500
-- Name: calarasi_releases; Type: MATERIALIZED VIEW DATA; Schema: extra; Owner: superset
--

REFRESH MATERIALIZED VIEW extra.calarasi_releases;


--
-- TOC entry 3494 (class 0 OID 215361)
-- Dependencies: 261 3500
-- Name: chisinau_releases; Type: MATERIALIZED VIEW DATA; Schema: extra; Owner: superset
--

REFRESH MATERIALIZED VIEW extra.chisinau_releases;


--
-- TOC entry 3497 (class 0 OID 215484)
-- Dependencies: 264 3500
-- Name: straseni_releases; Type: MATERIALIZED VIEW DATA; Schema: extra; Owner: superset
--

REFRESH MATERIALIZED VIEW extra.straseni_releases;


--
-- TOC entry 3498 (class 0 OID 215491)
-- Dependencies: 265 3500
-- Name: ungheni_releases; Type: MATERIALIZED VIEW DATA; Schema: extra; Owner: superset
--

REFRESH MATERIALIZED VIEW extra.ungheni_releases;
