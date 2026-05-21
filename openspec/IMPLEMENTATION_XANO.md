# Subjects Database - Implementação Backend em Xano

**Guia passo-a-passo para implementar a API REST no Xano**

Criado: 20 de maio de 2026  
Status: Pronto para implementação

---

## 🎯 Visão Geral

Este guia orienta a implementação da API de Subjects no Xano, seguindo a especificação em `specs/subjects_implementation.yaml`.

### Estrutura
1. Configuração de tabelas
2. Implementação de funções de negócio
3. Criação de endpoints da API
4. Testes de integração

### Tempo Estimado
- Setup de tabelas: 1-2 horas
- Implementação de endpoints: 6-10 horas
- Testes: 2-4 horas
- **Total: 9-16 horas**

---

## 📋 Pré-requisitos

✅ Acesso ao Xano (back-end)  
✅ Banco de dados PostgreSQL criado (com `specs/subjects_schema.sql`)  
✅ Especificação lida: `specs/subjects_implementation.yaml`  
✅ Exemplos consultados: `specs/subjects_examples.json`  

---

## 🗄️ Fase 1: Configuração de Tabelas no Xano

### Passo 1.1: Criar Tabela `subjects`

**No Xano Backend → Data**:

1. Criar nova tabela: `subjects`
2. Adicionar campos conforme abaixo:

```
subjects Table Configuration
────────────────────────────

Field Name          | Type      | Required | Properties
──────────────────────────────────────────────────────────
id                  | Text      | Yes      | UUID, Primary Key, Indexed
user_id             | Text      | Yes      | UUID, Indexed, Foreign Key
name                | Text      | Yes      | Max 255 chars, Searchable
code                | Text      | No       | Max 50 chars, Indexed
description         | Text      | No       | Max 5000 chars
professor_name      | Text      | No       | Max 255 chars
professor_email     | Text      | No       | Max 255 chars, Email validation
semester            | Text      | No       | Max 50 chars
credits             | Number    | No       | Min: 0
workload_hours      | Number    | No       | Min: 0
start_date          | Date      | No       | 
end_date            | Date      | No       | Validation: >= start_date
status              | Text      | Yes      | Default: "active"
                    |           |          | Enum: active, completed, archived, cancelled
color               | Text      | No       | Max 7 chars, Hex validation
notes               | Text      | No       | Max 5000 chars
created_at          | DateTime  | Yes      | Default: now()
updated_at          | DateTime  | Yes      | Default: now()
```

**Após criar**: Adicione índices
```
Indexes:
- user_id (for filtering)
- status (for filtering)
- created_at DESC (for sorting)
```

---

### Passo 1.2: Criar Tabela `subject_permissions`

**No Xano Backend → Data**:

1. Criar nova tabela: `subject_permissions`
2. Adicionar campos:

```
subject_permissions Table Configuration
──────────────────────────────────────

Field Name          | Type      | Required | Properties
──────────────────────────────────────────────────────────
id                  | Text      | Yes      | UUID, Primary Key, Indexed
subject_id          | Text      | Yes      | UUID, Indexed, Foreign Key
user_id             | Text      | Yes      | UUID, Indexed, Foreign Key
permission_type     | Text      | Yes      | Default: "viewer"
                    |           |          | Enum: owner, editor, viewer, commenter
granted_by          | Text      | Yes      | UUID, Foreign Key
created_at          | DateTime  | Yes      | Default: now()
expires_at          | DateTime  | No       | Optional expiration
```

**Após criar**: Adicione índices
```
Indexes:
- subject_id (for filtering)
- user_id (for filtering)
- permission_type (for filtering)
- expires_at (for expiration cleanup)
```

**Unique Constraint**:
```
(subject_id, user_id) - One permission per user per subject
```

---

## 🔧 Fase 2: Implementação de Funções de Negócio

### Função 1: `can_access_subject(subject_id, user_id, permission_level)`

**Objetivo**: Verificar se um usuário pode acessar um subject com o nível de permissão necessário

**Entrada**:
- `subject_id` (text)
- `user_id` (text)
- `permission_level` (text): "read", "write", "delete"

**Saída**: Boolean

**Lógica**:

```javascript
// Passo 1: Obter o subject
let subject = await xano.get("subjects", {
  id: subject_id
});

if (!subject) {
  return false; // Subject not found
}

// Passo 2: Verificar propriedade
if (subject.user_id === user_id) {
  return true; // Owner always has access
}

// Passo 3: Verificar permissões explícitas
let permission = await xano.query("subject_permissions", {
  where: {
    subject_id: subject_id,
    user_id: user_id,
    // Exclude expired
    "expires_at > now() OR expires_at IS NULL"
  }
});

if (!permission) {
  return false; // No permission found
}

// Passo 4: Verificar nível de permissão
let level_map = {
  "owner": 4,
  "editor": 3,
  "commenter": 2,
  "viewer": 1
};

let required_level = {
  "read": 1,
  "write": 3,
  "delete": 4
};

let user_level = level_map[permission.permission_type] || 0;
let required = required_level[permission_level] || 1;

return user_level >= required;
```

---

### Função 2: `get_user_subjects(user_id, filters)`

**Objetivo**: Obter todas as disciplinas acessíveis ao usuário

**Entrada**:
- `user_id` (text)
- `filters` (object): {status, semester, search}

**Saída**: Array de subjects

**Lógica**:

```javascript
// Passo 1: Query de disciplinas do usuário
let query = {
  where: {
    user_id: user_id
  }
};

// Passo 2: Aplicar filtros
if (filters.status) {
  query.where.status = filters.status;
}

if (filters.semester) {
  query.where.semester = filters.semester;
}

if (filters.search) {
  // Search em name, code, professor_name
  query.where = {
    ...query.where,
    OR: [
      { name: { contains: filters.search } },
      { code: { contains: filters.search } },
      { professor_name: { contains: filters.search } }
    ]
  };
}

// Passo 3: Ordenar por updated_at DESC
query.order = { updated_at: "desc" };

// Passo 4: Executar query
let subjects = await xano.query("subjects", query);

return subjects;
```

---

### Função 3: `validate_subject_dates(start_date, end_date)`

**Objetivo**: Validar coerência de datas

**Entrada**:
- `start_date` (date, optional)
- `end_date` (date, optional)

**Saída**: {valid: boolean, error: string}

**Lógica**:

```javascript
// Se ambas nulas, válido
if (!start_date && !end_date) {
  return { valid: true };
}

// Se apenas uma está preenchida, válido
if (!start_date || !end_date) {
  return { valid: true };
}

// Se start_date > end_date, inválido
if (new Date(start_date) > new Date(end_date)) {
  return {
    valid: false,
    error: "start_date must be before or equal to end_date"
  };
}

return { valid: true };
```

---

### Função 4: `validate_email(email)`

**Objetivo**: Validar formato de email

**Entrada**: `email` (text)

**Saída**: Boolean

**Lógica**:

```javascript
const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$/;
return emailRegex.test(email);
```

---

### Função 5: `validate_hex_color(color)`

**Objetivo**: Validar formato de cor hexadecimal

**Entrada**: `color` (text)

**Saída**: Boolean

**Lógica**:

```javascript
// Aceita null ou formato #RRGGBB
if (!color) return true;

const hexRegex = /^#[0-9A-Fa-f]{6}$/;
return hexRegex.test(color);
```

---

## 🔌 Fase 3: Criação de Endpoints da API

### Endpoint 1: POST /api/subjects

**Objetivo**: Criar nova disciplina

**Autenticação**: JWT requerido

**Request Body**:
```json
{
  "name": "string (required)",
  "code": "string (optional)",
  "description": "string (optional)",
  "professor_name": "string (optional)",
  "professor_email": "string (optional)",
  "semester": "string (optional)",
  "credits": "number (optional)",
  "workload_hours": "number (optional)",
  "start_date": "date (optional)",
  "end_date": "date (optional)",
  "color": "string (optional, hex)",
  "notes": "string (optional)"
}
```

**Validações**:
1. ✅ name é obrigatório e não vazio
2. ✅ professor_email válido (se fornecido)
3. ✅ color é hex válido (se fornecido)
4. ✅ credits ≥ 0 (se fornecido)
5. ✅ workload_hours ≥ 0 (se fornecido)
6. ✅ start_date ≤ end_date (se ambos fornecidos)
7. ✅ code é único por usuário (se fornecido)

**Response**: 201 Created
```json
{
  "id": "uuid",
  "user_id": "seu-uuid-aqui",
  "name": "Data Structures",
  "code": "CS101",
  "description": "...",
  "professor_name": "Dr. Carlos",
  "professor_email": "carlos@edu.com",
  "semester": "2026/1",
  "credits": 4,
  "workload_hours": 60,
  "start_date": "2026-02-01",
  "end_date": "2026-06-30",
  "status": "active",
  "color": "#FF5733",
  "notes": "...",
  "created_at": "2026-05-20T14:30:00Z",
  "updated_at": "2026-05-20T14:30:00Z"
}
```

**Error**: 400 Bad Request
```json
{
  "success": false,
  "errors": [
    {
      "field": "professor_email",
      "message": "Invalid email format"
    }
  ]
}
```

---

### Endpoint 2: GET /api/subjects

**Objetivo**: Listar disciplinas do usuário com filtros

**Autenticação**: JWT requerido

**Query Parameters**:
- `status`: "active" | "completed" | "archived" | "cancelled"
- `semester`: "2026/1" (exemplo)
- `search`: "Data Structures" (busca em name, code, professor)
- `limit`: número (default: 20, max: 100)
- `offset`: número (default: 0)

**Response**: 200 OK
```json
{
  "success": true,
  "data": {
    "total": 3,
    "limit": 20,
    "offset": 0,
    "items": [
      {
        "id": "uuid",
        "name": "Data Structures",
        "code": "CS101",
        "professor_name": "Dr. Carlos",
        "semester": "2026/1",
        "status": "active",
        "color": "#FF5733",
        "start_date": "2026-02-01",
        "end_date": "2026-06-30",
        "credits": 4
      }
    ]
  }
}
```

---

### Endpoint 3: GET /api/subjects/:id

**Objetivo**: Obter detalhes de uma disciplina

**Autenticação**: JWT requerido

**Autorização**: User é dono OU tem permissão

**Response**: 200 OK
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "name": "Data Structures",
    "code": "CS101",
    "description": "Comprehensive study...",
    "professor_name": "Dr. Carlos",
    "professor_email": "carlos@edu.com",
    "semester": "2026/1",
    "credits": 4,
    "workload_hours": 60,
    "start_date": "2026-02-01",
    "end_date": "2026-06-30",
    "status": "active",
    "color": "#FF5733",
    "notes": "...",
    "created_at": "2026-01-15T10:30:00Z",
    "updated_at": "2026-05-20T14:22:00Z"
  }
}
```

**Error**: 404 Not Found
```json
{
  "success": false,
  "error": "Subject not found"
}
```

**Error**: 403 Forbidden
```json
{
  "success": false,
  "error": "You don't have access to this subject"
}
```

---

### Endpoint 4: PUT /api/subjects/:id

**Objetivo**: Atualizar disciplina

**Autenticação**: JWT requerido

**Autorização**: User é dono OU tem permission_type="editor"

**Request Body**: (todos os campos opcionais)
```json
{
  "name": "string (optional)",
  "code": "string (optional)",
  "description": "string (optional)",
  "professor_name": "string (optional)",
  "professor_email": "string (optional)",
  "semester": "string (optional)",
  "credits": "number (optional)",
  "workload_hours": "number (optional)",
  "start_date": "date (optional)",
  "end_date": "date (optional)",
  "status": "string (optional)",
  "color": "string (optional)",
  "notes": "string (optional)"
}
```

**Response**: 200 OK
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    ...todos os campos atualizados...
    "updated_at": "2026-05-20T15:00:00Z"
  }
}
```

---

### Endpoint 5: DELETE /api/subjects/:id

**Objetivo**: Deletar disciplina

**Autenticação**: JWT requerido

**Autorização**: User é dono (exclusive)

**Response**: 204 No Content

**Error**: 403 Forbidden
```json
{
  "success": false,
  "error": "Only the owner can delete this subject"
}
```

---

### Endpoint 6: POST /api/subjects/:id/permissions

**Objetivo**: Conceder permissão para outro usuário

**Autenticação**: JWT requerido

**Autorização**: User é dono

**Request Body**:
```json
{
  "user_id": "uuid-outro-usuario",
  "permission_type": "viewer" | "commenter" | "editor",
  "expires_at": "2026-06-30T23:59:59Z (optional)"
}
```

**Response**: 201 Created
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "subject_id": "uuid",
    "user_id": "uuid-outro-usuario",
    "permission_type": "viewer",
    "granted_by": "seu-uuid",
    "created_at": "2026-05-20T15:00:00Z",
    "expires_at": null
  }
}
```

---

### Endpoint 7: GET /api/subjects/:id/permissions

**Objetivo**: Listar permissões de uma disciplina

**Autenticação**: JWT requerido

**Autorização**: User é dono

**Response**: 200 OK
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "subject_id": "uuid",
      "user_id": "uuid-outro-usuario",
      "user_name": "Ana Silva",
      "permission_type": "viewer",
      "granted_by": "seu-uuid",
      "created_at": "2026-05-15T10:00:00Z",
      "expires_at": null
    }
  ]
}
```

---

### Endpoint 8: DELETE /api/subjects/:id/permissions/:user_id

**Objetivo**: Revogar permissão

**Autenticação**: JWT requerido

**Autorização**: User é dono

**Response**: 204 No Content

---

## 🧪 Fase 4: Testes

### Testes de Integração

**Teste 1: Criar disciplina**
```
POST /api/subjects
Body: {"name": "Data Structures", "professor_name": "Dr. Carlos"}
Esperado: 201 Created com id gerado
```

**Teste 2: Listar disciplinas**
```
GET /api/subjects
Esperado: 200 OK com array de disciplinas do usuário
```

**Teste 3: Obter disciplina**
```
GET /api/subjects/{id}
Esperado: 200 OK com detalhes
```

**Teste 4: Atualizar disciplina**
```
PUT /api/subjects/{id}
Body: {"notes": "Novo note"}
Esperado: 200 OK com updated_at atualizado
```

**Teste 5: Compartilhar disciplina**
```
POST /api/subjects/{id}/permissions
Body: {"user_id": "outro-uuid", "permission_type": "viewer"}
Esperado: 201 Created com permission id
```

**Teste 6: Usuário com permissão pode ver**
```
GET /api/subjects/{id} (como outro usuário com permissão)
Esperado: 200 OK
```

**Teste 7: Usuário sem permissão não pode ver**
```
GET /api/subjects/{id} (como usuário sem permissão)
Esperado: 403 Forbidden
```

**Teste 8: Deletar disciplina**
```
DELETE /api/subjects/{id}
Esperado: 204 No Content
Verificar: permissões também foram deletadas (cascade)
```

---

## ✅ Checklist de Implementação

### Tabelas
- [ ] Tabela `subjects` criada com 17 campos
- [ ] Tabela `subject_permissions` criada com 7 campos
- [ ] Índices criados
- [ ] Unique constraints criados

### Funções
- [ ] `can_access_subject()` implementada
- [ ] `get_user_subjects()` implementada
- [ ] `validate_subject_dates()` implementada
- [ ] `validate_email()` implementada
- [ ] `validate_hex_color()` implementada

### Endpoints
- [ ] POST /api/subjects
- [ ] GET /api/subjects
- [ ] GET /api/subjects/:id
- [ ] PUT /api/subjects/:id
- [ ] DELETE /api/subjects/:id
- [ ] POST /api/subjects/:id/permissions
- [ ] GET /api/subjects/:id/permissions
- [ ] DELETE /api/subjects/:id/permissions/:user_id

### Testes
- [ ] Todos os endpoints testados
- [ ] Autorização testada
- [ ] Validação testada
- [ ] Erros testados

---

## 📞 Referências

- Especificação completa: `specs/subjects_implementation.yaml`
- Exemplos de API: `specs/subjects_examples.json`
- SQL scripts: `specs/subjects_schema.sql` (para referência)
- Database design: `specs/subjects_database.yaml`

---

**Próximo Passo**: Após completar implementação backend, prosseguir com integração frontend em Streamlit.
