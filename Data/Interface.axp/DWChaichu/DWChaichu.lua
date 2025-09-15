
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWCHAICHU_Item = {}
local g_DWCHAICHU_Object = {}
local g_DWCHAICHU_GRID_SKIP = 100	-- G101 -> G102
local g_DWCHAICHU_DemandMoney = 50000

local g_DWCHAICHU_Action_Type = 3
local g_DWCHAICHU_RScript_ID = 809272
local g_DWCHAICHU_RScript_Name = "DoDiaowenAction"

local g_DWCHAICHU_Clicked_Num = 0			-- ÊÇ·ñÒÑ¾­°´¹ýÒ»´Î¡°È·¶¨¡± by lhx tt80366

local g_DWChaichu_Frame_UnifiedPosition;

--=========================================================
-- ×¢²á´°¿Ú¹ØÐÄµÄËùÓÐÊÂ¼þ
--=========================================================
function DWChaichu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWCHAICHU")
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
function DWChaichu_OnLoad()
	g_DWCHAICHU_Item[1] = -1
	g_DWCHAICHU_Item[2] = -1
	g_DWCHAICHU_Object[1] = DWChaichu_Object
	g_DWCHAICHU_Object[2] = DWChaichu_Object2
	
	g_DWChaichu_Frame_UnifiedPosition=DWChaichu_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- ÊÂ¼þ´¦Àí
--=========================================================
function DWChaichu_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 4000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ð«")
			return
		end
		DWChaichu_OK:Disable()
		BeginCareObject_DWChaichu()
		DWChaichu_Clear()
		DWChaichu_UpdateBasic()
		this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if IsWindowShow("DWChaichu") then
			DWChaichu_UpdateBasic()
			if arg1 ~= nil then
				DWChaichu_Update(0, arg1)
				DWChaichu_UpdateBasic()
			end
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWChaichu_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 2 do
			if g_DWCHAICHU_Item[i] == tonumber(arg0) then
				DWChaichu_Resume_Equip(i + g_DWCHAICHU_GRID_SKIP)
				DWChaichu_UpdateBasic()
				break
			end
		end
	elseif (event == "UPDATE_DWCHAICHU") then
		DWChaichu_UpdateBasic()
		if arg0 ~= nil and arg1 ~= nil then
			DWChaichu_Update(arg0, arg1)
			DWChaichu_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWChaichu_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWChaichu_Resume_Equip(tonumber(arg0))
			DWChaichu_UpdateBasic()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		DWChaichu_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWChaichu_Frame_On_ResetPos()
	end
end

--=========================================================
-- ¸üÐÂ»ù±¾ÏÔÊ¾ÐÅÏ¢
--=========================================================
function DWChaichu_UpdateBasic()
	DWChaichu_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWChaichu_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ¼ÆËãËùÐè½ðÇ®
	if g_DWCHAICHU_Item[1] == -1 then
		g_DWCHAICHU_DemandMoney = 0
	else
		g_DWCHAICHU_DemandMoney = 50000
	end
	DWChaichu_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWCHAICHU_DemandMoney))
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWChaichu_Clear()
	for i = 1, 2 do
		if g_DWCHAICHU_Item[i] ~= -1 then
			g_DWCHAICHU_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[i], 0)
			g_DWCHAICHU_Item[i] = -1
		end
	end

	DWChaichu_UpdateBasic()
end

--=========================================================
-- ¸üÐÂ½çÃæ
--=========================================================
function DWChaichu_Update(uiIndex, itemIndex)
	local u_index = tonumber(uiIndex)
	local i_index = tonumber(itemIndex)
	local itemId = PlayerPackage:GetItemTableIndex(i_index)
	if itemId == 30503150 then
		u_index = 2
	elseif string.sub(itemId,1,1) == "1" then
		u_index=1
	else
		u_index=-1
	end

	local theAction = EnumAction(i_index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- ÅÐ¶ÏÊÇ·ñÎª°²È«Ê±¼ä
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		if u_index == -1 then
			PushDebugMessage("Yêu c¥u Dung Kim Ph¤n")
			-- Òì³£Çé¿ö
			--DWChaichu_Clear()
			return
		end
		
		-- ÅÐ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(Ö´ÐÐµ½ÕâÀïÖ®Ç°, ÒÑ¾­±»ÅÐ¶ÏÁË)
		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end

		-- Èç¹û¿Õ¸ñÄÚÒÑ¾­ÓÐ¶ÔÓ¦ÎïÆ·ÁË, Ìæ»»Ö®
		if g_DWCHAICHU_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[u_index], 0)
		end
		g_DWCHAICHU_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWCHAICHU_Item[u_index] = i_index
	else
		DWChaichu_Clear()
	end
	
	if g_DWCHAICHU_Item[1] ~= -1 and g_DWCHAICHU_Item[2] ~= -1 then
		DWChaichu_OK:Enable()
	end
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWChaichu_Resume_Equip(nIndex)
	if nIndex <= g_DWCHAICHU_GRID_SKIP or nIndex > g_DWCHAICHU_GRID_SKIP + 2 then
		return
	end

	nIndex = nIndex - g_DWCHAICHU_GRID_SKIP
	if this:IsVisible() then
		if g_DWCHAICHU_Item[nIndex] ~= -1 then
			g_DWCHAICHU_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[nIndex], 0)
			g_DWCHAICHU_Item[nIndex] = -1
			
			DWChaichu_OK:Disable()
		end
	end
	DWChaichu_Check_AllItem()
end

--=========================================================
-- ÅÐ¶ÏÊÇ·ñËùÓÐÎïÆ·¶¼ÒÑ·ÅºÃ
-- Ö»ÔÚµã»÷ OK °´Å¥µÄÊ±ºòµ÷ÓÃÕâ¸öº¯Êý
--=========================================================
function DWChaichu_Check_AllItem()
	DWChaichu_UpdateBasic()

	for i = 1, 2 do
		if g_DWCHAICHU_Item[i] == -1 then
			return i
		end
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWCHAICHU_DemandMoney then
		return 44
	end

	return 0
end

--=========================================================
-- È·¶¨Ö´ÐÐ¹¦ÄÜ
--=========================================================
function DWChaichu_OK_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045001)
		Set_XSCRIPT_Parameter(0, 224) --Thao Bo Dieu Van--
		for i = 1, 2 do
			Set_XSCRIPT_Parameter(i, g_DWCHAICHU_Item[i])
		end
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()

	g_DWCHAICHU_Clicked_Num = 0
end

--=========================================================
-- ¹Ø±Õ½çÃæ
--=========================================================
function DWChaichu_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒþ²Ø
--=========================================================
function DWChaichu_OnHiden()
	StopCareObject_DWChaichu()
	DWChaichu_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØÐÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
-- Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_DWChaichu()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWChaichu")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_DWChaichu()
	this:CareObject(g_CaredNpc, 0, "DWChaichu")
	g_CaredNpc = -1
	g_DWCHAICHU_Clicked_Num = 0
	return
end

--=========================================================
-- Íæ¼Ò½ðÇ®±ä»¯
--=========================================================
function DWChaichu_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWCHAICHU_DemandMoney then
		return -1
	end
	return 1
end


function DWChaichu_Frame_On_ResetPos()
  DWChaichu_Frame:SetProperty("UnifiedPosition", g_DWChaichu_Frame_UnifiedPosition);
end