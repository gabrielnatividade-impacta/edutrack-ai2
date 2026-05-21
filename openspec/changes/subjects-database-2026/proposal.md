# Proposal: Database de Disciplinas (Subjects)

**Data**: 20 de maio de 2026  
**Status**: ✅ Aprovado

---

## 📋 Problema

Usuários do EduTrack AI precisam registrar, gerenciar e compartilhar suas disciplinas acadêmicas com controle fino de acesso e preparação para futuras automações.

## 🎯 Solução Proposta

Criar uma base de dados robusta para disciplinas acadêmicas com:
- Propriedade clara do usuário
- Sistema de permissões granulares
- Metadados acadêmicos completos
- Suporte a automações futuras

## ✨ Benefícios

✅ Usuários podem registrar todas as suas disciplinas  
✅ Controle total sobre acesso (compartilhamento seguro)  
✅ Suporta colaboração entre usuários  
✅ Fundação para features futuras (tarefas, notas, arquivos)  
✅ Auditoria completa de permissões  

## 🔍 Escopo

### Fora de Escopo (Futuro)
- [ ] Gerenciamento de tarefas por disciplina
- [ ] Sistema de notas/grades
- [ ] Armazenamento de arquivos
- [ ] Notificações automáticas
- [ ] Automação de arquivamento

### Dentro de Escopo
- [x] Tabela subjects (disciplinas)
- [x] Tabela subject_permissions (controle de acesso)
- [x] API REST para CRUD
- [x] API para gerenciamento de permissões
- [x] Sistema de autorização (4 níveis)
- [x] Validação de dados
- [x] Documentação completa

## 📊 Requisitos

### Requisitos Funcionais

**RF-1: Criar Disciplina**
- Usuário pode criar uma disciplina com nome obrigatório
- Adicionar metadados opcionais (professor, semestre, créditos, etc.)
- Disciplina é associada ao usuário que criou

**RF-2: Gerenciar Disciplina**
- Usuário dono pode atualizar qualquer campo
- Usuário dono pode deletar a disciplina
- Editor pode atualizar (não deletar)
- Viewer apenas lê

**RF-3: Compartilhar Disciplina**
- Dono pode conceder permissão para outro usuário
- Permissão pode ter data de expiração
- Dono pode revogar permissão a qualquer momento

**RF-4: Filtrar e Buscar**
- Filtrar por status (ativa, concluída, arquivada)
- Filtrar por semestre
- Buscar por nome, código, professor
- Paginação

### Requisitos Não-Funcionais

**RNF-1: Performance**
- 1000+ disciplinas por usuário
- Queries < 100ms

**RNF-2: Segurança**
- JWT para autenticação
- Row-level security
- Audit trail completo

**RNF-3: Confiabilidade**
- Integridade referencial
- Backups regulares
- Dados nunca perdidos

## 💡 Notas

- Design aprovado por arquitetura
- Pronto para implementação imediata
- Todas as dependências mapeadas

---

**Próximo Passo**: Revisar Design
