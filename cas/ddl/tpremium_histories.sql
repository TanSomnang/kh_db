-- Table: public.tpremium_histories

-- DROP TABLE IF EXISTS public.tpremium_histories;

CREATE TABLE IF NOT EXISTS cas.tpremium_histories
(
    premium_history_id SERIAL PRIMARY KEY,
    policy_id INTEGER NOT NULL,
    old_premium_amount NUMERIC(12, 2) NOT NULL,
    new_premium_amount NUMERIC(12, 2) NOT NULL,
    change_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    changed_by_user_id INTEGER,
    change_reason VARCHAR(255),
    
    -- Ensure the premium change is valid (e.g., cannot change from a negative)
    CONSTRAINT check_positive_amount CHECK (new_premium_amount >= 0),
    
    -- Example Foreign Key to a hypothetical policy table
    -- CONSTRAINT fk_policy FOREIGN KEY(policy_id) REFERENCES public.tpolicies(policy_id)
);

-- Index for faster lookup of history by policy
CREATE INDEX IF NOT EXISTS idx_premium_histories_policy_id 
ON public.tpremium_histories(policy_id);

-- Comment on table
COMMENT ON TABLE public.tpremium_histories IS 'Stores historical records of premium changes for policies.';
