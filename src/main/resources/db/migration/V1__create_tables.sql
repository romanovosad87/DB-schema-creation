CREATE TYPE PHONE_TYPE as ENUM ('home', 'work', 'mobile');

CREATE TYPE ROLE as ENUM ('associate', 'partner', 'senior');

CREATE TYPE STATUS as ENUM ('new', 'assigned', 'on_hold',
    'approved', 'canceled', 'declined');

CREATE TABLE users
(
    id               bigserial
        constraint PK_users PRIMARY KEY,
    email            text not null
        constraint UQ_users_email UNIQUE ,
    cognito_username text not null
        constraint UQ_users_cognito_username UNIQUE
);

CREATE TABLE advisors
(
    id   bigserial
        constraint PK_advisors_id PRIMARY KEY,
    role ROLE not null,
    constraint advisor_users_fk FOREIGN KEY (id)
        REFERENCES users (id)
);

CREATE TABLE applicants
(
    id         bigserial
        constraint PK_applicants PRIMARY KEY,
    first_name text not null,
    last_name  text not null,
    ssn        int  not null
        constraint UQ_applicants_ssn UNIQUE,
    constraint applicants_users_fk FOREIGN KEY (id)
        REFERENCES users (id)
);

CREATE TABLE numbers
(
    id           bigserial
        constraint PK_numbers PRIMARY KEY,
    number       text       not null,
    type         PHONE_TYPE not null,
    applicant_id bigserial  not null,
    constraint numbers_applicants_fk FOREIGN KEY (applicant_id)
        references applicants (id)
);

CREATE TABLE addresses
(
    id     bigserial
        constraint PK_addresses PRIMARY KEY,
    city   text not null,
    street text not null,
    number text not null,
    zip    int  not null,
    apt    int,
    constraint addresses_applicants_fk FOREIGN KEY (id)
        references applicants (id)
);

CREATE TABLE applications
(
    id           bigserial
        constraint PK_applications PRIMARY KEY,
    amount_money money     not null,
    status       STATUS    not null,
    created_at   timestamp not null default now(),
    assigned_at  timestamp,
    applicant_id bigserial not null,
    advisor_id   bigserial,
    constraint applications_applicants_fk FOREIGN KEY (applicant_id)
        references applicants (id),
    constraint applications_advisors_fk FOREIGN KEY (advisor_id)
        references advisors (id)
);