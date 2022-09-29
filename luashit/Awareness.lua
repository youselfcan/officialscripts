Awareness = {
	Init = function(self)
		self.Tracker 	= {}
		self.JTracker 	= {}
		self.JTrackerList = {}
		self.Cooldowns 	= {}
		self.Wards		= {}
		self.Weapon_Ord_Draw = 0

		--JungleTrackerTimersBlueSide
		self.Blue1Pos = nil
		self.Blue1Timer = -1000
		self.Wolf1Pos = nil
		self.Wolf1Timer = -1000
		self.Gromp1Pos = nil
		self.Gromp1Timer = -1000
		self.Chicken1Pos = nil
		self.Chicken1Timer = -1000
		self.Red1Pos = nil
		self.Red1Timer = -1000
		self.Krug1Pos = nil
		self.Krug1Timer = -1000

		--JungleTrackerTimersRedSide
		self.Blue2Pos = nil
		self.Blue2Timer = -1000
		self.Wolf2Pos = nil
		self.Wolf2Timer = -1000
		self.Gromp2Pos = nil
		self.Gromp2Timer = -1000
		self.Chicken2Pos = nil
		self.Chicken2Timer = -1000
		self.Red2Pos = nil
		self.Red2Timer = -1000
		self.Krug2Pos = nil
		self.Krug2Timer = -1000

		self.AwarenessMenu 		= Menu:CreateMenu("Awareness")
		------------------------------------------------------------
		self.ChampionHUD 		= self.AwarenessMenu:AddSubMenu("Champion HUD")	
		self.ChampionHUD:AddLabel("Summoners:")
		self.TimeSummoners		= self.ChampionHUD:AddCheckbox("Show CD", 1)
		self.SummonerSeconds	= self.ChampionHUD:AddCheckbox("In Seconds", 0)
		self.ChampionHUD:AddLabel("Ultimates:")
		self.TimeUltimates		= self.ChampionHUD:AddCheckbox("Show CD", 1)
		self.UltimateSeconds	= self.ChampionHUD:AddCheckbox("In Seconds", 1)
		self.ChampionHUD:AddLabel("Healthbars:")
		self.DrawHealthbar 		= self.ChampionHUD:AddCheckbox("Draw Healthbars", 1)
		self.ChampionHUD:AddLabel("Recalls:")
		self.DrawRecall 		= self.ChampionHUD:AddCheckbox("Draw Recallbars", 1)
		self.ChampionHUD:AddLabel("Position on Screen:")
		self.ChampHUD_X			= self.ChampionHUD:AddSlider("X", 100,100,4000,1)
		self.ChampHUD_Y			= self.ChampionHUD:AddSlider("Y", 100,100,4000,1)
		------------------------------------------------------------
		self.TrackerSettings 	= self.AwarenessMenu:AddSubMenu("Tracker Settings")	
		self.TrackerSettings:AddLabel("Cooldowns:")
		self.DrawEnemyCD 		= self.TrackerSettings:AddCheckbox("Enemies", 1)
		self.DrawFriendCD 		= self.TrackerSettings:AddCheckbox("Allies", 1)
		self.TrackerSettings:AddLabel("Turrets:")
		self.DrawEnemyTurret	= self.TrackerSettings:AddCheckbox("Enemies", 1)
		self.DrawFriendTurret	= self.TrackerSettings:AddCheckbox("Allies", 1)
		self.TrackerSettings:AddLabel("Map:")
		self.DrawMapCircles		= self.TrackerSettings:AddCheckbox("ESP", 1)	
		self.TrackerSettings:AddLabel("Wards:")
		self.DrawEnemyWards		= self.TrackerSettings:AddCheckbox("Enemy Wards", 1)
		self.DrawGoodWardSpots	= self.TrackerSettings:AddCheckbox("Good Ward Spots(WIP)", 1)
		------------------------------------------------------------
		self.MiscSettings 		= self.AwarenessMenu:AddSubMenu("Misc Settings")	
		self.MiscSettings:AddLabel("Waypoints:")
		self.DrawEnemyWaypoint	= self.MiscSettings:AddCheckbox("Enemies", 1)
		self.DrawFriendWaypoint = self.MiscSettings:AddCheckbox("Allies", 1)

		self:LoadSettings()	
	end,
	SaveSettings = function(self)
		SettingsManager:CreateSettings("Awareness")
		------------------------------------------------------------
		SettingsManager:AddSettingsGroup("Champion HUD")
		SettingsManager:AddSettingsInt("Summoners", 		self.TimeSummoners.Value)
		SettingsManager:AddSettingsInt("SummonersSeconds", 	self.SummonerSeconds.Value)
		SettingsManager:AddSettingsInt("Ultimates", 		self.TimeUltimates.Value)
		SettingsManager:AddSettingsInt("UltimatesSeconds", 	self.UltimateSeconds.Value)
		SettingsManager:AddSettingsInt("Healthbars", 		self.DrawHealthbar.Value)
		SettingsManager:AddSettingsInt("Recall", 			self.DrawRecall.Value)
		SettingsManager:AddSettingsInt("Position_X", 		self.ChampHUD_X.Value)
		SettingsManager:AddSettingsInt("Position_Y", 		self.ChampHUD_Y.Value)
		------------------------------------------------------------
		SettingsManager:AddSettingsGroup("Tracker Settings")
		SettingsManager:AddSettingsInt("EnemyCD", 		self.DrawEnemyCD.Value)
		SettingsManager:AddSettingsInt("AllyCD", 		self.DrawFriendCD.Value)
		SettingsManager:AddSettingsInt("EnemyTurret", 	self.DrawEnemyTurret.Value)
		SettingsManager:AddSettingsInt("AllyTurret", 	self.DrawFriendTurret.Value)
		SettingsManager:AddSettingsInt("MAPESP", 		self.DrawMapCircles.Value)
		SettingsManager:AddSettingsInt("EnemyWard", 	self.DrawEnemyWards.Value)
		SettingsManager:AddSettingsInt("GoodWardSpot", 	self.DrawGoodWardSpots.Value)
		------------------------------------------------------------
		SettingsManager:AddSettingsGroup("Misc Settings")
		SettingsManager:AddSettingsInt("EnemyWaypoint", 	self.DrawEnemyWaypoint.Value)
		SettingsManager:AddSettingsInt("AllyWaypoint", 		self.DrawFriendWaypoint.Value)

	end,
	LoadSettings = function(self)
		SettingsManager:GetSettingsFile("Awareness")
		-------------------------------------------------------------
		self.TimeSummoners.Value		= SettingsManager:GetSettingsInt("Champion HUD", "Summoners")
		self.SummonerSeconds.Value		= SettingsManager:GetSettingsInt("Champion HUD", "SummonersSeconds")
		self.TimeUltimates.Value		= SettingsManager:GetSettingsInt("Champion HUD", "Ultimates")
		self.UltimateSeconds.Value		= SettingsManager:GetSettingsInt("Champion HUD", "UltimatesSeconds")
		self.DrawHealthbar.Value 		= SettingsManager:GetSettingsInt("Champion HUD", "Healthbars")
		self.DrawRecall.Value 			= SettingsManager:GetSettingsInt("Champion HUD", "Recall")
		self.ChampHUD_X.Value			= SettingsManager:GetSettingsInt("Champion HUD", "Position_X")
		self.ChampHUD_Y.Value			= SettingsManager:GetSettingsInt("Champion HUD", "Position_Y")
		------------------------------------------------------------
		self.DrawEnemyCD.Value			= SettingsManager:GetSettingsInt("Tracker Settings", "EnemyCD")
		self.DrawFriendCD.Value			= SettingsManager:GetSettingsInt("Tracker Settings", "AllyCD")
		self.DrawEnemyTurret.Value		= SettingsManager:GetSettingsInt("Tracker Settings", "EnemyTurret")
		self.DrawFriendTurret.Value		= SettingsManager:GetSettingsInt("Tracker Settings", "AllyTurret")
		self.DrawMapCircles.Value		= SettingsManager:GetSettingsInt("Tracker Settings", "MAPESP")	
		self.DrawEnemyWards.Value		= SettingsManager:GetSettingsInt("Tracker Settings", "EnemyWard")
		self.DrawGoodWardSpots.Value	= SettingsManager:GetSettingsInt("Tracker Settings", "GoodWardSpot")
		------------------------------------------------------------
		self.DrawEnemyWaypoint.Value	= SettingsManager:GetSettingsInt("Misc Settings", "EnemyWaypoint")
		self.DrawFriendWaypoint.Value	= SettingsManager:GetSettingsInt("Misc Settings", "AllyWaypoint")
		------------------------------------------------------------
	end,
	--HELPER FUNCTIONS
	GetDistance = function(self, from, to)
        return math.sqrt((from.x - to.x) ^ 2 + (from.y - to.y) ^ 2 + (from.z - to.z) ^ 2)
    end,
	GetBasePosition = function(self, Hero)
		if Hero.Team == 200 then
			return  Vector3.new(14400, 200, 14400)
		else
			return  Vector3.new(400, 200, 400)
		end
	end,
	AlliesInRange = function(self, Position, Range)
		local Count = 0 --FeelsBadMan
		local HeroList = ObjectManager.HeroList
		for i, Hero in pairs(HeroList) do	
			if Hero.Team == myHero.Team and Hero.IsDead == false then
				if Prediction:GetDistance(Hero.Position, Position) < Range then
					Count = Count + 1
				end
			end
		end
		return Count
	end,
	CampAlive = function(self, Position, Range, MonsterName)
		local Count = 0 --FeelsBadMan
		local MinionList = ObjectManager.MinionList
		for i, Minion in pairs(MinionList) do	
			if Minion.Team == 300 and Minion.IsDead == false then
				if Prediction:GetDistance(Minion.Position, Position) < Range then
					if string.find(Minion.ChampionName, MonsterName) ~= nil then
						Count = Count + 1
					end
				end
			end
		end
		return Count
	end,
	GetSummonerName = function(self, Slot)
		local Name = Slot.Info.Name
		--print(Name)
		if string.find(Name, "Dot", 8) ~= nil then
			return "Ignite"
		end
		if string.find(Name, "HextechFlash", 8) ~= nil then
			return "HexFlash"
		end
		if string.find(Name, "Snowball", 8) ~= nil then
			return "Snowball"
		end
		if string.find(Name, "Mana", 8) ~= nil then
			return "Clarity"
		end
		if string.find(Name, "Flash", 8) ~= nil then
			return "Flash"
		end
		if string.find(Name, "Haste", 8) ~= nil then
			return "Ghost"
		end
		if string.find(Name, "Heal", 8) ~= nil then
			return "Heal"
		end
		if string.find(Name, "Barrier", 8) ~= nil then
			return "Barrier"
		end
		if string.find(Name, "Exhaust", 8) ~= nil then
			return "Exhaust"
		end
		if string.find(Name, "Teleport", 8) ~= nil then
			return "Teleport"
		end
		if string.find(Name, "Smite", 8) ~= nil then
			return "Smite"
		end
		if string.find(Name, "Boost", 8) ~= nil then
			return "Cleanse"
		end		
		return Name
	end,
	GetSpellSlotCD = function(self, Slot)
		local Level = Slot.Level
		local CD 	= Slot.Cooldown - GameClock.Time
		if Level > 0 then
			return CD
		else
			return nil
		end
	end,
	GetAllJungleMinions = function(self)
        local Monsters = {}
        local Minions = ObjectManager.MinionList
        for _, Object in pairs(Minions) do
            if Object.Team == 300 then
                Monsters[#Monsters+1] = Object
            end
        end
        return Monsters
    end,
	GetRecallState = function(self,Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State ~= Hero.RecallState then
				return Hero.RecallState
			end	

			return self.Tracker[Hero.Index].Recall.State
		end
		return 0
	end,
	GetRecallStartTime = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State ~= Hero.RecallState and Hero.RecallState > 0 then
				return GameClock.Time
			end

			return self.Tracker[Hero.Index].Recall.StartTime
		end
		return 0.0
	end,
	GetRecallEndTime = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State > 0 then
				if self.Tracker[Hero.Index].Recall.State == 6 then --Recall
					return self.Tracker[Hero.Index].Recall.StartTime + 8.0	
				end
				if self.Tracker[Hero.Index].Recall.State == 16 then --Teleport
					return self.Tracker[Hero.Index].Recall.StartTime + 4.0	
				end
				if self.Tracker[Hero.Index].Recall.State == 11 then --SuperRecall
					return self.Tracker[Hero.Index].Recall.StartTime + 4.0	
				end				
			end

			return self.Tracker[Hero.Index].Recall.EndTime	
		end
		return 0.0
	end,
	GetIsRecallCanceled = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State ~= Hero.RecallState and self.Tracker[Hero.Index].Recall.StartTime > 0 and self.Tracker[Hero.Index].Recall.EndTime > 0 then
				return (self.Tracker[Hero.Index].Recall.EndTime-0.1 >= GameClock.Time and GameClock.Time > self.Tracker[Hero.Index].Recall.StartTime) and Hero.RecallState == 0
			end

			return self.Tracker[Hero.Index].Recall.Canceled
		end
		return false
	end,
	GetIsRecallFinished = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State ~= Hero.RecallState and self.Tracker[Hero.Index].Recall.StartTime > 0 and self.Tracker[Hero.Index].Recall.EndTime > 0 then
				return self.Tracker[Hero.Index].Recall.EndTime-0.1 <= GameClock.Time and self.Tracker[Hero.Index].Recall.Canceled == false and Hero.RecallState == 0
			end

			return self.Tracker[Hero.Index].Recall.Finished
		end
		return false		
	end,
	GetRecallCancelTime = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State ~= Hero.RecallState and self.Tracker[Hero.Index].Recall.StartTime > 0 and self.Tracker[Hero.Index].Recall.EndTime > 0 then
				if (self.Tracker[Hero.Index].Recall.EndTime-0.1 >= GameClock.Time and GameClock.Time > self.Tracker[Hero.Index].Recall.StartTime) and Hero.RecallState == 0 then
					return GameClock.Time
				end
			end
			if self.Tracker[Hero.Index].Recall.Finished == true then
				return 0
			end
			
			return self.Tracker[Hero.Index].Recall.CancelTime	
		end
		return 0	
	end,
	GetRecallFinishTime = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.State ~= Hero.RecallState and self.Tracker[Hero.Index].Recall.StartTime > 0 and self.Tracker[Hero.Index].Recall.EndTime > 0 then
				if self.Tracker[Hero.Index].Recall.EndTime-0.1 <= GameClock.Time and self.Tracker[Hero.Index].Recall.Canceled == false and Hero.RecallState == 0 then
					return GameClock.Time
				end
			end
			if self.Tracker[Hero.Index].Recall.Canceled == true then
				return 0
			end
			
			return self.Tracker[Hero.Index].Recall.FinishTime	
		end
		return 0		
	end,
	GetLastSeenTime = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if Hero.IsDead == true then
				return GameClock.Time
			end
			if Hero.AIData.NavLength > 0 or Hero.IsVisible or self:GetDistance(self.Tracker[Hero.Index].Map.LastPosition, Hero.Position) > 0 then--or Hero.AIData.Dashing or Hero.AIData.Moving then
				return GameClock.Time
			end
			if self.Tracker[Hero.Index].Recall.Finished == true and self.Tracker[Hero.Index].Map.LastSeen < self.Tracker[Hero.Index].Recall.FinishTime then
				return self.Tracker[Hero.Index].Recall.FinishTime
			end
			--[[local MissileList = ObjectManager.MissileList
			for _, Missile in pairs(MissileList) do
				if Missile.SourceIndex == Hero.Index and Hero.IsVisible == false then
					if self:GetDistance(self.Tracker[Hero.Index].Map.Position, Missile.Position) < self.Tracker[Hero.Index].Map.Radius then
						--print("MissileCheck!")
						return GameClock.Time
					end
				end
			end]]
			for i = 4 , 5 do
				if string.find(Hero:GetSpellSlot(i).Info.Name, "Smite") ~= nil  then
					local MinionList = ObjectManager.MinionList
					for _, Minion in pairs(MinionList) do
						if Minion.Team == 300 and Minion.IsVisible == false then
							if self:AlliesInRange(Minion.Position, 1500) == 0 then
								if Minion.ChampionName == "SRU_Gromp" or string.find(Minion.ChampionName, "Razor") ~= nil or Minion.ChampionName == "SRU_Blue" or string.find(Minion.ChampionName, "Crab") ~= nil or Minion.ChampionName == "SRU_Red" or string.find(Minion.ChampionName, "wolf") ~= nil or string.find(Minion.ChampionName, "Krug") ~= nil then
									if Minion.IsDead and self.Tracker[Hero.Index].Map.Timer >= 2 then
										--print("minionDeadCheck!")
										return GameClock.Time
									end
								end
							end
						end
					end
				end
			end

			return self.Tracker[Hero.Index].Map.LastSeen	
		end
		return GameClock.Time
	end,
	GetMapPosition = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if self.Tracker[Hero.Index].Recall.Finished == true and self.Tracker[Hero.Index].Map.LastSeen == self.Tracker[Hero.Index].Recall.FinishTime then
				return self:GetBasePosition(Hero)
			end	
			if self:GetDistance(self.Tracker[Hero.Index].Map.LastPosition, Hero.Position) > 0 or Hero.AIData.NavLength > 0 then --or Hero.AIData.Dashing or Hero.AIData.Moving then
				return Hero.Position
			end
			--[[local MissileList = ObjectManager.MissileList
			for _, Missile in pairs(MissileList) do
				if Missile.SourceIndex == Hero.Index and Hero.IsVisible == false then
					if self:GetDistance(self.Tracker[Hero.Index].Map.Position, Missile.Position) < self.Tracker[Hero.Index].Map.Radius then
						--print("MissileCheck!")
						return Missile.MissileStartPos
					end
				end
			end		]]	
			for i = 4 , 5 do
				if string.find(Hero:GetSpellSlot(i).Info.Name, "Smite") ~= nil  then
					local MinionList = ObjectManager.MinionList
					for _, Minion in pairs(MinionList) do
						if Minion.Team == 300 and Minion.IsVisible == false then
							if self:AlliesInRange(Minion.Position, 1500) == 0 then
								if Minion.ChampionName == "SRU_Gromp" or string.find(Minion.ChampionName, "Razor") ~= nil or Minion.ChampionName == "SRU_Blue" or string.find(Minion.ChampionName, "Crab") ~= nil or Minion.ChampionName == "SRU_Red" or string.find(Minion.ChampionName, "wolf") ~= nil or string.find(Minion.ChampionName, "Krug") ~= nil then
									if Minion.IsDead and self.Tracker[Hero.Index].Map.Timer >= 2 then
										--print("minionDeadCheck!")
										return Minion.Position
									end
								end
							end
						end
					end
				end
			end

			return self.Tracker[Hero.Index].Map.Position		
		end
		return Hero.Position
	end,
	GetMapTimer = function(self, Hero)
		if self.Tracker[Hero.Index] then
			if Hero.RecallState > 0 then
				return self.Tracker[Hero.Index].Map.Timer
			end
			if self.Tracker[Hero.Index].Recall.Finished == false and self.Tracker[Hero.Index].Recall.Canceled == true and self.Tracker[Hero.Index].Recall.CancelTime > self.Tracker[Hero.Index].Map.LastSeen then
				return GameClock.Time - (self.Tracker[Hero.Index].Map.LastSeen + (self.Tracker[Hero.Index].Recall.CancelTime - self.Tracker[Hero.Index].Map.LastSeen))
			end
			
			return GameClock.Time - self.Tracker[Hero.Index].Map.LastSeen
		end
		return 0.0			
	end,
	GetMonsterSpawnTime = function(self, Minion)
		if self.JTracker[Minion.Index] then
			--print(self.JTracker[Minion.Index].Object.ChampionName)
			local Timer = 135
			if Minion.ChampionName == "Sru_Crab" then
				Timer = 150
			end
			if Minion.ChampionName == "SRU_Blue" or Minion.ChampionName == "SRU_Red" then
				Timer = 300
			end
			if Minion.IsVisible == false then
				Timer = Timer - 3
			end
			if self.JTracker[Minion.Index].Timer == nil or self.JTracker[Minion.Index].Timer <= 0 then
				--print(GameClock.Time + Timer)
				if Minion.IsDead then
					return GameClock.Time + Timer
				end
			end
			return self.JTracker[Minion.Index].SpawnTime
		end
		return 0.0			
	end,
	GetMapRadius = function(self, Hero)
		if self.Tracker[Hero.Index] then
			return self.Tracker[Hero.Index].Map.Timer * Hero.MovementSpeed
		end
		return 0.0			
	end,
	GetIsWard = function(self, Minion)
		if Minion.Name == "SightWard" then
			return true
		end
		if Minion.Name == "VisionWard" then
			return true
		end
		if Minion.Name == "JammerDevice" then
			return true
		end
		if Minion.Name == "Noxious Trap" then
			return true
		end
		if Minion.Name == "Jack In The Box" then 
			return true
		end
		if Minion.Name == "Cupcake" then 
			return true
		end
		return false
	end,
	--FEATURE FUNCTIONS
	GetMonsterTimer = function(self, Minion)
		if self.JTracker[Minion.Index] then
			local Spawn = self.JTracker[Minion.Index].SpawnTime
			--print(self.JTracker[Minion.Index].Object.ChampionName)
			if Spawn ~= nil then
				return Spawn - GameClock.Time
			else
				return 0
			end
		end
		return nil
	end,
	GetJungleTracker = function(self)
		local JTracker = {}
		local JungleList = self:GetAllJungleMinions()
		for _, Minion in pairs(JungleList) do
			JTracker[Minion.Index] = {
				Object		= Minion,
				Position 	= Minion.Position,
				SpawnTime	= self:GetMonsterSpawnTime(Minion),
				Timer		= self:GetMonsterTimer(Minion),
			}
		end
		return JTracker
	end,
	KindredMarkSpawn = function(self)
		local list = ObjectManager.TroyList
		for i, troy in pairs(list) do 
			if troy.Position ~= nil then
				Render:DrawCircle(troy.Position, 15, 255, 0, 255, 255)
			end
		end
	end,
	GetJTimerList = function(self)
		local JTimerList = {}
		--print(JTimerList[1])
        --Monsters[#Monsters+1] = Object
		for _, Element in pairs(self.JTracker) do
			local Minion 		= Element.Object
			local Timer 		= Element.Timer
			--if self:GetDistance(Minion.Position, myHero.Position) < 500 then
				--Minion.BuffData:ShowAllBuffs()
			--end
			if Minion.IsDead then
				--print("d")
				if Minion.ChampionName == "SRU_Blue" then
					local StaticPos = Vector3.new(3734.9819335938, 52.791561126709, 7890.0)
					--print(Minion.Position.x, Minion.Position.y, Minion.Position.z) --3734.9819335938 52.791561126709 52.791561126709
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Blue1Timer < GameClock.Time then
						self.Blue1Pos = StaticPos
						if Minion.IsVisible then
							self.Blue1Timer = GameClock.Time + 300
						else
							self.Blue1Timer = GameClock.Time + 297
						end
					end
				end
				if Minion.ChampionName == "SRU_Blue" then
					local StaticPos = Vector3.new(11032.0, 51.723670959473, 7002.0)
					--print(Minion.Position.x, Minion.Position.y, Minion.Position.z) --11032.0 51.723670959473 7002.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Blue2Timer < GameClock.Time then
						self.Blue2Pos = StaticPos
						if Minion.IsVisible then
							self.Blue2Timer = GameClock.Time + 300
						else
							self.Blue2Timer = GameClock.Time + 297
						end
					end
				end
				--print(Minion.ChampionName)
				if string.find(Minion.ChampionName, "wolf") then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					--print("OK?")
					local StaticPos = Vector3.new(3780.6279296875, 52.463195800781, 6443.98388671889)
					--print(Minion.Position.x, Minion.Position.y, Minion.Position.z) --3780.6279296875 52.463195800781 6443.98388671889
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Wolf1Timer < GameClock.Time and self:CampAlive(StaticPos, 2000, "wolf") == 0 then
						self.Wolf1Pos = StaticPos
						if Minion.IsVisible then
							self.Wolf1Timer = GameClock.Time + 135
						else
							self.Wolf1Timer = GameClock.Time + 132
						end
					end
				end
				if string.find(Minion.ChampionName, "wolf") then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(11008.0, 62.131362915039, 8386.0)
					--print(Minion.Position.x, Minion.Position.y, Minion.Position.z) --11008.0 62.131362915039 8386.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Wolf2Timer < GameClock.Time and self:CampAlive(StaticPos, 2000, "wolf") == 0 then
						self.Wolf2Pos = StaticPos
						if Minion.IsVisible then
							self.Wolf2Timer = GameClock.Time + 135
						else
							self.Wolf2Timer = GameClock.Time + 132
						end
					end
				end
				if Minion.ChampionName == "SRU_Gromp" then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(2112.0  ,       51.777313232422 ,       8450.0)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Gromp1Timer < GameClock.Time then
						self.Gromp1Pos = StaticPos
						if Minion.IsVisible then
							self.Gromp1Timer = GameClock.Time + 135
						else
							self.Gromp1Timer = GameClock.Time + 132
						end
					end
				end
				if Minion.ChampionName == "SRU_Gromp" then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(12702.0 ,       51.691425323486 ,       6444.0)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Gromp2Timer < GameClock.Time then
						self.Gromp2Pos = StaticPos
						if Minion.IsVisible then
							self.Gromp2Timer = GameClock.Time + 135
						else
							self.Gromp2Timer = GameClock.Time + 132
						end
					end
				end
				if string.find(Minion.ChampionName, "Krug") ~= nil then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(8482.470703125  ,       50.648094177246 ,       2705.9479980469)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Krug1Timer < GameClock.Time and self:CampAlive(StaticPos, 2000, "Krug") == 0 then
						self.Krug1Pos = StaticPos
						if Minion.IsVisible then
							self.Krug1Timer = GameClock.Time + 135
						else
							self.Krug1Timer = GameClock.Time + 132
						end
					end
				end
				if string.find(Minion.ChampionName, "Krug") ~= nil then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(6317.0922851562 ,       56.47679901123  ,       12146.458007812)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Krug2Timer < GameClock.Time and self:CampAlive(StaticPos, 2000, "Krug") == 0 then
						self.Krug2Pos = StaticPos
						if Minion.IsVisible then
							self.Krug2Timer = GameClock.Time + 135
						else
							self.Krug2Timer = GameClock.Time + 132
						end
					end
				end
				if Minion.ChampionName == "SRU_Red" then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(7772.0  ,       53.933303833008 ,       4028.0)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Red1Timer < GameClock.Time then
						self.Red1Pos = StaticPos
						if Minion.IsVisible then
							self.Red1Timer = GameClock.Time + 300
						else
							self.Red1Timer = GameClock.Time + 297
						end
					end
				end
				if Minion.ChampionName == "SRU_Red" then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(7108.0  ,       56.300552368164 ,       10892.0)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Red2Timer < GameClock.Time then
						self.Red2Pos = StaticPos
						if Minion.IsVisible then
							self.Red2Timer = GameClock.Time + 300
						else
							self.Red2Timer = GameClock.Time + 297
						end
					end
				end
				if string.find(Minion.ChampionName, "Razor") ~= nil then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(6823.8950195312 ,       54.782833099365 ,       5507.755859375)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Chicken1Timer < GameClock.Time and self:CampAlive(StaticPos, 2000, "Razor") == 0 then
						self.Chicken1Pos = StaticPos
						if Minion.IsVisible then
							self.Chicken1Timer = GameClock.Time + 135
						else
							self.Chicken1Timer = GameClock.Time + 132
						end
					end
				end
				if string.find(Minion.ChampionName, "Razor") ~= nil then -- "SRU_Krug" "SRU_Red" "Sru_Crab" "SRU_Blue" "SRU_Murkwolf" "SRU_Razorbeak" "SRU_Gromp"
					local StaticPos = Vector3.new(7986.9970703125 ,       52.347938537598 ,       9471.388671875)
					--print(Minion.Position.x,",",Minion.Position.y,",",Minion.Position.z) --2102.0  51.777328491211 8454.0
					--Render:DrawCircle(StatB1Pos, 50,255,255,255,255)
					if self:GetDistance(Minion.Position, StaticPos) < 2000 and self.Chicken2Timer < GameClock.Time and self:CampAlive(StaticPos, 2000, "Razor") == 0 then
						self.Chicken2Pos = StaticPos
						if Minion.IsVisible then
							self.Chicken2Timer = GameClock.Time + 135
						else
							self.Chicken2Timer = GameClock.Time + 132
						end
					end
				end
			end
		end
		return JTimerList
	end,
	GetChampionTracker = function(self)
		local Counter = 0
		local Tracker = {}
		local HeroList = ObjectManager.HeroList
		for _, Hero in pairs(HeroList) do
			if Hero.Team ~= myHero.Team then
				Tracker[Hero.Index] = {
					Object 		= Hero,
					Position	= Vector3.new(self.ChampHUD_X.Value, self.ChampHUD_Y.Value + (Counter * 70), 0),
					Spells		= {
						[0] = {
							Name 		= "Q",
							Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(0)),	
							CooldownEnd	= Hero:GetSpellSlot(0).Cooldown,	
						},				
						[1] = {
							Name 		= "W",
							Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(1)),	
							CooldownEnd = Hero:GetSpellSlot(1).Cooldown,	
						},						
						[2] = {
							Name 		= "E",
							Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(2)),	
							CooldownEnd = Hero:GetSpellSlot(2).Cooldown,	
						},						
						[3] = {
							Name 		= "R",
							Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(3)),	
							CooldownEnd = Hero:GetSpellSlot(3).Cooldown,	
						},
						[4] = {
							Name		= self:GetSummonerName(Hero:GetSpellSlot(4)),
							Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(4)),						
							CooldownEnd = Hero:GetSpellSlot(4).Cooldown,						
						},
						[5] = {
							Name		= self:GetSummonerName(Hero:GetSpellSlot(5)),
							Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(5)),							
							CooldownEnd = Hero:GetSpellSlot(5).Cooldown,							
						},
					},
					Recall 		= {
						State 			= self:GetRecallState(Hero),
						StartTime 		= self:GetRecallStartTime(Hero),
						EndTime			= self:GetRecallEndTime(Hero),
						Canceled		= self:GetIsRecallCanceled(Hero),
						Finished		= self:GetIsRecallFinished(Hero),
						CancelTime  	= self:GetRecallCancelTime(Hero),
						FinishTime  	= self:GetRecallFinishTime(Hero),
					},
					Map 		= {
						Visible   		= Hero.IsVisible,
						Position  		= self:GetMapPosition(Hero),
						LastSeen  		= self:GetLastSeenTime(Hero),
						LastPosition 	= Hero.Position,
						Timer	  		= self:GetMapTimer(Hero),
						Radius	  		= self:GetMapRadius(Hero),
					},
				}		
				Counter = Counter+1	
			end
		end
		return Tracker
	end,
	GetChampionCooldowns = function(self)
		local Cooldowns = {}
		for _, Hero in pairs(ObjectManager.HeroList) do
			Cooldowns[Hero.Index] = {
				Object 		= Hero,
				Spells		= {
					[0] = {
						Name 		= "Q",
						Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(0)),	
						CooldownEnd	= Hero:GetSpellSlot(0).Cooldown,	
					},				
					[1] = {
						Name 		= "W",
						Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(1)),	
						CooldownEnd = Hero:GetSpellSlot(1).Cooldown,	
					},						
					[2] = {
						Name 		= "E",
						Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(2)),	
						CooldownEnd = Hero:GetSpellSlot(2).Cooldown,	
					},						
					[3] = {
						Name 		= "R",
						Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(3)),	
						CooldownEnd = Hero:GetSpellSlot(3).Cooldown,	
					},
					[4] = {
						Name		= self:GetSummonerName(Hero:GetSpellSlot(4)),
						Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(4)),						
						CooldownEnd = Hero:GetSpellSlot(4).Cooldown,						
					},
					[5] = {
						Name		= self:GetSummonerName(Hero:GetSpellSlot(5)),
						Cooldown 	= self:GetSpellSlotCD(Hero:GetSpellSlot(5)),							
						CooldownEnd = Hero:GetSpellSlot(5).Cooldown,							
					},
				},
			}		
		end
		return Cooldowns
	end,
	GetEnemyWards = function(self)
		local Wards = {}
		for I, Minion in pairs(ObjectManager.MinionList) do
			if Minion.Team ~= myHero.Team and self:GetIsWard(Minion) and Minion.IsDead == false then
				Wards[#Wards+1] = Minion
			end
		end
		return Wards
	end,
	DrawChampionHUD = function(self)
		for _, Element in pairs(self.Tracker) do
			local Name 	= Element.Object.ChampionName
			local X		= Element.Position.x
			local Y		= Element.Position.y

			Render:DrawString(Name .. ":", X, Y, 255,255,255,255)

			local XOFFSET 	= 120
			--HEALTHBAR
			if self.DrawHealthbar.Value == 1 then
				local Hero 		= Element.Object
				local Health 	= Hero.Health
				if Hero.IsDead then
					Health = 0				
				end
				local Size = 110 * (Health/Hero.MaxHealth)				
				Render:DrawFilledBox(X, Y+20, 114, 25, 0,0,0,255)
				Render:DrawFilledBox(X+2, Y+22, Size, 21, 0,200,0,255)
				Render:DrawString(string.format("%.0f",Health), X+5, Y+22, 255,255,255,255)
				Render:DrawString(string.format("| %.0f",Hero.MaxHealth), X+50, Y+22, 255,255,255,255)
			end
			--SPELLTRACKER
			local Spells = Element.Spells
			local R = Spells[3]
			local D = Spells[4]
			local F = Spells[5]

			if self.TimeUltimates.Value == 1 then
				if R.Cooldown then
					Render:DrawString("ULT: ", X + XOFFSET, Y, 255,255,255,255)
					if R.Cooldown >= 0 then
						if self.UltimateSeconds.Value == 1 then
							Render:DrawString(string.format("%.0f", R.Cooldown), X+XOFFSET+40, Y, 255,255,255,255)
						else
							local EndTime = R.CooldownEnd
							local Minutes = math.floor(EndTime / 60);
							local Seconds = math.floor(EndTime - Minutes * 60);
							Render:DrawString(string.format("%02d:%02d", Minutes,Seconds), X+XOFFSET+40, Y, 255,255,255,255)
						end
					else
						Render:DrawString("READY", X+XOFFSET+40, Y, 255,255,255,255)
					end		
				end	
			end
			--string.format("%02d:%02d", minutes,seconds)
			if self.TimeSummoners.Value == 1 then
				if D.Cooldown then
					Render:DrawString("S1: ", X + XOFFSET, Y + 15, 255,255,255,255)
					if D.Cooldown >= 0 then
						if self.SummonerSeconds.Value == 1 then
							Render:DrawString(string.format("%.0f", D.Cooldown), X+XOFFSET+40, Y + 15, 255,255,255,255)
						else
							local EndTime = D.CooldownEnd
							local Minutes = math.floor(EndTime / 60);
							local Seconds = math.floor(EndTime - Minutes * 60);
							Render:DrawString(string.format("%02d:%02d", Minutes,Seconds), X+XOFFSET+40, Y + 15, 255,255,255,255)
						end	
					else
						Render:DrawString("READY", X+XOFFSET+40, Y + 15, 255,255,255,255)
					end
					Render:DrawString("("..D.Name..")", X+XOFFSET+100, Y + 15, 255,255,255,255)			
				end

				if F.Cooldown then			
					Render:DrawString("S2: ", X + XOFFSET, Y + 30, 255,255,255,255)
					if F.Cooldown >= 0 then
						if self.SummonerSeconds.Value == 1 then
							Render:DrawString(string.format("%.0f", F.Cooldown), X+XOFFSET+40, Y + 30, 255,255,255,255)
						else
							local EndTime = F.CooldownEnd
							local Minutes = math.floor(EndTime / 60);
							local Seconds = math.floor(EndTime - Minutes * 60);
							Render:DrawString(string.format("%02d:%02d", Minutes,Seconds), X+XOFFSET+40, Y + 30, 255,255,255,255)
						end	
					else
						Render:DrawString("READY", X+XOFFSET+40, Y + 30, 255,255,255,255)
					end
					Render:DrawString("("..F.Name..")", X+XOFFSET+100, Y + 30, 255,255,255,255)			
				end
			end

			--RECALLS
			if self.DrawRecall.Value == 1 then
				local Recall = Element.Recall
				local State  = Recall.State
				local Start  = Recall.StartTime
				local End    = Recall.EndTime
				if Start and End and Start > 0 and End > 0 then
					local XOFFSET = XOFFSET -7
					if State == 6 then
						local Percent = (End-GameClock.Time) / 8
						if Percent > 0 and Percent < 1 then
							Render:DrawFilledBox(X, Y+50, XOFFSET, 20, 0,0,0,255)
							Render:DrawFilledBox(X+2, Y+52, (XOFFSET-4)*Percent, 16, 255,150,0,255)
							Render:DrawString("RECALL: ", X+2, Y + 50, 255,255,255,255)
							Render:DrawString(string.format("%.1f", End-GameClock.Time), X+80, Y + 50, 255,255,255,255)
						end
					end
					if State == 16 then
						local Percent = 1 - ((End-GameClock.Time) / 4)
						if Percent > 0 and Percent < 1 then
							Render:DrawFilledBox(X, Y+50, XOFFSET, 20, 0,0,0,255)
							Render:DrawFilledBox(X+2, Y+52, (XOFFSET-4)*Percent, 16, 0,150,255,255)
							Render:DrawString("TP: ", X, Y + 50, 255,255,255,255)
							Render:DrawString(string.format("%.1f", End-GameClock.Time), X+80, Y + 50, 255,255,255,255)
						end
					end
					if State == 11 then
						local Percent = (End-GameClock.Time) / 4
						if Percent > 0 and Percent < 1 then
							Render:DrawFilledBox(X, Y+50, XOFFSET, 20, 0,0,0,255)
							Render:DrawFilledBox(X+2, Y+52, (XOFFSET-4)*Percent, 16, 150,0,255,255)
							Render:DrawString("RECALL: ", X, Y + 50, 255,255,255,255)
							Render:DrawString(string.format("%.1f", End-GameClock.Time), X+80, Y + 50, 255,255,255,255)
						end
					end
					if State == 0 then
						if Recall.Finished and (Recall.FinishTime+4) > GameClock.Time then
							Render:DrawFilledBox(X, Y+50, XOFFSET, 20, 0,0,0,255)
							Render:DrawString("FINISHED!", X, Y + 50, 255,255,255,255)
						end
						if Recall.Canceled and (Recall.CancelTime+4) > GameClock.Time then
							Render:DrawFilledBox(X, Y+50, XOFFSET, 20, 0,0,0,255)
							Render:DrawString("CANCELED!", X, Y + 50, 255,255,255,255)
						end
					end
				end	
			end
		end
	end,
	DrawChampionCDS = function(self)
		for _, Element in pairs(self.Cooldowns) do
			local Hero 		= Element.Object
			local Spells 	= Element.Spells
			local ScreenPos = Vector3.new()
			Render:World2Screen(Hero.Position, ScreenPos)


			local Q = Spells[0]
			local W = Spells[1]
			local E = Spells[2]
			local R = Spells[3]
			local D = Spells[4]
			local F = Spells[5]

			local QString = " "
			local WString = " "
			local EString = " "
			local RString = " "
			local DString = " "
			local FString = " "

			if Q.Cooldown then
				QString = "Q"
				if Q.Cooldown >= 0 then
					QString = string.format("%.0f", Q.Cooldown)
				end
			end
			if W.Cooldown then				
				WString = "W"
				if W.Cooldown >= 0 then
					WString = string.format("%.0f", W.Cooldown)
				end
			end
			if E.Cooldown then
				EString = "E"
				if E.Cooldown >= 0 then
					EString = string.format("%.0f", E.Cooldown)
				end
			end
			if R.Cooldown then
				RString = "R"
				if R.Cooldown >= 0 then
					RString = string.format("%.0f", R.Cooldown)
				end
			end
			if D.Cooldown then
				DString = D.Name
				if D.Cooldown >= 0 then
					DString = string.format("%.0f", D.Cooldown)
				end
			end
			if F.Cooldown then
				FString = F.Name
				if F.Cooldown >= 0 then
					FString = string.format("%.0f", F.Cooldown)
				end
			end
			local SpellString 		= QString .. " " .. WString .. " " .. EString .. " " .. RString
			local SummonerString 	= DString .. "\n" .. FString
			if self.DrawEnemyCD.Value == 1 and Hero.Team ~= myHero.Team and Hero.IsTargetable then
				Render:DrawString(SpellString, ScreenPos.x - 30, ScreenPos.y + 30, 255,255,255,255)
				Render:DrawString(SummonerString, ScreenPos.x + 50, ScreenPos.y - 5, 255,255,255,255)
			end
			if self.DrawFriendCD.Value == 1 and Hero.Team == myHero.Team and Hero.IsTargetable then
				Render:DrawString(SpellString, ScreenPos.x - 30, ScreenPos.y + 30, 255,255,255,255)
				Render:DrawString(SummonerString, ScreenPos.x + 50, ScreenPos.y - 5, 255,255,255,255)
			end			
		end
	end,
	DrawCampTimer = function(self)
		if self.Blue1Timer > GameClock.Time then
			local Timer = self.Blue1Timer - GameClock.Time
			local MinionPos 	= self.Blue1Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Blue2Timer > GameClock.Time then
			local Timer = self.Blue2Timer - GameClock.Time
			local MinionPos 	= self.Blue2Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Wolf1Timer > GameClock.Time then
			local Timer = self.Wolf1Timer - GameClock.Time
			local MinionPos 	= self.Wolf1Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Wolf2Timer > GameClock.Time then
			local Timer = self.Wolf2Timer - GameClock.Time
			local MinionPos 	= self.Wolf2Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Krug1Timer > GameClock.Time then
			local Timer = self.Krug1Timer - GameClock.Time
			local MinionPos 	= self.Krug1Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Krug2Timer > GameClock.Time then
			local Timer = self.Krug2Timer - GameClock.Time
			local MinionPos 	= self.Krug2Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Red1Timer > GameClock.Time then
			local Timer = self.Red1Timer - GameClock.Time
			local MinionPos 	= self.Red1Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Red2Timer > GameClock.Time then
			local Timer = self.Red2Timer - GameClock.Time
			local MinionPos 	= self.Red2Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Chicken1Timer > GameClock.Time then
			local Timer = self.Chicken1Timer - GameClock.Time
			local MinionPos 	= self.Chicken1Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Chicken2Timer > GameClock.Time then
			local Timer = self.Chicken2Timer - GameClock.Time
			local MinionPos 	= self.Chicken2Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Gromp1Timer > GameClock.Time then
			local Timer = self.Gromp1Timer - GameClock.Time
			local MinionPos 	= self.Gromp1Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
		if self.Gromp2Timer > GameClock.Time then
			local Timer = self.Gromp2Timer - GameClock.Time
			local MinionPos 	= self.Gromp2Pos
			local MapPos		= Vector3.new()
			GameHud:World2Map(MinionPos, MapPos)
			Render:DrawString(string.format("%.0f", Timer), MapPos.x-20, MapPos.y-12, 255,255,255,255)
		end
	end,
	DrawChampionMAP = function(self)
		if self.DrawMapCircles.Value == 1 then
			for _, Element in pairs(self.Tracker) do
				local Map  		= Element.Map
				local Hero 		= Element.Object
				local Recall  	= Element.Recall
				local MapPos 	= Vector3.new()
				if Map.Visible == false and Hero.IsDead == false then
					GameHud:World2Map(Map.Position, MapPos)
					local NameSymbol 	= "(".. string.sub(Hero.ChampionName, 1, 2)..")"
					local NR		= 255
					local NB 		= 255
					local NG 		= 255
					if self:GetDistance(Map.Position, myHero.Position) < Map.Radius then
						NR		= 255
						NB 		= 0
						NG 		= 0
					else
						if self:GetDistance(Map.Position, myHero.Position) < Map.Radius + ((Hero.MovementSpeed * 10) - (myHero.MovementSpeed * 3)) then
							NR		= 255
							NB 		= 220
							NG 		= 0
						end
					end

					Render:DrawString(NameSymbol, MapPos.x -18, MapPos.y-13, NR,NB,NG,255)
					Render:DrawString(string.format("%.0f", Map.Timer), MapPos.x-16, MapPos.y, 255,220,0,255)
					Render:DrawCircleMap(Map.Position, Map.Radius, 255, 255, 255, 255)
					if self:GetDistance(Map.Position, myHero.Position) < Map.Radius + ((Hero.MovementSpeed * 10) - (myHero.MovementSpeed * 3)) then
						local R = 189
						local G = 4
						local B = 4
				
						local RN = 255
						local GN = 255
						local BN = 255
				
						local RG = 181
						local GG = 130
						local BG = 54

						local Y, X = 500, -200

						local Time2Gank 	= (self:GetDistance(Map.Position, myHero.Position) - Map.Radius) / Hero.MovementSpeed
						local LastSpot2my	= self:GetDistance(Map.Position, myHero.Position) / Hero.MovementSpeed
						--print(LastSpot2my)

						local RoundedTime 	= math.floor(Time2Gank + 0.5)
						local FirstText 	= RoundedTime
						if RoundedTime < 0 then
							FirstText = "NEAR!"
						else
							R = 255
							G = 140
							B = 0
						end

						local Alert			= "       (" .. Hero.ChampionName .. "): GANK ALERT!"
						if RoundedTime > -20 and LastSpot2my < 20 then
							Render:DrawFilledBox(Y+300 -2, X+320-2+(32*self.Weapon_Ord_Draw), 114+20+4+100, 25+4, RG,GG,BG,175)
							Render:DrawFilledBox(Y+302, X+322+(32*self.Weapon_Ord_Draw), 110+20+100, 21, R,G,B,190)
							Render:DrawString(string.format(FirstText), Y+300+5, X+300+22+(32*self.Weapon_Ord_Draw), RN,GN,BN,255)
							Render:DrawString(Alert, Y+300+5+20, X+300+22+(32*self.Weapon_Ord_Draw), RN,GN,BN,255)
							self.Weapon_Ord_Draw = self.Weapon_Ord_Draw + 1
						end
					end
				end
			end
		end
	end,
	DrawEnemyWardsF = function(self)
		if self.DrawEnemyWards.Value == 1 then
			local outVec = Vector3.new()
			for _, Ward in pairs(self.Wards) do
				local Name = Ward.Name
				if Name == "Cupcake" then
					Name = "Trap"
				elseif Name == "JammerDevice" then
					Render:DrawCircleMap(Ward.Position, 900, 199, 21, 133, 255)
				else
					Render:DrawCircleMap(Ward.Position, 900, 255, 165, 0, 255)
				end
				Render:DrawCircle(Ward.Position, 65, 0, 200, 100, 255)
				if Render:World2Screen(Ward.Position, outVec) then
					Render:DrawString(Name, outVec.x, outVec.y, 0, 200, 100, 255)
					--Render:DrawString(Target.Mana, outVec.x, outVec.y+40, 0, 200, 100, 255)
				end		
			end
		end
	end,
	DrawTurretRanges = function(self)
		for _, Turret in pairs(ObjectManager.TurretList) do
			if Turret.IsDead == false then
				if self.DrawEnemyTurret.Value == 1 and Turret.Team ~= myHero.Team then
					Render:DrawCircle(Turret.Position, 900, 255, 0, 0, 255)
				end
				if self.DrawFriendTurret.Value == 1 and Turret.Team == myHero.Team then
					Render:DrawCircle(Turret.Position, 900, 0, 255, 0, 255)
				end
			end
		end
	end,
	DrawWaypoints = function(self)
		local HeroScreenPos 	= Vector3.new()
		local TargetScreenPos 	= Vector3.new()
		for _, Hero in pairs(ObjectManager.HeroList) do
			if Hero.IsDead == false then
				Render:World2Screen(Hero.Position, HeroScreenPos)
				Render:World2Screen(Hero.AIData.TargetPos, TargetScreenPos)
				if self.DrawEnemyWaypoint.Value == 1 and Hero.Team ~= myHero.Team then
					Render:DrawCircle(Hero.AIData.TargetPos, 50, 200, 0, 0, 255)
					Render:DrawString(Hero.ChampionName, TargetScreenPos.x - 25, TargetScreenPos.y, 200,0,0,255)
					Render:DrawLine(HeroScreenPos, TargetScreenPos, 200,0,0,255)
				end
				if self.DrawFriendWaypoint.Value == 1 and Hero.Team == myHero.Team then
					Render:DrawCircle(Hero.AIData.TargetPos, 50, 0, 200, 0, 255)
					Render:DrawString(Hero.ChampionName, TargetScreenPos.x - 25, TargetScreenPos.y, 0,200,0,255)
					Render:DrawLine(HeroScreenPos, TargetScreenPos, 0,200,0,255)
				end	
			end
		end
	end,
	--CALLBACK FUNCTIONS
	OnTick = function(self) 
		--print(self.Blue1Timer)
		--self:KindredMarkSpawn()
	end,
	OnDraw = function(self)
		self.Weapon_Ord_Draw = 0
		--self:GetJTimerList()
		self.Tracker 	= self:GetChampionTracker()	
		self.JTracker 	= self:GetJungleTracker()
		self.JTrackerList 	= self:GetJTimerList()
		self.Cooldowns 	= self:GetChampionCooldowns()
		self.Wards		= self:GetEnemyWards()		
		self:DrawChampionHUD()
		self:DrawChampionCDS()
		self:DrawChampionMAP()
		self:DrawCampTimer()
		self:DrawEnemyWardsF()
		self:DrawTurretRanges()
		self:DrawWaypoints()
	end,
	OnLoad = function(self)
		AddEvent("OnSettingsSave" , function() self:SaveSettings() end)
		AddEvent("OnSettingsLoad" , function() self:LoadSettings() end)
	
	
		self:Init()
		AddEvent("OnTick", function() self:OnTick() end)	
		AddEvent("OnDraw", function() self:OnDraw() end)	
	end,
}

AddEvent("OnLoad", function() Awareness:OnLoad() end)	