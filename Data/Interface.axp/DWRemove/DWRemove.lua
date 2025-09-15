
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWRemove_Item = {}
local g_DWRemove_Object = {}
local g_DWRemove_GRID_SKIP = 100	-- G101 -> G102
local g_DWRemove_DemandMoney = 50000

local g_DWRemove_Action_Type = 3
local g_DWRemove_RScript_ID = 809272
local g_DWRemove_RScript_Name = "DoDiaowenAction"

local g_DWRemove_Clicked_Num = 0			-- ÊÇ·ñÒÑ¾­°´¹ıÒ»´Î¡°È·¶¨¡± by lhx tt80366

local g_DWRemove_Frame_UnifiedPosition;

--=========================================================
-- ×¢²á´°¿Ú¹ØĞÄµÄËùÓĞÊÂ¼ş
--=========================================================
function DWRemove_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWRemove")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWRemove_OnLoad()
	DWRemove_OK:Disable()
	g_DWRemove_Item[1] = -1
	g_DWRemove_Item[2] = -1
	g_DWRemove_Object[1] = DWRemove_Object
	g_DWRemove_Object[2] = DWRemove_Object2
	
	g_DWRemove_Frame_UnifiedPosition=DWRemove_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function DWRemove_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 1002001) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ğ«")
			return
		end
		DWRemove_OK:Disable()
		BeginCareObject_DWRemove()
		DWRemove_Clear()
		DWRemove_UpdateBasic()
		this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		DWRemove_UpdateBasic()
		if arg1 ~= nil then
			DWRemove_Update(0, arg1)
			DWRemove_UpdateBasic()
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWRemove_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 2 do
			if g_DWRemove_Item[i] == tonumber(arg0) then
				DWRemove_Resume_Equip(i + g_DWRemove_GRID_SKIP)
				DWRemove_UpdateBasic()
				break
			end
		end
	elseif (event == "UPDATE_DWRemove") then
		DWRemove_UpdateBasic()
		if arg0 ~= nil and arg1 ~= nil then
			DWRemove_Update(arg0, arg1)
			DWRemove_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWRemove_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWRemove_Resume_Equip(tonumber(arg0))
			DWRemove_UpdateBasic()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		DWRemove_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWRemove_Frame_On_ResetPos()
	end
end

--=========================================================
-- ¸üĞÂ»ù±¾ÏÔÊ¾ĞÅÏ¢
--=========================================================
function DWRemove_UpdateBasic()
	DWRemove_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWRemove_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ¼ÆËãËùĞè½ğÇ®
	if g_DWRemove_Item[1] == -1 then
		g_DWRemove_DemandMoney = 0
	else
		g_DWRemove_DemandMoney = 50000
	end
	DWRemove_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWRemove_DemandMoney))
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWRemove_Clear()
	for i = 1, 2 do
		if g_DWRemove_Item[i] ~= -1 then
			g_DWRemove_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWRemove_Item[i], 0)
			g_DWRemove_Item[i] = -1
		end
	end

	DWRemove_UpdateBasic()
end

--=========================================================
-- ¸üĞÂ½çÃæ
--=========================================================
function DWRemove_Update(uiIndex, itemIndex)
	local u_index = tonumber(uiIndex)
	local i_index = tonumber(itemIndex)
	local itemId = PlayerPackage:GetItemTableIndex(i_index)

	if itemId == -1 then
		return
	end

	if g_DWRemove_Item[1] == -1 and g_DWRemove_Item[2] ~= -1 then
		u_index = 1;
	elseif g_DWRemove_Item[1] ~= -1 and g_DWRemove_Item[2] == -1 then
		u_index = 2;
	elseif g_DWRemove_Item[1] == -1 and g_DWRemove_Item[2] == -1 then
		u_index = 1;
	else
		return
	end
	
	local theAction = EnumAction(i_index, "packageitem")
	local ItemID = theAction:GetDefineID()
	if string.sub(ItemID,1,1) ~= "1" then
		PushDebugMessage("Chï có th¬ ğ£t vào trang b¸!")
		return
	end
	if theAction:GetID() ~= 0 then
		-- ÅĞ¶ÏÊÇ·ñÎª°²È«Ê±¼ä
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		if u_index == -1 then
			--PushDebugMessage("Yêu c¥u Dung Kim Ph¤n")
			--DWRemove_Clear()
			return
		end
		
		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(Ö´ĞĞµ½ÕâÀïÖ®Ç°, ÒÑ¾­±»ÅĞ¶ÏÁË)
		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end

		-- Èç¹û¿Õ¸ñÄÚÒÑ¾­ÓĞ¶ÔÓ¦ÎïÆ·ÁË, Ìæ»»Ö®
		if g_DWRemove_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWRemove_Item[u_index], 0)
		end
		g_DWRemove_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWRemove_Item[u_index] = i_index
	else
		DWRemove_Clear()
	end
	
	if g_DWRemove_Item[1] ~= -1 and g_DWRemove_Item[2] ~= -1 then
		DWRemove_OK:Enable()
	else
		DWRemove_OK:Disable()
	end
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWRemove_Resume_Equip(nIndex)
	if nIndex <= g_DWRemove_GRID_SKIP or nIndex > g_DWRemove_GRID_SKIP + 2 then
		return
	end

	nIndex = nIndex - g_DWRemove_GRID_SKIP
	if this:IsVisible() then
		if g_DWRemove_Item[nIndex] ~= -1 then
			g_DWRemove_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWRemove_Item[nIndex], 0)
			g_DWRemove_Item[nIndex] = -1
			DWRemove_OK:Disable()
		end
	end
	DWRemove_Check_AllItem()
end

--=========================================================
-- ÅĞ¶ÏÊÇ·ñËùÓĞÎïÆ·¶¼ÒÑ·ÅºÃ
-- Ö»ÔÚµã»÷ OK °´Å¥µÄÊ±ºòµ÷ÓÃÕâ¸öº¯Êı
--=========================================================
function DWRemove_Check_AllItem()
	DWRemove_UpdateBasic()

	for i = 1, 2 do
		if g_DWRemove_Item[i] == -1 then
			return i
		end
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWRemove_DemandMoney then
		return 44
	end

	return 0
end

--=========================================================
-- È·¶¨Ö´ĞĞ¹¦ÄÜ
--=========================================================
function DWRemove_OK_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(741302)
		Set_XSCRIPT_Parameter(0, 995) --Thao Bo Dieu Van--
		for i = 1, 2 do
			Set_XSCRIPT_Parameter(i, g_DWRemove_Item[i])
		end
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()

	g_DWRemove_Clicked_Num = 0
	this:Hide()
end

--=========================================================
-- ¹Ø±Õ½çÃæ
--=========================================================
function DWRemove_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒş²Ø
--=========================================================
function DWRemove_OnHiden()
	StopCareObject_DWRemove()
	DWRemove_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØĞÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
-- Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_DWRemove()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWRemove")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_DWRemove()
	this:CareObject(g_CaredNpc, 0, "DWRemove")
	g_CaredNpc = -1
	g_DWRemove_Clicked_Num = 0
	return
end

--=========================================================
-- Íæ¼Ò½ğÇ®±ä»¯
--=========================================================
function DWRemove_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWRemove_DemandMoney then
		return -1
	end
	return 1
end


function DWRemove_Frame_On_ResetPos()
  DWRemove_Frame:SetProperty("UnifiedPosition", g_DWRemove_Frame_UnifiedPosition);
end