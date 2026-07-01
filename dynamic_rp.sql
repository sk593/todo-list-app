--
-- PostgreSQL database dump
--

\restrict 7d3kQnwDa2aJRtRc4rX16fBW9tyPST52IB7yhcgRVqYfTxxwgMuTFyPxvhYLaxd

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
/planes/radius/local/resourcegroups/default/providers/radius.security/secrets/dbsecret/	/planes/radius/local/resourcegroups/default/providers/Radius.Security/secrets/dbsecret	/radius.security/secrets/	/planes/radius/local/resourcegroups/default/	/radius.security/secrets/dbsecret/	32-f483d04cf8a37a7f31d33e11a6ecb64fc1d5b8634101c5af1c378e3a8ac9b3a9	2026-07-01 22:48:27.516774+00	{"id": "/planes/radius/local/resourcegroups/default/providers/Radius.Security/secrets/dbsecret", "name": "dbsecret", "type": "Radius.Security/secrets", "location": "global", "tenantId": "", "properties": {"data": {"PASSWORD": {"value": null}, "USERNAME": {"value": null}}, "application": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/applications/todo-list-app", "environment": "/planes/radius/local/resourcegroups/default/providers/Radius.Core/environments/dev"}, "systemData": {}, "createdApiVersion": "2025-08-01-preview", "provisioningState": "Failed", "updatedApiVersion": "2025-08-01-preview"}
/planes/radius/local/providers/radius.security/locations/global/operationstatuses/b674c855-631a-47e9-8d97-54bd10c8e7eb/	/planes/radius/local/providers/radius.security/locations/global/operationstatuses/b674c855-631a-47e9-8d97-54bd10c8e7eb	/radius.security/locations/operationstatuses/	/planes/radius/local/	/radius.security/locations/global/operationstatuses/b674c855-631a-47e9-8d97-54bd10c8e7eb/	32-bfe6f52a3e59c3286f344f9ded92ec01a1dc4b20e2ed67d005b842a859a7b895	2026-07-01 22:48:27.518293+00	{"id": "/planes/radius/local/providers/radius.security/locations/global/operationstatuses/b674c855-631a-47e9-8d97-54bd10c8e7eb", "name": "b674c855-631a-47e9-8d97-54bd10c8e7eb", "error": {"code": "", "message": "the operation failed due to a concurrency conflict"}, "status": "Failed", "endTime": "2026-07-01T22:48:32.757649573Z", "location": "global", "startTime": "2026-07-01T22:48:27.518084923Z", "resourceID": "/planes/radius/local/resourcegroups/default/providers/Radius.Security/secrets/dbsecret", "retryAfter": 5000000000, "lastUpdatedTime": "2026-07-01T22:48:32.75794614Z"}
/planes/radius/local/resourcegroups/default/providers/radius.compute/containerimages/demo-image/	/planes/radius/local/resourcegroups/default/providers/Radius.Compute/containerImages/demo-image	/radius.compute/containerimages/	/planes/radius/local/resourcegroups/default/	/radius.compute/containerimages/demo-image/	32-f639ad3db45dc23a3fff8d20f4733507226f019e84230f956db98f37919df391	2026-07-01 22:48:27.516774+00	{"id": "/planes/radius/local/resourcegroups/default/providers/Radius.Compute/containerImages/demo-image", "name": "demo-image", "type": "Radius.Compute/containerImages", "location": "global", "tenantId": "", "properties": {"tag": "770228ed7d8b2d88a6b4f435b922d6f2416580f1", "build": {"source": "/app/demo"}, "status": {}, "application": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/applications/todo-list-app", "environment": "/planes/radius/local/resourcegroups/default/providers/Radius.Core/environments/dev"}, "systemData": {}, "createdApiVersion": "2025-08-01-preview", "provisioningState": "Failed", "updatedApiVersion": "2025-08-01-preview"}
/planes/radius/local/providers/radius.compute/locations/global/operationstatuses/8732ffea-6a3e-4158-a5ae-141aa6024bb0/	/planes/radius/local/providers/radius.compute/locations/global/operationstatuses/8732ffea-6a3e-4158-a5ae-141aa6024bb0	/radius.compute/locations/operationstatuses/	/planes/radius/local/	/radius.compute/locations/global/operationstatuses/8732ffea-6a3e-4158-a5ae-141aa6024bb0/	32-44ca9d6457ec86f11ccf8b0626b720c01c5ccb0bc68f7b0dd2ca1e92ef929889	2026-07-01 22:48:27.518419+00	{"id": "/planes/radius/local/providers/radius.compute/locations/global/operationstatuses/8732ffea-6a3e-4158-a5ae-141aa6024bb0", "name": "8732ffea-6a3e-4158-a5ae-141aa6024bb0", "error": {"code": "RecipeDeploymentFailed", "message": "terraform apply failure: exit status 1\\n\\nError: Attempt to index null value\\n\\n  on .terraform/modules/default/Compute/containerImages/recipes/kubernetes/terraform/main.tf line 130, in locals:\\n 130:   registry_username = local.use_auth ? data.kubernetes_secret.registry_creds[0].data[\\"username\\"] : \\"\\"\\n\\nThis value is null, so it does not have any indices.\\n\\nError: Attempt to index null value\\n\\n  on .terraform/modules/default/Compute/containerImages/recipes/kubernetes/terraform/main.tf line 131, in locals:\\n 131:   registry_password = local.use_auth ? data.kubernetes_secret.registry_creds[0].data[\\"password\\"] : \\"\\"\\n\\nThis value is null, so it does not have any indices.\\n"}, "status": "Failed", "endTime": "2026-07-01T22:48:33.232918817Z", "location": "global", "startTime": "2026-07-01T22:48:27.518092796Z", "resourceID": "/planes/radius/local/resourcegroups/default/providers/Radius.Compute/containerImages/demo-image", "retryAfter": 5000000000, "lastUpdatedTime": "2026-07-01T22:48:33.233182293Z"}
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

\unrestrict 7d3kQnwDa2aJRtRc4rX16fBW9tyPST52IB7yhcgRVqYfTxxwgMuTFyPxvhYLaxd

