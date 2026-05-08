# Subscription Business Performance Analysis

## 📌 Огляд проєкту
Проєкт створений для аналізу SaaS revenue-метрик мобільних ігор. Дані перетворені за допомогою SQL і відображені на інтерактивному Tableau-дашборді для відстеження динаміки MRR, Churn Rate та ARPPU, а також визначення ключових факторів, що впливають на зміни доходу. 

## 🛠 Технологічний стек
* **SQL (PostgreSQL):** Попередня підготовка даних, об'єднання початкових таблиць та частковий розрахунок метрик (MRR, Churn, Retention тощо).
* **DBeaver** 
* **CSV**
* **Tableau:** Частковий розрахунок метрик та побудова інтерактивного дашборду (ARPPU, Net User Churn, LT, LTV тощо).

## 📊 Ключові результати
Я розробила SQL-запит, який автоматизує розрахунок:
* **MRR Waterfall:** (New, Expansion, Contraction, Churn).
* **Когортний аналіз:** утримання користувачів по місяцях.
* **LT & LTV Analysis:** Визначила залежність між часом життя користувача та доходом.

## 🔍 Приклад коду
Ось фрагмент моєї роботи з віконними функціями для визначення статусу користувача:

```sql
-- Визначення нових та реактивованих користувачів
        CASE WHEN previous_paid_month IS NULL
            THEN 1 ELSE 0 END                      AS new_users,
        CASE WHEN previous_paid_month IS NOT NULL
              AND previous_paid_month < prev_calendar_month
            THEN 1 ELSE 0 END                      AS reactivated_users.
```

Інтерактивний дашборд у Tableau
[![Tableau](https://img.shields.io/badge/Tableau-Interactive_Dashboard-blue?style=for-the-badge&logo=tableau)](https://public.tableau.com/views/_17767713281710/SubscriptionBusinessPerformanceExecutiveDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
