# Subjects Database Implementation
# Change Log Entry
# Date: 2026-05-20

## Summary
Created comprehensive database specification for managing academic subjects with user ownership and access control.

## Changes Made

### New Files Created

1. **openspec/specs/subjects_database.yaml**
   - Complete database specification for subjects management
   - Defines two tables: `subjects` and `subject_permissions`
   - Includes 17 fields for subjects with proper constraints and validation
   - Includes 7 fields for permissions with fine-grained access control
   - Documents API endpoints (future implementation)
   - Documents automations for auto-completion and permission expiration
   - Includes authentication and authorization rules
   - Defines data validation requirements
   - Migration path from basic setup to full automation

2. **openspec/specs/subjects_implementation.yaml**
   - Xano-specific implementation guide
   - Detailed column definitions with types and constraints
   - Xano table configuration syntax
   - Business logic functions (can_access_subject, get_user_subjects, etc.)
   - Xano workflows for future automations
   - Complete API endpoint specifications with request/response examples
   - Deployment checklist
   - Comprehensive testing scenarios

## Features Implemented (Design Phase)

### Subjects Table
- **Core Fields**: id, user_id, name, code, description
- **Academic Info**: professor_name, professor_email, semester, credits, workload_hours
- **Dates**: start_date, end_date with validation
- **Management**: status (active/completed/archived/cancelled), color for UI, notes
- **Metadata**: created_at, updated_at timestamps

### Permissions Table
- **Ownership & Access**: subject_id, user_id, permission_type (owner/editor/viewer/commenter)
- **Audit Trail**: granted_by, created_at, expires_at (for temporary permissions)
- **Constraints**: Unique (subject_id, user_id) to prevent duplicate permissions

### Authorization Rules
1. User can only see/manage subjects they own or have explicit permissions for
2. Only owner can delete a subject
3. Owner can grant/revoke permissions to other users
4. Explicit permission levels: owner, editor, viewer, commenter

### API Design
- RESTful CRUD endpoints for subjects
- Filter and sort capabilities (by status, semester, dates, etc.)
- Search functionality (name, code, professor)
- Permission management endpoints
- Pagination support
- Comprehensive error handling

### Future Automations
- Auto-archive subjects when end_date passes
- Permission expiration handling
- Notifications for status changes
- Audit logging

## Technical Details

### Database Design
- UUIDs for all primary and foreign keys
- Proper indexing for common queries
- Foreign key constraints with cascade deletes
- Unique constraints to prevent duplicates
- Data type validation (email, hex color, date ranges)

### Validation Rules
- Required fields: id, user_id, name, created_at, updated_at
- Max lengths: name (255), code (50), email (255), semester (50)
- Constraints: workload_hours >= 0, credits >= 0
- Date validation: start_date <= end_date
- Enum validation for status and permission_type

### Security
- JWT-based authentication required for all API endpoints
- User isolation: Can only access own subjects
- Fine-grained permissions for collaboration
- No public endpoints without authentication

## Integration Points

### With Users Table
- Each subject has user_id foreign key
- Cascade delete when user is deleted
- Permissions table also references users

### With Future Features
- Tasks will reference subjects
- Grades will be associated with subjects
- Files/materials will be attached to subjects
- Categories/tags can organize subjects

## Next Steps

1. **Database Setup** (In Xano)
   - Create `subjects` table with all columns
   - Create `subject_permissions` table
   - Set up indexes and constraints
   - Create foreign key relationships

2. **Backend Implementation** (In Xano)
   - Implement authorization functions
   - Create API endpoints
   - Add input validation
   - Add error handling and logging

3. **Frontend Integration** (In Streamlit)
   - Update "Disciplinas" page to call API
   - Implement create/edit/delete forms
   - Show subject list with filters
   - Add permission management UI

4. **Testing**
   - Unit tests for validation functions
   - Integration tests for API endpoints
   - Authorization tests
   - End-to-end tests

5. **Documentation**
   - API documentation (Swagger/OpenAPI)
   - User guide for subject management
   - Admin guide for permissions

## Status
✅ Design complete - ready for implementation in Xano

## Related Issues
- Enables user management of academic subjects
- Foundation for task management
- Foundation for grades management
- Prerequisite for collaboration features

## Notes
- All timestamps in UTC
- Soft deletes not used (physical deletion with cascades)
- Row-level security enforced at API level
- Future consideration: Add categories/tags for better organization
