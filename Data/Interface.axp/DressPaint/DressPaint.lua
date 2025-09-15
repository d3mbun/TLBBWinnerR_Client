local MAX_OBJ_DISTANCE = 3.0
local DRESS_POS = -1
local TypeUI = -1
local g_NeedMoney = 50000
local g_ObjCared = -1

--PreLoad
function DressPaint_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_DRESS_PAINT")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("DISABLE_DRESS_PAINT_TRACING")
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("PROGRESSBAR_SHOW")
	this:RegisterEvent( "NEW_DEBUGMESSAGE" )
	this:RegisterEvent( "RESUME_ENCHASE_GEM" )
end

--OnLoad
function DressPaint_OnLoad()

end

--OnEvent
function DressPaint_OnEvent(event)
	
	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 0910281 then
		local targetId = Get_XParam_INT(0)
		TypeUI = Get_XParam_INT(1)
		ObjCaredID = DataPool : GetNPCIDByServerID( targetId )
		if ObjCaredID == -1 then
			return
		end
		DressPaint_Clear()
		DressPaint_OK:Disable()
		--DressPaint_Show:Disable()		
		this:Show()
		
		-- ¹Ø±ÕÊÔÒÂ¼ä
		if (IsWindowShow("DressPaint_Fitting")) then
			DressReplaceColor:RestoreDressPaintFitting()
			CloseWindow("DressPaint_Fitting", true)
		end
		
		local xx = Get_XParam_INT(0);
		local objCared = DataPool:GetNPCIDByServerID(xx);

		BeginCareObject_DressPaint(objCared)
		
		DressPaint_DemandMoney:SetProperty("MoneyNumber", 0)
		local playerMoney = Player:GetData("MONEY")
		DressPaint_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		local playerJZ = Player:GetData("MONEY_JZ")
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
	
		if TypeUI == 0 then
			DressPaint_Title:SetText("#gFF0FA0Gia hÕn th¶i trang")
			DressPaint_Info:SetText("#cfff263 M²i l¥n gia hÕn th¶i trang c¥n tiêu hao 1 Kim Ngân Hoa. Sau khi gia hÕn, tính ch¤t th¶i trang s¨ ðßþc giæ nguyên, s¯ ngày sØ døng s¨ ðßþc phøc h°i t¯i ða.")
			DressPaint_Info2:SetText("#cfff263Nh§p vào th¶i trang c¥n gia hÕn:")
		elseif TypeUI == 1 then
			DressPaint_Title:SetText("#{SZPR_XML_13}")
			DressPaint_Info:SetText("#{SZPR_XML_14}")
			DressPaint_Info2:SetText("#{SZPR_XML_15}")
		end

	-- È¾É«³É¹¦£¬ÆôÓÃ¡°È¾É«×·×Ù¡±°´Å¥	
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 091109 then		
		if this:IsVisible() then
			--DressPaint_Show:Enable()
		end
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 10102017 then 
		if IsWindowShow("DressPaint") then
			if arg0 ~= nil and arg1 ~= nil then
				DressPaint_Update(tonumber(arg1),1)
			end
		end
	-- È¾É«×·×Ù½çÃæÒÑ´ò¿ª£¬½ûÓÃ¡°È¾É«×·×Ù¡±°´Å¥	
	elseif event == "DISABLE_DRESS_PAINT_TRACING" then		
		if this:IsVisible() then
			--DressPaint_Show:Disable()
		end

	elseif event ==	"UPDATE_DRESS_PAINT" then
		if arg0~= nil and arg1 ~= nil then
			DressPaint_Update(tonumber(arg0), tonumber(arg1))
		end

	elseif event == "OBJECT_CARED_EVENT" then
		if(arg0 ~= nil and tonumber(arg0) ~= objCared) then
			return;
		end		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then		
			--È¡Ïû¹ØÐÄ
			this:Hide()
		end	

	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then		
		if(arg0~=nil and tonumber(arg0) == 96) then
			DressPaint_Resume_Equip()
		end

	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
				
		if(arg0 ~= nil and -1 == tonumber(arg0)) then
			return;
		end
		
		if (DRESS_POS == tonumber(arg0)) then
			DressPaint_Update(tonumber(arg0), 1)
		end

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		DressPaint_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));	
	elseif (event == "OPEN_STALL_SALE" and this:IsVisible()) then
		--ºÍ°ÚÌ¯½çÃæ»¥³â
		this:Hide()
		
	elseif (event == "PROGRESSBAR_SHOW" and this:IsVisible())	then
		--ºÍ½ø¶ÈÌõ»¥³â
		this:Hide()
		
	end

end

function DressPaint_Update(Pos, isEquip)
	--DressPaint_Clear()

	if isEquip == 1 then 
		local theAction = EnumAction(Pos, "packageitem")
		if theAction:GetID() ~= 0 then

			--if PlayerPackage:IsLock(Pos) == 1 then   --tt60972 ²ß»®¸ÄÉè¼Æ£¬¼ÓËøÊ±×°Ò²ÄÜÈ¾É«
				--PushDebugMessage("#{SZPR_091023_16}")
				--DressPaint_Clear()
				--return
			--end

			local EquipPoint = LifeAbility:Get_Equip_Point(Pos)
			if EquipPoint ~= 16 then
				PushDebugMessage("#{SZPR_091023_17}")
				--DressPaint_Clear()
				return
			end

			DressPaint_Clear()
			
			DRESS_POS = Pos;
			LifeAbility:Lock_Packet_Item(DRESS_POS, 1)	
			DressPaint_Object:SetActionItem(theAction:GetID())
			DressPaint_DemandMoney:SetProperty("MoneyNumber", g_NeedMoney)
			--ÆôÓÃÈ·¶¨°´Å¥
			DressPaint_OK:Enable();
			return
		
		else
			--DressPaint_Clear()
			PushDebugMessage("#{SZPR_091023_17}")
			return
		end
	else
		PushDebugMessage("#{SZPR_091023_17}")
		--DressPaint_Clear()
		return
	end
end

function DressPaint_Resume_Equip()	
	DressPaint_Clear()	
end

function DressPaint_Clear()
	if (DRESS_POS ~= -1) then		
		DressPaint_OK:Disable()										-- ½ûÓÃ¡°È·¶¨¡±°´Å¥
		--DressPaint_Show:Disable()									-- ½ûÓÃ¡°È¾É«×·×Ù¡±°´Å¥
		DressPaint_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(DRESS_POS, 0)
		DRESS_POS = -1
		DressPaint_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

function DressPaint_OnHiden()
	StopCareObject_DressPaint(objCared)
	DressPaint_Clear()
	
	-- ¹Ø±ÕÊÔÒÂ¼ä
	if (IsWindowShow("DressPaint_Fitting")) then
		CloseWindow("DressPaint_Fitting", true)
		DressReplaceColor:RestoreDressPaintFitting()		
	end
	this:Hide()
	return
end

------------------------------------------------------
--
--	È·¶¨
--
function DressPaint_OK_Clicked()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_NeedMoney then
		--PushDebugMessage("#{RXZS_090804_11}")
		PushDebugMessage("#{no_money}")
		return
	end

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045001)
	Set_XSCRIPT_Parameter(0, 160)
	Set_XSCRIPT_Parameter(1, DRESS_POS)
	Set_XSCRIPT_Parameter(2, TypeUI)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	
	DressPaint_OnHiden()
end

------------------------------------------------------
--
--	´ò¿ªÊÔÒÂ¼ä
--
function DressPaint_Show_Clicked()
	
	if (IsWindowShow("DressPaint_Fitting")) then
		-- ÏÈÇå¿Õµ±Ç°ÊÔÒÂ¼äµÄÊý¾Ý
		DressReplaceColor:RestoreDressPaintFitting();
	end
	--PushDebugMessage("±äÉí");
	-- ´ò¿ªÊÔÒÂ¼ä£¬ÏÔÊ¾ÊÔÒÂÐ§¹û
	DressReplaceColor:OpenDressPaintFitting( DRESS_POS )

end

------------------------------------------------------
--
--	¹ØÐÄNPC
--
function BeginCareObject_DressPaint(objCaredId)
	g_ObjCared = objCaredId
	this:CareObject(g_ObjCared, 1, "DressPaint")
end


function StopCareObject_DressPaint(objCaredId)
	this:CareObject(g_ObjCared, 0, "DressPaint")
	g_ObjCared = -1
end