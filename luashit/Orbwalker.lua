--REWORKEDORB 30/08/2022-02.??
Orbwalker = {
    TargetOptions = {
        "PRIO_LOWHP",
        "PRIO_NEAREST",
        "PRIO_MOUSE",
        "PRIO_AD",
        "PRIO_AP",
        "PRIO_HYBRID"
    },
    Init = function(self)

        self.KeyNames = {}
        self.KeyNames[4] 		= "HK_SUMMONER1"
        self.KeyNames[5] 		= "HK_SUMMONER2"

        self.Enabled            = 1
        self.LastMoveTime       = 0
        self.LastMissileTime    = 0

        self.LastWindup         = 0
        self.LastDelay          = 0
        
        self.LastClick          = 0
        self.WindupTimer        = 0
        self.AttackTimer        = 0

        self.Attack             = 0
        self.Windup             = 0
        self.ExtraDamage        = 0

        self.ResetReady         = 0

        self.DontAA             = 0
        self.BlockAttack        = 0
        self.OrbRange           = 0

        self.CaitHSCounts       = {}
        self.CaitHSTimer        = 0
        self.ETimer             = 0
        self.RivenWTimer        = 0

        self.WaitForLasthit     = false
        self.WaitForLastHitTimer = nil
        self.WaitMinion         = nil

        self.Menu = Menu:CreateMenu("Orbwalker")
        self.GenericMenu            = self.Menu:AddSubMenu("Generic Settings")
        self.GenericMenu:AddLabel("Hold Radius:")
        self.GenericMenu:AddLabel("-->if mouse closer X to player dont issue move")
        self.HoldRadius             = self.GenericMenu:AddSlider("", 50, 50, 300, 1)
        self.GenericMenu:AddLabel("Block AA:")
        self.GenericMenu:AddLabel("-->dont use AA when level X and higher (disabled = 0)")
        self.BlockAALevel           = self.GenericMenu:AddSlider("", 0, 0, 18, 1)
        self.TargetMode             = self.GenericMenu:AddCombobox("Target Mode", self.TargetOptions)
        self.GenericMenu:AddLabel("Champion Prios:")
        self.LaneclearMenu          = self.Menu:AddSubMenu("Laneclear Settings")
        self.LaneclearMenu:AddLabel("Lower = faster, higher = slower")
        self.AlwaysPush             = self.LaneclearMenu:AddCheckbox("Always push with waveclear", 0)
        self.PrioChampHarass        = self.LaneclearMenu:AddCheckbox("1 == Prio Champion, 0 == Prio LastHits In Harass", 1)
        self.Prio		            = {}
        self.SupportMenu            = self.Menu:AddSubMenu("Support Settings")
        self.SupportMode            = self.SupportMenu:AddCheckbox("Disable attacks on minions", 0)
        self.DrawMenu               = self.Menu:AddSubMenu("Draw Settings")
        self.PlayerRange            = self.DrawMenu:AddCheckbox("Draw Player Range", 1)
        self.EnemyRange             = self.DrawMenu:AddCheckbox("Draw Enemy Range", 1)
        self.DrawTargetCircle       = self.DrawMenu:AddCheckbox("Draw Targetting Circle", 1)
        self.SafeFlashMenu          = self.Menu:AddSubMenu("Safe Flash Settings")
        self.SafeFlashMenu:AddLabel("Safe flash will prevent you from flashing to your mouse while holding down a key")
        self.SafeFlashMenu:AddLabel("Look at FAQ section on how to setup keys for fail flash to work properly")
        self.UseSafeFlash           = self.SafeFlashMenu:AddCheckbox("Use Safe Flash", 1)
        self.MiscMenu               = self.Menu:AddSubMenu("Misc Settings")
        self.AssassinMode           = self.MiscMenu:AddCheckbox("Only Target Your ForceTarget", 0)
        self.UsePrioList            = self.MiscMenu:AddCheckbox("Automatically Set Target Priorities", 1)
        self.BlockAttackForDodge    = self.MiscMenu:AddCheckbox("Block/Cancel AA for Evade", 0)
        self.WindUpSlider           = self.MiscMenu:AddSlider("Windup Percentage", 100, 70, 130, 1)

        self:LoadSettings()
    end,
    SaveSettings = function(self)
        SettingsManager:CreateSettings("Orbwalker")
        SettingsManager:AddSettingsGroup("Settings")
        SettingsManager:AddSettingsInt("HoldRadius", self.HoldRadius.Value)
        SettingsManager:AddSettingsInt("BlockAALevel", self.BlockAALevel.Value)
        SettingsManager:AddSettingsInt("AlwaysPush", self.AlwaysPush.Value)
        SettingsManager:AddSettingsInt("PrioChampHarass", self.PrioChampHarass.Value)
        SettingsManager:AddSettingsInt("UseSafeFlash", self.UseSafeFlash.Value)
        SettingsManager:AddSettingsInt("SupportMode", self.SupportMode.Value)
        SettingsManager:AddSettingsInt("AssassinMode", self.AssassinMode.Value)
        SettingsManager:AddSettingsInt("TargetMode", self.TargetMode.Selected)
        SettingsManager:AddSettingsInt("PlayerRange", self.PlayerRange.Value)
        SettingsManager:AddSettingsInt("EnemyRange", self.EnemyRange.Value)
        SettingsManager:AddSettingsInt("DrawTarget", self.DrawTargetCircle.Value)
        SettingsManager:AddSettingsInt("BlockAttackForDodge", self.BlockAttackForDodge.Value)
        SettingsManager:AddSettingsInt("AutomaticPrio", self.UsePrioList.Value)
        SettingsManager:AddSettingsInt("WindUpSlider", self.WindUpSlider.Value)

    end,
    LoadSettings = function(self)
        SettingsManager:GetSettingsFile			("Orbwalker")
        self.HoldRadius.Value = SettingsManager:GetSettingsInt("Settings","HoldRadius")
        self.BlockAALevel.Value = SettingsManager:GetSettingsInt("Settings","BlockAALevel")
        self.AlwaysPush.Value = SettingsManager:GetSettingsInt("Settings","AlwaysPush")
        self.PrioChampHarass.Value = SettingsManager:GetSettingsInt("Settings","PrioChampHarass")
        self.UseSafeFlash.Value = SettingsManager:GetSettingsInt("Settings","UseSafeFlash")
        self.SupportMode.Value = SettingsManager:GetSettingsInt("Settings","SupportMode")
        self.AssassinMode.Value = SettingsManager:GetSettingsInt("Settings","AssassinMode")
        self.TargetMode.Selected = SettingsManager:GetSettingsInt("Settings","TargetMode")
        self.PlayerRange.Value = SettingsManager:GetSettingsInt("Settings","PlayerRange")
        self.EnemyRange.Value = SettingsManager:GetSettingsInt("Settings","EnemyRange")
        self.DrawTargetCircle.Value = SettingsManager:GetSettingsInt("Settings","DrawTarget")
        self.BlockAttackForDodge.Value = SettingsManager:GetSettingsInt("Settings","BlockAttackForDodge")
        self.UsePrioList.Value = SettingsManager:GetSettingsInt("Settings","AutomaticPrio")
        self.WindUpSlider.Value = SettingsManager:GetSettingsInt("Settings","WindUpSlider")
    end,
    --Util functions
    SortList = function(self, List, Mode) 
        local CurrentList = {}
        for _, Object in pairs(List) do
            CurrentList[#CurrentList+1] = Object
        end
        if Mode == "LOWHP" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do    
                    if CurrentList[left].Health > CurrentList[right].Health then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right] 
                        CurrentList[right] = Swap
                    end
                end
            end    
        end
        if Mode == "MAXHP" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do    
                    if CurrentList[left].Health < CurrentList[right].Health then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right] 
                        CurrentList[right] = Swap
                    end
                end
            end    
        end
        if Mode == "MAXRANGE" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do    
                    if CurrentList[left].AttackRange < CurrentList[right].AttackRange then    
                        local Swap = CurrentList[left]
                        CurrentList[left] = CurrentList[right]
                        CurrentList[right] = Swap  
                    end
                end
            end    
        end
        if Mode == "MAXAD" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do    
                    if (CurrentList[left].BaseAttack + CurrentList[left].BonusAttack) < (CurrentList[right].BaseAttack + CurrentList[right].BonusAttack) then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    end
                end
            end    
        end
        if Mode == "MAXAP" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do    
                    if CurrentList[left].AbilityPower < CurrentList[right].AbilityPower then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    end
                end
            end    
        end
        return CurrentList
    end,
    PredictDamageToTarget = function(self, Target, Prio)
        local APDamage = myHero.AbilityPower * (100/(100+Target.MagicResist))
        local ADDamage = (myHero.BaseAttack + myHero.BonusAttack) * (100/(100+Target.Armor)) 
        
        if myHero.BonusAttack > myHero.AbilityPower then
            local PrioDamage        = ADDamage * Prio
            return PrioDamage - (Target.Health + Target.Shield + Target.PhysicalShield)
        else
            local PrioDamage        = APDamage * Prio
            return PrioDamage - (Target.Health + Target.Shield + Target.MagicalShield)   
        end

        return 0
    end,
    GetTargetSelectorList = function(self, Position, Range)
        if self.ForceTarget and self.ForceTarget.IsHero then
            if self.AssassinMode.Value == 1 then
                if self.ForceTarget.IsDead == false then
                    if self:GetDistance(self.ForceTarget.Position, Position) < Range + self.ForceTarget.CharData.BoundingRadius then
                        return {self.ForceTarget}
                    else
                        return {}
                    end
                end
            else
                if self.ForceTarget.IsTargetable and self:GetDistance(self.ForceTarget.Position, Position) < Range + self.ForceTarget.CharData.BoundingRadius then
                    return {self.ForceTarget}
                end
            end
        end

        local Mode = self.TargetOptions[self.TargetMode.Selected+1]
        local List = self:GetEnemyHerosInRange(Position, Range)
       
        local CurrentList = {}
        for _, Object in pairs(List) do
            CurrentList[#CurrentList+1] = Object
        end

        if Mode == "PRIO_LOWHP" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do
                    local LeftPrio = self.Prio[CurrentList[left].Index]
                    local RightPio = self.Prio[CurrentList[right].Index]
                    if LeftPrio and RightPio and LeftPrio.Value < RightPio.Value then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    else
                        if CurrentList[left].Health > CurrentList[right].Health then    
                            local Swap = CurrentList[left] 
                            CurrentList[left] = CurrentList[right]  
                            CurrentList[right] = Swap  
                        end    
                    end   
                end
            end    
        end
        if Mode == "PRIO_NEAREST" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do
                    local LeftPrio = self.Prio[CurrentList[left].Index]
                    local RightPio = self.Prio[CurrentList[right].Index]
                    if LeftPrio and RightPio and LeftPrio.Value < RightPio.Value then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    else
                        if self:GetDistance(myHero.Position, CurrentList[left].Position) > self:GetDistance(myHero.Position, CurrentList[right].Position) then    
                            local Swap = CurrentList[left] 
                            CurrentList[left] = CurrentList[right]  
                            CurrentList[right] = Swap  
                        end    
                    end   
                end
            end    
        end
        if Mode == "PRIO_MOUSE" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do
                    local LeftPrio = self.Prio[CurrentList[left].Index]
                    local RightPio = self.Prio[CurrentList[right].Index]
                    if LeftPrio and RightPio and LeftPrio.Value < RightPio.Value then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    else
                        if self:GetDistance(GameHud.MousePos, CurrentList[left].Position) > self:GetDistance(GameHud.MousePos, CurrentList[right].Position) then    
                            local Swap = CurrentList[left] 
                            CurrentList[left] = CurrentList[right]  
                            CurrentList[right] = Swap  
                        end    
                    end   
                end
            end    
        end
        if Mode == "PRIO_AD" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do
                    local LeftPrio = self.Prio[CurrentList[left].Index]
                    local RightPio = self.Prio[CurrentList[right].Index]
                    if LeftPrio and RightPio and LeftPrio.Value < RightPio.Value then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    else
                        if CurrentList[left].Armor > CurrentList[right].Armor then    
                            local Swap = CurrentList[left] 
                            CurrentList[left] = CurrentList[right]  
                            CurrentList[right] = Swap  
                        end    
                    end   
                end
            end    
        end
        if Mode == "PRIO_AP" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do
                    local LeftPrio = self.Prio[CurrentList[left].Index]
                    local RightPio = self.Prio[CurrentList[right].Index]
                    if LeftPrio and RightPio and LeftPrio.Value < RightPio.Value then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    else
                        if CurrentList[left].MagicResist > CurrentList[right].MagicResist then    
                            local Swap = CurrentList[left] 
                            CurrentList[left] = CurrentList[right]  
                            CurrentList[right] = Swap  
                        end    
                    end   
                end
            end    
        end
        if Mode == "PRIO_HYBRID" then
            for left = 1, #CurrentList do  
                for right = left+1, #CurrentList do
                    local LeftPrio = self.Prio[CurrentList[left].Index]
                    local RightPio = self.Prio[CurrentList[right].Index]
                    if LeftPrio and RightPio and self:PredictDamageToTarget(CurrentList[left], LeftPrio.Value) < self:PredictDamageToTarget(CurrentList[right], RightPio.Value) then    
                        local Swap = CurrentList[left] 
                        CurrentList[left] = CurrentList[right]  
                        CurrentList[right] = Swap  
                    else
                        local LeftDamage = self:PredictDamageToTarget(CurrentList[left], 1)
                        local RightDamage = self:PredictDamageToTarget(CurrentList[right], 1)
                        if LeftDamage < RightDamage then    
                            local Swap = CurrentList[left] 
                            CurrentList[left] = CurrentList[right]  
                            CurrentList[right] = Swap  
                        end    
                    end   
                end
            end    
        end
        return CurrentList    
    end,
    GetAllEnemyHeros = function(self)
        local Enemies = {}
        local Heros = ObjectManager.HeroList
        for _, Object in pairs(Heros) do
            if Object.Team ~= myHero.Team then
                Enemies[#Enemies+1] = Object
            end
        end
        return Enemies
    end,
    GetAllAllyHeros = function(self)
        local Allies = {}
        local Heros = ObjectManager.HeroList
        for _, Object in pairs(Heros) do
            if Object.Team == myHero.Team then
                Allies[#Allies+1] = Object
            end
        end
        return Allies

    end,
    GetAllEnemyTurrets = function(self)
        local Enemies = {}
        local Turrets = ObjectManager.TurretList
        for _, Object in pairs(Turrets) do
            if Object.Team ~= myHero.Team then
                Enemies[#Enemies+1] = Object
            end
        end
        return Enemies
    end,
    GetAllAllyTurrets = function(self)
        local Allies = {}
        local Turrets = ObjectManager.TurretList
        for _, Object in pairs(Turrets) do
            if Object.Team == myHero.Team then
                Allies[#Allies+1] = Object
            end
        end
        return Allies

    end,
    GetAllEnemyMinions = function(self)
        local Enemies = {}
        local Minions = ObjectManager.MinionList
        for _, Object in pairs(Minions) do
            if Object.Team ~= myHero.Team then
                Enemies[#Enemies+1] = Object
            end
        end
        return Enemies
    end,
    GetAllAllyMinions = function(self)
        local Allies = {}
        local Minions = ObjectManager.MinionList
        for _, Object in pairs(Minions) do
            if Object.Team == myHero.Team then
                Allies[#Allies+1] = Object
            end
        end
        return Allies

    end,
    GetAllEnemyMissiles = function(self)
        local Enemies = {}
        local Missiles = ObjectManager.MissileList
        for _, Object in pairs(Missiles) do
            if Object.Team ~= myHero.Team and _ == Object.Index then
                Enemies[#Enemies+1] = Object
            end
        end
        return Enemies
    end,
    GetAllAllyMissiles = function(self)
        local Allies = {}
        local Missiles = ObjectManager.MissileList
        for _, Object in pairs(Missiles) do
            if Object.Team == myHero.Team and _ == Object.Index then
                Allies[#Allies+1] = Object
            end
        end
        return Allies
    end,
    GetEnemyHerosInRange = function(self, Position, Range)
        local InRange = {}
        local Enemies = self:GetAllEnemyHeros()
        for _, Object in pairs(Enemies) do
            local Distance          = self:GetDistance(Object.Position, Position)
            local RangeCheck        = Distance < Range + Object.CharData.BoundingRadius
            local TargetableCheck   = Object.IsTargetable and Object.MaxHealth > 10
            local TargetImmune      = self:TargetIsImmune(Object)
            local GwenCheck         = (Object.BuffData:GetBuff("gwenw_gweninsidew").Valid == false or self:GetDistance(myHero.Position, Object.Position) <= 475)
            if RangeCheck and TargetableCheck and not TargetImmune and GwenCheck then
                InRange[#InRange+1] = Object
            end
        end
        return InRange
    end,
    GetAllyHerosInRange = function(self, Position, Range)
        local InRange = {}
        local Allies = self:GetAllAllyHeros()
        for _, Object in pairs(Allies) do
            local Bound =  math.min(55, Object.CharData.BoundingRadius)
            if self:GetDistance(Object.Position, Position) < Range + Bound and Object.IsTargetable and Object.MaxHealth > 10 then
                InRange[#InRange+1] = Object
            end
        end
        return InRange
    end,
    GetEnemyMinionsInRange = function(self, Position, Range)
        local InRange = {}
        local Enemies = self:GetAllEnemyMinions()
        for _, Object in pairs(Enemies) do
            local Bound =  math.min(55, Object.CharData.BoundingRadius)
            if self:GetDistance(Object.Position, Position) < Range + Bound and Object.IsTargetable and self:IsValidMinion(Object) then
                InRange[#InRange+1] = Object
            end
        end
        return InRange
    end,
    GetAllyMinionsInRange = function(self, Position, Range)
        local InRange = {}
        local Allies = self:GetAllAllyMinions()
        for _, Object in pairs(Allies) do
            local Bound =  math.min(55, Object.CharData.BoundingRadius)
            if self:GetDistance(Object.Position, Position) < Range + Bound and Object.IsTargetable and self:IsValidMinion(Object) then
                InRange[#InRange+1] = Object
            end
        end
        return InRange
    end,
    GetAllJungleMinions = function(self)
        local Allies = {}
        local Minions = ObjectManager.MinionList
        for _, Object in pairs(Minions) do
            if Object.Team == 300 then
                Allies[#Allies+1] = Object
            end
        end
        return Allies
    end,
    GetJungleMinionsInRange = function(self, Position, Range)
        local InRange = {}
        local Jungle = self:GetAllJungleMinions()
        local OffAggro = nil
        for _, Object in pairs(Jungle) do
            local Bound =  math.min(55, Object.CharData.BoundingRadius)
            if self:GetDistance(Object.Position, Position) < Range + Bound and Object.IsTargetable and self:IsValidMinion(Object) then
                InRange[#InRange+1] = Object
                --print(Object.ChampionName) --SRU_Razorbeak, SRU_Red, SRU_Krug, SRU_Murkwolf, SRU_Blue, SRU_Gromp
                if Object.Mana < 100 then
                    if Object.ChampionName == "SRU_Red" or Object.ChampionName == "SRU_Blue" or Object.ChampionName == "SRU_Gromp" then
                        OffAggro = true
                    end
                end
            end
        end
        return InRange, OffAggro
    end,
    GetDistance = function(self, from, to)
        return math.max(0, math.sqrt((from.x - to.x) ^ 2 + (from.y - to.y) ^ 2 + (from.z - to.z) ^ 2))
    end,
    --Helper functions
    GetPlayerLevel = function(self) 
        local Q = myHero:GetSpellSlot(0).Level
        local W = myHero:GetSpellSlot(1).Level
        local E = myHero:GetSpellSlot(2).Level
        local R = myHero:GetSpellSlot(3).Level
        return Q + W + E + R
    end,    
    GetAttackSpeed = function(self)
        local AttackRange		    = myHero.AttackRange
        local AttackSpeedMod	    = myHero.AttackSpeedMod
        local BaseAttackSpeed	    = myHero.CharData.BaseAttackSpeed
        local BaseAttackSpeedRatio	= myHero.CharData.BaseAttackSpeedRatio

        if myHero.ChampionName == "Jhin" then
            local AttackSpeedPerLevel = {0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.14,0.16,0.20,0.24,0.28,0.32,0.36,0.40,0.44}
            local CurrentAttackSpeedMod = AttackSpeedPerLevel[math.min(18, math.max(1, self:GetPlayerLevel()))] + 1.1
            return BaseAttackSpeed * CurrentAttackSpeedMod
        end
        if myHero.ChampionName == "Sion" then
            if myHero.BuffData:GetBuff("sionpassivezombie").Count_Alt > 0 then
                return 1.75
            end
        end
        local AttackSpeed = BaseAttackSpeed + (BaseAttackSpeedRatio * (AttackSpeedMod-1))
        --print(AttackSpeed)
        local JinxExcited		= myHero.BuffData:GetBuff("JinxPassiveKillAttackSpeed").Count_Alt > 0
        local LethalTempo		= myHero.BuffData:GetBuff("ASSETS/Perks/Styles/Precision/LethalTempo/LethalTempo.lua")
        local Stacks			= LethalTempo.Count_Int
        --print(Stacks)
        if Stacks >= 6 or JinxExcited then
             return AttackSpeed
        end

        if myHero.ChampionName == "Zeri" then
            return math.min(AttackSpeed, 1.5)
        end
        
        return math.min(AttackSpeed, 2.5);    
    end,   
    IsValidMinion = function(self,Minion)
        if Minion.Name == "k" or  Minion.Name == "hiu" then
            return false
        end
        if self.TeamHasGP == true and Minion.Name == "Barrel" then
            return false
        end
        local CheckNames = {"Unused","Beacon","Camp", "Plant", "Honey", "Fake", "Cupcake", "Feather", "Fiora"}
        for _, Name in pairs(CheckNames) do
            if string.find(Minion.Name,Name, 1) ~= nil then
                return false
            end
        end
        if string.find(Minion.Name, "Seed", 1) ~= nil and Minion.MaxHealth < 8 then
            return false
        end
        if myHero.ChampionName ~= "Senna" then
            if string.find(Minion.ChampionName, "SennaSoul", 1) ~= nil then
                return false
            end
        end  
        return true
    end,   
    SortAsTurretTargetList = function(self, List, Position)
        local CurrentList = {}
        for _, Object in pairs(List) do
            CurrentList[#CurrentList+1] = Object
        end
        for left = 1, #CurrentList do  
            for right = left+1, #CurrentList do
                if self:GetDistance(Position, CurrentList[left].AIData.TargetPos) > self:GetDistance(Position, CurrentList[right].AIData.TargetPos) then    
                    local Swap = CurrentList[left] 
                    CurrentList[left] = CurrentList[right]  
                    CurrentList[right] = Swap  
                end    
            end
        end
        return CurrentList   
    end,
    GetInRangeFromList = function(self, List, Position, Range)
        local InRange = {}
        for _, Object in pairs(List) do
            if self:GetDistance(Position, Object.Position) < Range then
                InRange[#InRange+1] = Object
            end
        end
        return InRange
    end,
    GetDamageBeforePlayer = function(self, Minion)
        local MinionList    = ObjectManager.MinionList
        local HeroList      = ObjectManager.HeroList
        local TurretList    = ObjectManager.TurretList
        local Missiles      = ObjectManager.MissileList
        local PlayerMissileSpeed = myHero.AttackInfo.Data.MissileSpeed
        --expiremental jayce adjustment to fix lasthits
        if myHero.ChampionName == "Jayce" then
            PlayerMissileSpeed = 1200
        end
        if myHero.ChampionName == "Aphelios" then
            --print(1)
            if myHero.BuffData:GetBuff("ApheliosGravitumManager").Valid then
                --print("1UK")
                PlayerMissileSpeed = 1500
                --Orwalker.ExtraDamage = 0
            end
            if myHero.BuffData:GetBuff("ApheliosCrescendumManager").Valid then
                --print("Sentry?")
                PlayerMissileSpeed = 6000
            end
            if myHero.BuffData:GetBuff("ApheliosSeverumManager").Valid then --ApheliosInfernumManager
                --print("2UK")
                PlayerMissileSpeed = 15000
                --Orwalker.ExtraDamage = 0
            end
            if myHero.BuffData:GetBuff("ApheliosCalibrumManager").Valid then --Sniper
                --print("Sniper")
                PlayerMissileSpeed = 3000
                self.ExtraDamage = -1
            end
            if myHero.BuffData:GetBuff("ApheliosInfernumManager").Valid then --ApheliosInfernumManager
               --print("Spread")
                PlayerMissileSpeed = 2000
                self.ExtraDamage = (myHero.BaseAttack + myHero.BonusAttack) * 0.1
            end
        end
        if myHero.ChampionName == "Zeri" then
            PlayerMissileSpeed = math.huge
        end
        
        local PlayerAttackTime = self:GetPlayerAttackWindup()
        if myHero.AttackRange > 300 then
            PlayerAttackTime   = PlayerAttackTime + (self:GetDistance(myHero.Position, Minion.Position)/PlayerMissileSpeed)
        end
        
        local Damage            = 0
        local HeroDamage        = 0
        local IncomingMissiles  = {}
        for _, Missile in pairs(Missiles) do
            local Team = Missile.Team
            if Team == 100 or Team == 200 then
                local TargetID = Missile.TargetIndex
                if Team ~= Minion.Team and TargetID == Minion.Index then
                    local SourceID  = Missile.SourceIndex
                    if TurretList[SourceID] then
                        local TimeTillMissileDamage = self:GetDistance(Missile.Position, Minion.Position)/1100
                        if TimeTillMissileDamage < PlayerAttackTime then                       
                            local Source    = TurretList[SourceID]
                            local TrtDMG    = self:GetDamageFromTurretToMinion(Source, Minion)
                            if TrtDMG then
                                Damage = Damage + TrtDMG
                                IncomingMissiles[#IncomingMissiles+1] = Missile
                            end
                        end
                    end
                    if MinionList[SourceID] then
                        local TimeTillMissileDamage = self:GetDistance(Missile.Position, Minion.Position)/650
                        if TimeTillMissileDamage < PlayerAttackTime then                       
                            local Source    = MinionList[SourceID]
                            local AD        = Source.BaseAttack + Source.BonusAttack
                            local Armor     = Minion.Armor
                            Damage = Damage + (AD * (100/(100+Armor)))
                            IncomingMissiles[#IncomingMissiles+1] = Missile
                        end
                    end
                    if HeroList[SourceID] then
                        local TimeTillMissileDamage = self:GetDistance(Missile.Position, Minion.Position)/650
                        if TimeTillMissileDamage < PlayerAttackTime then                       
                            local Source    = HeroList[SourceID]
                            local AD        = Source.BaseAttack + Source.BonusAttack
                            local Armor     = Minion.Armor
                            Damage = Damage + (AD * (100/(100+Armor)))
                            HeroDamage = HeroDamage + (AD * (100/(100+Armor)))
                            IncomingMissiles[#IncomingMissiles+1] = Missile
                        end
                    end
                end
            end
        end
        return Damage, HeroDamage, IncomingMissiles
    end,
    GetDamageFromTurretToMinion = function(self, Turret, Minion)
        local Armor = Minion.Armor
        if Minion.AttackRange == 110 then --Melee
            --45%
            local HPDamage = Minion.MaxHealth * 0.45
            return (HPDamage * (100/(100+Armor))) 
        end
        if Minion.AttackRange == 300 then --Siege
            if Turret.MaxHealth == 5000 then --Outer
                --14%
                local HPDamage = Minion.MaxHealth * 0.14
                return (HPDamage * (100/(100+Armor))) 
            end
            if Turret.MaxHealth == 3600 then --Inner
                --11%
                local HPDamage = Minion.MaxHealth * 0.11
                return (HPDamage * (100/(100+Armor))) 
            end
            if Turret.MaxHealth <= 3300 then --Inhib/Nexus
                --8%
                local HPDamage = Minion.MaxHealth * 0.08
                return (HPDamage * (100/(100+Armor))) 
            end
        end
        if Minion.AttackRange == 550 then --Caster
            --70%
            local HPDamage = Minion.MaxHealth * 0.70
            return (HPDamage * (100/(100+Armor))) 
        end                            
    end,
    GetDamagePercentFromTurretToMinion = function(self, Turret, Minion)
        if Minion.AttackRange == 110 then --Melee
            --45%
            return 0.45
        end
        if Minion.AttackRange == 300 then --Siege
            if Turret.MaxHealth == 5000 then --Outer
                --14%
                return 0.14
            end
            if Turret.MaxHealth == 3600 then --Inner
                --11%
                return 0.11
            end
            if Turret.MaxHealth <= 3300 then --Inhib/Nexus
                --8%
                return 0.08
            end
        end
        if Minion.AttackRange == 550 then --Caster
            --70%
            return 0.70
        end                            
    end,
    CheckTurretAggro = function(self, Minion)
        local TurretList = ObjectManager.TurretList
        for _, Turret in pairs(TurretList) do
            if Turret.IsTargetable and Turret.Team ~= Minion.Team and Minion.Team ~= 300 then
                if self:GetDistance(Turret.Position, Minion.AIData.TargetPos) < 750 then
                    return Turret
                end
            end     
        end

        return nil
    end,
    GetTurretMissile = function(self, Turret)
        local Missiles = self:GetAllAllyMissiles()
        for _, Missile in pairs(Missiles) do
            local SourceID = Missile.SourceIndex
            if SourceID == Turret.Index then
                return Missile 
            end
        end
        return nil
    end,
    PlayerMissileOnTheWay = function(self, Target)
        local PlayerDamage = math.floor((myHero.BaseAttack + myHero.BonusAttack) * (100/(100+Target.Armor)))
        local PlayerMissile = self:GetPlayerMissiles()
        for _, Missile in pairs(PlayerMissile) do
            if Missile.TargetIndex == Target.Index and Target.Health - PlayerDamage < PlayerDamage then return true end
        end
        return false
    end,
    PlayerMissileJustSpawned = function(self)
        local PlayerMissile = self:GetPlayerMissiles()
        for _, Missile in pairs(PlayerMissile) do
            if self:GetDistance(myHero.Position, Missile.Position) < 100 then return true end
        end
        return false
    end,
    GetPlayerDamage = function(self, Minion)
        local CritChance = myHero.CritChance
        if myHero.ChampionName == "Jhin" and myHero.Ammo == 1 then
            CritChance = 1.0
        end
        local PlayerDamage = math.floor((myHero.BaseAttack + myHero.BonusAttack + self.ExtraDamage) * (100/(100+Minion.Armor))) * math.max(1.0, math.min(2.0, math.floor(CritChance+1.5))) --gamble a bit with crit 
                
        if myHero.ChampionName == "Zeri" then
            local passive = myHero.BuffData:GetBuff("zeriqpassiveready")
            if passive.Valid then
                if myHero.ChampionName == "Zeri" and (Minion.Health / Minion.MaxHealth) > 0.35 then
                    PlayerDamage = 15 + (25 / 17) * (self:GetPlayerLevel() - 1) * (0.7025 + 0.0175 * (self:GetPlayerLevel() - 1)) + myHero.AbilityPower * 0.04
                end
                if myHero.ChampionName == "Zeri" and (Minion.Health / Minion.MaxHealth) <= 0.35 then
                    PlayerDamage = 4 * 15 + (4 * 25 / 17) * (self:GetPlayerLevel() - 1) * (0.7025 + 0.0175 * (self:GetPlayerLevel() - 1)) + myHero.AbilityPower * 0.16
                end 
            else
                PlayerDamage = (5 + (3 * myHero:GetSpellSlot(0).Level)) + (myHero.BaseAttack + myHero.BonusAttack) / 100 * (100 + (5 * myHero:GetSpellSlot(0).Level))
            end
        end

        if myHero.BuffData:GetBuff("6672buff").Count_Alt >= 2 then
            PlayerDamage = PlayerDamage + (50 * (0.4 * myHero.BonusAttack))
        end

        for i = 6 , 11 do
            local Slot = myHero:GetSpellSlot(i)
            if Slot.Info.Name == "BloodthirsterDummySpell" then
                PlayerDamage = PlayerDamage + 20
            end
        end
        return PlayerDamage
    end,
    GetLaneManagementList = function(self, Range)
        local LasthitList = {}
        local PrepareList = {}
        local PushList = {}
        local Turret    = nil
        local Minions   = self:SortList(self:GetEnemyMinionsInRange(myHero.Position, Range), "MAXRANGE")
        for _, Minion in pairs(Minions) do
            if self:PlayerMissileOnTheWay(Minion) == false then
                local PlayerDamage = self:GetPlayerDamage(Minion)
                local IncomingDamage, HeroDamage, IncomingMissiles   = self:GetDamageBeforePlayer(Minion)

                IncomingDamage                          = math.floor(IncomingDamage)
                if HeroDamage < Minion.Health or Minion.MaxHealth < 10 then
                    local CombinedDamage                    = PlayerDamage + IncomingDamage
                        
                    if CombinedDamage >= Minion.Health then --Minion can be lasthitted
                        LasthitList[#LasthitList+1] = Minion
                    end

                    if Minion.Team == 300 then
                        PushList[#PushList+1] = Minion
                    end 

                    Turret = self:CheckTurretAggro(Minion)
                    if Turret then
                        local Turret_AttackSpeed    = 0.83
                        local Player_AttackSpeed    = self:GetAttackSpeed()
                        local AttacksForPrepare     = math.max(1, math.floor(Player_AttackSpeed/Turret_AttackSpeed))
                        
                        local MinionHP_Percent      = (Minion.Health-IncomingDamage) / Minion.MaxHealth
                        local TurretDamage_Percent  = self:GetDamagePercentFromTurretToMinion(Turret, Minion)
                        local PlayerDamage_Percent  = PlayerDamage / Minion.Health
                        if TurretDamage_Percent then
                            local Turret_Shots          = MinionHP_Percent / TurretDamage_Percent
                            local Player_Shots          = MinionHP_Percent / PlayerDamage_Percent                        
                            local HP_AfterTurret        = (Minion.Health-IncomingDamage) - ((Minion.MaxHealth*TurretDamage_Percent)*math.floor(Turret_Shots))
                            local Delta                 = Turret_Shots / Player_Shots  
                            if HP_AfterTurret > PlayerDamage or Delta > 1 then
                                LasthitList[#LasthitList+1] = Minion 
                            end 
                        end
                    end      
                end
            end

            if not Turret then
                local AttackSpeed               = self:GetAttackSpeed()
                local PlayerDamage              = self:GetPlayerDamage(Minion)
    
                local IncomingDamage            = math.floor(self:GetDamageBeforePlayer(Minion))
                local AllyMinions               = self:GetAllyMinionsInRange(Minion.Position, 400)
                if #AllyMinions == 0 then
                    PushList[#PushList+1] = Minion
                end
    
                local CombinedDamage = PlayerDamage + IncomingDamage
                local WaitCondition1 = (IncomingDamage == 0 and Minion.Health - PlayerDamage < (PlayerDamage/AttackSpeed))
                local WaitCondition2 = (IncomingDamage > PlayerDamage and Minion.Health - CombinedDamage  < (PlayerDamage * 0.75))
                local WaitCondition3 = (Minion.Health - CombinedDamage <= 155)
    
                if myHero.ChampionName == "Zeri" then
                    WaitCondition3 = (Minion.Health - CombinedDamage <= 200)
                end
    
                if WaitCondition1 == false and WaitCondition2 == false and not WaitCondition3 then
                    PushList[#PushList+1] = Minion
                else
                    if self.AlwaysPush.Value == 0 then
                        if WaitCondition3 and #AllyMinions >= 2 and IncomingDamage > 0 then
                            self.WaitForLasthit = true
                            self.WaitMinion = Minion
                        end
                    end
                end
            end
        end

        if #LasthitList > 0 then
            return LasthitList, {}
        end

        if self.WaitForLasthit == true and self.WaitForLastHitTimer == nil then
            self.WaitForLastHitTimer = GameClock.Time + 0.1
        end

        if #PushList > 0 then 
            if self.WaitForLasthit then
                return LasthitList, {}
            else
                return LasthitList, PushList
            end
        end

		local Turrets = self:SortList(ObjectManager.TurretList, "MAXHP")
		for I, Turret in pairs(Turrets) do
			if Turret.Team ~= myHero.Team then
				if self:GetDistance(myHero.Position, Turret.Position) < (Range + 55) then
					if Turret.IsTargetable and Turret.IsInvincible == false then
                        PushList[#PushList+1] = Turret
					end
				end
			end
		end

        local Inhibs = ObjectManager.InhibList
		for I, Inhib in pairs(Inhibs) do
			if Inhib.Team ~= myHero.Team then
				if self:GetDistance(myHero.Position, Inhib.Position) < (Range + 200) then
					if Inhib.IsTargetable and Inhib.IsInvincible == false then
                        PushList[#PushList+1] = Inhib
					end
				end
			end
		end

        local Nexuss = ObjectManager.NexusList
		for I, Nexus in pairs(Nexuss) do
			if Nexus.Team ~= myHero.Team then
				if self:GetDistance(myHero.Position, Nexus.Position) < (Range + 300) then
					if Nexus.IsTargetable and Nexus.IsInvincible == false then
                        return {Nexus}, {Nexus}
					end
				end
			end
		end
        return LasthitList, PushList
    end,
    Enable = function(self)
        self.Enabled = 1
    end,
    Disable = function(self)
        self.Enabled = 0
    end,
    --Kiting functions
    ActionReady = function(self)
        local Timer 		= os.clock() -  self.LastMoveTime
        local APMTimer 		= (60000 / Settings.ActionsPerMinute) / 1000
        return Timer > APMTimer 
    end,    
    GetPlayerAttackDelay = function(self)
        local AttackSpeed = self:GetAttackSpeed()
        local Delay = (1 / AttackSpeed) --1.0f/((PlayerAttackSpeed + 1.0f) * 0.658f);
        -- if myHero.ChampionName == "Kalista" and AttackSpeed > 2 then
        --     return Delay * (1 + AttackSpeed/15)
        -- end
        -- quicker AA after AA
        return Delay
    end,
    GetPlayerAttackWindup = function(self)
        local AttackTime 		    = self:GetPlayerAttackDelay()
        local WindupPercent 		= (0.3 + myHero.CharData.CastTimeAdd)
        local WindupModifier		= myHero.CharData.CastTimeMod
        local BaseAttackSpeed       = myHero.CharData.BaseAttackSpeed
        local BonusAttackSpeed      = math.ceil((myHero.AttackSpeedMod - 1) * 100)
        local BaseWindupTime        = (1 / BaseAttackSpeed) * WindupPercent
        local Windup                = math.min(AttackTime, BaseWindupTime + ((AttackTime * WindupPercent) - BaseWindupTime) * WindupModifier)
        if myHero.ChampionName == "Senna" then
            Windup = Windup*0.6
        end   
        if myHero.ChampionName == "Graves" then
           Windup = Windup*0.5 
        end
        if self.WindUpSlider.Value ~= 0 then
            return Windup * (self.WindUpSlider.Value / 100)
        end
        return Windup
    end,
    IsAutoAttackMissile = function(self, Name)
        if string.find(Name, "Attack", 1) ~= nil then
            return true
        end
        local Missiles = {}
        Missiles["Caitlyn"] 		= {"caitlynheadshotmissile"}
        Missiles["Ashe"] 			= {"frostarrow"}
        Missiles["Kennen"] 		    = {"kennenmegaproc"}
        Missiles["Quinn"] 			= {"quinnwenhanced"}
        Missiles["Vayne"] 			= {"vaynecondemn"}
        Missiles["Jhin"] 			= {"jhine"}
    
        local PossibleAutos = Missiles[myHero.ChampionName]
        if PossibleAutos then
            for i = 1, #PossibleAutos do
                if Name:lower() == PossibleAutos[i] then
                    return true
                end
            end
        end
        return false
    end,   
    IsSpecialAttack = function(self, Name)
        local Autos = {}
        Autos["MasterYi"] 		= {"masteryidoublestrike"}
        Autos["Garen"] 			= {"garenslash2"}
        --Autos["Kennen"] 		= {"kennenmegaproc"}
        Autos["Renekton"] 		= {"renektonexecute", "renektonsuperexecute"}			
        Autos["Vayne"] 			= {"vaynecondemn"}
        Autos["Jhin"] 			= {"jhine"}
        Autos["Rengar"] 		= {"rengarnewpassivebuffdash"}
        Autos["Trundle"] 		= {"trundleq"}
        Autos["XinZhao"] 		= {"xinzhaoqthrust1","xinzhaoqthrust2","xinzhaoqthrust3"}
        Autos["Pantheon"] 		= {"pantheoneshieldslam"}
        Autos["Viktor"] 		= {"viktorqbuff"}
    
        local PossibleAutos = Autos[myHero.ChampionName]
        if PossibleAutos then
            for i = 1, #PossibleAutos do
                if Name:lower() == PossibleAutos[i] then
                    return true
                end
            end
        end
        return false
    end,  
    CanLasthit = function(self, Target)
        local IncomingDamage		= 0
        local TargetArmorMod 		= 100 / (100 + Target.Armor)
        local PlayerDamage 			= myHero.BaseAttack + myHero.BonusAttack + self.ExtraDamage
        if myHero.ChampionName == "Zeri" then
            PlayerDamage = 4 * 15 + (4 * 25 / 17) * (self:GetPlayerLevel() - 1) * (0.7025 + 0.0175 * (self:GetPlayerLevel() - 1))
        end
        local PlayerMissileSpeed	= myHero.AttackInfo.Data.MissileSpeed
        if myHero.ChampionName == "Aphelios" then
            --print(1)
            if myHero.BuffData:GetBuff("ApheliosGravitumManager").Valid then
                PlayerMissileSpeed = 400
                Orwalker.ExtraDamage = 0
            end
            if myHero.BuffData:GetBuff("ApheliosSeverumManager").Valid then --ApheliosInfernumManager
                PlayerMissileSpeed = 0
                Orwalker.ExtraDamage = 0
            end
            if myHero.BuffData:GetBuff("ApheliosInfernumManager").Valid then --ApheliosInfernumManager
               --Print("RED")
                PlayerMissileSpeed = 450
                Orwalker.ExtraDamage = (myHero.BaseAttack + myHero.BonusAttack) * 0.1
            end
        end
        if myHero.AttackRange < 300 then
            PlayerMissileSpeed 		= math.huge
        end
        local PlayerDistance		= math.max(0, self:GetDistance(myHero.Position, Target.Position) - myHero.CharData.BoundingRadius) -- Player Missiles doesnt spawn directly at center of champ, so distance is a bit shorter -> wait a bit longer to shoot
        local PlayerTime			= (PlayerDistance/PlayerMissileSpeed) + self.Windup
        --print(PlayerMissileSpeed)
        local Minions  = ObjectManager.MinionList
        local Missiles = ObjectManager.MissileList
    
        local MissileFilter = {}
        for I,Object in pairs(ObjectManager.MissileList) do
            local Index 	= Object.Index
            local Name		= Object.Name
            if Index > 0 and Index < 3500 and string.len(Name) > 0 and MissileFilter[Index] == nil then
                MissileFilter[Index] = Object
            end
        end
    
        for I,Missile in pairs(MissileFilter) do
            local SourceID				= Missile.SourceIndex
            local TargetID				= Missile.TargetIndex
            local MissileSource			= nil
            local MissileTarget			= nil
            if SourceID > 0 and SourceID < 3500 then
                MissileSource 			= Minions[SourceID]
            end
            if TargetID > 0 and TargetID < 3500 then
                MissileTarget 			= Minions[TargetID]
            end
            if I == Missile.Index and MissileTarget and MissileSource and MissileSource.IsMinion and MissileSource.IsDead == false and MissileSource.AttackRange > 300 then
                local MissileDistance		= self:GetDistance(Missile.Position, Target.Position)
                if MissileDistance > 0 and MissileTarget.Index == Target.Index and Missile.Team == myHero.Team then
                    local MissileDamage 	= (MissileSource.BaseAttack * TargetArmorMod)
                    local MissileTime		= MissileDistance / 650
                    if MissileTime < PlayerTime then
                        IncomingDamage 		= IncomingDamage + MissileDamage
                    end
                end
            end
        end
        IncomingDamage = (IncomingDamage + (PlayerDamage * TargetArmorMod) + self.ExtraDamage)
        if IncomingDamage > Target.Health then
            return true
        end
        return false
    end,
    GetPlayerMissiles = function(self)
        local Missiles = self:GetAllAllyMissiles()
        local PlayerMissiles = {}

        for _, Missile in pairs(Missiles) do
            local TargetID = Missile.TargetIndex
            local SourceID = Missile.SourceIndex
            if SourceID == myHero.Index and TargetID then
                PlayerMissiles[#PlayerMissiles+1] = Missile 
            end
        end
        return PlayerMissiles
    end,
    CanAttackReset = function(self)
        --myHero.BuffData:ShowAllBuffs()
        print(myHero.ActiveSpell.Info.Name)
        local AAResets = {}
        -- all AA resets that aren't working properly should be adjust in the champion script like so:
        -- When casting the ability check if Orbwalker.ResetReady == 1
        AAResets["Aatrox"] 	    = {"AatroxE"}
        AAResets["Blitzcrank"] 	= {"powerfist"}
        AAResets["Camille"] 	= {"CamilleQ"}
        AAResets["Chogath"] 	= {"VorpalSpikes"}
        AAResets["Darius"] 		= {"dariusnoxiantacticsonh", "DariusNoxianTacticsONH"}
        AAResets["DrMundo"] 	= {"DrMundoE"}		
        --AAResets["Ekko"] 	    = {"EkkoE"} resetready check in its own script
        AAResets["Elise"] 	    = {"EliseSpiderW"}		
        AAResets["Fiora"] 		= {"fioraflurry"}	
        AAResets["Fizz"] 		= {"FizzW"}	
        AAResets["Hecarim"] 	= {"hecarimrapidslash", "hecarimrampspeed"}		
        AAResets["Gangplank"] 	= {"parley", "GangplankQProceed"}
        -- couldn't test rengar
        AAResets["Rengar"] 		= {"rengarq", "rengarqemp"}		
        AAResets["Sivir"] 		= {"sivirwmarker"}		
        AAResets["Garen"] 		= {"garenq"}		
        --illaoi
        AAResets["Jax"] 		= {"jaxempowertwo"}		
        AAResets["Jayce"] 		= {"jaycehypercharge"}		
        AAResets["Kassadin"] 	= {"netherblade"}
        AAResets["Kayle"] 	    = {"kaylee"}
        AAResets["Kindred"]     = {"kindredqasbuff"}		
        AAResets["Leona"] 		= {"leonashieldofdaybreak"}		
        AAResets["Lucian"]      = {"lucianpassivebuff"}
        AAResets["Malphite"]    = {"MalphiteThunderclap"}
        -- doesn't work like that, need to adjust
        -- AAResets["Maokai"]      = {"maokaipassiveready"}
        AAResets["MasterYi"] 	= {"Meditate"}		
        AAResets["Nasus"] 		= {"nasusq"}		
        AAResets["Nidalee"] 	= {"takedown"}
        AAResets["Nilah"] 	    = {"NilahE"}
        AAResets["Olaf"] 	    = {"OlafFrenziedStrikes"}
        AAResets["Pantheon"]    = {"OlafFrenziedStrikes"}	
        AAResets["Mordekaiser"]	= {"mordekaisermaceofspades"}		
        AAResets["Poppy"] 		= {"poppydevastatingblow"}
        -- does not work as intended either
        -- AAResets["RekSai"] 		= {"RekSaiQAttack", "RekSaiQAttack2", "RekSaiQAttack3"}
        AAResets["Renekton"] 	= {"renektonpreexecute", "RenektonExecute"}
        --rengar
        --samira
        AAResets["Sejuani"] 	= {"SejuaniE2"}
        AAResets["Sett"] 	    = {"SettQ"}
        AAResets["Shyvana"] 	= {"ShyvanaDoubleAttack"}
        AAResets["Sivir"] 	    = {"SivirW"}
        AAResets["Sona"] 	    = {"SonaEPassiveAttack"}
        AAResets["Talon"] 		= {"TalonQAttack"}
        AAResets["Trundle"] 	= {"TrundleQ", "TrundleTrollSmash"}
        AAResets["Vayne"] 		= {"vaynetumblebonus"}
        AAResets["Vi"] 			= {"vie"}
        AAResets["Viego"] 		= {"viegowdash"}
        -- AAResets["Volibear"] 	= {"VolibearQ"} NEED Q resetready check in its own script
        -- wukong needs Q ResetReady check in its own script
        AAResets["MonkeyKing"] 	= {"MonkeyKingDoubleAttack"}	
        AAResets["XinZhao"] 	= {"XinZhaoQ"}
        AAResets["Yorick"] 		= {"yorickspectral", "yorickqbuff"}
        AAResets["Zac"] 		= {"ZacQ"}
        --zeri doesnt show E in printing..
        --zoe
        AAResets["Riven"] 		= {"RivenTriCleave"}
    
        local PossibleBuffs = AAResets[myHero.ChampionName]
        if PossibleBuffs then
            for i = 1, #PossibleBuffs do
                local Buffname = PossibleBuffs[i]
                local Buff = myHero.BuffData:GetBuff(Buffname)
                if Buff.Count_Alt > 0 and Buff.Valid == true and (GameClock.Time - Buff.StartTime) < 0.125 then -- used to be 0.1 need to test
                    return true
                end
            end	
        end

        if myHero.ChampionName == "Ashe" then
            local Buff = myHero.BuffData:GetBuff("AsheQ")
            local QBuff = myHero.BuffData:GetBuff("AsheQAttack").Valid
            if Buff ~= nil and Buff.Count_Alt == 0 and QBuff and GameClock.Time - Buff.StartTime < 0.085 then
                return true
            end
        end

        if myHero.ChampionName == "Aphelios" then
            local Crescendum = myHero.BuffData:GetBuff("ApheliosCrescendumManager")
            local Crescendum_Valid = Crescendum.Valid or Crescendum.Count_Alt > 0
            if Crescendum_Valid then
                if Aphelios:CresReset() == true then
                    return true
                end
            end
        end
        if myHero.ChampionName == "Katarina" then
            local KataE = "KatarinaE"
            if myHero.ActiveSpell.Info.Name == KataE then
                return true
            end
        end
        DashResets = { "Lucian", "Riven", "Vayne", "Belveth", "Graves" }
        for _, DashChampName in pairs(DashResets) do
            if myHero.ChampionName == DashChampName and myHero.AIData.Dashing then
                return true
            end
        end
        return false
    end,
    HasNoMissiles = function(self)
        if myHero.AttackRange < 300 then return true end

        local NoMissileRanged = {"Senna", "Kayle"}
        for _, Name in pairs(NoMissileRanged) do
            if myHero.ChampionName == Name then
                return true
            end
        end
        return false
    end,
    ResetTimers = function(self)
        self.Windup         = 0
        self.Attack         = 0
        self.ResetReady     = 0
        self.AttackTimer    = 0
        self.WindupTimer    = 0
    end,
    ManageAttackTimer = function(self)
        local WindupTime        = os.clock() - self.WindupTimer
        local AttackTime        = os.clock() - self.AttackTimer
        
        if (myHero.CharacterState&1 == 0 or myHero.AIData.Dashing) and myHero.ChampionName ~= "Kalista" then
            self:ResetTimers()
            return  
        end
        if self.Windup == 1 then
            self.WindupTimer = os.clock()
            local WindupCheck = (AttackTime > self.LastWindup*2)
            if string.len(myHero.ActiveSpell.Info.Name) == 0 and ((self.PrevTarget and (self.PrevTarget.IsDead or self.PrevTarget.IsTargetable == false)) or WindupCheck) then
                self:ResetTimers()
            end    
        end
        if string.len(myHero.ActiveSpell.Info.Name) > 0 then
            if self.Windup == 1 then 
                self.ResetReady     = 1

                if myHero.ChampionName ~= "Kalista" then
                    if myHero.ChampionName == "Zeri" then
                        self.AttackTimer     = self.WindupTimer
                    else
                        self.AttackTimer     = self.WindupTimer - math.min(0.2, self.LastWindup*2)
                    end
                else
                    if self:GetAttackSpeed() <= 2.5 then
                        self.AttackTimer = self.WindupTimer + (GameHud.Ping/2000)
                    end
                end
            end
            self.Windup         = 0
        end
        --print(self.Attack, self.Windup, self.AttackTimer, self.WindupTimer, os.clock())
    end,    
    CanAttack = function(self)
        local DashCheck         = myHero.AIData.Dashing == false or myHero.ChampionName == "Kalista"
        local TimerCheck        = (os.clock() - self.AttackTimer) > self:GetPlayerAttackDelay()
        local LevelCheck        = (self.BlockAALevel.Value == 0 or self:GetPlayerLevel() < self.BlockAALevel.Value)
        local EvadeCheck        = (self.BlockAttack == 0 or self.BlockAttackForDodge.Value == 0)
        local ChannelCheck      = (myHero.CharacterState&1) == 1 and string.len(myHero.ActiveSpell.Info.Name) == 0
        if self.DontAA == 1 then
            return nil
        end
        if myHero.ChampionName == "Riven" then
            if myHero.AIData.Moving == true and myHero.AIData.Dashing == false and (GameClock.Time - myHero.BuffData:GetBuff("riventricleavesoundone").StartTime > 0 and GameClock.Time - myHero.BuffData:GetBuff("riventricleavesoundone").StartTime < 0.8) or (GameClock.Time - myHero.BuffData:GetBuff("riventricleavesoundtwo").StartTime > 0 and GameClock.Time - myHero.BuffData:GetBuff("riventricleavesoundtwo").StartTime < 0.8) or (GameClock.Time - myHero.BuffData:GetBuff("riventricleavesoundthree").StartTime > 0 and GameClock.Time - myHero.BuffData:GetBuff("riventricleavesoundthree").StartTime < 0.8) then
                return true
            end
            if myHero.ActiveSpell.Info.Name == "RivenMartyr" then
                --print("WYT")
                self.RivenWTimer = os.clock()
            end
            --print(os.clock() - self.WTimer)
            if myHero:GetSpellSlot(0).Charges ~= 0 and self.RivenWTimer ~= nil then
                if (os.clock() - self.RivenWTimer) > 0 and (os.clock() - self.RivenWTimer) < self.LastWindup then
                    return true
                end
            end
        end
        return (DashCheck and LevelCheck and EvadeCheck) and (self:CanAttackReset() or (TimerCheck and (ChannelCheck or myHero.ChampionName == "Kalista")))
    end,
    CanMove = function(self, Target)
        local TimerCheck        = (self.Attack == 1 and ((os.clock() - self.WindupTimer) > self.LastWindup or myHero.ChampionName == "Kalista" or myHero.ActiveSpell.WindupIsFinished)) 
        local ClickerCheck      = (self.Attack == 0 and self:ActionReady())
        local EvadeCheck        = (self.BlockAttack == 1 and self.BlockAttackForDodge.Value == 1)
        return TimerCheck or ClickerCheck or EvadeCheck 
    end,
    IssueAttack = function(self, Position, Target)
        self.Attack         =   1
        self.Windup         =   1
        self.ResetReady     =   0
        self.LastWindup     =   self:GetPlayerAttackWindup()
        self.LastDelay      =   self:GetPlayerAttackDelay()            
        local ChampsOnlyClick = 0
        if Target and Target.IsHero == true then
            ChampsOnlyClick = 1
        end
        self.LastClick      =   os.clock()

        --print(Target.Name, Target.CharacterState)
        self.PrevTarget     = Target            
        if myHero.ChampionName == "Zeri" then
            local passive = myHero.BuffData:GetBuff("zeriqpassiveready")
            if passive.Valid then
                Engine:AttackClick(Position, ChampsOnlyClick)
            else
                if Engine:SpellReady("HK_SPELL1") then
                    Engine:CastSpell("HK_SPELL1", Position, ChampsOnlyClick)
                end
            end
        else
            Engine:AttackClick(Position, ChampsOnlyClick)
        end
        self.WindupTimer    =   os.clock()
        self.AttackTimer    =   os.clock()
    end,
    IssueMove = function(self, Position)
        self.Attack         = 0
        self.PrevTarget     = nil            
        self.LastMoveTime   = os.clock()
        local HoldRadius = self.HoldRadius.Value
        if myHero.ChampionName == "Kalista" then
            HoldRadius = 0
        end
        if Position then
            if self:GetDistance(myHero.Position, Position) > HoldRadius then
                Engine:MoveClick(Position)
            end
		else
            if self:GetDistance(myHero.Position, GameHud.MousePos) > HoldRadius then
                Engine:MoveClick(nil)
            end
        end
    end,
    Orbwalk = function(self, Target)        
        self.DrawTarget = Target
        if self:CanMove(Target) then
            if Target and self:CanAttack() then
                self:IssueAttack(Target.Position, Target)
                if myHero.ChampionName ~= "Kalista" then return end
            end
            return self:IssueMove(self.MovePosition)
        end    
    end,
    --Feature functions
    TargetIsImmune = function(self, currentTarget)
        local ImmuneBuffs = {
            "KayleR", "TaricR", "KarthusDeathDefiedBuff", "KindredRNoDeathBuff", "UndyingRage", "FioraW", "PantheonE", "sionpassivezombie", "ChronoShift"
        }
        -- print(currentTarget.BuffData:ShowAllBuffs())
        for i = 1, #ImmuneBuffs do
            local Buff = ImmuneBuffs[i]
            if currentTarget.BuffData:GetBuff(Buff).Valid then
                if currentTarget.BuffData:GetBuff("KindredRNoDeathBuff").Valid then
                    local hpPercent = 100 * currentTarget.Health / currentTarget.MaxHealth
                    if hpPercent < 14 or currentTarget.Health < (currentTarget.MaxHealth * 0.1 + myHero.BaseAttack + myHero.BonusAttack) * 2.1 or currentTarget.Health < (currentTarget.MaxHealth * 0.1 + myHero.AbilityPower * 1.5) then
                        return true -- Immune
                    else
                        return false
                    end
                elseif currentTarget.BuffData:GetBuff("UndyingRage").Valid or currentTarget.BuffData:GetBuff("ZileanR").Valid then
                    local hpPercent = 100 * currentTarget.Health / currentTarget.MaxHealth
                    if hpPercent < 6 or currentTarget.Health < (myHero.BaseAttack + myHero.BonusAttack) * 2.1 or currentTarget.Health < myHero.AbilityPower * 1.5 then
                        return true  -- Immune
                    else
                        return false
                    end
                elseif currentTarget.BuffData:GetBuff("PantheonE").Valid then
                    local TargetPos = currentTarget.Position
                    local Modifier  = 100
                    local EPos   = Vector3.new(TargetPos.x + (currentTarget.Direction.x*Modifier),TargetPos.y ,TargetPos.z + (currentTarget.Direction.z*Modifier))
                    if EPos and self:GetDistance(myHero.Position, currentTarget.Position) > self:GetDistance(myHero.Position, EPos) then
                        return true  -- Immune
                    else
                        return false
                    end
                end
                return true
            end
        end
        return false
    end,
    EnemiesInRange = function(self, Position, Range)
        local count = 0
        for _,Hero in pairs(ObjectManager.HeroList) do
            if Hero.Team ~= myHero.Team and Hero.IsTargetable then
                if Orbwalker:GetDistance(Hero.Position , Position) < Range then
                    count = count + 1			
                end
            end
        end
        return count
    end,
    IsCannonAboutToDie = function(self, LasthitList)
        for i, Minion in pairs(LasthitList) do
            if not Minion.IsDead and Minion.IsTargetable and self:GetDistance(myHero.Position, Minion.Position) <= 800 then
                if Minion.ChampionName == "SRU_ChaosMinionSiege" or Minion.ChampionName == "SRU_OrderMinionSiege" then
                    if Minion.Health <= (myHero.BaseAttack + myHero.BonusAttack) * 1.25 then
                        return true
                    end
                end
            end
        end
        return false
    end,
    GetTarget = function(self, Mode, Range)
        Mode = Mode:upper() --old champ script compatible
        local HarassPrio = 0
        if self.PrioChampHarass.Value == 1 and self:EnemiesInRange(myHero.Position, Orbwalker.OrbRange+5) >= 1 then
            HarassPrio = 1
        end
        if Mode == "LASTHIT" or (Mode == "HARASS" and self.SupportMode.Value == 0 and HarassPrio == 0) then --LASTHIT OVER CHAMPION HARASS
            local LasthitList, PushList = self:GetLaneManagementList(Range)
            if LasthitList[1] then
                local Turret = self:CheckTurretAggro(LasthitList[1])
                if not Turret then
                    for i, Minion in pairs(LasthitList) do
                        if not Minion.IsDead and Minion.IsTargetable and self:GetDistance(myHero.Position, Minion.Position) <= 800 then
                            if Minion.ChampionName == "SRU_ChaosMinionSiege" or Minion.ChampionName == "SRU_OrderMinionSiege" then -- need to add otherside as well
                                return Minion
                            end
                        end
                    end
                else
                    -- junk way, need to readd preparelist and make order lasthitlist > preparelist > pushlist
                    local PlayerDamage = nil
                    local lowestMinion = nil
                    for i, Minion in pairs(LasthitList) do
                        if not Minion.IsDead and Minion.IsTargetable then
                            if lowestMinion == nil then
                                lowestMinion = Minion
                            end
                            if lowestMinion ~= nil then
                                if Minion.Health < lowestMinion.Health then
                                    lowestMinion = Minion
                                end
                            end
                        end
                    end
                    if lowestMinion ~= nil then
                        PlayerDamage = self:GetPlayerDamage(lowestMinion)
                        if lowestMinion.Health <= PlayerDamage then
                            return lowestMinion
                        end
                    end
                end
                local IsCannonAboutToDie = self:IsCannonAboutToDie(LasthitList)
                if not IsCannonAboutToDie then
                    return LasthitList[1]
                end
            end
        end
        if Mode == "COMBO" or Mode == "HARASS" then
            local TargetList = self:GetTargetSelectorList(myHero.Position, Range)
            return TargetList[1] 
        end
        if Mode == "LANECLEAR" then
            local LasthitList, PushList = self:GetLaneManagementList(Range)
            local JungleMinions, OffAggro = self:GetJungleMinionsInRange(myHero.Position, Range)
            if #JungleMinions > 0 and OffAggro == nil then
                --print("WTF")
                PushList = self:SortList(JungleMinions, "MAXHP")
                LasthitList = self:SortList(JungleMinions, "MAXHP")
            end
            if LasthitList[1] then
                local Turret = self:CheckTurretAggro(LasthitList[1])
                if not Turret then
                    for i, Minion in pairs(LasthitList) do
                        if not Minion.IsDead and Minion.IsTargetable and self:GetDistance(myHero.Position, Minion.Position) <= 800 then
                            if Minion.ChampionName == "SRU_ChaosMinionSiege" or Minion.ChampionName == "SRU_OrderMinionSiege" then -- need to add otherside as well
                                return Minion
                            end
                        end
                    end
                else
                    -- junk way, need to readd preparelist and make order lasthitlist > preparelist > pushlist
                    local PlayerDamage = nil
                    local lowestMinion = nil
                    for i, Minion in pairs(LasthitList) do
                        if not Minion.IsDead and Minion.IsTargetable then
                            if lowestMinion == nil then
                                lowestMinion = Minion
                            end
                            if lowestMinion ~= nil then
                                if Minion.Health < lowestMinion.Health then
                                    lowestMinion = Minion
                                end
                            end
                        end
                    end
                    if lowestMinion ~= nil then
                        PlayerDamage = self:GetPlayerDamage(lowestMinion)
                        if lowestMinion.Health <= PlayerDamage then
                            return lowestMinion
                        end
                    end
                end
                local IsCannonAboutToDie = self:IsCannonAboutToDie(LasthitList)
                if not IsCannonAboutToDie then
                    return LasthitList[1]
                end
            end
            local AllyMinions = self:GetAllyMinionsInRange(myHero.Position, 400)
            if #AllyMinions == 0 then
                self.WaitForLasthit = false
                self.WaitForLastHitTimer = nil
                self.WaitMinion = nil
            end
            if self.WaitMinion ~= nil then
                if math.floor(self:GetDamageBeforePlayer(self.WaitMinion)) == 0 then
                    self.WaitForLasthit = false
                    self.WaitForLastHitTimer = nil
                    self.WaitMinion = nil
                end
            end
            if self.WaitForLastHitTimer ~= nil then
                if GameClock.Time >= self.WaitForLastHitTimer then
                    self.WaitForLasthit = false
                    self.WaitForLastHitTimer = nil
                    self.WaitMinion = nil
                end
            end
            if not self.WaitForLasthit then
                if PushList[#PushList] then
                    return PushList[#PushList]              
                end
            end
        end
        return nil
    end,
    GetClosestToMouse = function(self, List) 
        local CurrentList = {}
        for _, Object in pairs(List) do
            CurrentList[#CurrentList+1] = Object
        end
        for left = 1, #CurrentList do  
            for right = left+1, #CurrentList do    
                if self:GetDistance(GameHud.MousePos, CurrentList[left].Position) > self:GetDistance(GameHud.MousePos, CurrentList[right].Position) then    
                    local Swap = CurrentList[left] 
                    CurrentList[left] = CurrentList[right] 
                    CurrentList[right] = Swap
                end
            end
        end
        return CurrentList[1]    
    end,
    GetForceTarget = function(self)
        --[[self.ForceTarget = nil
        local Object = Engine:GetForceTarget()
        if Object and Object.IsHero and Object.Team ~= myHero.Team then
            self.ForceTarget = Object
        end]]

        if Engine:IsKeyDown("HK_FORCETARGET") then
            local Enemy = self:GetClosestToMouse(self:GetEnemyHerosInRange(GameHud.MousePos, 100))
            if Enemy then
                self.ForceTarget = Enemy
                return
            end
            local Minion = self:GetClosestToMouse(self:GetEnemyMinionsInRange(GameHud.MousePos, 100)) 
            if Minion then
                self.ForceTarget = Minion
                return
            end
            self.ForceTarget = nil
        end
    end,
    CheckBuffCount = function(self, Target)
        local BuffCount = 0
        local WBuff_Check = Target.BuffData:GetBuff("CaitlynWSnare").Count_Alt > 0
        local EBuff_Check = Target.BuffData:GetBuff("CaitlynEMissile").Count_Alt > 0
        if EBuff_Check then
            self.ETimer 	= os.clock()
        end
        if WBuff_Check and EBuff_Check == false then
            BuffCount = 1
        end
        if EBuff_Check and WBuff_Check == false then
            BuffCount = 1
        end
        if (EBuff_Check and WBuff_Check) or WBuff_Check and ((os.clock() - self.ETimer) < 2.5 and (os.clock() - self.ETimer) > 0) then
            BuffCount = 2
        end
        return BuffCount
    end,
    GetSummonerKey = function(self, SummonerName)
        for i = 4 , 5 do
            if string.find(myHero:GetSpellSlot(i).Info.Name, SummonerName) ~= nil  then
                return self.KeyNames[i]
            end
        end
        return nil
    end,
    SafeFlash = function(self)
        local Flash = self:Flash_Check()
    
        if Flash ~= false then
            Engine:ReleaseSpell(Flash.Key, nil)
        end
    end,
    Flash_Check = function(self)
        local Flash = {}
        Flash.Key = self:GetSummonerKey("SummonerFlash")	
        if Flash.Key ~= nil then
            if Engine:SpellReady(Flash.Key) then
                return Flash
            end
        end
        return false
    end,
    Safe_Flash = function(self)
        if self.UseSafeFlash.Value == 1 then
            local Flash = self:Flash_Check()
    
            if Flash ~= false then
                Engine:ReleaseSpell(Flash.Key, nil)
            end
        end
    end,
    GetCaitlynHeadshotTarget = function(self)
        local Heros = self:SortList(ObjectManager.HeroList, "LOWHP")
        for _, Hero in pairs(Heros) do
            --Hero.BuffData:ShowAllBuffs()
            if Hero.Team ~= myHero.Team and Hero.IsTargetable == true then
                if self:GetDistance(Hero.Position, myHero.Position) <= 1300 then --CaitlynEMissile --eternals_caitlyneheadshottracker
                    --print(self:CheckBuffCount(Hero))
                    if #self.CaitHSCounts < self:CheckBuffCount(Hero) then 
                        return Hero
                    end
                end
            end
        end
        return nil    
    end,
    CresOnWayCheck = function(self)
        local CresMissileName = "ApheliosCrescendumAttackMisInMini"
        local MissileList = ObjectManager.MissileList
        for _, Missile in pairs(MissileList) do
            --print(Missile.Name)
            if Missile.Name == CresMissileName and Missile.Team == myHero.Team then
                return true
            end
        end
        return false
    end,
    GetApheliosSniperTarget = function(self) --aphelioscalibrumbonusrangedebuff
        local Heros = self:SortList(ObjectManager.HeroList, "LOWHP")
        for _, Hero in pairs(Heros) do
            --Hero.BuffData:ShowAllBuffs()
            if Hero.Team ~= myHero.Team and Hero.IsTargetable == true then
                local RangedBuff = Hero.BuffData:GetBuff("aphelioscalibrumbonusrangedebuff")
                local RangedBuffValid = RangedBuff.Valid or RangedBuff.Count_Alt > 0
                if RangedBuffValid then 
                    local Missiles = Orbwalker:GetAllAllyMissiles()
                    for _, Missile in pairs(Missiles) do
                        local SourceID = Missile.SourceIndex
                        local TargetID = Missile.TargetIndex
                        if SourceID == myHero.Index and TargetID == Hero.Index then
                            return nil
                        end
                    end
                    if self:CresOnWayCheck() == true then return nil end
                    if self:GetDistance(Hero.Position, myHero.Position) <= 1800 then --CaitlynEMissile --eternals_caitlyneheadshottracker
                        --print(self:CheckBuffCount(Hero))
                        return Hero
                    end
                end
            end
        end
        return nil    
    end,
    GetTristanaBombTarget = function(self)
        local Heros = self:SortList(ObjectManager.HeroList, "LOWHP")
        for _, Hero in pairs(Heros) do
            if Hero.Team ~= myHero.Team and Hero.IsTargetable == true then
                if self:GetDistance(Hero.Position, myHero.Position) <= self.OrbRange then
                    if Hero.BuffData:GetBuff("tristanaecharge").Count_Alt > 0 then
                        return Hero
                    end
                end
            end
        end
        return nil    
    end,
    GetTeamHasGP = function(self)
        if self.TeamHasGP == nil then
            local Allys = self:GetAllAllyHeros()
            for _, Ally in pairs(Allys) do
                if Ally.ChampionName == "Gangplank" then self.TeamHasGP = true return end
            end
            self.TeamHasGP = false
        end
    end,
    GetAttackRange = function(self)
        if myHero.ChampionName == "Zeri" or myHero.ChampionName == "Sion" or myHero.ChampionName == "Annie" then
            if myHero.ChampionName == "Zeri" then
                local passive = myHero.BuffData:GetBuff("zeriqpassiveready")
                if passive.Valid then
                    self.OrbRange = myHero.AttackRange + myHero.CharData.BoundingRadius
                else
                    self.OrbRange = (825 - myHero.AttackRange) + myHero.AttackRange + myHero.CharData.BoundingRadius
                end
            end
            if myHero.ChampionName == "Sion" then
                self.OrbRange = 175 + myHero.CharData.BoundingRadius + 20
            end
            if myHero.ChampionName == "Annie" then
                self.OrbRange = myHero.AttackRange + myHero.CharData.BoundingRadius - 75
            end
        else
            if self.ForceTarget == nil then
                -- added - 33, 1/3 of teemo size. to counter sticky movement when enemy outside of AA range already. might need more if more cases are reported
                self.OrbRange = myHero.AttackRange + myHero.CharData.BoundingRadius - 33
            else
                self.OrbRange = myHero.AttackRange + myHero.CharData.BoundingRadius +55
            end
        end
        local LethalTempo		= myHero.BuffData:GetBuff("ASSETS/Perks/Styles/Precision/LethalTempo/LethalTempo.lua")
        local Stacks			= LethalTempo.Count_Int
        if self.OrbRange >= 300 then
            if Stacks >= 6 then
                self.OrbRange = self.OrbRange + 50
            end
        else
            if Stacks >= 6 then
                self.OrbRange = self.OrbRange + 50
            end
        end
    end,
    OnTick = function(self)
        --myHero.BuffData:ShowAllBuffs()
        -- local test = myHero.BuffData:GetBuff("zhonyasringshield")
        -- print(test.Count_Alt)

        self.DrawTarget = nil
        self:GetTeamHasGP()
        self:GetForceTarget()
        self:GetChampionPrios()
        self:ManageAttackTimer()
        if GameHud.Minimized == false and GameHud.ChatOpen == false and self.Enabled == 1 then
            self:GetAttackRange()
            if Engine:IsKeyDown("HK_FLEE") then
                if Engine:IsKeyDown("HK_ITEM6") then
                    self:Safe_Flash()
                end
                if self:CanMove() then
                    return self:IssueMove(self.MovePosition)    
                end                
            end
            if Engine:IsKeyDown("HK_COMBO") then
                if Engine:IsKeyDown("HK_ITEM6") then
                    self:Safe_Flash()
                end
                local Target = nil
                if myHero.ChampionName == "Caitlyn" then
                    self.count = 1
                    local Missiles = Orbwalker:GetAllAllyMissiles()
                    for _, Missile in pairs(Missiles) do
                        local SourceID = Missile.SourceIndex
                        if SourceID == myHero.Index and Missile.Name == "CaitlynPassiveMissile" then
                            --print(Missile.Name)
                            if ((os.clock() - self.CaitHSTimer) > 0.5 or (os.clock() - self.CaitHSTimer) < 0) then
                                self.CaitHSTimer 	= os.clock()
                                table.insert(self.CaitHSCounts, self.count)
                            end
                        end
                    end
                    if (os.clock() - self.CaitHSTimer) > 2 then
                        table.remove(self.CaitHSCounts, self.count)
                    end
                    Target = self:GetCaitlynHeadshotTarget()
                end
                if myHero.ChampionName == "Aphelios" then
                    Target = self:GetApheliosSniperTarget()
                end
                if myHero.ChampionName == "Tristana" then
                    Target = self:GetTristanaBombTarget()
                end
                if Target == nil then
                    Target = self:GetTarget("COMBO", self.OrbRange)
                end
                
                return self:Orbwalk(Target)
            end   
            if Engine:IsKeyDown("HK_HARASS") then
                if Engine:IsKeyDown("HK_ITEM6") then
                    self:Safe_Flash()
                end
                local Target = nil
                if myHero.ChampionName == "Caitlyn" then
                    Target = self:GetCaitlynHeadshotTarget()
                end
                if myHero.ChampionName == "Aphelios" then
                    Target = self:GetApheliosSniperTarget()
                end
                if myHero.ChampionName == "Tristana" then
                    Target = self:GetTristanaBombTarget()
                end
                if Target == nil then
                    Target = self:GetTarget("HARASS", self.OrbRange)
                end
                return self:Orbwalk(Target)            
            end   
            if Engine:IsKeyDown("HK_LASTHIT") then
                if Engine:IsKeyDown("HK_ITEM6") then
                    self:Safe_Flash()
                end
                return self:Orbwalk(self:GetTarget("LASTHIT", self.OrbRange))           
            end   
            if Engine:IsKeyDown("HK_LANECLEAR") then
                if Engine:IsKeyDown("HK_ITEM6") then
                    self:Safe_Flash()
                end
                return self:Orbwalk(self:GetTarget("LANECLEAR", self.OrbRange))           
            end
            if Engine:IsKeyDown("HK_ITEM6") then
                self:Safe_Flash()
            end
        end

        self.BlockAttack  = 0
        -- self.MovePosition = nil
    end,
    OnDraw = function(self)
        -- local Turrets = ObjectManager.TurretList
        -- for _, T in pairs(Turrets) do
        --     print(T:GetTypeFlag())
        -- end

        -- Render:DrawCircle(myHero.Position, 10, 0,255,0,255)

        -- local TroyList = ObjectManager.TroyList
        -- for _ , Troy in pairs(TroyList) do
        --     local vecOut = Vector3.new()
        --     if Render:World2Screen(Troy.Position, vecOut) then
        --         print(Troy.Name)
        --         Render:DrawString(Troy.Name, vecOut.x , vecOut.y , 255, 0, 0, 255)
        --         Render:DrawString(Troy.Index, vecOut.x , vecOut.y+20 , 0, 255, 0, 255)
        --         Render:DrawCircle(Troy.Position, 20, 0,255,0,255)
        --     end
        -- end
        self:GetAttackRange()
        if self.DrawTarget ~= nil and self.DrawTargetCircle.Value == 1 then
            --print(self.DrawTarget.Name)
            local Bound = self.DrawTarget.CharData.BoundingRadius
            if self.DrawTarget.IsInhib then
                Bound = 200
            end
            if self.DrawTarget.IsNexus then
                Bound = 300
            end
            Render:DrawCircle(self.DrawTarget.Position, Bound, 0,255,0,255)
        end
        if self.ForceTarget ~= nil and self.ForceTarget.IsHero then
            local vecOut = Vector3.new()
            if Render:World2Screen(myHero.Position, vecOut) then
                Render:DrawString("ForceTarget: " .. self.ForceTarget.ChampionName, vecOut.x - 100 , vecOut.y + 50, 255, 0, 0, 255)
            end
            if self.ForceTarget.IsTargetable then       
                Render:DrawCircle(self.ForceTarget.Position, self.ForceTarget.CharData.BoundingRadius, 255,255,100,255)
            end
        end
        if self.PlayerRange.Value == 1 then
            Render:DrawCircle(myHero.Position, self.OrbRange, 255, 255, 255, 255)
        end
        if self.EnemyRange.Value == 1 then
            local Heros = ObjectManager.HeroList
            for I, Hero in pairs(Heros) do
                if Hero.Team ~= myHero.Team then
                    if Hero.IsTargetable then
                        Render:DrawCircle(Hero.Position, Hero.CharData.BoundingRadius + Hero.AttackRange, 255,0,0,255)
                    end
                end
            end    
        end
    end,
    OnLoad = function(self)
        AddEvent("OnSettingsSave" , function() self:SaveSettings() end)
        AddEvent("OnSettingsLoad" , function() self:LoadSettings() end)
        self:Init()
        AddEvent("OnTick", function() self:OnTick() end)
        AddEvent("OnDraw", function() self:OnDraw() end)
    end,
    --AutoPrios functions
    GetChampionPrios = function(self)
        for _,Hero in pairs(ObjectManager.HeroList) do 
            if Hero.Team ~= myHero.Team and string.len(Hero.ChampionName) > 1 then
                if self.Prio[Hero.Index] == nil then
                    local Prio = self:GetHeroPrio(Hero.ChampionName)
                    if Prio and self.UsePrioList.Value == 1 then
                        self.Prio[Hero.Index] = self.GenericMenu:AddSlider(Hero.ChampionName, Prio,1,5,1)
                    else
                        self.Prio[Hero.Index] = self.GenericMenu:AddSlider(Hero.ChampionName, 1,1,5,1)
                    end
                end
            end
        end
    end,
    GetRolePrio = function(self, Role)
        if Role == "ADC"        then return 5 end
        if Role == "AP"         then return 4 end
        if Role == "MidAD"      then return 5 end
        if Role == "Support"    then return 3 end
        if Role == "Bruiser"    then return 2 end
        if Role == "Tank"       then return 1 end
        if Role == "FuckMeUpFam"then return 5 end
    end,   
    GetHeroPrio = function(self, Name)
        if Name == "Aatrox" then return        self:GetRolePrio("Bruiser") end
        if Name == "Ahri" then return          self:GetRolePrio("AP") end
        if Name == "Akali" then return         self:GetRolePrio("AP") end
        if Name == "Alistar" then return       self:GetRolePrio("Tank") end
        if Name == "Amumu" then return         self:GetRolePrio("Tank") end
        if Name == "Anivia" then return        self:GetRolePrio("AP") end
        if Name == "Annie" then return         self:GetRolePrio("AP") end
        if Name == "Aphelios" then return      self:GetRolePrio("ADC") end
        if Name == "Ashe" then return          self:GetRolePrio("ADC") end
        if Name == "AurelionSol" then return   self:GetRolePrio("AP") end
        if Name == "Azir" then return          self:GetRolePrio("AP") end
        if Name == "Bard" then return          self:GetRolePrio("Tank") end
        if Name == "Blitzcrank" then return    self:GetRolePrio("Tank") end
        if Name == "Brand" then return         self:GetRolePrio("AP") end
        if Name == "Braum" then return         self:GetRolePrio("Tank") end
        if Name == "Caitlyn" then return       self:GetRolePrio("ADC") end
        if Name == "Camille" then return       self:GetRolePrio("Tank") end
        if Name == "Cassiopeia" then return    self:GetRolePrio("AP") end
        if Name == "Chogath" then return       self:GetRolePrio("Tank") end
        if Name == "Corki" then return         self:GetRolePrio("ADC") end
        if Name == "Darius" then return        self:GetRolePrio("Tank") end
        if Name == "Diana" then return         self:GetRolePrio("AP") end
        if Name == "DrMundo" then return       self:GetRolePrio("Tank") end
        if Name == "Draven" then return        self:GetRolePrio("ADC") end
        if Name == "Ekko" then return          self:GetRolePrio("AP") end
        if Name == "Elise" then return         self:GetRolePrio("Bruiser") end
        if Name == "Evelynn" then return       self:GetRolePrio("AP") end
        if Name == "Ezreal" then return        self:GetRolePrio("ADC") end
        if Name == "FiddleSticks" then return  self:GetRolePrio("AP") end
        if Name == "Fiora" then return         self:GetRolePrio("Bruiser") end
        if Name == "Fizz" then return          self:GetRolePrio("AP") end
        if Name == "Galio" then return         self:GetRolePrio("Tank") end
        if Name == "Gangplank" then return     self:GetRolePrio("Bruiser") end
        if Name == "Garen" then return         self:GetRolePrio("Tank") end
        if Name == "Gnar" then return          self:GetRolePrio("Tank") end
        if Name == "Gragas" then return        self:GetRolePrio("AP") end
        if Name == "Graves" then return        self:GetRolePrio("ADC") end
        if Name == "Hecarim" then return       self:GetRolePrio("Tank") end
        if Name == "Heimerdinger" then return  self:GetRolePrio("AP") end
        if Name == "Illaoi" then return        self:GetRolePrio("Tank") end
        if Name == "Irelia" then return        self:GetRolePrio("Bruiser") end
        if Name == "Ivern" then return         self:GetRolePrio("Bruiser") end
        if Name == "Janna" then return         self:GetRolePrio("Support") end
        if Name == "JarvanIV" then return      self:GetRolePrio("Tank") end
        if Name == "Jax" then return           self:GetRolePrio("Bruiser") end
        if Name == "Jayce" then return         self:GetRolePrio("MidAD") end
        if Name == "Jhin" then return          self:GetRolePrio("ADC") end
        if Name == "Jinx" then return          self:GetRolePrio("ADC") end
        if Name == "Kaisa" then return         self:GetRolePrio("ADC") end
        if Name == "Kalista" then return       self:GetRolePrio("ADC") end
        if Name == "Karma" then return         self:GetRolePrio("Support") end
        if Name == "Karthus" then return       self:GetRolePrio("AP") end
        if Name == "Kassadin" then return      self:GetRolePrio("AP") end
        if Name == "Katarina" then return      self:GetRolePrio("AP") end
        if Name == "Kayle" then return         self:GetRolePrio("AP") end
        if Name == "Kayn" then return          self:GetRolePrio("Bruiser") end
        if Name == "Kindred" then return       self:GetRolePrio("ADC") end
        if Name == "Kennen" then return        self:GetRolePrio("AP") end
        if Name == "Khazix" then return        self:GetRolePrio("Bruiser") end
        if Name == "Kled" then return          self:GetRolePrio("Bruiser") end
        if Name == "KogMaw" then return        self:GetRolePrio("ADC") end
        if Name == "Leblanc" then return       self:GetRolePrio("AP") end
        if Name == "LeeSin" then return        self:GetRolePrio("Bruiser") end
        if Name == "Leona" then return         self:GetRolePrio("Tank") end
        if Name == "Lissandra" then return     self:GetRolePrio("AP") end
        if Name == "Lucian" then return        self:GetRolePrio("ADC") end
        if Name == "Lulu" then return          self:GetRolePrio("Support") end
        if Name == "Lux" then return           self:GetRolePrio("AP") end
        if Name == "Malphite" then return      self:GetRolePrio("Tank") end
        if Name == "Malzahar" then return      self:GetRolePrio("AP") end
        if Name == "Maokai" then return        self:GetRolePrio("Tank") end
        if Name == "MasterYi" then return      self:GetRolePrio("Bruiser") end
        if Name == "MissFortune" then return   self:GetRolePrio("ADC") end
        if Name == "MonkeyKing" then return    self:GetRolePrio("Bruiser") end
        if Name == "Mordekaiser" then return   self:GetRolePrio("AP") end
        if Name == "Morgana" then return       self:GetRolePrio("AP") end
        if Name == "Nami" then return          self:GetRolePrio("Support") end
        if Name == "Nasus" then return         self:GetRolePrio("Tank") end
        if Name == "Nautilus" then return      self:GetRolePrio("Tank") end
        if Name == "Neeko" then return         self:GetRolePrio("AP") end
        if Name == "Nidalee" then return       self:GetRolePrio("AP") end
        if Name == "Nocturne" then return      self:GetRolePrio("Bruiser") end
        if Name == "Nunu" then return          self:GetRolePrio("Tank") end
        if Name == "Olaf" then return          self:GetRolePrio("Bruiser") end
        if Name == "Orianna" then return       self:GetRolePrio("AP") end
        if Name == "Ornn" then return          self:GetRolePrio("Tank") end
        if Name == "Pantheon" then return      self:GetRolePrio("Bruiser") end
        if Name == "Poppy" then return         self:GetRolePrio("Bruiser") end
        if Name == "Pyke" then return          self:GetRolePrio("MidAD") end
        if Name == "Qiyana" then return        self:GetRolePrio("Bruiser") end
        if Name == "Quinn" then return         self:GetRolePrio("ADC") end
        if Name == "Rakan" then return         self:GetRolePrio("Tank") end
        if Name == "Rammus" then return        self:GetRolePrio("Tank") end
        if Name == "RekSai" then return        self:GetRolePrio("AP") end
        if Name == "Renekton" then return      self:GetRolePrio("Tank") end
        if Name == "Rengar" then return        self:GetRolePrio("Bruiser") end
        if Name == "Riven" then return         self:GetRolePrio("Bruiser") end
        if Name == "Rumble" then return        self:GetRolePrio("Bruiser") end
        if Name == "Ryze" then return          self:GetRolePrio("AP") end
        if Name == "Samira" then return        self:GetRolePrio("ADC") end
        if Name == "Sejuani" then return       self:GetRolePrio("Tank") end
        if Name == "Senna" then return         self:GetRolePrio("ADC") end
        if Name == "Seraphine" then return     self:GetRolePrio("AP") end
        if Name == "Sett" then return          self:GetRolePrio("Bruiser") end
        if Name == "Shaco" then return         self:GetRolePrio("AP") end
        if Name == "Shen" then return          self:GetRolePrio("Tank") end
        if Name == "Shyvana" then return       self:GetRolePrio("Tank") end
        if Name == "Singed" then return        self:GetRolePrio("Tank") end
        if Name == "Sion" then return          self:GetRolePrio("AP") end
        if Name == "Sivir" then return         self:GetRolePrio("ADC") end
        if Name == "Skarner" then return       self:GetRolePrio("Tank") end
        if Name == "Sona" then return          self:GetRolePrio("Support") end
        if Name == "Soraka" then return        self:GetRolePrio("FuckMeUpFam") end
        if Name == "Swain" then return         self:GetRolePrio("AP") end
        if Name == "Sylas" then return         self:GetRolePrio("AP") end
        if Name == "Syndra" then return        self:GetRolePrio("AP") end
        if Name == "TahmKench" then return     self:GetRolePrio("Tank") end
        if Name == "Taliyah" then return       self:GetRolePrio("AP") end
        if Name == "Talon" then return         self:GetRolePrio("MidAD") end
        if Name == "Taric" then return         self:GetRolePrio("Tank") end
        if Name == "Teemo" then return         self:GetRolePrio("AP") end
        if Name == "Thresh" then return        self:GetRolePrio("Tank") end
        if Name == "Tristana" then return      self:GetRolePrio("ADC") end
        if Name == "Trundle" then return       self:GetRolePrio("Tank") end
        if Name == "Tryndamere" then return    self:GetRolePrio("Bruiser") end
        if Name == "TwistedFate" then return   self:GetRolePrio("AP") end
        if Name == "Twitch" then return        self:GetRolePrio("ADC") end
        if Name == "Udyr" then return          self:GetRolePrio("Tank") end
        if Name == "Urgot" then return         self:GetRolePrio("ADC") end
        if Name == "Varus" then return         self:GetRolePrio("ADC") end
        if Name == "Vayne" then return         self:GetRolePrio("ADC") end
        if Name == "Veigar" then return        self:GetRolePrio("AP") end
        if Name == "Velkoz" then return        self:GetRolePrio("AP") end
        if Name == "Vi" then return            self:GetRolePrio("Bruiser") end
        if Name == "Viego" then return         self:GetRolePrio("MidAD") end
        if Name == "Viktor" then return        self:GetRolePrio("AP") end
        if Name == "Vladimir" then return      self:GetRolePrio("AP") end
        if Name == "Volibear" then return      self:GetRolePrio("Tank") end
        if Name == "Warwick" then return       self:GetRolePrio("Tank") end
        if Name == "Xerath" then return        self:GetRolePrio("AP") end
        if Name == "Xayah" then return         self:GetRolePrio("ADC") end
        if Name == "XinZhao" then return       self:GetRolePrio("Bruiser") end
        if Name == "Yasuo" then return         self:GetRolePrio("MidAD") end
        if Name == "Yorick" then return        self:GetRolePrio("Tank") end
        if Name == "Yuumi" then return         self:GetRolePrio("Support") end
        if Name == "Zac" then return           self:GetRolePrio("Tank") end
        if Name == "Zed" then return           self:GetRolePrio("MidAD") end
        if Name == "Ziggs" then return         self:GetRolePrio("AP") end
        if Name == "Zilean" then return        self:GetRolePrio("Support") end
        if Name == "Zoe" then return           self:GetRolePrio("AP") end
        if Name == "Zyra" then return          self:GetRolePrio("AP") end
    end,
}

AddEvent("OnLoad", function() Orbwalker:OnLoad() end)