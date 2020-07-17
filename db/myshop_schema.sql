-- Category
CREATE TABLE category (
    id bigint NOT NULL,
    displayname character varying(255),
    name character varying(255) NOT NULL,
    parent_id bigint
);

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY category
    ADD CONSTRAINT category_name_ukey UNIQUE (name);

ALTER TABLE ONLY category
    ADD CONSTRAINT category_parent_fkey FOREIGN KEY (parent_id) REFERENCES category(id);

CREATE SEQUENCE category_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Product
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

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_ukey UNIQUE (code);    

ALTER TABLE ONLY product
    ADD CONSTRAINT product_category_fkey FOREIGN KEY (category_id) REFERENCES category(id);

CREATE SEQUENCE product_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE property (
    id bigint NOT NULL,
    displayname character varying(255),
    name character varying(255) NOT NULL
);

ALTER TABLE ONLY property
    ADD CONSTRAINT property_pkey PRIMARY KEY (id);

ALTER TABLE ONLY property
    ADD CONSTRAINT property_name_ukey UNIQUE (name);

CREATE TABLE property_value (
    id bigint NOT NULL,
    displayname character varying(255),
    name character varying(255) NOT NULL,
    property_id bigint
);

ALTER TABLE ONLY property_value
    ADD CONSTRAINT property_value_pkey PRIMARY KEY (id);

ALTER TABLE ONLY property_value
    ADD CONSTRAINT property_value_name_ukey UNIQUE (name);

ALTER TABLE ONLY property_value
    ADD CONSTRAINT property_value_property_fkey FOREIGN KEY (property_id) REFERENCES property(id);    

CREATE TABLE category_property (
    category_id bigint NOT NULL,
    properties_id bigint NOT NULL
);

ALTER TABLE ONLY category_property
    ADD CONSTRAINT category_property_pkey PRIMARY KEY (category_id, properties_id);

ALTER TABLE ONLY category_property
    ADD CONSTRAINT category_property_fkey FOREIGN KEY (properties_id) REFERENCES property(id);

CREATE TABLE product_property_value (
    product_id bigint NOT NULL,
    property_value_id bigint NOT NULL
);

ALTER TABLE ONLY product_property_value
    ADD CONSTRAINT product_property_value_pkey PRIMARY KEY (product_id, property_value_id);

ALTER TABLE ONLY product_property_value
    ADD CONSTRAINT product_property_value_property_value_fkey FOREIGN KEY (property_value_id) REFERENCES property_value(id);

ALTER TABLE ONLY product_property_value
    ADD CONSTRAINT product_property_value_product_fkey FOREIGN KEY (product_id) REFERENCES product(id);

--User
CREATE TABLE users (
    id bigint NOT NULL,
    access_token character varying(255),
    email character varying(255),
    expiresin integer,
    firstname character varying(255),
    lastname character varying(255)
);

ALTER TABLE ONLY users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);

CREATE SEQUENCE users_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE user_roles (
    user_id bigint NOT NULL,
    user_role character varying(255)
);

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_user_fkey FOREIGN KEY (user_id) REFERENCES users(id);