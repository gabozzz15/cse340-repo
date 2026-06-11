CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES 
    ('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure...', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
    ('GreenHarvest Growers', 'An urban farming collective promoting food sustainability...', 'contact@greenharvest.org', 'greenharvest-logo.png'),
    ('UnityServe Volunteers', 'A volunteer coordination group supporting local charities...', 'hello@unityserve.org', 'unityserve-logo.png');

SELECT * FROM organization;

CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    project_date DATE NOT NULL,
    CONSTRAINT fk_organization
        FOREIGN KEY (organization_id) 
        REFERENCES organization(organization_id)
        ON DELETE CASCADE
);

INSERT INTO project (organization_id, title, description, location, project_date)
VALUES 
    (1, 'Community Park Cleanup', 'Help clean and beautify the downtown community park.', 'Central Park, Main St', '2025-06-15'),
    (1, 'School Playground Repair', 'Fix and paint playground equipment at Jefferson Elementary.', 'Jefferson Elementary School', '2025-06-22'),
    (1, 'Senior Center Garden', 'Build raised garden beds for senior residents.', 'Valley Senior Center', '2025-07-05'),
    (1, 'Affordable Housing Build', 'Assist in constructing new affordable housing units.', 'Oakwood Avenue Site', '2025-07-12'),
    (1, 'Community Center Roof Repair', 'Help repair the roof at the local community center.', 'Eastside Community Center', '2025-07-20');

INSERT INTO project (organization_id, title, description, location, project_date)
VALUES 
    (2, 'Urban Farm Planting Day', 'Plant vegetables at the downtown urban farm.', 'Downtown Urban Farm', '2025-06-18'),
    (2, 'Farmers Market Setup', 'Help set up tents and tables for weekly farmers market.', 'City Plaza', '2025-06-25'),
    (2, 'Compost Workshop', 'Teach community members about composting at home.', 'GreenHouse Learning Center', '2025-07-02'),
    (2, 'School Garden Building', 'Build raised garden beds at middle school.', 'Washington Middle School', '2025-07-09'),
    (2, 'Harvest Festival', 'Help organize annual harvest celebration event.', 'Riverside Park', '2025-08-16');

INSERT INTO project (organization_id, title, description, location, project_date)
VALUES 
    (3, 'Food Bank Sorting', 'Sort and package food donations for distribution.', 'Community Food Bank', '2025-06-20'),
    (3, 'Clothing Drive', 'Collect and organize winter clothing donations.', 'UnityServe Warehouse', '2025-06-27'),
    (3, 'Literacy Tutoring', 'Tutor elementary students in reading.', 'Public Library', '2025-07-03'),
    (3, 'Senior Meal Delivery', 'Deliver meals to homebound seniors.', 'Various locations', '2025-07-10'),
    (3, 'Homeless Shelter Service', 'Serve meals at the downtown homeless shelter.', 'Hope Shelter', '2025-07-17');

SELECT 
    p.project_id,
    p.title,
    p.description,
    p.location,
    p.project_date,
    o.name as organization_name
FROM project p
JOIN organization o ON p.organization_id = o.organization_id
ORDER BY p.project_date;


CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, category_id),
    FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

INSERT INTO category (name) VALUES 
    ('Environment'),
    ('Children & Youth'),
    ('Food Security'),
    ('Education'),
    ('Elderly Services'),
    ('Community Development'),
    ('Homeless Support'),
    ('Health & Wellness');


-- BrightFuture Builders Projects (IDs 1-5)
INSERT INTO project_category (project_id, category_id) VALUES 
    (1, 1),
    (2, 2), (2, 7),
    (3, 5), (3, 1),
    (4, 7),
    (5, 7)
ON CONFLICT (project_id, category_id) DO NOTHING;

-- GreenHarvest Growers Projects (IDs 6-10)
INSERT INTO project_category (project_id, category_id) VALUES 
    (6, 1), (6, 3),
    (7, 3), (7, 7),
    (8, 1), (8, 4),
    (9, 2), (9, 1), (9, 4),
    (10, 3), (10, 7)
ON CONFLICT (project_id, category_id) DO NOTHING;

-- UnityServe Volunteers Projects (IDs 11-15)
INSERT INTO project_category (project_id, category_id) VALUES 
    (11, 3),
    (12, 6), (12, 7),
    (13, 4), (13, 2),
    (14, 5), (14, 3),
    (15, 6), (15, 3)
ON CONFLICT (project_id, category_id) DO NOTHING;

--UPDATING PROJECTS DATE TO MAKE UPCOMING PROJECTS FUNCTION ON WEB
UPDATE project 
SET project_date = '2026-12-15' 
WHERE organization_id = 1 AND title = 'Community Center Roof Repair';

UPDATE project 
SET project_date = '2027-01-20' 
WHERE organization_id = 1 AND title = 'Affordable Housing Build';

UPDATE project 
SET project_date = '2026-11-25' 
WHERE organization_id = 2 AND title = 'Farmers Market Setup';

UPDATE project 
SET project_date = '2026-12-05' 
WHERE organization_id = 2 AND title = 'Harvest Festival';

UPDATE project 
SET project_date = '2027-02-10' 
WHERE organization_id = 3 AND title = 'Senior Meal Delivery';

UPDATE project 
SET project_date = '2027-03-15' 
WHERE organization_id = 3 AND title = 'Homeless Shelter Service';


CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

INSERT INTO roles (role_name, role_description) VALUES 
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

SELECT * FROM roles;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);