-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.sales_transactions
(
    transaction_id serial,
    transaction_date date,
    transaction_time time with time zone,
    sales_outlet_id integer,
    staff_id integer,
    customer_id integer,
    CONSTRAINT "Transaction ID" PRIMARY KEY (transaction_id)
);

COMMENT ON TABLE public.sales_transactions
    IS 'Sales transactions table.';

CREATE TABLE IF NOT EXISTS public.products
(
    product_id serial,
    product_type_id integer NOT NULL,
    product_name character varying(150) NOT NULL,
    description text,
    price numeric(10, 2) NOT NULL,
    CONSTRAINT product_id PRIMARY KEY (product_id)
);

COMMENT ON TABLE public.products
    IS 'Products table.';

CREATE TABLE IF NOT EXISTS public.sales_detail
(
    detail_id serial,
    transaction_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(10, 2) NOT NULL,
    CONSTRAINT detail_id PRIMARY KEY (detail_id)
);

CREATE TABLE IF NOT EXISTS public.product_type
(
    product_type_id serial,
    product_category character varying(50) NOT NULL,
    product_type character varying(100) NOT NULL,
    PRIMARY KEY (product_type_id)
);

ALTER TABLE IF EXISTS public.products
    ADD CONSTRAINT product_type_id FOREIGN KEY (product_type_id)
    REFERENCES public.product_type (product_type_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sales_detail
    ADD CONSTRAINT transaction_id FOREIGN KEY (transaction_id)
    REFERENCES public.sales_transactions (transaction_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sales_detail
    ADD CONSTRAINT product_id FOREIGN KEY (product_id)
    REFERENCES public.products (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;