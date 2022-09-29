Jinx = {}
function Jinx:__init()

	if myHero.Team == 100 then
		self.EnemyBase = Vector3.new(14400, 200, 14400)
	else
		self.EnemyBase = Vector3.new(400, 200, 400)
	end

	
	self.QRange = 175
	self.WRange = 1440
	self.ERange = 475

	self.QSpeed = math.huge
	self.WSpeed = 3300
	self.ESpeed = math.huge
	self.RSpeed = 2200

	self.QDelay = 0.25 
	self.WDelay = 0.6
	self.EDelay = 0.5
	self.RDelay = 0.6

	self.WWidth = 120
	self.EWidth = 150
	self.RWidth = 280

	self.WHitChance = 0.2
	self.EHitChance = 0.2
	self.RHitChance = 0.2


    self.ChampionMenu = Menu:CreateMenu("Jinx")
	-------------------------------------------
    self.ComboMenu = self.ChampionMenu:AddSubMenu("Combo")
    self.ComboUseQ = self.ComboMenu:AddCheckbox("UseQ in combo", 1)
    self.ComboUseW = self.ComboMenu:AddCheckbox("UseW in combo", 1)
    self.ComboUseE = self.ComboMenu:AddCheckbox("UseE in combo", 1)
    self.ComboUseR = self.ComboMenu:AddCheckbox("UseR in combo", 1)
	self.RRange	   = self.ComboMenu:AddSlider("Range for R use", 5000, 2000, 25000, 1000)


	self.HarassMenu = self.ChampionMenu:AddSubMenu("Harass")
    self.HarassUseQ = self.HarassMenu:AddCheckbox("UseQ in harass", 1)
    self.HarassUseW = self.HarassMenu:AddCheckbox("UseW in harass", 1)
    self.HarassUseE = self.HarassMenu:AddCheckbox("UseE in harass", 1)

	
	self.BaseMenu  = self.ChampionMenu:AddSubMenu("BaseUlt")
    self.BaseUseR  = self.BaseMenu:AddCheckbox("Enabled", 1)
	
	self.ComboMenu = self.ChampionMenu:AddSubMenu("Drawings")
    self.DrawQ = self.ComboMenu:AddCheckbox("DrawQ", 1)
    self.DrawW = self.ComboMenu:AddCheckbox("DrawW", 1)
    self.DrawE = self.ComboMenu:AddCheckbox("DrawE", 1)
	
	Jinx:LoadSettings()
end

function Jinx:SaveSettings()
	SettingsManager:CreateSettings("Jinx")
	SettingsManager:AddSettingsGroup("Combo")
	SettingsManager:AddSettingsInt("UseQ in combo", self.ComboUseQ.Value)
	SettingsManager:AddSettingsInt("UseW in combo", self.ComboUseW.Value)
	SettingsManager:AddSettingsInt("UseE in combo", self.ComboUseE.Value)
	SettingsManager:AddSettingsInt("UseR in combo", self.ComboUseR.Value)
	SettingsManager:AddSettingsInt("RSlider", self.RRange.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("Harass")
	SettingsManager:AddSettingsInt("UseQ in harass", self.HarassUseQ.Value)
	SettingsManager:AddSettingsInt("UseW in harass", self.HarassUseW.Value)
	SettingsManager:AddSettingsInt("UseE in harass", self.HarassUseE.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("BaseUlt")
	SettingsManager:AddSettingsInt("Enabled", self.BaseUseR.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("Drawings")
	SettingsManager:AddSettingsInt("DrawQ", self.DrawQ.Value)
	SettingsManager:AddSettingsInt("DrawW", self.DrawW.Value)
	SettingsManager:AddSettingsInt("DrawE", self.DrawE.Value)
end

function Jinx:LoadSettings()
	SettingsManager:GetSettingsFile("Jinx")
	self.ComboUseQ.Value = SettingsManager:GetSettingsInt("Combo","UseQ in combo")
	self.ComboUseW.Value = SettingsManager:GetSettingsInt("Combo","UseW in combo")
	self.ComboUseE.Value = SettingsManager:GetSettingsInt("Combo","UseE in combo")
	self.ComboUseR.Value = SettingsManager:GetSettingsInt("Combo","UseR in combo")
	self.RRange.Value 	 = SettingsManager:GetSettingsInt("Combo","RSlider")
	-------------------------------------------------------------
	self.HarassUseQ.Value = SettingsManager:GetSettingsInt("Harass","UseQ in harass")
	self.HarassUseW.Value = SettingsManager:GetSettingsInt("Harass","UseW in harass")
	self.HarassUseE.Value = SettingsManager:GetSettingsInt("Harass","UseE in harass")
	-------------------------------------------------------------
	self.BaseUseR.Value = SettingsManager:GetSettingsInt("BaseUlt","Enabled")
	-------------------------------------------------------------
	self.DrawQ.Value = SettingsManager:GetSettingsInt("Drawings","DrawQ")
	self.DrawW.Value = SettingsManager:GetSettingsInt("Drawings","DrawW")
	self.DrawE.Value = SettingsManager:GetSettingsInt("Drawings","DrawE")
end

function Jinx:GetDistance(from , to)
    return math.sqrt((from.x - to.x) ^ 2 + (from.z - to.z) ^ 2)
end

function Jinx:CastRToEnemyBase()
	Engine:CastSpellMap("HK_SPELL4", self.EnemyBase ,1)
end

function Jinx:getAttackRange()
    local attRange = myHero.AttackRange + myHero.CharData.BoundingRadius
    return attRange
end

function Jinx:EnemiesInRange(Position, Range)
    local Count = 0 --FeelsBadMan
    local HeroList = ObjectManager.HeroList
    for i, Hero in pairs(HeroList) do    
        if Hero.Team ~= myHero.Team and Hero.IsTargetable then
            if self:GetDistance(Hero.Position , Position) < Range then
                Count = Count + 1
            end
        end
    end
    return Count
end

function Jinx:MinionsInRange(Position, Range)
    local Count = 0 --FeelsBadMan
    local MinionList = ObjectManager.MinionList
    for i, Minion in pairs(MinionList) do    
        if Minion.Team ~= myHero.Team and Minion.IsTargetable then
            if self:GetDistance(Minion.Position , Position) < Range then
                Count = Count + 1
            end
        end
    end
    return Count
end

local function GetHeroLevel(Target)
    local totalLevel = Target:GetSpellSlot(0).Level + Target:GetSpellSlot(1).Level + Target:GetSpellSlot(2).Level + Target:GetSpellSlot(3).Level
    return totalLevel
end

function Jinx:GetRDamage(Target, Time)
	local Vis = Target.IsVisible
	local Timer = Time
	local MissingHealth 			= Target.MaxHealth - Target.Health
	local ArmorMod 					= 100 / (100 + Target.Armor)
	local RLevel 					= myHero:GetSpellSlot(3).Level
	local DMG 						= 100 + (150 * RLevel) + (myHero.BonusAttack * 1.5) + (MissingHealth * (0.20 + (0.05*RLevel))) 
	if Vis == false then
		Timer = Timer + Awareness:GetMapTimer(Target)
	end
	FixedHealth = Timer * (2.1 + 0.21 * GetHeroLevel(Target))
	return (DMG * ArmorMod) - FixedHealth
end

function Jinx:CheckBaseUlt()
	local Distance 					= self:GetDistance(self.EnemyBase, myHero.Position)
	local GameTime					= GameClock.Time
	
	local RSpeed1 = 1700
	local RSpeed2 = 2200

	local Time1 =  1350 / RSpeed1
	local Time2 = (Distance - 1350) / RSpeed2
	local TravelTime = Time1
	if Distance > 1350 then
		TravelTime = Time1 + Time2
	end
	TravelTime = TravelTime + self.RDelay

	local Heros = ObjectManager.HeroList
	for I, Hero in pairs(Heros) do
		if Engine:SpellReady("HK_SPELL4") then
			local Tracker = Awareness.Tracker[Hero.Index]
			if Tracker then
				local State = Tracker.Recall.State
				local Start = Tracker.Recall.StartTime
				local End 	= Tracker.Recall.EndTime
				if State == 6 and Start < End then
					local RecallTime 		= End - GameTime
					local RDMG				= self:GetRDamage(Hero, TravelTime + 0.5)
					-- no regeneration HP so we add 30 as safeguard.
					local enemyHP = Hero.Health + 50
					if RecallTime > 0 and RDMG > enemyHP and TravelTime >= RecallTime and TravelTime < (RecallTime + 0.5) then
						return true
					end
				end
			end
		end
	end
	
	return false
end

function Jinx:GapCloseTarget()
	local Heros = ObjectManager.HeroList
	for I, Hero in pairs(Heros) do
		if Hero.Team ~= myHero.Team then
			if Hero.AIData.IsDashing == true then
				local TargetPos = Target.AIData.TargetPos
				local Distance = self:GetDistance(TargetPos, myHero.Position)
				if Distance < self.ERange then
					return Hero
				end
			end
		end
	end
	return nil
end

function Jinx:Combo()
	if self.ComboUseR.Value == 1 and Engine:SpellReady("HK_SPELL4") then
		local target = Orbwalker:GetTarget("Combo", self.RRange.Value)
		if target then
			local RealRSpeed = self.RSpeed
			local TargetDist = self:GetDistance(myHero.Position, target.Position)
			if TargetDist < 1350 then
				RealRSpeed = 1700
			else
				local ExtraTravel = TargetDist - 1350 
				local Speed1 = (1350 / TargetDist) * 1700
				local Speed2 = (TargetDist / 1350) * 2200
				local TotalSpeed = (Speed1 + Speed2) / 2
				RealRSpeed = TotalSpeed
			end
			local StartPos 			= myHero.Position
			local CastPos = Prediction:GetCastPos(StartPos, self.RRange.Value, RealRSpeed, self.RWidth, self.RDelay, 1, 1, self.RHitChance, 1)
			if CastPos ~= nil then
				local Distance 		= self:GetDistance(StartPos, CastPos)
				if Distance < self.RRange.Value and Distance > self:getAttackRange() + 200 then
					local RDMG = self:GetRDamage(target, Distance / RealRSpeed + self.RDelay)
					if RDMG > target.Health then
						if Distance >= 1500 then
							Engine:CastSpellMap("HK_SPELL4", CastPos ,1)
							return
						else
							Engine:CastSpell("HK_SPELL4", CastPos ,1)
							return
						end
					end
				end
			end
		end
	end
	
	if self.ComboUseW.Value == 1 and Engine:SpellReady("HK_SPELL2") then
		local LethalTempo_Check = myHero.BuffData:GetBuff("ASSETS/Perks/Styles/Precision/LethalTempo/LethalTempoEmpowered.lua").Count_Alt > 0
		local StartPos 			= myHero.Position
		local bonusAts = (myHero.AttackSpeedMod - 1) * 100
		local calcWDelay = 0.6 - 0.02 * math.floor(bonusAts / 25)
		local CastPos, Target = Prediction:GetCastPos(StartPos, self.WRange, self.WSpeed, self.WWidth, calcWDelay, 1, 1, self.WHitChance, 1)
		if CastPos ~= nil and LethalTempo_Check then
			local distCheck 		= self:GetDistance(myHero.Position, CastPos)
			if distCheck >= self:getAttackRange() then
				local Distance 		= self:GetDistance(StartPos, CastPos)
				if Distance < self.WRange and Distance > self.QRange then
					Engine:CastSpell("HK_SPELL2", CastPos ,1)
					return
				end
			end
		end
		if not LethalTempo_Check then
			if CastPos ~= nil and not LethalTempo_Check then
				local Distance 		= self:GetDistance(StartPos, CastPos)
				if Distance < self.WRange and Distance > self.QRange then
					Engine:CastSpell("HK_SPELL2", CastPos ,1)
					return
				end
			end
		end
	end

	if self.ComboUseE.Value == 1 and Engine:SpellReady("HK_SPELL3") then
		local range = self:getAttackRange() + (50 + (25 * myHero:GetSpellSlot(0).Level) - 20)
		local Target 			= Orbwalker:GetTarget("Combo", range)
		if Target then
			local isCC = Target.BuffData:HasBuffOfType(BuffType.Stun) or Target.BuffData:HasBuffOfType(BuffType.Snare) or Target.BuffData:HasBuffOfType(BuffType.Knockup) or Target.BuffData:HasBuffOfType(BuffType.Asleep)
			if isCC then
				Engine:CastSpell("HK_SPELL3", Target.Position, 1)
				return
			end
			local StartPos = myHero.Position
			local CastPos = Prediction:GetCastPos(StartPos, self.ERange, self.ESpeed, 0, self.EDelay, 0, 0, self.EHitChance, 0)
			if CastPos then
				Engine:CastSpell("HK_SPELL3", CastPos, 1)
				return
			end
		end
	end
	
	if self.ComboUseQ.Value == 1 and Engine:SpellReady("HK_SPELL1") then
		local aaRange = 525 + myHero.CharData.BoundingRadius
		local range = self:getAttackRange() + (50 + (25 * myHero:GetSpellSlot(0).Level))
		local rangeAddition = {100, 125, 150, 175, 200}
		local Target 			= Orbwalker:GetTarget("Combo", range)
        local LethalTempo		= myHero.BuffData:GetBuff("ASSETS/Perks/Styles/Precision/LethalTempo/LethalTempo.lua")	
        local Stacks			= LethalTempo.Count_Int	
		if Stacks >= 42 then
			aaRange = aaRange + 75
		end
		if Target ~= nil then 
			local JinxQ 		= myHero.BuffData:GetBuff("JinxQ")
			local Distance 		= self:GetDistance(myHero.Position, Target.Position)
			if JinxQ.Valid == false then
				local count = self:EnemiesInRange(Target.Position, 250)
				if count > 1 then
					Engine:CastSpell("HK_SPELL1", nil ,1)
					return
				end
			end
			if Distance > aaRange and JinxQ.Valid == false then
				Engine:CastSpell("HK_SPELL1", nil ,1)
				return
			end
			if Distance < aaRange and JinxQ.Valid == true then
				local count = self:EnemiesInRange(Target.Position, 250)
				if count <= 1 then
					Engine:CastSpell("HK_SPELL1", nil ,1)
					return
				end
			end
		end
	end
end

function Jinx:Harass()
	if self.HarassUseW.Value == 1 and Engine:SpellReady("HK_SPELL2") then
		local LethalTempo_Check = myHero.BuffData:GetBuff("ASSETS/Perks/Styles/Precision/LethalTempo/LethalTempoEmpowered.lua").Count_Alt > 0
		local StartPos 			= myHero.Position
		local bonusAts = (myHero.AttackSpeedMod - 1) * 100
		local calcWDelay = 0.6 - 0.02 * math.floor(bonusAts / 25)
		local CastPos, Target 	= Prediction:GetCastPos(StartPos, self.WRange, self.WSpeed, self.WWidth, calcWDelay, 1, 1, self.WHitChance, 1)
		if CastPos ~= nil and LethalTempo_Check then
			local distCheck 		= self:GetDistance(myHero.Position, CastPos)
			if distCheck >= self:getAttackRange() then
				local Distance 		= self:GetDistance(StartPos, CastPos)
				if Distance < self.WRange and Distance > self.QRange then
					Engine:CastSpell("HK_SPELL2", CastPos ,1)
					return
				end
			end
		end
		if not LethalTempo_Check then
			if CastPos ~= nil and not LethalTempo_Check then
				local Distance 		= self:GetDistance(StartPos, CastPos)
				if Distance < self.WRange and Distance > self.QRange then
					Engine:CastSpell("HK_SPELL2", CastPos ,1)
					return
				end
			end
		end
	end
	if self.HarassUseE.Value == 1 and Engine:SpellReady("HK_SPELL3") then
		local range = self:getAttackRange() + (50 + (25 * myHero:GetSpellSlot(0).Level) - 20)
		local Target 			= Orbwalker:GetTarget("Harass", range)
		if Target then
			local StartPos 						= myHero.Position
			local CastPos 						= Prediction:GetCastPos(StartPos, self.ERange, self.ESpeed, self.EWidth, self.EDelay, 0, 0, self.EHitChance, 0)
			if CastPos then
				Engine:CastSpell("HK_SPELL3", CastPos ,1)
				return
			end
		end
	end
	
	if self.HarassUseQ.Value == 1 and Engine:SpellReady("HK_SPELL1") then
		local aaRange = 525 + myHero.CharData.BoundingRadius
		local range = self:getAttackRange() + (50 + (25 * myHero:GetSpellSlot(0).Level))
		local rangeAddition = {100, 125, 150, 175, 200}
		local Target 			= Orbwalker:GetTarget("Harass", range)
		local LethalTempo		= myHero.BuffData:GetBuff("ASSETS/Perks/Styles/Precision/LethalTempo/LethalTempo.lua")	
        local Stacks			= LethalTempo.Count_Int	
		if Stacks >= 42 then
			aaRange = aaRange + 75
		end
		if Target ~= nil then 
			local JinxQ 		= myHero.BuffData:GetBuff("JinxQ")
			local Distance 		= self:GetDistance(myHero.Position, Target.Position)
			if JinxQ.Valid == false then
				local count = self:EnemiesInRange(Target.Position, 250)
				if count > 1 then
					Engine:CastSpell("HK_SPELL1", nil ,1)
					return
				end
			end
			if Distance > aaRange and JinxQ.Valid == false then
				Engine:CastSpell("HK_SPELL1", nil ,1)
				return
			end
			if Distance < (aaRange + 50) and JinxQ.Valid == true then
				local count = self:EnemiesInRange(Target.Position, 250)
				if count <= 1 then
					Engine:CastSpell("HK_SPELL1", nil ,1)
					return
				end
			end
		end
	end
end

function Jinx:Laneclear()
	if Orbwalker:GetAttackSpeed() >= 1.5 then
		local target = Orbwalker:GetTarget("Laneclear", 800) or Orbwalker:GetTarget("Lasthit", 800)
		local JinxQ = myHero.BuffData:GetBuff("JinxQ")
		if target then
			local count = self:MinionsInRange(target.Position, 200)
			if count >= 3 then
				if Engine:SpellReady("HK_SPELL1") then
					if not JinxQ.Valid then
						Engine:CastSpell("HK_SPELL1", nil ,1)
					end
				end
			else
				if JinxQ.Valid then
					Engine:CastSpell("HK_SPELL1", nil ,1)
				end
			end
		else
			if JinxQ.Valid then
				Engine:CastSpell("HK_SPELL1", nil ,1)
			end
		end
	else
		local JinxQ = myHero.BuffData:GetBuff("JinxQ")
		if JinxQ.Valid then
			Engine:CastSpell("HK_SPELL1", nil ,1)
		end
	end
end

function Jinx:OnTick()
	if GameHud.Minimized == false and GameHud.ChatOpen == false then
		-- myHero.BuffData:ShowAllBuffs()
		self.QRange = myHero.AttackRange + myHero.CharData.BoundingRadius + 50 + (myHero:GetSpellSlot(0).Level * 25)
		if self.BaseUseR.Value == 1 and Engine:SpellReady("HK_SPELL4") then
			if self:CheckBaseUlt() == true then
				self:CastRToEnemyBase()
			end
		end
		local JinxQ = myHero.BuffData:GetBuff("JinxQ")
		if JinxQ.Valid == true then
			local qDmg = ((myHero.BaseAttack + myHero.BonusAttack) / 100 * 110) - (myHero.BaseAttack + myHero.BonusAttack)
			Orbwalker.ExtraDamage = qDmg
		else
			Orbwalker.ExtraDamage = 0
		end
		if Engine:IsKeyDown("HK_COMBO") and Orbwalker.Attack == 0 then
			Jinx:Combo()
			return
		end
		if Engine:IsKeyDown("HK_HARASS") and Orbwalker.Attack == 0 then
			Jinx:Harass()
			return
		end
		if Engine:IsKeyDown("HK_LANECLEAR") and Orbwalker.Attack == 0 then
			-- Jinx:Laneclear()
			return
		end
	end
end

function Jinx:OnDraw()
	local JinxQ = myHero.BuffData:GetBuff("JinxQ")
	if JinxQ.Valid == false and Engine:SpellReady("HK_SPELL1") and self.DrawQ.Value == 1 then
        Render:DrawCircle(myHero.Position, self.QRange ,100,150,255,255)
    end
	if Engine:SpellReady("HK_SPELL2") and self.DrawW.Value == 1 then
        Render:DrawCircle(myHero.Position, self.WRange ,100,150,255,255)
    end
	if Engine:SpellReady("HK_SPELL3") and self.DrawE.Value == 1 then
        Render:DrawCircle(myHero.Position, self.ERange ,100,150,255,255)
    end
end



function Jinx:OnLoad()
    if(myHero.ChampionName ~= "Jinx") then return end
	AddEvent("OnSettingsSave" , function() Jinx:SaveSettings() end)
	AddEvent("OnSettingsLoad" , function() Jinx:LoadSettings() end)


	Jinx:__init()
	AddEvent("OnTick", function() Jinx:OnTick() end)	
	AddEvent("OnDraw", function() Jinx:OnDraw() end)	
end

AddEvent("OnLoad", function() Jinx:OnLoad() end)	
