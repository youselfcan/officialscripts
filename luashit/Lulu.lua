require("SupportLib")

Lulu = {}
function Lulu:__init()
	self.QRange = 950
	self.WRange = 650
	self.ERange = 650
	self.RRange = 900

	self.QSpeed = 1450
	self.WSpeed = math.huge
	self.ESpeed = math.huge
	self.RSpeed = math.huge

	self.QWidth = 120

	self.QDelay = 0.25 
	self.WDelay = 0
	self.EDelay = 0
	self.RDelay = 0

	self.QHitChance = 0.2

    self.ChampionMenu = Menu:CreateMenu("Lulu")
	-------------------------------------------
    self.ComboMenu 		= self.ChampionMenu:AddSubMenu("Q Settings")
    self.ComboUseQ 		= self.ComboMenu:AddCheckbox("UseQ on Combo", 1)
	-------------------------------------------
	self.WSettings		= self.ChampionMenu:AddSubMenu("W Settings")
	self.UseWEnchant	= self.WSettings:AddCheckbox("UseW on Ally", 1)
	self.UseWDeEnchant	= self.WSettings:AddCheckbox("UseW on Enemy", 1)
	self.UseWGapclose	= self.WSettings:AddCheckbox("UseW on Gapclose", 1)
	-------------------------------------------
	self.ESettings		= self.ChampionMenu:AddSubMenu("E Settings")
	self.UseEEnchant	= self.ESettings:AddCheckbox("UseE as Buff", 1)
	self.ESettings:AddLabel("HP % for E Shield:")
	self.ETargets		= {}
	-------------------------------------------
	self.RSettings 		= self.ChampionMenu:AddSubMenu("R Settings")
	self.UseRGapclose	= self.RSettings:AddCheckbox("UseR on Gapclose", 1)
	self.RSettings:AddLabel("HP % for R Save:")
	self.RTargets		= {}
	-------------------------------------------
	self.DrawMenu 		= self.ChampionMenu:AddSubMenu("Drawings")
    self.DrawQ 			= self.DrawMenu:AddCheckbox("DrawQ", 1)
    self.DrawW 			= self.DrawMenu:AddCheckbox("DrawW", 1)
    self.DrawE 			= self.DrawMenu:AddCheckbox("DrawE", 1)
    self.DrawR 			= self.DrawMenu:AddCheckbox("DrawR", 1)
	
	Lulu:LoadSettings()
end

function Lulu:SaveSettings()
	SettingsManager:CreateSettings("Lulu")
	SettingsManager:AddSettingsGroup("Combo")
	SettingsManager:AddSettingsInt("UseQ", self.ComboUseQ.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("WSettings")
	SettingsManager:AddSettingsInt("UseWEnchant", self.UseWEnchant.Value)
	SettingsManager:AddSettingsInt("UseWDeEnchant", self.UseWDeEnchant.Value)
	SettingsManager:AddSettingsInt("UseWGapclose", self.UseWGapclose.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("ESettings")
	SettingsManager:AddSettingsInt("UseEEnchant", self.UseEEnchant.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("RSettings")
	SettingsManager:AddSettingsInt("UseRGapclose", self.UseRGapclose.Value)
	------------------------------------------------------------
	SettingsManager:AddSettingsGroup("Drawings")
	SettingsManager:AddSettingsInt("DrawQ", self.DrawQ.Value)
	SettingsManager:AddSettingsInt("DrawW", self.DrawW.Value)
	SettingsManager:AddSettingsInt("DrawE", self.DrawE.Value)
	SettingsManager:AddSettingsInt("DrawR", self.DrawR.Value)

end

function Lulu:LoadSettings()
	SettingsManager:GetSettingsFile("Lulu")
	self.ComboUseQ.Value 		= SettingsManager:GetSettingsInt("Combo","UseQ")
	-------------------------------------------------------------
	self.UseWEnchant.Value		= SettingsManager:GetSettingsInt("WSettings","UseWEnchant")
	self.UseWDeEnchant.Value	= SettingsManager:GetSettingsInt("WSettings","UseWDeEnchant")
	self.UseWGapclose.Value		= SettingsManager:GetSettingsInt("WSettings","UseWGapclose")
	-------------------------------------------------------------
	self.UseEEnchant.Value		= SettingsManager:GetSettingsInt("ESettings","UseEEnchant")
	-------------------------------------------------------------
	self.UseRGapclose.Value		= SettingsManager:GetSettingsInt("RSettings","UseRGapclose")
	-------------------------------------------------------------
	self.DrawQ.Value = SettingsManager:GetSettingsInt("Drawings","DrawQ")
	self.DrawW.Value = SettingsManager:GetSettingsInt("Drawings","DrawW")
	self.DrawE.Value = SettingsManager:GetSettingsInt("Drawings","DrawE")
	self.DrawR.Value = SettingsManager:GetSettingsInt("Drawings","DrawR")

end

function Lulu:GetPixi()
	local MinionList = ObjectManager.MinionList
	for I,Minion in pairs(MinionList) do	
		if Minion.Team == myHero.Team then
			if Minion.Name == "RobotBuddy" and Minion.IsVisible then
				return Minion
			end
		end
	end
	return nil
end

function Lulu:Q()
	if self.ComboUseQ.Value == 1 and Engine:SpellReady("HK_SPELL1") then
		local CastPos 	= nil
		local Pixi 		= self:GetPixi()
		if Pixi then CastPos = Prediction:GetCastPos(Pixi.Position, self.QRange, self.QSpeed, self.QWidth, self.QDelay, 0, true, self.QHitChance, 1) 
		else CastPos = Prediction:GetCastPos(Pixi.Position, self.QRange, self.QSpeed, self.QWidth, self.QDelay, 0, true, self.QHitChance, 1)  end
		if CastPos then
			Engine:CastSpell("HK_SPELL1", CastPos, 0)
		end
	end
end

function Lulu:W()
	if Engine:SpellReady("HK_SPELL2") then
		local Target = nil
		if self.UseWGapclose == 1 then
			Target = SupportLib:GetAntiGapCloseTarget(self.WRange, 300)
			if Target then
				return Engine:CastSpell("HK_SPELL2", Target.Position, 1)
			end
		end
		if self.UseWDeEnchant.Value == 1 then
			Target = SupportLib:GetDebuffTarget(self.WRange)
			if Target then
				return Engine:CastSpell("HK_SPELL2", Target.Position, 1)
			end
		end
		if self.UseWEnchant.Value == 1 then
			Target = SupportLib:GetBuffTarget(self.WRange)
			if Target then
				return Engine:CastSpell("HK_SPELL2", Target.Position, 1)
			end
		end
	end
end

function Lulu:E()
	if Engine:SpellReady("HK_SPELL3") then
		local ShieldTarget = SupportLib:GetShieldTargetWithTable(self.ERange, self.ETargets)
		if ShieldTarget then
			return Engine:CastSpell("HK_SPELL3", ShieldTarget.Position, 1)
		end
		if self.UseEEnchant.Value == 1 then
			local Target = SupportLib:GetBuffTarget(self.ERange)
			if Target then
				local ETargets = SupportLib:GetAlliesInRange(myHero.Position, self.ERange)
				if #ETargets > 1 then
					if Target.Index ~= myHero.Index then
						return Engine:CastSpell("HK_SPELL3", Target.Position, 1)
					end
				else
					return Engine:CastSpell("HK_SPELL3", Target.Position, 1)
				end
			end	
		end
	end
end

function Lulu:R()
	if Engine:SpellReady("HK_SPELL4") then
		local ShieldTarget = SupportLib:GetShieldTargetWithTable(self.RRange, self.RTargets)
		if ShieldTarget then
			return Engine:CastSpell("HK_SPELL4", ShieldTarget.Position, 1)
		end
		if self.UseRGapclose.Value == 1 then
			if self.UseWGapclose.Value == 0 or Engine:SpellReady("HK_SPELL2") == false then
				local Enemy, Ally = SupportLib:GetAntiGapCloseTarget(self.RRange, 450)
				if Ally then
					return Engine:CastSpell("HK_SPELL4", Ally.Position, 1)
				end		
			end
		end
	end
end

function Lulu:OnTick()
	local Allies = SupportLib:GetAllAllies()
	for _, Ally in pairs(Allies) do
		if string.len(Ally.ChampionName) > 1 and self.ETargets[Ally.Index] == nil then
			self.ETargets[Ally.Index] 		= self.ESettings:AddSlider(Ally.ChampionName , 100, 0, 100, 1)
		end
		if string.len(Ally.ChampionName) > 1 and self.RTargets[Ally.Index] == nil then
			self.RTargets[Ally.Index] 		= self.RSettings:AddSlider(Ally.ChampionName , 30, 0, 100, 1)
		end
	end
	if GameHud.Minimized == false and GameHud.ChatOpen == false then
		self:R()
		self:W()
		self:E()
		if Engine:IsKeyDown("HK_COMBO") then	
			self:Q()
		end
	end
end

function Lulu:OnDraw()
	if myHero.IsDead then return end
	local Pixi = Lulu:GetPixi()
    if Engine:SpellReady("HK_SPELL1") and self.DrawQ.Value == 1 then
		if Pixi then
			Render:DrawCircle(Pixi.Position, self.QRange ,100,150,255,255)
		end
        Render:DrawCircle(myHero.Position, self.QRange ,100,150,255,255)
    end
    if Engine:SpellReady("HK_SPELL2") and self.DrawW.Value == 1 then
        Render:DrawCircle(myHero.Position, self.WRange ,100,150,255,255)
    end
    if Engine:SpellReady("HK_SPELL3") and self.DrawE.Value == 1 then
        Render:DrawCircle(myHero.Position, self.ERange ,100,150,255,255)
    end
    if Engine:SpellReady("HK_SPELL4") and self.DrawR.Value == 1 then
        Render:DrawCircle(myHero.Position, self.RRange ,255,0,0,255)
    end
end

function Lulu:OnLoad()
    if(myHero.ChampionName ~= "Lulu") then return end
	AddEvent("OnSettingsSave" , function() Lulu:SaveSettings() end)
	AddEvent("OnSettingsLoad" , function() Lulu:LoadSettings() end)


	Lulu:__init()
	AddEvent("OnTick", function() Lulu:OnTick() end)	
	AddEvent("OnDraw", function() Lulu:OnDraw() end)	
end

AddEvent("OnLoad", function() Lulu:OnLoad() end)