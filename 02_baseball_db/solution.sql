-- step 1: investigate the first rows of batting, teams, people, pitching
SELECT * FROM batting
LIMIT 3;

SELECT * FROM teams
LIMIT 3;

SELECT * FROM people
LIMIT 3;

SELECT * FROM pitching
LIMIT 3;

-- step 2: get the team with the highest average weight of its batters on a given year
SELECT teams.name, batting.yearid, AVG(people.weight) AS avg_weight
FROM people
JOIN batting
  ON people.playerid = batting.playerid
JOIN teams
  ON batting.teamid = teams.teamid
  AND batting.yearid = teams.yearid
GROUP BY teams.name, batting.yearid
ORDER BY avg_weight DESC
LIMIT 1;

-- step 3: team with the largest salary of all players in a given year
SELECT teams.name, salaries.teamid, salaries.yearid, SUM(salaries.salary) AS total_salary
FROM salaries
JOIN teams
  ON salaries.teamid = teams.teamid
  AND salaries.yearid = teams.yearid
GROUP BY teams.name, salaries.teamid, salaries.yearid
ORDER BY total_salary DESC
LIMIT 1;

-- step 4: team with the smallest cost per win in 2010
SELECT teams.name, salaries.teamid, salaries.yearid,
       ROUND(SUM(salaries.salary)::numeric / teams.w, 2) AS cost_per_win
FROM salaries
JOIN teams
  ON salaries.teamid = teams.teamid
  AND salaries.yearid = teams.yearid
WHERE salaries.yearid = 2010
GROUP BY teams.name, salaries.teamid, salaries.yearid, teams.w
ORDER BY cost_per_win ASC
LIMIT 1;

-- step 5: priciest starter (expensive pitcher per game)
SELECT people.namefirst, people.namelast, pitching.playerid, salaries.teamid, salaries.yearid,
       ROUND(salaries.salary::numeric / pitching.gs, 2) AS cost_per_starter
FROM salaries
JOIN pitching
  ON salaries.teamid = pitching.teamid
  AND salaries.playerid = pitching.playerid
  AND salaries.yearid = pitching.yearid
JOIN people
  ON pitching.playerid = people.playerid
WHERE pitching.gs >= 10
ORDER BY cost_per_starter DESC
LIMIT 1;

-- step 6: batter with the highest hits per game IN 1990'S
SELECT people.namefirst, people.namelast, batting.yearid,
       batting.h, batting.g,
       ROUND(batting.h / batting.g::numeric, 3) AS hits_per_game
FROM people
JOIN batting
  ON people.playerid = batting.playerid
WHERE batting.yearid BETWEEN 1990 AND 1999
  AND batting.g >= 10
ORDER BY hits_per_game DESC
LIMIT 1;

-- step 7: get pitcher with the lowest ERA who played for a team whose stadium is in Canada
SELECT people.namefirst, people.namelast, pitching.yearid,
       teams.name, parks.park, parks.city, parks.country,
       pitching.era, ROUND((pitching.ipouts / 3.0)::numeric, 1) AS innings
FROM pitching
JOIN people
  ON people.playerid = pitching.playerid
JOIN teams
  ON pitching.teamid = teams.teamid
  AND pitching.yearid = teams.yearid
JOIN parks
  ON teams.park = parks.park
WHERE parks.country = 'CA'
  AND pitching.ipouts >= 150
ORDER BY pitching.era ASC
LIMIT 1;
