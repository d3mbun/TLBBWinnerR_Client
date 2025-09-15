
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWSHIKE_DemandMoney = 50000
local g_DWSHIKE_Item = {}
local g_DWSHIKE_Object = {}
local g_DWSHIKE_GRID_SKIP = 97	-- G98 -> G100

local g_DWSHIKE_Action_Type = 1
local g_DWSHIKE_RScript_ID = 809272
local g_DWSHIKE_RScript_Name = "DoDiaowenAction"

local g_DWShike_Frame_UnifiedPosition;

local g_TipsTwice = 1

--=========================================================
-- ×¢²á´°¿Ú¹ØĞÄµÄËùÓĞÊÂ¼ş
--=========================================================
function DWShike_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWSHIKE")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWSHIKE")	-- È·ÈÏ½øĞĞµñÎÆÊ´¿ÌµÄÏûÏ¢

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWShike_OnLoad()
	g_DWSHIKE_Item[1] = -1
	g_DWSHIKE_Item[2] = -1
	g_DWSHIKE_Item[3] = -1
	g_DWSHIKE_Object[1] = DWShike_Object
	g_DWSHIKE_Object[2] = DWShike_Object2
	g_DWSHIKE_Object[3] = DWShike_Object3
	-- Ê¼ÖÕ¿ÉÒÔµã»÷ OK °´Å¥, ÎªÁË·½±ãÌáÊ¾Íæ¼ÒĞÅÏ¢
	DWShike_OK:Disable()

	g_DWShike_Frame_UnifiedPosition=DWShike_Frame:GetProperty("UnifiedPosition");

end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function DWShike_OnEvent(event)
	-- PushDebugMessage(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 2000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ğ«")
			return
		end
		BeginCareObject_DWShike()
		DWShike_Clear()
		DWShike_UpdateBasic()
		this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if IsWindowShow("DWShike") then
			DWShike_UpdateBasic()
			DWShike_Update(tonumber(arg1))
			DWShike_UpdateBasic()
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWShike_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 3 do
			if g_DWSHIKE_Item[i] == tonumber(arg0) then
				DWShike_Resume_Equip(i + g_DWSHIKE_GRID_SKIP)
				DWShike_UpdateBasic()
				break
			end
		end
	elseif (event == "UPDATE_DWSHIKE") then
		DWShike_UpdateBasic()
		if arg0 ~= nil and arg1 ~= nil then
			DWShike_Update(arg0, arg1)
			DWShike_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWShike_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWShike_Resume_Equip(tonumber(arg0))
			DWShike_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWSHIKE") then
		if 1 == tonumber(arg0) then
			DWShike_OK_Clicked(1)
		elseif 2 == tonumber(arg0) then
			DWShike_OK_Clicked(2)
		end

	elseif (event == "ADJEST_UI_POS" ) then
		DWShike_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWShike_Frame_On_ResetPos()
	end
end

--=========================================================
-- ¸üĞÂ»ù±¾ÏÔÊ¾ĞÅÏ¢
--=========================================================
function DWShike_UpdateBasic()
	DWShike_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWShike_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ¼ÆËãËùĞè½ğÇ®
	if g_DWSHIKE_Item[1] == -1 then
		g_DWSHIKE_DemandMoney = 0
	else
		g_DWSHIKE_DemandMoney = 50000
	end
	DWShike_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWSHIKE_DemandMoney))
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWShike_Clear()
	for i = 1, 3 do
		if g_DWSHIKE_Item[i] ~= -1 then
			g_DWSHIKE_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[i], 0)
			g_DWSHIKE_Item[i] = -1
		end
	end

	DWShike_UpdateBasic()
end

--=========================================================
-- ¸üĞÂ½çÃæ
--=========================================================
function DWShike_Update(i_index)
	local itemId=PlayerPackage:GetItemTableIndex(i_index)
	local u_index = -1

	if string.sub(itemId,1,1) == "1" then
		u_index = 1
	end
	if itemId == 30503149 then
		u_index = 2
	elseif itemId >= 30120001 and itemId <= 30120210 then
		u_index = 3
	end

	local theAction = EnumAction(i_index, "packageitem")

	--add by kaibin 2010-11-26 tt85427
	g_TipsTwice = 1

	if theAction:GetID() ~= 0 then
		-- ÅĞ¶ÏÊÇ·ñÎª°²È«Ê±¼ä
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		if u_index == 4 then
			PushDebugMessage("Trang b¸ này ğã ğßşc kh¡c ğiêu vån.")
			return		
		end

		if u_index == -1 then
			-- Òì³£Çé¿ö
			PushDebugMessage("Trang b¸ này không th¬ tiªn hành ğiêu vån.")
			--DWShike_Clear()
			return		
		end

		-- µñÎÆÊ´¿Ì²»ÅĞ¶Ï×°±¸ÊÇ·ñ¼ÓËøÁË - 2009-12-07
		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(ÔÚÕâ¸öÂß¼­Ö®Ç°³ÌĞòÒÑ¾­ÅĞ¶ÏÁË)
		if u_index ~= 1 and PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end

		-- Èç¹û¿Õ¸ñÄÚÒÑ¾­ÓĞ¶ÔÓ¦ÎïÆ·ÁË, Ìæ»»Ö®
		if g_DWSHIKE_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[u_index], 0)
		end
		g_DWSHIKE_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWSHIKE_Item[u_index] = i_index

		-- ÅĞ¶ÏËùÓĞÎïÆ·ÊÇ·ñ¶¼ÒÑ¾­·ÅÈë
		-- DWShike_Check_AllItem()
	else
		DWShike_Clear()
	end
	
	if g_DWSHIKE_Item[1] ~= -1 and g_DWSHIKE_Item[2] ~= -1 and g_DWSHIKE_Item[3] ~= -1 then
		DWShike_OK:Enable()
	else
		DWShike_OK:Disable()
	end
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWShike_Resume_Equip(nIndex)
	if nIndex <= g_DWSHIKE_GRID_SKIP or nIndex > g_DWSHIKE_GRID_SKIP + 3 then
		return
	end

	nIndex = nIndex - g_DWSHIKE_GRID_SKIP
	if this:IsVisible() then
		if g_DWSHIKE_Item[nIndex] ~= -1 then
			g_DWSHIKE_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[nIndex], 0)
			g_DWSHIKE_Item[nIndex] = -1
			
			DWShike_OK:Disable()
		end
	end
	DWShike_Check_AllItem()
end

--=========================================================
-- ÅĞ¶ÏÊÇ·ñËùÓĞÎïÆ·¶¼ÒÑ·ÅºÃ
-- Ö»ÔÚµã»÷ OK °´Å¥µÄÊ±ºòµ÷ÓÃÕâ¸öº¯Êı
--=========================================================
function DWShike_Check_AllItem()
	DWShike_UpdateBasic()
	for i = 1, 3 do
		if g_DWSHIKE_Item[i] == -1 then
			return i
		end
	end

	-- ²é¿´Ê´¿Ì·ûºÍµñÎÆÊÇ·ñÊÇ°ó¶¨µÄ
	local isShikeBind	= 0
	local isDiaowenBind	= 0
	if(GetItemBindStatus(g_DWSHIKE_Item[2]) == 1) then
		isShikeBind = 1
	end

	if(GetItemBindStatus(g_DWSHIKE_Item[3]) == 1) then
		isDiaowenBind = 1
	end

	local equipTableIndex	= PlayerPackage : GetItemTableIndex( g_DWSHIKE_Item[1] )
	local isEquipBind	= GetItemBindStatus( g_DWSHIKE_Item[1] )
	-- Èç¹û Ê´¿Ì·û µñÎÆ ÈÎÒâÒ»ÏîÊÇ°ó¶¨µÄ£¬ÄÇ¾Í²»¿ÉÒÔ¶ÔÖØÂ¥½ä¡¢ÖØÂ¥ÓñµñÎÆ
	--[»ÆÊï¹â 2010-1-27 TT65847 ·Ç°ó¶¨µÄÖØÂ¥½ä ÖØÂ¥ÓñÔÊĞíµñÎÆ£¬µñÍêºó»¹ÊÇÎ´°ó¶¨µÄ]
	-- Èç¹û Ê´¿Ì·û µñÎÆ ÈÎÒâÒ»ÏîÊÇ°ó¶¨µÄ£¬ÄÇ¾Í²»¿ÉÒÔ¶ÔÖØÂ¥½ä¡¢ÖØÂ¥ÓñµñÎÆ
	-- Íõ¹Ú 2009-12-11 13:38:04
	--if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
		--if ( 0 == isEquipBind ) then
			--if(isShikeBind == 1 or isDiaowenBind == 1) then
				--return 6
			--end
		--end
	--end
	--[/»ÆÊï¹â 2010-1-27 TT65847 ·Ç°ó¶¨µÄÖØÂ¥½ä ÖØÂ¥ÓñÔÊĞíµñÎÆ£¬µñÍêºó»¹ÊÇÎ´°ó¶¨µÄ]

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWSHIKE_DemandMoney then
		return 44
	end

	local EquipPoint = LifeAbility:Can_Diaowen(g_DWSHIKE_Item[1], g_DWSHIKE_Item[3])
	if EquipPoint == -1 then
		return 5
	end

	local dwId = LifeAbility:GetDiaowenId(g_DWSHIKE_Item[3])
	-- ÅĞ¶ÏµñÎÆºÍ×°±¸ÊÇ·ñÅäÌ×(²»ÖØĞÂÉèÖÃOK°´Å¥ÁË), Í¬Ê±¼ìÑéµñÎÆµÄĞèÇóµÈ¼¶
	if LifeAbility:CheckDwAndEquipPoint(dwId, EquipPoint) <= 0 then
		return 4
	end

	DWShike_OK:Disable()
	return 0
end

local EB_BINDED = 1;				-- ÒÑ¾­°ó¶¨
--=========================================================
-- È·¶¨Ö´ĞĞ¹¦ÄÜ
--=========================================================
function DWShike_OK_Clicked(okFlag)

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045001)
		Set_XSCRIPT_Parameter(0, 222) --Tac Khac Dieu Van--
		for i = 1, 3 do
			Set_XSCRIPT_Parameter(i, g_DWSHIKE_Item[i])
		end
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()

end

--=========================================================
-- ¹Ø±Õ½çÃæ
--=========================================================
function DWShike_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒş²Ø
--=========================================================
function DWShike_OnHiden()
	StopCareObject_DWShike()
	DWShike_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØĞÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
-- Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_DWShike()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWShike")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_DWShike()
	this:CareObject(g_CaredNpc, 0, "DWShike")
	g_CaredNpc = -1
	return
end

--=========================================================
-- Íæ¼Ò½ğÇ®±ä»¯
--=========================================================
function DWShike_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- ÅĞ¶Ï½ğÇ®¹»²»¹»
	if selfMoney < g_DWSHIKE_DemandMoney then
		return -1
	end
	return 1
end

function DWShike_Frame_On_ResetPos()
  DWShike_Frame:SetProperty("UnifiedPosition", g_DWShike_Frame_UnifiedPosition);
end

