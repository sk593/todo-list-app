--
-- PostgreSQL database dump
--

\restrict fJYPW1P8Cy2Vv9IA8GKnmo6IQsaapIwdrH3KrfvJ7OdndhQGq4ZzgZnxR7Yzupn

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
/planes/radius/local/resourcegroups/default/providers/applications.core/environments/default/	/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default	/applications.core/environments/	/planes/radius/local/resourcegroups/default/	/applications.core/environments/default/	32-856c7317cde2ebbcf6e6f5b35d689c88eddd260c1cf23e7e006a16349ca226b9	2026-07-01 21:18:33.341467+00	{"id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default", "name": "default", "type": "Applications.Core/environments", "location": "global", "tenantId": "", "properties": {"compute": {"aci": {"resourceGroup": ""}, "kind": "kubernetes", "kubernetes": {"namespace": "default"}}, "providers": {"aws": {}, "azure": {}}, "recipeConfig": {"env": {}, "bicep": {"Authentication": null}, "terraform": {"authentication": {"git": {}}}}}, "systemData": {}, "createdApiVersion": "2023-10-01-preview", "provisioningState": "Succeeded", "updatedApiVersion": "2023-10-01-preview"}
/planes/radius/local/resourcegroups/default/providers/radius.core/recipepacks/azure-terraform/	/planes/radius/local/resourcegroups/default/providers/Radius.Core/recipePacks/azure-terraform	/radius.core/recipepacks/	/planes/radius/local/resourcegroups/default/	/radius.core/recipepacks/azure-terraform/	32-1f86100f96cdaf03768a481affb010daffc82a50d5393a12452384d4d76aff3d	2026-07-01 21:20:11.315543+00	{"id": "/planes/radius/local/resourcegroups/default/providers/Radius.Core/recipePacks/azure-terraform", "name": "azure-terraform", "type": "Radius.Core/recipePacks", "location": "global", "tenantId": "", "properties": {"recipes": {"Radius.Compute/routes": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Compute/routes/recipes/kubernetes/terraform?ref=main"}, "Radius.Security/secrets": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Security/secrets/recipes/kubernetes/terraform?ref=main"}, "Radius.Compute/containers": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Compute/containers/recipes/kubernetes/terraform?ref=main"}, "Radius.Data/mySqlDatabases": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Data/mySqlDatabases/recipes/azure/terraform?ref=sk593/add-azure-mysql-recipe", "parameters": {"location": "eastus", "resourceGroupName": "sk-test", "azure_subscription_id": "83d22c15-134b-4a0a-b10d-0a63710f9ab3"}}, "Radius.Compute/containerImages": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Compute/containerImages/recipes/kubernetes/terraform?ref=main", "parameters": {"registry": "ghcr.io/sk593", "registrySecretName": "ghcr-registry-creds"}}, "Radius.Data/postgreSqlDatabases": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Data/postgreSqlDatabases/recipes/kubernetes/terraform?ref=main"}, "Radius.Compute/persistentVolumes": {"kind": "terraform", "source": "git::https://github.com/radius-project/resource-types-contrib.git//Compute/persistentVolumes/recipes/kubernetes/terraform?ref=main"}}}, "systemData": {}, "createdApiVersion": "2025-08-01-preview", "provisioningState": "Succeeded", "updatedApiVersion": "2025-08-01-preview"}
/planes/radius/local/resourcegroups/default/providers/radius.core/environments/dev/	/planes/radius/local/resourcegroups/default/providers/Radius.Core/environments/dev	/radius.core/environments/	/planes/radius/local/resourcegroups/default/	/radius.core/environments/dev/	32-9a0abd7ebe8a779b23cb98becff93d731086099fb31a0afdc7583b2aa492fdff	2026-07-01 21:20:11.627534+00	{"id": "/planes/radius/local/resourcegroups/default/providers/Radius.Core/environments/dev", "name": "dev", "type": "Radius.Core/environments", "location": "global", "tenantId": "", "properties": {"providers": {"azure": {"subscriptionId": "83d22c15-134b-4a0a-b10d-0a63710f9ab3", "resourceGroupName": "sk-test"}, "kubernetes": {"namespace": "default"}}, "recipePacks": ["/planes/radius/local/resourcegroups/default/providers/Radius.Core/recipePacks/azure-terraform"]}, "systemData": {}, "createdApiVersion": "2025-08-01-preview", "provisioningState": "Succeeded", "updatedApiVersion": "2025-08-01-preview"}
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

GRANT ALL ON TABLE public.resources TO applications_rp;


--
-- PostgreSQL database dump complete
--

\unrestrict fJYPW1P8Cy2Vv9IA8GKnmo6IQsaapIwdrH3KrfvJ7OdndhQGq4ZzgZnxR7Yzupn

