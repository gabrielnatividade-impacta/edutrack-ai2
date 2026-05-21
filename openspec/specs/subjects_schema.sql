-- Subjects Database SQL Creation Scripts
-- PostgreSQL dialect
-- Created: 2026-05-20
-- Purpose: Create database tables for academic subject management

-- ============================================================================
-- TABLE: subjects
-- ============================================================================
-- Stores academic subjects/disciplines registered by users
-- Purpose: Allow users to manage their courses and related metadata

CREATE TABLE IF NOT EXISTS subjects (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign Keys
  user_id UUID NOT NULL,
  
  -- Core Information
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50),
  description TEXT,
  
  -- Professor Information
  professor_name VARCHAR(255),
  professor_email VARCHAR(255),
  
  -- Academic Information
  semester VARCHAR(50),
  credits INTEGER CHECK (credits >= 0),
  workload_hours INTEGER CHECK (workload_hours >= 0),
  
  -- Schedule
  start_date DATE,
  end_date DATE CHECK (end_date >= start_date),
  
  -- Status & Metadata
  status VARCHAR(20) NOT NULL DEFAULT 'active' 
    CHECK (status IN ('active', 'completed', 'archived', 'cancelled')),
  color VARCHAR(7),
  notes TEXT,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Constraints
  CONSTRAINT fk_subjects_user FOREIGN KEY (user_id) 
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT unique_code_per_user UNIQUE(user_id, code)
);

-- Indexes for subjects table
CREATE INDEX idx_subjects_user_id ON subjects(user_id);
CREATE INDEX idx_subjects_status ON subjects(status);
CREATE INDEX idx_subjects_created_at ON subjects(created_at DESC);
CREATE INDEX idx_subjects_updated_at ON subjects(updated_at DESC);
CREATE INDEX idx_subjects_start_date ON subjects(start_date);
CREATE INDEX idx_subjects_end_date ON subjects(end_date);

-- ============================================================================
-- TABLE: subject_permissions
-- ============================================================================
-- Manages fine-grained access control for subjects
-- Purpose: Allow subjects to be shared with other users with specific permissions

CREATE TABLE IF NOT EXISTS subject_permissions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign Keys
  subject_id UUID NOT NULL,
  user_id UUID NOT NULL,
  granted_by UUID NOT NULL,
  
  -- Permission Information
  permission_type VARCHAR(20) NOT NULL DEFAULT 'viewer'
    CHECK (permission_type IN ('owner', 'editor', 'viewer', 'commenter')),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP WITH TIME ZONE,
  
  -- Constraints
  CONSTRAINT fk_permissions_subject FOREIGN KEY (subject_id)
    REFERENCES subjects(id) ON DELETE CASCADE,
  CONSTRAINT fk_permissions_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_permissions_granted_by FOREIGN KEY (granted_by)
    REFERENCES users(id) ON DELETE RESTRICT,
  CONSTRAINT unique_permission_per_user UNIQUE(subject_id, user_id),
  CONSTRAINT expires_after_created CHECK (expires_at > created_at OR expires_at IS NULL)
);

-- Indexes for subject_permissions table
CREATE INDEX idx_permissions_subject_id ON subject_permissions(subject_id);
CREATE INDEX idx_permissions_user_id ON subject_permissions(user_id);
CREATE INDEX idx_permissions_granted_by ON subject_permissions(granted_by);
CREATE INDEX idx_permissions_type ON subject_permissions(permission_type);
CREATE INDEX idx_permissions_expires_at ON subject_permissions(expires_at)
  WHERE expires_at IS NOT NULL;

-- ============================================================================
-- TRIGGER: Update updated_at on subjects modification
-- ============================================================================

CREATE OR REPLACE FUNCTION update_subject_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_subject_timestamp
BEFORE UPDATE ON subjects
FOR EACH ROW
EXECUTE FUNCTION update_subject_timestamp();

-- ============================================================================
-- FUNCTION: Check if user can access subject
-- ============================================================================
-- Returns true if user can access the subject with the required permission level
-- Permission hierarchy: owner > editor > viewer > commenter

CREATE OR REPLACE FUNCTION can_access_subject(
  p_subject_id UUID,
  p_user_id UUID,
  p_required_level VARCHAR DEFAULT 'viewer'
)
RETURNS BOOLEAN AS $$
DECLARE
  v_owner_id UUID;
  v_permission_type VARCHAR;
  v_level_value INT;
  v_required_value INT;
BEGIN
  -- Get subject owner
  SELECT user_id INTO v_owner_id FROM subjects WHERE id = p_subject_id;
  
  IF v_owner_id IS NULL THEN
    RETURN FALSE; -- Subject doesn't exist
  END IF;
  
  -- Owner always has access
  IF v_owner_id = p_user_id THEN
    RETURN TRUE;
  END IF;
  
  -- Check explicit permissions
  SELECT permission_type INTO v_permission_type
  FROM subject_permissions
  WHERE subject_id = p_subject_id 
    AND user_id = p_user_id
    AND (expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP);
  
  IF v_permission_type IS NULL THEN
    RETURN FALSE; -- No permission found
  END IF;
  
  -- Map permission levels to numeric values
  CASE v_permission_type
    WHEN 'owner' THEN v_level_value := 4;
    WHEN 'editor' THEN v_level_value := 3;
    WHEN 'commenter' THEN v_level_value := 2;
    WHEN 'viewer' THEN v_level_value := 1;
  END CASE;
  
  CASE p_required_level
    WHEN 'owner' THEN v_required_value := 4;
    WHEN 'editor' THEN v_required_value := 3;
    WHEN 'commenter' THEN v_required_value := 2;
    WHEN 'viewer' THEN v_required_value := 1;
    ELSE v_required_value := 1; -- Default to viewer
  END CASE;
  
  RETURN v_level_value >= v_required_value;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FUNCTION: Get user's accessible subjects
-- ============================================================================
-- Returns all subjects the user owns or has permissions for

CREATE OR REPLACE FUNCTION get_user_subjects(
  p_user_id UUID,
  p_status VARCHAR DEFAULT NULL,
  p_limit INT DEFAULT 100,
  p_offset INT DEFAULT 0
)
RETURNS TABLE(
  id UUID,
  user_id UUID,
  name VARCHAR,
  code VARCHAR,
  description TEXT,
  professor_name VARCHAR,
  professor_email VARCHAR,
  semester VARCHAR,
  credits INT,
  workload_hours INT,
  start_date DATE,
  end_date DATE,
  status VARCHAR,
  color VARCHAR,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
  RETURN QUERY
  SELECT s.id, s.user_id, s.name, s.code, s.description,
         s.professor_name, s.professor_email, s.semester,
         s.credits, s.workload_hours, s.start_date, s.end_date,
         s.status, s.color, s.notes, s.created_at, s.updated_at
  FROM subjects s
  WHERE (
    -- User is owner
    s.user_id = p_user_id
    OR
    -- User has valid permission
    EXISTS (
      SELECT 1 FROM subject_permissions sp
      WHERE sp.subject_id = s.id
        AND sp.user_id = p_user_id
        AND (sp.expires_at IS NULL OR sp.expires_at > CURRENT_TIMESTAMP)
    )
  )
  AND (p_status IS NULL OR s.status = p_status)
  ORDER BY s.updated_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FUNCTION: Auto-complete subjects (scheduled task)
-- ============================================================================
-- Mark subjects as completed when their end_date has passed

CREATE OR REPLACE FUNCTION auto_complete_subjects()
RETURNS TABLE(updated_count INT) AS $$
DECLARE
  v_count INT;
BEGIN
  UPDATE subjects
  SET status = 'completed'
  WHERE status = 'active'
    AND end_date < CURRENT_DATE;
  
  GET DIAGNOSTICS v_count = ROW_COUNT;
  
  RETURN QUERY SELECT v_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FUNCTION: Expire permissions (scheduled task)
-- ============================================================================
-- Remove permissions that have expired

CREATE OR REPLACE FUNCTION expire_permissions()
RETURNS TABLE(deleted_count INT) AS $$
DECLARE
  v_count INT;
BEGIN
  DELETE FROM subject_permissions
  WHERE expires_at IS NOT NULL
    AND expires_at <= CURRENT_TIMESTAMP;
  
  GET DIAGNOSTICS v_count = ROW_COUNT;
  
  RETURN QUERY SELECT v_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- DATA VALIDATION FUNCTIONS
-- ============================================================================

-- Validate email format
CREATE OR REPLACE FUNCTION is_valid_email(email VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Validate hex color format
CREATE OR REPLACE FUNCTION is_valid_hex_color(color VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN color IS NULL OR color ~ '^#[0-9A-Fa-f]{6}$';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================================================
-- AUDIT TABLE (Optional - for logging changes)
-- ============================================================================
-- Uncomment if you want to track all changes to subjects

/*
CREATE TABLE IF NOT EXISTS subjects_audit (
  id BIGSERIAL PRIMARY KEY,
  subject_id UUID NOT NULL,
  action VARCHAR(10) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
  old_data JSONB,
  new_data JSONB,
  changed_by UUID,
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_subjects_audit_subject ON subjects_audit(subject_id);
CREATE INDEX idx_subjects_audit_changed_at ON subjects_audit(changed_at DESC);

CREATE OR REPLACE FUNCTION audit_subject_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO subjects_audit(subject_id, action, old_data, changed_by, changed_at)
    VALUES(OLD.id, 'DELETE', row_to_json(OLD), NULL, CURRENT_TIMESTAMP);
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO subjects_audit(subject_id, action, old_data, new_data, changed_by, changed_at)
    VALUES(NEW.id, 'UPDATE', row_to_json(OLD), row_to_json(NEW), NULL, CURRENT_TIMESTAMP);
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    INSERT INTO subjects_audit(subject_id, action, new_data, changed_by, changed_at)
    VALUES(NEW.id, 'INSERT', row_to_json(NEW), NULL, CURRENT_TIMESTAMP);
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audit_subjects
AFTER INSERT OR UPDATE OR DELETE ON subjects
FOR EACH ROW
EXECUTE FUNCTION audit_subject_changes();
*/

-- ============================================================================
-- DATA INTEGRITY CHECKS
-- ============================================================================

-- Check that professor_email is valid if provided
ALTER TABLE subjects
ADD CONSTRAINT check_email_format
CHECK (professor_email IS NULL OR is_valid_email(professor_email));

-- Check that color is valid hex if provided
ALTER TABLE subjects
ADD CONSTRAINT check_color_format
CHECK (is_valid_hex_color(color));

-- ============================================================================
-- VIEWS (Optional - for simplified access patterns)
-- ============================================================================

-- View for active subjects
CREATE OR REPLACE VIEW active_subjects AS
SELECT * FROM subjects
WHERE status = 'active'
  AND (end_date IS NULL OR end_date >= CURRENT_DATE);

-- View for completed subjects
CREATE OR REPLACE VIEW completed_subjects AS
SELECT * FROM subjects
WHERE status = 'completed';

-- View for user subject access (includes shared subjects)
CREATE OR REPLACE VIEW user_subject_access AS
SELECT DISTINCT
  s.id,
  s.user_id AS owner_id,
  sp.user_id AS accessible_to_user,
  COALESCE(sp.permission_type, 'owner') AS permission_type,
  s.name,
  s.code,
  s.status,
  s.created_at
FROM subjects s
LEFT JOIN subject_permissions sp ON s.id = sp.subject_id
WHERE sp.expires_at IS NULL OR sp.expires_at > CURRENT_TIMESTAMP;

-- ============================================================================
-- SAMPLE QUERIES
-- ============================================================================

/*
-- Get all subjects for a user
SELECT * FROM get_user_subjects('user-uuid-here'::UUID);

-- Get active subjects for a user
SELECT * FROM get_user_subjects('user-uuid-here'::UUID, 'active');

-- Check if user can edit a subject
SELECT can_access_subject('subject-uuid'::UUID, 'user-uuid'::UUID, 'editor');

-- Auto-complete subjects
SELECT * FROM auto_complete_subjects();

-- Expire old permissions
SELECT * FROM expire_permissions();

-- Get subjects coming up in next 7 days
SELECT * FROM subjects
WHERE user_id = 'user-uuid'::UUID
  AND start_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
ORDER BY start_date;

-- Get subjects by semester
SELECT * FROM subjects
WHERE user_id = 'user-uuid'::UUID
  AND semester = '2026/1'
ORDER BY name;
*/
