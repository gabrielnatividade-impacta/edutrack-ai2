# Design: Database de Disciplinas (Subjects)

**Data**: 20 de maio de 2026  
**Status**: ✅ Revisado

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────┐
│        Users (Existente)        │
├─────────────────────────────────┤
│ id (UUID)                       │
│ name, email, ...                │
└────────────┬────────────────────┘
             │
             │ 1:Many
             │
             ▼
┌─────────────────────────────────┐
│      Subjects (Nova)            │
├─────────────────────────────────┤
│ id (UUID, PK)                   │
│ user_id (FK → users.id)         │
│ name (required)                 │
│ code (unique per user)          │
│ professor_name, professor_email │
│ semester, credits, workload_hrs │
│ start_date, end_date            │
│ status (active/completed/...)   │
│ color (hex)                     │
│ notes                           │
│ created_at, updated_at          │
└────────────┬────────────────────┘
             │
             │ 1:Many
             │
             ▼
┌──────────────────────────────────┐
│ Subject_Permissions (Nova)       │
├──────────────────────────────────┤
│ id (UUID, PK)                    │
│ subject_id (FK → subjects.id)    │
│ user_id (FK → users.id)          │
│ permission_type (owner/editor/...) │
│ granted_by (FK → users.id)       │
│ created_at, expires_at           │
│ Unique(subject_id, user_id)      │
└──────────────────────────────────┘
```

## 📊 Tabelas

### Tabela: subjects

**Responsabilidade**: Armazenar disciplinas acadêmicas

**Campos**:

| Campo | Tipo | Requerido | Notas |
|-------|------|-----------|-------|
| id | UUID | Sim | Primary key, auto-gerado |
| user_id | UUID | Sim | FK para users, dono da disciplina |
| name | VARCHAR(255) | Sim | Nome da disciplina |
| code | VARCHAR(50) | Não | Código (ex: CS101), único por usuário |
| description | TEXT | Não | Descrição detalhada |
| professor_name | VARCHAR(255) | Não | Nome do professor |
| professor_email | VARCHAR(255) | Não | Email do professor (validado) |
| semester | VARCHAR(50) | Não | Semestre (ex: 2026/1) |
| credits | INTEGER | Não | Créditos acadêmicos (≥ 0) |
| workload_hours | INTEGER | Não | Horas de trabalho (≥ 0) |
| start_date | DATE | Não | Data de início |
| end_date | DATE | Não | Data de fim (≥ start_date) |
| status | VARCHAR(20) | Sim | active/completed/archived/cancelled |
| color | VARCHAR(7) | Não | Cor hex (#RRGGBB) |
| notes | TEXT | Não | Notas livres |
| created_at | TIMESTAMP | Sim | Data de criação |
| updated_at | TIMESTAMP | Sim | Última atualização |

**Índices**:
- PK: id
- FK: user_id (cascade delete)
- Index: user_id, status, created_at
- Unique: (user_id, code)

### Tabela: subject_permissions

**Responsabilidade**: Gerenciar acesso a disciplinas (compartilhamento)

**Campos**:

| Campo | Tipo | Requerido | Notas |
|-------|------|-----------|-------|
| id | UUID | Sim | Primary key, auto-gerado |
| subject_id | UUID | Sim | FK para subjects |
| user_id | UUID | Sim | FK para users (quem tem acesso) |
| permission_type | VARCHAR(20) | Sim | owner/editor/viewer/commenter |
| granted_by | UUID | Sim | FK para users (quem concedeu) |
| created_at | TIMESTAMP | Sim | Data de concessão |
| expires_at | TIMESTAMP | Não | Expiração (opcional) |

**Índices**:
- PK: id
- FK: subject_id (cascade delete)
- FK: user_id (cascade delete)
- FK: granted_by
- Index: permission_type, expires_at
- Unique: (subject_id, user_id)

## 🔐 Autorização

### Modelo de Permissões

```
OWNER (4)      → Controle total (CRUD + Permissions)
EDITOR (3)     → Pode editar, não deletar
COMMENTER (2)  → Apenas comentários (futuro)
VIEWER (1)     → Apenas leitura

Regra: user_level ≥ required_level
```

### Regras de Acesso

```
LEITURA:
  ✓ User é dono → Sempre
  ✓ User tem permission_type ≥ 1 (não expirada) → Sim
  ✗ Caso contrário → Negado

ESCRITA:
  ✓ User é dono → Sempre
  ✓ User tem permission_type ≥ 3 (editor) → Sim
  ✗ Caso contrário → Negado

DELETAR:
  ✓ User é dono → Sempre
  ✗ Outros → Negado

GERENCIAR PERMISSÕES:
  ✓ User é dono → Sempre
  ✗ Outros → Negado
```

## 🔌 Endpoints de API (Resumo)

```
POST   /api/subjects                      → Criar
GET    /api/subjects                      → Listar (filtros)
GET    /api/subjects/:id                  → Obter
PUT    /api/subjects/:id                  → Atualizar
DELETE /api/subjects/:id                  → Deletar

POST   /api/subjects/:id/permissions      → Conceder
GET    /api/subjects/:id/permissions      → Listar
DELETE /api/subjects/:id/permissions/:uid → Revogar
```

## ✅ Validações

```
- name: Obrigatório, max 255 chars
- code: Optional, max 50 chars, unique per user
- professor_email: Valid email format
- color: Valid hex (#RRGGBB)
- credits, workload_hours: ≥ 0
- start_date, end_date: start ≤ end
- status: Enum values only
- permission_type: Enum values only
```

## 🔄 Relacionamentos

```
users (1) ──────── (N) subjects
  User owns Multiple Subjects
  Foreign Key: subjects.user_id → users.id
  Delete Rule: CASCADE

subjects (1) ────── (N) subject_permissions
  Subject has Multiple Permissions
  Foreign Key: subject_permissions.subject_id → subjects.id
  Delete Rule: CASCADE

users (1) ─────── (N) subject_permissions
  User can have Multiple Permissions
  Foreign Key: subject_permissions.user_id → users.id
  Delete Rule: CASCADE
```

## 📈 Escalabilidade

- Suporta 1000s de disciplinas por usuário
- Suporta 1000s de permissões por disciplina
- Índices para queries < 100ms
- Pronto para sharding por user_id se necessário

## 🚀 Futuro

Preparado para:
- Tarefas (tasks → subject_id)
- Notas/Grades (grades → subject_id)
- Arquivos (files → subject_id)
- Automações (auto-archive, notifications)

---

**Próximo Passo**: Revisar Specifications
