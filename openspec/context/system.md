# System Context
## Overview

This project is an academic management backend built using XanoScript and Spec-
Driven Development.

## Purpose
Allow users to manage academic subjects and related data.
## Core Entities
- Users (native Xano authentication)
- Subjects (academic disciplines owned by users)
- Subject Permissions (fine-grained access control for collaboration)

## Relationships
- Each subject belongs to one user (owner)
- Users can grant permissions to other users for their subjects
- Permissions can have different levels: owner, editor, viewer, commenter
- Permissions can have expiration dates (optional)

## Subjects Features
- **Ownership & Access**: Each user owns their subjects and can control access
- **Rich Metadata**: Includes professor info, semester, credits, workload, dates
- **Status Tracking**: active, completed, archived, cancelled
- **UI Organization**: Custom colors for visual organization
- **Collaboration Ready**: Permission system supports future team features

## Authorization Rules
1. User can only see subjects they own or have explicit permissions for
2. Only owner can delete a subject
3. Only owner can modify permissions
4. Different permission levels enable different access patterns

## Expected Evolution
The system will evolve with:
- APIs for subject CRUD operations
- Task management tied to subjects
- Grades management associated with subjects
- Automation tasks (auto-archive, permission expiration)
- Notifications and audit logging
- Integrations with external systems