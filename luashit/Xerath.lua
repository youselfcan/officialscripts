Xerath = {
    Init = function(self)
        self.QRange_Min 	= 750
        self.QRange_Max 	= 1450
		self.QRange_Charged = 0

        self.QSpeed = math.huge
		-- self.QDelay = 0.40
        self.QDelay = 0.528
        self.QWidth = 140

        self.WRange = 1000
        self.WSpeed = math.huge
        self.WWidth = 125
        self.WDelay = 0.25

        self.ERange = 1125
        self.EDelay = 0.25
        self.ESpeed = 1400
        self.EWidth = 120

        self.RWidth = 200

        self.RSpeed = math.huge
        self.RRange = 5000
        self.RDelay = 0.6

        self.Menu       = Menu:CreateMenu("Xerath") 
        --------------------------------------------
        self.QSettings  = self.Menu:AddSubMenu("Q Settings")
        self.ComboUseQ  = self.QSettings:AddCheckbox("Use Q on Combo")
        self.HarassUseQ = self.QSettings:AddCheckbox("UseQ on Harass")
        self.LaneclearUseQ = self.QSettings:AddCheckbox("UseQ on Laneclear")
        --------------------------------------------
        self.WSettings  = self.Menu:AddSubMenu("W Settings")
        self.ComboUseW  = self.WSettings:AddCheckbox("Use W on Combo")
        self.HarassUseW  = self.WSettings:AddCheckbox("Use W on Harass")
        self.LaneclearUseW  = self.WSettings:AddCheckbox("Use W on Laneclear")
        --------------------------------------------
        self.ESettings  = self.Menu:AddSubMenu("E Settings")
        self.ComboUseE  = self.ESettings:AddCheckbox("Use E on Combo")
        self.HarassUseE = self.ESettings:AddCheckbox("Use E on Harass")
        --------------------------------------------
        self.RSettings  = self.Menu:AddSubMenu("R Settings")
        self.ComboUseR  = self.RSettings:AddCheckbox("Use R on Combo")
        --------------------------------------------
        self.DrawSettings  = self.Menu:AddSubMenu("Drawings")
        self.QDrawings     = self.DrawSettings:AddCheckbox("Draw Q Range")
        self.WDrawings     = self.DrawSettings:AddCheckbox("Draw W Range")
        self.EDrawings     = self.DrawSettings:AddCheckbox("Draw E Range")
        self.RDrawings     = self.DrawSettings:AddCheckbox("Draw R Range")
        --------------------------------------------
        self:LoadSettings()  
    end,
    SaveSettings = function(self)
        SettingsManager:CreateSettings("Xerath")
        SettingsManager:AddSettingsGroup("QSettings")
        SettingsManager:AddSettingsInt("UseQCombo", self.ComboUseQ.Value)
        SettingsManager:AddSettingsInt("UseQLaneclear", self.LaneclearUseQ.Value)
        ------------------------------------------------------------
        SettingsManager:AddSettingsGroup("WSettings")
        SettingsManager:AddSettingsInt("UseWCombo", self.ComboUseW.Value)
        SettingsManager:AddSettingsInt("UseWHarass", self.HarassUseW.Value)
        SettingsManager:AddSettingsInt("UseWLaneclear", self.LaneclearUseW.Value)
        ------------------------------------------------------------
        SettingsManager:AddSettingsGroup("ESettings")
        SettingsManager:AddSettingsInt("UseECombo", self.ComboUseE.Value)
        SettingsManager:AddSettingsInt("UseEHarass", self.HarassUseE.Value)
        ------------------------------------------------------------
        SettingsManager:AddSettingsGroup("RSettings")
        SettingsManager:AddSettingsInt("UseRCombo", self.ComboUseR.Value)
        ------------------------------------------------------------
        SettingsManager:AddSettingsGroup("Drawings")
        SettingsManager:AddSettingsInt("DrawQ", self.QDrawings.Value)
        SettingsManager:AddSettingsInt("DrawW", self.WDrawings.Value)
        SettingsManager:AddSettingsInt("DrawE", self.EDrawings.Value)
        SettingsManager:AddSettingsInt("DrawR", self.RDrawings.Value)
    end,
    LoadSettings = function(self)
        SettingsManager:GetSettingsFile("Xerath")
        self.ComboUseQ.Value 		= SettingsManager:GetSettingsInt("QSettings","UseQCombo")
        self.LaneclearUseQ.Value 		= SettingsManager:GetSettingsInt("QSettings","UseQLaneclear")
        -------------------------------------------------------------
        self.ComboUseW.Value		= SettingsManager:GetSettingsInt("WSettings","UseWCombo")
        self.HarassUseW.Value		= SettingsManager:GetSettingsInt("WSettings","UseWHarass")
        self.LaneclearUseW.Value		= SettingsManager:GetSettingsInt("WSettings","UseWLaneclear")
        -------------------------------------------------------------
        self.ComboUseE.Value		= SettingsManager:GetSettingsInt("ESettings","UseECombo")
        self.HarassUseE.Value		= SettingsManager:GetSettingsInt("ESettings","UseEHarass")
        -------------------------------------------------------------
        self.ComboUseR.Value		= SettingsManager:GetSettingsInt("RSettings","UseRCombo")
        -------------------------------------------------------------
        self.QDrawings.Value = SettingsManager:GetSettingsInt("Drawings","DrawQ")
        self.WDrawings.Value = SettingsManager:GetSettingsInt("Drawings","DrawW")
        self.EDrawings.Value = SettingsManager:GetSettingsInt("Drawings","DrawE")
        self.RDrawings.Value = SettingsManager:GetSettingsInt("Drawings","DrawR")
    end,
    GetDistance = function(self, from, to)
        return math.sqrt((from.x - to.x) ^ 2 + (from.y - to.y) ^ 2 + (from.z - to.z) ^ 2)
    end,
    Combo = function(self)
        if self.QRange_Charged == 0 then
            local RStartTime =  myHero:GetSpellSlot(3).StartTime
            if RStartTime > 0 then
                local CastPos =  Prediction:GetCastPos(GameHud.MousePos, 500, self.RSpeed, self.RWidth, self.RDelay, 0, true, 0.01, 0)
                -- local CastPos =  Prediction:GetCastPos(GameHud.MousePos, 500, math.huge, 0, self.RDelay, 0)
                if CastPos and self.ComboUseR.Value == 1 and Engine:SpellReady("HK_SPELL4") then
                    return Engine:ReleaseSpell("HK_SPELL4", CastPos)
                end		
                return
            end
            if self.ComboUseE.Value == 1 and Engine:SpellReady("HK_SPELL3") then
                local PredPos, Target = Prediction:GetCastPos(myHero.Position, self.ERange, self.ESpeed, self.EWidth, self.EDelay, 1, true, 0.5, 1)
                if PredPos and (Prediction:PointOnLineSegment(myHero.Position, Target.Position, PredPos, 200) or Prediction:PointOnLineSegment(myHero.Position, PredPos, Target.Position, 200)) then
                    return Engine:CastSpell("HK_SPELL3", PredPos, 0)
                end
            end
            if self.ComboUseW.Value == 1 and Engine:SpellReady("HK_SPELL2") then
                local PredPos, Target = Prediction:GetCastPos(myHero.Position, self.WRange, self.WSpeed, self.WWidth, self.WDelay, 0, true, 0.4, 0)
                if PredPos then
                    return Engine:CastSpell("HK_SPELL2", PredPos, 0)
                end
            end
        end
		if self.ComboUseQ.Value == 1 then
			local PredPos,Target  = Prediction:GetCastPos(myHero.Position, self.QRange_Max, self.QSpeed, self.QWidth, self.QDelay, 0, true, 1, 0)
			if PredPos then
				if self.QRange_Charged > 0 and self:GetDistance(myHero.Position, PredPos) < self.QRange_Charged then
					return Engine:ReleaseSpell("HK_SPELL1", PredPos)
				end
				if self.QRange_Charged == 0 and Engine:SpellReady("HK_SPELL1") then
					Engine:ChargeSpell("HK_SPELL1")	
				end	
			end
		end
	end,
    Harass = function(self)
		if self.ComboUseQ.Value == 1 then
			local PredPos,Target  = Prediction:GetCastPos(myHero.Position, self.QRange_Max, self.QSpeed, self.QWidth, self.QDelay, 0, true, 1, 0)
			if PredPos then
				if self.QRange_Charged > 0 and self:GetDistance(myHero.Position, PredPos) < self.QRange_Charged then
					return Engine:ReleaseSpell("HK_SPELL1", PredPos)
				end
				if self.QRange_Charged == 0 and Engine:SpellReady("HK_SPELL1") then
					Engine:ChargeSpell("HK_SPELL1")	
				end	
			end
		end
		if self.HarassUseE.Value == 1 and Engine:SpellReady("HK_SPELL3") and Orbwalker.Attack == 0 then
            local PredPos, Target = Prediction:GetCastPos(myHero.Position, self.ERange, self.ESpeed, self.EWidth, self.EDelay, 1, true, 0.6, 1)
            if PredPos and (Prediction:PointOnLineSegment(myHero.Position, Target.Position, PredPos, 200) or Prediction:PointOnLineSegment(myHero.Position, PredPos, Target.Position, 200)) then
				return Engine:CastSpell("HK_SPELL3", PredPos, 0)
			end
		end
		if self.HarassUseW.Value == 1 and Engine:SpellReady("HK_SPELL2") and Orbwalker.Attack == 0 then
            local PredPos, Target = Prediction:GetCastPos(myHero.Position, self.WRange, self.WSpeed, self.WWidth, self.WDelay, 0, true, 0.5, 0)
			if PredPos then
				return Engine:CastSpell("HK_SPELL2", PredPos, 0)
			end
		end
	end,
    Laneclear = function(self)
        local target = Orbwalker:GetTarget("Laneclear", self.QRange_Max)
        if target then
            if self.LaneclearUseQ.Value == 1 then
                if self.QRange_Charged > 0 and self:GetDistance(myHero.Position, target.Position) < self.QRange_Charged then
                    return Engine:ReleaseSpell("HK_SPELL1", target.Position)
                end
                if self.QRange_Charged == 0 and Engine:SpellReady("HK_SPELL1") then
                    Engine:ChargeSpell("HK_SPELL1")	
                end	
            end
            if self.LaneclearUseW.Value == 1 and Engine:SpellReady("HK_SPELL2") and self:GetDistance(myHero.Position, target.Position) < self.WRange then
                return Engine:CastSpell("HK_SPELL2", target.Position, 0)
            end
        end
    end,
    SetRanges = function(self)
		local QStartTime =  myHero:GetSpellSlot(0).StartTime
		if QStartTime > 0 then
			self.QRange_Charged = math.min(self.QRange_Max + 200, self.QRange_Min + (((GameClock.Time - QStartTime)) * 555)) - 200
		else
			self.QRange_Charged = 0
		end
		if Engine:IsKeyDown("HK_SPELL1") == true and Engine:SpellReady("HK_SPELL1") == false and QStartTime == 0 then
			return Engine:ReleaseSpell("HK_SPELL1", nil)
		end	
    end,
    OnTick = function(self)
        if GameHud.Minimized == false and GameHud.ChatOpen == false then
            self:SetRanges()
            if Engine:IsKeyDown("HK_COMBO") then
                return self:Combo()	
            end
            if Engine:IsKeyDown("HK_HARASS") then
                return self:Harass()	
            end
            if Engine:IsKeyDown("HK_LANECLEAR") then
                return self:Laneclear()
            end
        end
    end,
    OnDraw = function(self)
        --Render:DrawCircle(myHero.Position, self.QRange_Charged ,100,150,255,255)
        if Engine:SpellReady("HK_SPELL1") and self.QDrawings.Value == 1 then
            Render:DrawCircle(myHero.Position, self.QRange_Max ,100,150,255,255)
        end
        if Engine:SpellReady("HK_SPELL2") and self.WDrawings.Value == 1 then
            Render:DrawCircle(myHero.Position, self.WRange ,150,255,100,255)
        end
        if Engine:SpellReady("HK_SPELL3") and self.EDrawings.Value == 1 then
            Render:DrawCircle(myHero.Position, self.ERange ,255,150,0,255)
        end
        if Engine:SpellReady("HK_SPELL4") then
            if self.RDrawings.Value == 1  then
                Render:DrawCircleMap(myHero.Position, self.RRange ,255,0,0,255)
            end
        end
		local RStartTime = myHero:GetSpellSlot(3).StartTime
		if RStartTime > 0 then
			Orbwalker:Disable()
			local MousePos = GameHud.MousePos
			Render:DrawCircle(MousePos,500,255,255,255,255)
			return
		end
		Orbwalker:Enable()	
    end,
    OnLoad = function(self)
        if(myHero.ChampionName ~= "Xerath") then return end
        AddEvent("OnSettingsSave" , function() self:SaveSettings() end)
        AddEvent("OnSettingsLoad" , function() self:LoadSettings() end)

        self:Init()
        AddEvent("OnTick", function() self:OnTick() end)	
        AddEvent("OnDraw", function() self:OnDraw() end)
    end
}

AddEvent("OnLoad", function() Xerath:OnLoad() end)	
