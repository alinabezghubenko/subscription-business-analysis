# Subscription Business Performance Analysis

## 📌 Огляд проекту
Цей проект присвячений аналізу доходів та утримання користувачів для мобільних ігор. 
Головна мета — розрахувати складні SaaS-метрики та візуалізувати їх для прийняття бізнес-рішень.

## 🛠 Технологічний стек
* **SQL (PostgreSQL):** Розрахунок метрик (MRR, Churn, Retention).
* **Tableau:** Побудова інтерактивного дашборду.
* **Excel:** Попередня підготовка даних.

## 📊 Ключові результати
Я розробила SQL-запит, який автоматизує розрахунок:
* **MRR Waterfall:** (New, Retained, Expansion, Contraction, Churn).
* **Когортний аналіз:** утримання користувачів по місяцях.

## 🔍 Приклад коду
Ось фрагмент моєї роботи з віконними функціями для визначення статусу користувача:

```sql
-- Визначення нових та реактивованих користувачів
        CASE WHEN previous_paid_month IS NULL
            THEN 1 ELSE 0 END                      AS new_users,
        CASE WHEN previous_paid_month IS NOT NULL
              AND previous_paid_month < prev_calendar_month
            THEN 1 ELSE 0 END                      AS reactivated_users,

🔗 Посилання
Інтерактивний дашборд у Tableau
[![Tableau](https://img.shields.io/badge/Tableau-Interactive_Dashboard-blue?style=for-the-badge&logo=tableau)](https://public.tableau.com/views/_17767713281710/SubscriptionBusinessPerformanceExecutiveDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
