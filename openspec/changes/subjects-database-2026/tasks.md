# Tasks: Database de Disciplinas (Subjects)

**Data**: 20 de maio de 2026  
**Status**: ✅ Pronto para Implementação

---

## 📋 Tarefas de Implementação

Siga a ordem abaixo. Marque com `[x]` ao completar cada tarefa.

---

## FASE 1: Setup do Banco de Dados (Xano)

**Objetivo**: Criar estrutura de dados em Xano

### [ ] Task 1.1: Criar Tabela `subjects`

- [ ] Criar collection "subjects" em Xano
- [ ] Adicionar campo `id` (UUID, PK, auto-gerado)
- [ ] Adicionar campo `user_id` (UUID, FK → users.id)
- [ ] Adicionar campo `name` (VARCHAR 255, obrigatório)
- [ ] Adicionar campo `code` (VARCHAR 50, opcional)
- [ ] Adicionar campo `description` (TEXT)
- [ ] Adicionar campo `professor_name` (VARCHAR 255)
- [ ] Adicionar campo `professor_email` (VARCHAR 255)
- [ ] Adicionar campo `semester` (VARCHAR 50)
- [ ] Adicionar campo `credits` (INTEGER, default 0)
- [ ] Adicionar campo `workload_hours` (INTEGER, default 0)
- [ ] Adicionar campo `start_date` (DATE)
- [ ] Adicionar campo `end_date` (DATE)
- [ ] Adicionar campo `status` (VARCHAR 20, default "active")
- [ ] Adicionar campo `color` (VARCHAR 7)
- [ ] Adicionar campo `notes` (TEXT)
- [ ] Adicionar campo `created_at` (TIMESTAMP, auto-current_timestamp)
- [ ] Adicionar campo `updated_at` (TIMESTAMP, auto-current_timestamp)
- [ ] **Teste**: Criar 1 subject de teste, verificar todos os campos

### [ ] Task 1.2: Criar Tabela `subject_permissions`

- [ ] Criar collection "subject_permissions" em Xano
- [ ] Adicionar campo `id` (UUID, PK, auto-gerado)
- [ ] Adicionar campo `subject_id` (UUID, FK → subjects.id)
- [ ] Adicionar campo `user_id` (UUID, FK → users.id)
- [ ] Adicionar campo `permission_type` (VARCHAR 20, required)
- [ ] Adicionar campo `granted_by` (UUID, FK → users.id)
- [ ] Adicionar campo `created_at` (TIMESTAMP, auto-current_timestamp)
- [ ] Adicionar campo `expires_at` (TIMESTAMP, nullable)
- [ ] **Teste**: Criar 1 permission de teste

### [ ] Task 1.3: Criar Índices (Performance)

- [ ] Índice em subjects(user_id)
- [ ] Índice em subjects(status)
- [ ] Índice em subjects(created_at DESC)
- [ ] Índice em subject_permissions(subject_id)
- [ ] Índice em subject_permissions(user_id)
- [ ] Índice em subject_permissions(permission_type)
- [ ] Índice em subject_permissions(expires_at)
- [ ] **Teste**: Executar query de listagem, medir tempo < 100ms

### [ ] Task 1.4: Criar Business Logic Functions

- [ ] Função `can_access_subject(user_id, subject_id)`
  - Verifica se user pode ler a disciplina
  - Retorna: true/false
  - Lógica: owner OU permission ≥ viewer (não expirada)
  
- [ ] Função `can_edit_subject(user_id, subject_id)`
  - Verifica se user pode editar a disciplina
  - Retorna: true/false
  - Lógica: owner OU permission = editor (não expirada)
  
- [ ] Função `can_delete_subject(user_id, subject_id)`
  - Verifica se user pode deletar a disciplina
  - Retorna: true/false
  - Lógica: owner ONLY
  
- [ ] Função `get_user_subjects(user_id)`
  - Retorna todas as disciplinas do usuário (owned + shared)
  - Retorna: [subjects]
  - Aplicar filtros de expiração
  
- [ ] Função `auto_revoke_expired_permissions()`
  - Deleta permissions com expires_at no passado
  - Retorna: count deletado
  - Rodar em cron job diariamente
  
- [ ] **Teste**: Testar cada função com dados de teste

---

## FASE 2: Endpoints de API (Xano)

**Objetivo**: Implementar 9 endpoints REST

### [ ] Task 2.1: POST /api/subjects (Criar)

- [ ] Criar endpoint POST `/api/subjects`
- [ ] Validar token JWT (Authorization header)
- [ ] Extrair user_id do token
- [ ] Validar body JSON (name obrigatório)
- [ ] Validar code se fornecido (único por user)
- [ ] Validar email do professor se fornecido
- [ ] Validar color se fornecido (hex format)
- [ ] Inserir em database com created_at/updated_at
- [ ] Retornar 201 + subject criado
- [ ] **Teste**: POST com dados válidos, verificar 201

### [ ] Task 2.2: GET /api/subjects (Listar)

- [ ] Criar endpoint GET `/api/subjects`
- [ ] Validar token JWT
- [ ] Extrair user_id do token
- [ ] Aplicar filtros: status, semester
- [ ] Aplicar sort: order_by, sort
- [ ] Aplicar paginação: limit, offset
- [ ] Retornar subjects do user (owned + shared)
- [ ] Retornar 200 + count + data[]
- [ ] **Teste**: GET com filtros, verificar resultados corretos

### [ ] Task 2.3: GET /api/subjects/:id (Obter)

- [ ] Criar endpoint GET `/api/subjects/:id`
- [ ] Validar token JWT
- [ ] Validar que subject existe
- [ ] Chamar can_access_subject() para validar acesso
- [ ] Incluir permissions object na response (can_read, can_edit, etc)
- [ ] Retornar 200 ou 403 Forbidden
- [ ] **Teste**: GET como owner, GET como viewer, GET sem access

### [ ] Task 2.4: PUT /api/subjects/:id (Atualizar)

- [ ] Criar endpoint PUT `/api/subjects/:id`
- [ ] Validar token JWT
- [ ] Validar que subject existe
- [ ] Chamar can_edit_subject() para validar acesso
- [ ] Validar campos atualizáveis (todos exceto id, user_id, created_at)
- [ ] Validar status enum values
- [ ] Atualizar updated_at automaticamente
- [ ] Retornar 200 + subject atualizado
- [ ] Retornar 403 se sem acesso
- [ ] **Teste**: PUT como owner (sucesso), PUT como viewer (403)

### [ ] Task 2.5: DELETE /api/subjects/:id (Deletar)

- [ ] Criar endpoint DELETE `/api/subjects/:id`
- [ ] Validar token JWT
- [ ] Validar que subject existe
- [ ] Chamar can_delete_subject() para validar acesso (owner only)
- [ ] Deletar subject (cascade → deleta permissions também)
- [ ] Retornar 204 No Content
- [ ] Retornar 403 se não é owner
- [ ] **Teste**: DELETE como owner (sucesso), DELETE como editor (403)

### [ ] Task 2.6: POST /api/subjects/:id/permissions (Conceder)

- [ ] Criar endpoint POST `/api/subjects/:id/permissions`
- [ ] Validar token JWT
- [ ] Validar que subject existe
- [ ] Validar que user é owner (can_manage_permissions)
- [ ] Validar permission_type enum [owner, editor, commenter, viewer]
- [ ] Validar que target user existe
- [ ] Checar se permission já existe → erro 409
- [ ] Criar permission com granted_by = current_user
- [ ] Retornar 201 + permission
- [ ] **Teste**: POST com viewer permission, verificar created

### [ ] Task 2.7: GET /api/subjects/:id/permissions (Listar)

- [ ] Criar endpoint GET `/api/subjects/:id/permissions`
- [ ] Validar token JWT
- [ ] Validar que subject existe
- [ ] Validar que user é owner
- [ ] Retornar lista de permissions (excluir expiradas)
- [ ] Incluir user names junto com user_ids
- [ ] Retornar 200 + count + data[]
- [ ] **Teste**: GET como owner (sucesso), GET como viewer (403)

### [ ] Task 2.8: DELETE /api/subjects/:id/permissions/:user_id (Revogar)

- [ ] Criar endpoint DELETE `/api/subjects/:id/permissions/:user_id`
- [ ] Validar token JWT
- [ ] Validar que subject existe
- [ ] Validar que user é owner
- [ ] Validar que permission existe
- [ ] Validar que não é revogar own owner permission
- [ ] Deletar permission
- [ ] Retornar 204 No Content
- [ ] **Teste**: DELETE permission válida (sucesso), DELETE own (erro)

### [ ] Task 2.9: GET /api/subjects/permissions/me (Compartilhadas)

- [ ] Criar endpoint GET `/api/subjects/permissions/me`
- [ ] Validar token JWT
- [ ] Extrair user_id
- [ ] Retornar subjects compartilhados COMIGO (não minhas)
- [ ] Incluir info do owner em cada
- [ ] Retornar 200 + count + data[]
- [ ] **Teste**: Como user com 2+ shared subjects

---

## FASE 3: Testes Funcionais (QA)

**Objetivo**: Validar todas as funcionalidades

### [ ] Task 3.1: Testes de CRUD

- [ ] ✓ Criar subject com todos os campos
- [ ] ✓ Ler subject como owner
- [ ] ✓ Listar subjects com paginação
- [ ] ✓ Atualizar subject (alguns campos)
- [ ] ✓ Deletar subject
- [ ] ✓ Verificar cascade delete de permissions

### [ ] Task 3.2: Testes de Acesso/Autorização

- [ ] ✓ Owner pode READ, EDIT, DELETE, MANAGE PERMS
- [ ] ✓ Editor pode READ, EDIT (não DELETE)
- [ ] ✓ Viewer pode READ (não EDIT/DELETE)
- [ ] ✓ Non-shared user não pode READ
- [ ] ✓ Non-authenticated request retorna 401

### [ ] Task 3.3: Testes de Validação

- [ ] ✓ Name obrigatório (erro se vazio)
- [ ] ✓ Code único por user (erro se duplicado)
- [ ] ✓ Email válido ou vazio (erro se inválido)
- [ ] ✓ Color válido hex ou vazio (erro se inválido)
- [ ] ✓ Credits, workload_hours ≥ 0 (erro se negativo)
- [ ] ✓ start_date ≤ end_date (erro se inverted)
- [ ] ✓ Status enum values (erro se inválido)

### [ ] Task 3.4: Testes de Permissões

- [ ] ✓ Grant permission (novo usuário acessa)
- [ ] ✓ Revoke permission (usuário perde acesso)
- [ ] ✓ Permission expirada nega acesso
- [ ] ✓ Upgrade permission (viewer → editor)
- [ ] ✓ Não pode grant permission sem ser owner

### [ ] Task 3.5: Testes de Performance

- [ ] ✓ List subjects: < 200ms (1000 subjects)
- [ ] ✓ Get subject: < 100ms
- [ ] ✓ Create subject: < 100ms
- [ ] ✓ Update subject: < 100ms
- [ ] ✓ Delete subject: < 100ms

### [ ] Task 3.6: Testes Edge Cases

- [ ] ✓ Subject with null optional fields
- [ ] ✓ Concurrent updates (last write wins)
- [ ] ✓ Delete subject with multiple permissions
- [ ] ✓ User sharing with self (error)
- [ ] ✓ Very long strings (truncated or error)

---

## FASE 4: Integração Frontend (Streamlit)

**Objetivo**: Conectar API com interface

### [ ] Task 4.1: Atualizar Página "Disciplinas"

- [ ] Importar funções de API no arquivo correspondente
- [ ] Criar componente para listar subjects (com filtros)
- [ ] Criar formulário para criar nova subject
- [ ] Criar modal para editar subject
- [ ] Adicionar botão Delete com confirmação
- [ ] **Teste**: Verificar que CRUD funciona via interface

### [ ] Task 4.2: UI de Permissões

- [ ] Criar interface para compartilhar subject
- [ ] Dropdown para selecionar permission_type
- [ ] Input para buscar/selecionar usuário
- [ ] Modal para listar permissões
- [ ] Botão para revogar permission
- [ ] **Teste**: Compartilhar disciplina, verificar acesso do outro user

### [ ] Task 4.3: Listagem de Compartilhadas

- [ ] Adicionar seção "Disciplinas Compartilhadas Comigo"
- [ ] Chamar GET /api/subjects/permissions/me
- [ ] Mostrar owner e permission_type
- [ ] **Teste**: Verificar que lista está correta

### [ ] Task 4.4: Filtros e Busca

- [ ] Implementar filtro por status
- [ ] Implementar filtro por semester
- [ ] Implementar busca por name/code
- [ ] Implementar ordenação (created_at, name, start_date)
- [ ] **Teste**: Aplicar filtros, verificar resultados

---

## RESUMO DE DEPENDÊNCIAS

```
FASE 1 (Database) é pré-requisito para FASES 2, 3, 4
FASE 2 (Endpoints) é pré-requisito para FASE 3 e 4
FASE 3 (QA) deve rodar em paralelo com FASE 2
FASE 4 (Frontend) é pós-requisito de FASE 2 + 3
```

---

## CHECKLIST FINAL

- [ ] ✓ Todas as tasks FASE 1 completadas
- [ ] ✓ Todas as tasks FASE 2 completadas
- [ ] ✓ Todas as tasks FASE 3 completadas
- [ ] ✓ Todas as tasks FASE 4 completadas
- [ ] ✓ Nenhum bug crítico aberto
- [ ] ✓ Documentação atualizada
- [ ] ✓ Pronto para produção

---

**Status**: ✅ Aguardando inicio de implementação  
**Próximo Passo**: Executar `/opsx:apply` para aprovação formal
