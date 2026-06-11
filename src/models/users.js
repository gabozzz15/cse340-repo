import db from './db.js';
import bcrypt from 'bcrypt';

/**
 * Creates a new user in the database.
 * @param {string} name - The user's full name.
 * @param {string} email - The user's email address (used as username).
 * @param {string} passwordHash - The bcrypt-hashed password.
 * @returns {number} The id of the newly created user record.
 */
const createUser = async (name, email, passwordHash) => {
    // Retrieve the role_id for the "user" role
    const roleResult = await db.query(
        `SELECT role_id FROM roles WHERE role_name = 'user'`
    );

    if (roleResult.rows.length === 0) {
        throw new Error("Default 'user' role not found in the database.");
    }

    const roleId = roleResult.rows[0].role_id;

    const query = `
        INSERT INTO users (name, email, password_hash, role_id)
        VALUES ($1, $2, $3, $4)
        RETURNING user_id
    `;

    const queryParams = [name, email, passwordHash, roleId];
    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        throw new Error('Failed to create user');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Created new user with ID:', result.rows[0].user_id);
    }

    return result.rows[0].user_id;
};

/**
 * Finds a user in the database by their email address.
 * @param {string} email - The user's email address.
 * @returns {object|null} The user row, or null if not found.
 */
const findUserByEmail = async (email) => {
    const query = `
        SELECT u.user_id, u.name, u.email, u.password_hash, r.role_name 
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        WHERE u.email = $1
    `;
    const queryParams = [email];

    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        return null; // User not found
    }

    return result.rows[0];
};

/**
 * Checks whether a plain-text password matches a bcrypt hash.
 * @param {string} password - The plain-text password submitted by the user.
 * @param {string} passwordHash - The stored bcrypt hash.
 * @returns {boolean} True if they match, false otherwise.
 */
const verifyPassword = async (password, passwordHash) => {
    return bcrypt.compare(password, passwordHash);
};

/**
 * Authenticates a user by email and password.
 * Returns the user object (without password_hash) on success, or null on failure.
 * @param {string} email
 * @param {string} password
 * @returns {object|null}
 */
const authenticateUser = async (email, password) => {
    const user = await findUserByEmail(email);

    if (!user) {
        return null; // No user with that email
    }

    const passwordMatches = await verifyPassword(password, user.password_hash);

    if (!passwordMatches) {
        return null; // Wrong password
    }

    // Remove the password hash before returning the user object
    delete user.password_hash;
    return user;
};

const getAllUsers = async () => {
    const query = `
        SELECT u.user_id, u.name, u.email, r.role_name
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        ORDER BY u.name ASC;
    `;
    const result = await db.query(query);
    return result.rows;
};

export { createUser, authenticateUser, getAllUsers };

