
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWQIANGHUA_Item = -1
local g_DWQIANGHUA_DemandMoney = 0
local g_DWQIANGHUA_GRID_SKIP = 96
-- ½ğ²ÏË¿, Ç¿»¯ÓÃµÄµÀ¾ß, °´ÕÕ °ó¶¨ -> Ôª±¦½»Ò× -> Ëæ±ã½»Ò× Ë³ĞòÊ¹ÓÃ
local g_DWQIANGHUA_ToolItem = {20310168, 20310166, 20310167}
local g_DWQIANGHUA_Tool_Num = tonumber(1)
local g_DWQIANGHUA_NUM_LOW = tonumber(1)
local g_DWQIANGHUA_NUM_UP = tonumber(100000)

local g_DWQIANGHUA_Action_Type = 2
local g_DWQIANGHUA_RScript_ID = 809272
local g_DWQIANGHUA_RScript_Name = "DoDiaowenAction"
local DWQianghua_KTT = {2,9,50,87,165,284,811,2088,3570}
local g_DWQianghua_Frame_UnifiedPosition;

--=========================================================
-- ×¢²á´°¿Ú¹ØĞÄµÄËùÓĞÊÂ¼ş
--=========================================================
function DWQianghua_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWQIANGHUA")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWQIANGHUA")

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWQianghua_OnLoad()
	g_DWQIANGHUA_Item = -1
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
	g_DWQIANGHUA_Tool_Num = tonumber(1)
	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
	-- Ê¼ÖÕ¿ÉÒÔµã»÷ OK °´Å¥, ÎªÁË·½±ãÌáÊ¾Íæ¼ÒĞÅÏ¢
	DWQianghua_OK:Disable()

	g_DWQianghua_Frame_UnifiedPosition=DWQianghua_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function DWQianghua_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 3000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ğ«")
			return
		end
		BeginCareObject_DWQianghua()
		DWQianghua_Clear()
		DWQianghua_UpdateBasic()
		this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if IsWindowShow("DWQianghua") then
			if arg1 ~= nil then
				local ID_M = PlayerPackage:GetItemTableIndex(tonumber(arg1))
				DWQianghua_Update(arg1)
				DWQianghua_UpdateBasic()
			end
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWQianghua_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		-- ¿ÉÒÔ¸Ä³ÉÔÊĞí½Ó×ÅÇ¿»¯, ÄÇ¾Í²»ÒªÔÚÕâÀïÒÆ³ıÎïÆ·
		if tonumber(arg0) == g_DWQIANGHUA_Item then
			-- Ç¿»¯ºó²»½«×°±¸·µ»¹µ½°ü¹ü, Ö§³Ö³ÖĞøÇ¿»¯ - 2009-12-07
			--DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
		end
	elseif (event == "UPDATE_DWQIANGHUA") then
		--¼ÓÔØÕâÀïºÜÈİÒ×µ¼ÖÂ½çÃæ´¦Àí²»¹ıÀ´, Õâ¸öÊÂ¼şÌØ±ğ¶à
		--DWQianghua_UpdateBasic()
		if arg0 ~= nil then
			DWQianghua_Update(arg0)
			DWQianghua_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWQianghua_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWQIANGHUA_GRID_SKIP + 1) then
			DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWQIANGHUA") then
		DWQianghua_OK_Clicked(1)

	elseif (event == "ADJEST_UI_POS" ) then
		DWQianghua_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWQianghua_Frame_On_ResetPos()
	end
end

--=========================================================
-- ¸üĞÂ»ù±¾ÏÔÊ¾ĞÅÏ¢
-- ÔÚÕâÀï¼ÆËã½ğÇ®²¢ÏÔÊ¾
--=========================================================
function DWQianghua_UpdateBasic(nToolNum)
	DWQianghua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWQianghua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	if nToolNum == nil then
		nToolNum = g_DWQIANGHUA_Tool_Num
	end
	DWQianghua_SetToolNumAndText(nToolNum)

	-- ¼ÆËãËùĞè½ğÇ®
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWQianghua_Clear()
	if g_DWQIANGHUA_Item ~= -1 then
		DWQianghua_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
		g_DWQIANGHUA_Item = -1
	end

	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
	DWQianghua_NumericalValue:SetProperty("DefaultEditBox", "True")
	DWQianghua_NumericalValue:SetSelected(0, -1)
end

--=========================================================
-- ¸üĞÂ½çÃæ
--=========================================================
function DWQianghua_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")
	
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

		if g_DWQIANGHUA_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
		end

		DWQianghua_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWQIANGHUA_Item = index
		
		DWQianghua_OK:Enable()
		-- Éè¶¨ OK Îª×ÜÊÇ¿ÉÒÔµã»÷, ÕâÑù·½±ã¼ìÑé
		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñÂú×ãÒªÇóÀ´Éè¶¨¹¦ÄÜbutton
		-- DWQianghua_Check_AllItem()
		
		local InfoDW = GlobalAuthorDW()
		if ItemID >= 10171001 and ItemID <= 10173170 then
			InfoDW = string.sub(ItemID,6,8)..string.sub(InfoDW,4,7)
		end
		
		local CurDW = tonumber(string.sub(InfoDW,1,3));
		local CurKTT = tonumber(string.sub(InfoDW,4,7));
		local LevelDW = math.mod(CurDW,10)
		if LevelDW == 0 then
			DWQianghua_UpdateBasic(0)
		else
			local NeedKTT = DWQianghua_KTT[LevelDW] - CurKTT;
			-- g_DWQIANGHUA_Tool_Num = NeedKTT;
			local Ktt1 = DataPool:GetPlayerMission_ItemCountNow(20310168)
			local Ktt2 = DataPool:GetPlayerMission_ItemCountNow(20310166)
			local Ktt3 = DataPool:GetPlayerMission_ItemCountNow(20310167)
			
			if Ktt1 + Ktt2 + Ktt3 >= NeedKTT then
				DWQianghua_UpdateBasic(NeedKTT)
			else
				DWQianghua_UpdateBasic(Ktt1 + Ktt2 + Ktt3)
			end
		end
	else
		DWQianghua_OK:Disable()
		DWQianghua_Clear()
	end
end

--=========================================================
-- Ôö¼Ó½ğ²ÏË¿µÄÊıÁ¿
--=========================================================
function DWQianghua_Addition_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num + 1)
end

--=========================================================
-- ¼õÉÙ½ğ²ÏË¿µÄÊıÁ¿
--=========================================================
function DWQianghua_Decrease_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num - 1)
end

--=========================================================
-- ½ğ²ÏË¿ÊıÁ¿¸Ä±ä
--=========================================================
function DWQianghua_ToolNumChange()
	local num = DWQianghua_NumericalValue:GetProperty("Text")
	-- ÊäÈë¿ò¸Ä±äÁË, ²»ÒªÔÙ¸Ä±äÊäÈë¿òµÄÄÚÈİ, ²»È»ÓÃ»§¾ÍÃ»·¨ÔÙÊäÈë¿òÊäÈëÊı×ÖÁË
	-- ´úÂëÖ÷¶¯ĞŞ¸ÄµÄÎÄ±¾
	if num == nil or (not num) or num == "" or tonumber(num) < g_DWQIANGHUA_NUM_LOW then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		return
	end
	-- Èç¹ûÓÃ»§É¾³ıÊäÈë¿òµÄËùÓĞÄÚÈİ, tonumber µÄ½á¹û±È½Ï¹îÒì, ÎŞ·¨×Ô¶¯ÉèÖÃÎªÄ³¸öÖµ
	num = tonumber(num)
	if num == g_DWQIANGHUA_Tool_Num then
		return
	end
	-- Íæ¼ÒÊäÈëÎÄ±¾: Ê×ÏÈ¶ÔÓĞĞ§ num ½øĞĞ±£´æ, ²»È»¿ÉÄÜÓ°ÏìÍæ¼ÒÊäÈë
	if tonumber(num) >= g_DWQIANGHUA_NUM_LOW and tonumber(num) <= g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = tonumber(num)
	elseif tonumber(num) > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_UP
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		--DWQianghua_SetToolNumAndText(g_DWQIANGHUA_NUM_UP)
	else
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		--DWQianghua_SetToolNumAndText(g_DWQIANGHUA_NUM_LOW)
	end
	--ºÜÈİÒ×µ¼ÖÂËÀÑ­»·, ÓÉÓÚ½ğÇ®ºÍÇ¿»¯ÊıÁ¿ÎŞ¹Ø, ²»ĞèÒª¸üĞÂÁË.
	--DWQianghua_UpdateBasic(num)
end

--=========================================================
-- ½ğ²ÏË¿ÊıÁ¿µÄÊäÈë¿òÊ§È¥½¹µã?
--=========================================================
function DWQianghua_TextLost()
	DWQianghua_ToolNumChange()
end

--=========================================================
-- ¸ü¸Ä½ğ²ÏË¿ÊıÁ¿²¢ÉèÖÃ±äÁ¿
-- ÎªÁË±£Ö¤ÕâÁ½¸ö²Ù×÷Ê¼ÖÕÍ³Ò»
--=========================================================
function DWQianghua_SetToolNumAndText(count)
	local num = tonumber(count)
	-- ×¢ÒâÕâÀï²»ÒªºÍ DWQianghua_ToolNumChange() ²úÉúËÀÑ­»·ÁË
	if count == nil or count == "" or num < g_DWQIANGHUA_NUM_LOW then
		-- ÊäÈëÌ«Ğ¡µÄÊı
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
	elseif num > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_UP
	elseif num == g_DWQIANGHUA_Tool_Num then
		return
	else
		g_DWQIANGHUA_Tool_Num = num
	end

	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWQianghua_Resume_Equip()
	if this:IsVisible() then
		if g_DWQIANGHUA_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
			DWQianghua_Object:SetActionItem(-1)
			g_DWQIANGHUA_Item = -1
			
			DWQianghua_OK:Disable()
		end
	end

	-- ÖØĞÂ³õÊ¼»¯½ğ²ÏË¿µÄÊıÁ¿
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
end

--=========================================================
-- ÅĞ¶ÏÊÇ·ñËùÓĞÎïÆ·¶¼ÒÑ·ÅºÃ
-- Ö»ÔÚµã»÷ OK °´Å¥µÄÊ±ºòµ÷ÓÃÕâ¸öº¯Êı
--=========================================================
function DWQianghua_Check_AllItem()
	DWQianghua_UpdateBasic()

	if g_DWQIANGHUA_Item == -1 then
		g_DWQIANGHUA_DemandMoney = 0
		DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
		return 1
	end

	-- ÅĞ¶Ï×°±¸ÊÇ·ñÄÜ¹»Ç¿»¯(Ã»ÓĞÊ´¿ÌµñÎÆ»òÕßÇ¿»¯µ½¶¥¼¶ÁË·µ»Ø < 0)
	local ret = LifeAbility:CanEquipDiaowen_Enchase(g_DWQIANGHUA_Item)
	if ret == -1 or ret == -2 then
		return 2
	end
	if ret < 0 then
		return 3
	end

	-- ÅĞ¶Ï½ğ²ÏË¿ÊıÁ¿, ÊäÈëµÄ½ğ²ÏË¿ÊıÁ¿
	-- ÔÚ Server ÅĞ¶Ï

	-- ÅĞ¶Ï½ğÇ®ÊÇ·ñ×ã¹»
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		return 44
	end

	--DWQianghua_OK:Disable()
	DWQianghua_OK:Disable()
	return 0
end


local EB_FREE_BIND = 0;				-- ÎŞ°ó¶¨ÏŞÖÆ
local EB_BINDED = 1;				-- ÒÑ¾­°ó¶¨
local EB_GETUP_BIND =2			-- Ê°È¡°ó¶¨
local EB_EQUIP_BIND =3			-- ×°±¸°ó¶¨
--=========================================================
-- È·¶¨Ö´ĞĞ¹¦ÄÜ
--=========================================================
function DWQianghua_OK_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045001)
		Set_XSCRIPT_Parameter(0, 223) --Cuong Hoa Dieu Van--
		Set_XSCRIPT_Parameter(1, g_DWQIANGHUA_Item)
		Set_XSCRIPT_Parameter(2, g_DWQIANGHUA_Tool_Num)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	
	DWQianghua_Clear()
end

--=========================================================
-- ¹Ø±Õ½çÃæ
--=========================================================
function DWQianghua_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒş²Ø
--=========================================================
function DWQianghua_OnHiden()
	StopCareObject_DWQianghua()
	DWQianghua_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØĞÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
-- Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_DWQianghua()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWQianghua")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_DWQianghua()
	this:CareObject(g_CaredNpc, 0, "DWQianghua")
	g_CaredNpc = -1
	return
end

--=========================================================
-- Íæ¼Ò½ğÇ®±ä»¯
--=========================================================
function DWQianghua_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- ÅĞ¶Ï½ğÇ®¹»²»¹»
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		--DWQianghua_OK:Disable()
		return -1
	end
	return 1
end

function DWQianghua_Frame_On_ResetPos()
  DWQianghua_Frame:SetProperty("UnifiedPosition", g_DWQianghua_Frame_UnifiedPosition);
end
