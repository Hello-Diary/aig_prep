CREATE TABLE users (
                       user_id UUID PRIMARY KEY,
                       email VARCHAR(255) UNIQUE NOT NULL,
                       name VARCHAR(100) NOT NULL,
                       role VARCHAR(50) DEFAULT 'USER',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE journals (
                          journal_id UUID PRIMARY KEY,
                          user_id UUID NOT NULL,
                          content TEXT NOT NULL,
                          submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
                           user_notes TEXT,
                           FOREIGN KEY (journal_id) REFERENCES journals(journal_id) ON DELETE CASCADE,
                           FOREIGN KEY (template_id) REFERENCES feedback_templates(template_id) ON DELETE CASCADE
);

CREATE TABLE flashcards (
                            flashcard_id UUID PRIMARY KEY,
                            user_id UUID NOT NULL,
                            source_feedback_id UUID,
                            word VARCHAR(255) NOT NULL,
                            definition TEXT,
                            example TEXT,
                            created_from VARCHAR(50),                -- MISTAKE, NEW_WORD, MANUAL
                            bookmarked BOOLEAN DEFAULT FALSE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            level VARCHAR(20),                       -- BEGINNER, INTERMEDIATE, ADVANCED
                            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                            FOREIGN KEY (source_feedback_id) REFERENCES feedbacks(feedback_id) ON DELETE SET NULL
);

CREATE TABLE progress_snapshots (
                                    snapshot_id UUID PRIMARY KEY,
                                    user_id UUID NOT NULL,
                                    taken_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    journal_count INTEGER DEFAULT 0,
                                    unique_word_count INTEGER DEFAULT 0,
                                    error_rate FLOAT DEFAULT 0.0,
                                    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);