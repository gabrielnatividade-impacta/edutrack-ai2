# Subjects Database - Cross-Reference & Navigation Guide

This guide helps you find information across the Subjects Database specification documents.

---

## Quick Navigation Map

```
SUBJECTS DATABASE SPECIFICATION
├── 📄 SUBJECTS_SUMMARY.md (Executive Overview)
│   ├── What was created
│   ├── Feature overview
│   ├── Database structure overview
│   ├── Deployment checklist
│   └── Success criteria
│
├── 📋 specs/subjects_database.yaml (Functional Specification)
│   ├── Detailed table definitions
│   ├── All fields with descriptions
│   ├── Constraints and validation rules
│   ├── API endpoint list (future)
│   ├── Automations (future)
│   ├── Authentication & authorization rules
│   └── Migration path
│
├── 🔧 specs/subjects_implementation.yaml (Technical Guide)
│   ├── Xano table configuration (exact syntax)
│   ├── Column type mappings
│   ├── Business logic functions
│   ├── Xano workflows
│   ├── API endpoint specifications (with request/response)
│   ├── Deployment checklist
│   └── Testing scenarios
│
├── 💾 specs/subjects_schema.sql (Database Script)
│   ├── CREATE TABLE statements
│   ├── Index definitions
│   ├── Constraint definitions
│   ├── Functions (5 business logic)
│   ├── Triggers (update timestamp)
│   ├── Optional audit table
│   ├── Views (3 pre-built)
│   └── Sample queries
│
├── 📊 specs/subjects_examples.json (Sample Data & Examples)
│   ├── Sample users (3)
│   ├── Sample subjects (5 with real data)
│   ├── Sample permissions (2)
│   ├── API examples (10 complete requests/responses)
│   ├── Error response examples
│   └── SQL query examples (5)
│
├── 📝 changes/subjects_database_20260520.md (Change Log)
│   ├── Summary of changes
│   ├── Files created
│   ├── Features implemented
│   ├── Technical details
│   ├── Integration points
│   ├── Next steps
│   └── Related issues
│
└── 📚 context/system.md (Updated System Context)
    ├── Core entities
    ├── Relationships
    ├── Subjects features
    ├── Authorization rules
    └── Evolution roadmap
```

---

## Finding Information by Topic

### 🗄️ DATABASE DESIGN

**Question**: What are the table structures?
- **Answer**: subjects_database.yaml → "Database Tables" section
- **Details**: subjects_schema.sql → CREATE TABLE statements
- **Implementation**: subjects_implementation.yaml → "Xano Table Configuration"

**Question**: What fields does subjects table have?
- **Answer**: subjects_database.yaml → "subjects" table definition (17 fields)
- **With Types**: subjects_schema.sql → CREATE TABLE subjects
- **As Xano Config**: subjects_implementation.yaml → "Table: subjects"

**Question**: How do permissions work?
- **Answer**: subjects_database.yaml → "subject_permissions" table definition
- **With SQL**: subjects_schema.sql → CREATE TABLE subject_permissions
- **API Usage**: subjects_examples.json → "grant_permission_request"

**Question**: What constraints are enforced?
- **Answer**: subjects_database.yaml → "Constraints" section under each table
- **In SQL**: subjects_schema.sql → CHECK constraints and UNIQUE constraints
- **Validation**: subjects_database.yaml → "Data Validation" section

### 🔐 SECURITY & ACCESS CONTROL

**Question**: How is authorization implemented?
- **Answer**: subjects_database.yaml → "Authentication & Authorization" section
- **In Detail**: subjects_implementation.yaml → "Authentication Middleware"
- **In Code**: subjects_schema.sql → can_access_subject function

**Question**: What permission levels exist?
- **Answer**: subjects_database.yaml → "subject_permissions" table definition
- **Hierarchy**: subjects_implementation.yaml → Business logic description
- **SQL Check**: subjects_schema.sql → permission_type enum values

**Question**: How can users share subjects?
- **Answer**: subjects_examples.json → "grant_permission_request" example
- **API Details**: subjects_implementation.yaml → "POST /subjects/{id}/permissions"
- **In Database**: subjects_database.yaml → subject_permissions table

### 🔌 API ENDPOINTS

**Question**: What endpoints are available?
- **Full List**: subjects_implementation.yaml → "Xano API Endpoints" section
- **With Examples**: subjects_examples.json → "api_examples" section
- **Specs**: subjects_database.yaml → "API Endpoints (Future Implementation)"

**Question**: How do I create a subject?
- **Request Format**: subjects_examples.json → "create_subject_request"
- **Response Format**: subjects_examples.json → "create_subject_response"
- **API Spec**: subjects_implementation.yaml → "POST /subjects"

**Question**: How do I list subjects with filters?
- **Query Parameters**: subjects_implementation.yaml → "GET /subjects"
- **Example Request**: subjects_examples.json → "list_subjects_request"
- **Example Response**: subjects_examples.json → "list_subjects_response"

**Question**: How do I handle errors?
- **Error Handling**: subjects_examples.json → "error_response_*" examples
- **Response Format**: subjects_implementation.yaml → "Error response" section

### 📊 DATA EXAMPLES

**Question**: Can I see sample data?
- **Users**: subjects_examples.json → "users" array (3 samples)
- **Subjects**: subjects_examples.json → "subjects" array (5 samples)
- **Permissions**: subjects_examples.json → "subject_permissions" array

**Question**: What should a subject look like?
- **Minimal**: subjects_database.yaml → "Subject Creation" validation (just name required)
- **Full**: subjects_examples.json → subjects[0] (Data Structures example)
- **Xano Format**: subjects_implementation.yaml → Column definitions

**Question**: Can I see real API calls?
- **All Calls**: subjects_examples.json → "api_examples" object (10 examples)
- **CRUD**: subjects_examples.json → create, read, update, delete examples
- **Permissions**: subjects_examples.json → permission management examples

### 🚀 IMPLEMENTATION & DEPLOYMENT

**Question**: How do I implement this in Xano?
- **Full Guide**: subjects_implementation.yaml (entire document)
- **Tables**: subjects_implementation.yaml → "Xano Table Configuration"
- **Functions**: subjects_implementation.yaml → "Xano Functions"
- **Endpoints**: subjects_implementation.yaml → "Xano API Endpoints"

**Question**: What's the deployment checklist?
- **Full Checklist**: subjects_implementation.yaml → "Deployment Checklist"
- **Phases**: SUBJECTS_SUMMARY.md → "Deployment Checklist" (5 phases)
- **Database Setup**: subjects_schema.sql (scripts ready to run)

**Question**: What should I test?
- **Test Scenarios**: subjects_implementation.yaml → "Testing Scenarios"
- **SQL Queries**: subjects_examples.json → "query_examples"
- **API Tests**: subjects_examples.json → all "api_examples"

**Question**: What functions do I need to create?
- **Business Logic**: subjects_implementation.yaml → "Xano Functions" (5 functions)
- **SQL Functions**: subjects_schema.sql → 5 database functions
- **Triggers**: subjects_schema.sql → 1 trigger (update timestamp)

### 📈 PERFORMANCE & OPTIMIZATION

**Question**: What indexes should I create?
- **Index List**: subjects_database.yaml → "Indexes" under each table
- **SQL Syntax**: subjects_schema.sql → CREATE INDEX statements
- **Why**: subjects_schema.sql → comments explaining each index

**Question**: How should queries be optimized?
- **Functions**: subjects_implementation.yaml → Function descriptions
- **Views**: subjects_schema.sql → 3 pre-built views
- **Query Examples**: subjects_examples.json → "query_examples"

**Question**: How does it scale?
- **Scalability**: SUBJECTS_SUMMARY.md → "Scalability" section
- **Indexes**: subjects_schema.sql → Performance-focused indexes

### 🔄 INTEGRATION & FUTURE

**Question**: How does this connect to other features?
- **Related Entities**: subjects_database.yaml → "Related Entities" section
- **Integration Points**: subjects_database.yaml → "Related Entities"
- **Roadmap**: subjects_database.yaml → "Expected Evolution"
- **In System**: context/system.md → "Expected Evolution"

**Question**: What automations are planned?
- **Future Automations**: subjects_database.yaml → "Automations (Future)" section
- **Functions**: subjects_schema.sql → auto_complete_subjects, expire_permissions
- **Workflows**: subjects_implementation.yaml → "Xano Workflows"

**Question**: Can I store files with subjects?
- **Yes, Future**: subjects_database.yaml → "Related Entities" → "Files/Materials"
- **Plan**: Each subject can have attached materials

---

## File-by-File Reference

### 📄 SUBJECTS_SUMMARY.md
**Purpose**: Executive summary and navigation hub  
**Best For**: Quick overview, deployment planning, stakeholder communication  
**Contains**:
- What was created (list of 6 files)
- Database structure overview
- Authorization model
- API design summary
- Key features checklist
- Deployment checklist (5 phases)
- Technology stack
- Performance considerations

### 📋 specs/subjects_database.yaml
**Purpose**: Functional specification (what, not how)  
**Best For**: Understanding requirements, design review  
**Contains**:
- Complete table definitions
- All 17 subject fields with descriptions
- All 7 permission fields with descriptions
- Database constraints and validation rules
- API endpoint specifications
- Future automations
- Authentication & authorization rules
- Data validation requirements

### 🔧 specs/subjects_implementation.yaml
**Purpose**: Technical implementation guide (how to build it)  
**Best For**: Backend developers, Xano configuration  
**Contains**:
- Xano table configuration (exact syntax)
- Column type definitions
- 5 business logic functions
- 2 automation workflows
- Complete API endpoint specifications
- Request/response JSON examples
- Deployment checklist
- 20 testing scenarios

### 💾 specs/subjects_schema.sql
**Purpose**: Database creation scripts  
**Best For**: Database administrators, SQL reference  
**Contains**:
- 2 CREATE TABLE statements
- 10 CREATE INDEX statements
- 3 CREATE FUNCTION statements
- 1 CREATE TRIGGER statement
- 3 CREATE VIEW statements
- SQL comments explaining design choices
- Sample queries at the end
- Optional audit table

### 📊 specs/subjects_examples.json
**Purpose**: Sample data and API documentation by example  
**Best For**: QA testing, API integration, documentation  
**Contains**:
- 3 sample users
- 5 sample subjects with realistic data
- 2 sample permissions
- 10 complete API examples (request + response)
- 2 error response examples
- 5 SQL query examples

### 📝 changes/subjects_database_20260520.md
**Purpose**: Change log and project tracking  
**Best For**: Project tracking, communication, handoff  
**Contains**:
- Summary of changes
- List of new files created
- Features implemented (design phase)
- Technical details
- Integration points
- Next steps and checklist
- Related issues
- Status

### 📚 context/system.md
**Purpose**: System context for AI and team communication  
**Best For**: Onboarding, project understanding  
**Contains**:
- Core entities list
- Relationships diagram
- Features overview
- Authorization rules
- Evolution roadmap

---

## Common Workflows

### 👨‍💻 "I'm implementing the backend"
1. Start: SUBJECTS_SUMMARY.md (overview)
2. Read: subjects_implementation.yaml (Xano configuration)
3. Reference: subjects_examples.json (API contract)
4. Test: subjects_implementation.yaml (testing scenarios)
5. Deploy: subjects_implementation.yaml (deployment checklist)

### 🧪 "I'm testing the API"
1. Start: SUBJECTS_SUMMARY.md (feature overview)
2. Read: subjects_examples.json (10 API examples)
3. Reference: subjects_implementation.yaml (testing scenarios)
4. Review: subjects_examples.json (error responses)

### 👨‍💼 "I need to understand the design"
1. Start: SUBJECTS_SUMMARY.md (executive summary)
2. Read: subjects_database.yaml (functional spec)
3. Check: SUBJECTS_SUMMARY.md (authorization model)
4. Review: subjects_examples.json (sample data)

### 🗄️ "I need to set up the database"
1. Start: SUBJECTS_SUMMARY.md (overview)
2. Review: subjects_database.yaml (table definitions)
3. Execute: subjects_schema.sql (create tables)
4. Verify: subjects_examples.json (sample data)

### 🚀 "I'm deploying this to production"
1. Plan: subjects_implementation.yaml (deployment checklist)
2. Database: subjects_schema.sql (production scripts)
3. API: subjects_implementation.yaml (API endpoints)
4. Testing: subjects_examples.json (test data)
5. Monitor: SUBJECTS_SUMMARY.md (success criteria)

---

## Document Relationships

```
SUBJECTS_SUMMARY.md (Hub)
├── References → subjects_database.yaml
├── References → subjects_implementation.yaml
├── References → subjects_schema.sql
├── References → subjects_examples.json
├── References → subjects_database_20260520.md
└── References → context/system.md

subjects_database.yaml (Specification)
├── Detailed by → subjects_implementation.yaml
├── Implemented in → subjects_schema.sql
├── Exemplified by → subjects_examples.json
└── Tracked in → subjects_database_20260520.md

subjects_implementation.yaml (Technical Guide)
├── Based on → subjects_database.yaml
├── Uses SQL from → subjects_schema.sql
├── Tested with → subjects_examples.json
└── Deployed via → subjects_implementation.yaml (checklist)

subjects_schema.sql (Database Scripts)
├── Implements → subjects_database.yaml
├── Referenced in → subjects_implementation.yaml
├── Tested with → subjects_examples.json
└── Logged in → subjects_database_20260520.md

subjects_examples.json (Sample Data)
├── Validates → subjects_database.yaml
├── Implements → subjects_implementation.yaml
├── Tests → subjects_schema.sql
└── Tracked in → subjects_database_20260520.md

subjects_database_20260520.md (Change Log)
├── Summarizes → All of the above
├── Links to → All of the above
└── Tracked by → Project management

context/system.md (System Context)
├── Updated by → subjects_database.yaml
├── Linked to → All specifications
└── Used by → Team and AI
```

---

## Checklist for Completeness

Use this checklist to verify all documentation is available:

- [ ] **SUBJECTS_SUMMARY.md** - Executive overview (START HERE)
  - [ ] Contains what was created
  - [ ] Lists all 6 documentation files
  - [ ] Database structure overview
  - [ ] Authorization model diagram
  - [ ] Deployment checklist

- [ ] **subjects_database.yaml** - Functional specification
  - [ ] Subjects table (17 fields defined)
  - [ ] Subject_permissions table (7 fields defined)
  - [ ] Constraints and validation rules
  - [ ] API endpoints listed
  - [ ] Automations described

- [ ] **subjects_implementation.yaml** - Technical guide
  - [ ] Xano table configuration
  - [ ] 5 business logic functions
  - [ ] Complete API endpoint specs
  - [ ] Request/response examples
  - [ ] Testing scenarios (20+)
  - [ ] Deployment checklist

- [ ] **subjects_schema.sql** - Database scripts
  - [ ] CREATE TABLE subjects
  - [ ] CREATE TABLE subject_permissions
  - [ ] 10+ indexes
  - [ ] 5 functions
  - [ ] 1 trigger
  - [ ] 3 views

- [ ] **subjects_examples.json** - Sample data
  - [ ] 3 sample users
  - [ ] 5 sample subjects
  - [ ] 2 sample permissions
  - [ ] 10 API examples
  - [ ] Error responses
  - [ ] 5 query examples

- [ ] **subjects_database_20260520.md** - Change log
  - [ ] Summary of changes
  - [ ] Files created list
  - [ ] Features implemented
  - [ ] Next steps
  - [ ] Deployment checklist

- [ ] **context/system.md** - System context (UPDATED)
  - [ ] Core entities listed
  - [ ] Relationships documented
  - [ ] Features described
  - [ ] Evolution roadmap

---

## Version Control

- **Version**: 1.0
- **Created**: 2026-05-20
- **Status**: ✅ Complete - Ready for Implementation
- **Owner**: Gabriel Moreira da Natividade

All documents are synchronized as of 2026-05-20.

---

## Support & Questions

If you can't find what you're looking for:
1. Check the "Finding Information by Topic" section above
2. Check the "Common Workflows" section for your use case
3. See the "File-by-File Reference" for document contents
4. Review the "Document Relationships" diagram
5. Use the "Checklist for Completeness" to verify all files exist

**Most questions can be answered by combining 2-3 of these documents.**
