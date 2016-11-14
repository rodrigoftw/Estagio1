M = {}
M.maxLevels = 7
--M.levelScore = 0
M.products = {}
M.settings = {}
M.settings.currentLevel = 1
M.settings.unlockedLevels = 1
--M.settings.bestScore = 0
M.settings.soundOn = true
M.settings.musicOn = true
M.settings.levels = {} 
-- levels data members:
--      .stars -- Stars earned per level
--      .score -- Score for the level
-- 		.energyBonus -- Bonus for unused energy

M.settings.levels[1] = {}
-- M.settings.levels[1].remainingTime = ""

return M

-- These lines are just here to pre-populate the table.
-- In reality, your app would likely create a level entry when each level is unlocked and the score/stars are saved.
-- Perhaps this happens at the end of your game level, or in a scene between game levels.

-- M.settings.levels[1].stars = 3
-- M.settings.levels[1].score = 3833
-- if M.settings.levels[1].score >= 20000 then
--    M.settings.unlockedLevels = 2
-- end
-- if M.settings.levels[1].score >= 5000 then
--     M.settings.levels[1].stars = 1
-- end
-- if M.settings.levels[1].score >= 15000 then
--     M.settings.levels[1].stars = 2
-- end
-- if M.settings.levels[1].score >= 20000 then
--     M.settings.levels[1].stars = 3
-- end
-- -- levels data members:
-- --      .stars -- Stars earned per level
-- --      .score -- Score for the level
-- return M