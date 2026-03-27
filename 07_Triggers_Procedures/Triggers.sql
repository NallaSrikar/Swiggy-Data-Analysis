
----## TRIGGERS

-- Rating Validation
CREATE TRIGGER trg_validate_rating_and_count
ON fact_Swiggy_orders
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE 
            (rating IS NOT NULL AND rating_count = 0)
            OR
            (rating IS NULL AND rating_count> 0)
    )
    BEGIN
        RAISERROR('Rating and Rating_Count must be entered together', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;


--Tracking Changes
CREATE TABLE order_audit (
    order_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date DATETIME
);

CREATE TRIGGER trg_audit_price_change
ON fact_Swiggy_orders
AFTER UPDATE
AS
BEGIN
    INSERT INTO order_audit (order_id, old_price, new_price, change_date)
    SELECT 
        d.order_id,
        d.price_INR,
        i.price_INR,
        GETDATE()
    FROM deleted d
    JOIN inserted i ON d.order_id = i.order_id
    WHERE d.price_INR <> i.price_INR;
END;