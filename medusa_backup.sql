--
-- PostgreSQL database dump
--

\restrict CjKgsMnelJP45EbAZgO21NbxzyjkKeBXhZhTCJRUsZ4cp9clXZWU3VinxfKH0Tb

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

-- Started on 2025-10-27 01:06:06

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

--
-- TOC entry 1251 (class 1247 OID 21101)
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO postgres;

--
-- TOC entry 1245 (class 1247 OID 21080)
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO postgres;

--
-- TOC entry 1191 (class 1247 OID 20746)
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- TOC entry 1260 (class 1247 OID 21151)
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 284 (class 1259 OID 20698)
-- Name: account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 20419)
-- Name: api_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 19929)
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 19922)
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 21295)
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 20614)
-- Name: capture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 20172)
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 20187)
-- Name: cart_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 20196)
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 20222)
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 20234)
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 21865)
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 21665)
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 20245)
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 20258)
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 20269)
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 20372)
-- Name: credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 20539)
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 20084)
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 21851)
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 20094)
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 20108)
-- Name: customer_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 20118)
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 21459)
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 21351)
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 21485)
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 21474)
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 21361)
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 21369)
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 21392)
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 19348)
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 19189)
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 19201)
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 21324)
-- Name: invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 21647)
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 21646)
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 6592 (class 0 OID 0)
-- Dependencies: 334
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- TOC entry 337 (class 1259 OID 21660)
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 21659)
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 19148)
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 19147)
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 6593 (class 0 OID 0)
-- Dependencies: 217
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- TOC entry 332 (class 1259 OID 21594)
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 21586)
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 20733)
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 20722)
-- Name: order_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 21688)
-- Name: order_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 20785)
-- Name: order_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 20800)
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 20799)
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO postgres;

--
-- TOC entry 6594 (class 0 OID 0)
-- Dependencies: 290
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- TOC entry 309 (class 1259 OID 21086)
-- Name: order_claim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 21085)
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO postgres;

--
-- TOC entry 6595 (class 0 OID 0)
-- Dependencies: 308
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- TOC entry 310 (class 1259 OID 21109)
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 21122)
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 21180)
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_credit_line OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 20732)
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO postgres;

--
-- TOC entry 6596 (class 0 OID 0)
-- Dependencies: 286
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- TOC entry 306 (class 1259 OID 21052)
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 21051)
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO postgres;

--
-- TOC entry 6597 (class 0 OID 0)
-- Dependencies: 305
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- TOC entry 307 (class 1259 OID 21067)
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 21709)
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 20814)
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 20838)
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 20862)
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    is_tax_inclusive boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item_adjustment OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 20852)
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 21716)
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 21729)
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 20826)
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 20872)
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 20883)
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 20893)
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 20774)
-- Name: order_summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 20903)
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 20596)
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 20550)
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'partially_captured'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 20578)
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 20570)
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 20585)
-- Name: payment_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 19618)
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 19694)
-- Name: price_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 19704)
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 19799)
-- Name: price_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 19649)
-- Name: price_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 19609)
-- Name: price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 19292)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 19392)
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 19422)
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 19381)
-- Name: product_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 19326)
-- Name: product_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 19337)
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 21759)
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 21844)
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 19359)
-- Name: product_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 19408)
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 19370)
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 19308)
-- Name: product_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 21761)
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 19429)
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 21760)
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 19871)
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 19886)
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text, 'once'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 19846)
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 19857)
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    attribute text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text, 'use_by_attribute'::text, 'spend_by_attribute'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 20059)
-- Name: promotion_campaign_budget_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget_usage (
    id text NOT NULL,
    attribute_value text NOT NULL,
    used numeric DEFAULT 0 NOT NULL,
    budget_id text NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign_budget_usage OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 19915)
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 19903)
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 19936)
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 21304)
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 21785)
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 20605)
-- Name: refund; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 20664)
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    code text NOT NULL
);


ALTER TABLE public.refund_reason OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 20391)
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 20402)
-- Name: region_country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 21793)
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 19216)
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 21022)
-- Name: return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 21021)
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO postgres;

--
-- TOC entry 6598 (class 0 OID 0)
-- Dependencies: 302
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- TOC entry 343 (class 1259 OID 21745)
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 21037)
-- Name: return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 20916)
-- Name: return_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 20161)
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 21813)
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 21896)
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 21895)
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.script_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 6599 (class 0 OID 0)
-- Dependencies: 354
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- TOC entry 322 (class 1259 OID 21380)
-- Name: service_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 21429)
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 21823)
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 21447)
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 21408)
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 21418)
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 19165)
-- Name: stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 19155)
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 20435)
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 20447)
-- Name: store_currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 20464)
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 20486)
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 20500)
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 20472)
-- Name: tax_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 21337)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 21269)
-- Name: user_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_preference (
    id text NOT NULL,
    user_id text NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.user_preference OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 21281)
-- Name: view_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_configuration (
    id text NOT NULL,
    entity text NOT NULL,
    name text,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.view_configuration OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 21619)
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01K86RDE809XPH4SGAG431TMJK'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO postgres;

--
-- TOC entry 5478 (class 2604 OID 21650)
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- TOC entry 5180 (class 2604 OID 19151)
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- TOC entry 5356 (class 2604 OID 20736)
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- TOC entry 5368 (class 2604 OID 20803)
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- TOC entry 5416 (class 2604 OID 21089)
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- TOC entry 5410 (class 2604 OID 21055)
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- TOC entry 5402 (class 2604 OID 21025)
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- TOC entry 5518 (class 2604 OID 21899)
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- TOC entry 6515 (class 0 OID 20698)
-- Dependencies: 284
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6499 (class 0 OID 20419)
-- Dependencies: 268
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K86RGJF3XMXAK5T28R4GC6JX	pk_69c53270bc91cc472fc081cb345af5b7b312c7ba6f7d0dec9a4e71bfe0aa5cb0		pk_69c***cb0	Webshop	publishable	\N		2025-10-22 20:07:06.98+00	\N	\N	2025-10-22 20:07:06.98+00	\N
\.


--
-- TOC entry 6480 (class 0 OID 19929)
-- Dependencies: 249
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- TOC entry 6479 (class 0 OID 19922)
-- Dependencies: 248
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- TOC entry 6546 (class 0 OID 21295)
-- Dependencies: 315
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01K86XDQD1483ZENN6R8E1CRAM	{"user_id": "user_01K86XDQG1305RPG7F26988VWY"}	2025-10-22 21:32:56.609+00	2025-10-22 21:32:56.724+00	\N
\.


--
-- TOC entry 6513 (class 0 OID 20614)
-- Dependencies: 282
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- TOC entry 6488 (class 0 OID 20172)
-- Dependencies: 257
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
\.


--
-- TOC entry 6489 (class 0 OID 20187)
-- Dependencies: 258
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6490 (class 0 OID 20196)
-- Dependencies: 259
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
\.


--
-- TOC entry 6491 (class 0 OID 20222)
-- Dependencies: 260
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id, is_tax_inclusive) FROM stdin;
\.


--
-- TOC entry 6492 (class 0 OID 20234)
-- Dependencies: 261
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- TOC entry 6584 (class 0 OID 21865)
-- Dependencies: 353
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6569 (class 0 OID 21665)
-- Dependencies: 338
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6493 (class 0 OID 20245)
-- Dependencies: 262
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6494 (class 0 OID 20258)
-- Dependencies: 263
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- TOC entry 6495 (class 0 OID 20269)
-- Dependencies: 264
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- TOC entry 6496 (class 0 OID 20372)
-- Dependencies: 265
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6506 (class 0 OID 20539)
-- Dependencies: 275
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-10-22 20:06:17.202+00	2025-10-22 20:06:17.202+00	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-10-22 20:06:17.202+00	2025-10-22 20:06:17.202+00	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-10-22 20:06:17.202+00	2025-10-22 20:06:17.202+00	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-10-22 20:06:17.203+00	2025-10-22 20:06:17.203+00	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-10-22 20:06:17.204+00	2025-10-22 20:06:17.204+00	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
mwk	K	K	2	0	{"value": "0", "precision": 20}	Malawian Kwacha	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
tjs	TJS	с.	2	0	{"value": "0", "precision": 20}	Tajikistani Somoni	2025-10-22 20:06:17.205+00	2025-10-22 20:06:17.205+00	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
xpf	₣	₣	0	0	{"value": "0", "precision": 20}	CFP Franc	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-10-22 20:06:17.206+00	2025-10-22 20:06:17.206+00	\N
\.


--
-- TOC entry 6483 (class 0 OID 20084)
-- Dependencies: 252
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
\.


--
-- TOC entry 6583 (class 0 OID 21851)
-- Dependencies: 352
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6484 (class 0 OID 20094)
-- Dependencies: 253
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6485 (class 0 OID 20108)
-- Dependencies: 254
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6486 (class 0 OID 20118)
-- Dependencies: 255
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- TOC entry 6559 (class 0 OID 21459)
-- Dependencies: 328
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- TOC entry 6550 (class 0 OID 21351)
-- Dependencies: 319
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6561 (class 0 OID 21485)
-- Dependencies: 330
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6560 (class 0 OID 21474)
-- Dependencies: 329
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6551 (class 0 OID 21361)
-- Dependencies: 320
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-10-22 20:06:17.255+00	2025-10-22 20:06:17.255+00	\N
\.


--
-- TOC entry 6552 (class 0 OID 21369)
-- Dependencies: 321
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01K86RGJ9SDK7TTBJPA65FHT5W	European Warehouse delivery	shipping	\N	2025-10-22 20:07:06.81+00	2025-10-22 20:07:06.81+00	\N
\.


--
-- TOC entry 6554 (class 0 OID 21392)
-- Dependencies: 323
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01K86RGJ9RYGA9ZCR8SBG4BFT8	country	gb	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
fgz_01K86RGJ9RZAFRM1NMZXSFMMCQ	country	de	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
fgz_01K86RGJ9RJNP03DW3WP9EW4D6	country	dk	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
fgz_01K86RGJ9SQTY7ZTT1GB49TD0W	country	se	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
fgz_01K86RGJ9STKR7K4ERE2MP22G1	country	fr	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
fgz_01K86RGJ9SZAA1S3151D3TX9YV	country	es	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
fgz_01K86RGJ9S3485H4D9TJV0NPPK	country	it	\N	\N	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	\N	\N	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
\.


--
-- TOC entry 6459 (class 0 OID 19348)
-- Dependencies: 228
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K86RGJH19D8KPRP1HHFMVC0H	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.029+00	2025-10-22 21:47:41.008+00	0	prod_01K86RGJGSFGNYEBD80ZBASQQR
img_01K86RGJH1AYX152NWFQXJEFAW	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.029+00	2025-10-22 21:47:41.008+00	1	prod_01K86RGJGSFGNYEBD80ZBASQQR
img_01K86RGJGZ7J4F2SFDRG0PZK9B	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00	0	prod_01K86RGJGSDMNSWH34XZ83V1HG
img_01K86RGJGZEQRW4DGE7YT1JFY4	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00	1	prod_01K86RGJGSDMNSWH34XZ83V1HG
img_01K86RGJGXVTGSFDMQ0DZ47P1N	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN
img_01K86RGJGXP54592N818R32VVD	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00	1	prod_01K86RGJGSDAQ3VAGK2ABX4VFN
img_01K86RGJGXD5KSTAEEGDDNZC3S	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00	2	prod_01K86RGJGSDAQ3VAGK2ABX4VFN
img_01K86RGJGX6FCNAGVW86KY7EPE	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00	3	prod_01K86RGJGSDAQ3VAGK2ABX4VFN
img_01K86RGJGY3NHHZ2ESJ67C6JY3	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00	0	prod_01K86RGJGSA0PYV2C3WZY4GHJG
img_01K86RGJGZC930F9DYPHG45SV0	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00	1	prod_01K86RGJGSA0PYV2C3WZY4GHJG
img_01K870CTRNJBRRVRSZN1673PR2	http://localhost:9000/static/1761171892853-phillip-goldsberry-fZuleEfeA1Q-unsplash.jpg	\N	2025-10-22 22:24:53.014+00	2025-10-22 22:24:53.014+00	\N	0	prod_01K870AG8DXCZV5NN6J5NVFKY0
img_01K86ZJ6GSQ2P4TW8T5XETZ6EX	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.577+00	2025-10-22 22:25:33.56+00	0	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR
img_01K86ZJ6GSEZEH38Q6DMSVJDNJ	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.577+00	2025-10-22 22:25:33.56+00	1	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR
img_01K86ZJ6GRJ34CC651F3N50XTJ	https://medusa-public-images.s3.eu-west-1.amazonaws.com/coffee-mug.png	\N	2025-10-22 22:10:20.314+00	2025-10-22 22:25:36.635+00	2025-10-22 22:25:36.619+00	0	prod_01K86ZJ6GQQJ9WEV3FA3DR8HT2
img_01K8715YC0D9FDFZQ72TAHHNME	http://localhost:9000/static/1761172715856-virender-singh-hE0nmTffKtM-unsplash.jpg	\N	2025-10-22 22:38:35.904+00	2025-10-22 22:38:35.904+00	\N	0	prod_01K8715YBZDSTSAZ4PXMR8HZJS
img_01K871H01GNF24FGHAAV8SP8CM	http://localhost:9000/static/1761173078033-bence-balla-schottner-vFwjD8JLP4M-unsplash.jpg	\N	2025-10-22 22:44:38.065+00	2025-10-22 22:44:38.065+00	\N	0	prod_01K871H01D777X2BKZX991DA8K
img_01K870TZYY7NYVST715VXTZ07J	http://localhost:9000/static/1761172357068-paul-weaver-nWidMEQsnAQ-unsplash.jpg	\N	2025-10-22 22:32:37.087+00	2025-10-23 17:32:54.962+00	2025-10-23 17:32:54.909+00	0	prod_01K870TZYX6C9NVBWGX1YAH303
img_01K89286HC6MKJK5GX2EV0R7TX	http://localhost:9000/static/1761240947179-paul-weaver-nWidMEQsnAQ-unsplash.jpg	\N	2025-10-23 17:35:47.245+00	2025-10-23 17:35:47.245+00	\N	0	prod_01K89286HA6YCDJWZ2DH68KBNB
img_01K898RB2D2Y9865GRF4VRVGR3	http://localhost:9000/static/1761247767527-laura-chouette-HUnrPHgMHsA-unsplash.jpg	\N	2025-10-23 19:29:27.63+00	2025-10-23 19:29:27.63+00	\N	0	prod_01K898RB2BFVKT544YNZHRC3DG
img_01K899Z57ZA9BPJ4M0AGZBAMCH	http://localhost:9000/static/1761249039559-guglielmo-basile-fupKD-E4GZ0-unsplash.jpg	\N	2025-10-23 19:50:39.616+00	2025-10-23 19:50:39.616+00	\N	0	prod_01K899Z57YTQT04HG5J1P39R5W
\.


--
-- TOC entry 6452 (class 0 OID 19189)
-- Dependencies: 221
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01K86RGJMRQSSJS4XGTV982MNF	2025-10-22 20:07:07.162+00	2025-10-22 21:47:40.948+00	2025-10-22 21:47:40.946+00	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K86RGJMRVAXS4NKVQBWQAV1B	2025-10-22 20:07:07.162+00	2025-10-22 21:47:40.963+00	2025-10-22 21:47:40.946+00	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K86RGJMR7N61ZKNVCWP8CMWT	2025-10-22 20:07:07.162+00	2025-10-22 21:47:40.971+00	2025-10-22 21:47:40.946+00	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K86RGJMS67MTG1ZMQ4W7GKKX	2025-10-22 20:07:07.162+00	2025-10-22 21:47:40.977+00	2025-10-22 21:47:40.946+00	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K86RGJMQEV0EMP4CH7QA21Y5	2025-10-22 20:07:07.162+00	2025-10-22 21:47:44.861+00	2025-10-22 21:47:44.861+00	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K86RGJMQ3ENGXS906AVK6AN7	2025-10-22 20:07:07.162+00	2025-10-22 21:47:44.869+00	2025-10-22 21:47:44.861+00	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K86RGJMQGRHNVKHKCQTCBSJE	2025-10-22 20:07:07.162+00	2025-10-22 21:47:44.874+00	2025-10-22 21:47:44.861+00	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K86RGJMRV22338QPY0C69023	2025-10-22 20:07:07.162+00	2025-10-22 21:47:44.881+00	2025-10-22 21:47:44.861+00	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K86RGJMPH3JT778M54W0A0NW	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.342+00	2025-10-22 21:47:48.342+00	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01K86RGJMPRAXEF6HRF9J8SCV3	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.35+00	2025-10-22 21:47:48.342+00	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01K86RGJMPN4GJ5MATE9143MSS	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.356+00	2025-10-22 21:47:48.342+00	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01K86RGJMPRYS6B6C99SANT4GT	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.361+00	2025-10-22 21:47:48.342+00	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01K86RGJMN7Z1PBQ3AY48Y3500	2025-10-22 20:07:07.161+00	2025-10-22 21:47:48.367+00	2025-10-22 21:47:48.342+00	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01K86RGJMPFMNWR5FJYX48N9EV	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.372+00	2025-10-22 21:47:48.342+00	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01K86RGJMPR6281BGG47MPRTRM	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.377+00	2025-10-22 21:47:48.342+00	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01K86RGJMP4EG2MRPP55PDS7PF	2025-10-22 20:07:07.162+00	2025-10-22 21:47:48.382+00	2025-10-22 21:47:48.342+00	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
iitem_01K86RGJMQF0TTDXS6D1JKM3QP	2025-10-22 20:07:07.162+00	2025-10-22 21:47:51.165+00	2025-10-22 21:47:51.165+00	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K86RGJMQ821H6Y3YQZ9SP5NC	2025-10-22 20:07:07.162+00	2025-10-22 21:47:51.172+00	2025-10-22 21:47:51.165+00	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K86RGJMQ62BS4RXP0B21R9A9	2025-10-22 20:07:07.162+00	2025-10-22 21:47:51.177+00	2025-10-22 21:47:51.165+00	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K86RGJMQVBMB5MT1BEB1TSV0	2025-10-22 20:07:07.162+00	2025-10-22 21:47:51.183+00	2025-10-22 21:47:51.165+00	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K870AGCYE0ZQBGZ57A09V9X1	2025-10-22 22:23:36.862+00	2025-10-22 22:23:36.862+00	\N	SOFA-C-GRE	\N	\N	\N	\N	\N	\N	\N	\N	t	Green	Green	\N	\N
iitem_01K870AGCYP084BWMFQW2KKZ7G	2025-10-22 22:23:36.862+00	2025-10-22 22:23:36.862+00	\N	SOFA-C-GRA	\N	\N	\N	\N	\N	\N	\N	\N	t	Gray	Gray	\N	\N
iitem_01K870AGCY69SAGYZRTZF9DE9X	2025-10-22 22:23:36.862+00	2025-10-22 22:23:36.862+00	\N	SOFA-C-RED	\N	\N	\N	\N	\N	\N	\N	\N	t	Red	Red	\N	\N
iitem_01K870AGCYPMR55SX59AHZVT5A	2025-10-22 22:23:36.862+00	2025-10-22 22:23:36.862+00	\N	SOFA-C-NAV	\N	\N	\N	\N	\N	\N	\N	\N	t	Navy	Navy	\N	\N
iitem_01K86ZJ6KAMZWEN1A3B3SE6S6B	2025-10-22 22:10:20.395+00	2025-10-22 22:25:33.524+00	2025-10-22 22:25:33.523+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K86ZJ6KAR2WJ2MZYQ0Y8KBEN	2025-10-22 22:10:20.395+00	2025-10-22 22:25:33.531+00	2025-10-22 22:25:33.523+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K86ZJ6KBFERST72JA4ZA4KJ3	2025-10-22 22:10:20.395+00	2025-10-22 22:25:33.535+00	2025-10-22 22:25:33.523+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K86ZJ6KBD4876TV8WAESHMVY	2025-10-22 22:10:20.395+00	2025-10-22 22:25:33.541+00	2025-10-22 22:25:33.523+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K86ZJ6KACJ3RP5TE41DDMXJN	2025-10-22 22:10:20.395+00	2025-10-22 22:25:36.595+00	2025-10-22 22:25:36.595+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	One Size	One Size	\N	\N
iitem_01K8715YETR1ZZB7HMV3VPM3DJ	2025-10-22 22:38:35.994+00	2025-10-22 22:38:35.994+00	\N	POL-L-SKB	\N	\N	\N	\N	\N	\N	\N	\N	t	Sky Blue	Sky Blue	\N	\N
iitem_01K8715YET4FCQ9NJVMD2QYHB7	2025-10-22 22:38:35.994+00	2025-10-22 22:38:35.994+00	\N	POL-L-WHI	\N	\N	\N	\N	\N	\N	\N	\N	t	White	White	\N	\N
iitem_01K8715YETHCCVCKE6AGJT3Y4Y	2025-10-22 22:38:35.994+00	2025-10-22 22:38:35.994+00	\N	POL-L-ORG	\N	\N	\N	\N	\N	\N	\N	\N	t	Orange	Orange	\N	\N
iitem_01K871H042G2BN2Q44VMGWS8QS	2025-10-22 22:44:38.147+00	2025-10-22 22:44:38.147+00	\N	BLK-H-YEČ	\N	\N	\N	\N	\N	\N	\N	\N	t	Yellow	Yellow	\N	\N
iitem_01K871H0426SQD4Q1MQE9A5XF6	2025-10-22 22:44:38.147+00	2025-10-22 22:44:38.147+00	\N	BLK-H-BRW	\N	\N	\N	\N	\N	\N	\N	\N	t	Brown	Brown	\N	\N
iitem_01K871H042B7SHN6ZRDQM7EGKW	2025-10-22 22:44:38.147+00	2025-10-22 22:44:38.147+00	\N	BLK-H-PAT	\N	\N	\N	\N	\N	\N	\N	\N	t	Pattern	Pattern	\N	\N
iitem_01K89286MPJTSVH249VWRAKDVP	2025-10-23 17:35:47.351+00	2025-10-23 17:35:47.351+00	\N	AME-D-COG	\N	\N	\N	\N	\N	\N	\N	\N	t	Cognac	Cognac	\N	\N
iitem_01K89286MQDPZE5J4TEDWVGGK7	2025-10-23 17:35:47.351+00	2025-10-23 17:35:47.351+00	\N	AME-D-BLA	\N	\N	\N	\N	\N	\N	\N	\N	t	Black	Black	\N	\N
iitem_01K89286MQ5WPWE154J6GRP220	2025-10-23 17:35:47.351+00	2025-10-23 17:35:47.351+00	\N	AME-D-WHI	\N	\N	\N	\N	\N	\N	\N	\N	t	White	White	\N	\N
iitem_01K898RB57X2PYYVKEKKN3CY1Q	2025-10-23 19:29:27.72+00	2025-10-23 19:29:27.72+00	\N	ALP-P-YEL	\N	\N	\N	\N	\N	\N	\N	\N	t	Yellow	Yellow	\N	\N
iitem_01K898RB57RM823HDN8SR2QGJ0	2025-10-23 19:29:27.72+00	2025-10-23 19:29:27.72+00	\N	ALP-P-NAV	\N	\N	\N	\N	\N	\N	\N	\N	t	Navy	Navy	\N	\N
iitem_01K898RB57Y3V5NFGBHJDPS49P	2025-10-23 19:29:27.72+00	2025-10-23 19:29:27.72+00	\N	ALP-P-GRE	\N	\N	\N	\N	\N	\N	\N	\N	t	Green	Green	\N	\N
iitem_01K898RB57KPS7JHBKM3Y3YQ7R	2025-10-23 19:29:27.72+00	2025-10-23 19:29:27.72+00	\N	ALP-P-PAT	\N	\N	\N	\N	\N	\N	\N	\N	t	Pattern	Pattern	\N	\N
iitem_01K899Z5A28CJWHC18PW96ANBD	2025-10-23 19:50:39.682+00	2025-10-23 19:50:39.682+00	\N	AME-R-COG	\N	\N	\N	\N	\N	\N	\N	\N	t	Cognac	Cognac	\N	\N
iitem_01K899Z5A2JZ9VQSTWNPJFHW1N	2025-10-23 19:50:39.683+00	2025-10-23 19:50:39.683+00	\N	AME-R-WHI	\N	\N	\N	\N	\N	\N	\N	\N	t	White	White	\N	\N
iitem_01K899Z5A20W00XV6C9613V878	2025-10-23 19:50:39.683+00	2025-10-23 19:50:39.683+00	\N	AME-R-BLA	\N	\N	\N	\N	\N	\N	\N	\N	t	Black	Black	\N	\N
\.


--
-- TOC entry 6453 (class 0 OID 19201)
-- Dependencies: 222
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01K86RGJSEC4CV4HN61K4JVRX3	2025-10-22 20:07:07.312+00	2025-10-22 21:47:40.962+00	2025-10-22 21:47:40.946+00	iitem_01K86RGJMRQSSJS4XGTV982MNF	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSFNJ2D8BXWKCSP51ZR	2025-10-22 20:07:07.312+00	2025-10-22 21:47:40.971+00	2025-10-22 21:47:40.946+00	iitem_01K86RGJMRVAXS4NKVQBWQAV1B	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSESQPFBHXW6H2GAMSF	2025-10-22 20:07:07.312+00	2025-10-22 21:47:40.977+00	2025-10-22 21:47:40.946+00	iitem_01K86RGJMR7N61ZKNVCWP8CMWT	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSF2VW9M5MJ30ZSBY50	2025-10-22 20:07:07.312+00	2025-10-22 21:47:40.983+00	2025-10-22 21:47:40.946+00	iitem_01K86RGJMS67MTG1ZMQ4W7GKKX	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSDC2MQQZRE876FY45E	2025-10-22 20:07:07.312+00	2025-10-22 21:47:44.869+00	2025-10-22 21:47:44.861+00	iitem_01K86RGJMQEV0EMP4CH7QA21Y5	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSDZS8Q9RMERQA9ADHK	2025-10-22 20:07:07.312+00	2025-10-22 21:47:44.874+00	2025-10-22 21:47:44.861+00	iitem_01K86RGJMQ3ENGXS906AVK6AN7	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSEWQRC3QE0HJF1C2G6	2025-10-22 20:07:07.312+00	2025-10-22 21:47:44.88+00	2025-10-22 21:47:44.861+00	iitem_01K86RGJMQGRHNVKHKCQTCBSJE	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSE2K0HZY45K6RDDDJK	2025-10-22 20:07:07.312+00	2025-10-22 21:47:44.885+00	2025-10-22 21:47:44.861+00	iitem_01K86RGJMRV22338QPY0C69023	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSCNA3CS9HBSD6QMDV7	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.35+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMPH3JT778M54W0A0NW	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSCGT9XEVMKBS6PHKFJ	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.356+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMPRAXEF6HRF9J8SCV3	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSCDB6YQFK4P8YV9YRS	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.361+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMPN4GJ5MATE9143MSS	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSDJJH5ZS57PXWXC9XM	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.367+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMPRYS6B6C99SANT4GT	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSBKK4CNAXRA5DV5B6R	2025-10-22 20:07:07.311+00	2025-10-22 21:47:48.371+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMN7Z1PBQ3AY48Y3500	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSB6HXYZKK9CVV0EKFR	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.376+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMPFMNWR5FJYX48N9EV	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSE2QMH2SYVEK69BFZ0	2025-10-22 20:07:07.312+00	2025-10-22 21:47:51.172+00	2025-10-22 21:47:51.165+00	iitem_01K86RGJMQF0TTDXS6D1JKM3QP	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSDAZGGQ152DC50NDKB	2025-10-22 20:07:07.312+00	2025-10-22 21:47:51.177+00	2025-10-22 21:47:51.165+00	iitem_01K86RGJMQ821H6Y3YQZ9SP5NC	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSDZXDREW16XGRYBW7F	2025-10-22 20:07:07.312+00	2025-10-22 21:47:51.183+00	2025-10-22 21:47:51.165+00	iitem_01K86RGJMQ62BS4RXP0B21R9A9	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSE0XSKXWGDMZ40KEH9	2025-10-22 20:07:07.312+00	2025-10-22 21:47:51.187+00	2025-10-22 21:47:51.165+00	iitem_01K86RGJMQVBMB5MT1BEB1TSV0	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSCDCEPNC3PC67JYDJT	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.382+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMPR6281BGG47MPRTRM	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K86RGJSB4MN1WRYVQXHCNGSA	2025-10-22 20:07:07.312+00	2025-10-22 21:47:48.388+00	2025-10-22 21:47:48.342+00	iitem_01K86RGJMP4EG2MRPP55PDS7PF	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8718R36ZYKCXFCX5N1BTH7P	2025-10-22 22:40:07.782+00	2025-10-22 22:40:07.782+00	\N	iitem_01K8715YETHCCVCKE6AGJT3Y4Y	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	4	0	0	\N	{"value": "4", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8718R367A7FWKDFA26XKPSA	2025-10-22 22:40:07.782+00	2025-10-22 22:40:07.782+00	\N	iitem_01K8715YETR1ZZB7HMV3VPM3DJ	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	24	0	0	\N	{"value": "24", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8718R361DN2CBYK1J3FSP08	2025-10-22 22:40:07.782+00	2025-10-22 22:40:07.782+00	\N	iitem_01K8715YET4FCQ9NJVMD2QYHB7	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	19	0	0	\N	{"value": "19", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871J0STQK9X6SQ7212KDBXP	2025-10-22 22:45:11.611+00	2025-10-22 22:45:11.611+00	\N	iitem_01K871H042B7SHN6ZRDQM7EGKW	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	30	0	0	\N	{"value": "30", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871J0SVRT3Y09SHTV3GJQVA	2025-10-22 22:45:11.611+00	2025-10-22 22:45:11.611+00	\N	iitem_01K871H0426SQD4Q1MQE9A5XF6	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	14	0	0	\N	{"value": "14", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871J0SV9P59HVH8BWYK3KF0	2025-10-22 22:45:11.611+00	2025-10-22 22:45:11.611+00	\N	iitem_01K871H042G2BN2Q44VMGWS8QS	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	7	0	0	\N	{"value": "7", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871S0BF1QE2DT74QVM1A2S2	2025-10-22 22:49:00.528+00	2025-10-22 22:49:00.528+00	\N	iitem_01K870AGCYE0ZQBGZ57A09V9X1	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	23	0	0	\N	{"value": "23", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871S0BGDZ9AH4VCX7T88D09	2025-10-22 22:49:00.528+00	2025-10-22 22:49:00.528+00	\N	iitem_01K870AGCYPMR55SX59AHZVT5A	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	12	0	0	\N	{"value": "12", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871S0BGR8A0Y71BMQCXJCCR	2025-10-22 22:49:00.528+00	2025-10-22 22:49:00.528+00	\N	iitem_01K870AGCYP084BWMFQW2KKZ7G	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	17	0	0	\N	{"value": "17", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K871S0BG3PHBVVPMSFS79WVB	2025-10-22 22:49:00.528+00	2025-10-22 22:49:00.528+00	\N	iitem_01K870AGCY69SAGYZRTZF9DE9X	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	4	0	0	\N	{"value": "4", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8928Z60XE0XX0GKHCST5FSQ	2025-10-23 17:36:12.481+00	2025-10-23 17:36:12.481+00	\N	iitem_01K89286MPJTSVH249VWRAKDVP	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	6	0	0	\N	{"value": "6", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8928Z60Z855905VPB1ZQTNM	2025-10-23 17:36:12.481+00	2025-10-23 17:36:12.481+00	\N	iitem_01K89286MQ5WPWE154J6GRP220	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	4	0	0	\N	{"value": "4", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8928Z609A1GHYPX3PC3V6Z0	2025-10-23 17:36:12.481+00	2025-10-23 17:36:12.481+00	\N	iitem_01K89286MQDPZE5J4TEDWVGGK7	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	5	0	0	\N	{"value": "5", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K898SEJWK1Q3MKGS57EY1G3R	2025-10-23 19:30:03.996+00	2025-10-23 19:30:03.996+00	\N	iitem_01K898RB57KPS7JHBKM3Y3YQ7R	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	7	0	0	\N	{"value": "7", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K898SEJWMG4E5MHP0PWT9M5M	2025-10-23 19:30:03.997+00	2025-10-23 19:30:03.997+00	\N	iitem_01K898RB57X2PYYVKEKKN3CY1Q	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	13	0	0	\N	{"value": "13", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K898SEJWK15HEN9F2Z8WA1Z8	2025-10-23 19:30:03.997+00	2025-10-23 19:30:03.997+00	\N	iitem_01K898RB57RM823HDN8SR2QGJ0	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	9	0	0	\N	{"value": "9", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K898SEJWP6AP1A9WX4WA1Z7K	2025-10-23 19:30:03.997+00	2025-10-23 19:30:03.997+00	\N	iitem_01K898RB57Y3V5NFGBHJDPS49P	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	4	0	0	\N	{"value": "4", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K899ZSWQ8YH2Z2EG6CS2HK3H	2025-10-23 19:51:00.76+00	2025-10-23 19:51:00.76+00	\N	iitem_01K899Z5A20W00XV6C9613V878	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	13	0	0	\N	{"value": "13", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K899ZSWQ91ZJV4AZ3M6PBRNV	2025-10-23 19:51:00.76+00	2025-10-23 19:51:00.76+00	\N	iitem_01K899Z5A2JZ9VQSTWNPJFHW1N	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	4	0	0	\N	{"value": "4", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K899ZSWQSWNDTZHFW1GQRGQ2	2025-10-23 19:51:00.76+00	2025-10-23 19:51:00.76+00	\N	iitem_01K899Z5A28CJWHC18PW96ANBD	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	28	0	0	\N	{"value": "28", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- TOC entry 6548 (class 0 OID 21324)
-- Dependencies: 317
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
invite_01K86RG9HQTSVBGN6V68Y1T7XR	admin@medusa-test.com	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Imludml0ZV8wMUs4NlJHOUhRVFNWQkdONlY2OFkxVDdYUiIsImVtYWlsIjoiYWRtaW5AbWVkdXNhLXRlc3QuY29tIiwiaWF0IjoxNzYxMTYzNjE3LCJleHAiOjE3NjEyNTAwMTcsImp0aSI6IjgzMzVmNTc0LTc3ZDEtNGY5Yy05MDAyLTFkYWEzYWUyN2NjMiJ9.JJHNrRX3NFeT8Vg4mFTfwkXvt8wmRq1_jfUBeLzdJvU	2025-10-23 20:06:57.847+00	\N	2025-10-22 20:06:57.85+00	2025-10-22 21:32:56.731+00	2025-10-22 21:32:56.73+00
\.


--
-- TOC entry 6566 (class 0 OID 21647)
-- Dependencies: 335
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-10-22 20:05:26.850847
2	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-10-22 20:05:26.852704
3	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-10-22 20:05:26.852925
4	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-10-22 20:05:26.878927
5	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-10-22 20:05:26.887687
6	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-10-22 20:05:26.888984
7	order_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-10-22 20:05:26.891642
8	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-10-22 20:05:26.897187
9	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-10-22 20:05:26.90284
10	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-10-22 20:05:26.903447
11	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-10-22 20:05:26.904863
12	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-10-22 20:05:26.922706
13	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-10-22 20:05:26.925705
14	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-10-22 20:05:26.93393
15	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-10-22 20:05:26.936207
16	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-10-22 20:05:26.94329
17	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-10-22 20:05:26.945863
18	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-10-22 20:05:26.950622
\.


--
-- TOC entry 6568 (class 0 OID 21660)
-- Dependencies: 337
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	manual_manual	locfp_01K86RGJ9879ZS55QN629G5K1C	2025-10-22 20:07:06.792587+00	2025-10-22 20:07:06.792587+00	\N
\.


--
-- TOC entry 6567 (class 0 OID 21659)
-- Dependencies: 336
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	fuset_01K86RGJ9SDK7TTBJPA65FHT5W	locfs_01K86RGJAHM4QE669426M4EP3F	2025-10-22 20:07:06.833267+00	2025-10-22 20:07:06.833267+00	\N
\.


--
-- TOC entry 6449 (class 0 OID 19148)
-- Dependencies: 218
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-10-22 20:05:02.462253+00
2	Migration20241210073813	2025-10-22 20:05:02.462253+00
3	Migration20250106142624	2025-10-22 20:05:02.462253+00
4	Migration20250120110820	2025-10-22 20:05:02.462253+00
5	Migration20240307132720	2025-10-22 20:05:03.679133+00
6	Migration20240719123015	2025-10-22 20:05:03.679133+00
7	Migration20241213063611	2025-10-22 20:05:03.679133+00
8	InitialSetup20240401153642	2025-10-22 20:05:04.669094+00
9	Migration20240601111544	2025-10-22 20:05:04.669094+00
10	Migration202408271511	2025-10-22 20:05:04.669094+00
11	Migration20241122120331	2025-10-22 20:05:04.669094+00
12	Migration20241125090957	2025-10-22 20:05:04.669094+00
13	Migration20250411073236	2025-10-22 20:05:04.669094+00
14	Migration20250516081326	2025-10-22 20:05:04.669094+00
15	Migration20250910154539	2025-10-22 20:05:04.669094+00
16	Migration20250911092221	2025-10-22 20:05:04.669094+00
17	Migration20230929122253	2025-10-22 20:05:06.713958+00
18	Migration20240322094407	2025-10-22 20:05:06.713958+00
19	Migration20240322113359	2025-10-22 20:05:06.713958+00
20	Migration20240322120125	2025-10-22 20:05:06.713958+00
21	Migration20240626133555	2025-10-22 20:05:06.713958+00
22	Migration20240704094505	2025-10-22 20:05:06.713958+00
23	Migration20241127114534	2025-10-22 20:05:06.713958+00
24	Migration20241127223829	2025-10-22 20:05:06.713958+00
25	Migration20241128055359	2025-10-22 20:05:06.713958+00
26	Migration20241212190401	2025-10-22 20:05:06.713958+00
27	Migration20250408145122	2025-10-22 20:05:06.713958+00
28	Migration20250409122219	2025-10-22 20:05:06.713958+00
29	Migration20251009110625	2025-10-22 20:05:06.713958+00
30	Migration20240227120221	2025-10-22 20:05:08.016025+00
31	Migration20240617102917	2025-10-22 20:05:08.016025+00
32	Migration20240624153824	2025-10-22 20:05:08.016025+00
33	Migration20241211061114	2025-10-22 20:05:08.016025+00
34	Migration20250113094144	2025-10-22 20:05:08.016025+00
35	Migration20250120110700	2025-10-22 20:05:08.016025+00
36	Migration20250226130616	2025-10-22 20:05:08.016025+00
37	Migration20250508081510	2025-10-22 20:05:08.016025+00
38	Migration20250828075407	2025-10-22 20:05:08.016025+00
39	Migration20250909083125	2025-10-22 20:05:08.016025+00
40	Migration20250916120552	2025-10-22 20:05:08.016025+00
41	Migration20250917143818	2025-10-22 20:05:08.016025+00
42	Migration20250919122137	2025-10-22 20:05:08.016025+00
43	Migration20251006000000	2025-10-22 20:05:08.016025+00
44	Migration20240124154000	2025-10-22 20:05:10.490055+00
45	Migration20240524123112	2025-10-22 20:05:10.490055+00
46	Migration20240602110946	2025-10-22 20:05:10.490055+00
47	Migration20241211074630	2025-10-22 20:05:10.490055+00
48	Migration20240115152146	2025-10-22 20:05:11.387484+00
49	Migration20240222170223	2025-10-22 20:05:11.592134+00
50	Migration20240831125857	2025-10-22 20:05:11.592134+00
51	Migration20241106085918	2025-10-22 20:05:11.592134+00
52	Migration20241205095237	2025-10-22 20:05:11.592134+00
53	Migration20241216183049	2025-10-22 20:05:11.592134+00
54	Migration20241218091938	2025-10-22 20:05:11.592134+00
55	Migration20250120115059	2025-10-22 20:05:11.592134+00
56	Migration20250212131240	2025-10-22 20:05:11.592134+00
57	Migration20250326151602	2025-10-22 20:05:11.592134+00
58	Migration20250508081553	2025-10-22 20:05:11.592134+00
59	Migration20240205173216	2025-10-22 20:05:12.463897+00
60	Migration20240624200006	2025-10-22 20:05:12.463897+00
61	Migration20250120110744	2025-10-22 20:05:12.463897+00
62	InitialSetup20240221144943	2025-10-22 20:05:12.892478+00
63	Migration20240604080145	2025-10-22 20:05:12.892478+00
64	Migration20241205122700	2025-10-22 20:05:12.892478+00
65	Migration20251015123842	2025-10-22 20:05:12.892478+00
66	InitialSetup20240227075933	2025-10-22 20:05:13.2507+00
67	Migration20240621145944	2025-10-22 20:05:13.2507+00
68	Migration20241206083313	2025-10-22 20:05:13.2507+00
69	Migration20240227090331	2025-10-22 20:05:13.57136+00
70	Migration20240710135844	2025-10-22 20:05:13.57136+00
71	Migration20240924114005	2025-10-22 20:05:13.57136+00
72	Migration20241212052837	2025-10-22 20:05:13.57136+00
73	InitialSetup20240228133303	2025-10-22 20:05:13.98907+00
74	Migration20240624082354	2025-10-22 20:05:13.98907+00
75	Migration20240225134525	2025-10-22 20:05:14.274053+00
76	Migration20240806072619	2025-10-22 20:05:14.274053+00
77	Migration20241211151053	2025-10-22 20:05:14.274053+00
78	Migration20250115160517	2025-10-22 20:05:14.274053+00
79	Migration20250120110552	2025-10-22 20:05:14.274053+00
80	Migration20250123122334	2025-10-22 20:05:14.274053+00
81	Migration20250206105639	2025-10-22 20:05:14.274053+00
82	Migration20250207132723	2025-10-22 20:05:14.274053+00
83	Migration20250625084134	2025-10-22 20:05:14.274053+00
84	Migration20250924135437	2025-10-22 20:05:14.274053+00
85	Migration20250929124701	2025-10-22 20:05:14.274053+00
86	Migration20240219102530	2025-10-22 20:05:15.918131+00
87	Migration20240604100512	2025-10-22 20:05:15.918131+00
88	Migration20240715102100	2025-10-22 20:05:15.918131+00
89	Migration20240715174100	2025-10-22 20:05:15.918131+00
90	Migration20240716081800	2025-10-22 20:05:15.918131+00
91	Migration20240801085921	2025-10-22 20:05:15.918131+00
92	Migration20240821164505	2025-10-22 20:05:15.918131+00
93	Migration20240821170920	2025-10-22 20:05:15.918131+00
94	Migration20240827133639	2025-10-22 20:05:15.918131+00
95	Migration20240902195921	2025-10-22 20:05:15.918131+00
96	Migration20240913092514	2025-10-22 20:05:15.918131+00
97	Migration20240930122627	2025-10-22 20:05:15.918131+00
98	Migration20241014142943	2025-10-22 20:05:15.918131+00
99	Migration20241106085223	2025-10-22 20:05:15.918131+00
100	Migration20241129124827	2025-10-22 20:05:15.918131+00
101	Migration20241217162224	2025-10-22 20:05:15.918131+00
102	Migration20250326151554	2025-10-22 20:05:15.918131+00
103	Migration20250522181137	2025-10-22 20:05:15.918131+00
104	Migration20250702095353	2025-10-22 20:05:15.918131+00
105	Migration20250704120229	2025-10-22 20:05:15.918131+00
106	Migration20250910130000	2025-10-22 20:05:15.918131+00
107	Migration20250717162007	2025-10-22 20:05:20.481078+00
108	Migration20240205025928	2025-10-22 20:05:20.799768+00
109	Migration20240529080336	2025-10-22 20:05:20.799768+00
110	Migration20241202100304	2025-10-22 20:05:20.799768+00
111	Migration20240214033943	2025-10-22 20:05:21.447843+00
112	Migration20240703095850	2025-10-22 20:05:21.447843+00
113	Migration20241202103352	2025-10-22 20:05:21.447843+00
114	Migration20240311145700_InitialSetupMigration	2025-10-22 20:05:21.774104+00
115	Migration20240821170957	2025-10-22 20:05:21.774104+00
116	Migration20240917161003	2025-10-22 20:05:21.774104+00
117	Migration20241217110416	2025-10-22 20:05:21.774104+00
118	Migration20250113122235	2025-10-22 20:05:21.774104+00
119	Migration20250120115002	2025-10-22 20:05:21.774104+00
120	Migration20250822130931	2025-10-22 20:05:21.774104+00
121	Migration20250825132614	2025-10-22 20:05:21.774104+00
122	Migration20240509083918_InitialSetupMigration	2025-10-22 20:05:22.97567+00
123	Migration20240628075401	2025-10-22 20:05:22.97567+00
124	Migration20240830094712	2025-10-22 20:05:22.97567+00
125	Migration20250120110514	2025-10-22 20:05:22.97567+00
126	Migration20231228143900	2025-10-22 20:05:23.944259+00
127	Migration20241206101446	2025-10-22 20:05:23.944259+00
128	Migration20250128174331	2025-10-22 20:05:23.944259+00
129	Migration20250505092459	2025-10-22 20:05:23.944259+00
130	Migration20250819104213	2025-10-22 20:05:23.944259+00
131	Migration20250819110924	2025-10-22 20:05:23.944259+00
132	Migration20250908080305	2025-10-22 20:05:23.944259+00
\.


--
-- TOC entry 6563 (class 0 OID 21594)
-- Dependencies: 332
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
noti_01K86YM8P8RE0KCXTT3P8YSF34		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file sofas_armchairs_products.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-22 21:53:59.498+00	2025-10-22 21:53:59.513+00	\N	success
noti_01K86Z63V7Z1479YDY2JYZ3BMM		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file sofas_armchairs_products.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-22 22:03:44.36+00	2025-10-22 22:03:44.366+00	\N	success
noti_01K86ZD547P6AFDTE0HETV947X		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_sofas_armchairs_full.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-22 22:07:35.048+00	2025-10-22 22:07:35.056+00	\N	success
noti_01K86ZJ6QENNEJBMZMD0YQE1J0		feed	admin-ui	{"title": "Product import", "description": "Product import of file product-import-template.csv completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-22 22:10:20.527+00	2025-10-22 22:10:20.533+00	\N	success
noti_01K86ZSB5GB97FXABDCMWMTH7G		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_sofas_armchairs_full.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-22 22:14:14.449+00	2025-10-22 22:14:14.458+00	\N	success
\.


--
-- TOC entry 6562 (class 0 OID 21586)
-- Dependencies: 331
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-10-22 20:06:17.27+00	2025-10-22 20:06:17.27+00	\N
\.


--
-- TOC entry 6518 (class 0 OID 20733)
-- Dependencies: 287
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
\.


--
-- TOC entry 6516 (class 0 OID 20722)
-- Dependencies: 285
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6570 (class 0 OID 21688)
-- Dependencies: 339
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6520 (class 0 OID 20785)
-- Dependencies: 289
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 6522 (class 0 OID 20800)
-- Dependencies: 291
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 6540 (class 0 OID 21086)
-- Dependencies: 309
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- TOC entry 6541 (class 0 OID 21109)
-- Dependencies: 310
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6542 (class 0 OID 21122)
-- Dependencies: 311
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6543 (class 0 OID 21180)
-- Dependencies: 312
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6537 (class 0 OID 21052)
-- Dependencies: 306
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- TOC entry 6538 (class 0 OID 21067)
-- Dependencies: 307
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6571 (class 0 OID 21709)
-- Dependencies: 340
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6523 (class 0 OID 20814)
-- Dependencies: 292
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
\.


--
-- TOC entry 6525 (class 0 OID 20838)
-- Dependencies: 294
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
\.


--
-- TOC entry 6527 (class 0 OID 20862)
-- Dependencies: 296
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at, is_tax_inclusive) FROM stdin;
\.


--
-- TOC entry 6526 (class 0 OID 20852)
-- Dependencies: 295
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 6572 (class 0 OID 21716)
-- Dependencies: 341
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6573 (class 0 OID 21729)
-- Dependencies: 342
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6524 (class 0 OID 20826)
-- Dependencies: 293
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 6528 (class 0 OID 20872)
-- Dependencies: 297
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
\.


--
-- TOC entry 6529 (class 0 OID 20883)
-- Dependencies: 298
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 6530 (class 0 OID 20893)
-- Dependencies: 299
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 6519 (class 0 OID 20774)
-- Dependencies: 288
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6531 (class 0 OID 20903)
-- Dependencies: 300
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 6511 (class 0 OID 20596)
-- Dependencies: 280
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- TOC entry 6507 (class 0 OID 20550)
-- Dependencies: 276
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- TOC entry 6509 (class 0 OID 20578)
-- Dependencies: 278
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- TOC entry 6508 (class 0 OID 20570)
-- Dependencies: 277
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-10-22 20:06:17.261+00	2025-10-22 20:06:17.261+00	\N
\.


--
-- TOC entry 6510 (class 0 OID 20585)
-- Dependencies: 279
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6468 (class 0 OID 19618)
-- Dependencies: 237
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K86RGJCT0W56V55VQENBVVH2	\N	pset_01K86RGJCV61DBNMTV9EA4SXKJ	usd	{"value": "10", "precision": 20}	0	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	\N	10	\N	\N
price_01K86RGJCT20Z79SHM349ZJ61J	\N	pset_01K86RGJCV61DBNMTV9EA4SXKJ	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	\N	10	\N	\N
price_01K86RGJCV0FZJNKKFVV7SQBN4	\N	pset_01K86RGJCV61DBNMTV9EA4SXKJ	eur	{"value": "10", "precision": 20}	1	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	\N	10	\N	\N
price_01K86RGJCVCP8YTQPZ9YDHAPN3	\N	pset_01K86RGJCW479867NZWG1NGGJH	usd	{"value": "10", "precision": 20}	0	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	\N	10	\N	\N
price_01K86RGJCVFJKXVRAFR0Z0KRNP	\N	pset_01K86RGJCW479867NZWG1NGGJH	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	\N	10	\N	\N
price_01K86RGJCWA2C3M6BKFFVQ1T41	\N	pset_01K86RGJCW479867NZWG1NGGJH	eur	{"value": "10", "precision": 20}	1	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	\N	10	\N	\N
price_01K86RGJPJENQB4E278TF07WC3	\N	pset_01K86RGJPKK9NC5X0W7Z8JAD02	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.934+00	2025-10-22 21:47:44.922+00	\N	10	\N	\N
price_01K86RGJPKSDVZ49Y0A075HJ19	\N	pset_01K86RGJPKK9NC5X0W7Z8JAD02	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.935+00	2025-10-22 21:47:44.922+00	\N	15	\N	\N
price_01K86RGJPK4SEGAZM4VDH203NM	\N	pset_01K86RGJPKJ9BGHKTF8JDNJYMQ	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.949+00	2025-10-22 21:47:44.922+00	\N	10	\N	\N
price_01K86RGJPK993EAYBP9CWWCWFX	\N	pset_01K86RGJPKJ9BGHKTF8JDNJYMQ	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.949+00	2025-10-22 21:47:44.922+00	\N	15	\N	\N
price_01K86RGJPK5TG9YPDP60N3D8EK	\N	pset_01K86RGJPKJ6T4NQVXZBGT3A4N	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.957+00	2025-10-22 21:47:44.922+00	\N	10	\N	\N
price_01K86RGJPKB9A816T9FDXA6PNX	\N	pset_01K86RGJPKJ6T4NQVXZBGT3A4N	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.957+00	2025-10-22 21:47:44.922+00	\N	15	\N	\N
price_01K86RGJPFQ9JVH9X6A16HSQHV	\N	pset_01K86RGJPFHCPBKS2WG3ZNY0KP	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.445+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPFS50TT9RNVJZ9TW2J	\N	pset_01K86RGJPFHCPBKS2WG3ZNY0KP	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.445+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPFEET00QK3NFJCBJFV	\N	pset_01K86RGJPF4TZ0HGR5S2DXR8JA	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.462+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPFPM11A2YK1JHY3N4X	\N	pset_01K86RGJPF4TZ0HGR5S2DXR8JA	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.462+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPFW5CD5CS7TJREY282	\N	pset_01K86RGJPGDTC8612BDAJ1BGX9	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.474+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPFYM0GR5ZD2518NJQA	\N	pset_01K86RGJPGDTC8612BDAJ1BGX9	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.474+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPGPYBYBWHBFF2HDJEP	\N	pset_01K86RGJPGA02APZ79QGY5DAD1	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.486+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPGP4ZGKRCAS9RXD822	\N	pset_01K86RGJPGA02APZ79QGY5DAD1	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.486+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPHMKM8WQW2RTCM8DK6	\N	pset_01K86RGJPJX41526QMGS1PGP85	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.222+00	2025-10-22 21:47:51.216+00	\N	10	\N	\N
price_01K86RGJPH4V78G809XJH24C88	\N	pset_01K86RGJPJX41526QMGS1PGP85	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.222+00	2025-10-22 21:47:51.216+00	\N	15	\N	\N
price_01K86RGJPJHTJW12C0H8CTZNRW	\N	pset_01K86RGJPJKSA07V16KNTX4800	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.233+00	2025-10-22 21:47:51.216+00	\N	10	\N	\N
price_01K86RGJPJ20P3YTTCF2Z49XNZ	\N	pset_01K86RGJPJKSA07V16KNTX4800	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.233+00	2025-10-22 21:47:51.216+00	\N	15	\N	\N
price_01K86RGJPJKB6C8R79HFMA0DXS	\N	pset_01K86RGJPJHX3EFDNQKP1J93KP	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.242+00	2025-10-22 21:47:51.216+00	\N	10	\N	\N
price_01K86RGJPJ3HAEM35BN4MMPR81	\N	pset_01K86RGJPJHX3EFDNQKP1J93KP	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.242+00	2025-10-22 21:47:51.216+00	\N	15	\N	\N
price_01K86RGJPJMRK9WHVATY5XNWM0	\N	pset_01K86RGJPJ57J3QYZ4AWE7ABSB	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.249+00	2025-10-22 21:47:51.216+00	\N	10	\N	\N
price_01K86RGJPJVWR9XXMWMZZ76VKE	\N	pset_01K86RGJPJ57J3QYZ4AWE7ABSB	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:51.249+00	2025-10-22 21:47:51.216+00	\N	15	\N	\N
price_01K86RGJPMPTFX78XB7HYHWTXW	\N	pset_01K86RGJPM7NE16MWSZ3VMPVYV	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.067+00	2025-10-22 21:47:41.058+00	\N	10	\N	\N
price_01K86RGJPMACD8QB23GMBZ00SG	\N	pset_01K86RGJPM7NE16MWSZ3VMPVYV	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.068+00	2025-10-22 21:47:41.058+00	\N	15	\N	\N
price_01K86RGJPMTF5TRR8G2G4N17H7	\N	pset_01K86RGJPM6RWYZVQP0Q1JZ9KW	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.085+00	2025-10-22 21:47:41.058+00	\N	10	\N	\N
price_01K86RGJPMJ13DY6PF6DVZ4KCV	\N	pset_01K86RGJPM6RWYZVQP0Q1JZ9KW	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.085+00	2025-10-22 21:47:41.058+00	\N	15	\N	\N
price_01K86RGJPM2NAPY00GDD8M47HR	\N	pset_01K86RGJPMK7QMQ5QN5CFY0S1Z	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.095+00	2025-10-22 21:47:41.058+00	\N	10	\N	\N
price_01K86RGJPMYC8P46C3TM52BZME	\N	pset_01K86RGJPMK7QMQ5QN5CFY0S1Z	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.095+00	2025-10-22 21:47:41.058+00	\N	15	\N	\N
price_01K86RGJPMPJ8SB9CP5Y9EWQ46	\N	pset_01K86RGJPNYAM0WS11JQDJZJ8Y	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.105+00	2025-10-22 21:47:41.058+00	\N	10	\N	\N
price_01K86RGJPNTJ2E7YAPZPMBA76V	\N	pset_01K86RGJPNYAM0WS11JQDJZJ8Y	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.106+00	2025-10-22 21:47:41.058+00	\N	15	\N	\N
price_01K86RGJPK73J1PCMQKE8N1ECA	\N	pset_01K86RGJPK7NG6ARGQ7N0P7FXM	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.965+00	2025-10-22 21:47:44.922+00	\N	10	\N	\N
price_01K86RGJPKH972H8DF6K4FWJAB	\N	pset_01K86RGJPK7NG6ARGQ7N0P7FXM	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.965+00	2025-10-22 21:47:44.922+00	\N	15	\N	\N
price_01K86RGJPG45WP7AJHJG002JTW	\N	pset_01K86RGJPGEKAB3SGVQXNRKYJ0	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.495+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPG16JXB2WKA0FV2X2S	\N	pset_01K86RGJPGEKAB3SGVQXNRKYJ0	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.495+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPG74019ENKBNZBMH74	\N	pset_01K86RGJPHX1PKP2EGA860NTDM	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.507+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPGW2BWDMGHX9SYF1AT	\N	pset_01K86RGJPHX1PKP2EGA860NTDM	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.507+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPH5ABRWMQYTYDP0SJA	\N	pset_01K86RGJPHNH6D9HNKMGYFVZYH	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.518+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPHRZ94WBPQEJ9SMDVN	\N	pset_01K86RGJPHNH6D9HNKMGYFVZYH	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.518+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K86RGJPHCF02JRNTDEKT26B4	\N	pset_01K86RGJPHM9N140JGA4BYW2CN	eur	{"value": "10", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.528+00	2025-10-22 21:47:48.435+00	\N	10	\N	\N
price_01K86RGJPHE4Q1MWF3NSC323TN	\N	pset_01K86RGJPHM9N140JGA4BYW2CN	usd	{"value": "15", "precision": 20}	0	2025-10-22 20:07:07.222+00	2025-10-22 21:47:48.528+00	2025-10-22 21:47:48.435+00	\N	15	\N	\N
price_01K870AGE21SE5ZAQ2CKS02RFZ	\N	pset_01K870AGE2A1A62KJV66Z4213A	eur	{"value": "699", "precision": 20}	0	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N	\N	699	\N	\N
price_01K870AGE2X730WPGRQ3RETMX5	\N	pset_01K870AGE2A1A62KJV66Z4213A	usd	{"value": "811.79", "precision": 20}	0	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N	\N	811.79	\N	\N
price_01K870AGE2RTP8BJRR52SS6T0Q	\N	pset_01K870AGE23BWVN1H8524XQVWG	eur	{"value": "699", "precision": 20}	0	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N	\N	699	\N	\N
price_01K870AGE2H6DR09QXEYM7M8YX	\N	pset_01K870AGE23BWVN1H8524XQVWG	usd	{"value": "811.79", "precision": 20}	0	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N	\N	811.79	\N	\N
price_01K870AGE3S104PAY5A3A0QSP0	\N	pset_01K870AGE387SS1X3CBW9EQ8F7	eur	{"value": "699", "precision": 20}	0	2025-10-22 22:23:36.9+00	2025-10-22 22:23:36.9+00	\N	\N	699	\N	\N
price_01K870AGE3KBQ7ZCC4ZQK9R9ZW	\N	pset_01K870AGE387SS1X3CBW9EQ8F7	usd	{"value": "811.79", "precision": 20}	0	2025-10-22 22:23:36.9+00	2025-10-22 22:23:36.9+00	\N	\N	811.79	\N	\N
price_01K870AGE3HY2Y85Y5SPFR5FYA	\N	pset_01K870AGE3PCTDZ3A2MQKJQTBX	eur	{"value": "699", "precision": 20}	0	2025-10-22 22:23:36.9+00	2025-10-22 22:23:36.9+00	\N	\N	699	\N	\N
price_01K870AGE3ZBNJZKJFPEKFGJNS	\N	pset_01K870AGE3PCTDZ3A2MQKJQTBX	usd	{"value": "811.79", "precision": 20}	0	2025-10-22 22:23:36.9+00	2025-10-22 22:23:36.9+00	\N	\N	811.79	\N	\N
price_01K86ZJ6MQZ2KEP5MRDWZEVMNR	\N	pset_01K86ZJ6MQB1DZ8V075MPMH9J8	eur	{"value": "29.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.605+00	2025-10-22 22:25:33.597+00	\N	29.5	\N	\N
price_01K86ZJ6MQHJHDBKSJH9BJD9XF	\N	pset_01K86ZJ6MQB1DZ8V075MPMH9J8	usd	{"value": "33.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.606+00	2025-10-22 22:25:33.597+00	\N	33.5	\N	\N
price_01K86ZJ6MQBFV7JBMJ16Q881Y6	\N	pset_01K86ZJ6MQ70ZRE17Q4XZD8D6Z	eur	{"value": "29.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.62+00	2025-10-22 22:25:33.597+00	\N	29.5	\N	\N
price_01K86ZJ6MQ39ZPEVQCGQWVHVGN	\N	pset_01K86ZJ6MQ70ZRE17Q4XZD8D6Z	usd	{"value": "33.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.62+00	2025-10-22 22:25:33.597+00	\N	33.5	\N	\N
price_01K86ZJ6MQMC8N1M1FAKJW9G4D	\N	pset_01K86ZJ6MQDEFHF3ZR98XXNNSJ	eur	{"value": "29.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.63+00	2025-10-22 22:25:33.597+00	\N	29.5	\N	\N
price_01K86ZJ6MQ244ZC9KW3KRP4SRG	\N	pset_01K86ZJ6MQDEFHF3ZR98XXNNSJ	usd	{"value": "33.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.63+00	2025-10-22 22:25:33.597+00	\N	33.5	\N	\N
price_01K86ZJ6MRRCB2AWPS2DAMRQC2	\N	pset_01K86ZJ6MRPGTC5TEVFT83115V	eur	{"value": "29.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.64+00	2025-10-22 22:25:33.597+00	\N	29.5	\N	\N
price_01K86ZJ6MPYVMNEDSC5164DVE8	\N	pset_01K86ZJ6MP029N2BG0VENR5HPT	eur	{"value": "10", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:36.644+00	2025-10-22 22:25:36.633+00	\N	10	\N	\N
price_01K86ZJ6MPM2FX11SK0Q67SEWS	\N	pset_01K86ZJ6MP029N2BG0VENR5HPT	usd	{"value": "12", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:36.644+00	2025-10-22 22:25:36.633+00	\N	12	\N	\N
price_01K86ZJ6MRAF5AHJB2D7B6BHX9	\N	pset_01K86ZJ6MRPGTC5TEVFT83115V	usd	{"value": "33.5", "precision": 20}	0	2025-10-22 22:10:20.441+00	2025-10-22 22:25:33.64+00	2025-10-22 22:25:33.597+00	\N	33.5	\N	\N
price_01K8715YFEJ8NEMR40Z0YH26W0	\N	pset_01K8715YFEAAMZXD4EYQEE50CK	eur	{"value": "299", "precision": 20}	0	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N	\N	299	\N	\N
price_01K8715YFEW4APDCDG98R2W4JM	\N	pset_01K8715YFEAAMZXD4EYQEE50CK	usd	{"value": "347.25", "precision": 20}	0	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N	\N	347.25	\N	\N
price_01K8715YFEBSTH1R75HGKT3J9N	\N	pset_01K8715YFFKEGCNSTEB9B2G8PP	eur	{"value": "299", "precision": 20}	0	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N	\N	299	\N	\N
price_01K8715YFFJZEG6120218PS1KC	\N	pset_01K8715YFFKEGCNSTEB9B2G8PP	usd	{"value": "347.25", "precision": 20}	0	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N	\N	347.25	\N	\N
price_01K8715YFFJ7E4D6S62K3CJWWV	\N	pset_01K8715YFFQD16B3BY4D3H0V91	eur	{"value": "299", "precision": 20}	0	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N	\N	299	\N	\N
price_01K8715YFFMKSQDDQQ3XR8EPTC	\N	pset_01K8715YFFQD16B3BY4D3H0V91	usd	{"value": "347.25", "precision": 20}	0	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N	\N	347.25	\N	\N
price_01K871H04QBJ44979ABJ04SNGP	\N	pset_01K871H04Q53PCW3DYVAR6S9DD	eur	{"value": "599", "precision": 20}	0	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N	\N	599	\N	\N
price_01K871H04QWVKWG423A0TPGAW1	\N	pset_01K871H04Q53PCW3DYVAR6S9DD	usd	{"value": "695.65", "precision": 20}	0	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N	\N	695.65	\N	\N
price_01K871H04RAX796JW4TFZA01YF	\N	pset_01K871H04RJW8SXXP1GBN472ZD	eur	{"value": "599", "precision": 20}	0	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N	\N	599	\N	\N
price_01K871H04RPJ8GDHVG0RG9Y3PW	\N	pset_01K871H04RJW8SXXP1GBN472ZD	usd	{"value": "695.65", "precision": 20}	0	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N	\N	695.65	\N	\N
price_01K871H04R0GF9HTP6G6428KQN	\N	pset_01K871H04RR1EMPYC3DXHR7GW6	eur	{"value": "599", "precision": 20}	0	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N	\N	599	\N	\N
price_01K871H04R5QWKTGEVHJ9H4XB1	\N	pset_01K871H04RR1EMPYC3DXHR7GW6	usd	{"value": "695.65", "precision": 20}	0	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N	\N	695.65	\N	\N
price_01K871V2F58DSH7B3KVN40YDYW	\N	pset_01K870V00HZ96PYRPCAA70ND57	eur	{"value": "799", "precision": 20}	0	2025-10-22 22:50:08.234+00	2025-10-23 17:32:54.951+00	2025-10-23 17:32:54.939+00	\N	799	\N	\N
price_01K871V2F6QBTRHE5RBBDMRXY4	\N	pset_01K870V00HZ96PYRPCAA70ND57	usd	{"value": "927.92", "precision": 20}	0	2025-10-22 22:50:08.234+00	2025-10-23 17:32:54.951+00	2025-10-23 17:32:54.939+00	\N	927.92	\N	\N
price_01K871V2F6S3NXCYNMGQRSN2YA	\N	pset_01K870V00HFMFE9JSECHEK9Y9M	eur	{"value": "799", "precision": 20}	0	2025-10-22 22:50:08.234+00	2025-10-23 17:32:54.99+00	2025-10-23 17:32:54.939+00	\N	799	\N	\N
price_01K871V2F6M7CTB6606WK39W9W	\N	pset_01K870V00HFMFE9JSECHEK9Y9M	usd	{"value": "927.92", "precision": 20}	0	2025-10-22 22:50:08.234+00	2025-10-23 17:32:54.99+00	2025-10-23 17:32:54.939+00	\N	927.92	\N	\N
price_01K871V2F6G009HK41QP99YH9G	\N	pset_01K870V00HP9N248ZY8P5ZVPF4	eur	{"value": "799", "precision": 20}	0	2025-10-22 22:50:08.234+00	2025-10-23 17:32:54.999+00	2025-10-23 17:32:54.939+00	\N	799	\N	\N
price_01K871V2F6CJCJP1DR6R98N01D	\N	pset_01K870V00HP9N248ZY8P5ZVPF4	usd	{"value": "927.92", "precision": 20}	0	2025-10-22 22:50:08.234+00	2025-10-23 17:32:54.999+00	2025-10-23 17:32:54.939+00	\N	927.92	\N	\N
price_01K89286NQ6KF1A5DFE4T8JMQJ	\N	pset_01K89286NQYEP2G07GA2P1TD6J	eur	{"value": "799", "precision": 20}	0	2025-10-23 17:35:47.385+00	2025-10-23 17:35:47.385+00	\N	\N	799	\N	\N
price_01K89286NQE46Q3FZ5KBW75P0H	\N	pset_01K89286NQYEP2G07GA2P1TD6J	usd	{"value": "927.45", "precision": 20}	0	2025-10-23 17:35:47.385+00	2025-10-23 17:35:47.385+00	\N	\N	927.45	\N	\N
price_01K89286NQ1J3QSJPW5H151BFQ	\N	pset_01K89286NRKFE8N60X5RNEFK6C	eur	{"value": "799", "precision": 20}	0	2025-10-23 17:35:47.385+00	2025-10-23 17:35:47.385+00	\N	\N	799	\N	\N
price_01K89286NQFC4JM1XHZKQF2FGF	\N	pset_01K89286NRKFE8N60X5RNEFK6C	usd	{"value": "927.45", "precision": 20}	0	2025-10-23 17:35:47.385+00	2025-10-23 17:35:47.385+00	\N	\N	927.45	\N	\N
price_01K89286NRHRV76TD0Z1C1V1GT	\N	pset_01K89286NRGXFMF445AYGZSSB9	eur	{"value": "799", "precision": 20}	0	2025-10-23 17:35:47.385+00	2025-10-23 17:35:47.385+00	\N	\N	799	\N	\N
price_01K89286NRGXCXM6VP2BPM7H5Y	\N	pset_01K89286NRGXFMF445AYGZSSB9	usd	{"value": "927.45", "precision": 20}	0	2025-10-23 17:35:47.385+00	2025-10-23 17:35:47.385+00	\N	\N	927.45	\N	\N
price_01K898RB63PM5WY63ZWZDHRYT9	\N	pset_01K898RB638YTGWVFQZ785N3J3	eur	{"value": "279", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	279	\N	\N
price_01K898RB630T2920PWF7MET1TV	\N	pset_01K898RB638YTGWVFQZ785N3J3	usd	{"value": "323.85", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	323.85	\N	\N
price_01K898RB6371V0DNRDG5YN16G2	\N	pset_01K898RB64R8DH1RJK15HNV7Z1	eur	{"value": "279", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	279	\N	\N
price_01K898RB64KPS1VSDKEJ2PC8HG	\N	pset_01K898RB64R8DH1RJK15HNV7Z1	usd	{"value": "323.85", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	323.85	\N	\N
price_01K898RB64CEXDB8E1ASYSGRB6	\N	pset_01K898RB640W8DK5DJWGN43151	eur	{"value": "279", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	279	\N	\N
price_01K898RB64MEG373Y5Y7290WJM	\N	pset_01K898RB640W8DK5DJWGN43151	usd	{"value": "323.85", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	323.85	\N	\N
price_01K898RB643DKEREF7PVCMGWJP	\N	pset_01K898RB65KR7PEAXRKBD21D8S	eur	{"value": "279", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	279	\N	\N
price_01K898RB657C8AGFVEQ1FZ8GBT	\N	pset_01K898RB65KR7PEAXRKBD21D8S	usd	{"value": "323.85", "precision": 20}	0	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N	\N	323.85	\N	\N
price_01K899Z5ATB6NBYV0BMEW2FYBN	\N	pset_01K899Z5ATB513GK66JBSG2FM1	eur	{"value": "349", "precision": 20}	0	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N	\N	349	\N	\N
price_01K899Z5ATG8TE56RSXD6V6NNE	\N	pset_01K899Z5ATB513GK66JBSG2FM1	usd	{"value": "405.11", "precision": 20}	0	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N	\N	405.11	\N	\N
price_01K899Z5AV2VHVK3QJAFJ2486R	\N	pset_01K899Z5AVWQ91X9NK0F2X2AJW	eur	{"value": "349", "precision": 20}	0	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N	\N	349	\N	\N
price_01K899Z5AVN57ZWS3GDQ115WVD	\N	pset_01K899Z5AVWQ91X9NK0F2X2AJW	usd	{"value": "405.11", "precision": 20}	0	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N	\N	405.11	\N	\N
price_01K899Z5AVECZD9A0MQAEK4DQN	\N	pset_01K899Z5AWSYTG3C1HV3PKT19A	eur	{"value": "349", "precision": 20}	0	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N	\N	349	\N	\N
price_01K899Z5AVNV6K9003R4VZVZN0	\N	pset_01K899Z5AWSYTG3C1HV3PKT19A	usd	{"value": "405.11", "precision": 20}	0	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N	\N	405.11	\N	\N
\.


--
-- TOC entry 6470 (class 0 OID 19694)
-- Dependencies: 239
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6471 (class 0 OID 19704)
-- Dependencies: 240
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- TOC entry 6472 (class 0 OID 19799)
-- Dependencies: 241
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K86RG9HCCF3YN217EFB065CV	currency_code	eur	f	2025-10-22 20:06:57.836+00	2025-10-22 20:06:57.836+00	\N
prpref_01K86RGJ6HKMY9WVBTAT54CFP1	region_id	reg_01K86RGJ581AE11MHX8DSXWX1D	f	2025-10-22 20:07:06.705+00	2025-10-22 20:07:06.705+00	\N
\.


--
-- TOC entry 6469 (class 0 OID 19649)
-- Dependencies: 238
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01K86RGJCT4F7N39R1YVB1KA48	reg_01K86RGJ581AE11MHX8DSXWX1D	0	price_01K86RGJCV0FZJNKKFVV7SQBN4	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	region_id	eq
prule_01K86RGJCVDQDFG9WPD7E67RW4	reg_01K86RGJ581AE11MHX8DSXWX1D	0	price_01K86RGJCWA2C3M6BKFFVQ1T41	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N	region_id	eq
\.


--
-- TOC entry 6467 (class 0 OID 19609)
-- Dependencies: 236
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K86RGJCV61DBNMTV9EA4SXKJ	2025-10-22 20:07:06.908+00	2025-10-22 20:07:06.908+00	\N
pset_01K86RGJCW479867NZWG1NGGJH	2025-10-22 20:07:06.909+00	2025-10-22 20:07:06.909+00	\N
pset_01K86RGJPM7NE16MWSZ3VMPVYV	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.059+00	2025-10-22 21:47:41.058+00
pset_01K86RGJPM6RWYZVQP0Q1JZ9KW	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.08+00	2025-10-22 21:47:41.058+00
pset_01K86RGJPMK7QMQ5QN5CFY0S1Z	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.09+00	2025-10-22 21:47:41.058+00
pset_01K86RGJPNYAM0WS11JQDJZJ8Y	2025-10-22 20:07:07.222+00	2025-10-22 21:47:41.101+00	2025-10-22 21:47:41.058+00
pset_01K86RGJPKK9NC5X0W7Z8JAD02	2025-10-22 20:07:07.221+00	2025-10-22 21:47:44.922+00	2025-10-22 21:47:44.922+00
pset_01K86RGJPKJ9BGHKTF8JDNJYMQ	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.945+00	2025-10-22 21:47:44.922+00
pset_01K86RGJPKJ6T4NQVXZBGT3A4N	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.954+00	2025-10-22 21:47:44.922+00
pset_01K86RGJPK7NG6ARGQ7N0P7FXM	2025-10-22 20:07:07.222+00	2025-10-22 21:47:44.961+00	2025-10-22 21:47:44.922+00
pset_01K86RGJPFHCPBKS2WG3ZNY0KP	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.436+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPF4TZ0HGR5S2DXR8JA	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.458+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPGDTC8612BDAJ1BGX9	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.47+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPGA02APZ79QGY5DAD1	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.479+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPGEKAB3SGVQXNRKYJ0	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.492+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPHX1PKP2EGA860NTDM	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.504+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPHNH6D9HNKMGYFVZYH	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.512+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPHM9N140JGA4BYW2CN	2025-10-22 20:07:07.221+00	2025-10-22 21:47:48.523+00	2025-10-22 21:47:48.435+00
pset_01K86RGJPJX41526QMGS1PGP85	2025-10-22 20:07:07.221+00	2025-10-22 21:47:51.216+00	2025-10-22 21:47:51.216+00
pset_01K86RGJPJKSA07V16KNTX4800	2025-10-22 20:07:07.221+00	2025-10-22 21:47:51.228+00	2025-10-22 21:47:51.216+00
pset_01K86RGJPJHX3EFDNQKP1J93KP	2025-10-22 20:07:07.221+00	2025-10-22 21:47:51.239+00	2025-10-22 21:47:51.216+00
pset_01K86RGJPJ57J3QYZ4AWE7ABSB	2025-10-22 20:07:07.221+00	2025-10-22 21:47:51.245+00	2025-10-22 21:47:51.216+00
pset_01K870AGE2A1A62KJV66Z4213A	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N
pset_01K870AGE23BWVN1H8524XQVWG	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N
pset_01K870AGE387SS1X3CBW9EQ8F7	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N
pset_01K870AGE3PCTDZ3A2MQKJQTBX	2025-10-22 22:23:36.899+00	2025-10-22 22:23:36.899+00	\N
pset_01K86ZJ6MQB1DZ8V075MPMH9J8	2025-10-22 22:10:20.44+00	2025-10-22 22:25:33.597+00	2025-10-22 22:25:33.597+00
pset_01K86ZJ6MQ70ZRE17Q4XZD8D6Z	2025-10-22 22:10:20.44+00	2025-10-22 22:25:33.616+00	2025-10-22 22:25:33.597+00
pset_01K86ZJ6MQDEFHF3ZR98XXNNSJ	2025-10-22 22:10:20.44+00	2025-10-22 22:25:33.626+00	2025-10-22 22:25:33.597+00
pset_01K86ZJ6MRPGTC5TEVFT83115V	2025-10-22 22:10:20.44+00	2025-10-22 22:25:33.634+00	2025-10-22 22:25:33.597+00
pset_01K86ZJ6MP029N2BG0VENR5HPT	2025-10-22 22:10:20.44+00	2025-10-22 22:25:36.633+00	2025-10-22 22:25:36.633+00
pset_01K8715YFEAAMZXD4EYQEE50CK	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N
pset_01K8715YFFKEGCNSTEB9B2G8PP	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N
pset_01K8715YFFQD16B3BY4D3H0V91	2025-10-22 22:38:36.016+00	2025-10-22 22:38:36.016+00	\N
pset_01K871H04Q53PCW3DYVAR6S9DD	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N
pset_01K871H04RJW8SXXP1GBN472ZD	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N
pset_01K871H04RR1EMPYC3DXHR7GW6	2025-10-22 22:44:38.168+00	2025-10-22 22:44:38.168+00	\N
pset_01K870V00HZ96PYRPCAA70ND57	2025-10-22 22:32:37.137+00	2025-10-23 17:32:54.94+00	2025-10-23 17:32:54.939+00
pset_01K870V00HFMFE9JSECHEK9Y9M	2025-10-22 22:32:37.137+00	2025-10-23 17:32:54.985+00	2025-10-23 17:32:54.939+00
pset_01K870V00HP9N248ZY8P5ZVPF4	2025-10-22 22:32:37.137+00	2025-10-23 17:32:54.995+00	2025-10-23 17:32:54.939+00
pset_01K89286NQYEP2G07GA2P1TD6J	2025-10-23 17:35:47.384+00	2025-10-23 17:35:47.384+00	\N
pset_01K89286NRKFE8N60X5RNEFK6C	2025-10-23 17:35:47.384+00	2025-10-23 17:35:47.384+00	\N
pset_01K89286NRGXFMF445AYGZSSB9	2025-10-23 17:35:47.384+00	2025-10-23 17:35:47.384+00	\N
pset_01K898RB638YTGWVFQZ785N3J3	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N
pset_01K898RB64R8DH1RJK15HNV7Z1	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N
pset_01K898RB640W8DK5DJWGN43151	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N
pset_01K898RB65KR7PEAXRKBD21D8S	2025-10-23 19:29:27.75+00	2025-10-23 19:29:27.75+00	\N
pset_01K899Z5ATB513GK66JBSG2FM1	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N
pset_01K899Z5AVWQ91X9NK0F2X2AJW	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N
pset_01K899Z5AWSYTG3C1HV3PKT19A	2025-10-23 19:50:39.708+00	2025-10-23 19:50:39.708+00	\N
\.


--
-- TOC entry 6455 (class 0 OID 19292)
-- Dependencies: 224
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K86RGJGSFGNYEBD80ZBASQQR	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:41.01+00	2025-10-22 21:47:41.008+00	\N
prod_01K86RGJGSDMNSWH34XZ83V1HG	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:44.906+00	2025-10-22 21:47:44.906+00	\N
prod_01K86RGJGSDAQ3VAGK2ABX4VFN	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 20:07:07.042+00	2025-10-22 21:47:48.409+00	2025-10-22 21:47:48.409+00	\N
prod_01K86RGJGSA0PYV2C3WZY4GHJG	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 20:07:07.042+00	2025-10-22 21:47:51.203+00	2025-10-22 21:47:51.202+00	\N
prod_01K899Z57YTQT04HG5J1P39R5W	American ranch	american-ranch	Premium leather armchair with rustic charm	The American Ranch Armchair brings western-inspired elegance into your home. Upholstered in high-quality full-grain leather, it combines durability with timeless comfort. Its sturdy oak legs and handcrafted stitching evoke the warmth of classic ranch interiors.	f	published	http://localhost:9000/static/1761249039559-guglielmo-basile-fupKD-E4GZ0-unsplash.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K89FEKCM4KK2CDST7QBX96PF	\N	t	\N	2025-10-23 19:50:39.615+00	2025-10-23 21:28:55.565+00	\N	\N
prod_01K86ZJ6GRTFXTSB4PXAN5FMXR	Medusa Sweatpants	sweatpants-v2	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 22:10:20.314+00	2025-10-22 22:25:33.561+00	2025-10-22 22:25:33.56+00	\N
prod_01K86ZJ6GQQJ9WEV3FA3DR8HT2	Medusa Coffee Mug	coffee-mug-v3	\N	Every programmer's best friend.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/coffee-mug.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 22:10:20.313+00	2025-10-22 22:25:36.619+00	2025-10-22 22:25:36.619+00	\N
prod_01K870TZYX6C9NVBWGX1YAH303	American Dream	american-dream	Premium leather sofa	A premium full leather three-seater sofa with woodfinish.	f	published	http://localhost:9000/static/1761172357068-paul-weaver-nWidMEQsnAQ-unsplash.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-22 22:32:37.087+00	2025-10-23 17:32:54.911+00	2025-10-23 17:32:54.909+00	\N
prod_01K870AG8DXCZV5NN6J5NVFKY0	Soumi Lake	soumi-lake	Modern three-seater sofa	A comfortable modern three-seater sofa in soft fabric.	f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K89FEWVEH8VCFX97W434AD2K	\N	t	\N	2025-10-22 22:23:36.719+00	2025-10-23 21:27:11.169+00	\N	\N
prod_01K8715YBZDSTSAZ4PXMR8HZJS	Polar Light	armchair	Comfort armchai	A cozy armchair with plush cushions and wooden legs.	f	published	http://localhost:9000/static/1761172715856-virender-singh-hE0nmTffKtM-unsplash.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K89FEWVEH8VCFX97W434AD2K	\N	t	\N	2025-10-22 22:38:35.904+00	2025-10-23 21:27:36.064+00	\N	\N
prod_01K871H01D777X2BKZX991DA8K	Alpine Hearth	alpine-hearth	Deep comfort sofa for modern homes	The Balkan Hug Sofa combines timeless design with deep, plush cushions for ultimate comfort. Built with a solid wood frame and premium upholstery, it’s perfect for cozy evenings and stylish interiors.	f	published	http://localhost:9000/static/1761173078033-bence-balla-schottner-vFwjD8JLP4M-unsplash.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K89FE6RVVYS8XGBEAHAASDPN	\N	t	\N	2025-10-22 22:44:38.065+00	2025-10-23 21:27:55.705+00	\N	\N
prod_01K89286HA6YCDJWZ2DH68KBNB	American Dream	american-dream	Premium leather sofa	A premium full leather three-seater sofa with dark finish.	f	published	http://localhost:9000/static/1761240947179-paul-weaver-nWidMEQsnAQ-unsplash.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K89FEKCM4KK2CDST7QBX96PF	\N	t	\N	2025-10-23 17:35:47.245+00	2025-10-23 21:28:13.306+00	\N	\N
prod_01K898RB2BFVKT544YNZHRC3DG	Alpine pine	alpine-pine	Retro-inspired comfort with timeless design	The Alpine Pine Armchair blends a vintage silhouette with modern craftsmanship. It features a solid wooden frame, soft velvet upholstery, and gentle curves inspired by mid-century design. Perfect for cozy reading corners or stylish living rooms.	f	published	http://localhost:9000/static/1761247767527-laura-chouette-HUnrPHgMHsA-unsplash.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K89FE6RVVYS8XGBEAHAASDPN	\N	t	\N	2025-10-23 19:29:27.629+00	2025-10-23 21:28:32.423+00	\N	\N
\.


--
-- TOC entry 6463 (class 0 OID 19392)
-- Dependencies: 232
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K86RGJG9AC4DPWD8SKVWAHRM	Shirts		shirts	pcat_01K86RGJG9AC4DPWD8SKVWAHRM	t	f	0	\N	2025-10-22 20:07:07.019+00	2025-10-23 21:25:11.138+00	2025-10-23 21:25:11.138+00	\N
pcat_01K86RGJGA87Q7HPSEFHR7AREZ	Pants		pants	pcat_01K86RGJGA87Q7HPSEFHR7AREZ	t	f	1	\N	2025-10-22 20:07:07.019+00	2025-10-23 21:25:13.678+00	2025-10-23 21:25:13.678+00	\N
pcat_01K86RGJGA8MFX8D2G8YP647G5	Sweatshirts		sweatshirts	pcat_01K86RGJGA8MFX8D2G8YP647G5	t	f	0	\N	2025-10-22 20:07:07.019+00	2025-10-23 21:25:17.051+00	2025-10-23 21:25:17.051+00	\N
pcat_01K86RGJGACK0WJ0731GHXQEJA	Merch		merch	pcat_01K86RGJGACK0WJ0731GHXQEJA	t	f	0	\N	2025-10-22 20:07:07.019+00	2025-10-23 21:25:20.122+00	2025-10-23 21:25:20.122+00	\N
pcat_01K89FD5WWHYT1CYZXPRE4G6RK	Sofas		sofas	pcat_01K89FD5WWHYT1CYZXPRE4G6RK	t	f	0	\N	2025-10-23 21:25:41.917+00	2025-10-23 21:25:41.917+00	\N	\N
pcat_01K89FDSGPA71BA897SN9809KE	Armchairs		armchairs	pcat_01K89FDSGPA71BA897SN9809KE	t	f	1	\N	2025-10-23 21:26:02.006+00	2025-10-23 21:26:02.006+00	\N	\N
\.


--
-- TOC entry 6465 (class 0 OID 19422)
-- Dependencies: 234
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K86RGJGSDAQ3VAGK2ABX4VFN	pcat_01K86RGJG9AC4DPWD8SKVWAHRM
prod_01K86RGJGSA0PYV2C3WZY4GHJG	pcat_01K86RGJGA8MFX8D2G8YP647G5
prod_01K86RGJGSDMNSWH34XZ83V1HG	pcat_01K86RGJGA87Q7HPSEFHR7AREZ
prod_01K86RGJGSFGNYEBD80ZBASQQR	pcat_01K86RGJGACK0WJ0731GHXQEJA
prod_01K870AG8DXCZV5NN6J5NVFKY0	pcat_01K89FD5WWHYT1CYZXPRE4G6RK
prod_01K8715YBZDSTSAZ4PXMR8HZJS	pcat_01K89FDSGPA71BA897SN9809KE
prod_01K871H01D777X2BKZX991DA8K	pcat_01K89FD5WWHYT1CYZXPRE4G6RK
prod_01K89286HA6YCDJWZ2DH68KBNB	pcat_01K89FD5WWHYT1CYZXPRE4G6RK
prod_01K898RB2BFVKT544YNZHRC3DG	pcat_01K89FDSGPA71BA897SN9809KE
prod_01K899Z57YTQT04HG5J1P39R5W	pcat_01K89FDSGPA71BA897SN9809KE
\.


--
-- TOC entry 6462 (class 0 OID 19381)
-- Dependencies: 231
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcol_01K89FE6RVVYS8XGBEAHAASDPN	Alpine	alpine	\N	2025-10-23 21:26:15.578495+00	2025-10-23 21:26:15.578495+00	\N
pcol_01K89FEKCM4KK2CDST7QBX96PF	American	american	\N	2025-10-23 21:26:28.500774+00	2025-10-23 21:26:28.500774+00	\N
pcol_01K89FEWVEH8VCFX97W434AD2K	Nordic	nordic	\N	2025-10-23 21:26:38.190025+00	2025-10-23 21:26:38.190025+00	\N
\.


--
-- TOC entry 6457 (class 0 OID 19326)
-- Dependencies: 226
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K86RGJH05T9412CBB0K5BX38	Size	prod_01K86RGJGSFGNYEBD80ZBASQQR	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.03+00	2025-10-22 21:47:41.008+00
opt_01K86RGJGZGGN0846GKHZ0SWVZ	Size	prod_01K86RGJGSDMNSWH34XZ83V1HG	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00
opt_01K86RGJGW5DFND05JX8SNY4D8	Size	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.434+00	2025-10-22 21:47:48.409+00
opt_01K86RGJGWWE5G9K37A5Z7156K	Color	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.434+00	2025-10-22 21:47:48.409+00
opt_01K86RGJGY4HS0MJR8N9S67T72	Size	prod_01K86RGJGSA0PYV2C3WZY4GHJG	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00
opt_01K870AG8ESHSE74GAB55RC6W6	Color	prod_01K870AG8DXCZV5NN6J5NVFKY0	\N	2025-10-22 22:23:36.719+00	2025-10-22 22:23:36.719+00	\N
opt_01K86ZJ6GSNPYJS0GMGTDWGANW	Size	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.577+00	2025-10-22 22:25:33.56+00
opt_01K86ZJ6GRFTW7E04JH0PBNGK4	Size	prod_01K86ZJ6GQQJ9WEV3FA3DR8HT2	\N	2025-10-22 22:10:20.314+00	2025-10-22 22:25:36.635+00	2025-10-22 22:25:36.619+00
opt_01K8715YC0DACGTEB29QSRPHY1	Color	prod_01K8715YBZDSTSAZ4PXMR8HZJS	\N	2025-10-22 22:38:35.904+00	2025-10-22 22:38:35.904+00	\N
opt_01K871H01F6E8Y2S1QC48Z97MB	Color	prod_01K871H01D777X2BKZX991DA8K	\N	2025-10-22 22:44:38.065+00	2025-10-22 22:44:38.065+00	\N
opt_01K870TZYY0ACBXMSNECX9RZ1N	Color	prod_01K870TZYX6C9NVBWGX1YAH303	\N	2025-10-22 22:32:37.087+00	2025-10-23 17:32:54.962+00	2025-10-23 17:32:54.909+00
opt_01K89286HCR0NNWKKG5JWYY6XM	Color	prod_01K89286HA6YCDJWZ2DH68KBNB	\N	2025-10-23 17:35:47.245+00	2025-10-23 17:35:47.245+00	\N
opt_01K898RB2DG6B1D2G3THBKBBZW	Color	prod_01K898RB2BFVKT544YNZHRC3DG	\N	2025-10-23 19:29:27.629+00	2025-10-23 19:29:27.629+00	\N
opt_01K899Z57ZJ0W6TKGD4ZGBP4G1	Color	prod_01K899Z57YTQT04HG5J1P39R5W	\N	2025-10-23 19:50:39.616+00	2025-10-23 19:50:39.616+00	\N
\.


--
-- TOC entry 6458 (class 0 OID 19337)
-- Dependencies: 227
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K870AG8EW6MSZW04CRT2NGQG	Green	opt_01K870AG8ESHSE74GAB55RC6W6	\N	2025-10-22 22:23:36.719+00	2025-10-22 22:23:36.719+00	\N
optval_01K870AG8EZC1EWKTE0GD4THD3	Gray	opt_01K870AG8ESHSE74GAB55RC6W6	\N	2025-10-22 22:23:36.719+00	2025-10-22 22:23:36.719+00	\N
optval_01K870AG8ER9YQ72CB6TPX8SG3	Red	opt_01K870AG8ESHSE74GAB55RC6W6	\N	2025-10-22 22:23:36.719+00	2025-10-22 22:23:36.719+00	\N
optval_01K870AG8EAZ0920PMP5ZRZ6EV	Navy	opt_01K870AG8ESHSE74GAB55RC6W6	\N	2025-10-22 22:23:36.719+00	2025-10-22 22:23:36.719+00	\N
optval_01K86ZJ6GSW1AC8CWMEV5PSTKV	S	opt_01K86ZJ6GSNPYJS0GMGTDWGANW	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.59+00	2025-10-22 22:25:33.56+00
optval_01K86ZJ6GS37QP17HHWB9EQG2B	M	opt_01K86ZJ6GSNPYJS0GMGTDWGANW	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.59+00	2025-10-22 22:25:33.56+00
optval_01K86ZJ6GS7A7BRQ6RTNXYX14A	L	opt_01K86ZJ6GSNPYJS0GMGTDWGANW	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.59+00	2025-10-22 22:25:33.56+00
optval_01K86ZJ6GS424GZFXGP5SYF3XC	XL	opt_01K86ZJ6GSNPYJS0GMGTDWGANW	\N	2025-10-22 22:10:20.32+00	2025-10-22 22:25:33.59+00	2025-10-22 22:25:33.56+00
optval_01K86ZJ6GR3958MET6HXDKBS19	One Size	opt_01K86ZJ6GRFTW7E04JH0PBNGK4	\N	2025-10-22 22:10:20.314+00	2025-10-22 22:25:36.648+00	2025-10-22 22:25:36.619+00
optval_01K86RGJH0P589BKRH2YZPN8HB	S	opt_01K86RGJH05T9412CBB0K5BX38	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.045+00	2025-10-22 21:47:41.008+00
optval_01K86RGJH0QQZYQ4W2NYCPSR4M	M	opt_01K86RGJH05T9412CBB0K5BX38	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.045+00	2025-10-22 21:47:41.008+00
optval_01K86RGJH01JRGAH5VE95Y5MRJ	L	opt_01K86RGJH05T9412CBB0K5BX38	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.045+00	2025-10-22 21:47:41.008+00
optval_01K86RGJH0D1YVZ8KB6931M9S0	XL	opt_01K86RGJH05T9412CBB0K5BX38	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:41.046+00	2025-10-22 21:47:41.008+00
optval_01K86RGJGZ52BVNEV8D2D308R2	S	opt_01K86RGJGZGGN0846GKHZ0SWVZ	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.939+00	2025-10-22 21:47:44.906+00
optval_01K86RGJGZBFBR6TV9RRQNQNV8	M	opt_01K86RGJGZGGN0846GKHZ0SWVZ	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.939+00	2025-10-22 21:47:44.906+00
optval_01K86RGJGZ2Y33T8856FWFEB3B	L	opt_01K86RGJGZGGN0846GKHZ0SWVZ	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.939+00	2025-10-22 21:47:44.906+00
optval_01K86RGJGZ1J956CX7M7C3KB77	XL	opt_01K86RGJGZGGN0846GKHZ0SWVZ	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:44.939+00	2025-10-22 21:47:44.906+00
optval_01K86RGJGVPPXVVGDG4FZ7M64M	S	opt_01K86RGJGW5DFND05JX8SNY4D8	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.454+00	2025-10-22 21:47:48.409+00
optval_01K86RGJGWSST4J4KMJJ5726B6	M	opt_01K86RGJGW5DFND05JX8SNY4D8	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.454+00	2025-10-22 21:47:48.409+00
optval_01K86RGJGWB65EDMHMH2701XBP	L	opt_01K86RGJGW5DFND05JX8SNY4D8	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.454+00	2025-10-22 21:47:48.409+00
optval_01K86RGJGWKBBHSYH15NJ3VTN6	XL	opt_01K86RGJGW5DFND05JX8SNY4D8	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.454+00	2025-10-22 21:47:48.409+00
optval_01K86RGJGWXDKENEG1MDZK2YD0	Black	opt_01K86RGJGWWE5G9K37A5Z7156K	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.454+00	2025-10-22 21:47:48.409+00
optval_01K86RGJGW5CB9GCQNSAX9M0Y7	White	opt_01K86RGJGWWE5G9K37A5Z7156K	\N	2025-10-22 20:07:07.043+00	2025-10-22 21:47:48.454+00	2025-10-22 21:47:48.409+00
optval_01K86RGJGYNFXZZRVSDQG9KYT9	S	opt_01K86RGJGY4HS0MJR8N9S67T72	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.235+00	2025-10-22 21:47:51.202+00
optval_01K86RGJGYXP5JAT53NPHA1JZ8	M	opt_01K86RGJGY4HS0MJR8N9S67T72	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.235+00	2025-10-22 21:47:51.202+00
optval_01K86RGJGYQVW41070DBQB30TA	L	opt_01K86RGJGY4HS0MJR8N9S67T72	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.235+00	2025-10-22 21:47:51.202+00
optval_01K86RGJGYJ9ENXF9D8JQAND2Y	XL	opt_01K86RGJGY4HS0MJR8N9S67T72	\N	2025-10-22 20:07:07.044+00	2025-10-22 21:47:51.235+00	2025-10-22 21:47:51.202+00
optval_01K8715YBZFY5DWBAYG88EF67T	Sky Blue	opt_01K8715YC0DACGTEB29QSRPHY1	\N	2025-10-22 22:38:35.904+00	2025-10-22 22:38:35.904+00	\N
optval_01K8715YC0Q4F1NJKNX5SGJP6Z	White	opt_01K8715YC0DACGTEB29QSRPHY1	\N	2025-10-22 22:38:35.904+00	2025-10-22 22:38:35.904+00	\N
optval_01K8715YC0Y39HZXE43XPWKH4D	Orange	opt_01K8715YC0DACGTEB29QSRPHY1	\N	2025-10-22 22:38:35.904+00	2025-10-22 22:38:35.904+00	\N
optval_01K871H01E9QACXNKQ5NTX4EWY	Yellow	opt_01K871H01F6E8Y2S1QC48Z97MB	\N	2025-10-22 22:44:38.065+00	2025-10-22 22:44:38.065+00	\N
optval_01K871H01EK93F6HFT836RQYFQ	Brown	opt_01K871H01F6E8Y2S1QC48Z97MB	\N	2025-10-22 22:44:38.065+00	2025-10-22 22:44:38.065+00	\N
optval_01K871H01EYGH5PT4BNW6AE873	Pattern	opt_01K871H01F6E8Y2S1QC48Z97MB	\N	2025-10-22 22:44:38.065+00	2025-10-22 22:44:38.065+00	\N
optval_01K870TZYYQ478A78PBTE59D8F	White	opt_01K870TZYY0ACBXMSNECX9RZ1N	\N	2025-10-22 22:32:37.087+00	2025-10-23 17:32:54.971+00	2025-10-23 17:32:54.909+00
optval_01K870TZYYMP5RD3X8G1SBZKFJ	Black	opt_01K870TZYY0ACBXMSNECX9RZ1N	\N	2025-10-22 22:32:37.087+00	2025-10-23 17:32:54.972+00	2025-10-23 17:32:54.909+00
optval_01K870TZYYT3W6A78Y473JHF0Y	Cognac	opt_01K870TZYY0ACBXMSNECX9RZ1N	\N	2025-10-22 22:32:37.087+00	2025-10-23 17:32:54.972+00	2025-10-23 17:32:54.909+00
optval_01K89286HCRVGXQKJ552TE2Z4N	Cognac	opt_01K89286HCR0NNWKKG5JWYY6XM	\N	2025-10-23 17:35:47.245+00	2025-10-23 17:35:47.245+00	\N
optval_01K89286HCD0ZE452K71R5A2R0	Black	opt_01K89286HCR0NNWKKG5JWYY6XM	\N	2025-10-23 17:35:47.245+00	2025-10-23 17:35:47.245+00	\N
optval_01K89286HC0E2VXKAWXHB0PK9F	White	opt_01K89286HCR0NNWKKG5JWYY6XM	\N	2025-10-23 17:35:47.245+00	2025-10-23 17:35:47.245+00	\N
optval_01K898RB2CN3BNSGQHK1YA6Q8R	Yellow	opt_01K898RB2DG6B1D2G3THBKBBZW	\N	2025-10-23 19:29:27.63+00	2025-10-23 19:29:27.63+00	\N
optval_01K898RB2CM6Z70SJ3G0K94ENE	Navy	opt_01K898RB2DG6B1D2G3THBKBBZW	\N	2025-10-23 19:29:27.63+00	2025-10-23 19:29:27.63+00	\N
optval_01K898RB2CRVZXZP9A8412K6B2	Green	opt_01K898RB2DG6B1D2G3THBKBBZW	\N	2025-10-23 19:29:27.63+00	2025-10-23 19:29:27.63+00	\N
optval_01K898RB2CBM8WJRPA7GVAQ2BT	Pattern	opt_01K898RB2DG6B1D2G3THBKBBZW	\N	2025-10-23 19:29:27.63+00	2025-10-23 19:29:27.63+00	\N
optval_01K899Z57YMA5402PZ20DQ0J9G	Cognac	opt_01K899Z57ZJ0W6TKGD4ZGBP4G1	\N	2025-10-23 19:50:39.616+00	2025-10-23 19:50:39.616+00	\N
optval_01K899Z57ZYRGV4BRYC9CPD506	White	opt_01K899Z57ZJ0W6TKGD4ZGBP4G1	\N	2025-10-23 19:50:39.616+00	2025-10-23 19:50:39.616+00	\N
optval_01K899Z57ZSRZWQSA8Y2QKFDZG	Black	opt_01K899Z57ZJ0W6TKGD4ZGBP4G1	\N	2025-10-23 19:50:39.616+00	2025-10-23 19:50:39.616+00	\N
\.


--
-- TOC entry 6575 (class 0 OID 21759)
-- Dependencies: 344
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K86RGJGSFGNYEBD80ZBASQQR	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K86RGJJ587Z4X7Z6NMW5EA4C	2025-10-22 20:07:07.076603+00	2025-10-22 21:47:41.042+00	2025-10-22 21:47:41.041+00
prod_01K86RGJGSDMNSWH34XZ83V1HG	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K86RGJJ5KXB3ND4XAVPFNV4E	2025-10-22 20:07:07.076603+00	2025-10-22 21:47:44.911+00	2025-10-22 21:47:44.911+00
prod_01K86RGJGSDAQ3VAGK2ABX4VFN	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K86RGJJ439K6RBQPHGTQQ38C	2025-10-22 20:07:07.076603+00	2025-10-22 21:47:48.414+00	2025-10-22 21:47:48.414+00
prod_01K86RGJGSA0PYV2C3WZY4GHJG	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K86RGJJ5YP352B94Y8Q20BMX	2025-10-22 20:07:07.076603+00	2025-10-22 21:47:51.207+00	2025-10-22 21:47:51.206+00
prod_01K870AG8DXCZV5NN6J5NVFKY0	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K870AGAADAEXMBYNTNZ2M6TP	2025-10-22 22:23:36.773343+00	2025-10-22 22:23:36.773343+00	\N
prod_01K870T4CJ5BZBA89E01S4ZN63	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K870T4DS1ZHTKTM8WK4Z90B8	2025-10-22 22:32:08.889377+00	2025-10-22 22:32:09.018+00	2025-10-22 22:32:09.018+00
prod_01K8715YBZDSTSAZ4PXMR8HZJS	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K8715YDFZ80Q3TQ1RKF7RRV4	2025-10-22 22:38:35.947973+00	2025-10-22 22:38:35.947973+00	\N
prod_01K871H01D777X2BKZX991DA8K	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K871H02SQ16100112W1HQYMC	2025-10-22 22:44:38.10546+00	2025-10-22 22:44:38.10546+00	\N
prod_01K870TZYX6C9NVBWGX1YAH303	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K870TZZ9BZPX1CVNXQ5PX6DJ	2025-10-22 22:32:37.096255+00	2025-10-23 17:32:54.929+00	2025-10-23 17:32:54.928+00
prod_01K89286HA6YCDJWZ2DH68KBNB	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K89286JMADZKCQFWSZA3C8FE	2025-10-23 17:35:47.279205+00	2025-10-23 17:35:47.279205+00	\N
prod_01K898RB2BFVKT544YNZHRC3DG	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K898RB3MEY1SXBV0PS71T86K	2025-10-23 19:29:27.667069+00	2025-10-23 19:29:27.667069+00	\N
prod_01K899Z57YTQT04HG5J1P39R5W	sc_01K86RG9F20H7KT7BC6R0WD39V	prodsc_01K899Z58NSMSC4A3MYQVWQGAS	2025-10-23 19:50:39.637233+00	2025-10-23 19:50:39.637233+00	\N
\.


--
-- TOC entry 6582 (class 0 OID 21844)
-- Dependencies: 351
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K86RGJGSFGNYEBD80ZBASQQR	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	prodsp_01K86RGJJNRD0BF4K07199Y24Y	2025-10-22 20:07:07.093129+00	2025-10-22 21:47:41.056+00	2025-10-22 21:47:41.056+00
prod_01K86RGJGSDMNSWH34XZ83V1HG	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	prodsp_01K86RGJJN63A31HT1E1GRPZSQ	2025-10-22 20:07:07.093129+00	2025-10-22 21:47:44.908+00	2025-10-22 21:47:44.908+00
prod_01K86RGJGSDAQ3VAGK2ABX4VFN	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	prodsp_01K86RGJJMJZKVKREWWGJ89E0K	2025-10-22 20:07:07.093129+00	2025-10-22 21:47:48.417+00	2025-10-22 21:47:48.416+00
prod_01K86RGJGSA0PYV2C3WZY4GHJG	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	prodsp_01K86RGJJNVFR5KRTBBG77DMA1	2025-10-22 20:07:07.093129+00	2025-10-22 21:47:51.209+00	2025-10-22 21:47:51.209+00
prod_01K8715YBZDSTSAZ4PXMR8HZJS	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	prodsp_01K87192EFBBRH9AREVNX4XRAN	2025-10-22 22:40:18.38348+00	2025-10-22 22:40:18.38348+00	\N
\.


--
-- TOC entry 6460 (class 0 OID 19359)
-- Dependencies: 229
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6464 (class 0 OID 19408)
-- Dependencies: 233
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- TOC entry 6461 (class 0 OID 19370)
-- Dependencies: 230
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6456 (class 0 OID 19308)
-- Dependencies: 225
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K86RGJKQAGS934S84006J2ME	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSFGNYEBD80ZBASQQR	2025-10-22 20:07:07.129+00	2025-10-22 21:47:41.029+00	2025-10-22 21:47:41.008+00
variant_01K86RGJKQH6J5CTZ5P7G132PD	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSFGNYEBD80ZBASQQR	2025-10-22 20:07:07.129+00	2025-10-22 21:47:41.029+00	2025-10-22 21:47:41.008+00
variant_01K86RGJKQXRWXCKF53KD8W4MM	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSFGNYEBD80ZBASQQR	2025-10-22 20:07:07.129+00	2025-10-22 21:47:41.029+00	2025-10-22 21:47:41.008+00
variant_01K86RGJKR3X2GBNXPZRFBD0K4	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSFGNYEBD80ZBASQQR	2025-10-22 20:07:07.129+00	2025-10-22 21:47:41.029+00	2025-10-22 21:47:41.008+00
variant_01K86RGJKPH4R6917TT3VX5NRJ	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDMNSWH34XZ83V1HG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00
variant_01K86RGJKP676D5Q3P5WJ3PH6J	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDMNSWH34XZ83V1HG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00
variant_01K86RGJKQ7VTM7K3ZKGWVC65H	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDMNSWH34XZ83V1HG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00
variant_01K86RGJKQX2XC8BYVZRH7A6VV	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDMNSWH34XZ83V1HG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:44.925+00	2025-10-22 21:47:44.906+00
variant_01K86RGJKM4B16X23G0ZD7Y77P	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.128+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKMX0F5054FEDWKAPA8	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.128+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKMJH8NG1SGXVF27YVK	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.128+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKMFEZ6PAGRD4VCXHR0	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.129+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKNJDEBGMGTFGPA3CC8	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.129+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKN45NAS762HQC7QKPE	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.129+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKNM0DCHMSKY4K6KVXB	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.129+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKN4GMJGA4MW9WKKWWQ	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSDAQ3VAGK2ABX4VFN	2025-10-22 20:07:07.129+00	2025-10-22 21:47:48.433+00	2025-10-22 21:47:48.409+00
variant_01K86RGJKPWHEE1X52GR1TZQTN	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSA0PYV2C3WZY4GHJG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00
variant_01K86RGJKP5D0VAAYKKWXDZ5DK	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSA0PYV2C3WZY4GHJG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00
variant_01K86RGJKPJEMA5P9FDZ1F57B5	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSA0PYV2C3WZY4GHJG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00
variant_01K86RGJKP890D4Z1ER1BCG8VW	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86RGJGSA0PYV2C3WZY4GHJG	2025-10-22 20:07:07.129+00	2025-10-22 21:47:51.22+00	2025-10-22 21:47:51.202+00
variant_01K86ZJ6JVX74MNSJFXCJFK1V8	S	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR	2025-10-22 22:10:20.38+00	2025-10-22 22:25:33.576+00	2025-10-22 22:25:33.56+00
variant_01K86ZJ6JVKMRJT49MF5VVTRHZ	M	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR	2025-10-22 22:10:20.38+00	2025-10-22 22:25:33.576+00	2025-10-22 22:25:33.56+00
variant_01K86ZJ6JWJXQWVQADP924P8S4	L	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR	2025-10-22 22:10:20.381+00	2025-10-22 22:25:33.577+00	2025-10-22 22:25:33.56+00
variant_01K86ZJ6JWXE1CD1T92ZW17F1B	XL	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86ZJ6GRTFXTSB4PXAN5FMXR	2025-10-22 22:10:20.381+00	2025-10-22 22:25:33.577+00	2025-10-22 22:25:33.56+00
variant_01K86ZJ6JVKNDJV6CH5D210YBH	One Size	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K86ZJ6GQQJ9WEV3FA3DR8HT2	2025-10-22 22:10:20.38+00	2025-10-22 22:25:36.635+00	2025-10-22 22:25:36.619+00
variant_01K8715YEEBBYSYN12E72298PN	Sky Blue	POL-L-SKB	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8715YBZDSTSAZ4PXMR8HZJS	2025-10-22 22:38:35.982+00	2025-10-22 22:38:35.982+00	\N
variant_01K8715YEEN15NDMPPJZ2WG9Y3	White	POL-L-WHI	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K8715YBZDSTSAZ4PXMR8HZJS	2025-10-22 22:38:35.982+00	2025-10-22 22:38:35.982+00	\N
variant_01K8715YEE0R337AWX09TGQ872	Orange	POL-L-ORG	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K8715YBZDSTSAZ4PXMR8HZJS	2025-10-22 22:38:35.983+00	2025-10-22 22:38:35.983+00	\N
variant_01K89286KTRVMZ8TR8S29SH3ZD	Black	AME-D-BLA	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K89286HA6YCDJWZ2DH68KBNB	2025-10-23 17:35:47.323+00	2025-10-23 17:35:47.323+00	\N
variant_01K89286KT6QX09EWHY5AEX017	White	AME-D-WHI	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K89286HA6YCDJWZ2DH68KBNB	2025-10-23 17:35:47.323+00	2025-10-23 17:35:47.323+00	\N
variant_01K870AGCCDVP5NNR7KAP75NDJ	Green	SUO-L-GRE	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K870AG8DXCZV5NN6J5NVFKY0	2025-10-22 22:23:36.844+00	2025-10-22 22:23:36.844+00	\N
variant_01K870TZZV09PC2PE242D6E4W2	Cognac	AME-D-COG	\N	\N	\N	t	t	\N	\N	\N	Leather	\N	\N	\N	\N	\N	0	prod_01K870TZYX6C9NVBWGX1YAH303	2025-10-22 22:32:37.116+00	2025-10-23 17:32:54.961+00	2025-10-23 17:32:54.909+00
variant_01K870TZZVN8SWS30YGKYAHCKC	White	AME-D-WHI	\N	\N	\N	t	t	\N	\N	\N	Leather	\N	\N	\N	\N	\N	1	prod_01K870TZYX6C9NVBWGX1YAH303	2025-10-22 22:32:37.116+00	2025-10-23 17:32:54.962+00	2025-10-23 17:32:54.909+00
variant_01K870TZZWASEP00FVDM6P8N4T	Black	AME-D-BLA	\N	\N	\N	t	t	\N	\N	\N	Leather	\N	\N	\N	\N	\N	2	prod_01K870TZYX6C9NVBWGX1YAH303	2025-10-22 22:32:37.116+00	2025-10-23 17:32:54.962+00	2025-10-23 17:32:54.909+00
variant_01K89286KS0GNR2XK3FV45AB1Q	Cognac	AME-D-COG	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K89286HA6YCDJWZ2DH68KBNB	2025-10-23 17:35:47.322+00	2025-10-23 17:35:47.322+00	\N
variant_01K870AGCCSDFWDBDBB8MWCYZB	Gray	SUO-L-GRA	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K870AG8DXCZV5NN6J5NVFKY0	2025-10-22 22:23:36.845+00	2025-10-22 22:23:36.845+00	\N
variant_01K870AGCCVBRWDG2X5YP9M0K4	Red	SOU-L-RED	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K870AG8DXCZV5NN6J5NVFKY0	2025-10-22 22:23:36.845+00	2025-10-22 22:23:36.845+00	\N
variant_01K870AGCCERJX91A61ZCKAGE2	Navy	SOU-L-NAV	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	3	prod_01K870AG8DXCZV5NN6J5NVFKY0	2025-10-22 22:23:36.845+00	2025-10-22 22:23:36.845+00	\N
variant_01K871H03PKC4JQYWHHAA2H05X	Brown	ALP-H-BRW	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K871H01D777X2BKZX991DA8K	2025-10-22 22:44:38.134+00	2025-10-22 22:44:38.134+00	\N
variant_01K871H03PBQH2ZVBMRW8JMJPQ	Pattern	ALP-H-PAT	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K871H01D777X2BKZX991DA8K	2025-10-22 22:44:38.134+00	2025-10-22 22:44:38.134+00	\N
variant_01K871H03PQHZJJ9G6GWKBYDWH	Yellow	ALP-H-YEL	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K871H01D777X2BKZX991DA8K	2025-10-22 22:44:38.134+00	2025-10-22 22:44:38.134+00	\N
variant_01K898RB4NBCPP4B9TG5QQZBB9	Yellow	ALP-P-YEL	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K898RB2BFVKT544YNZHRC3DG	2025-10-23 19:29:27.702+00	2025-10-23 19:29:27.702+00	\N
variant_01K898RB4NCGRXR5X3B9HGFSN0	Navy	ALP-P-NAV	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K898RB2BFVKT544YNZHRC3DG	2025-10-23 19:29:27.702+00	2025-10-23 19:29:27.702+00	\N
variant_01K898RB4NDDRYHPP28QTHFH7W	Green	ALP-P-GRE	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K898RB2BFVKT544YNZHRC3DG	2025-10-23 19:29:27.702+00	2025-10-23 19:29:27.702+00	\N
variant_01K898RB4N2Y2NZJZ8245XEPN4	Pattern	ALP-P-PAT	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	3	prod_01K898RB2BFVKT544YNZHRC3DG	2025-10-23 19:29:27.702+00	2025-10-23 19:29:27.702+00	\N
variant_01K899Z59KXZ5GGQ020JJEZVBT	Cognac	AME-R-COG	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K899Z57YTQT04HG5J1P39R5W	2025-10-23 19:50:39.667+00	2025-10-23 19:50:39.667+00	\N
variant_01K899Z59KSTDWBN54CBTHY8TT	White	AME-R-WHI	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K899Z57YTQT04HG5J1P39R5W	2025-10-23 19:50:39.668+00	2025-10-23 19:50:39.668+00	\N
variant_01K899Z59KMAK456D42GXDPNWC	Black	AME-R-BLA	\N	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K899Z57YTQT04HG5J1P39R5W	2025-10-23 19:50:39.668+00	2025-10-23 19:50:39.668+00	\N
\.


--
-- TOC entry 6577 (class 0 OID 21761)
-- Dependencies: 346
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01K86RGJKQAGS934S84006J2ME	iitem_01K86RGJMR7N61ZKNVCWP8CMWT	pvitem_01K86RGJP2PR34SBF4M276NSXW	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:40.992+00	2025-10-22 21:47:40.991+00
variant_01K86RGJKQH6J5CTZ5P7G132PD	iitem_01K86RGJMRVAXS4NKVQBWQAV1B	pvitem_01K86RGJP36257WR9DPRM9PNEV	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:40.992+00	2025-10-22 21:47:40.991+00
variant_01K86RGJKQXRWXCKF53KD8W4MM	iitem_01K86RGJMRQSSJS4XGTV982MNF	pvitem_01K86RGJP3ESPG7XE2FFWPE8RD	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:40.992+00	2025-10-22 21:47:40.991+00
variant_01K86RGJKR3X2GBNXPZRFBD0K4	iitem_01K86RGJMS67MTG1ZMQ4W7GKKX	pvitem_01K86RGJP33HP2Y29EE1HKVD63	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:40.992+00	2025-10-22 21:47:40.991+00
variant_01K86RGJKPH4R6917TT3VX5NRJ	iitem_01K86RGJMQGRHNVKHKCQTCBSJE	pvitem_01K86RGJP2PVVAJ4MV9NN5JK6W	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:44.892+00	2025-10-22 21:47:44.892+00
variant_01K86RGJKP676D5Q3P5WJ3PH6J	iitem_01K86RGJMQ3ENGXS906AVK6AN7	pvitem_01K86RGJP2YB54RXB8JNSRK3KK	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:44.892+00	2025-10-22 21:47:44.892+00
variant_01K86RGJKQ7VTM7K3ZKGWVC65H	iitem_01K86RGJMQEV0EMP4CH7QA21Y5	pvitem_01K86RGJP2P3S11F951K8DSX8Z	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:44.892+00	2025-10-22 21:47:44.892+00
variant_01K86RGJKQX2XC8BYVZRH7A6VV	iitem_01K86RGJMRV22338QPY0C69023	pvitem_01K86RGJP265BPWK79R9X5CSR9	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:44.892+00	2025-10-22 21:47:44.892+00
variant_01K86RGJKM4B16X23G0ZD7Y77P	iitem_01K86RGJMN7Z1PBQ3AY48Y3500	pvitem_01K86RGJP0SJ845R9NPNW9T9SB	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKMX0F5054FEDWKAPA8	iitem_01K86RGJMPFMNWR5FJYX48N9EV	pvitem_01K86RGJP00GN7SP59C9R7N875	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKMJH8NG1SGXVF27YVK	iitem_01K86RGJMPN4GJ5MATE9143MSS	pvitem_01K86RGJP1M4PJ7CZ8WMP3SCYZ	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKMFEZ6PAGRD4VCXHR0	iitem_01K86RGJMPRYS6B6C99SANT4GT	pvitem_01K86RGJP1M1F9G1APMR58JZRT	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.396+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKNJDEBGMGTFGPA3CC8	iitem_01K86RGJMPH3JT778M54W0A0NW	pvitem_01K86RGJP1AFDSV3E8HCZY85R5	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKN45NAS762HQC7QKPE	iitem_01K86RGJMPRAXEF6HRF9J8SCV3	pvitem_01K86RGJP1E8DBM05FDXBQBCGH	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKNM0DCHMSKY4K6KVXB	iitem_01K86RGJMPR6281BGG47MPRTRM	pvitem_01K86RGJP1Y05MSRT4725J3SK2	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKN4GMJGA4MW9WKKWWQ	iitem_01K86RGJMP4EG2MRPP55PDS7PF	pvitem_01K86RGJP1N14EBX7QWP7JPBHV	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:48.395+00	2025-10-22 21:47:48.395+00
variant_01K86RGJKPWHEE1X52GR1TZQTN	iitem_01K86RGJMQ62BS4RXP0B21R9A9	pvitem_01K86RGJP14R6DT1T9T9NGZQNG	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:51.192+00	2025-10-22 21:47:51.192+00
variant_01K86RGJKP5D0VAAYKKWXDZ5DK	iitem_01K86RGJMQ821H6Y3YQZ9SP5NC	pvitem_01K86RGJP26N3WN1HQ30YHQXQ2	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:51.192+00	2025-10-22 21:47:51.192+00
variant_01K86RGJKPJEMA5P9FDZ1F57B5	iitem_01K86RGJMQF0TTDXS6D1JKM3QP	pvitem_01K86RGJP24CWTKPY0V7NY5Z0A	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:51.192+00	2025-10-22 21:47:51.192+00
variant_01K86RGJKP890D4Z1ER1BCG8VW	iitem_01K86RGJMQVBMB5MT1BEB1TSV0	pvitem_01K86RGJP2M09PAM20TG2VAWRY	1	2025-10-22 20:07:07.200481+00	2025-10-22 21:47:51.192+00	2025-10-22 21:47:51.192+00
variant_01K870AGCCDVP5NNR7KAP75NDJ	iitem_01K870AGCYE0ZQBGZ57A09V9X1	pvitem_01K870AGDTRZ31ZYCANPJGJ2H6	1	2025-10-22 22:23:36.8896+00	2025-10-22 22:23:36.8896+00	\N
variant_01K870AGCCSDFWDBDBB8MWCYZB	iitem_01K870AGCYP084BWMFQW2KKZ7G	pvitem_01K870AGDTEH9BQG3CW5WXPJHC	1	2025-10-22 22:23:36.8896+00	2025-10-22 22:23:36.8896+00	\N
variant_01K870AGCCVBRWDG2X5YP9M0K4	iitem_01K870AGCY69SAGYZRTZF9DE9X	pvitem_01K870AGDTNDCH6F4FFSBMSR1A	1	2025-10-22 22:23:36.8896+00	2025-10-22 22:23:36.8896+00	\N
variant_01K870AGCCERJX91A61ZCKAGE2	iitem_01K870AGCYPMR55SX59AHZVT5A	pvitem_01K870AGDVSWEBQXY8GKKCGH8N	1	2025-10-22 22:23:36.8896+00	2025-10-22 22:23:36.8896+00	\N
variant_01K86ZJ6JVX74MNSJFXCJFK1V8	iitem_01K86ZJ6KAMZWEN1A3B3SE6S6B	pvitem_01K86ZJ6M2WKZTGHEP33PVH12G	1	2025-10-22 22:10:20.416493+00	2025-10-22 22:25:33.549+00	2025-10-22 22:25:33.549+00
variant_01K86ZJ6JVKMRJT49MF5VVTRHZ	iitem_01K86ZJ6KAR2WJ2MZYQ0Y8KBEN	pvitem_01K86ZJ6M3Q2HPGRV12JKQ0YXR	1	2025-10-22 22:10:20.416493+00	2025-10-22 22:25:33.549+00	2025-10-22 22:25:33.549+00
variant_01K86ZJ6JWJXQWVQADP924P8S4	iitem_01K86ZJ6KBFERST72JA4ZA4KJ3	pvitem_01K86ZJ6M37ADBJV82NNKB7T1D	1	2025-10-22 22:10:20.416493+00	2025-10-22 22:25:33.549+00	2025-10-22 22:25:33.549+00
variant_01K86ZJ6JWXE1CD1T92ZW17F1B	iitem_01K86ZJ6KBD4876TV8WAESHMVY	pvitem_01K86ZJ6M4SHGMAJFJD9V20FXQ	1	2025-10-22 22:10:20.416493+00	2025-10-22 22:25:33.549+00	2025-10-22 22:25:33.549+00
variant_01K86ZJ6JVKNDJV6CH5D210YBH	iitem_01K86ZJ6KACJ3RP5TE41DDMXJN	pvitem_01K86ZJ6M1KBY8KCYZ69GFP5Z1	1	2025-10-22 22:10:20.416493+00	2025-10-22 22:25:36.608+00	2025-10-22 22:25:36.608+00
variant_01K8715YEEBBYSYN12E72298PN	iitem_01K8715YETR1ZZB7HMV3VPM3DJ	pvitem_01K8715YF6F2JVVH1605VYV2KR	1	2025-10-22 22:38:36.006213+00	2025-10-22 22:38:36.006213+00	\N
variant_01K8715YEEN15NDMPPJZ2WG9Y3	iitem_01K8715YET4FCQ9NJVMD2QYHB7	pvitem_01K8715YF6106QX5GWVS6Q8K5B	1	2025-10-22 22:38:36.006213+00	2025-10-22 22:38:36.006213+00	\N
variant_01K8715YEE0R337AWX09TGQ872	iitem_01K8715YETHCCVCKE6AGJT3Y4Y	pvitem_01K8715YF6M1ACVQZTHWPJ9G6E	1	2025-10-22 22:38:36.006213+00	2025-10-22 22:38:36.006213+00	\N
variant_01K871H03PQHZJJ9G6GWKBYDWH	iitem_01K871H042G2BN2Q44VMGWS8QS	pvitem_01K871H04EFHVG2C7KQ84YMAN9	1	2025-10-22 22:44:38.158305+00	2025-10-22 22:44:38.158305+00	\N
variant_01K871H03PKC4JQYWHHAA2H05X	iitem_01K871H0426SQD4Q1MQE9A5XF6	pvitem_01K871H04E0A2MF90FAWYDSK11	1	2025-10-22 22:44:38.158305+00	2025-10-22 22:44:38.158305+00	\N
variant_01K871H03PBQH2ZVBMRW8JMJPQ	iitem_01K871H042B7SHN6ZRDQM7EGKW	pvitem_01K871H04EHNBGY7ZQGZTP0255	1	2025-10-22 22:44:38.158305+00	2025-10-22 22:44:38.158305+00	\N
variant_01K89286KS0GNR2XK3FV45AB1Q	iitem_01K89286MPJTSVH249VWRAKDVP	pvitem_01K89286NE4R6BW1T9SVYJW89R	1	2025-10-23 17:35:47.369219+00	2025-10-23 17:35:47.369219+00	\N
variant_01K89286KTRVMZ8TR8S29SH3ZD	iitem_01K89286MQDPZE5J4TEDWVGGK7	pvitem_01K89286NESJ5S44Y5J0TJNDRN	1	2025-10-23 17:35:47.369219+00	2025-10-23 17:35:47.369219+00	\N
variant_01K89286KT6QX09EWHY5AEX017	iitem_01K89286MQ5WPWE154J6GRP220	pvitem_01K89286NFJXWP9C0YJTDCXK4V	1	2025-10-23 17:35:47.369219+00	2025-10-23 17:35:47.369219+00	\N
variant_01K898RB4NBCPP4B9TG5QQZBB9	iitem_01K898RB57X2PYYVKEKKN3CY1Q	pvitem_01K898RB5SSRGE60DV6166GVQA	1	2025-10-23 19:29:27.736705+00	2025-10-23 19:29:27.736705+00	\N
variant_01K898RB4NCGRXR5X3B9HGFSN0	iitem_01K898RB57RM823HDN8SR2QGJ0	pvitem_01K898RB5TZGYP6WDMFV3HK1GN	1	2025-10-23 19:29:27.736705+00	2025-10-23 19:29:27.736705+00	\N
variant_01K898RB4NDDRYHPP28QTHFH7W	iitem_01K898RB57Y3V5NFGBHJDPS49P	pvitem_01K898RB5TXYEV0M572R5D6RQY	1	2025-10-23 19:29:27.736705+00	2025-10-23 19:29:27.736705+00	\N
variant_01K898RB4N2Y2NZJZ8245XEPN4	iitem_01K898RB57KPS7JHBKM3Y3YQ7R	pvitem_01K898RB5VRW73E3M6JQHZRC33	1	2025-10-23 19:29:27.736705+00	2025-10-23 19:29:27.736705+00	\N
variant_01K899Z59KXZ5GGQ020JJEZVBT	iitem_01K899Z5A28CJWHC18PW96ANBD	pvitem_01K899Z5AK0CX38S4W53M29PR8	1	2025-10-23 19:50:39.698794+00	2025-10-23 19:50:39.698794+00	\N
variant_01K899Z59KSTDWBN54CBTHY8TT	iitem_01K899Z5A2JZ9VQSTWNPJFHW1N	pvitem_01K899Z5AM9H4DR9NN9KNNK1V1	1	2025-10-23 19:50:39.698794+00	2025-10-23 19:50:39.698794+00	\N
variant_01K899Z59KMAK456D42GXDPNWC	iitem_01K899Z5A20W00XV6C9613V878	pvitem_01K899Z5AMVX6MQ8381B2NFVDG	1	2025-10-23 19:50:39.698794+00	2025-10-23 19:50:39.698794+00	\N
\.


--
-- TOC entry 6466 (class 0 OID 19429)
-- Dependencies: 235
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K86RGJKM4B16X23G0ZD7Y77P	optval_01K86RGJGVPPXVVGDG4FZ7M64M
variant_01K86RGJKM4B16X23G0ZD7Y77P	optval_01K86RGJGWXDKENEG1MDZK2YD0
variant_01K86RGJKMX0F5054FEDWKAPA8	optval_01K86RGJGVPPXVVGDG4FZ7M64M
variant_01K86RGJKMX0F5054FEDWKAPA8	optval_01K86RGJGW5CB9GCQNSAX9M0Y7
variant_01K86RGJKMJH8NG1SGXVF27YVK	optval_01K86RGJGWSST4J4KMJJ5726B6
variant_01K86RGJKMJH8NG1SGXVF27YVK	optval_01K86RGJGWXDKENEG1MDZK2YD0
variant_01K86RGJKMFEZ6PAGRD4VCXHR0	optval_01K86RGJGWSST4J4KMJJ5726B6
variant_01K86RGJKMFEZ6PAGRD4VCXHR0	optval_01K86RGJGW5CB9GCQNSAX9M0Y7
variant_01K86RGJKNJDEBGMGTFGPA3CC8	optval_01K86RGJGWB65EDMHMH2701XBP
variant_01K86RGJKNJDEBGMGTFGPA3CC8	optval_01K86RGJGWXDKENEG1MDZK2YD0
variant_01K86RGJKN45NAS762HQC7QKPE	optval_01K86RGJGWB65EDMHMH2701XBP
variant_01K86RGJKN45NAS762HQC7QKPE	optval_01K86RGJGW5CB9GCQNSAX9M0Y7
variant_01K86RGJKNM0DCHMSKY4K6KVXB	optval_01K86RGJGWKBBHSYH15NJ3VTN6
variant_01K86RGJKNM0DCHMSKY4K6KVXB	optval_01K86RGJGWXDKENEG1MDZK2YD0
variant_01K86RGJKN4GMJGA4MW9WKKWWQ	optval_01K86RGJGWKBBHSYH15NJ3VTN6
variant_01K86RGJKN4GMJGA4MW9WKKWWQ	optval_01K86RGJGW5CB9GCQNSAX9M0Y7
variant_01K86RGJKPWHEE1X52GR1TZQTN	optval_01K86RGJGYNFXZZRVSDQG9KYT9
variant_01K86RGJKP5D0VAAYKKWXDZ5DK	optval_01K86RGJGYXP5JAT53NPHA1JZ8
variant_01K86RGJKPJEMA5P9FDZ1F57B5	optval_01K86RGJGYQVW41070DBQB30TA
variant_01K86RGJKP890D4Z1ER1BCG8VW	optval_01K86RGJGYJ9ENXF9D8JQAND2Y
variant_01K86RGJKPH4R6917TT3VX5NRJ	optval_01K86RGJGZ52BVNEV8D2D308R2
variant_01K86RGJKP676D5Q3P5WJ3PH6J	optval_01K86RGJGZBFBR6TV9RRQNQNV8
variant_01K86RGJKQ7VTM7K3ZKGWVC65H	optval_01K86RGJGZ2Y33T8856FWFEB3B
variant_01K86RGJKQX2XC8BYVZRH7A6VV	optval_01K86RGJGZ1J956CX7M7C3KB77
variant_01K86RGJKQAGS934S84006J2ME	optval_01K86RGJH0P589BKRH2YZPN8HB
variant_01K86RGJKQH6J5CTZ5P7G132PD	optval_01K86RGJH0QQZYQ4W2NYCPSR4M
variant_01K86RGJKQXRWXCKF53KD8W4MM	optval_01K86RGJH01JRGAH5VE95Y5MRJ
variant_01K86RGJKR3X2GBNXPZRFBD0K4	optval_01K86RGJH0D1YVZ8KB6931M9S0
variant_01K86ZJ6JVKNDJV6CH5D210YBH	optval_01K86ZJ6GR3958MET6HXDKBS19
variant_01K86ZJ6JVX74MNSJFXCJFK1V8	optval_01K86ZJ6GSW1AC8CWMEV5PSTKV
variant_01K86ZJ6JVKMRJT49MF5VVTRHZ	optval_01K86ZJ6GS37QP17HHWB9EQG2B
variant_01K86ZJ6JWJXQWVQADP924P8S4	optval_01K86ZJ6GS7A7BRQ6RTNXYX14A
variant_01K86ZJ6JWXE1CD1T92ZW17F1B	optval_01K86ZJ6GS424GZFXGP5SYF3XC
variant_01K870AGCCDVP5NNR7KAP75NDJ	optval_01K870AG8EW6MSZW04CRT2NGQG
variant_01K870AGCCSDFWDBDBB8MWCYZB	optval_01K870AG8EZC1EWKTE0GD4THD3
variant_01K870AGCCVBRWDG2X5YP9M0K4	optval_01K870AG8ER9YQ72CB6TPX8SG3
variant_01K870AGCCERJX91A61ZCKAGE2	optval_01K870AG8EAZ0920PMP5ZRZ6EV
variant_01K870TZZV09PC2PE242D6E4W2	optval_01K870TZYYT3W6A78Y473JHF0Y
variant_01K870TZZVN8SWS30YGKYAHCKC	optval_01K870TZYYQ478A78PBTE59D8F
variant_01K870TZZWASEP00FVDM6P8N4T	optval_01K870TZYYMP5RD3X8G1SBZKFJ
variant_01K8715YEEBBYSYN12E72298PN	optval_01K8715YBZFY5DWBAYG88EF67T
variant_01K8715YEEN15NDMPPJZ2WG9Y3	optval_01K8715YC0Q4F1NJKNX5SGJP6Z
variant_01K8715YEE0R337AWX09TGQ872	optval_01K8715YC0Y39HZXE43XPWKH4D
variant_01K871H03PQHZJJ9G6GWKBYDWH	optval_01K871H01E9QACXNKQ5NTX4EWY
variant_01K871H03PKC4JQYWHHAA2H05X	optval_01K871H01EK93F6HFT836RQYFQ
variant_01K871H03PBQH2ZVBMRW8JMJPQ	optval_01K871H01EYGH5PT4BNW6AE873
variant_01K89286KS0GNR2XK3FV45AB1Q	optval_01K89286HCRVGXQKJ552TE2Z4N
variant_01K89286KTRVMZ8TR8S29SH3ZD	optval_01K89286HCD0ZE452K71R5A2R0
variant_01K89286KT6QX09EWHY5AEX017	optval_01K89286HC0E2VXKAWXHB0PK9F
variant_01K898RB4NBCPP4B9TG5QQZBB9	optval_01K898RB2CN3BNSGQHK1YA6Q8R
variant_01K898RB4NCGRXR5X3B9HGFSN0	optval_01K898RB2CM6Z70SJ3G0K94ENE
variant_01K898RB4NDDRYHPP28QTHFH7W	optval_01K898RB2CRVZXZP9A8412K6B2
variant_01K898RB4N2Y2NZJZ8245XEPN4	optval_01K898RB2CBM8WJRPA7GVAQ2BT
variant_01K899Z59KXZ5GGQ020JJEZVBT	optval_01K899Z57YMA5402PZ20DQ0J9G
variant_01K899Z59KSTDWBN54CBTHY8TT	optval_01K899Z57ZYRGV4BRYC9CPD506
variant_01K899Z59KMAK456D42GXDPNWC	optval_01K899Z57ZSRZWQSA8Y2QKFDZG
\.


--
-- TOC entry 6576 (class 0 OID 21760)
-- Dependencies: 345
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K86RGJKQAGS934S84006J2ME	pset_01K86RGJPM7NE16MWSZ3VMPVYV	pvps_01K86RGJQXRRY0Q81KJKHNFAZ5	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:41.023+00	2025-10-22 21:47:41.022+00
variant_01K86RGJKQH6J5CTZ5P7G132PD	pset_01K86RGJPM6RWYZVQP0Q1JZ9KW	pvps_01K86RGJQXJ2KS086JYQN4JB3T	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:41.023+00	2025-10-22 21:47:41.022+00
variant_01K86RGJKQXRWXCKF53KD8W4MM	pset_01K86RGJPMK7QMQ5QN5CFY0S1Z	pvps_01K86RGJQX9YDZPDJBDDK5A8H6	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:41.023+00	2025-10-22 21:47:41.022+00
variant_01K86RGJKR3X2GBNXPZRFBD0K4	pset_01K86RGJPNYAM0WS11JQDJZJ8Y	pvps_01K86RGJQYV5QE3W94KTAV5KFX	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:41.023+00	2025-10-22 21:47:41.022+00
variant_01K86RGJKPH4R6917TT3VX5NRJ	pset_01K86RGJPKK9NC5X0W7Z8JAD02	pvps_01K86RGJQXS924XRG6DGGVBD93	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:44.909+00	2025-10-22 21:47:44.909+00
variant_01K86RGJKP676D5Q3P5WJ3PH6J	pset_01K86RGJPKJ9BGHKTF8JDNJYMQ	pvps_01K86RGJQXDFW01N1P8CG9GAD6	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:44.909+00	2025-10-22 21:47:44.909+00
variant_01K86RGJKQ7VTM7K3ZKGWVC65H	pset_01K86RGJPKJ6T4NQVXZBGT3A4N	pvps_01K86RGJQXK65MRPW5AV83571W	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:44.909+00	2025-10-22 21:47:44.909+00
variant_01K86RGJKQX2XC8BYVZRH7A6VV	pset_01K86RGJPK7NG6ARGQ7N0P7FXM	pvps_01K86RGJQX2EC7PE9CFHJHYDAE	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:44.91+00	2025-10-22 21:47:44.909+00
variant_01K86RGJKM4B16X23G0ZD7Y77P	pset_01K86RGJPFHCPBKS2WG3ZNY0KP	pvps_01K86RGJQVPMF0BJGN3RERZDHW	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKMX0F5054FEDWKAPA8	pset_01K86RGJPF4TZ0HGR5S2DXR8JA	pvps_01K86RGJQVXRQ48FJYFTERQZHV	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKMJH8NG1SGXVF27YVK	pset_01K86RGJPGDTC8612BDAJ1BGX9	pvps_01K86RGJQVVYVZ1XS66HA5Q1ZS	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKMFEZ6PAGRD4VCXHR0	pset_01K86RGJPGA02APZ79QGY5DAD1	pvps_01K86RGJQWW4DAJ2ZP64H9YM5Z	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKNJDEBGMGTFGPA3CC8	pset_01K86RGJPGEKAB3SGVQXNRKYJ0	pvps_01K86RGJQW86WX1PX3F3GY421K	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKN45NAS762HQC7QKPE	pset_01K86RGJPHX1PKP2EGA860NTDM	pvps_01K86RGJQW0TY3HNP85KGBS6WS	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKNM0DCHMSKY4K6KVXB	pset_01K86RGJPHNH6D9HNKMGYFVZYH	pvps_01K86RGJQW2KKVN2Z68T1CTC67	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKN4GMJGA4MW9WKKWWQ	pset_01K86RGJPHM9N140JGA4BYW2CN	pvps_01K86RGJQWVFZ0M14G13GRQXN4	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:48.412+00	2025-10-22 21:47:48.411+00
variant_01K86RGJKPWHEE1X52GR1TZQTN	pset_01K86RGJPJX41526QMGS1PGP85	pvps_01K86RGJQWN1HCB4FXBQKRXWB7	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:51.205+00	2025-10-22 21:47:51.205+00
variant_01K86RGJKP5D0VAAYKKWXDZ5DK	pset_01K86RGJPJKSA07V16KNTX4800	pvps_01K86RGJQXTJXEPVKCG10VSK2Q	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:51.205+00	2025-10-22 21:47:51.205+00
variant_01K86RGJKPJEMA5P9FDZ1F57B5	pset_01K86RGJPJHX3EFDNQKP1J93KP	pvps_01K86RGJQXHSPP30JYJAC1A1EQ	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:51.205+00	2025-10-22 21:47:51.205+00
variant_01K86RGJKP890D4Z1ER1BCG8VW	pset_01K86RGJPJ57J3QYZ4AWE7ABSB	pvps_01K86RGJQX4F0RTT189458YHX4	2025-10-22 20:07:07.259433+00	2025-10-22 21:47:51.205+00	2025-10-22 21:47:51.205+00
variant_01K870AGCCDVP5NNR7KAP75NDJ	pset_01K870AGE2A1A62KJV66Z4213A	pvps_01K870AGFK6ZDTZDQK1N5PFXX1	2025-10-22 22:23:36.947445+00	2025-10-22 22:23:36.947445+00	\N
variant_01K870AGCCSDFWDBDBB8MWCYZB	pset_01K870AGE23BWVN1H8524XQVWG	pvps_01K870AGFKF689N04XV78G9QJM	2025-10-22 22:23:36.947445+00	2025-10-22 22:23:36.947445+00	\N
variant_01K870AGCCVBRWDG2X5YP9M0K4	pset_01K870AGE387SS1X3CBW9EQ8F7	pvps_01K870AGFM6GBJNK4TDWH0SDZZ	2025-10-22 22:23:36.947445+00	2025-10-22 22:23:36.947445+00	\N
variant_01K870AGCCERJX91A61ZCKAGE2	pset_01K870AGE3PCTDZ3A2MQKJQTBX	pvps_01K870AGFMF0P6N58A3MG64S92	2025-10-22 22:23:36.947445+00	2025-10-22 22:23:36.947445+00	\N
variant_01K86ZJ6JVX74MNSJFXCJFK1V8	pset_01K86ZJ6MQB1DZ8V075MPMH9J8	pvps_01K86ZJ6PBRCFZPT1PDP9XAQ87	2025-10-22 22:10:20.490836+00	2025-10-22 22:25:33.57+00	2025-10-22 22:25:33.57+00
variant_01K86ZJ6JVKMRJT49MF5VVTRHZ	pset_01K86ZJ6MQ70ZRE17Q4XZD8D6Z	pvps_01K86ZJ6PBXRXS7EXRMGS6ZDHJ	2025-10-22 22:10:20.490836+00	2025-10-22 22:25:33.57+00	2025-10-22 22:25:33.57+00
variant_01K86ZJ6JWJXQWVQADP924P8S4	pset_01K86ZJ6MQDEFHF3ZR98XXNNSJ	pvps_01K86ZJ6PB1075Y9R3WD0B4QQW	2025-10-22 22:10:20.490836+00	2025-10-22 22:25:33.57+00	2025-10-22 22:25:33.57+00
variant_01K86ZJ6JWXE1CD1T92ZW17F1B	pset_01K86ZJ6MRPGTC5TEVFT83115V	pvps_01K86ZJ6PBJ60KTGPGPA92DA4G	2025-10-22 22:10:20.490836+00	2025-10-22 22:25:33.57+00	2025-10-22 22:25:33.57+00
variant_01K86ZJ6JVKNDJV6CH5D210YBH	pset_01K86ZJ6MP029N2BG0VENR5HPT	pvps_01K86ZJ6PBQP1R336R2MQ80VKW	2025-10-22 22:10:20.490836+00	2025-10-22 22:25:36.624+00	2025-10-22 22:25:36.623+00
variant_01K8715YEEBBYSYN12E72298PN	pset_01K8715YFEAAMZXD4EYQEE50CK	pvps_01K8715YGC0MZK4Y34J1ETYFH9	2025-10-22 22:38:36.043858+00	2025-10-22 22:38:36.043858+00	\N
variant_01K8715YEEN15NDMPPJZ2WG9Y3	pset_01K8715YFFKEGCNSTEB9B2G8PP	pvps_01K8715YGCGHPVK263YEGBRXTX	2025-10-22 22:38:36.043858+00	2025-10-22 22:38:36.043858+00	\N
variant_01K8715YEE0R337AWX09TGQ872	pset_01K8715YFFQD16B3BY4D3H0V91	pvps_01K8715YGC8GQDDNDG3TR4H5MB	2025-10-22 22:38:36.043858+00	2025-10-22 22:38:36.043858+00	\N
variant_01K871H03PQHZJJ9G6GWKBYDWH	pset_01K871H04Q53PCW3DYVAR6S9DD	pvps_01K871H05P0RS4M7667X4WQWQG	2025-10-22 22:44:38.198406+00	2025-10-22 22:44:38.198406+00	\N
variant_01K871H03PKC4JQYWHHAA2H05X	pset_01K871H04RJW8SXXP1GBN472ZD	pvps_01K871H05P12HYHM8VDMMFHR5S	2025-10-22 22:44:38.198406+00	2025-10-22 22:44:38.198406+00	\N
variant_01K871H03PBQH2ZVBMRW8JMJPQ	pset_01K871H04RR1EMPYC3DXHR7GW6	pvps_01K871H05Q0DHZMW45Q4WCG67Y	2025-10-22 22:44:38.198406+00	2025-10-22 22:44:38.198406+00	\N
variant_01K870TZZV09PC2PE242D6E4W2	pset_01K870V00HZ96PYRPCAA70ND57	pvps_01K870V01BEXQB7YW6SKSGDV4W	2025-10-22 22:32:37.162228+00	2025-10-23 17:32:54.921+00	2025-10-23 17:32:54.919+00
variant_01K870TZZVN8SWS30YGKYAHCKC	pset_01K870V00HFMFE9JSECHEK9Y9M	pvps_01K870V01B3K9K0HYYB44STR2C	2025-10-22 22:32:37.162228+00	2025-10-23 17:32:54.921+00	2025-10-23 17:32:54.919+00
variant_01K870TZZWASEP00FVDM6P8N4T	pset_01K870V00HP9N248ZY8P5ZVPF4	pvps_01K870V01B6RJ7C13DA26TAT4S	2025-10-22 22:32:37.162228+00	2025-10-23 17:32:54.921+00	2025-10-23 17:32:54.919+00
variant_01K89286KS0GNR2XK3FV45AB1Q	pset_01K89286NQYEP2G07GA2P1TD6J	pvps_01K89286Q8ZHJJW5KKMCFJEVNF	2025-10-23 17:35:47.427237+00	2025-10-23 17:35:47.427237+00	\N
variant_01K89286KTRVMZ8TR8S29SH3ZD	pset_01K89286NRKFE8N60X5RNEFK6C	pvps_01K89286Q8FVPTWJWCGBKKY0TW	2025-10-23 17:35:47.427237+00	2025-10-23 17:35:47.427237+00	\N
variant_01K89286KT6QX09EWHY5AEX017	pset_01K89286NRGXFMF445AYGZSSB9	pvps_01K89286Q8SWZVY085EDZEPYA4	2025-10-23 17:35:47.427237+00	2025-10-23 17:35:47.427237+00	\N
variant_01K898RB4NBCPP4B9TG5QQZBB9	pset_01K898RB638YTGWVFQZ785N3J3	pvps_01K898RB7KYV840ASP8P5822CE	2025-10-23 19:29:27.794545+00	2025-10-23 19:29:27.794545+00	\N
variant_01K898RB4NCGRXR5X3B9HGFSN0	pset_01K898RB64R8DH1RJK15HNV7Z1	pvps_01K898RB7KEJEEK3EYHEXYMBB3	2025-10-23 19:29:27.794545+00	2025-10-23 19:29:27.794545+00	\N
variant_01K898RB4NDDRYHPP28QTHFH7W	pset_01K898RB640W8DK5DJWGN43151	pvps_01K898RB7K06QCS61C1NPYCGWZ	2025-10-23 19:29:27.794545+00	2025-10-23 19:29:27.794545+00	\N
variant_01K898RB4N2Y2NZJZ8245XEPN4	pset_01K898RB65KR7PEAXRKBD21D8S	pvps_01K898RB7K0S1EW6HKN6Y8ACJF	2025-10-23 19:29:27.794545+00	2025-10-23 19:29:27.794545+00	\N
variant_01K899Z59KXZ5GGQ020JJEZVBT	pset_01K899Z5ATB513GK66JBSG2FM1	pvps_01K899Z5DJK0YS8HTFEDW9XXD3	2025-10-23 19:50:39.793496+00	2025-10-23 19:50:39.793496+00	\N
variant_01K899Z59KSTDWBN54CBTHY8TT	pset_01K899Z5AVWQ91X9NK0F2X2AJW	pvps_01K899Z5DJW76W5R7ZNA3GPPBW	2025-10-23 19:50:39.793496+00	2025-10-23 19:50:39.793496+00	\N
variant_01K899Z59KMAK456D42GXDPNWC	pset_01K899Z5AWSYTG3C1HV3PKT19A	pvps_01K899Z5DJBQAPAYGKZ84GQPV7	2025-10-23 19:50:39.793496+00	2025-10-23 19:50:39.793496+00	\N
\.


--
-- TOC entry 6475 (class 0 OID 19871)
-- Dependencies: 244
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status, is_tax_inclusive) FROM stdin;
\.


--
-- TOC entry 6476 (class 0 OID 19886)
-- Dependencies: 245
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- TOC entry 6473 (class 0 OID 19846)
-- Dependencies: 242
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6474 (class 0 OID 19857)
-- Dependencies: 243
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code, attribute) FROM stdin;
\.


--
-- TOC entry 6482 (class 0 OID 20059)
-- Dependencies: 251
-- Data for Name: promotion_campaign_budget_usage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget_usage (id, attribute_value, used, budget_id, raw_used, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6478 (class 0 OID 19915)
-- Dependencies: 247
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- TOC entry 6477 (class 0 OID 19903)
-- Dependencies: 246
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6481 (class 0 OID 19936)
-- Dependencies: 250
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6547 (class 0 OID 21304)
-- Dependencies: 316
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01K86XDQD0ZAYJW87FXHHT968H	roko.martinic2@gmail.com	emailpass	authid_01K86XDQD1483ZENN6R8E1CRAM	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAZqSCgXiY37nPWf1EqqQz+sVKGB7ljFDkZ36ZMoSedLHRQ1FOaY+GNlcbPqtReYNf2OjBr1QE8wJpGLkv46CeoiwhWuXsaKquHOsxnu9qOZD"}	2025-10-22 21:32:56.61+00	2025-10-22 21:32:56.61+00	\N
\.


--
-- TOC entry 6578 (class 0 OID 21785)
-- Dependencies: 347
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01K86RGJF3XMXAK5T28R4GC6JX	sc_01K86RG9F20H7KT7BC6R0WD39V	pksc_01K86RGJFN23R74FK5WGHZEFH0	2025-10-22 20:07:06.997146+00	2025-10-22 20:07:06.997146+00	\N
\.


--
-- TOC entry 6512 (class 0 OID 20605)
-- Dependencies: 281
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- TOC entry 6514 (class 0 OID 20664)
-- Dependencies: 283
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at, code) FROM stdin;
refr_01K86RD5ANVVC3K3TX741PFP3Q	Shipping Issue	Refund due to lost, delayed, or misdelivered shipment	\N	2025-10-22 20:05:14.274053+00	2025-10-22 20:05:14.274053+00	\N	shipping_issue
refr_01K86RD5AN70YCN2RYS0ZFW44A	Customer Care Adjustment	Refund given as goodwill or compensation for inconvenience	\N	2025-10-22 20:05:14.274053+00	2025-10-22 20:05:14.274053+00	\N	customer_care_adjustment
refr_01K86RD5ANZM2G30Q7JYVNWDHT	Pricing Error	Refund to correct an overcharge, missing discount, or incorrect price	\N	2025-10-22 20:05:14.274053+00	2025-10-22 20:05:14.274053+00	\N	pricing_error
\.


--
-- TOC entry 6497 (class 0 OID 20391)
-- Dependencies: 266
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K86RGJ581AE11MHX8DSXWX1D	Europe	eur	\N	2025-10-22 20:07:06.677+00	2025-10-22 20:07:06.677+00	\N	t
\.


--
-- TOC entry 6498 (class 0 OID 20402)
-- Dependencies: 267
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-10-22 20:06:17.124+00	2025-10-22 20:06:17.124+00	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-10-22 20:06:17.126+00	2025-10-22 20:06:17.126+00	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
ca	can	124	CANADA	Canada	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cn	chn	156	CHINA	China	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-10-22 20:06:17.127+00	2025-10-22 20:06:17.127+00	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:06:17.128+00	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
in	ind	356	INDIA	India	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ml	mli	466	MALI	Mali	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:06:17.129+00	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
om	omn	512	OMAN	Oman	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pe	per	604	PERU	Peru	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:06:17.13+00	\N
dk	dnk	208	DENMARK	Denmark	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.128+00	2025-10-22 20:07:06.678+00	\N
fr	fra	250	FRANCE	France	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:07:06.678+00	\N
de	deu	276	GERMANY	Germany	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:07:06.677+00	\N
it	ita	380	ITALY	Italy	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.129+00	2025-10-22 20:07:06.678+00	\N
es	esp	724	SPAIN	Spain	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:07:06.678+00	\N
se	swe	752	SWEDEN	Sweden	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:07:06.678+00	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	reg_01K86RGJ581AE11MHX8DSXWX1D	\N	2025-10-22 20:06:17.13+00	2025-10-22 20:07:06.678+00	\N
\.


--
-- TOC entry 6579 (class 0 OID 21793)
-- Dependencies: 348
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01K86RGJ581AE11MHX8DSXWX1D	pp_system_default	regpp_01K86RGJ6PVRNMMWF4FQD78K3Z	2025-10-22 20:07:06.70958+00	2025-10-22 20:07:06.70958+00	\N
\.


--
-- TOC entry 6454 (class 0 OID 19216)
-- Dependencies: 223
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- TOC entry 6534 (class 0 OID 21022)
-- Dependencies: 303
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- TOC entry 6574 (class 0 OID 21745)
-- Dependencies: 343
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6535 (class 0 OID 21037)
-- Dependencies: 304
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- TOC entry 6532 (class 0 OID 20916)
-- Dependencies: 301
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6487 (class 0 OID 20161)
-- Dependencies: 256
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K86RG9F20H7KT7BC6R0WD39V	Default Sales Channel	Created by Medusa	f	\N	2025-10-22 20:06:57.763+00	2025-10-22 20:06:57.763+00	\N
\.


--
-- TOC entry 6580 (class 0 OID 21813)
-- Dependencies: 349
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01K86RG9F20H7KT7BC6R0WD39V	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	scloc_01K86RGJEMK40BCZ4RJ41HDKES	2025-10-22 20:07:06.964964+00	2025-10-22 20:07:06.964964+00	\N
\.


--
-- TOC entry 6586 (class 0 OID 21896)
-- Dependencies: 355
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-10-22 20:06:44.630108+00	2025-10-22 20:06:44.723339+00
2	migrate-tax-region-provider.js	2025-10-22 20:06:44.752078+00	2025-10-22 20:06:44.770746+00
\.


--
-- TOC entry 6553 (class 0 OID 21380)
-- Dependencies: 322
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01K86RGJ9SMC14D3E6S4C36GXJ	Europe	\N	fuset_01K86RGJ9SDK7TTBJPA65FHT5W	2025-10-22 20:07:06.811+00	2025-10-22 20:07:06.811+00	\N
\.


--
-- TOC entry 6557 (class 0 OID 21429)
-- Dependencies: 326
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01K86RGJC2GPKD4CQAMYNHC25M	Standard Shipping	flat	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	manual_manual	\N	\N	sotype_01K86RGJC10K8J3QXF79MDGSCW	2025-10-22 20:07:06.883+00	2025-10-22 20:07:06.883+00	\N
so_01K86RGJC3EMSPE03MZZCSXD4C	Express Shipping	flat	serzo_01K86RGJ9SMC14D3E6S4C36GXJ	sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	manual_manual	\N	\N	sotype_01K86RGJC2DFQSVQE0527W89MW	2025-10-22 20:07:06.884+00	2025-10-22 20:07:06.884+00	\N
\.


--
-- TOC entry 6581 (class 0 OID 21823)
-- Dependencies: 350
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01K86RGJC2GPKD4CQAMYNHC25M	pset_01K86RGJCV61DBNMTV9EA4SXKJ	sops_01K86RGJE7RF1NJ46T9T5GSSVK	2025-10-22 20:07:06.951487+00	2025-10-22 20:07:06.951487+00	\N
so_01K86RGJC3EMSPE03MZZCSXD4C	pset_01K86RGJCW479867NZWG1NGGJH	sops_01K86RGJE84396NFE488DBSG68	2025-10-22 20:07:06.951487+00	2025-10-22 20:07:06.951487+00	\N
\.


--
-- TOC entry 6558 (class 0 OID 21447)
-- Dependencies: 327
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01K86RGJC1PPHWQ5MQ73GDMMGF	enabled_in_store	eq	"true"	so_01K86RGJC2GPKD4CQAMYNHC25M	2025-10-22 20:07:06.884+00	2025-10-22 20:07:06.884+00	\N
sorul_01K86RGJC2B7NCTVC14AETVCSD	is_return	eq	"false"	so_01K86RGJC2GPKD4CQAMYNHC25M	2025-10-22 20:07:06.884+00	2025-10-22 20:07:06.884+00	\N
sorul_01K86RGJC2J500X7F82G3JKX2C	enabled_in_store	eq	"true"	so_01K86RGJC3EMSPE03MZZCSXD4C	2025-10-22 20:07:06.884+00	2025-10-22 20:07:06.884+00	\N
sorul_01K86RGJC2G8SCBD1WPQXXVY1N	is_return	eq	"false"	so_01K86RGJC3EMSPE03MZZCSXD4C	2025-10-22 20:07:06.884+00	2025-10-22 20:07:06.884+00	\N
\.


--
-- TOC entry 6555 (class 0 OID 21408)
-- Dependencies: 324
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01K86RGJC10K8J3QXF79MDGSCW	Standard	Ship in 2-3 days.	standard	2025-10-22 20:07:06.883+00	2025-10-22 20:07:06.883+00	\N
sotype_01K86RGJC2DFQSVQE0527W89MW	Express	Ship in 24 hours.	express	2025-10-22 20:07:06.884+00	2025-10-22 20:07:06.884+00	\N
\.


--
-- TOC entry 6556 (class 0 OID 21418)
-- Dependencies: 325
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01K86RFWQ9V1JDGG2JWBE5J1SQ	Default Shipping Profile	default	\N	2025-10-22 20:06:44.713+00	2025-10-22 20:06:44.713+00	\N
\.


--
-- TOC entry 6451 (class 0 OID 19165)
-- Dependencies: 220
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	2025-10-22 20:07:06.77+00	2025-10-22 20:07:06.77+00	\N	European Warehouse	laddr_01K86RGJ8HDPQMTRHK7EDY02XM	\N
\.


--
-- TOC entry 6450 (class 0 OID 19155)
-- Dependencies: 219
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K86RGJ8HDPQMTRHK7EDY02XM	2025-10-22 20:07:06.77+00	2025-10-22 20:07:06.77+00	\N		\N	\N	Copenhagen	DK	\N	\N	\N	\N
\.


--
-- TOC entry 6500 (class 0 OID 20435)
-- Dependencies: 269
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K86RG9FNPRH45WSDDF75MM22	Medusa Store	sc_01K86RG9F20H7KT7BC6R0WD39V	\N	sloc_01K86RGJ8JS8H3TYJSRAJXWKE9	\N	2025-10-22 20:06:57.77898+00	2025-10-22 20:06:57.77898+00	\N
\.


--
-- TOC entry 6501 (class 0 OID 20447)
-- Dependencies: 270
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K86RGJ4B3V7NW8NAKA864SAP	eur	t	store_01K86RG9FNPRH45WSDDF75MM22	2025-10-22 20:07:06.629183+00	2025-10-22 20:07:06.629183+00	\N
stocur_01K86RGJ4BPZ2329TDEHZ1AWN3	usd	f	store_01K86RG9FNPRH45WSDDF75MM22	2025-10-22 20:07:06.629183+00	2025-10-22 20:07:06.629183+00	\N
\.


--
-- TOC entry 6502 (class 0 OID 20464)
-- Dependencies: 271
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-10-22 20:06:17.258+00	2025-10-22 20:06:17.258+00	\N
\.


--
-- TOC entry 6504 (class 0 OID 20486)
-- Dependencies: 273
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- TOC entry 6505 (class 0 OID 20500)
-- Dependencies: 274
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- TOC entry 6503 (class 0 OID 20472)
-- Dependencies: 272
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01K86RGJ7Y4RRSRXPE44W2G84J	tp_system	gb	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
txreg_01K86RGJ7Y9QC23QXFGB20QXZF	tp_system	de	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
txreg_01K86RGJ7YAZD152QG4T2BQAQC	tp_system	dk	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
txreg_01K86RGJ7Y5Y0TMVDZXFDYC8MF	tp_system	se	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
txreg_01K86RGJ7Y3PB9HC103HMGYC38	tp_system	fr	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
txreg_01K86RGJ7ZS2966MK84YRVB3YF	tp_system	es	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
txreg_01K86RGJ7Z4H74HZHR4VD6E76X	tp_system	it	\N	\N	\N	2025-10-22 20:07:06.751+00	2025-10-22 20:07:06.751+00	\N	\N
\.


--
-- TOC entry 6549 (class 0 OID 21337)
-- Dependencies: 318
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01K86XDQG1305RPG7F26988VWY	Roko	Martinić	roko.martinic2@gmail.com	\N	\N	2025-10-22 21:32:56.706+00	2025-10-22 21:32:56.706+00	\N
\.


--
-- TOC entry 6544 (class 0 OID 21269)
-- Dependencies: 313
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_preference (id, user_id, key, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6545 (class 0 OID 21281)
-- Dependencies: 314
-- Data for Name: view_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_configuration (id, entity, name, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 6564 (class 0 OID 21619)
-- Dependencies: 333
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
\.


--
-- TOC entry 6600 (class 0 OID 0)
-- Dependencies: 334
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 18, true);


--
-- TOC entry 6601 (class 0 OID 0)
-- Dependencies: 217
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 132, true);


--
-- TOC entry 6602 (class 0 OID 0)
-- Dependencies: 290
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- TOC entry 6603 (class 0 OID 0)
-- Dependencies: 308
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- TOC entry 6604 (class 0 OID 0)
-- Dependencies: 286
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, false);


--
-- TOC entry 6605 (class 0 OID 0)
-- Dependencies: 305
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- TOC entry 6606 (class 0 OID 0)
-- Dependencies: 302
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- TOC entry 6607 (class 0 OID 0)
-- Dependencies: 354
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- TOC entry 5866 (class 2606 OID 20707)
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- TOC entry 5801 (class 2606 OID 20426)
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- TOC entry 5698 (class 2606 OID 19935)
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- TOC entry 5696 (class 2606 OID 19928)
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- TOC entry 6012 (class 2606 OID 21301)
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- TOC entry 5859 (class 2606 OID 20622)
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- TOC entry 5744 (class 2606 OID 20195)
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- TOC entry 5757 (class 2606 OID 20231)
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 5751 (class 2606 OID 20208)
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5763 (class 2606 OID 20242)
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 6214 (class 2606 OID 21879)
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- TOC entry 5741 (class 2606 OID 20180)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- TOC entry 6124 (class 2606 OID 21696)
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- TOC entry 5775 (class 2606 OID 20266)
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 5769 (class 2606 OID 20255)
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- TOC entry 5781 (class 2606 OID 20277)
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 5786 (class 2606 OID 20380)
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- TOC entry 5831 (class 2606 OID 20549)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- TOC entry 6208 (class 2606 OID 21866)
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- TOC entry 5719 (class 2606 OID 20104)
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- TOC entry 5729 (class 2606 OID 20126)
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- TOC entry 5724 (class 2606 OID 20116)
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- TOC entry 5713 (class 2606 OID 20093)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 6029 (class 2606 OID 21359)
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- TOC entry 6080 (class 2606 OID 21493)
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- TOC entry 6074 (class 2606 OID 21482)
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- TOC entry 6070 (class 2606 OID 21467)
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- TOC entry 6032 (class 2606 OID 21368)
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 6036 (class 2606 OID 21377)
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- TOC entry 6048 (class 2606 OID 21402)
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- TOC entry 5603 (class 2606 OID 19356)
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- TOC entry 5556 (class 2606 OID 19198)
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5563 (class 2606 OID 19212)
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- TOC entry 6022 (class 2606 OID 21333)
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- TOC entry 6104 (class 2606 OID 21656)
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6106 (class 2606 OID 21658)
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- TOC entry 6118 (class 2606 OID 21677)
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- TOC entry 6112 (class 2606 OID 21687)
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- TOC entry 5545 (class 2606 OID 19154)
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6089 (class 2606 OID 21601)
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- TOC entry 6083 (class 2606 OID 21593)
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 5870 (class 2606 OID 20730)
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- TOC entry 6130 (class 2606 OID 21698)
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- TOC entry 5905 (class 2606 OID 20810)
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- TOC entry 5896 (class 2606 OID 20795)
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- TOC entry 5994 (class 2606 OID 21130)
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- TOC entry 5990 (class 2606 OID 21118)
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5985 (class 2606 OID 21095)
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- TOC entry 5998 (class 2606 OID 21188)
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- TOC entry 5979 (class 2606 OID 21075)
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5974 (class 2606 OID 21062)
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- TOC entry 6136 (class 2606 OID 21726)
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- TOC entry 5912 (class 2606 OID 20822)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5934 (class 2606 OID 20870)
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 5928 (class 2606 OID 20849)
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5931 (class 2606 OID 20860)
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 6142 (class 2606 OID 21730)
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- TOC entry 5881 (class 2606 OID 20744)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 6148 (class 2606 OID 21743)
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- TOC entry 5940 (class 2606 OID 20891)
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 5937 (class 2606 OID 20881)
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- TOC entry 5943 (class 2606 OID 20901)
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 5923 (class 2606 OID 20834)
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- TOC entry 5885 (class 2606 OID 20783)
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- TOC entry 5952 (class 2606 OID 20912)
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 5839 (class 2606 OID 20584)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- TOC entry 5834 (class 2606 OID 20560)
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- TOC entry 5850 (class 2606 OID 20604)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- TOC entry 5837 (class 2606 OID 20577)
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 5843 (class 2606 OID 20595)
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- TOC entry 5650 (class 2606 OID 19703)
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- TOC entry 5656 (class 2606 OID 19712)
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 5636 (class 2606 OID 19627)
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- TOC entry 5660 (class 2606 OID 19808)
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- TOC entry 5646 (class 2606 OID 19658)
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 5630 (class 2606 OID 19617)
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- TOC entry 5621 (class 2606 OID 19404)
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- TOC entry 5625 (class 2606 OID 19428)
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- TOC entry 5616 (class 2606 OID 19389)
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- TOC entry 5590 (class 2606 OID 19334)
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- TOC entry 5595 (class 2606 OID 19345)
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- TOC entry 5576 (class 2606 OID 19303)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 6160 (class 2606 OID 21889)
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- TOC entry 6202 (class 2606 OID 21855)
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- TOC entry 5607 (class 2606 OID 19367)
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- TOC entry 5623 (class 2606 OID 19414)
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- TOC entry 5611 (class 2606 OID 19378)
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- TOC entry 6172 (class 2606 OID 21788)
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- TOC entry 5627 (class 2606 OID 19435)
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- TOC entry 5585 (class 2606 OID 19319)
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- TOC entry 6166 (class 2606 OID 21775)
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- TOC entry 5685 (class 2606 OID 19897)
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- TOC entry 5669 (class 2606 OID 19867)
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- TOC entry 5709 (class 2606 OID 20068)
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 5664 (class 2606 OID 19854)
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- TOC entry 5677 (class 2606 OID 19881)
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- TOC entry 5694 (class 2606 OID 19921)
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- TOC entry 5692 (class 2606 OID 19912)
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 5704 (class 2606 OID 19944)
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- TOC entry 6017 (class 2606 OID 21312)
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- TOC entry 6178 (class 2606 OID 21812)
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- TOC entry 5855 (class 2606 OID 20613)
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- TOC entry 5862 (class 2606 OID 20672)
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 5794 (class 2606 OID 20408)
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- TOC entry 6184 (class 2606 OID 21805)
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- TOC entry 5789 (class 2606 OID 20399)
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- TOC entry 5569 (class 2606 OID 19224)
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- TOC entry 6154 (class 2606 OID 21754)
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- TOC entry 5968 (class 2606 OID 21046)
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- TOC entry 5962 (class 2606 OID 21032)
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- TOC entry 5956 (class 2606 OID 20924)
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 5732 (class 2606 OID 20170)
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- TOC entry 6190 (class 2606 OID 21833)
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- TOC entry 6217 (class 2606 OID 21902)
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 6041 (class 2606 OID 21388)
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- TOC entry 6061 (class 2606 OID 21439)
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- TOC entry 6196 (class 2606 OID 21836)
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- TOC entry 6065 (class 2606 OID 21456)
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 6051 (class 2606 OID 21416)
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- TOC entry 6055 (class 2606 OID 21426)
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- TOC entry 5548 (class 2606 OID 19163)
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- TOC entry 5552 (class 2606 OID 19173)
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- TOC entry 5808 (class 2606 OID 20456)
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- TOC entry 5804 (class 2606 OID 20445)
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- TOC entry 5811 (class 2606 OID 20471)
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 5823 (class 2606 OID 20496)
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- TOC entry 5829 (class 2606 OID 20508)
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 5818 (class 2606 OID 20482)
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- TOC entry 6026 (class 2606 OID 21345)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 6003 (class 2606 OID 21277)
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (id);


--
-- TOC entry 6009 (class 2606 OID 21290)
-- Name: view_configuration view_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_configuration
    ADD CONSTRAINT view_configuration_pkey PRIMARY KEY (id);


--
-- TOC entry 6102 (class 2606 OID 21640)
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- TOC entry 5863 (class 1259 OID 20708)
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6203 (class 1259 OID 21872)
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5864 (class 1259 OID 20709)
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5752 (class 1259 OID 20232)
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5770 (class 1259 OID 20267)
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5795 (class 1259 OID 20432)
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5796 (class 1259 OID 20434)
-- Name: IDX_api_key_redacted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_redacted" ON public.api_key USING btree (redacted) WHERE (deleted_at IS NULL);


--
-- TOC entry 5797 (class 1259 OID 20433)
-- Name: IDX_api_key_revoked_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_revoked_at" ON public.api_key USING btree (revoked_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5798 (class 1259 OID 20427)
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- TOC entry 5799 (class 1259 OID 20430)
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- TOC entry 5678 (class 1259 OID 19900)
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- TOC entry 5679 (class 1259 OID 19899)
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- TOC entry 5680 (class 1259 OID 19898)
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- TOC entry 6010 (class 1259 OID 21322)
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5665 (class 1259 OID 19868)
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- TOC entry 5856 (class 1259 OID 20679)
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- TOC entry 5857 (class 1259 OID 20631)
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5742 (class 1259 OID 20311)
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5733 (class 1259 OID 20183)
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- TOC entry 5782 (class 1259 OID 20383)
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5734 (class 1259 OID 20186)
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- TOC entry 5735 (class 1259 OID 20181)
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- TOC entry 5736 (class 1259 OID 20310)
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6209 (class 1259 OID 21881)
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6125 (class 1259 OID 21704)
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6119 (class 1259 OID 21703)
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5753 (class 1259 OID 20312)
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5754 (class 1259 OID 20336)
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5745 (class 1259 OID 20330)
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5746 (class 1259 OID 20317)
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5758 (class 1259 OID 20314)
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5759 (class 1259 OID 20342)
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5737 (class 1259 OID 20184)
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- TOC entry 5738 (class 1259 OID 20185)
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- TOC entry 5739 (class 1259 OID 20182)
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- TOC entry 5771 (class 1259 OID 20313)
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5772 (class 1259 OID 20349)
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5764 (class 1259 OID 20348)
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5765 (class 1259 OID 20316)
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5776 (class 1259 OID 20315)
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5777 (class 1259 OID 20350)
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5617 (class 1259 OID 19405)
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- TOC entry 5612 (class 1259 OID 19390)
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- TOC entry 5783 (class 1259 OID 20381)
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5784 (class 1259 OID 20382)
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5714 (class 1259 OID 20105)
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- TOC entry 5715 (class 1259 OID 20147)
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5716 (class 1259 OID 20106)
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- TOC entry 5717 (class 1259 OID 20107)
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- TOC entry 5710 (class 1259 OID 20146)
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5711 (class 1259 OID 20144)
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- TOC entry 5725 (class 1259 OID 20159)
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5726 (class 1259 OID 20128)
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- TOC entry 5727 (class 1259 OID 20160)
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5720 (class 1259 OID 20148)
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5721 (class 1259 OID 20117)
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 5722 (class 1259 OID 20145)
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 6204 (class 1259 OID 21871)
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6173 (class 1259 OID 21832)
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- TOC entry 6113 (class 1259 OID 21686)
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- TOC entry 6149 (class 1259 OID 21758)
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- TOC entry 6210 (class 1259 OID 21883)
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- TOC entry 6126 (class 1259 OID 21706)
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- TOC entry 6143 (class 1259 OID 21867)
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- TOC entry 6120 (class 1259 OID 21708)
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- TOC entry 6107 (class 1259 OID 21718)
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- TOC entry 6131 (class 1259 OID 21742)
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- TOC entry 6197 (class 1259 OID 21862)
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- TOC entry 6167 (class 1259 OID 21808)
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- TOC entry 6179 (class 1259 OID 21815)
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- TOC entry 6155 (class 1259 OID 21893)
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- TOC entry 6185 (class 1259 OID 21841)
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- TOC entry 6161 (class 1259 OID 21786)
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- TOC entry 6205 (class 1259 OID 21873)
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- TOC entry 6191 (class 1259 OID 21843)
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- TOC entry 6137 (class 1259 OID 21773)
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- TOC entry 6027 (class 1259 OID 21360)
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6066 (class 1259 OID 21473)
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6150 (class 1259 OID 21757)
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6132 (class 1259 OID 21739)
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6075 (class 1259 OID 21497)
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6076 (class 1259 OID 21496)
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6077 (class 1259 OID 21495)
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6078 (class 1259 OID 21494)
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6071 (class 1259 OID 21484)
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6072 (class 1259 OID 21483)
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6067 (class 1259 OID 21470)
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6030 (class 1259 OID 21564)
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6114 (class 1259 OID 21681)
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6033 (class 1259 OID 21379)
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6108 (class 1259 OID 21710)
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6034 (class 1259 OID 21378)
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 6068 (class 1259 OID 21472)
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6042 (class 1259 OID 21405)
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- TOC entry 6043 (class 1259 OID 21403)
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 6044 (class 1259 OID 21407)
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6045 (class 1259 OID 21404)
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- TOC entry 6046 (class 1259 OID 21406)
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6174 (class 1259 OID 21814)
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- TOC entry 6115 (class 1259 OID 21678)
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- TOC entry 6151 (class 1259 OID 21755)
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- TOC entry 6211 (class 1259 OID 21880)
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- TOC entry 6127 (class 1259 OID 21699)
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- TOC entry 6144 (class 1259 OID 21744)
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- TOC entry 6121 (class 1259 OID 21700)
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- TOC entry 6109 (class 1259 OID 21702)
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- TOC entry 6133 (class 1259 OID 21727)
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- TOC entry 6198 (class 1259 OID 21859)
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- TOC entry 6168 (class 1259 OID 21800)
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- TOC entry 6180 (class 1259 OID 21807)
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- TOC entry 6156 (class 1259 OID 21890)
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- TOC entry 6186 (class 1259 OID 21834)
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- TOC entry 6162 (class 1259 OID 21776)
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- TOC entry 6206 (class 1259 OID 21870)
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- TOC entry 6192 (class 1259 OID 21838)
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- TOC entry 6138 (class 1259 OID 21737)
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- TOC entry 5596 (class 1259 OID 19535)
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5597 (class 1259 OID 19594)
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5553 (class 1259 OID 19199)
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6169 (class 1259 OID 21804)
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5554 (class 1259 OID 19287)
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- TOC entry 5557 (class 1259 OID 19213)
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5558 (class 1259 OID 19281)
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5559 (class 1259 OID 19286)
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5560 (class 1259 OID 19282)
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5561 (class 1259 OID 19291)
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6018 (class 1259 OID 21336)
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6019 (class 1259 OID 21349)
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 6020 (class 1259 OID 21335)
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- TOC entry 5755 (class 1259 OID 20233)
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- TOC entry 5747 (class 1259 OID 20219)
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5748 (class 1259 OID 20220)
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- TOC entry 5924 (class 1259 OID 21242)
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.order_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- TOC entry 5760 (class 1259 OID 20244)
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- TOC entry 5749 (class 1259 OID 20221)
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- TOC entry 6084 (class 1259 OID 21618)
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6085 (class 1259 OID 21614)
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- TOC entry 6081 (class 1259 OID 21617)
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6086 (class 1259 OID 21602)
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- TOC entry 6087 (class 1259 OID 21604)
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- TOC entry 5586 (class 1259 OID 19538)
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- TOC entry 5591 (class 1259 OID 19346)
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5867 (class 1259 OID 20731)
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- TOC entry 5868 (class 1259 OID 21179)
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5871 (class 1259 OID 21214)
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5897 (class 1259 OID 21225)
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5898 (class 1259 OID 21007)
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- TOC entry 5899 (class 1259 OID 21226)
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5900 (class 1259 OID 21222)
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5901 (class 1259 OID 21223)
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5902 (class 1259 OID 21227)
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering) WHERE (deleted_at IS NULL);


--
-- TOC entry 5903 (class 1259 OID 21224)
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5886 (class 1259 OID 20996)
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- TOC entry 5887 (class 1259 OID 21218)
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5888 (class 1259 OID 20997)
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- TOC entry 5889 (class 1259 OID 21219)
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5890 (class 1259 OID 21216)
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5891 (class 1259 OID 20797)
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- TOC entry 5892 (class 1259 OID 21217)
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5893 (class 1259 OID 21220)
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status) WHERE (deleted_at IS NULL);


--
-- TOC entry 5894 (class 1259 OID 21221)
-- Name: IDX_order_change_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_version" ON public.order_change USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5980 (class 1259 OID 21097)
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5981 (class 1259 OID 21229)
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5986 (class 1259 OID 21232)
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5987 (class 1259 OID 21119)
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5991 (class 1259 OID 21234)
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5992 (class 1259 OID 21132)
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5988 (class 1259 OID 21233)
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5982 (class 1259 OID 21230)
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5983 (class 1259 OID 21231)
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5995 (class 1259 OID 21190)
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5996 (class 1259 OID 21235)
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5872 (class 1259 OID 21212)
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 5873 (class 1259 OID 21210)
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5874 (class 1259 OID 20772)
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- TOC entry 5875 (class 1259 OID 21208)
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5969 (class 1259 OID 21064)
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5970 (class 1259 OID 21236)
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5975 (class 1259 OID 21076)
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5976 (class 1259 OID 21239)
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5977 (class 1259 OID 21240)
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5971 (class 1259 OID 21237)
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5972 (class 1259 OID 21238)
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 6128 (class 1259 OID 21701)
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6145 (class 1259 OID 21762)
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6134 (class 1259 OID 21733)
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6139 (class 1259 OID 21741)
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5876 (class 1259 OID 21215)
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- TOC entry 5906 (class 1259 OID 21172)
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5907 (class 1259 OID 21245)
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5908 (class 1259 OID 21244)
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5909 (class 1259 OID 20824)
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5910 (class 1259 OID 21246)
-- Name: IDX_order_item_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5932 (class 1259 OID 21139)
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5925 (class 1259 OID 21241)
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5929 (class 1259 OID 21138)
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5926 (class 1259 OID 21243)
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5877 (class 1259 OID 21209)
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5878 (class 1259 OID 21211)
-- Name: IDX_order_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_sales_channel_id" ON public."order" USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5879 (class 1259 OID 21213)
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5913 (class 1259 OID 21249)
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5914 (class 1259 OID 21174)
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5915 (class 1259 OID 21250)
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5916 (class 1259 OID 20837)
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5938 (class 1259 OID 21137)
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5935 (class 1259 OID 21133)
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5941 (class 1259 OID 21136)
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5917 (class 1259 OID 21247)
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5918 (class 1259 OID 20836)
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5919 (class 1259 OID 21248)
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5920 (class 1259 OID 21251)
-- Name: IDX_order_shipping_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_shipping_method_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5921 (class 1259 OID 21252)
-- Name: IDX_order_shipping_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5882 (class 1259 OID 21173)
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5883 (class 1259 OID 21228)
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5944 (class 1259 OID 21265)
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5945 (class 1259 OID 21268)
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 5946 (class 1259 OID 21266)
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5947 (class 1259 OID 21262)
-- Name: IDX_order_transaction_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id" ON public.order_transaction USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5948 (class 1259 OID 21263)
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 5949 (class 1259 OID 21267)
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5950 (class 1259 OID 21264)
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5832 (class 1259 OID 20628)
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6212 (class 1259 OID 21882)
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6140 (class 1259 OID 21752)
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5844 (class 1259 OID 20623)
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5845 (class 1259 OID 20624)
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5846 (class 1259 OID 20676)
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- TOC entry 5847 (class 1259 OID 20697)
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5835 (class 1259 OID 20683)
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5848 (class 1259 OID 20626)
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6181 (class 1259 OID 21811)
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5840 (class 1259 OID 20675)
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- TOC entry 5841 (class 1259 OID 20633)
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5631 (class 1259 OID 19788)
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 5632 (class 1259 OID 19748)
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5647 (class 1259 OID 19743)
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5648 (class 1259 OID 19842)
-- Name: IDX_price_list_id_status_starts_at_ends_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_id_status_starts_at_ends_at" ON public.price_list USING btree (id, status, starts_at, ends_at) WHERE ((deleted_at IS NULL) AND (status = 'active'::text));


--
-- TOC entry 5651 (class 1259 OID 19838)
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- TOC entry 5652 (class 1259 OID 19760)
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5653 (class 1259 OID 19759)
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5654 (class 1259 OID 19843)
-- Name: IDX_price_list_rule_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_value" ON public.price_list_rule USING gin (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5657 (class 1259 OID 19810)
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5658 (class 1259 OID 19809)
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5633 (class 1259 OID 19747)
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5634 (class 1259 OID 19745)
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5637 (class 1259 OID 19841)
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- TOC entry 5638 (class 1259 OID 19839)
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5639 (class 1259 OID 19844)
-- Name: IDX_price_rule_attribute_value_price_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute_value_price_id" ON public.price_rule USING btree (attribute, value, price_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5640 (class 1259 OID 19757)
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5641 (class 1259 OID 19813)
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- TOC entry 5642 (class 1259 OID 19840)
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5643 (class 1259 OID 19837)
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5644 (class 1259 OID 19814)
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- TOC entry 5628 (class 1259 OID 19744)
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6163 (class 1259 OID 21784)
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6193 (class 1259 OID 21842)
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5613 (class 1259 OID 19407)
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- TOC entry 5618 (class 1259 OID 19534)
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5619 (class 1259 OID 19406)
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- TOC entry 5614 (class 1259 OID 19391)
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- TOC entry 5570 (class 1259 OID 19306)
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5571 (class 1259 OID 19307)
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- TOC entry 5572 (class 1259 OID 19304)
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- TOC entry 6199 (class 1259 OID 21860)
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6157 (class 1259 OID 21891)
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5598 (class 1259 OID 19596)
-- Name: IDX_product_image_rank; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_rank" ON public.image USING btree (rank) WHERE (deleted_at IS NULL);


--
-- TOC entry 5599 (class 1259 OID 19598)
-- Name: IDX_product_image_rank_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_rank_product_id" ON public.image USING btree (rank, product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5600 (class 1259 OID 19357)
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- TOC entry 5601 (class 1259 OID 19597)
-- Name: IDX_product_image_url_rank_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url_rank_product_id" ON public.image USING btree (url, rank, product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5587 (class 1259 OID 19336)
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- TOC entry 5588 (class 1259 OID 19544)
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5592 (class 1259 OID 19347)
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- TOC entry 5593 (class 1259 OID 19545)
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5573 (class 1259 OID 19599)
-- Name: IDX_product_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_status" ON public.product USING btree (status) WHERE (deleted_at IS NULL);


--
-- TOC entry 5604 (class 1259 OID 19369)
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- TOC entry 5608 (class 1259 OID 19380)
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- TOC entry 5574 (class 1259 OID 19305)
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5577 (class 1259 OID 19323)
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- TOC entry 5578 (class 1259 OID 19325)
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- TOC entry 5579 (class 1259 OID 19320)
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- TOC entry 5580 (class 1259 OID 19595)
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5581 (class 1259 OID 19324)
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5582 (class 1259 OID 19322)
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- TOC entry 5583 (class 1259 OID 19321)
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- TOC entry 5681 (class 1259 OID 20002)
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5682 (class 1259 OID 20048)
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5683 (class 1259 OID 20056)
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5666 (class 1259 OID 20055)
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5667 (class 1259 OID 20011)
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5705 (class 1259 OID 20071)
-- Name: IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u" ON public.promotion_campaign_budget_usage USING btree (attribute_value, budget_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5706 (class 1259 OID 20069)
-- Name: IDX_promotion_campaign_budget_usage_budget_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_budget_id" ON public.promotion_campaign_budget_usage USING btree (budget_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5707 (class 1259 OID 20070)
-- Name: IDX_promotion_campaign_budget_usage_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_deleted_at" ON public.promotion_campaign_budget_usage USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5661 (class 1259 OID 20003)
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- TOC entry 5662 (class 1259 OID 20004)
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5670 (class 1259 OID 20012)
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5671 (class 1259 OID 20013)
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6146 (class 1259 OID 21782)
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6122 (class 1259 OID 21707)
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5672 (class 1259 OID 20079)
-- Name: IDX_promotion_is_automatic; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_is_automatic" ON public.promotion USING btree (is_automatic) WHERE (deleted_at IS NULL);


--
-- TOC entry 5686 (class 1259 OID 19913)
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- TOC entry 5687 (class 1259 OID 20078)
-- Name: IDX_promotion_rule_attribute_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute_operator" ON public.promotion_rule USING btree (attribute, operator) WHERE (deleted_at IS NULL);


--
-- TOC entry 5688 (class 1259 OID 20082)
-- Name: IDX_promotion_rule_attribute_operator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute_operator_id" ON public.promotion_rule USING btree (operator, attribute, id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5689 (class 1259 OID 20049)
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5690 (class 1259 OID 19914)
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- TOC entry 5699 (class 1259 OID 20051)
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5700 (class 1259 OID 20050)
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5701 (class 1259 OID 20080)
-- Name: IDX_promotion_rule_value_rule_id_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_rule_id_value" ON public.promotion_rule_value USING btree (promotion_rule_id, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5702 (class 1259 OID 20081)
-- Name: IDX_promotion_rule_value_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_value" ON public.promotion_rule_value USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5673 (class 1259 OID 20054)
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- TOC entry 5674 (class 1259 OID 19883)
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- TOC entry 6013 (class 1259 OID 21313)
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- TOC entry 6014 (class 1259 OID 21323)
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6015 (class 1259 OID 21314)
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- TOC entry 6175 (class 1259 OID 21821)
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5851 (class 1259 OID 20680)
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- TOC entry 5852 (class 1259 OID 20629)
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5860 (class 1259 OID 20695)
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5853 (class 1259 OID 20696)
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5790 (class 1259 OID 20418)
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5791 (class 1259 OID 20417)
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5792 (class 1259 OID 20409)
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- TOC entry 5787 (class 1259 OID 20401)
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6182 (class 1259 OID 21809)
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5564 (class 1259 OID 19226)
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5565 (class 1259 OID 19285)
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5566 (class 1259 OID 19283)
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5567 (class 1259 OID 19284)
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5957 (class 1259 OID 21256)
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5958 (class 1259 OID 21253)
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5959 (class 1259 OID 21255)
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 6152 (class 1259 OID 21756)
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5963 (class 1259 OID 21047)
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5964 (class 1259 OID 21258)
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5965 (class 1259 OID 21259)
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5966 (class 1259 OID 21257)
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5960 (class 1259 OID 21254)
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5953 (class 1259 OID 21261)
-- Name: IDX_return_reason_parent_return_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_reason_parent_return_reason_id" ON public.return_reason USING btree (parent_return_reason_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5954 (class 1259 OID 21260)
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5730 (class 1259 OID 20171)
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- TOC entry 6176 (class 1259 OID 21824)
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6158 (class 1259 OID 21892)
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6187 (class 1259 OID 21837)
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6037 (class 1259 OID 21391)
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6038 (class 1259 OID 21390)
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6039 (class 1259 OID 21389)
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 5773 (class 1259 OID 20268)
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- TOC entry 5766 (class 1259 OID 20256)
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5767 (class 1259 OID 20257)
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- TOC entry 5778 (class 1259 OID 20279)
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- TOC entry 6056 (class 1259 OID 21446)
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6194 (class 1259 OID 21840)
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6057 (class 1259 OID 21575)
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6062 (class 1259 OID 21458)
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6063 (class 1259 OID 21457)
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6058 (class 1259 OID 21442)
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6059 (class 1259 OID 21443)
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6049 (class 1259 OID 21417)
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6052 (class 1259 OID 21428)
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6200 (class 1259 OID 21861)
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6053 (class 1259 OID 21427)
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 5819 (class 1259 OID 20499)
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- TOC entry 5546 (class 1259 OID 19164)
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5549 (class 1259 OID 19188)
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5550 (class 1259 OID 19174)
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6116 (class 1259 OID 21679)
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6110 (class 1259 OID 21705)
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6188 (class 1259 OID 21839)
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5805 (class 1259 OID 20457)
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5806 (class 1259 OID 20463)
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5802 (class 1259 OID 20446)
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5605 (class 1259 OID 19368)
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5761 (class 1259 OID 20243)
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5779 (class 1259 OID 20278)
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5809 (class 1259 OID 20537)
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 5820 (class 1259 OID 20498)
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5824 (class 1259 OID 20511)
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5825 (class 1259 OID 20510)
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5826 (class 1259 OID 20509)
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5827 (class 1259 OID 20512)
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5821 (class 1259 OID 20497)
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5812 (class 1259 OID 20484)
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 5813 (class 1259 OID 20483)
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- TOC entry 5814 (class 1259 OID 20538)
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5815 (class 1259 OID 20534)
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- TOC entry 5816 (class 1259 OID 20533)
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 5609 (class 1259 OID 19379)
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 5675 (class 1259 OID 20057)
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- TOC entry 6023 (class 1259 OID 21347)
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 6024 (class 1259 OID 21350)
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 5999 (class 1259 OID 21278)
-- Name: IDX_user_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_preference_deleted_at" ON public.user_preference USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6000 (class 1259 OID 21280)
-- Name: IDX_user_preference_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_preference_user_id" ON public.user_preference USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6001 (class 1259 OID 21279)
-- Name: IDX_user_preference_user_id_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_preference_user_id_key_unique" ON public.user_preference USING btree (user_id, key) WHERE (deleted_at IS NULL);


--
-- TOC entry 6170 (class 1259 OID 21802)
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6164 (class 1259 OID 21778)
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6004 (class 1259 OID 21291)
-- Name: IDX_view_configuration_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_deleted_at" ON public.view_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6005 (class 1259 OID 21293)
-- Name: IDX_view_configuration_entity_is_system_default; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_entity_is_system_default" ON public.view_configuration USING btree (entity, is_system_default) WHERE (deleted_at IS NULL);


--
-- TOC entry 6006 (class 1259 OID 21292)
-- Name: IDX_view_configuration_entity_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_entity_user_id" ON public.view_configuration USING btree (entity, user_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6007 (class 1259 OID 21294)
-- Name: IDX_view_configuration_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_user_id" ON public.view_configuration USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6090 (class 1259 OID 21632)
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6091 (class 1259 OID 21633)
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6092 (class 1259 OID 21644)
-- Name: IDX_workflow_execution_retention_time_updated_at_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_retention_time_updated_at_state" ON public.workflow_execution USING btree (retention_time, updated_at, state) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL));


--
-- TOC entry 6093 (class 1259 OID 21641)
-- Name: IDX_workflow_execution_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_run_id" ON public.workflow_execution USING btree (run_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6094 (class 1259 OID 21636)
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- TOC entry 6095 (class 1259 OID 21643)
-- Name: IDX_workflow_execution_state_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state_updated_at" ON public.workflow_execution USING btree (state, updated_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 6096 (class 1259 OID 21635)
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6097 (class 1259 OID 21645)
-- Name: IDX_workflow_execution_updated_at_retention_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_updated_at_retention_time" ON public.workflow_execution USING btree (updated_at, retention_time) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL) AND ((state)::text = ANY ((ARRAY['done'::character varying, 'failed'::character varying, 'reverted'::character varying])::text[])));


--
-- TOC entry 6098 (class 1259 OID 21634)
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6099 (class 1259 OID 21642)
-- Name: IDX_workflow_execution_workflow_id_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id_transaction_id" ON public.workflow_execution USING btree (workflow_id, transaction_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6100 (class 1259 OID 21638)
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 6215 (class 1259 OID 21903)
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- TOC entry 6266 (class 2606 OID 20528)
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- TOC entry 6265 (class 2606 OID 20523)
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- TOC entry 6263 (class 2606 OID 20518)
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- TOC entry 6264 (class 2606 OID 20513)
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- TOC entry 6245 (class 2606 OID 19981)
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6246 (class 2606 OID 19986)
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6243 (class 2606 OID 19971)
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6244 (class 2606 OID 19976)
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6272 (class 2606 OID 20654)
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6252 (class 2606 OID 20214)
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6255 (class 2606 OID 20331)
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6254 (class 2606 OID 20325)
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6256 (class 2606 OID 20337)
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6253 (class 2606 OID 20209)
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6258 (class 2606 OID 20300)
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6257 (class 2606 OID 20343)
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6259 (class 2606 OID 20305)
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6260 (class 2606 OID 20384)
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- TOC entry 6249 (class 2606 OID 20129)
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6250 (class 2606 OID 20149)
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6251 (class 2606 OID 20154)
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6297 (class 2606 OID 21581)
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6301 (class 2606 OID 21553)
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6300 (class 2606 OID 21548)
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6298 (class 2606 OID 21576)
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6299 (class 2606 OID 21538)
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6291 (class 2606 OID 21503)
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6226 (class 2606 OID 19529)
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6219 (class 2606 OID 19230)
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6302 (class 2606 OID 21605)
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6273 (class 2606 OID 20936)
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6277 (class 2606 OID 20946)
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6276 (class 2606 OID 20941)
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6288 (class 2606 OID 21203)
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6278 (class 2606 OID 20956)
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6279 (class 2606 OID 20951)
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6283 (class 2606 OID 20971)
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6282 (class 2606 OID 20966)
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6281 (class 2606 OID 20961)
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6274 (class 2606 OID 20931)
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6284 (class 2606 OID 20981)
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6285 (class 2606 OID 20986)
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6280 (class 2606 OID 20976)
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6275 (class 2606 OID 21197)
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6286 (class 2606 OID 20991)
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6267 (class 2606 OID 20710)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6268 (class 2606 OID 20715)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6270 (class 2606 OID 20690)
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6269 (class 2606 OID 20685)
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6237 (class 2606 OID 19778)
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6234 (class 2606 OID 19763)
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6235 (class 2606 OID 19659)
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6236 (class 2606 OID 19789)
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6227 (class 2606 OID 19501)
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6230 (class 2606 OID 19496)
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6231 (class 2606 OID 19491)
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6221 (class 2606 OID 19436)
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6224 (class 2606 OID 19539)
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6225 (class 2606 OID 19456)
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6228 (class 2606 OID 19481)
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6229 (class 2606 OID 19486)
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6222 (class 2606 OID 19441)
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6232 (class 2606 OID 19466)
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6233 (class 2606 OID 19461)
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6223 (class 2606 OID 19446)
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6240 (class 2606 OID 19956)
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6238 (class 2606 OID 20005)
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6248 (class 2606 OID 20072)
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_budget_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_budget_id_foreign FOREIGN KEY (budget_id) REFERENCES public.promotion_campaign_budget(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6239 (class 2606 OID 19996)
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6241 (class 2606 OID 19961)
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6242 (class 2606 OID 19966)
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6247 (class 2606 OID 19991)
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6289 (class 2606 OID 21315)
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6271 (class 2606 OID 20659)
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6261 (class 2606 OID 20410)
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6220 (class 2606 OID 19235)
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6287 (class 2606 OID 20925)
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- TOC entry 6290 (class 2606 OID 21498)
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6292 (class 2606 OID 21565)
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6296 (class 2606 OID 21528)
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6293 (class 2606 OID 21508)
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6294 (class 2606 OID 21570)
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- TOC entry 6295 (class 2606 OID 21513)
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 6218 (class 2606 OID 19180)
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 6262 (class 2606 OID 20458)
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2025-10-27 01:06:06

--
-- PostgreSQL database dump complete
--

\unrestrict CjKgsMnelJP45EbAZgO21NbxzyjkKeBXhZhTCJRUsZ4cp9clXZWU3VinxfKH0Tb

