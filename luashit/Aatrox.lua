Aatrox = {} 
function Aatrox:__init() 
    self.QRange = 625
    self.QRange2 = 450
    self.QRange3 = 400
    self.WRange = 825
    self.ERange = 350 
    self.RRange = 600

    self.QSpeed = math.huge 
    self.WSpeed = 1800
    self.ESpeed = 850

    self.QDelay = 0.6
    self.WDelay = 0.25
    self.EDelay = 0

    self.QWidth = 100
    self.WWidth = 100

    self.QHitChance = 0.2
    self.WHitChance = 0.2

    self.QTimer = 0
    self.ChampionMenu = Menu:CreateMenu("Aatrox") 
    --------------------------------------------
    self.ComboMenu = self.ChampionMenu:AddSubMenu("Combo") 
    self.ComboQ = self.ComboMenu:AddCheckbox("Use Q in Combo", 1)
    self.ComboW = self.ComboMenu:AddCheckbox("Use W in Combo", 1) 
    self.ComboE = self.ComboMenu:AddCheckbox("Use E in Combo", 1) 
    self.RComboHP = self.ComboMenu:AddCheckbox("Use R based on %HP in combo", 1)
    self.RComboHPSlider = self.ComboMenu:AddSlider("Use R if HP below %", 20,1,100,1)

    --------------------------------------------
    self.HarassMenu = self.ChampionMenu:AddSubMenu("Harass") 
    self.HarassQ = self.HarassMenu:AddCheckbox("Use Q in Harass", 1) 
    self.HarassW = self.HarassMenu:AddCheckbox("Use W in Harass", 1) 
    self.HarassE = self.HarassMenu:AddCheckbox("Use E in Harass", 1) 
    --------------------------------------------
    self.LClearMenu = self.ChampionMenu:AddSubMenu("LaneClear") 
    self.ClearQ = self.LClearMenu:AddCheckbox("Use Q in LaneClear", 1) 
    self.ClearW = self.LClearMenu:AddCheckbox("Use W in LaneClear", 1)
    self.ClearE = self.LClearMenu:AddCheckbox("Use E in LaneClear", 1)    
    --------------------------------------------
	self.DrawMenu = self.ChampionMenu:AddSubMenu("Drawings") 
    self.DrawQ = self.DrawMenu:AddCheckbox("Draw Q", 1) 
    self.DrawW = self.DrawMenu:AddCheckbox("Draw W", 1) 
    self.DrawE = self.DrawMenu:AddCheckbox("Draw E", 1) 
    self.DrawR = self.DrawMenu:AddCheckbox("Draw R", 1) 
    
    --------------------------------------------
    
    Aatrox:LoadSettings()  
end 

function Aatrox:SaveSettings() 

    SettingsManager:CreateSettings("Aatrox")
	SettingsManager:AddSettingsGroup("Combo")
	SettingsManager:AddSettingsInt("Use Q in Combo", self.ComboQ.Value)
	SettingsManager:AddSettingsInt("Use W in Combo", self.ComboW.Value)
    SettingsManager:AddSettingsInt("Use E in Combo", self.ComboE.Value)
    SettingsManager:AddSettingsInt("Use R based on %HP in combo", self.RComboHP.Value)
    SettingsManager:AddSettingsInt("Use R if HP below %", self.RComboHPSlider.Value)
    --------------------------------------------
    SettingsManager:AddSettingsGroup("Harass")
    SettingsManager:AddSettingsInt("Use Q in Harass", self.HarassQ.Value)
    SettingsManager:AddSettingsInt("Use W in Harass", self.HarassW.Value)
    SettingsManager:AddSettingsInt("Use E in Harass", self.HarassE.Value)
    --------------------------------------------
    SettingsManager:AddSettingsGroup("Drawings")
    SettingsManager:AddSettingsInt("Draw Q", self.DrawQ.Value)
    SettingsManager:AddSettingsInt("Draw W", self.DrawW.Value)
	SettingsManager:AddSettingsInt("Draw E", self.DrawE.Value)
    SettingsManager:AddSettingsInt("Draw R", self.DrawR.Value)
    --------------------------------------------
end

function Aatrox:LoadSettings()
    SettingsManager:GetSettingsFile("Aatrox")
     ------------------------------------------
	self.ComboQ.Value = SettingsManager:GetSettingsInt("Combo","Use Q in Combo")
	self.ComboW.Value = SettingsManager:GetSettingsInt("Combo","Use W in Combo")
    self.ComboE.Value = SettingsManager:GetSettingsInt("Combo","Use E in Combo")
    self.RComboHP.Value = SettingsManager:GetSettingsInt("Combo", "Use R based on %HP in combo")
    self.RComboHPSlider.Value = SettingsManager:GetSettingsInt("Combo", "Use R if HP below %")    
    -------------------------------------------
    self.HarassQ.Value = SettingsManager:GetSettingsInt("Harass","Use Q in Harass")
    self.HarassW.Value = SettingsManager:GetSettingsInt("Harass","Use W in Harass")
    self.HarassE.Value = SettingsManager:GetSettingsInt("Harass","Use E in Harass")  
    --------------------------------------------
    self.ClearQ.Value = SettingsManager:GetSettingsInt("LaneClear","Use Q in LaneClear")
    self.ClearW.Value = SettingsManager:GetSettingsInt("LaneClear","Use W in LaneClear")
    self.ClearW.Value = SettingsManager:GetSettingsInt("LaneClear","Use E in LaneClear")
    --------------------------------------------
    self.DrawQ.Value = SettingsManager:GetSettingsInt("Drawings","Draw Q")
    self.DrawW.Value = SettingsManager:GetSettingsInt("Drawings","Draw W")
	self.DrawE.Value = SettingsManager:GetSettingsInt("Drawings","Draw E")
    self.DrawR.Value = SettingsManager:GetSettingsInt("Drawings","Draw R")
    --------------------------------------------
end

function Aatrox:Ultimate()
    if self.RComboHP.Value == 1 and Engine:SpellReady('HK_SPELL4') then
        local Rcondition = myHero.MaxHealth / 100 * self.RComboHPSlider.Value
        if myHero.Health <= Rcondition then
            Engine:CastSpell('HK_SPELL4', myHero.Position)
        end
    end
end

function Aatrox:CalcEVector(StartPos, EndPos, Range)
	local ToTargetVec = Vector3.new(EndPos.x - StartPos.x, EndPos.y - StartPos.y, EndPos.z - StartPos.z)

	local Distance = math.sqrt((ToTargetVec.x * ToTargetVec.x) + (ToTargetVec.y * ToTargetVec.y) + (ToTargetVec.z * ToTargetVec.z))
	local VectorNorm = Vector3.new(ToTargetVec.x / Distance, ToTargetVec.y / Distance, ToTargetVec.z / Distance)
	
	return Vector3.new(StartPos.x + (VectorNorm.x*Range), StartPos.y , StartPos.z + (VectorNorm.z*Range))
end

function Aatrox:GetEPosition(QName)
    local ActiveSpell = myHero.ActiveSpell.Info.Name
    if ActiveSpell == "AatroxQWrapperCast" then
        local PredPos = nil
        if QName == "AatroxQ2" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.QRange + 100, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            if PredPos then
                local Range = Orbwalker:GetDistance(myHero.Position, PredPos) - (self.QRange - 50)
                --print(Range)
                return self:CalcEVector(myHero.Position, PredPos, Range)
            end
        elseif QName == "AatroxQ3" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.QRange2 + 100, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            if PredPos then
                local Range = Orbwalker:GetDistance(myHero.Position, PredPos) - (self.QRange2 - 50)
                return self:CalcEVector(myHero.Position, PredPos, Range)
            end
        elseif QName == "AatroxQ" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.RRange, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            if PredPos then
                return PredPos
            end
        end
    end
    return nil
end

function Aatrox:Combo()
    if self.ComboW.Value == 1 and Engine:SpellReady("HK_SPELL2") then
        local PredPos = Prediction:GetCastPos(myHero.Position, self.WRange, self.WSpeed, self.WWidth, self.WDelay, 0, 0, self.WHitChance, 0)
        if PredPos then
            return Engine:CastSpell("HK_SPELL2", PredPos, 1)
        end
    end

    local QName = myHero:GetSpellSlot(0).Info.Name
    if self.ComboQ.Value == 1 and Engine:SpellReady("HK_SPELL1") then
        local PredPos = nil
        if QName == "AatroxQ" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.QRange, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
        elseif QName == "AatroxQ2" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.QRange2, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
        elseif QName == "AatroxQ3" then
            if Engine:SpellReady("HK_SPELL3") then
                PredPos = Prediction:GetCastPos(myHero.Position, self.RRange, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            else
                PredPos = Prediction:GetCastPos(myHero.Position, self.QRange3, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            end
        end
        if PredPos then
            self.QTimer = GameClock.Time
            return Engine:CastSpell("HK_SPELL1", PredPos, 1)
        end
    end 

    local ETimer = GameClock.Time - self.QTimer 
    if self.ComboE.Value == 1 and Engine:SpellReady("HK_SPELL3") and ETimer > 0.25 then
        local PredPos = self:GetEPosition(QName)
        if PredPos then
            return Engine:CastSpell("HK_SPELL3", PredPos, 1)
        end
    end
end


function Aatrox:Harass()
    if self.HarassW.Value == 1 and Engine:SpellReady("HK_SPELL2") then
        local PredPos = Prediction:GetCastPos(myHero.Position, self.WRange, self.WSpeed, self.WWidth, self.WDelay, 0, 0, self.WHitChance, 0)
        if PredPos then
            return Engine:CastSpell("HK_SPELL2", PredPos, 1)
        end
    end

    local QName = myHero:GetSpellSlot(0).Info.Name
    if self.HarassQ.Value == 1 and Engine:SpellReady("HK_SPELL1") then
        local PredPos = nil
        if QName == "AatroxQ" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.QRange, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
        elseif QName == "AatroxQ2" then
            PredPos = Prediction:GetCastPos(myHero.Position, self.QRange2, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
        elseif QName == "AatroxQ3" then
            if Engine:SpellReady("HK_SPELL3") then
                PredPos = Prediction:GetCastPos(myHero.Position, self.RRange, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            else
                PredPos = Prediction:GetCastPos(myHero.Position, self.QRange3, self.QSpeed, self.QWidth, self.QDelay, 0, 0, self.QHitChance, 0)
            end
        end
        if PredPos then
            return Engine:CastSpell("HK_SPELL1", PredPos, 1)
        end
    end 
    if self.HarassE.Value == 1 and Engine:SpellReady("HK_SPELL3") then
        local PredPos = self:GetEPosition(QName)
        if PredPos then
            return Engine:CastSpell("HK_SPELL3", PredPos, 1)
        end
    end
end

function Aatrox:OnTick()
    if GameHud.Minimized == false and GameHud.ChatOpen == false and Orbwalker.Attack == 0 then
        Aatrox:Ultimate()
        if Engine:IsKeyDown("HK_COMBO") then
            Aatrox:Combo()
        end
        if Engine:IsKeyDown("HK_HARASS") then
            Aatrox:Harass()
        end
	end
end

function Aatrox:OnDraw()
    if Engine:SpellReady("HK_SPELL1") and self.DrawQ.Value == 1 then
        if myHero.BuffData:GetBuff("AatroxQ2").Valid then
            Render:DrawCircle(myHero.Position, self.QRange2 ,100,150,255,255)
            else        
                if myHero.BuffData:GetBuff("AatroxQ3").Valid then
                Render:DrawCircle(myHero.Position, self.QRange3 ,100,150,255,255)
            else
                
                Render:DrawCircle(myHero.Position, self.QRange ,100,150,255,255)
            end
        end
    end
	if Engine:SpellReady("HK_SPELL2") and self.DrawW.Value == 1 then
      Render:DrawCircle(myHero.Position, self.WRange ,100,150,255,255)
    end
    if Engine:SpellReady("HK_SPELL3") and self.DrawE.Value == 1 then
        Render:DrawCircle(myHero.Position, self.ERange ,100,150,255,255)
    end
    if Engine:SpellReady("HK_SPELL4") and self.DrawR.Value == 1 then
        Render:DrawCircle(myHero.Position, self.RRange ,255,0,0,255) -- values Red, Green, Blue, Alpha(opacity)      
    end
end

function Aatrox:OnLoad()
    if(myHero.ChampionName ~= "Aatrox") then return end
	AddEvent("OnSettingsSave" , function() Aatrox:SaveSettings() end)
	AddEvent("OnSettingsLoad" , function() Aatrox:LoadSettings() end)


	Aatrox:__init()
	AddEvent("OnTick", function() Aatrox:OnTick() end)	
    AddEvent("OnDraw", function() Aatrox:OnDraw() end)
end

AddEvent("OnLoad", function() Aatrox:OnLoad() end)	
