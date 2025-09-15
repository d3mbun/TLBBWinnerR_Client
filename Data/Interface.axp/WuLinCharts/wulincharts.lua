--UI COMMAND ID 19824 by hukai 39440~39446

local g_clientNpcId = -1;

local g_MedicineWuLin = -1;	--ºÏ³ÉµÄÁéÊÞµ¤ID
local g_ConsumeMoney = -1;	--ÐèÒªµÄ½ðÇ®
local g_NotifyBind = 1;
local WuLinCharts_BTN = {};

function WuLinCharts_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("WULINCHARTS");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("RESUME_ENCHASE_GEM") --ÖªµÀÎªÊ²Ã´ÒªÕâ¸öÏûÏ¢Âð£¬ÒòÎª´ÓºÏ³É¿òÍÏ¶¯µ½±³°ü¶¼ÊÇ×ßÌØÊâÂß¼­£¬´ÓClientLibµ½GameÀïÃæµÄGxx±àºÅ¶¼ºÜ¶ñÐÄ£¬ö»öº
	
end

function WuLinCharts_OnLoad()
	WuLinCharts_BTN[1] = {WuLinCharts_Space1, -1}; --{¿Ø¼þÃû,ÎïÆ·Ë÷ÒýÖµ}
	WuLinCharts_BTN[2] = {WuLinCharts_Space2, -1};
	WuLinCharts_BTN[3] = {WuLinCharts_Space3, -1};
	WuLinCharts_BTN[4] = {WuLinCharts_Space4, -1};
	WuLinCharts_BTN[5] = {WuLinCharts_Space5, -1};
end

function WuLinCharts_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 19825) then
		if this : IsVisible() then									-- Èç¹û½çÃæ¿ª×Å£¬Ôò²»´¦Àí
			this:Hide()
			return
		end
		WuLinCharts_Clear()
		WuLinCharts_OnShow()
		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("Chßa phát hi®n NPC")
			WuLinCharts_Close()
			return
		end
		this : CareObject( g_clientNpcId, 1, "WuLinCharts" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end
	
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			WuLinCharts_Close()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		WuLinCharts_UpdateGoods(tonumber(arg1))	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuLinCharts_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		WuLinCharts_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then
		--67~71Ö®¼ä
		WuLinCharts_CancelGoods(tonumber(arg0)-66)
	end

end

function WuLinCharts_OnShow()
	WuLinCharts_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuLinCharts_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	this : Show()
end

function WuLinCharts_UpdateGoods( nGoodsIndex)
	if PlayerPackage:IsLock(nGoodsIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	local goodsID = PlayerPackage : GetItemTableIndex( nGoodsIndex )
		if goodsID  < 20310117 or goodsID >20310121 then
		PushDebugMessage("Vui lòng ð£t vào H°n Bång Châu!")
			return
		end
		
		for i = 1, 5 do
			if WuLinCharts_BTN[i][2] == -1 then
				nUIPos = i
				break
			end
		end
		
	
	if nUIPos < 0 or nUIPos > 5 then
		return
	end
	
	
	--ÏÈÈ¡ÏûÇ°Ãæ·ÅÈëµÄÎïÆ·µÄÐ§¹û
	WuLinCharts_CancelGoods(nUIPos)
	--·ÅÈëÐÂÎïÆ·
	g_MedicineWuLin = goodsID
	g_ConsumeMoney = Money
		
	local theAction = EnumAction(nGoodsIndex, "packageitem");
	if theAction:GetID() ~= 0 then
		WuLinCharts_BTN[nUIPos][1]:SetActionItem(theAction:GetID());
	end
	WuLinCharts_BTN[nUIPos][2] = nGoodsIndex;
	LifeAbility : Lock_Packet_Item(nGoodsIndex,1);
	
	--PushDebugMessage("btn "..WuLinCharts_BTN[nUIPos][2])
	
	--ÊÇ·ñ·Å×îºóÒ»¸ö
	for i = 1, 5 do
		if WuLinCharts_BTN[i][2] == -1 then
			return
		end
	end
	
	WuLinCharts_NeedMoney:SetProperty("MoneyNumber", 10000)--ÉèÖÃÐèÒª½ðÇ®¿òÊýÖµ
	WuLinCharts_OK:Enable()
	WuLinCharts_SuccessValue:SetText("#cFF0000TÖ l® thành công 100 ph¥n tråm")
	g_NotifyBind = 1
end

function WuLinCharts_Cancel_Clicked()
	WuLinCharts_Close()
end

function WuLinCharts_CancelGoods(nGoodsIndex)
	if nGoodsIndex >=1 and nGoodsIndex <= 5 then
		WuLinCharts_BTN[nGoodsIndex][1]:SetActionItem(-1) --Çå³ý½çÃæ
		if WuLinCharts_BTN[nGoodsIndex][2] ~= -1 then
			LifeAbility : Lock_Packet_Item(WuLinCharts_BTN[nGoodsIndex][2],0);
		end
		WuLinCharts_BTN[nGoodsIndex][2] = -1							--Çå³ý¶ÔÓ¦ÎïÆ·Ë÷Òý
		
		--ËùÓÐ½çÃæ¶¼Çå³ýÁË£¬ÔòÉèÖÃ°´Å¥²»¿ÉÓÃ
		local isfindempty = 0
		for i = 1, 5 do
			if WuLinCharts_BTN[i][2] == -1 then
				isfindempty = 1
				break
			end
		end
		
		if isfindempty == 1 then
			g_MedicineWuLin = -1;
			g_ConsumeMoney = -1
			WuLinCharts_OK:Disable()
			WuLinCharts_SuccessValue:SetText("không có cách nào hþp thành")
		end
		
	end
end

function WuLinCharts_Clear()
	g_MedicineWuLin = -1;
	g_ConsumeMoney = -1;
	g_NotifyBind = 1;
	
	for i = 1, 5 do
		WuLinCharts_CancelGoods(i)
	end

	--WuLinCharts_OK:Disable()
	WuLinCharts_SelfMoney:SetProperty("MoneyNumber", "")
	WuLinCharts_SelfJiaozi:SetProperty("MoneyNumber", "")
	WuLinCharts_NeedMoney:SetProperty("MoneyNumber", "")
	--WuLinCharts_SuccessValue:SetText("ÎÞ·¨ºÏ³É")
end

function WuLinCharts_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "WuLinCharts")
	g_clientNpcId = -1
	WuLinCharts_Clear()
end

function WuLinCharts_Frame_OnHiden()
	WuLinCharts_Close()
end

function WuLinCharts_OK_Clicked()
		
	--¼ì²âÎïÆ·Ë÷Òý£¬¼ì²â°ó¶¨×´Ì¬
	local bHaveBind = 0
	for i = 1, 5 do
		if WuLinCharts_BTN[i][2] == -1 then
			return
		end
		if GetItemBindStatus( WuLinCharts_BTN[i][2] ) == 1 then
			bHaveBind = 1
		end
	end
	
	--ÊÇ·ñ½ðÇ®×ã¹»
	if Player:GetData("MONEY")+Player:GetData("MONEY_JZ") < 1000 then
		PushDebugMessage("#{JNHC_81015_18}#{_EXCHG1000}")
		return
	end
		
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnWuHun")
		Set_XSCRIPT_ScriptID(809273);
		Set_XSCRIPT_Parameter(0,5)
		for i = 1, 5 do
			Set_XSCRIPT_Parameter(i,WuLinCharts_BTN[i][2]);
		end
		Set_XSCRIPT_ParamCount(6);
	Send_XSCRIPT();
	
	--ºÏ³É½çÃæ²»¹Ø±Õ
	WuLinCharts_Clear()
	WuLinCharts_OnShow()
	
end