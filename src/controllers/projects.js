import { getUpcomingProjects, getProjectDetails, createProject, updateProject, addVolunteerToProject, removeVolunteerFromProject, isUserVolunteeringForProject } from '../models/projects.js';
import { getCategoriesByProjectId } from '../models/categories.js';
import { getAllOrganizations } from '../models/organizations.js';
import { body, validationResult } from 'express-validator';

// Number of upcoming projects to display on the projects page
const NUMBER_OF_UPCOMING_PROJECTS = 5;

// Define validation rules for the new project form
const projectValidation = [
    body('title')
        .trim()
        .notEmpty().withMessage('Title is required')
        .isLength({ min: 3, max: 200 }).withMessage('Title must be between 3 and 200 characters'),
    body('description')
        .trim()
        .notEmpty().withMessage('Description is required')
        .isLength({ max: 1000 }).withMessage('Description must be less than 1000 characters'),
    body('location')
        .trim()
        .notEmpty().withMessage('Location is required')
        .isLength({ max: 200 }).withMessage('Location must be less than 200 characters'),
    body('date')
        .notEmpty().withMessage('Date is required')
        .isISO8601().withMessage('Date must be a valid date format'),
    body('organizationId')
        .notEmpty().withMessage('Organization is required')
        .isInt().withMessage('Organization must be a valid integer')
];

// Define any controller functions
const showProjectsPage = async (req, res) => {
    const projects = await getUpcomingProjects(NUMBER_OF_UPCOMING_PROJECTS);
    const title = 'Upcoming Service Projects';

    res.render('projects', { title, projects });
};

const showProjectDetailsPage = async (req, res) => {
    const projectId = req.params.id;
    const project = await getProjectDetails(projectId);
    const categories = await getCategoriesByProjectId(projectId);
    
    let isVolunteering = false;
    if (req.session && req.session.user) {
        isVolunteering = await isUserVolunteeringForProject(projectId, req.session.user.user_id);
    }
    
    const title = project ? project.title : 'Project Details';

    res.render('project', { title, project, categories, isVolunteering });
};

const showNewProjectForm = async (req, res) => {
    const organizations = await getAllOrganizations();
    const title = 'Add New Service Project';

    res.render('new-project', { title, organizations });
};

const processNewProjectForm = async (req, res) => {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        errors.array().forEach((error) => {
            req.flash('error', error.msg);
        });
        return res.redirect('/new-project');
    }

    const { title, description, location, date, organizationId } = req.body;

    try {
        const newProjectId = await createProject(title, description, location, date, organizationId);
        req.flash('success', 'New service project created successfully!');
        res.redirect(`/project/${newProjectId}`);
    } catch (error) {
        console.error('Error creating new project:', error);
        req.flash('error', 'There was an error creating the service project.');
        res.redirect('/new-project');
    }
};

const showEditProjectForm = async (req, res) => {
    const projectId = req.params.id;
    const projectDetails = await getProjectDetails(projectId);
    const organizations = await getAllOrganizations();
    const title = 'Edit Service Project';

    res.render('edit-project', { title, projectDetails, organizations });
};

const processEditProjectForm = async (req, res) => {
    const projectId = req.params.id;

    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        errors.array().forEach((error) => {
            req.flash('error', error.msg);
        });
        return res.redirect(`/edit-project/${projectId}`);
    }

    const { title, description, location, date, organizationId } = req.body;

    try {
        await updateProject(projectId, title, description, location, date, organizationId);
        req.flash('success', 'Service project updated successfully!');
        res.redirect(`/project/${projectId}`);
    } catch (error) {
        console.error('Error updating project:', error);
        req.flash('error', 'There was an error updating the service project.');
        res.redirect(`/edit-project/${projectId}`);
    }
};

// Export any controller functions
const volunteerForProject = async (req, res) => {
    const projectId = req.params.id;
    const userId = req.session.user.user_id;

    try {
        await addVolunteerToProject(projectId, userId);
        req.flash('success', 'You have volunteered for this project successfully!');
        res.redirect(`/project/${projectId}`);
    } catch (error) {
        console.error('Error volunteering for project:', error);
        req.flash('error', 'There was an error volunteering for this project.');
        res.redirect(`/project/${projectId}`);
    }
};

const removeVolunteering = async (req, res) => {
    const projectId = req.params.id;
    const userId = req.session.user.user_id;

    try {
        await removeVolunteerFromProject(projectId, userId);
        req.flash('success', 'You are no longer volunteering for this project.');
        res.redirect(req.header('Referer') || '/dashboard');
    } catch (error) {
        console.error('Error removing volunteering:', error);
        req.flash('error', 'There was an error removing your volunteering.');
        res.redirect(req.header('Referer') || '/dashboard');
    }
};

export { showProjectsPage, showProjectDetailsPage, showNewProjectForm, processNewProjectForm, showEditProjectForm, processEditProjectForm, volunteerForProject, removeVolunteering, projectValidation };


