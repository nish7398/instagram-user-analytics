-- ============================================
-- INSTAGRAM USER ANALYTICS
-- Analysis Queries — MySQL
-- Author: Nishant Jaiswal
-- ============================================

USE instagram_analytics;

-- ============================================
-- QUERY 1: 5 Oldest Users (Early Adopters)
-- Business Use: Loyalty reward program
-- ============================================
SELECT
    id,
    username,
    email,
    created_at                                      AS registration_date,
    DATEDIFF(CURDATE(), DATE(created_at))           AS days_on_platform
FROM users
ORDER BY created_at ASC
LIMIT 5;


-- ============================================
-- QUERY 2: Inactive Users (Never Posted)
-- Business Use: Email re-engagement campaign
-- ============================================
SELECT
    u.id,
    u.username,
    u.email,
    u.created_at                                    AS registration_date,
    DATEDIFF(CURDATE(), DATE(u.created_at))         AS days_since_joining
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL
ORDER BY u.created_at;


-- ============================================
-- QUERY 3: Most Liked Photo (Contest Winner)
-- Business Use: Engagement contest results
-- ============================================
SELECT
    p.id           AS photo_id,
    p.image_url,
    u.username     AS posted_by,
    p.caption,
    p.location,
    COUNT(l.user_id) AS total_likes
FROM photos p
JOIN  users u ON p.user_id = u.id
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY p.id, p.image_url, u.username, p.caption, p.location
ORDER BY total_likes DESC
LIMIT 1;


-- ============================================
-- QUERY 4: Top 5 Most Used Hashtags
-- Business Use: Trending content recommendations
-- ============================================
SELECT
    t.tag_name,
    COUNT(pt.photo_id)                                                  AS usage_count,
    ROUND(COUNT(pt.photo_id) * 100.0 / (SELECT COUNT(*) FROM photos), 2) AS usage_pct
FROM tags t
JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY t.id, t.tag_name
ORDER BY usage_count DESC
LIMIT 5;


-- ============================================
-- QUERY 5: Best Day to Register (Marketing)
-- Business Use: Schedule ad campaigns on peak days
-- ============================================
SELECT
    DAYNAME(created_at)  AS day_of_week,
    COUNT(*)             AS registrations
FROM users
GROUP BY DAYNAME(created_at)
ORDER BY registrations DESC;


-- ============================================
-- QUERY 6: Avg Posts Per User (Engagement Health)
-- Business Use: Investor/stakeholder reporting
-- ============================================
SELECT
    COUNT(DISTINCT u.id)                                           AS total_users,
    COUNT(p.id)                                                    AS total_posts,
    ROUND(COUNT(p.id) / COUNT(DISTINCT u.id), 2)                   AS avg_posts_per_user
FROM users u
LEFT JOIN photos p ON u.id = p.user_id;


-- ============================================
-- QUERY 7: Bot Detection (Liked Every Photo)
-- Business Use: Fake account identification
-- ============================================
SELECT
    u.id,
    u.username,
    COUNT(l.photo_id)               AS photos_liked,
    (SELECT COUNT(*) FROM photos)   AS total_photos_on_platform
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY u.id, u.username
HAVING COUNT(l.photo_id) = (SELECT COUNT(*) FROM photos);


-- ============================================
-- QUERY 8: Completely Inactive Users
-- Business Use: Database cleanup / win-back campaign
-- ============================================
SELECT
    u.id,
    u.username,
    u.email,
    u.created_at,
    DATEDIFF(CURDATE(), DATE(u.created_at)) AS days_since_joining
FROM users u
LEFT JOIN photos   p ON u.id = p.user_id
LEFT JOIN likes    l ON u.id = l.user_id
LEFT JOIN comments c ON u.id = c.user_id
WHERE p.id IS NULL
  AND l.photo_id IS NULL
  AND c.id IS NULL
ORDER BY u.created_at;


-- ============================================
-- QUERY 9: Most Active Commenters
-- Business Use: Identify brand advocates
-- ============================================
SELECT
    u.id,
    u.username,
    COUNT(c.id)          AS total_comments,
    MIN(c.created_at)    AS first_comment_date,
    MAX(c.created_at)    AS latest_comment_date
FROM users u
JOIN comments c ON u.id = c.user_id
GROUP BY u.id, u.username
ORDER BY total_comments DESC
LIMIT 10;


-- ============================================
-- QUERY 10: Photo Engagement Rate
-- Business Use: Content strategy & creator insights
-- ============================================
SELECT
    p.id,
    u.username,
    p.caption,
    p.location,
    COUNT(DISTINCT l.user_id)                             AS likes,
    COUNT(DISTINCT c.id)                                  AS comments,
    COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id)      AS total_engagement
FROM photos p
JOIN  users    u ON p.user_id  = u.id
LEFT JOIN likes    l ON p.id = l.photo_id
LEFT JOIN comments c ON p.id = c.photo_id
GROUP BY p.id, u.username, p.caption, p.location
ORDER BY total_engagement DESC
LIMIT 10;


-- ============================================
-- QUERY 11: Monthly User Growth (CTE)
-- Business Use: Growth metrics for stakeholders
-- ============================================
WITH monthly_signups AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        COUNT(*)                          AS new_users
    FROM users
    GROUP BY DATE_FORMAT(created_at, '%Y-%m')
)
SELECT
    month,
    new_users,
    SUM(new_users) OVER (ORDER BY month)  AS cumulative_users
FROM monthly_signups
ORDER BY month;


-- ============================================
-- QUERY 12: Top Influencers (Most Followed)
-- Business Use: Partnership & sponsorship targeting
-- ============================================
SELECT
    u.id,
    u.username,
    u.is_verified,
    COUNT(DISTINCT f.follower_id)    AS follower_count,
    COUNT(DISTINCT p.id)             AS total_posts
FROM users u
LEFT JOIN follows f ON u.id = f.followee_id
LEFT JOIN photos  p ON u.id = p.user_id
GROUP BY u.id, u.username, u.is_verified
ORDER BY follower_count DESC
LIMIT 10;


-- ============================================
-- QUERY 13: Avg Likes Per Photo By User
-- Business Use: Content creator performance ranking
-- ============================================
SELECT
    u.username,
    COUNT(DISTINCT p.id)                                               AS total_photos,
    COUNT(l.user_id)                                                   AS total_likes,
    ROUND(COUNT(l.user_id) / COUNT(DISTINCT p.id), 2)                  AS avg_likes_per_photo
FROM users u
JOIN  photos p ON u.id = p.user_id
LEFT JOIN likes  l ON p.id = l.photo_id
GROUP BY u.username
ORDER BY avg_likes_per_photo DESC
LIMIT 10;


-- ============================================
-- QUERY 14: Hashtag Engagement Performance
-- Business Use: Hashtag recommendation engine
-- ============================================
SELECT
    t.tag_name,
    COUNT(DISTINCT pt.photo_id)                                                AS photos_tagged,
    COUNT(DISTINCT l.user_id)                                                  AS total_likes,
    ROUND(COUNT(DISTINCT l.user_id) / COUNT(DISTINCT pt.photo_id), 2)          AS avg_likes_per_photo
FROM tags t
JOIN  photo_tags pt ON t.id  = pt.tag_id
JOIN  photos     p  ON pt.photo_id = p.id
LEFT JOIN likes  l  ON p.id = l.photo_id
GROUP BY t.id, t.tag_name
HAVING COUNT(DISTINCT pt.photo_id) >= 2
ORDER BY avg_likes_per_photo DESC;


-- ============================================
-- QUERY 15: User Retention Segmentation
-- Business Use: Churn analysis & re-engagement
-- ============================================
SELECT
    CASE
        WHEN last_login IS NULL                              THEN '❌ Never Logged In'
        WHEN DATEDIFF(CURDATE(), last_login) <= 7            THEN '✅ Active (Last 7 Days)'
        WHEN DATEDIFF(CURDATE(), last_login) <= 30           THEN '🟡 Moderately Active'
        WHEN DATEDIFF(CURDATE(), last_login) <= 90           THEN '🟠 At Risk'
        ELSE                                                      '🔴 Churned'
    END                                         AS user_segment,
    COUNT(*)                                    AS user_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 1) AS pct_of_total
FROM users
GROUP BY user_segment
ORDER BY user_count DESC;


-- ============================================
-- QUERY 16: Engagement Funnel Analysis
-- Business Use: Product funnel optimization
-- ============================================
SELECT 'Total Users'       AS funnel_stage, COUNT(*)             AS users, 100.0 AS pct FROM users
UNION ALL
SELECT 'Posted a Photo',    COUNT(DISTINCT user_id),
       ROUND(COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(*) FROM users), 1) FROM photos
UNION ALL
SELECT 'Liked a Photo',     COUNT(DISTINCT user_id),
       ROUND(COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(*) FROM users), 1) FROM likes
UNION ALL
SELECT 'Left a Comment',    COUNT(DISTINCT user_id),
       ROUND(COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(*) FROM users), 1) FROM comments
UNION ALL
SELECT 'Follows Someone',   COUNT(DISTINCT follower_id),
       ROUND(COUNT(DISTINCT follower_id) * 100.0 / (SELECT COUNT(*) FROM users), 1) FROM follows;


-- ============================================
-- QUERY 17: Best Hour to Post for Max Likes
-- Business Use: Content scheduling strategy
-- ============================================
SELECT
    HOUR(p.created_at)                                          AS posting_hour,
    COUNT(DISTINCT p.id)                                        AS photos_posted,
    COUNT(l.user_id)                                            AS total_likes,
    ROUND(COUNT(l.user_id) / COUNT(DISTINCT p.id), 2)           AS avg_likes_per_photo
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY HOUR(p.created_at)
ORDER BY avg_likes_per_photo DESC;


-- ============================================
-- QUERY 18: Mutual Followers (Friend Graph)
-- Business Use: Friend recommendation system
-- ============================================
SELECT
    u1.username  AS user_1,
    u2.username  AS user_2,
    'Mutual Follow' AS relationship_type
FROM follows f1
JOIN follows f2
    ON f1.follower_id = f2.followee_id
    AND f1.followee_id = f2.follower_id
JOIN users u1 ON f1.follower_id = u1.id
JOIN users u2 ON f1.followee_id = u2.id
WHERE f1.follower_id < f1.followee_id
ORDER BY u1.username;


-- ============================================
-- BONUS: VIEW — User Engagement Summary
-- Business Use: Quick dashboard lookup
-- ============================================
CREATE OR REPLACE VIEW vw_user_engagement AS
SELECT
    u.id,
    u.username,
    u.is_verified,
    COUNT(DISTINCT p.id)         AS total_posts,
    COUNT(DISTINCT l.photo_id)   AS total_likes_given,
    COUNT(DISTINCT c.id)         AS total_comments_made,
    COUNT(DISTINCT f.followee_id) AS total_following,
    COUNT(DISTINCT f2.follower_id) AS total_followers
FROM users u
LEFT JOIN photos   p  ON u.id = p.user_id
LEFT JOIN likes    l  ON u.id = l.user_id
LEFT JOIN comments c  ON u.id = c.user_id
LEFT JOIN follows  f  ON u.id = f.follower_id
LEFT JOIN follows  f2 ON u.id = f2.followee_id
GROUP BY u.id, u.username, u.is_verified;

-- Usage: SELECT * FROM vw_user_engagement ORDER BY total_posts DESC;


-- ============================================
-- BONUS: STORED PROCEDURE — User Activity Report
-- Business Use: Generate per-user report on demand
-- ============================================
DELIMITER $$

CREATE PROCEDURE GetUserActivityReport(IN p_user_id INT)
BEGIN
    SELECT
        u.username,
        u.email,
        u.created_at,
        u.is_verified,
        COUNT(DISTINCT p.id)          AS total_posts,
        COUNT(DISTINCT l.photo_id)    AS total_likes_given,
        COUNT(DISTINCT c.id)          AS total_comments,
        COUNT(DISTINCT f.followee_id) AS following,
        COUNT(DISTINCT f2.follower_id) AS followers
    FROM users u
    LEFT JOIN photos   p  ON u.id = p.user_id
    LEFT JOIN likes    l  ON u.id = l.user_id
    LEFT JOIN comments c  ON u.id = c.user_id
    LEFT JOIN follows  f  ON u.id = f.follower_id
    LEFT JOIN follows  f2 ON u.id = f2.followee_id
    WHERE u.id = p_user_id
    GROUP BY u.username, u.email, u.created_at, u.is_verified;
END$$

DELIMITER ;

-- Usage: CALL GetUserActivityReport(1);


-- ============================================
-- END OF ANALYSIS
-- ============================================
SELECT 'All 18 queries + 2 bonus features executed successfully!' AS Status;