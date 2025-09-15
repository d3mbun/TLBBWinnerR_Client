TradeItem_Index = -1;
TradeItem_NeedMoney = 0;

TradeItem_Material = {}
TradeItem_Material[20400300] = {20400301}
TradeItem_Material[20400301] = {20400302}
TradeItem_Material[20400302] = {20400303}
TradeItem_Material[20400303] = {20400304}
TradeItem_Material[20400304] = {20400305}
TradeItem_Material[20400305] = {20400306}
TradeItem_Material[20400306] = {20400307}
TradeItem_Material[20400307] = {20400308}
TradeItem_Material[20401300] = {20401301}
TradeItem_Material[20401301] = {20401302}
TradeItem_Material[20401302] = {20401303}
TradeItem_Material[20401303] = {20401304}
TradeItem_Material[20401304] = {20401305}
TradeItem_Material[20401305] = {20401306}
TradeItem_Material[20401306] = {20401307}
TradeItem_Material[20401307] = {20401308}
TradeItem_Material[20402300] = {20402301}
TradeItem_Material[20402301] = {20402302}
TradeItem_Material[20402302] = {20402303}
TradeItem_Material[20402303] = {20402304}
TradeItem_Material[20402304] = {20402305}
TradeItem_Material[20402305] = {20402306}
TradeItem_Material[20402306] = {20402307}
TradeItem_Material[20402307] = {20402308}
TradeItem_Material[20500000] = {20500001}
TradeItem_Material[20500001] = {20500002}
TradeItem_Material[20500002] = {20500003}
TradeItem_Material[20500003] = {20500004}
TradeItem_Material[20500004] = {20500005}
TradeItem_Material[20500005] = {20500006}
TradeItem_Material[20500006] = {20500007}
TradeItem_Material[20500007] = {20500008}
TradeItem_Material[20501000] = {20501001}
TradeItem_Material[20501001] = {20501002}
TradeItem_Material[20501002] = {20501003}
TradeItem_Material[20501003] = {20501004}
TradeItem_Material[20501004] = {20501005}
TradeItem_Material[20501005] = {20501006}
TradeItem_Material[20501006] = {20501007}
TradeItem_Material[20501007] = {20501008}
TradeItem_Material[20502000] = {20502001}
TradeItem_Material[20502001] = {20502002}
TradeItem_Material[20502002] = {20502003}
TradeItem_Material[20502003] = {20502004}
TradeItem_Material[20502004] = {20502005}
TradeItem_Material[20502005] = {20502006}
TradeItem_Material[20502006] = {20502007}
TradeItem_Material[20502007] = {20502008}

function TradeItem_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function TradeItem_OnLoad()

end

function TradeItem_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 1001001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		TradeItem_Update(-1)
		this:Show();
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 1001009 then
		PushEvent("UPDATE_YUANBAO")
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" or event == "PACKAGE_ITEM_CHANGED" then
		TradeItem_UpdateUI()
	end
	
	if IsWindowShow("TradeItem") then
		if event == "UI_COMMAND" and tonumber(arg0) == 10102017 then
			TradeItem_Update(tonumber(arg1))
		end
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		TradeItem_OnHidden();
		return;
	end
end

function TradeItem_Update(value)
	if value ~= -1 then
		local Index = EnumAction(value, "packageitem")
		local ItemID = Index:GetDefineID()
		
		if ItemID >= 20400300 and ItemID <= 20502008 then
		
		else
			PushDebugMessage("Chï có th¬ ðßa vào Nguyên Li®u")
			return
		end
		
		local MaterialLevel = math.mod(ItemID,10)
		if MaterialLevel >= 8 then
			PushDebugMessage("Nguyên Li®u này không th¬ hþp thành ðÆng c¤p cao h½n.")
			return
		end
		
		TradeItem_NeedMoney = (MaterialLevel+1)*10000;
		
		TradeItem_Object1:SetActionItem(Index:GetID())
		LifeAbility:Lock_Packet_Item( value, 1 )
		TradeItem_Index = value
		
		local Item2ID = TradeItem_Material[ItemID][1];		
		local Index2 = GemMelting:UpdateProductAction(Item2ID);
		TradeItem_Object2:SetActionItem(Index2:GetID())
		
		TradeItem_OK:Enable()
	else
		TradeItem_Clear()
	end
	
	TradeItem_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	TradeItem_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	TradeItem_DemandMoney:SetProperty("MoneyNumber", TradeItem_NeedMoney);
end

function TradeItem_Buttons_Clicked()
	if TradeItem_Index == -1 then
		PushDebugMessage("Vui lòng ð¬ nguyên li®u vào ô bên dß¾i!")
		return
	end
	
	local Money = tostring(Player:GetData("MONEY"))
	local MoneyJZ = tostring(Player:GetData("MONEY_JZ"))
	
	if Money + MoneyJZ < TradeItem_NeedMoney then
		PushDebugMessage("Không ðü ngân lßþng.")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnCreateItem")
		Set_XSCRIPT_ScriptID(045050)
		Set_XSCRIPT_Parameter(0, 2)
		Set_XSCRIPT_Parameter(1, TradeItem_Index)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	TradeItem_UpdateUI()
end

function TradeItem_UpdateUI()
	TradeItem_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	TradeItem_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	
	local Index = EnumAction(TradeItem_Index, "packageitem")
	local ItemID = Index:GetDefineID()
	
	if ItemID == -1 then
		LifeAbility:Lock_Packet_Item( TradeItem_Index, 0 )
		TradeItem_Index = -1
		TradeItem_Object1:SetActionItem(-1)
		TradeItem_Object2:SetActionItem(-1)
		TradeItem_DemandMoney:SetProperty("MoneyNumber", 0);
		TradeItem_OK:Disable()
	end
end

function TradeItem_Help()
	PushDebugMessage("")
end

function TradeItem_Clear()
	LifeAbility:Lock_Packet_Item( TradeItem_Index, 0 )
	TradeItem_Index = -1;
	TradeItem_Object1:SetActionItem(-1)
	TradeItem_Object2:SetActionItem(-1)
	
	TradeItem_OK:Disable()
	TradeItem_DemandMoney:SetProperty("MoneyNumber", 0);
end

function TradeItem_OnHidden()
	TradeItem_Clear()
	
	this:Hide()
end