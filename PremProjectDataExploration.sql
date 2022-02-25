Select *
From prem.goalscorers2;

-- Looking at the games played vs the goals scored
Select PLAYER, TEAM, GP, G, (G/GP) as GoalsPerGame
From prem.goalscorers2
order by 5 DESC;

-- Looking at the games started vs the goals scored
Select PLAYER, TEAM, GS, G, (G/GS) as GoalsPerStart
From prem.goalscorers2
order by 5 DESC;

-- Looking at the minutes vs goals scored
Select PLAYER, TEAM, MIN, G, (MIN/G) as MinutesPerGoal
From prem.goalscorers2
order by 5;

-- Displaying each goalscorer of every single club and the acummulative goals of each club
SELECT TEAM, PLAYER, GP, MIN, G, SUM(G) over (partition by TEAM order by G, PLAYER) as CommulativeGoals
From prem.goalscorers2
order by 1;

-- Looking at the goals per 90 minutes
Select PLAYER, TEAM, MIN, G, (MIN/G) as MinutesPerGoal, (G/(MIN/90)) as GoalsPer90
From prem.goalscorers2
order by 6 DESC;

-- Looking at the goal contributions
Select PLAYER, TEAM, GP, G, ASST, (G+ASST) as GC
From prem.goalscorers2
order by 6 DESC;

-- Looking at the goal contributions per 90 minutes
Select PLAYER, TEAM, MIN, G, (MIN/G) as MinutesPerGoal, (MIN/ASST) as MinutesPerAssist, (G/(MIN/90)) as GoalsPer90, (ASST/(MIN/90)) as AssistsPer90, ((G+ASST)/(MIN/90)) as GoalContributionPer90
From prem.goalscorers2
order by 9 DESC;

-- Looking at the goal contributions vs the games played
Select PLAYER, TEAM, GP, G, ASST, (G+ASST) as GC, ((G+ASST)/GP) as GoalContributionsPerGame
From prem.goalscorers2
order by 7 DESC;

-- Looking at the goal contributions vs the games started
Select PLAYER, TEAM, GP, GS, G, ASST, (G+ASST) as GC, ((G+ASST)/GS) as GoalContributionsPerStart
From prem.goalscorers2
order by 8 DESC;

-- Looking at the goal contributions vs the minutes played
Select PLAYER, TEAM, GP, MIN, G, ASST, (G+ASST) as GC, (MIN/(G+ASST)) as MinutesPerGoalContribution
From prem.goalscorers2
order by 8;

-- Looking at the conversion rates of each player
Select PLAYER, TEAM, G, SHOTS, SOG, (SOG/SHOTS)*100 as ShotAccuracy, (G/SHOTS)*100 as ConversionRate
From prem.goalscorers2
order by 7 DESC;

-- Comparing how different teams performed in front of the goal
Select TEAM, sum(G) as GOALS, sum(SHOTS) as TotalShots, sum(SOG) as TotalShotsOnTarget, (sum(SOG)/sum(SHOTS))*100 as ShotAccuracy, (sum(G)/sum(SHOTS))*100 as ConversionRate
From prem.goalscorers2
group by TEAM
order by 2 DESC;

-- Comparing the top goal scorer at each club
Select TEAM, PLAYER, GP, GS, MIN, SHOTS, SOG, (SOG/SHOTS)*100 as ShotAccuracy, (G/SHOTS)*100 as ConversionRate, (G/(MIN/90)) as GoalsPer90, max(G) as GOALS
From prem.goalscorers2
group by TEAM
order by 11 DESC;
