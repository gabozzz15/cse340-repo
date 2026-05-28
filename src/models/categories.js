import db from './db.js';


const getAllCategories = async () => {
    const query = `
        SELECT category_id, name
        FROM category
        ORDER BY name ASC
    `;

    const result = await db.query(query);
    return result.rows;
};


const getCategoryDetails = async (categoryId) => {
    const query = `
        SELECT category_id, name
        FROM category
        WHERE category_id = $1;
    `;

    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);
    return result.rows.length > 0 ? result.rows[0] : null;
};

const getCategoriesByProjectId = async (projectId) => {
    const query = `
        SELECT c.category_id, c.name
        FROM category c
        INNER JOIN project_category pc ON c.category_id = pc.category_id
        WHERE pc.project_id = $1
        ORDER BY c.name ASC;
    `;

    const queryParams = [projectId];
    const result = await db.query(query, queryParams);
    return result.rows;
};

const getProjectsByCategoryId = async (categoryId) => {
    const query = `
        SELECT
            p.project_id,
            p.title,
            p.description,
            p.project_date,
            p.location,
            p.organization_id,
            o.name AS organization_name
        FROM project p
        INNER JOIN project_category pc ON p.project_id = pc.project_id
        INNER JOIN organization o ON p.organization_id = o.organization_id
        WHERE pc.category_id = $1
        ORDER BY p.project_date ASC;
    `;

    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);
    return result.rows;
};


export { getAllCategories, getCategoryDetails, getCategoriesByProjectId, getProjectsByCategoryId };