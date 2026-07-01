--
-- PostgreSQL database dump
--

\restrict bnv4gKExDyBxvTCVPIzBXIg47DRjQDWD49fxqqIWhYJgsV87MDX3DtdakoSFpaL

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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

DROP INDEX IF EXISTS public.idx_resource_query;
ALTER TABLE IF EXISTS ONLY public.resources DROP CONSTRAINT IF EXISTS resources_pkey;
DROP TABLE IF EXISTS public.resources;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: resources; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.resources (
    id text NOT NULL,
    original_id text NOT NULL,
    resource_type text NOT NULL,
    root_scope text NOT NULL,
    routing_scope text NOT NULL,
    etag text NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_data jsonb NOT NULL
);


ALTER TABLE public.resources OWNER TO radius;

--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.resources (id, original_id, resource_type, root_scope, routing_scope, etag, created_at, resource_data) FROM stdin;
\.


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: idx_resource_query; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX idx_resource_query ON public.resources USING btree (resource_type, root_scope);


--
-- Name: TABLE resources; Type: ACL; Schema: public; Owner: radius
--

GRANT ALL ON TABLE public.resources TO dynamic_rp;


--
-- PostgreSQL database dump complete
--

\unrestrict bnv4gKExDyBxvTCVPIzBXIg47DRjQDWD49fxqqIWhYJgsV87MDX3DtdakoSFpaL

