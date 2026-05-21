# 🎓 EduTrack AI - Base de Dados de Disciplinas (Subjects)

**Especificação completa para gerenciar disciplinas acadêmicas com propriedade do usuário e controle de acesso**

---

## 📋 Resumo Executivo

Uma especificação completa foi criada para permitir que usuários do EduTrack AI:
- ✅ Registrem e gerenciem suas disciplinas acadêmicas
- ✅ Compartilhem disciplinas com outros usuários com controle fino de acesso
- ✅ Organizem disciplinas com metadados (professor, créditos, datas, etc.)
- ✅ Tenham suporte a futuras automações e integrações

**Status**: ✅ **Especificação Completa - Pronto para Implementação**  
**Data de Criação**: 20 de maio de 2026

---

## 📁 O Que Foi Criado

### 7 Documentos de Especificação

1. **SUBJECTS_SUMMARY.md** - Resumo executivo (COMECE AQUI)
2. **SUBJECTS_REFERENCE.md** - Guia de referência cruzada
3. **QUICK_START.md** - Guia rápido por função/papel
4. **ARCHITECTURE.md** - Arquitetura visual do sistema
5. **INDEX.md** - Índice completo
6. **README.md** - Documentação geral

### 4 Arquivos de Especificação Técnica

1. **specs/subjects_database.yaml** - Especificação funcional (O QUE construir)
2. **specs/subjects_implementation.yaml** - Guia técnico (COMO construir)
3. **specs/subjects_schema.sql** - Scripts PostgreSQL prontos para executar
4. **specs/subjects_examples.json** - Dados de exemplo e exemplos de API

### 2 Arquivos Adicionais

1. **changes/subjects_database_20260520.md** - Registro de mudanças
2. **context/system.md** - Contexto do sistema (ATUALIZADO)

**Total**: 13 arquivos criados/atualizados com ~4.500 linhas de especificação

---

## 🎯 O Que Você Precisa Saber

### 1. Estrutura da Base de Dados

#### Tabela: subjects (Disciplinas)
```
17 campos:
- Básico: id, user_id (dono), nome, código
- Acadêmico: professor, semestre, créditos, horas de trabalho
- Cronograma: data_início, data_fim
- Gestão: status (ativa/concluída/arquivada/cancelada)
- Organização: cor (para UI), notas
- Metadados: criado_em, atualizado_em
```

#### Tabela: subject_permissions (Permissões)
```
7 campos:
- Referência: id, subject_id, user_id
- Acesso: permission_type (owner/editor/viewer/commenter)
- Auditoria: concedido_por, criado_em, expira_em
```

### 2. Modelo de Autorização

```
NÍVEIS DE PERMISSÃO:
┌─────────────────────────────────────┐
│ OWNER (Dono)        - Controle total│
│ EDITOR              - Pode editar   │
│ VIEWER              - Apenas leitura│
│ COMMENTER           - Futuro        │
└─────────────────────────────────────┘

REGRA DE ACESSO:
  Usuário pode acessar SE:
    • É dono DA disciplina, OU
    • Tem permissão explícita (não expirada)
```

### 3. API REST

```
9 Endpoints:
POST   /subjects                    - Criar
GET    /subjects                    - Listar (com filtros)
GET    /subjects/:id                - Obter uma
PUT    /subjects/:id                - Atualizar
DELETE /subjects/:id                - Deletar

POST   /subjects/:id/permissions    - Conceder permissão
GET    /subjects/:id/permissions    - Listar permissões
DELETE /subjects/:id/permissions/:user_id - Revogar permissão
```

---

## 🚀 Próximos Passos

### Para Desenvolvedores Backend (50 minutos)
```
1. Ler: SUBJECTS_SUMMARY.md (10 min)
2. Ler: specs/subjects_implementation.yaml (40 min)
3. Referenciar: specs/subjects_examples.json (API)
```

### Para Administradores de Banco de Dados (25 minutos)
```
1. Ler: SUBJECTS_SUMMARY.md (5 min)
2. Executar: specs/subjects_schema.sql (20 min)
```

### Para Engenheiros de QA (25 minutos)
```
1. Ler: SUBJECTS_SUMMARY.md (10 min)
2. Estudar: specs/subjects_examples.json (15 min)
```

### Para Desenvolvedores Frontend (25 minutos)
```
1. Ler: SUBJECTS_SUMMARY.md (10 min)
2. Entender: specs/subjects_examples.json (API) (15 min)
```

### Para Gerentes de Projeto (15 minutos)
```
1. Ler: SUBJECTS_SUMMARY.md
   Foco: Checklist de Implementação e Cronograma
```

---

## 📊 Estatísticas

| Métrica | Valor |
|---------|-------|
| Arquivos criados | 13 |
| Linhas de especificação | 4.500+ |
| Tabelas de banco de dados | 2 |
| Campos de banco de dados | 24 |
| Endpoints de API | 9 |
| Exemplos de API | 10+ |
| Cenários de teste | 20+ |
| Registros de dados de exemplo | 10 |
| Índices de banco de dados | 10+ |
| Restrições de banco de dados | 15+ |
| Funções de banco de dados | 5 |

---

## ✨ Recursos Principais

### 1. Propriedade de Usuário
- Cada disciplina tem um dono claro (quem criou)
- Dono tem controle total
- Dono pode compartilhar com outros

### 2. Compartilhamento Seguro
- Permissões granulares (4 níveis)
- Permissões podem expirar automaticamente
- Rastreamento de auditoria completo

### 3. Metadados Acadêmicos
- Informações do professor (nome, email)
- Semestre/período
- Créditos acadêmicos
- Horas de trabalho
- Datas de início e fim
- Cores customizadas para UI
- Campo de notas flexível

### 4. Integridade de Dados
- Validação de email
- Validação de cores hex
- Validação de datas
- Validação de números
- Restrições de chave estrangeira

### 5. Performance
- 10+ índices otimizados
- Funções de banco de dados eficientes
- Suporte a paginação
- Visualizações pré-construídas

### 6. Pronto para o Futuro
- Hooks de automação
- Preparado para gerenciamento de tarefas
- Preparado para gerenciamento de notas
- Preparado para armazenamento de arquivos

---

## 🏗️ Plano de Implementação

### Fase 1: Banco de Dados (2-4 horas)
- Executar scripts de criação de tabelas
- Criar índices
- Criar funções e triggers

### Fase 2: Backend API (8-16 horas)
- Configurar tabelas no Xano
- Implementar lógica de negócio
- Criar 9 endpoints de API
- Adicionar autenticação e validação

### Fase 3: Testes (4-8 horas)
- Testes de integração
- Testes de autorização
- Testes de erro
- Testes de performance

### Fase 4: Frontend (4-8 horas)
- Atualizar página "Disciplinas" em Streamlit
- Criar formulários CRUD
- Adicionar filtros e busca

### Fase 5: Implantação (2-4 horas)
- Configurar monitoramento
- Configurar backups
- Implantar em produção

**Tempo Total Estimado**: 20-40 horas (equipe completa, trabalho em paralelo)

---

## 🔐 Segurança

```
Autenticação: Token JWT no header
Autorização: Verificação de propriedade + permissões
Validação: Múltiplas camadas (cliente, API, BD)
Integridade: Restrições de chave estrangeira
Auditoria: Rastreamento de quem fez o quê e quando
```

---

## 📚 Documentação Disponível

### Para Começar (5-10 minutos)
- **README.md** - Este arquivo
- **QUICK_START.md** - Guia por função/papel

### Para Entender (15-30 minutos)
- **SUBJECTS_SUMMARY.md** - Resumo executivo
- **SUBJECTS_REFERENCE.md** - Guia de referência

### Para Implementar (45-90 minutos)
- **specs/subjects_implementation.yaml** - Guia técnico
- **specs/subjects_schema.sql** - Scripts SQL
- **specs/subjects_examples.json** - Exemplos de API

### Para Arquitetura (15-20 minutos)
- **ARCHITECTURE.md** - Arquitetura visual
- **INDEX.md** - Índice completo

---

## ✅ O Que Está Pronto

- [x] Design de banco de dados completo
- [x] Especificação de API completa
- [x] Scripts SQL prontos para executar
- [x] Exemplos de API documentados
- [x] Cenários de teste documentados
- [x] Guia de implementação completo
- [x] Plano de implantação com cronograma
- [x] Dados de exemplo para testes

---

## 🎯 Critério de Sucesso

✅ Usuários podem criar disciplinas com suas informações  
✅ Usuários veem apenas disciplinas que possuem ou têm permissão  
✅ Apenas donos podem deletar disciplinas  
✅ Donos podem compartilhar com outros usuários  
✅ Permissões podem expirar automaticamente  
✅ Todos os endpoints tratam erros corretamente  
✅ Integridade de dados é mantida  
✅ Performance é aceitável com 1000+ disciplinas  

---

## 📞 Como Navegar

| Necessidade | Arquivo |
|----------|---------|
| Visão geral rápida | README.md (este) |
| Começar por função | QUICK_START.md |
| Resumo executivo | SUBJECTS_SUMMARY.md |
| Encontrar informação | SUBJECTS_REFERENCE.md |
| Arquitetura | ARCHITECTURE.md |
| Índice completo | INDEX.md |
| Especificação funcional | specs/subjects_database.yaml |
| Guia técnico | specs/subjects_implementation.yaml |
| Scripts SQL | specs/subjects_schema.sql |
| Exemplos de API | specs/subjects_examples.json |

---

## 🚀 Seus Próximos Passos

### Passo 1: Escolha Seu Papel
- Backend Developer?
- Database Admin?
- QA Engineer?
- Frontend Developer?
- Project Manager?

### Passo 2: Leia o Guia Rápido
→ Abra **QUICK_START.md** e encontre sua função

### Passo 3: Leia os Documentos Relevantes
→ Siga as instruções do seu papel

### Passo 4: Comece a Implementar
→ Use os exemplos fornecidos como base

---

## 📋 Checklist de Implementação

### Antes de Desenvolver
- [ ] Ler SUBJECTS_SUMMARY.md
- [ ] Ler documento específico para sua função
- [ ] Entender estrutura de banco de dados
- [ ] Ter specs/subjects_examples.json à mão

### Durante Desenvolvimento
- [ ] Seguir Checklist de Implantação em SUBJECTS_SUMMARY.md
- [ ] Referenciar specs/subjects_implementation.yaml
- [ ] Usar specs/subjects_schema.sql para scripts SQL
- [ ] Usar specs/subjects_examples.json para validação de API

### Antes de Testes
- [ ] Revisar cenários em specs/subjects_implementation.yaml
- [ ] Preparar dados de teste de specs/subjects_examples.json
- [ ] Configurar banco de dados de teste

### Antes de Produção
- [ ] Todos os testes passando
- [ ] Documentação atualizada
- [ ] Monitoramento configurado
- [ ] Backups configurados

---

## 🎓 Tempo de Leitura Estimado

| Documento | Tempo | Para Quem |
|-----------|-------|----------|
| README.md (este) | 5 min | Todos |
| QUICK_START.md | 10-15 min | Todos |
| SUBJECTS_SUMMARY.md | 15 min | Todos |
| specs/subjects_implementation.yaml | 45 min | Devs |
| specs/subjects_schema.sql | 20 min | DBAs |
| specs/subjects_examples.json | 15 min | QA/Devs |

**Total para Compreensão Completa**: 2-3 horas

---

## 💡 Exemplo Rápido

### Criar uma Disciplina
```json
POST /api/subjects
{
  "name": "Data Structures",
  "code": "CS101",
  "professor_name": "Dr. Carlos Santos",
  "semester": "2026/1",
  "credits": 4,
  "workload_hours": 60,
  "start_date": "2026-02-01",
  "end_date": "2026-06-30"
}

Resposta: 201 Created
{
  "id": "uuid-aqui",
  "user_id": "seu-uuid",
  "name": "Data Structures",
  ...tudo que você enviou...
  "status": "active",
  "created_at": "2026-05-20T14:30:00Z"
}
```

### Compartilhar uma Disciplina
```json
POST /api/subjects/{id}/permissions
{
  "user_id": "uuid-outro-usuario",
  "permission_type": "viewer"
}

Resposta: 201 Created
(Outro usuário agora pode ver a disciplina!)
```

---

## 🎯 O Que Você Deve Fazer Agora

1. **Leia este documento** (você está fazendo!) ✓
2. **Abra QUICK_START.md** e encontre sua função
3. **Leia o documento específico** para sua função
4. **Comece a implementar** usando os exemplos

---

## 📞 Precisa de Ajuda?

1. **Visão geral?** → SUBJECTS_SUMMARY.md
2. **Encontrar algo?** → SUBJECTS_REFERENCE.md
3. **Por onde começo?** → QUICK_START.md
4. **Índice completo?** → INDEX.md
5. **Arquitetura?** → ARCHITECTURE.md

---

## ✨ Destaques

- 🎯 **Especificação Completa** - Tudo definido e documentado
- 🔐 **Design Seguro** - JWT, permissões, auditoria
- 📊 **Bem Documentado** - 4.500+ linhas
- 🚀 **Pronto para Produção** - Plano, testes, monitoramento
- 💻 **Amigável para Devs** - Scripts SQL prontos, exemplos de API
- 🔄 **À Prova de Futuro** - Extensível, automações, integração

---

## ✅ Status Final

- ✅ 13 arquivos criados/atualizados
- ✅ 4.500+ linhas de especificação
- ✅ Todas as tabelas de banco de dados definidas
- ✅ Todos os 9 endpoints de API especificados
- ✅ 10+ exemplos de API documentados
- ✅ 20+ cenários de teste documentados
- ✅ Plano de implementação em 5 fases pronto
- ✅ Pronto para implementação imediata

---

## 🎓 Créditos

**Especificação Criada Por**: Gabriel Moreira da Natividade  
**Projeto**: EduTrack AI - Sistema de Gestão Acadêmica  
**Instituição**: Faculdade Impacta  
**Disciplina**: Innovation Lab  
**Data**: 20 de maio de 2026

---

## 🚀 Vamos Começar!

**Próximo passo**: Abra [QUICK_START.md](QUICK_START.md) →

Ou escolha por função:
- [Backend Developer](QUICK_START.md#im-a-backend-developer-20-minutes)
- [Database Admin](QUICK_START.md#im-a-database-admin-15-minutes)
- [QA Engineer](QUICK_START.md#im-a-qa-engineer-15-minutes)
- [Frontend Developer](QUICK_START.md#im-a-frontend-developer-15-minutes)
- [Project Manager](QUICK_START.md#im-a-project-manager-10-minutes)

---

**Tudo está pronto. Vamos construir! 🚀**
