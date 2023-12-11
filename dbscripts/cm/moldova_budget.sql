-- Table: public.budget_entities

-- DROP TABLE IF EXISTS public.budget_entities;

CREATE TABLE IF NOT EXISTS public.budget_entities
(
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    parent_id integer,
    id integer NOT NULL DEFAULT nextval('budget_entities_id_seq'::regclass),
    CONSTRAINT budget_entities_pkey PRIMARY KEY (id),
    CONSTRAINT parent_fk FOREIGN KEY (parent_id)
        REFERENCES public.budget_entities (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.budget_entities
    OWNER to superset;
-- Index: budget_entities_parent_id

-- DROP INDEX IF EXISTS public.budget_entities_parent_id;

CREATE UNIQUE INDEX IF NOT EXISTS budget_entities_parent_id
    ON public.budget_entities USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST, parent_id ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Table: public.budget_lines

-- DROP TABLE IF EXISTS public.budget_lines;

CREATE TABLE IF NOT EXISTS public.budget_lines
(
    id bigint NOT NULL DEFAULT nextval('budget_entries_id_seq'::regclass),
    region integer,
    org1 integer,
    eco_k integer,
    approved double precision,
    adjusted double precision,
    executed double precision,
    budget_category_id integer NOT NULL,
    file_id integer NOT NULL,
    file_row_no integer NOT NULL,
    budget_entity_id integer,
    CONSTRAINT budget_lines_pkey PRIMARY KEY (id),
    CONSTRAINT budget_categories_fk FOREIGN KEY (budget_category_id)
        REFERENCES public.budget_categories (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT budget_entries_fk FOREIGN KEY (budget_entity_id)
        REFERENCES public.budget_entities (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT file_id_fk FOREIGN KEY (file_id)
        REFERENCES public.files (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.budget_lines
    OWNER to superset;
-- Index: file_id_idx

-- DROP INDEX IF EXISTS public.file_id_idx;

CREATE INDEX IF NOT EXISTS file_id_idx
    ON public.budget_lines USING btree
    (file_id ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: fki_budget_lines_

-- DROP INDEX IF EXISTS public.fki_budget_lines_;

CREATE INDEX IF NOT EXISTS fki_budget_lines_
    ON public.budget_lines USING btree
    (budget_entity_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_category_id_fk

-- DROP INDEX IF EXISTS public.fki_category_id_fk;

CREATE INDEX IF NOT EXISTS fki_category_id_fk
    ON public.budget_lines USING btree
    (budget_category_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_i

-- DROP INDEX IF EXISTS public.fki_i;

CREATE INDEX IF NOT EXISTS fki_i
    ON public.budget_lines USING btree
    (file_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.budget_categories

-- DROP TABLE IF EXISTS public.budget_categories;

CREATE TABLE IF NOT EXISTS public.budget_categories
(
    name character varying(510) COLLATE pg_catalog."default" NOT NULL,
    parent_id integer,
    id integer NOT NULL DEFAULT nextval('category_id_seq'::regclass),
    CONSTRAINT id_pk PRIMARY KEY (id),
    CONSTRAINT parent_fk FOREIGN KEY (parent_id)
        REFERENCES public.budget_categories (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.budget_categories
    OWNER to superset;
-- Index: budget_categories_name_parent_id

-- DROP INDEX IF EXISTS public.budget_categories_name_parent_id;

CREATE UNIQUE INDEX IF NOT EXISTS budget_categories_name_parent_id
    ON public.budget_categories USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST, parent_id ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: fki_parent_fk

-- DROP INDEX IF EXISTS public.fki_parent_fk;

CREATE INDEX IF NOT EXISTS fki_parent_fk
    ON public.budget_categories USING btree
    (parent_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.files

-- DROP TABLE IF EXISTS public.files;

CREATE TABLE IF NOT EXISTS public.files
(
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
    converted boolean NOT NULL DEFAULT false,
    resource_id character varying(255) COLLATE pg_catalog."default",
    id integer NOT NULL DEFAULT nextval('files_id_seq'::regclass),
    CONSTRAINT pk_id PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.files
    OWNER to superset;
-- Index: converted_idx

-- DROP INDEX IF EXISTS public.converted_idx;

CREATE INDEX IF NOT EXISTS converted_idx
    ON public.files USING btree
    (converted ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: id_idx

-- DROP INDEX IF EXISTS public.id_idx;

CREATE INDEX IF NOT EXISTS id_idx
    ON public.files USING btree
    (id ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: revision_idx

-- DROP INDEX IF EXISTS public.revision_idx;

CREATE INDEX IF NOT EXISTS revision_idx
    ON public.files USING btree
    (revision_id COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;