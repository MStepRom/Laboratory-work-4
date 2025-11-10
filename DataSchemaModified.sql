CREATE TABLE Roles (
    Role_id SERIAL,
    Role_name VARCHAR(100)
);

CREATE TABLE Users (
    User_id SERIAL,
    User_login VARCHAR(50),
    User_name VARCHAR(150),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Role_id INTEGER
);

CREATE TABLE Projects (
    Project_id SERIAL,
    Project_name VARCHAR(255),
    Description TEXT,
    Manager_id INTEGER
);

CREATE TABLE Tasks (
    Task_id SERIAL,
    Description TEXT,
    Project_id INTEGER
);

CREATE TABLE Project_crew (
    User_id INTEGER,
    Project_id INTEGER
);

CREATE TABLE Task_assignment (
    User_id INTEGER,
    Task_id INTEGER
);

ALTER TABLE Roles
ADD CONSTRAINT Role_pk PRIMARY KEY (Role_id);

ALTER TABLE Users
ADD CONSTRAINT User_pk PRIMARY KEY (User_id);

ALTER TABLE Projects
ADD CONSTRAINT Project_pk PRIMARY KEY (Project_id);

ALTER TABLE Tasks
ADD CONSTRAINT Task_pk PRIMARY KEY (Task_id);

ALTER TABLE Project_crew
ADD CONSTRAINT Project_crew_pk PRIMARY KEY (User_id, Project_id);

ALTER TABLE Task_assignment
ADD CONSTRAINT Task_assignment_pk PRIMARY KEY (User_id, Task_id);

ALTER TABLE Roles
ALTER COLUMN Role_name SET NOT NULL,
ADD CONSTRAINT Role_name_unique UNIQUE (Role_name);

ALTER TABLE Users
ALTER COLUMN User_login SET NOT NULL,
ALTER COLUMN User_name SET NOT NULL,
ALTER COLUMN Email SET NOT NULL,
ALTER COLUMN Role_id SET NOT NULL,
ADD CONSTRAINT User_login_unique UNIQUE (User_login),
ADD CONSTRAINT User_email_unique UNIQUE (Email);

ALTER TABLE Projects
ALTER COLUMN Project_name SET NOT NULL,
ALTER COLUMN Manager_id SET NOT NULL,
ADD CONSTRAINT Project_name_unique UNIQUE (Project_name);

ALTER TABLE Tasks
ALTER COLUMN Description SET NOT NULL,
ALTER COLUMN Project_id SET NOT NULL;

ALTER TABLE Users
ADD CONSTRAINT User_role_fk FOREIGN KEY (Role_id) REFERENCES Roles (Role_id);

ALTER TABLE Projects
ADD CONSTRAINT Project_manager_fk FOREIGN KEY (Manager_id) REFERENCES Users (
    User_id
);

ALTER TABLE Tasks
ADD CONSTRAINT Task_project_fk FOREIGN KEY (Project_id) REFERENCES Projects (
    Project_id
);

ALTER TABLE Project_crew
ADD CONSTRAINT Pc_user_fk FOREIGN KEY (User_id) REFERENCES Users (User_id);

ALTER TABLE Project_crew
ADD CONSTRAINT Pc_project_fk FOREIGN KEY (Project_id) REFERENCES Projects (
    Project_id
);

ALTER TABLE Task_assignment
ADD CONSTRAINT Ta_user_fk FOREIGN KEY (User_id) REFERENCES Users (User_id);

ALTER TABLE Task_assignment
ADD CONSTRAINT Ta_task_fk FOREIGN KEY (Task_id) REFERENCES Tasks (Task_id);

ALTER TABLE Users
ADD CONSTRAINT User_email_format
CHECK (Email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

ALTER TABLE Users
ADD CONSTRAINT User_phone_format
CHECK (Phone IS NULL OR Phone ~ '^\+?(\d{2})?\d{10}$');

ALTER TABLE Users
ADD CONSTRAINT User_login_characters
CHECK (User_login ~ '^[a-zA-Z0-9_]{3,}$');
