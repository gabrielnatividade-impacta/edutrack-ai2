# Subjects Database - Executive Summary

**Project:** EduTrack AI  
**Component:** Subjects Database  
**Status:** ✅ Specification Complete - Ready for Implementation  
**Date:** May 20, 2026  
**Author:** Gabriel Moreira da Natividade

---

## Overview

A comprehensive database specification has been created to enable users to register, organize, and manage their academic subjects (disciplinas) with:
- User ownership and access control
- Fine-grained permission system for future collaboration
- Rich metadata for academic information
- Structured for automation and integrations

---

## What Has Been Created

### 📋 Documentation Files

1. **subjects_database.yaml** - Complete functional specification
   - Database table definitions (subjects & subject_permissions)
   - 17 fields for subjects with validation rules
   - Access control and authorization model
   - API endpoint specifications (future)
   - Automation requirements
   - Migration path

2. **subjects_implementation.yaml** - Technical implementation guide
   - Xano table configuration with field types
   - Business logic functions (5 core functions)
   - API endpoint specifications with examples
   - Request/response formats
   - Error handling patterns
   - Testing checklist

3. **subjects_schema.sql** - PostgreSQL DDL scripts
   - Complete CREATE TABLE statements
   - Index definitions for performance
   - Foreign key constraints with cascades
   - 3 core functions (can_access_subject, get_user_subjects, auto_complete)
   - 2 automation functions (auto_complete, expire_permissions)
   - Data validation functions
   - Sample views for common access patterns
   - Query examples

4. **subjects_examples.json** - Sample data and API examples
   - 5 sample subjects with realistic data
   - 2 sample permissions
   - 10 API call examples (create, read, list, update, delete, permissions)
   - Error response examples
   - 5 common database queries

5. **subjects_database_20260520.md** - Change log entry
   - Summary of all changes
   - Feature list
   - Integration points
   - Next steps and deployment checklist

6. **system.md** - Updated system context
   - Documented Subjects as core entity
   - Authorization rules
   - Features overview
   - Evolution roadmap

---

## Database Structure

### Subjects Table
```
17 Fields Total:
- Core: id, user_id, name, code, description
- Academic: professor_name, professor_email, semester, credits, workload_hours
- Schedule: start_date, end_date
- Status: status (active/completed/archived/cancelled)
- Organization: color (for UI), notes
- Metadata: created_at, updated_at
```

**Key Properties:**
- Each subject belongs to exactly one user (owner)
- Unique constraint: (user_id, code) - prevents duplicate codes per user
- Date validation: start_date ≤ end_date
- Status tracking for lifecycle management
- Color customization for visual organization

### Subject Permissions Table
```
7 Fields Total:
- Core: id, subject_id, user_id
- Access: permission_type (owner/editor/viewer/commenter)
- Audit: granted_by, created_at, expires_at
```

**Key Properties:**
- Unique constraint: (subject_id, user_id) - one permission per user per subject
- Expiring permissions (optional expires_at field)
- Permission hierarchy for access control
- Full audit trail of who granted what permission when

---

## Authorization Model

### Permission Levels
1. **Owner** - Full control (create, read, update, delete, manage permissions)
2. **Editor** - Can modify subject details and content
3. **Commenter** - Can leave comments (future feature)
4. **Viewer** - Read-only access

### Access Rules
- User always has access to subjects they own
- For other subjects, check subject_permissions table
- Permission can have expiration date
- Expired permissions are automatically cleaned up by scheduled task

---

## API Design (Ready for Xano Implementation)

### Subject Management
- `POST /api/subjects` - Create
- `GET /api/subjects` - List with filters
- `GET /api/subjects/:id` - Get single
- `PUT /api/subjects/:id` - Update
- `DELETE /api/subjects/:id` - Delete (owner only)

### Permission Management
- `GET /api/subjects/:id/permissions` - List
- `POST /api/subjects/:id/permissions` - Grant
- `DELETE /api/subjects/:id/permissions/:user_id` - Revoke

### Features
- Filtering by status, semester, search query
- Sorting by dates, name
- Pagination (limit/offset)
- Consistent error responses with codes

---

## Key Features

✅ **User Ownership**
- Each subject has a clear owner (user_id)
- Owner has full control and responsibility

✅ **Access Control**
- Fine-grained permissions system
- Support for collaboration (future)
- Expiring permissions for temporary access

✅ **Rich Metadata**
- Academic information (credits, workload, semester)
- Professor contact information
- Flexible scheduling (start/end dates)
- Custom colors for UI organization
- Notes and description fields

✅ **Data Integrity**
- Foreign key constraints with cascades
- Unique constraints to prevent duplicates
- Date validation (start ≤ end)
- Email and color format validation
- Type safety for all fields

✅ **Query Performance**
- Indexes on frequently queried fields (user_id, status, dates)
- Optimized database functions for common operations
- View definitions for simplified access patterns

✅ **Automation Ready**
- Auto-complete subjects when end_date passes
- Auto-expire permissions when expires_at reached
- Extensible for future automations

---

## Data Validation

### Required Fields
- id (UUID, auto-generated)
- user_id (UUID, must exist in users table)
- name (string, max 255 chars)
- created_at (timestamp, auto-generated)
- updated_at (timestamp, auto-updated)

### Validated Fields
- professor_email: Must be valid email format (if provided)
- color: Must be valid hex format #RRGGBB (if provided)
- credits: Must be ≥ 0 (if provided)
- workload_hours: Must be ≥ 0 (if provided)
- start_date, end_date: start_date ≤ end_date (if both provided)

### Optional Fields
Most fields are optional, allowing flexible subject creation:
- Can create minimal subject (just name)
- Can update with additional details later
- All date fields optional for ongoing subjects

---

## Technology Stack

- **Database**: PostgreSQL (DDL scripts provided)
- **Backend**: Xano (configuration guide provided)
- **Frontend**: Streamlit (ready for integration)
- **API Format**: REST with JSON
- **Authentication**: JWT (Xano native)

---

## Integration Points

### With Users Table
- Foreign key: subjects.user_id → users.id
- Cascade delete: Deleting user deletes their subjects
- Permissions also reference users table

### With Future Features
- **Tasks**: Will reference subjects via subject_id
- **Grades**: Will track grades per subject
- **Files**: Study materials attached to subjects
- **Notifications**: Alert users on subject changes
- **Analytics**: Track performance by subject

### With Frontend (Streamlit)
- Replace placeholder "Disciplinas" page
- Call API endpoints to list/create/edit subjects
- Show subject list with filters
- Edit form with all metadata fields
- Permission management UI

---

## Deployment Checklist

### Phase 1: Database Setup
- [ ] Create subjects table in Xano
- [ ] Create subject_permissions table
- [ ] Create all indexes
- [ ] Set up foreign key relationships
- [ ] Test database connectivity

### Phase 2: Backend Implementation
- [ ] Implement can_access_subject function
- [ ] Implement get_user_subjects function
- [ ] Create all API endpoints
- [ ] Add authentication middleware
- [ ] Add input validation
- [ ] Add error handling

### Phase 3: Testing
- [ ] Unit tests for validation functions
- [ ] Integration tests for API endpoints
- [ ] Authorization tests
- [ ] End-to-end tests
- [ ] Performance tests with sample data

### Phase 4: Frontend Integration
- [ ] Update Streamlit app with API calls
- [ ] Create subject list view
- [ ] Create create/edit/delete forms
- [ ] Add permission management UI
- [ ] Add filters and search

### Phase 5: Operations
- [ ] Set up monitoring and alerts
- [ ] Set up automated backups
- [ ] Schedule automation tasks
- [ ] Document API (Swagger/OpenAPI)
- [ ] Create user documentation

---

## Performance Considerations

### Indexes
- user_id: For fast filtering of user's subjects
- status: For filtering active/completed/archived
- created_at, updated_at: For sorting by date
- start_date, end_date: For date range queries
- permission_type: For permission filtering
- expires_at: For finding expired permissions

### Query Optimization
- Database functions use efficient SQL
- Views provide pre-calculated access patterns
- Pagination built into list endpoints
- Connection pooling recommended

### Scalability
- Supports millions of subjects per database
- Millions of permissions across all users
- Horizontal scaling via read replicas for queries
- Sharding by user_id possible if needed

---

## Security

### Authentication
- JWT tokens required for all API endpoints
- Token validates user identity
- Token contains user_id claim

### Authorization
- Row-level security: Users see only their own data
- Permission-based access: Check subject_permissions table
- Field-level security: Some fields may be read-only for non-owners
- Audit trail: Track who granted/revoked permissions

### Data Protection
- Foreign key constraints prevent orphaned data
- Cascade deletes ensure data consistency
- Soft deletes not used (physical deletion only)
- All timestamps in UTC

---

## Documentation Provided

| File | Purpose | Audience |
|------|---------|----------|
| subjects_database.yaml | Functional specification | Product, Design |
| subjects_implementation.yaml | Technical implementation | Backend developers |
| subjects_schema.sql | DDL scripts | Database admin |
| subjects_examples.json | Sample data & API examples | QA, Developers |
| subjects_database_20260520.md | Change log | Project tracking |
| system.md | System context | All team members |

---

## Next Actions

1. **For Backend Team:**
   - Review subjects_implementation.yaml
   - Set up Xano tables based on DDL
   - Implement API endpoints
   - Run tests against examples

2. **For Frontend Team:**
   - Review subjects_examples.json for API contract
   - Update Streamlit "Disciplinas" page
   - Implement create/edit/delete forms
   - Add filters and search

3. **For DevOps/DBA:**
   - Review subjects_schema.sql
   - Set up database in staging environment
   - Configure backups and monitoring
   - Plan migration strategy

4. **For QA:**
   - Review testing scenarios in subjects_implementation.yaml
   - Use examples from subjects_examples.json
   - Create test cases for all endpoints
   - Test authorization scenarios

---

## Success Criteria

✅ Users can create subjects with their own information  
✅ Users can only see subjects they own or have permission for  
✅ Only owners can delete subjects  
✅ Owners can share subjects with other users  
✅ Permissions can expire automatically  
✅ All API endpoints have proper error handling  
✅ Data integrity constraints are enforced  
✅ Performance is acceptable with 1000+ subjects  

---

## Questions & Support

For questions about this specification, refer to:
- **Database design**: subjects_database.yaml
- **Implementation details**: subjects_implementation.yaml
- **SQL scripts**: subjects_schema.sql
- **API examples**: subjects_examples.json
- **Project tracking**: subjects_database_20260520.md

All documents are cross-referenced and complete.

---

**Status**: ✅ Ready for Implementation  
**Owner**: Gabriel Moreira da Natividade  
**Last Updated**: May 20, 2026
