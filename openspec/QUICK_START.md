# Subjects Database - Quick Start Guide

**Get up to speed in 30 minutes or less**

---

## 🚀 Quick Start (5 minutes)

### What Was Created?
A complete database specification for managing academic subjects with user ownership and access control.

### 7 Documentation Files
1. **SUBJECTS_SUMMARY.md** - Executive overview ← **START HERE**
2. **SUBJECTS_REFERENCE.md** - Cross-reference guide
3. **specs/subjects_database.yaml** - Functional spec
4. **specs/subjects_implementation.yaml** - Technical guide
5. **specs/subjects_schema.sql** - SQL scripts
6. **specs/subjects_examples.json** - Sample data & examples
7. **changes/subjects_database_20260520.md** - Change log

### Status
✅ **Design Complete** - Ready for implementation

---

## 📖 Read Based on Your Role

### I'm a Backend Developer (20 minutes)
```
1. Read: SUBJECTS_SUMMARY.md (10 min)
   - Understand the overview
   - See deployment phases
   
2. Study: specs/subjects_implementation.yaml (10 min)
   - Xano table configuration
   - API endpoints
   - Business logic functions
   
THEN: Open specs/subjects_examples.json for API reference
```

### I'm a Database Admin (15 minutes)
```
1. Read: SUBJECTS_SUMMARY.md (5 min)
   - Database structure overview
   
2. Study: specs/subjects_schema.sql (10 min)
   - All SQL scripts ready to copy/paste
   
THEN: Execute the DDL to create tables
```

### I'm a QA Engineer (15 minutes)
```
1. Read: SUBJECTS_SUMMARY.md (5 min)
   - Feature overview
   - Success criteria
   
2. Study: specs/subjects_examples.json (10 min)
   - 10 API examples to test
   - Error responses
   
THEN: specs/subjects_implementation.yaml → Testing Scenarios
```

### I'm a Frontend Developer (15 minutes)
```
1. Read: SUBJECTS_SUMMARY.md (5 min)
   - Feature overview
   
2. Study: specs/subjects_examples.json (10 min)
   - API request/response format
   - Filter parameters
   
THEN: specs/subjects_implementation.yaml → API Endpoints section
```

### I'm a Project Manager (10 minutes)
```
1. Read: SUBJECTS_SUMMARY.md (10 min)
   - Deployment checklist
   - Implementation roadmap
   - Time estimates
   
THEN: Track progress with the 5-phase checklist
```

---

## 🎯 What's in Each Document?

### SUBJECTS_SUMMARY.md
```
✓ What was created (7 files)
✓ Database structure (2 tables, 24 fields)
✓ Authorization model (4 permission levels)
✓ API design (9 endpoints)
✓ Deployment checklist (5 phases)
✓ Success criteria
✓ Next actions by role
```

### specs/subjects_database.yaml
```
✓ Functional specification
✓ Complete table definitions
✓ All 24 fields with descriptions
✓ Constraints (15+)
✓ Validation rules
✓ API endpoints (future)
✓ Automations (future)
```

### specs/subjects_implementation.yaml
```
✓ Xano configuration syntax
✓ Column type mappings
✓ 5 business logic functions
✓ 9 API endpoint specifications
✓ Request/response examples
✓ 20+ testing scenarios
✓ Deployment checklist
```

### specs/subjects_schema.sql
```
✓ PostgreSQL DDL (ready to run)
✓ CREATE TABLE subjects
✓ CREATE TABLE subject_permissions
✓ 10+ CREATE INDEX statements
✓ 5 CREATE FUNCTION statements
✓ 1 CREATE TRIGGER statement
✓ 3 CREATE VIEW statements
```

### specs/subjects_examples.json
```
✓ 3 sample users
✓ 5 sample subjects
✓ 2 sample permissions
✓ 10 complete API examples (req + resp)
✓ Error response examples
✓ 5 database query examples
```

---

## 💡 Key Concepts (2 minutes)

### 1. Subjects Table
Each academic subject has:
- Owner (user_id) - who created it
- Metadata (professor, semester, credits, etc.)
- Status (active, completed, archived, cancelled)
- Color for UI organization

### 2. Permissions
Subjects can be shared with other users:
- **Owner** - Full control (create, read, update, delete, manage permissions)
- **Editor** - Can modify but not delete
- **Viewer** - Read-only access
- **Commenter** - Future feature for collaboration

### 3. Authorization Rules
```
CAN ACCESS IF:
  • User owns the subject, OR
  • User has explicit permission (and it's not expired)
```

### 4. API Design
```
POST   /subjects                    - Create
GET    /subjects                    - List (with filters)
GET    /subjects/:id                - Get one
PUT    /subjects/:id                - Update
DELETE /subjects/:id                - Delete

POST   /subjects/:id/permissions    - Grant permission
GET    /subjects/:id/permissions    - List permissions
DELETE /subjects/:id/permissions/:user_id - Revoke
```

---

## 🚀 Implementation Steps

### Step 1: Database Setup (2-4 hours)
```
1. Copy specs/subjects_schema.sql
2. Execute in PostgreSQL
3. Verify 2 tables created
4. Verify 10+ indexes created
5. Test connectivity
```

### Step 2: Backend Implementation (8-16 hours)
```
1. Create 2 tables in Xano
2. Implement 5 business logic functions
3. Create 9 API endpoints
4. Add JWT authentication
5. Add input validation
6. Add error handling
```

### Step 3: Testing (4-8 hours)
```
1. Use specs/subjects_examples.json to test
2. Test all 9 API endpoints
3. Test all 20+ scenarios in specs/subjects_implementation.yaml
4. Test authorization scenarios
```

### Step 4: Frontend (4-8 hours)
```
1. Update Streamlit "Disciplinas" page
2. Call API endpoints
3. Create forms for CRUD
4. Add filters and search
```

### Step 5: Deployment (2-4 hours)
```
1. Set up monitoring
2. Deploy to staging
3. Run UAT tests
4. Deploy to production
```

---

## 📊 Database at a Glance

### Subjects Table (17 fields)
```
Core:      id, user_id, name, code, description
Academic:  professor_name, professor_email, semester, credits, workload_hours
Schedule:  start_date, end_date
Status:    status (active/completed/archived/cancelled)
Org:       color (for UI), notes
Meta:      created_at, updated_at
```

### Permissions Table (7 fields)
```
Core:      id, subject_id, user_id
Access:    permission_type (owner/editor/viewer/commenter)
Audit:     granted_by, created_at, expires_at
```

---

## 🔐 Security Summary

```
Authentication:
  ✓ JWT token in Authorization header
  ✓ Token must be valid and not expired

Authorization:
  ✓ Check if user owns subject (get full access)
  ✓ Check if user has permission (level-based access)
  ✓ Check if permission is not expired

Validation:
  ✓ Email format (professor_email)
  ✓ Hex color format (#RRGGBB)
  ✓ Date ranges (start_date ≤ end_date)
  ✓ Positive numbers (credits ≥ 0, hours ≥ 0)
  ✓ Enum values (status, permission_type)
```

---

## 📋 Quick Checklist

### Before Development
- [ ] Read SUBJECTS_SUMMARY.md
- [ ] Read role-specific document
- [ ] Understand database structure
- [ ] Understand API design
- [ ] Have specs/subjects_examples.json ready

### During Development
- [ ] Follow Deployment Checklist in SUBJECTS_SUMMARY.md
- [ ] Reference specs/subjects_examples.json for API contract
- [ ] Reference specs/subjects_implementation.yaml for details
- [ ] Use specs/subjects_schema.sql for SQL scripts

### Before Testing
- [ ] Review testing scenarios in specs/subjects_implementation.yaml
- [ ] Prepare test data from specs/subjects_examples.json
- [ ] Set up test database
- [ ] Create test script for all endpoints

### Before Production
- [ ] All tests passing
- [ ] All 9 endpoints working
- [ ] Authorization tests passing
- [ ] Error handling complete
- [ ] Documentation updated
- [ ] Monitoring set up
- [ ] Backups configured

---

## 🎓 Learning Resources

| Topic | Location | Time |
|-------|----------|------|
| Overview | SUBJECTS_SUMMARY.md | 10 min |
| Database Design | specs/subjects_database.yaml | 30 min |
| Implementation | specs/subjects_implementation.yaml | 45 min |
| SQL Scripts | specs/subjects_schema.sql | 20 min |
| API Examples | specs/subjects_examples.json | 15 min |
| Architecture | ARCHITECTURE.md | 15 min |
| Navigation | SUBJECTS_REFERENCE.md | 5 min |

**Total**: ~2.5 hours for complete understanding

---

## ❓ FAQ

### Q: Where do I start?
**A:** Read SUBJECTS_SUMMARY.md (10 minutes), then your role-specific document.

### Q: Do I need to understand all 7 files?
**A:** No. Start with your role-specific guide. Read others as needed.

### Q: Are the SQL scripts ready to use?
**A:** Yes! specs/subjects_schema.sql has complete PostgreSQL DDL.

### Q: Can I see API examples?
**A:** Yes! specs/subjects_examples.json has 10 complete request/response examples.

### Q: How long will implementation take?
**A:** 20-40 hours for full team (parallel work). See deployment phases in SUBJECTS_SUMMARY.md.

### Q: Is the specification complete?
**A:** Yes! Design phase is complete. Ready for implementation.

### Q: What if I need more details?
**A:** Use SUBJECTS_REFERENCE.md (cross-reference guide) to find what you need.

### Q: Can I print these documents?
**A:** Yes! All documents are in markdown/YAML/SQL/JSON format.

---

## 🔗 File Locations

```
c:\Users\2503353\edutrack-ai2\openspec\

Hub Documents:
  ├── INDEX.md                           ← Complete index
  ├── SUBJECTS_SUMMARY.md                ← Executive summary (START)
  ├── SUBJECTS_REFERENCE.md              ← Cross-reference guide
  ├── ARCHITECTURE.md                    ← Visual architecture

Specifications:
  └── specs/
      ├── subjects_database.yaml         ← Functional spec
      ├── subjects_implementation.yaml   ← Technical guide
      ├── subjects_schema.sql            ← SQL scripts
      └── subjects_examples.json         ← Sample data & examples

Context:
  ├── context/system.md                  ← Updated system context
  └── changes/
      └── subjects_database_20260520.md  ← Change log
```

---

## 🎯 Your Next Steps

### For Backend Developers
1. Read SUBJECTS_SUMMARY.md (10 min)
2. Read specs/subjects_implementation.yaml (45 min)
3. Get specs/subjects_schema.sql
4. Get specs/subjects_examples.json
5. Start implementing endpoints in Xano

### For Database Admins
1. Read SUBJECTS_SUMMARY.md (5 min)
2. Get specs/subjects_schema.sql
3. Execute DDL in PostgreSQL
4. Test connectivity
5. Wait for backend developers

### For QA Engineers
1. Read SUBJECTS_SUMMARY.md (10 min)
2. Get specs/subjects_examples.json
3. Get specs/subjects_implementation.yaml
4. Review testing scenarios
5. Prepare test cases

### For Frontend Developers
1. Read SUBJECTS_SUMMARY.md (10 min)
2. Get specs/subjects_examples.json
3. Understand API endpoints
4. Update Streamlit app
5. Test integration

---

## 📞 Need Help?

1. **Can't find something?** → Use SUBJECTS_REFERENCE.md
2. **Need overview?** → Read SUBJECTS_SUMMARY.md
3. **Need architecture?** → Check ARCHITECTURE.md
4. **Need all files?** → Use INDEX.md
5. **Need implementation help?** → Read specs/subjects_implementation.yaml

---

## ✨ Summary

- ✅ **7 comprehensive documents created**
- ✅ **Complete database design**
- ✅ **9 API endpoints specified**
- ✅ **SQL scripts ready to use**
- ✅ **10+ API examples provided**
- ✅ **20+ test scenarios documented**
- ✅ **5-phase deployment plan ready**

**Everything is ready for implementation. Pick your role and get started!**

---

**Last Updated**: May 20, 2026  
**Status**: ✅ Ready for Implementation  
**Time to Read**: 5-30 minutes depending on role
