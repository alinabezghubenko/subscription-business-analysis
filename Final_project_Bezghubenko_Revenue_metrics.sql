WITH user_monthly_payments AS (
    SELECT
        DATE_TRUNC('month', p.payment_date)  AS payment_month,
        p.user_id,
        u.game_name,
        u.language,
        u.age,
        u.has_older_device_model,
        SUM(p.revenue_amount_usd)            AS total_revenue
    FROM project.games_payments p
    LEFT JOIN project.games_paid_users u ON p.user_id = u.user_id
    GROUP BY 1, 2, 3, 4, 5, 6
),
monthly_metrics AS (
    SELECT
        payment_month,
        user_id,
        game_name,
        language,
        age,
        has_older_device_model,
        total_revenue,
        COUNT(user_id) OVER (PARTITION BY payment_month)  AS paid_users,
        DATE(payment_month + INTERVAL '1 month')          AS next_calendar_month,
        DATE(payment_month - INTERVAL '1 month')          AS prev_calendar_month,
        LAG(total_revenue)    OVER (PARTITION BY user_id ORDER BY payment_month)  AS previous_paid_month_revenue,
        LAG(payment_month)    OVER (PARTITION BY user_id ORDER BY payment_month)  AS previous_paid_month,
        LEAD(payment_month)   OVER (PARTITION BY user_id ORDER BY payment_month)  AS next_paid_month
    FROM user_monthly_payments
),
final_metrics AS (
    SELECT
        payment_month,
        user_id,
        game_name,
        language,
        age,
        has_older_device_model,
        total_revenue,
        paid_users,
        -- Новий юзер: платить вперше (немає попереднього платежу)
        CASE WHEN previous_paid_month IS NULL
            THEN 1 ELSE 0 END                                                    AS new_users,
        CASE WHEN previous_paid_month IS NULL
            THEN total_revenue ELSE 0 END                                        AS new_mrr,
        -- Реактивація: юзер платив раніше, але пропустив хоча б один місяць
        CASE WHEN previous_paid_month IS NOT NULL
              AND previous_paid_month < prev_calendar_month
            THEN 1 ELSE 0 END                                                    AS reactivated_users,
        CASE WHEN previous_paid_month IS NOT NULL
              AND previous_paid_month < prev_calendar_month
            THEN total_revenue ELSE 0 END                                        AS reactivation_mrr,
        -- Чарн: наступний платіж відсутній або не рівно наступного місяця
        -- (у Tableau зсувати на +1 місяць через LOOKUP для відображення)
        CASE WHEN next_paid_month IS NULL
              OR next_paid_month != next_calendar_month
            THEN 1 END                                                           AS churned_users,
        CASE WHEN next_paid_month IS NULL
              OR next_paid_month != next_calendar_month
            THEN total_revenue END                                                AS churned_revenue,
         -- churn_month: місяць коли юзер вважається зачарненим (поточний місяць + 1)
        CASE WHEN next_paid_month IS NULL
              OR next_paid_month != next_calendar_month
            THEN next_calendar_month END                                           AS churn_month,
        -- Retained: юзер платив місяць тому і платить зараз (не новий, не реактивований)
        CASE WHEN previous_paid_month = prev_calendar_month
            THEN 1 ELSE 0 END                                                    AS retained_users,
        CASE WHEN previous_paid_month = prev_calendar_month
            THEN total_revenue ELSE 0 END                                        AS retained_revenue,
        -- Expansion MRR: поточний платіж більший за попередній (лише для послідовних місяців)
        CASE WHEN previous_paid_month = prev_calendar_month
              AND previous_paid_month_revenue IS NOT NULL
              AND total_revenue > previous_paid_month_revenue
            THEN total_revenue - previous_paid_month_revenue ELSE 0 END          AS expansion_mrr,
        -- Contraction MRR: поточний платіж менший за попередній (лише для послідовних місяців)
        CASE WHEN previous_paid_month = prev_calendar_month
              AND previous_paid_month_revenue IS NOT NULL
              AND total_revenue < previous_paid_month_revenue
            THEN previous_paid_month_revenue - total_revenue ELSE 0 END          AS contraction_mrr
    FROM monthly_metrics
)
SELECT
    payment_month,
    user_id,
    game_name,
    language,
    age,
    has_older_device_model,
    total_revenue,
    paid_users,
    new_users,
    new_mrr,
    reactivated_users,
    reactivation_mrr,
    churned_users,
    churned_revenue,
    churn_month,
    retained_users,
    retained_revenue,
    expansion_mrr,
    contraction_mrr
FROM final_metrics
ORDER BY payment_month;