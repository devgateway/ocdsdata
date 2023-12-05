-- Table: public.files

-- DROP TABLE IF EXISTS public.files;

CREATE TABLE IF NOT EXISTS public.files
(
    id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    resource_group_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    cache_last_updated character varying(255) COLLATE pg_catalog."default",
    revision_timestamp timestamp without time zone,
    size character varying(255) COLLATE pg_catalog."default",
    state character varying(255) COLLATE pg_catalog."default",
    hash character varying(255) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    format character varying(255) COLLATE pg_catalog."default",
    last_modified timestamp without time zone,
    url_type character varying(255) COLLATE pg_catalog."default",
    mimetype character varying(255) COLLATE pg_catalog."default",
    cache_url character varying(255) COLLATE pg_catalog."default",
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    created timestamp without time zone NOT NULL,
    url character varying(255) COLLATE pg_catalog."default" NOT NULL,
    webstore_url character varying(255) COLLATE pg_catalog."default",
    mimetype_inner character varying(255) COLLATE pg_catalog."default",
    "position" character varying(255) COLLATE pg_catalog."default",
    revision_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    resource_type character varying(255) COLLATE pg_catalog."default",
    content bytea,
    CONSTRAINT files_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.files
    OWNER to superset;
-- Index: id_idx

-- DROP INDEX IF EXISTS public.id_idx;

CREATE UNIQUE INDEX IF NOT EXISTS id_idx
    ON public.files USING btree
    (id COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: revision_idx

-- DROP INDEX IF EXISTS public.revision_idx;

CREATE INDEX IF NOT EXISTS revision_idx
    ON public.files USING btree
    (revision_id COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;