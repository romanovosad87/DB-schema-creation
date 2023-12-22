CREATE TYPE PHONE_TYPE as ENUM ('home', 'work', 'mobile');

CREATE TYPE ROLE as ENUM ('associate', 'partner', 'senior');

CREATE TYPE STATUS as ENUM ('new', 'assigned', 'on_hold',
    'approved', 'canceled', 'declined');

CREATE TABLE users
(
    id               bigserial
        constraint PK_users PRIMARY KEY,
    email            varchar(255) not null
        constraint UQ_users_email UNIQUE,
    cognito_username varchar(255) not null
        constraint UQ_users_cognito_username UNIQUE,
    constraint email_format_check CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE advisors
(
    id   bigint
        constraint PK_advisors_id PRIMARY KEY,
    role ROLE not null,
    constraint advisor_users_fk FOREIGN KEY (id)
        references users (id)
);

CREATE TABLE applicants
(
    id         bigint
        constraint PK_applicants PRIMARY KEY,
    first_name varchar(255) not null,
    last_name  varchar(255) not null,
    ssn        int          not null
        constraint UQ_applicants_ssn UNIQUE,
    constraint applicants_users_fk FOREIGN KEY (id)
        references users (id)
);

CREATE TABLE numbers
(
    id           bigserial
        constraint PK_numbers PRIMARY KEY,
    number       varchar(20) not null,
    type         PHONE_TYPE  not null,
    applicant_id bigint      not null,
    constraint numbers_applicants_fk FOREIGN KEY (applicant_id)
        references applicants (id) on DELETE CASCADE
);

CREATE TABLE addresses
(
    id       bigserial
        constraint PK_addresses PRIMARY KEY,
    city     varchar(255) not null,
    street   varchar(255) not null,
    "number" varchar(10)  not null,
    zip      int          not null,
    apt      varchar(10),
    constraint addresses_applicants_fk FOREIGN KEY (id)
        references applicants (id) on DELETE CASCADE
);

CREATE TABLE applications
(
    id           bigserial
        constraint PK_applications PRIMARY KEY,
    amount_money money     not null,
    "status"     STATUS    not null default 'new',
    created_at   timestamp not null default now(),
    assigned_at  timestamp null,
    applicant_id bigint    not null,
    advisor_id   bigint    null,
    constraint applications_applicants_fk FOREIGN KEY (applicant_id)
        references applicants (id) on DELETE RESTRICT,
    constraint applications_advisors_fk FOREIGN KEY (advisor_id)
        references advisors (id) on DELETE RESTRICT,
    constraint validate_assigned_at CHECK ((assigned_at IS NULL AND advisor_id IS NULL AND "status" = 'new') OR
                                           (advisor_id IS NOT NULL AND "status" != 'new'))
);