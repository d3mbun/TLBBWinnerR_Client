local Compose_NEW_Type = -1;

local Compose_NEW_Index1 = -1
local Compose_NEW_Index2 = -1
local Compose_NEW_Index3 = -1
local Compose_NEW_Index4 = -1
local Compose_NEW_Index5 = -1

local Compose_NEW_SpecialIndex = -1

local Compose_NEW_GemLevel = -1

function Compose_NEW_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end


function Compose_NEW_OnLoad()
	-- Compose_NEW_OK:Disable()
end


function Compose_NEW_OnEvent( event )
	if event == "UI_COMMAND" and tonumber(arg0) == 1019001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		
		Compose_NEW_Type = Get_XParam_INT(0)
		
		Compose_NEW_Update(Compose_NEW_Type)
		this:Show();
	end
	
	if IsWindowShow("Compose_NEW") then
		if event == "UI_COMMAND" and tonumber(arg0) == 10102017 then
			Compose_NEW_Item(tonumber(arg1))
		end
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		Compose_NEW_UpdateUI()
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		Compose_NEW_Close();
		return;
	end
end

function Compose_NEW_Item(pos)
	local Index = EnumAction(pos, "packageitem")
	local ItemID = Index:GetDefineID()
	
	if Compose_NEW_Type == 1 then
		if ItemID >= 50101001 and ItemID <= 50921004 then
			--Is Gem
		elseif ItemID == 30900015 or ItemID == 30900115 then
			if Compose_NEW_Index1 == -1 then
				PushDebugMessage("Ð£t vào bäo thÕch trß¾c.")
				return
			end
			
			if Compose_NEW_GemLevel >= 4 then
				PushDebugMessage("Yêu c¥u Cao C¤p Bäo ThÕch Hþp Thành Phù")
				return
			end
			
			if Compose_NEW_SpecialIndex ~= -1 then
				return
			end
			
			Compose_NEW_SpecialIndex = pos;
			LifeAbility:Lock_Packet_Item( Compose_NEW_SpecialIndex, 1 )
			Compose_NEW_Special_Button:SetActionItem(Index:GetID())
			
			Compose_NEW_UpdateUI()
			return
		elseif ItemID == 30900016 or ItemID == 30900116 then
			if Compose_NEW_Index1 == -1 then
				PushDebugMessage("Ð£t vào bäo thÕch trß¾c.")
				return
			end
			
			--PushDebugMessage(Compose_NEW_GemLevel)
			if Compose_NEW_GemLevel <= 3 then
				PushDebugMessage("Yêu c¥u S½ C¤p Bäo ThÕch Hþp Thành Phù")
				return
			end
			
			if Compose_NEW_SpecialIndex ~= -1 then
				return
			end
			
			Compose_NEW_SpecialIndex = pos;
			LifeAbility:Lock_Packet_Item( Compose_NEW_SpecialIndex, 1 )
			Compose_NEW_Special_Button:SetActionItem(Index:GetID())
			
			Compose_NEW_UpdateUI()
			return
		else
			PushDebugMessage("Chï có th¬ ðßa vào Bäo ThÕch ho£c Hþp Thành Phù")
			return
		end
		
		if Compose_NEW_Index1 == -1 then
			Compose_NEW_Index1 = pos
			LifeAbility:Lock_Packet_Item( Compose_NEW_Index1, 1 )
			
			Compose_NEW_GemLevel = tonumber(string.sub(ItemID,3,3))
			
			Compose_NEW_Space1:SetActionItem(Index:GetID())
		elseif Compose_NEW_Index2 == -1 then
			local Index1 = EnumAction(Compose_NEW_Index1, "packageitem")
			local Item1ID = Index1:GetDefineID()
			
			if ItemID ~= Item1ID then
				PushDebugMessage("Chï có th¬ hþp thành cùng loÕi bäo thÕch!")
				return
			end
			Compose_NEW_Index2 = pos
			LifeAbility:Lock_Packet_Item( Compose_NEW_Index2, 1 )
			Compose_NEW_Space2:SetActionItem(Index:GetID())
		elseif Compose_NEW_Index3 == -1 then
			local Index1 = EnumAction(Compose_NEW_Index1, "packageitem")
			local Item1ID = Index1:GetDefineID()
			
			if ItemID ~= Item1ID then
				PushDebugMessage("Chï có th¬ hþp thành cùng loÕi bäo thÕch!")
				return
			end
			Compose_NEW_Index3 = pos
			LifeAbility:Lock_Packet_Item( Compose_NEW_Index3, 1 )
			Compose_NEW_Space3:SetActionItem(Index:GetID())
		elseif Compose_NEW_Index4 == -1 then
			local Index1 = EnumAction(Compose_NEW_Index1, "packageitem")
			local Item1ID = Index1:GetDefineID()
			
			if ItemID ~= Item1ID then
				PushDebugMessage("Chï có th¬ hþp thành cùng loÕi bäo thÕch!")
				return
			end
			Compose_NEW_Index4 = pos
			LifeAbility:Lock_Packet_Item( Compose_NEW_Index4, 1 )
			Compose_NEW_Space4:SetActionItem(Index:GetID())
		elseif Compose_NEW_Index5 == -1 then
			local Index1 = EnumAction(Compose_NEW_Index1, "packageitem")
			local Item1ID = Index1:GetDefineID()
			
			if ItemID ~= Item1ID then
				PushDebugMessage("Chï có th¬ hþp thành cùng loÕi bäo thÕch!")
				return
			end
			
			Compose_NEW_Index5 = pos			
			LifeAbility:Lock_Packet_Item( Compose_NEW_Index5, 1 )
			Compose_NEW_Space5:SetActionItem(Index:GetID())
		end
		
		Compose_NEW_UpdateUI()
	elseif Compose_NEW_Type == 2 then
		-- if ItemID >= 20400300 and ItemID <= 20502008 then
		
		-- end
	end
end

function Compose_NEW_Update(type)
	Compose_NEW_UpdateUI()
	
	if type == 1 then
		Compose_NEW_DragTitle:SetText("#YHþp Thành Bäo ThÕch")
		Compose_NEW_Info:SetText("Hþp thành bäo thÕch có th¬ làm cho nhæng bäo thÕch s½ c¤p hþp thành sang bäo thÕch cao c¤p.")
		
		Compose_NEW_Static1:SetText("Ð£t vào Bäo ThÕch")
		Compose_NEW_Special:Show()
	elseif type == 2 then
		Compose_NEW_DragTitle:SetText("#YHþp Thành Nguyên Li®u")
		Compose_NEW_Info:SetText("Hþp thành nguyên li®u có th¬ dùng Väi Bông, Bí Ngân, Tinh Thiªt ð¬ tiªn hành thång c¤p h½p thành.")

		Compose_NEW_Static1:SetText("Ð£t vào Nguyên Li®u")
		
		Compose_NEW_Special:Hide()
	elseif type == 3 then
		-- Compose_NEW_DragTitle:SetText("")
		-- Compose_NEW_Static1:SetText("Ð£t vào Nguyên Li®u")
		
		
		-- Compose_NEW_Special:Hide()
	end
end

function Compose_NEW_UpdateUI()
	local luckyvalue = 0;
	if Compose_NEW_SpecialIndex == -1 then
		luckyvalue = 0;
	else
		if Compose_NEW_Index1 == -1 or Compose_NEW_Index2 == -1 or Compose_NEW_Index3 == -1 then
			luckyvalue = 0;
		elseif Compose_NEW_Index4 == -1 and Compose_NEW_Index5 == -1 then
			luckyvalue = 50;
		elseif Compose_NEW_Index5 == -1 then
			luckyvalue = 75;
		else
			luckyvalue = 100;
		end
	end
	
	local str = ""
	if luckyvalue == 100 then
		str = "#GTï l® thành công: "..luckyvalue.."%"
	else
		str = "#cFF0000Tï l® thành công: "..luckyvalue.."%"
	end
	Compose_NEW_SuccessValue:SetText(str)
	
	local MoneyNeed = Compose_NEW_GemLevel*10000;
	if Compose_NEW_GemLevel == -1 then
		MoneyNeed = 0;
	end
	Compose_NEW_UpdateMoney(MoneyNeed)

	if luckyvalue >= 50 then
		Compose_NEW_OK:Enable()
	else
		Compose_NEW_OK:Disable()
	end
end

function Compose_NEW_UpdateMoney(costvalue)
	if costvalue ~= -1 then
		Compose_NEW_NeedMoney:SetProperty("MoneyNumber", tostring(costvalue))
	end
	
	local Money = Player:GetData("MONEY")
	local MoneyJZ = Player:GetData("MONEY_JZ")
	
	Compose_NEW_SelfJiaozi:SetProperty("MoneyNumber", tostring(MoneyJZ))
	Compose_NEW_SelfMoney:SetProperty("MoneyNumber", tostring(Money))
end

function Compose_NEW_OK_Clicked()
	local Money = Player:GetData("MONEY")
	local MoneyJZ = Player:GetData("MONEY_JZ")
	local MoneyNeed = Compose_NEW_GemLevel*10000;
	
	if MoneyNeed > Money + MoneyJZ then
		PushDebugMessage("Không ðü ngân lßþng.")
		return
	end
	
	if Compose_NEW_Index1 == -1 or Compose_NEW_Index2 == -1 or Compose_NEW_Index3 == -1 or Compose_NEW_SpecialIndex == -1 then
		PushDebugMessage("Không ðü Bäo ThÕch ho£c Hþp Thành Phù")
		return
	end

	local Compose_Param12 = 10000
	local Compose_Param34 = 10000
	local Compose_Param56 = 10000
	
	if Compose_NEW_Index1 >= 30 and Compose_NEW_Index1 <= 59 then
		Compose_Param12 = Compose_Param12 + Compose_NEW_Index1*100;
	end
	if Compose_NEW_Index2 >= 30 and Compose_NEW_Index2 <= 59 then
		Compose_Param12 = Compose_Param12 + Compose_NEW_Index2;
	end
	
	if Compose_NEW_Index3 >= 30 and Compose_NEW_Index3 <= 59 then
		Compose_Param34 = Compose_Param34 + Compose_NEW_Index3*100;
	end
	if Compose_NEW_Index4 >= 30 and Compose_NEW_Index4 <= 59 then
		Compose_Param34 = Compose_Param34 + Compose_NEW_Index4;
	end
	
	if Compose_NEW_Index5 >= 30 and Compose_NEW_Index5 <= 59 then
		Compose_Param56 = Compose_Param56 + Compose_NEW_Index5*100;
	end
	Compose_Param56 = Compose_Param56 + Compose_NEW_SpecialIndex;
	
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnCreateItem")
		Set_XSCRIPT_ScriptID(045050)
		Set_XSCRIPT_Parameter(0, 500) --type
		Set_XSCRIPT_Parameter(1, Compose_NEW_Type) --Type Compose
		Set_XSCRIPT_Parameter(2, Compose_Param12) --Pos Gem1 + Gem2
		Set_XSCRIPT_Parameter(3, Compose_Param34) --Pos Gem3 + Gem4
		Set_XSCRIPT_Parameter(4, Compose_Param56) --Pos Gem5 + HTP
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	
	Compose_NEW_Clear()
end


function Compose_NEW_Close()
	this:Hide()
	Compose_NEW_Clear()
end

function Compose_NEW_Clear()
	LifeAbility:Lock_Packet_Item( Compose_NEW_Index1, 0 )
	LifeAbility:Lock_Packet_Item( Compose_NEW_Index2, 0 )
	LifeAbility:Lock_Packet_Item( Compose_NEW_Index3, 0 )
	LifeAbility:Lock_Packet_Item( Compose_NEW_Index4, 0 )
	LifeAbility:Lock_Packet_Item( Compose_NEW_Index5, 0 )
	LifeAbility:Lock_Packet_Item( Compose_NEW_SpecialIndex, 0 )
	
	Compose_NEW_Space1:SetActionItem(-1)
	Compose_NEW_Space2:SetActionItem(-1)
	Compose_NEW_Space3:SetActionItem(-1)
	Compose_NEW_Space4:SetActionItem(-1)
	Compose_NEW_Space5:SetActionItem(-1)
	Compose_NEW_Special_Button:SetActionItem(-1)
	
	Compose_NEW_Index1 = -1;
	Compose_NEW_Index2 = -1;
	Compose_NEW_Index3 = -1;
	Compose_NEW_Index4 = -1;
	Compose_NEW_Index5 = -1;
	Compose_NEW_SpecialIndex = -1
	
	Compose_NEW_GemLevel = -1;
	
	Compose_NEW_NeedMoney:SetProperty("MoneyNumber", 0)
	Compose_NEW_SuccessValue:SetText("#cFF0000Tï l® thành công: 0%")
	Compose_NEW_OK:Disable()
end
