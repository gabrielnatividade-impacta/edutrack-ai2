# Subjects Database - Architecture & Structure

**Visual representation of the Subjects Database specification**

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      EDUTRACK AI - SUBJECTS                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │         FRONTEND LAYER (Streamlit)                         │  │
│  │  ┌─────────────────────────────────────────────────────┐   │  │
│  │  │  Dashboard  │  Subjects  │  Tasks  │  [More Pages]  │   │  │
│  │  └─────────────────────────────────────────────────────┘   │  │
│  └────────────────────────────────────────────────────────────┘  │
│                             ▲                                     │
│                             │ HTTP Requests                       │
│                             ▼                                     │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │          API LAYER (Xano Backend)                          │  │
│  │  ┌──────────────────────────────────────────────────────┐  │  │
│  │  │  /api/subjects          [CRUD]                       │  │  │
│  │  │  /api/subjects/:id/permissions  [Permission Mgmt]  │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  │  ┌──────────────────────────────────────────────────────┐  │  │
│  │  │  Authentication (JWT)                                │  │  │
│  │  │  Authorization (check_can_access_subject)           │  │  │
│  │  │  Validation (email, dates, numbers, etc.)           │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────────────┘  │
│                             ▲                                     │
│                             │ SQL Queries                         │
│                             ▼                                     │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │         DATABASE LAYER (PostgreSQL)                        │  │
│  │  ┌──────────────────────────────────────────────────────┐  │  │
│  │  │  ┌─────────────────┐      ┌──────────────────────┐  │  │  │
│  │  │  │   SUBJECTS      │      │ SUBJECT_PERMISSIONS  │  │  │  │
│  │  │  │ ─────────────   │      │ ─────────────────    │  │  │  │
│  │  │  │ • id            │◄────►│ • id                 │  │  │  │
│  │  │  │ • user_id       │      │ • subject_id (FK)    │  │  │  │
│  │  │  │ • name          │      │ • user_id (FK)       │  │  │  │
│  │  │  │ • code          │      │ • permission_type    │  │  │  │
│  │  │  │ • description   │      │ • granted_by         │  │  │  │
│  │  │  │ • professor_*   │      │ • created_at         │  │  │  │
│  │  │  │ • semester      │      │ • expires_at         │  │  │  │
│  │  │  │ • credits       │      │                      │  │  │  │
│  │  │  │ • workload_*    │      │ Unique: (subj, user) │  │  │  │
│  │  │  │ • start_date    │      │ Index: expires_at    │  │  │  │
│  │  │  │ • end_date      │      └──────────────────────┘  │  │  │
│  │  │  │ • status        │                                 │  │  │
│  │  │  │ • color         │      ┌──────────────────────┐  │  │  │
│  │  │  │ • notes         │      │   USERS (Foreign)    │  │  │  │
│  │  │  │ • created_at    │◄────►│ (Reference only)     │  │  │  │
│  │  │  │ • updated_at    │      │                      │  │  │  │
│  │  │  │                 │      └──────────────────────┘  │  │  │
│  │  │  │ Unique: code    │                                 │  │  │
│  │  │  │ per user        │      ┌──────────────────────┐  │  │  │
│  │  │  │                 │      │  INDEXES (10+)       │  │  │  │
│  │  │  │ Indexes:        │      │  • user_id           │  │  │  │
│  │  │  │ • user_id       │      │  • status            │  │  │  │
│  │  │  │ • status        │      │  • created_at        │  │  │  │
│  │  │  │ • dates         │      │  • dates             │  │  │  │
│  │  │  └─────────────────┘      └──────────────────────┘  │  │  │
│  │  │                                                       │  │  │
│  │  │  ┌──────────────────────────────────────────────┐  │  │  │
│  │  │  │  FUNCTIONS & TRIGGERS                        │  │  │  │
│  │  │  │  • can_access_subject()    [Authorization]   │  │  │  │
│  │  │  │  • get_user_subjects()     [Query]           │  │  │  │
│  │  │  │  • auto_complete_subjects() [Automation]     │  │  │  │
│  │  │  │  • expire_permissions()    [Automation]      │  │  │  │
│  │  │  │  • update_timestamp()      [Auto-trigger]    │  │  │  │
│  │  │  └──────────────────────────────────────────────┘  │  │  │
│  │  │                                                       │  │  │
│  │  │  ┌──────────────────────────────────────────────┐  │  │  │
│  │  │  │  VIEWS (Simplified Access)                   │  │  │  │
│  │  │  │  • active_subjects                           │  │  │  │
│  │  │  │  • completed_subjects                        │  │  │  │
│  │  │  │  • user_subject_access                       │  │  │  │
│  │  │  └──────────────────────────────────────────────┘  │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔐 Authorization Model

```
┌──────────────────────────────────────────────────────────────┐
│  REQUEST: User wants to access/modify Subject                │
└──────────────────────────────────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────────┐
│  STEP 1: Authentication                                      │
│  □ JWT Token present in Authorization header?               │
│  □ Token is valid and not expired?                          │
│  □ Token contains valid user_id?                            │
└──────────────────────────────────────────────────────────────┘
                            ▼
                    YES ──┐
                          ▼ NO ──► 401 UNAUTHORIZED
┌──────────────────────────────────────────────────────────────┐
│  STEP 2: Check Subject Ownership                             │
│  □ Is subject.user_id == request.user_id?                   │
│    (Is the requesting user the owner?)                       │
└──────────────────────────────────────────────────────────────┘
                            ▼
              YES ──► ALLOW (Owner has full access)
              │
              NO
              │
              ▼
┌──────────────────────────────────────────────────────────────┐
│  STEP 3: Check Explicit Permissions                          │
│  □ Look in subject_permissions table                         │
│  □ Find row: (subject_id, user_id)                           │
│  □ Check if permission is not expired                        │
└──────────────────────────────────────────────────────────────┘
                            ▼
           FOUND & VALID ──┐
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  STEP 4: Check Permission Level                              │
│  Permission Hierarchy:                                       │
│  • owner   [4] - Full control                                │
│  • editor  [3] - Can modify                                  │
│  • commenter[2] - Can comment                                │
│  • viewer  [1] - Read-only                                   │
│                                                              │
│  Required Level ≤ User's Level? → ALLOW                      │
│  Required Level > User's Level? → 403 FORBIDDEN              │
└──────────────────────────────────────────────────────────────┘
                            ▼
           NOT FOUND OR EXPIRED ──► 403 FORBIDDEN (No access)
```

---

## 📊 Data Model

```
Users Table
───────────────────────────────────────────
│ id (UUID)                                 │
│ name (STRING)                             │
│ email (STRING)                            │
│ [other user fields]                       │
└───────────────────────────────────────────┘
         ▲              ▲            ▲
         │              │            │
         │ Owns          │ Granted by │ Has Permission
         │              │            │
         └──────┬───────┴────────────┘
                │
    ┌───────────┴──────────┐
    │                      │
    ▼                      ▼
┌──────────────────┐  ┌──────────────────────┐
│    SUBJECTS      │  │ SUBJECT_PERMISSIONS  │
├──────────────────┤  ├──────────────────────┤
│ id (UUID)        │  │ id (UUID)            │
│ user_id (FK)     │◄─┼ subject_id (FK)      │
│ name (STRING)    │  │ user_id (FK)         │
│ code (STRING)    │  │ permission_type      │
│ description      │  │ granted_by (FK)      │
│ professor_name   │  │ created_at           │
│ professor_email  │  │ expires_at           │
│ semester         │  │                      │
│ credits (INT)    │  │ Unique: (subj, user) │
│ workload_hours   │  └──────────────────────┘
│ start_date       │
│ end_date         │
│ status (ENUM)    │
│ color (HEX)      │
│ notes (TEXT)     │
│ created_at       │
│ updated_at       │
└──────────────────┘

Relationships:
─────────────
subjects.user_id → users.id
  (1-to-Many: One user can have many subjects)
  (ON DELETE CASCADE: Deleting user deletes subjects)

subject_permissions.subject_id → subjects.id
  (Many-to-One: Many permissions per subject)
  (ON DELETE CASCADE: Deleting subject deletes permissions)

subject_permissions.user_id → users.id
  (Many-to-One: Many permissions to one user)
  (ON DELETE CASCADE: Deleting user deletes their permissions)

subject_permissions.granted_by → users.id
  (Many-to-One: Who granted the permission)
  (ON DELETE RESTRICT: Cannot delete if gave permissions)
```

---

## 🔄 API Flow

```
CLIENT (Streamlit)          BACKEND (Xano)              DATABASE (PostgreSQL)
────────────────            ─────────────              ─────────────────────

1. CREATE SUBJECT
┌─────────────┐
│ POST        │
│ /subjects   │
│ {name, ...} │
└──────────┬──┘
           │
           │ JWT Auth + Validation
           ├──────────────────────────► insert_subject()
           │                            INSERT subjects
           │                            ├─ generate id
           │                            ├─ set user_id
           │                            ├─ validate fields
           │                            └─ set timestamps
           │                            │
           │                            ◄── Subject created
           │
           ◄──────────────────────────── 201 Created
           │                             + subject details

2. LIST SUBJECTS
┌─────────────┐
│ GET         │
│ /subjects   │
│ ?status=... │
└──────────┬──┘
           │
           │ JWT Auth + Auth Check
           ├──────────────────────────► get_user_subjects()
           │                            SELECT from subjects
           │                            WHERE user_id = ? OR
           │                            (subject_id in
           │                             permissions table)
           │                            │
           │                            ◄── Subject list
           │
           ◄──────────────────────────── 200 OK
           │                             + array of subjects

3. UPDATE SUBJECT
┌─────────────┐
│ PUT         │
│ /subjects/:id
│ {field:val} │
└──────────┬──┘
           │
           │ Check ownership
           ├──────────────────────────► can_access_subject()
           │                            Can modify?
           │                            │
           │                            ◄── yes/no
           │
           ├───────────────────────────► UPDATE subjects
           │                            SET field = value
           │                            WHERE id = ?
           │                            TRIGGER: update updated_at
           │                            │
           │                            ◄── Updated
           │
           ◄──────────────────────────── 200 OK
           │                             + updated subject

4. GRANT PERMISSION
┌──────────────────┐
│ POST             │
│ /subjects/:id/   │
│  permissions     │
│ {user_id, type}  │
└──────────┬───────┘
           │
           │ Check ownership
           ├──────────────────────────► check_owner()
           │                            Is requester owner?
           │                            │
           │                            ◄── yes/no
           │
           ├───────────────────────────► INSERT permissions
           │                            (subject_id, user_id,
           │                             permission_type,
           │                             granted_by)
           │                            │
           │                            ◄── Permission created
           │
           ◄──────────────────────────── 201 Created
           │                             + permission details

5. DELETE SUBJECT
┌─────────────┐
│ DELETE      │
│ /subjects/:id
│             │
└──────────┬──┘
           │
           │ Check ownership
           ├──────────────────────────► can_access_subject()
           │                            Is owner?
           │                            │
           │                            ◄── yes/no
           │
           ├───────────────────────────► DELETE subjects
           │                            WHERE id = ?
           │                            CASCADE:
           │                            - delete permissions
           │                            │
           │                            ◄── Deleted
           │
           ◄──────────────────────────── 204 No Content
```

---

## 🎯 Feature Map

```
┌─────────────────────────────────────────────────────────────┐
│                  SUBJECTS DATABASE FEATURES                 │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  CORE FUNCTIONALITY                                           │
│  ├─ Create Subject          (Owner creates)                  │
│  ├─ Read Subject            (Owner or with permission)       │
│  ├─ Update Subject          (Owner or editor)                │
│  ├─ Delete Subject          (Owner only)                     │
│  └─ List Subjects           (Filtered by ownership)          │
│                                                               │
│  PERMISSION MANAGEMENT                                        │
│  ├─ Grant Permission        (Owner to other users)           │
│  ├─ List Permissions        (Owner views)                    │
│  ├─ Revoke Permission       (Owner removes)                  │
│  ├─ Expire Permission       (Auto - if expires_at set)       │
│  └─ Permission Levels       (owner > editor > viewer)        │
│                                                               │
│  ACADEMIC METADATA                                            │
│  ├─ Professor Information   (name, email)                    │
│  ├─ Semester Tracking       (which semester)                 │
│  ├─ Credits                 (academic credits)               │
│  ├─ Workload Hours          (total hours)                    │
│  ├─ Schedule Dates          (start/end dates)                │
│  └─ Subject Description     (full text)                      │
│                                                               │
│  ORGANIZATION FEATURES                                        │
│  ├─ Custom Colors           (visual organization)            │
│  ├─ Subject Code            (e.g., CS101)                    │
│  ├─ Status Tracking         (active/completed/archived)      │
│  ├─ Custom Notes            (flexible notes field)           │
│  └─ Auto-timestamp          (created_at, updated_at)         │
│                                                               │
│  QUERYING & FILTERING                                         │
│  ├─ Filter by Status        (active, completed, etc.)        │
│  ├─ Filter by Semester      (2026/1, etc.)                   │
│  ├─ Search by Text          (name, code, professor)          │
│  ├─ Sort by Dates           (start, end, created)            │
│  └─ Pagination              (limit/offset)                   │
│                                                               │
│  AUTOMATIONS (FUTURE)                                         │
│  ├─ Auto-Complete           (mark done when end_date passed) │
│  ├─ Permission Expiration   (auto-revoke expired)            │
│  ├─ Notifications           (status changes)                 │
│  └─ Audit Logging           (track all changes)              │
│                                                               │
│  DATA INTEGRITY                                               │
│  ├─ Email Validation        (professor_email format)         │
│  ├─ Date Validation         (start ≤ end)                    │
│  ├─ Number Validation       (credits ≥ 0, hours ≥ 0)        │
│  ├─ Color Validation        (#RRGGBB hex format)             │
│  ├─ Enum Validation         (status, permission_type)        │
│  └─ Foreign Key Constraints (data consistency)               │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📈 Status Lifecycle

```
┌──────────┐
│  active  │ ◄─── Initial status when created
└────┬─────┘
     │
     ├─── User marks as archived
     │    │
     │    ▼
     │  ┌──────────┐
     │  │ archived │ (Can be reactivated)
     │  └──────────┘
     │
     ├─── end_date has passed (auto-transition)
     │    │
     │    ▼
     │  ┌───────────┐
     │  │ completed │ (Final status - course is done)
     │  └───────────┘
     │
     └─── Course cancelled mid-way
          │
          ▼
        ┌──────────┐
        │cancelled │ (Final status)
        └──────────┘
```

---

## 🔐 Permission Hierarchy

```
┌─────────────────────────────────────────────────┐
│  OWNER [Level 4]                                │
│  ├─ Read subject            ✓                   │
│  ├─ Update subject          ✓                   │
│  ├─ Delete subject          ✓                   │
│  ├─ Grant permissions       ✓                   │
│  ├─ Revoke permissions      ✓                   │
│  └─ List permissions        ✓                   │
├─────────────────────────────────────────────────┤
│  EDITOR [Level 3]                               │
│  ├─ Read subject            ✓                   │
│  ├─ Update subject          ✓                   │
│  ├─ Delete subject          ✗                   │
│  ├─ Grant permissions       ✗                   │
│  ├─ Revoke permissions      ✗                   │
│  └─ List permissions        ✓                   │
├─────────────────────────────────────────────────┤
│  COMMENTER [Level 2]                            │
│  ├─ Read subject            ✓                   │
│  ├─ Update subject          ✗ (not implemented) │
│  ├─ Delete subject          ✗                   │
│  ├─ Grant permissions       ✗                   │
│  ├─ Revoke permissions      ✗                   │
│  └─ Leave comments          ✓ (future)          │
├─────────────────────────────────────────────────┤
│  VIEWER [Level 1]                               │
│  ├─ Read subject            ✓                   │
│  ├─ Update subject          ✗                   │
│  ├─ Delete subject          ✗                   │
│  ├─ Grant permissions       ✗                   │
│  ├─ Revoke permissions      ✗                   │
│  └─ List permissions        ✗                   │
├─────────────────────────────────────────────────┤
│  NO PERMISSION [Level 0]                        │
│  ├─ Read subject            ✗                   │
│  ├─ (No access at all)                          │
└─────────────────────────────────────────────────┘
```

---

## 📚 Document Dependencies

```
INDEX.md ◄──────────────┐
                        │
SUBJECTS_SUMMARY.md ────┼─── SUBJECTS_REFERENCE.md
    │                   │
    ├──────────────────►  specs/subjects_database.yaml
    ├──────────────────►  specs/subjects_implementation.yaml
    ├──────────────────►  specs/subjects_schema.sql
    ├──────────────────►  specs/subjects_examples.json
    ├──────────────────►  changes/subjects_database_20260520.md
    └──────────────────►  context/system.md

specs/subjects_database.yaml
    │
    ├─ Implemented by ──► specs/subjects_implementation.yaml
    │
    ├─ SQL Scripts ─────► specs/subjects_schema.sql
    │
    └─ Examples by ─────► specs/subjects_examples.json

specs/subjects_implementation.yaml
    │
    ├─ Based on ────────► specs/subjects_database.yaml
    │
    ├─ Uses SQL from ───► specs/subjects_schema.sql
    │
    └─ Test data from ──► specs/subjects_examples.json
```

---

## ✨ Implementation Phases

```
PHASE 1: DATABASE SETUP (Hours 0-4)
┌─────────────────────────────────┐
│ ✓ Create subjects table         │
│ ✓ Create subject_permissions    │
│ ✓ Create 10+ indexes            │
│ ✓ Create 5 functions            │
│ ✓ Create 1 trigger              │
│ ✓ Create 3 views                │
│ ✓ Test connectivity             │
└─────────────────────────────────┘
        ▼
PHASE 2: BACKEND API (Hours 4-20)
┌─────────────────────────────────┐
│ ✓ Implement 9 API endpoints     │
│ ✓ Add JWT authentication        │
│ ✓ Add authorization layer       │
│ ✓ Add input validation          │
│ ✓ Add error handling            │
│ ✓ Add logging                   │
│ ✓ Write unit tests              │
└─────────────────────────────────┘
        ▼
PHASE 3: TESTING (Hours 20-24)
┌─────────────────────────────────┐
│ ✓ Integration tests             │
│ ✓ Authorization tests           │
│ ✓ End-to-end tests              │
│ ✓ Load testing                  │
│ ✓ Security testing              │
└─────────────────────────────────┘
        ▼
PHASE 4: FRONTEND (Hours 24-32)
┌─────────────────────────────────┐
│ ✓ Update Streamlit "Disciplinas"│
│ ✓ Create forms (C/R/U/D)        │
│ ✓ Add filters                   │
│ ✓ Add permissions UI            │
│ ✓ Test integration              │
└─────────────────────────────────┘
        ▼
PHASE 5: DEPLOYMENT (Hours 32-40)
┌─────────────────────────────────┐
│ ✓ Set up monitoring             │
│ ✓ Set up backups                │
│ ✓ Deploy to staging             │
│ ✓ UAT testing                   │
│ ✓ Deploy to production          │
│ ✓ Setup automations             │
│ ✓ Document API                  │
└─────────────────────────────────┘
```

---

**Total Documentation Files**: 8  
**Total Specification Lines**: ~4,500  
**Total Code Examples**: 10+  
**Ready for Implementation**: ✅ YES
