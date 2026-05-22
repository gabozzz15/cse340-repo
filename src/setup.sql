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