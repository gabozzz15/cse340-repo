import db from './db.js';


const getAllProjects = async () => {
    const query = `
        SELECT 
            p.project_id,
            p.title,
            p.description,
            p.location,
            p.project_date,
            p.organization_id,
            o.name as organization_name,
            o.logo_filename as organization_logo
        FROM project p
        INNER JOIN organization o ON p.organization_id = o.organization_id
        ORDER BY p.project_date ASC
    `;

    const result = await db.query(query);
    return result.rows;
};


const getProjectsByOrganizationId = async (organizationId) => {
    const query = `
        SELECT
          project_id,
          organization_id,
          title,
          description,
          location,
          project_date
        FROM project
        WHERE organization_id = $1
        ORDER BY project_date;
      `;

    const queryParams = [organizationId];
    const result = await db.query(query, queryParams);

    return result.rows;
};

// Export the model functions
export { getAllProjects, getProjectsByOrganizationId };