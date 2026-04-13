# 📸 Instagram User Analytics

> SQL-based user behavior analysis on an Instagram-style platform — uncovering engagement patterns, bot activity, influencers, and retention insights.

---

## 📌 Project Overview

This project simulates a real-world product analytics task: analyzing Instagram user data to help a growth team make data-driven decisions. Using a relational database of **100 users, 300+ photos, 3,600+ likes, and 1,200+ comments**, the analysis answers 18 business questions across user growth, engagement, content strategy, and retention.

**Tools:** MySQL · SQL (CTEs, Window Functions, Stored Procedures, Views)  
**Skills:** Data Modeling · Joins · Aggregations · Funnel Analysis · Bot Detection · Retention Segmentation

---

## 🎯 Business Questions Answered

| # | Question | Business Use |
|---|----------|-------------|
| 1 | Who are the 5 oldest users? | Loyalty reward program |
| 2 | Which users have never posted? | Re-engagement email campaign |
| 3 | Which photo got the most likes? | Contest winner declaration |
| 4 | What are the top 5 hashtags? | Trending content recommendations |
| 5 | Which day sees most registrations? | Marketing campaign scheduling |
| 6 | What is the avg posts per user? | Investor engagement metrics |
| 7 | Which accounts liked every photo? | Bot/fake account detection |
| 8 | Who has zero activity at all? | Database cleanup candidates |
| 9 | Who comments the most? | Brand advocate identification |
| 10 | Which photos have best engagement? | Content strategy insights |
| 11 | How is user growth trending monthly? | Stakeholder growth reporting |
| 12 | Who are the top influencers? | Partnership targeting |
| 13 | Which users get most avg likes? | Creator performance ranking |
| 14 | Which hashtags drive most likes? | Hashtag recommendation engine |
| 15 | How are users segmented by activity? | Churn & retention analysis |
| 16 | What does the engagement funnel look like? | Product funnel optimization |
| 17 | What hour gets the most likes? | Content scheduling strategy |
| 18 | Who are mutual followers? | Friend recommendation system |

---

## 📁 Repository Structure

```
instagram-user-analytics/
│
├── sql/
│   ├── schema.sql            # CREATE TABLE statements with indexes & constraints
│   ├── data.sql              # Sample data: 100 users, 300+ photos, 3600+ likes
│   └── analysis_queries.sql  # 18 business queries + VIEW + Stored Procedure
│
└── README.md
```

---

## 🗄️ Database Schema

```
users ──────< photos ──────< photo_tags >────── tags
  │              │
  │           < likes
  │           < comments
  │
  └──────────< follows >────── users
```

**7 Tables:** `users` · `photos` · `comments` · `likes` · `follows` · `tags` · `photo_tags`

| Table | Rows |
|-------|------|
| users | 100 |
| photos | 302 |
| likes | 3,643 |
| comments | 1,277 |
| follows | 999 |
| tags | 30 |
| photo_tags | 876 |

---

## 📊 Key Findings

| # | Finding | Detail |
|---|---------|--------|
| 1 | **35% of users never posted** | 35 users joined but never shared a photo |
| 2 | **Engagement funnel drops sharply** | Only ~65% of users ever post; ~75% interact via likes |
| 3 | **Bot detection possible via likes** | Users who liked every photo flagged as suspicious |
| 4 | **photography & travel dominate hashtags** | Top 2 tags appear in 30%+ of photos |
| 5 | **Mutual follow pairs identified** | Network graph reveals tightly-knit user clusters |
| 6 | **Retention segmentation reveals churn risk** | 30% of users classified as At Risk or Churned |
| 7 | **Peak posting hours correlate with likes** | Afternoon posts (2–5 PM) get highest avg engagement |

---

## 🔑 SQL Features Used

- `JOIN`, `LEFT JOIN`, `INNER JOIN` — multi-table relationships
- `GROUP BY` + `HAVING` — aggregation with filters
- `Window Functions` — `SUM() OVER()` for cumulative growth
- `CTEs` — `WITH` clause for clean monthly growth query
- `CASE WHEN` — user retention segmentation
- `Subqueries` — bot detection logic
- `CREATE VIEW` — reusable engagement summary dashboard
- `Stored Procedure` — on-demand per-user activity report
- `Indexes` — optimized for query performance on large datasets

---

## ▶️ How to Run

**Requirements:** MySQL 8.0+

```bash
# Step 1: Create schema
mysql -u root -p < sql/schema.sql

# Step 2: Load sample data
mysql -u root -p instagram_analytics < sql/data.sql

# Step 3: Run analysis
mysql -u root -p instagram_analytics < sql/analysis_queries.sql
```

Or open each file in **MySQL Workbench** and run in order:
1. `schema.sql`
2. `data.sql`
3. `analysis_queries.sql`

---

## 🧠 What I'd Add Next

- **Python + Pandas** — Pull query results into Python for visualization
- **Tableau Dashboard** — Visual funnel, retention heatmap, influencer leaderboard
- **Cohort Analysis** — Track retention of users who signed up in same month
- **Fraud Scoring** — Weighted bot score using likes + comments + follow ratio

---

## 📬 Connect

**Nishant Jaiswal** — Data Analyst  
[LinkedIn](https://www.linkedin.com/in/nishant-jaiswal01) · [Email](mailto:nishant.jais3918@gmail.com)
