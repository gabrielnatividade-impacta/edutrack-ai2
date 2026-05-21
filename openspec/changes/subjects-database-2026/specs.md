# Specifications: Database de Disciplinas (Subjects)

**Data**: 20 de maio de 2026  
**Status**: ✅ Completo

---

## 📋 Resumo Executivo

Este documento detalha as especificações técnicas da solução de gerenciamento de disciplinas acadêmicas (Subjects), incluindo:
- Definição completa de tabelas e campos
- Requisitos de API (9 endpoints)
- Requisitos de validação
- Regras de negócio
- Exemplos de dados

---

## 🗄️ Especificações de Banco de Dados

### CREATE TABLE subjects

```sql
CREATE TABLE subjects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50),
  description TEXT,
  professor_name VARCHAR(255),
  professor_email VARCHAR(255),
  semester VARCHAR(50),
  credits INTEGER DEFAULT 0 CHECK (credits >= 0),
  workload_hours INTEGER DEFAULT 0 CHECK (workload_hours >= 0),
  start_date DATE,
  end_date DATE CHECK (end_date >= start_date),
  status VARCHAR(20) NOT NULL DEFAULT 'active' 
    CHECK (status IN ('active', 'completed', 'archived', 'cancelled')),
  color VARCHAR(7),
  notes TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, code)
);

CREATE INDEX idx_subjects_user_id ON subjects(user_id);
CREATE INDEX idx_subjects_status ON subjects(status);
CREATE INDEX idx_subjects_created_at ON subjects(created_at DESC);
```

### CREATE TABLE subject_permissions

```sql
CREATE TABLE subject_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id UUID NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  permission_type VARCHAR(20) NOT NULL 
    CHECK (permission_type IN ('owner', 'editor', 'commenter', 'viewer')),
  granted_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP,
  UNIQUE(subject_id, user_id)
);

CREATE INDEX idx_permissions_subject_id ON subject_permissions(subject_id);
CREATE INDEX idx_permissions_user_id ON subject_permissions(user_id);
CREATE INDEX idx_permissions_type ON subject_permissions(permission_type);
CREATE INDEX idx_permissions_expires_at ON subject_permissions(expires_at);
```

---

## 🔌 Especificações de API

### 1. POST /api/subjects

**Criar nova disciplina**

**Request**:
```json
{
  "name": "Cálculo I",
  "code": "MAT101",
  "description": "Fundamentos de cálculo",
  "professor_name": "Dr. João Silva",
  "professor_email": "joao@univ.edu",
  "semester": "2026/1",
  "credits": 4,
  "workload_hours": 60,
  "start_date": "2026-03-01",
  "end_date": "2026-07-15",
  "color": "#FF5733",
  "notes": "Disciplina obrigatória"
}
```

**Response** (201):
```json
{
  "id": "uuid-123",
  "user_id": "user-uuid",
  "name": "Cálculo I",
  "code": "MAT101",
  "status": "active",
  "created_at": "2026-05-20T10:00:00Z"
}
```

**Validações**:
- name: Required, 1-255 chars
- code: Optional, 1-50 chars, unique per user
- professor_email: Valid email format if provided
- color: Valid hex format if provided (#RRGGBB)
- credits, workload_hours: ≥ 0
- start_date ≤ end_date

---

### 2. GET /api/subjects

**Listar disciplinas do usuário**

**Query Parameters**:
```
status=active|completed|archived|cancelled
semester=2026/1
order_by=created_at|name|start_date
sort=asc|desc
limit=10
offset=0
```

**Response** (200):
```json
{
  "count": 5,
  "data": [
    {
      "id": "uuid-123",
      "name": "Cálculo I",
      "code": "MAT101",
      "status": "active",
      "credits": 4,
      "created_at": "2026-05-20T10:00:00Z"
    }
  ]
}
```

**Regra de Acesso**:
- User vê apenas suas disciplinas (user_id = auth_user_id)
- Ou disciplinas onde tem permission_type ≥ viewer

---

### 3. GET /api/subjects/:id

**Obter detalhes de disciplina**

**Response** (200):
```json
{
  "id": "uuid-123",
  "user_id": "user-uuid",
  "name": "Cálculo I",
  "code": "MAT101",
  "description": "Fundamentos de cálculo",
  "professor_name": "Dr. João Silva",
  "professor_email": "joao@univ.edu",
  "semester": "2026/1",
  "credits": 4,
  "workload_hours": 60,
  "start_date": "2026-03-01",
  "end_date": "2026-07-15",
  "status": "active",
  "color": "#FF5733",
  "notes": "Disciplina obrigatória",
  "created_at": "2026-05-20T10:00:00Z",
  "updated_at": "2026-05-20T10:00:00Z",
  "permissions": {
    "can_read": true,
    "can_edit": true,
    "can_delete": true,
    "can_manage_permissions": true
  }
}
```

**Validações**:
- Subject ID exists
- User has read access

---

### 4. PUT /api/subjects/:id

**Atualizar disciplina**

**Request**:
```json
{
  "name": "Cálculo I - Atualizado",
  "status": "active",
  "credits": 5
}
```

**Response** (200): Subject atualizado

**Validações**:
- Subject exists
- User is owner OR editor
- All field validations as per POST
- status must be valid enum

---

### 5. DELETE /api/subjects/:id

**Deletar disciplina**

**Response** (204): No content

**Validações**:
- Subject exists
- User is owner (only)

---

### 6. POST /api/subjects/:id/permissions

**Conceder permissão**

**Request**:
```json
{
  "user_id": "user-uuid-shared",
  "permission_type": "editor"
}
```

**Response** (201):
```json
{
  "id": "perm-uuid",
  "subject_id": "uuid-123",
  "user_id": "user-uuid-shared",
  "permission_type": "editor",
  "created_at": "2026-05-20T10:30:00Z"
}
```

**Validações**:
- User is owner of subject
- permission_type in [owner, editor, commenter, viewer]
- Target user exists
- Permission doesn't already exist (update instead)

---

### 7. GET /api/subjects/:id/permissions

**Listar permissões da disciplina**

**Response** (200):
```json
{
  "count": 2,
  "data": [
    {
      "id": "perm-uuid",
      "user_id": "user-uuid-shared",
      "permission_type": "editor",
      "granted_by": "owner-uuid",
      "created_at": "2026-05-20T10:30:00Z",
      "expires_at": null
    }
  ]
}
```

**Validações**:
- User is owner of subject

---

### 8. DELETE /api/subjects/:id/permissions/:user_id

**Revogar permissão**

**Response** (204): No content

**Validações**:
- User is owner of subject
- Permission exists
- Cannot revoke own owner permission

---

### 9. GET /api/subjects/permissions/me

**Disciplinas compartilhadas comigo**

**Response** (200):
```json
{
  "count": 3,
  "data": [
    {
      "subject_id": "uuid-456",
      "name": "Física II",
      "permission_type": "viewer",
      "owner": {
        "id": "owner-uuid",
        "name": "Maria Santos"
      },
      "created_at": "2026-05-15T14:00:00Z"
    }
  ]
}
```

---

## ✅ Regras de Validação de Campo

```
name:
  - Obrigatório
  - Min: 1 char
  - Max: 255 chars
  - Pattern: /^[a-zA-Z0-9áéíóúãõçñ\s\-\.]+$/

code:
  - Opcional
  - Min: 1 char
  - Max: 50 chars
  - Unique per (user_id, code)
  - Pattern: /^[A-Z0-9\-]+$/

professor_email:
  - Opcional
  - Valid email format (RFC 5322)
  - Max: 255 chars

color:
  - Opcional
  - Valid hex format: #[0-9A-Fa-f]{6}
  
credits, workload_hours:
  - Opcional
  - Integer ≥ 0

status:
  - Required
  - Enum: [active, completed, archived, cancelled]
  - Default: active

start_date, end_date:
  - Opcional
  - ISO 8601 format (YYYY-MM-DD)
  - start_date ≤ end_date
```

---

## 🔐 Regras de Negócio

```
1. PROPRIEDADE
   - User que cria é automaticamente owner
   - Apenas owner pode deletar
   - Apenas owner pode gerenciar permissões

2. COMPARTILHAMENTO
   - Owner concede access via POST /permissions
   - Permission type: owner > editor > commenter > viewer
   - Permissões podem expirar (expires_at)

3. ISOLAMENTO
   - User vê apenas suas disciplinas e as compartilhadas
   - Não há "public" disciplines
   - Cada compartilhamento é 1-to-1 (user + subject)

4. CASCATA
   - Delete subject → Delete todas as permissions
   - Delete user → Delete seus subjects e permissions

5. ATUALIZAÇÃO
   - Qualquer mudança atualiza updated_at
   - Histórico não é mantido (v1)
```

---

## 📊 Dados de Exemplo

### Usuario 1:
```json
{
  "id": "user-001",
  "name": "Alice Silva",
  "email": "alice@example.com"
}
```

### Disciplina 1 (criada por Alice):
```json
{
  "id": "subject-001",
  "user_id": "user-001",
  "name": "Cálculo I",
  "code": "MAT101",
  "description": "Fundamentos de cálculo",
  "professor_name": "Dr. João Silva",
  "professor_email": "joao@univ.edu",
  "semester": "2026/1",
  "credits": 4,
  "workload_hours": 60,
  "start_date": "2026-03-01",
  "end_date": "2026-07-15",
  "status": "active",
  "color": "#FF5733",
  "notes": "Disciplina obrigatória",
  "created_at": "2026-05-20T10:00:00Z",
  "updated_at": "2026-05-20T10:00:00Z"
}
```

### Permissão 1 (Alice compartilha com Bob):
```json
{
  "id": "perm-001",
  "subject_id": "subject-001",
  "user_id": "user-002",
  "permission_type": "viewer",
  "granted_by": "user-001",
  "created_at": "2026-05-20T10:30:00Z",
  "expires_at": null
}
```

---

## 🧪 Cenários de Teste

```
1. CREATE - User cria disciplina
   Input: name=Cálculo I, credits=4
   Expected: Status 201, id gerado

2. READ - User lê sua disciplina
   Input: id=subject-001
   Expected: Status 200, todos os campos

3. UPDATE - Owner atualiza
   Input: id=subject-001, credits=5
   Expected: Status 200, updated_at mudou

4. PERMISSIONS - Owner compartilha
   Input: subject-001, user-002, viewer
   Expected: Status 201, permission criada

5. ACCESS CONTROL - Non-owner não pode deletar
   Input: id=subject-001, auth=user-002
   Expected: Status 403 Forbidden

6. CASCADE - Delete disciplina deleta permissões
   Input: delete subject-001
   Expected: Todas as subject_permissions deletadas

7. EXPIRATION - Permission expirada não é válida
   Input: permission com expires_at no passado
   Expected: Access denied
```

---

## 🚀 Implementação em Xano

### Tabelas Xano (mapeamento):

```
Xano Collection: subjects
Xano Collection: subject_permissions

Business Logic Functions (Xano Scripts):
- can_access_subject(user_id, subject_id) → boolean
- get_user_subjects(user_id) → [subjects]
- get_shared_subjects(user_id) → [subjects]
- check_permission(user_id, subject_id, required_level) → boolean
- auto_revoke_expired_permissions() → count
```

---

**Status**: ✅ Pronto para implementação  
**Próximo Passo**: Gerar Tasks (tarefas de implementação)
