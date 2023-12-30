use ig_clone;
-- A) Marketing Analysis:

-- Task 1 : Loyal User Reward: The marketing team wants to reward the most loyal users, 
--          i.e., those who have been using the platform for the longest time.
--          Identify the five oldest users on Instagram from the provided database.

select id as Id, username as UserName 
from users
order by created_at asc
limit 5;


-- Task 2 : Inactive User Engagement: The team wants to encourage inactive users to start posting by sending them promotional emails.
--  		Identify users who have never posted a single photo on Instagram.

select u.id, u.username as UserName
from users u
left join
photos p on u.id=p.user_id
where p.user_id is null;


-- Task 3 : Contest Winner Declaration: The team has organized a contest where the user with the most likes on a single photo wins.
--          Determine the winner of the contest and provide their details to the team.

select * from likes;
select u.username as UserName, p.image_url, p.id, count(*) as Like_Counts
from photos p
join
likes l on p.id=l.photo_id
join
users u on p.user_id=u.id
group by p.id
order by Like_Counts desc
limit 1;



-- Task 4 : Hashtag Research: A partner brand wants to know the most popular hashtags to use in their posts to reach the most people.
--          Identify and suggest the top five most commonly used hashtags on the platform.

select * from tags;
select * from photo_tags;
select t.id, t.tag_name, count(*) as Use_Count
from tags t
join
photo_tags pt on t.id=pt.tag_id
group by t.id
order by Use_Count desc
limit 5;








-- Task 5 : Ad Campaign Launch: The team wants to know the best day of the week to launch ads.
--          Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.

select dayname(created_at) as DayName, count(*) as Total_Counts
from users
group by DayName
order by Total_Counts desc;






-- B) Investor Metrics:

-- Task 1 : User Engagement: Investors want to know if users are still active and posting on Instagram or if they are making fewer posts.
--          Calculate the average number of posts per user on Instagram. 
--          Also, provide the total number of photos on Instagram divided by the total number of users.
select (select count(p.id) from photos p) / (select count(u.id) from users u) as Answer;

select avg(Total_Count) as Average_Number_of_Posts_per_User
from (select count(p.image_url) as Total_Count, u.username
from photos p
left join
users u on p.user_id=u.id
group by u.username
order by Total_Count desc) as Average;






-- Task 2 : Bots & Fake Accounts: Investors want to know if the platform is crowded with fake and dummy accounts.
--          Identify users (potential bots) who have liked every single photo on the site, 
--          as this is not typically possible for a normal user.

select u.id, u.username
from users u
join
likes l on u.id=l.user_id
group by u.id
having count(u.id)=(select count(p.id) from photos p);



