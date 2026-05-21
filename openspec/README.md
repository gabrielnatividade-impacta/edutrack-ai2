# 🎓 EduTrack AI - Subjects Database Specification

**Complete specification for managing academic subjects with user ownership and access control**

---

## 📋 Overview

This directory contains a comprehensive specification for the Subjects Database component of EduTrack AI. It enables users to:
- Register and manage their academic subjects (courses/disciplines)
- Control access through a fine-grained permission system
- Organize subjects with metadata (professor, credits, dates, etc.)
- Support future collaboration and automation features

**Status**: ✅ **Specification Complete - Ready for Implementation**

**Date Created**: May 20, 2026

---

## 📁 Directory Structure

```
openspec/
│
├── 📄 Hub Documents (Navigation)
│   ├── INDEX.md                    - Complete index and file listing
│   ├── SUBJECTS_SUMMARY.md         - Executive summary (START HERE)
│   ├── SUBJECTS_REFERENCE.md       - Cross-reference guide for all docs
│   ├── QUICK_START.md              - Quick start guide by role
│   ├── ARCHITECTURE.md             - System architecture diagrams
│   └── README.md                   - This file
│
├── 📋 specs/ - Specification Documents
│   ├── subjects_database.yaml      - Functional specification (WHAT to build)
│   ├── subjects_implementation.yaml - Technical guide (HOW to build it)
│   ├── subjects_schema.sql         - PostgreSQL DDL scripts
│   └── subjects_examples.json      - Sample data and API examples
│
├── 📚 context/ - System Context
│   └── system.md                   - Updated system context (MODIFIED)
│
├── 📝 changes/ - Project Tracking
│   ├── subjects_database_20260520.md - Change log entry
│   └── archive/                    - Archived changes
│
└── 📄 config.yaml                  - OpenSpec configuration

Total: 12 files created/updated
```

---

## 🚀 Quick Start

### For Developers
1. **Start Here**: Read [SUBJECTS_SUMMARY.md](SUBJECTS_SUMMARY.md) (10 minutes)
2. **Your Role**: Read [QUICK_START.md](QUICK_START.md) and find your role-specific guide
3. **Implementation**: Open the appropriate spec file for your role
4. **Reference**: Use [SUBJECTS_REFERENCE.md](SUBJECTS_REFERENCE.md) to find information

### For Different Roles

| Role | Start Here | Then Read | Time |
|------|-----------|-----------|------|
| **Backend Dev** | SUBJECTS_SUMMARY.md | specs/subjects_implementation.yaml | 50 min |
| **Database Admin** | SUBJECTS_SUMMARY.md | specs/subjects_schema.sql | 25 min |
| **QA Engineer** | SUBJECTS_SUMMARY.md | specs/subjects_examples.json | 25 min |
| **Frontend Dev** | SUBJECTS_SUMMARY.md | specs/subjects_implementation.yaml (API section) | 25 min |
| **Project Manager** | SUBJECTS_SUMMARY.md | Deployment Checklist | 15 min |
| **All Understanding** | SUBJECTS_SUMMARY.md | All spec files | 150 min |

---

## 📚 Document Guide

### Hub Documents (Navigation)
- **INDEX.md** - Complete index, file locations, statistics
- **SUBJECTS_SUMMARY.md** - Executive overview, features, deployment plan
- **SUBJECTS_REFERENCE.md** - Cross-reference guide, finding information by topic
- **QUICK_START.md** - 5-30 minute guides for different roles
- **ARCHITECTURE.md** - System architecture, data model, API flows

### Specification Documents

#### 📋 subjects_database.yaml
**Purpose**: Functional specification (what to build)
- 17 fields in subjects table (complete definitions)
- 7 fields in subject_permissions table
- 15+ constraints and validation rules
- Authorization rules
- API endpoint list
- Future automations
- **Size**: ~1,500 lines
- **Read Time**: 30-45 minutes

#### 🔧 subjects_implementation.yaml
**Purpose**: Technical implementation guide (how to build it)
- Xano table configuration (exact syntax)
- 5 business logic functions
- 2 automation workflows
- 9 API endpoint specifications with JSON examples
- 20+ testing scenarios
- Deployment checklist
- **Size**: ~1,200 lines
- **Read Time**: 45-60 minutes

#### 💾 subjects_schema.sql
**Purpose**: Database creation scripts
- PostgreSQL DDL (ready to execute)
- CREATE TABLE subjects
- CREATE TABLE subject_permissions
- 10+ indexes
- 5 functions
- 1 trigger
- 3 views
- **Size**: ~500 lines
- **Read Time**: 20-30 minutes

#### 📊 subjects_examples.json
**Purpose**: Sample data and API documentation
- 3 sample users
- 5 sample subjects (realistic data)
- 2 sample permissions
- 10 complete API examples (request + response)
- Error response examples
- 5 database query examples
- **Size**: ~600 lines
- **Read Time**: 15-20 minutes

### Context Documents

#### context/system.md (UPDATED)
- Core entities (Users, Subjects, Permissions)
- Relationships
- Features overview
- Authorization rules
- Evolution roadmap

#### changes/subjects_database_20260520.md
- Summary of changes
- List of files created
- Features implemented
- Integration points
- Next steps

---

## ✨ What Was Created

### 🗄️ Database Design
- **2 Tables**: subjects, subject_permissions
- **24 Fields Total**: 17 in subjects, 7 in permissions
- **15+ Constraints**: Data integrity enforcement
- **10+ Indexes**: Performance optimization
- **5 Functions**: Business logic (authorization, queries, automations)
- **1 Trigger**: Auto-update timestamps

### 🔌 API Design
- **9 Endpoints Total**:
  - 5 CRUD operations (create, read, list, update, delete)
  - 3 permission operations (grant, list, revoke)
  - 1 bulk operations (future)
- **Request/Response Examples**: 10 complete examples
- **Filter Capabilities**: status, semester, search, sorting
- **Pagination**: limit/offset support
- **Error Handling**: Consistent error response format

### 🔐 Security & Authorization
- **JWT Authentication**: Token-based access
- **4 Permission Levels**: owner > editor > viewer > commenter
- **Row-Level Security**: Users see only their data
- **Audit Trail**: Track permission grants/revokes
- **Expiring Permissions**: Optional automatic expiration

### 🎯 Features
- ✅ User ownership with full control
- ✅ Subject sharing with fine-grained permissions
- ✅ Rich metadata (professor, semester, credits, dates)
- ✅ Status tracking (active/completed/archived/cancelled)
- ✅ Custom colors for UI organization
- ✅ Notes and descriptions
- ✅ Comprehensive validation (email, dates, numbers)
- ✅ Automatic timestamp management
- ✅ Future automation hooks

### 📈 Documentation
- **7 specification documents** (YAML, SQL, JSON, Markdown)
- **4,500+ lines** of specification and examples
- **10+ API examples** with request/response
- **20+ test scenarios** documented
- **5-phase deployment plan**
- **Complete index** and navigation guide

---

## 🎯 Key Features

### 1. User Ownership
Every subject has a clear owner (the user who created it).
- Owner has full control
- Owner can share with others
- Owner can revoke access

### 2. Access Control
Fine-grained permissions prevent unauthorized access:
- **Owner**: Full control (CRUD + permissions)
- **Editor**: Can modify but not delete
- **Viewer**: Read-only access
- **Commenter**: Future feature for collaboration

### 3. Rich Metadata
Supports comprehensive academic information:
```
- Professor name & email
- Semester/term
- Credits (academic units)
- Workload hours
- Start and end dates
- Custom color for UI organization
- Flexible notes field
```

### 4. Data Integrity
Multiple validation mechanisms:
- Foreign key constraints
- Unique constraints (prevent duplicates)
- Date validation (start ≤ end)
- Email format validation
- Enum validation (fixed values)
- Numeric range validation

### 5. Query Performance
Optimized for common operations:
- 10+ indexes on frequently queried fields
- Database functions for complex queries
- Pre-built views for common patterns
- Pagination support

### 6. Future-Ready
Foundation for future features:
- Task management (tie tasks to subjects)
- Grades management
- File/materials storage
- Notifications and audit logging
- Automation workflows

---

## 🚀 Implementation Roadmap

### Phase 1: Database Setup (2-4 hours)
Execute SQL scripts from specs/subjects_schema.sql
- Create 2 tables
- Create indexes and constraints
- Create functions and triggers

### Phase 2: Backend Implementation (8-16 hours)
Build API in Xano following specs/subjects_implementation.yaml
- Configure tables in Xano
- Implement 5 business logic functions
- Create 9 API endpoints
- Add authentication and validation

### Phase 3: Integration Testing (4-8 hours)
Test using specs/subjects_examples.json and specs/subjects_implementation.yaml
- Test all endpoints
- Test authorization scenarios
- Test error cases
- Performance testing

### Phase 4: Frontend Integration (4-8 hours)
Update Streamlit app
- Modify "Disciplinas" page
- Create forms for CRUD operations
- Add filters and search
- Test integration with API

### Phase 5: Deployment (2-4 hours)
Production deployment
- Set up monitoring
- Configure backups
- Deploy to staging
- Run UAT tests
- Deploy to production

**Total Estimated Time**: 20-40 hours (for full team, parallel work)

---

## 📊 Specification Statistics

| Metric | Value |
|--------|-------|
| Total Files | 12 (8 created + 4 updated) |
| Total Lines | 4,500+ |
| Database Tables | 2 |
| Database Fields | 24 |
| Database Indexes | 10+ |
| Database Constraints | 15+ |
| Database Functions | 5 |
| API Endpoints | 9 |
| API Examples | 10 |
| Test Scenarios | 20+ |
| Sample Data Records | 10 |
| SQL Statements | 20+ |
| Lines of YAML | 2,700+ |
| Lines of SQL | 500+ |
| Lines of JSON | 600+ |

---

## ✅ What's Documented

### Database Design ✓
- [x] Table structures (all fields, types, constraints)
- [x] Relationships (foreign keys, cascades)
- [x] Indexes (performance optimization)
- [x] Functions (business logic)
- [x] Triggers (automatic updates)
- [x] Views (simplified access)

### API Design ✓
- [x] Authentication (JWT tokens)
- [x] Authorization (permission levels)
- [x] Endpoints (9 total)
- [x] Request/Response formats
- [x] Error handling
- [x] Filters and sorting
- [x] Pagination

### Features ✓
- [x] User ownership
- [x] Access control
- [x] Permissions
- [x] Status tracking
- [x] Metadata storage
- [x] Validation rules
- [x] Automations (hooks)

### Implementation ✓
- [x] Xano configuration
- [x] Business logic functions
- [x] Deployment plan
- [x] Testing scenarios
- [x] Sample data
- [x] SQL scripts

---

## 🔗 Document Cross-References

### For Database Information
→ specs/subjects_database.yaml

### For Implementation Details
→ specs/subjects_implementation.yaml

### For SQL Scripts
→ specs/subjects_schema.sql

### For API Examples
→ specs/subjects_examples.json

### For Project Tracking
→ changes/subjects_database_20260520.md

### For Navigation
→ SUBJECTS_REFERENCE.md

### For Quick Overview
→ SUBJECTS_SUMMARY.md

### For Getting Started
→ QUICK_START.md

### For Architecture
→ ARCHITECTURE.md

### For Complete Index
→ INDEX.md

---

## 🎓 Learning Path

### 30-Minute Overview
1. SUBJECTS_SUMMARY.md (15 min)
2. Your role-specific section in QUICK_START.md (15 min)

### Complete Understanding (2.5 hours)
1. SUBJECTS_SUMMARY.md (15 min)
2. specs/subjects_database.yaml (45 min)
3. specs/subjects_implementation.yaml (45 min)
4. specs/subjects_schema.sql (20 min)
5. specs/subjects_examples.json (15 min)
6. ARCHITECTURE.md (15 min)

### Implementation-Focused (1.5 hours)
1. SUBJECTS_SUMMARY.md (15 min)
2. Your role-specific spec file (45 min)
3. specs/subjects_examples.json (15 min)
4. SUBJECTS_REFERENCE.md (15 min)

---

## 🛠️ Technology Stack

- **Database**: PostgreSQL
- **Backend**: Xano (No-code API builder)
- **Frontend**: Streamlit (Python)
- **Authentication**: JWT (JSON Web Tokens)
- **API Format**: REST with JSON

---

## 📞 Support & Navigation

### Can't Find Something?
→ Use SUBJECTS_REFERENCE.md (cross-reference guide)

### Need a Quick Overview?
→ Read SUBJECTS_SUMMARY.md

### Need to Find Your Role?
→ Use QUICK_START.md

### Need System Architecture?
→ Check ARCHITECTURE.md

### Need Complete Index?
→ Use INDEX.md

### Need File Locations?
→ See Directory Structure above

---

## ✨ Highlights

- 🎯 **Complete Specification** - All tables, fields, constraints defined
- 🔐 **Secure Design** - JWT auth, fine-grained permissions, audit trail
- 📊 **Well-Documented** - 4,500+ lines of specification
- 🚀 **Production-Ready** - Deployment plan, testing scenarios, monitoring
- 💻 **Developer-Friendly** - SQL scripts ready to execute, API examples provided
- 🔄 **Future-Proof** - Automation hooks, extensible design, clear migration path

---

## 📋 Deployment Checklist

### Pre-Implementation
- [ ] Read SUBJECTS_SUMMARY.md
- [ ] Review database design
- [ ] Review API design
- [ ] Understand authorization model
- [ ] Have all spec files downloaded

### Phase 1: Database
- [ ] Create subjects table
- [ ] Create subject_permissions table
- [ ] Create all indexes
- [ ] Create functions and triggers
- [ ] Test connectivity

### Phase 2: Backend
- [ ] Configure Xano tables
- [ ] Implement business logic functions
- [ ] Create API endpoints
- [ ] Add authentication
- [ ] Add validation

### Phase 3: Testing
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Authorization tests passing
- [ ] Error handling working

### Phase 4: Frontend
- [ ] API integration complete
- [ ] CRUD forms working
- [ ] Filters working
- [ ] Permissions UI working

### Phase 5: Deployment
- [ ] Monitoring set up
- [ ] Backups configured
- [ ] Documentation updated
- [ ] UAT tests passing
- [ ] Production ready

---

## 🎯 Success Criteria

✅ Users can create subjects with their information  
✅ Users can only see subjects they own or have permission for  
✅ Only owners can delete subjects  
✅ Owners can share subjects with other users  
✅ Permissions can expire automatically  
✅ All API endpoints have proper error handling  
✅ Data integrity constraints are enforced  
✅ Performance is acceptable with 1000+ subjects  

---

## 📞 Questions?

1. **What's here?** → Read INDEX.md
2. **Where do I start?** → Read SUBJECTS_SUMMARY.md
3. **How do I find something?** → Use SUBJECTS_REFERENCE.md
4. **What's my next step?** → Check QUICK_START.md

---

## 📝 Version Information

- **Version**: 1.0 (Complete)
- **Created**: May 20, 2026
- **Status**: ✅ Ready for Implementation
- **Owner**: Gabriel Moreira da Natividade
- **Repository**: edutrack-ai2 (GitHub)
- **Branch**: main

---

## 🎓 Credit

**Specification Created By**: Gabriel Moreira da Natividade  
**Project**: EduTrack AI - Academic Management System  
**Institution**: Faculdade Impacta  
**Course**: Innovation Lab

---

**🚀 Everything is ready. Pick a document and start implementing!**

For the best experience, start with [SUBJECTS_SUMMARY.md](SUBJECTS_SUMMARY.md) →
