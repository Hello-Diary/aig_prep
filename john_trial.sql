CREATE TABLE users (
    user_id UUID NOT NULL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE journals (
    journal_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    content TEXT NOT NULL,
    status ENUM('DRAFT', 'SUBMITTED') NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    submitted_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE feedback_templates (
    template_id UUID PRIMARY KEY,
    error_type VARCHAR(50) NOT NULL,         -- GRAMMAR, VOCABULARY, STYLE
    category VARCHAR(50),                    -- TENSE, ARTICLE, etc.
    issue_text TEXT NOT NULL,
    suggestion TEXT NOT NULL,
    explanation TEXT
);

CREATE TABLE feedbacks (
    feedback_id UUID PRIMARY KEY,
    journal_id UUID NOT NULL,
    template_id UUID NOT NULL,
    original_text TEXT NOT NULL,
    suggested_text TEXT NOT NULL,
    explanation TEXT,
    user_notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (journal_id) REFERENCES journals(journal_id) ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES feedback_templates(template_id) ON DELETE SET NULL
);

CREATE TABLE flashcards (
    flashcard_id UUID NOT NULL PRIMARY KEY,
    user_id UUID NOT NULL,
    source_feedback_id UUID NULL,
    word VARCHAR(255) NOT NULL,
    definition TEXT,
    example TEXT,
    level ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED'),
    created_from ENUM('MISTAKE', 'NEW_WORD', 'MANUAL') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (source_feedback_id) REFERENCES feedbacks(feedback_id) ON DELETE SET NULL
);

CREATE TABLE progress_snapshots (
    snapshot_id UUID NOT NULL PRIMARY KEY,
    user_id UUID NOT NULL,
    taken_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    journal_count INT NOT NULL DEFAULT 0,
    unique_word_count INT NOT NULL DEFAULT 0,
    error_rate FLOAT NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE llm_interaction_logs (
    log_id UUID NOT NULL PRIMARY KEY,
    user_id UUID NOT NULL,
    journal_id UUID NULL,
    request_payload JSON NOT NULL,
    response_payload JSON,
    latency_ms INT,
    cost_usd DECIMAL(10, 6),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (journal_id) REFERENCES journals(journal_id)
);
