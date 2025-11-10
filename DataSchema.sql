/*
  Фізична схема БД PostgreSQL
  Трансформація логічної моделі в SQL-скрипт.
  Назви ключів відповідають вимогам (використання суфікса _id).
*/

-- =================================================================
-- 1. Створення Таблиць (CREATE TABLE)
-- Використовуємо SERIAL для автоінкрементних PK
-- =================================================================

CREATE TABLE Role (
    role_id     SERIAL,             -- Первинний ключ
    name        VARCHAR(100)        -- Унікальна назва ролі
);

CREATE TABLE "user" (
    user_id     SERIAL,             -- Первинний ключ
    login       VARCHAR(50),
    name        VARCHAR(150),
    email       VARCHAR(255),
    phone       VARCHAR(20),
    role_id     INTEGER             -- Зовнішній ключ до Role
);

CREATE TABLE Project (
    project_id  SERIAL,             -- Первинний ключ
    name        VARCHAR(255),
    description TEXT,               -- Детальний опис (може бути великим)
    manager_id  INTEGER             -- Зовнішній ключ до "user" (Project Manager)
);

CREATE TABLE Task (
    task_id     SERIAL,             -- Первинний ключ
    description TEXT,
    project_id  INTEGER             -- Зовнішній ключ до Project
);

-- =================================================================
-- 2. Створення Проміжних Таблиць (Багато-до-Багатьох)
-- =================================================================

CREATE TABLE Project_Crew (
    user_id     INTEGER,            -- FK до "user"
    project_id  INTEGER             -- FK до Project
);

CREATE TABLE Task_Assignment (
    user_id     INTEGER,            -- FK до "user"
    task_id     INTEGER             -- FK до Task
);


/* Команди обмеження цілісності даних */

-- =================================================================
-- 3. Обмеження Первинного Ключа (PRIMARY KEY)
-- =================================================================

ALTER TABLE Role
    ADD CONSTRAINT role_pk PRIMARY KEY (role_id);

ALTER TABLE "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (user_id);

ALTER TABLE Project
    ADD CONSTRAINT project_pk PRIMARY KEY (project_id);

ALTER TABLE Task
    ADD CONSTRAINT task_pk PRIMARY KEY (task_id);

-- Обмеження складених первинних ключів для проміжних таблиць
ALTER TABLE Project_Crew
    ADD CONSTRAINT project_crew_pk PRIMARY KEY (user_id, project_id);

ALTER TABLE Task_Assignment
    ADD CONSTRAINT task_assignment_pk PRIMARY KEY (user_id, task_id);


-- =================================================================
-- 4. Обмеження Унікальності та NOT NULL (Згідно Словника Атрибутів)
-- =================================================================

ALTER TABLE Role
    ALTER COLUMN name SET NOT NULL,
    ADD CONSTRAINT role_name_unique UNIQUE (name);

ALTER TABLE "user"
    ALTER COLUMN login SET NOT NULL,
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN role_id SET NOT NULL,
    ADD CONSTRAINT user_login_unique UNIQUE (login),
    ADD CONSTRAINT user_email_unique UNIQUE (email);

ALTER TABLE Project
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN manager_id SET NOT NULL,
    ADD CONSTRAINT project_name_unique UNIQUE (name);

ALTER TABLE Task
    ALTER COLUMN description SET NOT NULL,
    ALTER COLUMN project_id SET NOT NULL;


-- =================================================================
-- 5. Обмеження Зовнішнього Ключа (FOREIGN KEY)
-- =================================================================

-- Зв'язок: Користувач -- Роль
ALTER TABLE "user"
    ADD CONSTRAINT user_role_fk FOREIGN KEY (role_id) REFERENCES Role (role_id);

-- Зв'язок: Проєкт -- Менеджер (Користувач)
ALTER TABLE Project
    ADD CONSTRAINT project_manager_fk FOREIGN KEY (manager_id) REFERENCES "user" (user_id);

-- Зв'язок: Завдання -- Проєкт
ALTER TABLE Task
    ADD CONSTRAINT task_project_fk FOREIGN KEY (project_id) REFERENCES Project (project_id);

-- Зв'язок: Project_Crew -- Користувач
ALTER TABLE Project_Crew
    ADD CONSTRAINT pc_user_fk FOREIGN KEY (user_id) REFERENCES "user" (user_id);

-- Зв'язок: Project_Crew -- Проєкт
ALTER TABLE Project_Crew
    ADD CONSTRAINT pc_project_fk FOREIGN KEY (project_id) REFERENCES Project (project_id);

-- Зв'язок: Task_Assignment -- Користувач
ALTER TABLE Task_Assignment
    ADD CONSTRAINT ta_user_fk FOREIGN KEY (user_id) REFERENCES "user" (user_id);

-- Зв'язок: Task_Assignment -- Завдання
ALTER TABLE Task_Assignment
    ADD CONSTRAINT ta_task_fk FOREIGN KEY (task_id) REFERENCES Task (task_id);


-- =================================================================
-- 6. Обмеження Змісту Атрибутів (CHECK/Регулярні вирази)
-- =================================================================

-- Обмеження для email: Перевірка коректного формату email (вимога завдання)
ALTER TABLE "user"
    ADD CONSTRAINT user_email_format
    CHECK ( email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$' );

-- Обмеження для phone: Перевірка формату телефону (наприклад: +380501234567 або 0501234567)
ALTER TABLE "user"
    ADD CONSTRAINT user_phone_format
    CHECK ( phone IS NULL OR phone ~ '^\+?(\d{2})?\d{10}$' );
    
-- Обмеження для login: Перевірка, що login містить лише літери, цифри та підкреслення (для безпеки)
ALTER TABLE "user"
    ADD CONSTRAINT user_login_characters
    CHECK ( login ~ '^[a-zA-Z0-9_]{3,}$' );