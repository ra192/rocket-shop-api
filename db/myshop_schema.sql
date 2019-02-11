--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2015-03-19 13:59:19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 179 (class 3079 OID 11750)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2002 (class 0 OID 0)
-- Dependencies: 179
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 803013)
-- Name: category; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE category (
    id bigint NOT NULL,
    displayname character varying(255),
    name character varying(255) NOT NULL,
    parent_id bigint
);


ALTER TABLE public.category OWNER TO myshop;

--
-- TOC entry 171 (class 1259 OID 803021)
-- Name: category_property; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE category_property (
    category_id bigint NOT NULL,
    properties_id bigint NOT NULL
);


ALTER TABLE public.category_property OWNER TO myshop;

--
-- TOC entry 178 (class 1259 OID 803116)
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: myshop
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO myshop;

--
-- TOC entry 172 (class 1259 OID 803026)
-- Name: product; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(255) NOT NULL,
    description character varying(255),
    displayname character varying(255),
    imageurl character varying(255),
    price double precision,
    rating real,
    category_id bigint
);


ALTER TABLE public.product OWNER TO myshop;

--
-- TOC entry 173 (class 1259 OID 803034)
-- Name: product_property_value; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE product_property_value (
    product_id bigint NOT NULL,
    propertyvalues_id bigint NOT NULL
);


ALTER TABLE public.product_property_value OWNER TO myshop;

--
-- TOC entry 174 (class 1259 OID 803039)
-- Name: property; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE property (
    id bigint NOT NULL,
    displayname character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.property OWNER TO myshop;

--
-- TOC entry 176 (class 1259 OID 803050)
-- Name: property_value; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE property_value (
    id bigint NOT NULL,
    displayname character varying(255),
    name character varying(255) NOT NULL,
    property_id bigint
);


ALTER TABLE public.property_value OWNER TO myshop;

--
-- TOC entry 175 (class 1259 OID 803047)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE user_roles (
    user_id bigint NOT NULL,
    roles character varying(255)
);


ALTER TABLE public.user_roles OWNER TO myshop;

--
-- TOC entry 177 (class 1259 OID 803058)
-- Name: users; Type: TABLE; Schema: public; Owner: myshop; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    accesstoken character varying(255),
    email character varying(255),
    expiresin integer,
    firstname character varying(255),
    lastname character varying(255),
    userid bigint
);


ALTER TABLE public.users OWNER TO myshop;

--
-- TOC entry 1857 (class 2606 OID 803020)
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 1861 (class 2606 OID 803025)
-- Name: category_property_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY category_property
    ADD CONSTRAINT category_property_pkey PRIMARY KEY (category_id, properties_id);


--
-- TOC entry 1863 (class 2606 OID 803033)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 1867 (class 2606 OID 803038)
-- Name: product_property_value_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY product_property_value
    ADD CONSTRAINT product_property_value_pkey PRIMARY KEY (product_id, propertyvalues_id);


--
-- TOC entry 1869 (class 2606 OID 803046)
-- Name: property_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY property
    ADD CONSTRAINT property_pkey PRIMARY KEY (id);


--
-- TOC entry 1873 (class 2606 OID 803057)
-- Name: property_value_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY property_value
    ADD CONSTRAINT property_value_pkey PRIMARY KEY (id);


--
-- TOC entry 1865 (class 2606 OID 803069)
-- Name: uk_10ganh9tlh637bdu7sammc8dp; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT uk_10ganh9tlh637bdu7sammc8dp UNIQUE (code);


--
-- TOC entry 1871 (class 2606 OID 803071)
-- Name: uk_4jaqs0het40jm6jmhi9fa7dmh; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY property
    ADD CONSTRAINT uk_4jaqs0het40jm6jmhi9fa7dmh UNIQUE (name);


--
-- TOC entry 1859 (class 2606 OID 803067)
-- Name: uk_foei036ov74bv692o5lh5oi66; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT uk_foei036ov74bv692o5lh5oi66 UNIQUE (name);


--
-- TOC entry 1877 (class 2606 OID 803075)
-- Name: uk_gdiweoh9h0bbhh4os5to79ro4; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT uk_gdiweoh9h0bbhh4os5to79ro4 UNIQUE (userid);


--
-- TOC entry 1875 (class 2606 OID 803073)
-- Name: uk_n0l0ufcisjulucwf00f0dwmq8; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY property_value
    ADD CONSTRAINT uk_n0l0ufcisjulucwf00f0dwmq8 UNIQUE (name);


--
-- TOC entry 1879 (class 2606 OID 803065)
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: myshop; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 1887 (class 2606 OID 803111)
-- Name: fk_21tglbpy5qhtj27hfnj9r5r0e; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY property_value
    ADD CONSTRAINT fk_21tglbpy5qhtj27hfnj9r5r0e FOREIGN KEY (property_id) REFERENCES property(id);


--
-- TOC entry 1886 (class 2606 OID 803106)
-- Name: fk_9npctppqlup1uag8ek04qpmie; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT fk_9npctppqlup1uag8ek04qpmie FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 1883 (class 2606 OID 803091)
-- Name: fk_b7afq93qsn7aoydaftixggf14; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY product
    ADD CONSTRAINT fk_b7afq93qsn7aoydaftixggf14 FOREIGN KEY (category_id) REFERENCES category(id);


--
-- TOC entry 1882 (class 2606 OID 803086)
-- Name: fk_g8w1nffq59rad5xuppqt5dk0y; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY category_property
    ADD CONSTRAINT fk_g8w1nffq59rad5xuppqt5dk0y FOREIGN KEY (category_id) REFERENCES category(id);


--
-- TOC entry 1884 (class 2606 OID 803096)
-- Name: fk_maqwk3gqjmmj8kqoq6d5o1yfc; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY product_property_value
    ADD CONSTRAINT fk_maqwk3gqjmmj8kqoq6d5o1yfc FOREIGN KEY (propertyvalues_id) REFERENCES property_value(id);


--
-- TOC entry 1880 (class 2606 OID 803076)
-- Name: fk_p6elut499cl32in8b8j8sy2n4; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY category
    ADD CONSTRAINT fk_p6elut499cl32in8b8j8sy2n4 FOREIGN KEY (parent_id) REFERENCES category(id);


--
-- TOC entry 1885 (class 2606 OID 803101)
-- Name: fk_s4r657t8hjwicmafctnfoe4js; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY product_property_value
    ADD CONSTRAINT fk_s4r657t8hjwicmafctnfoe4js FOREIGN KEY (product_id) REFERENCES product(id);


--
-- TOC entry 1881 (class 2606 OID 803081)
-- Name: fk_so37fdysm1mymuynyftclcf3d; Type: FK CONSTRAINT; Schema: public; Owner: myshop
--

ALTER TABLE ONLY category_property
    ADD CONSTRAINT fk_so37fdysm1mymuynyftclcf3d FOREIGN KEY (properties_id) REFERENCES property(id);


--
-- TOC entry 2001 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-03-19 13:59:19

--
-- PostgreSQL database dump complete
--

