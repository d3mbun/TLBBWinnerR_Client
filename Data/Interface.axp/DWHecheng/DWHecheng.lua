
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWHECHENG_Item = -1
local g_DWHECHENG_DemandMoney = 50000
local g_DWHECHENG_GRID_SKIP = 95

local g_DWHECHENG_Action_Type = 4
local g_DWHECHENG_RScript_ID = 741301
local g_DWHECHENG_RSCript_Name = "DieuVan"

local g_DWHecheng_Frame_UnifiedPosition;

--=========================================================
-- ע�ᴰ�ڹ��ĵ������¼�
--=========================================================
function DWHecheng_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWHECHENG")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWHECHENG")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- �����ʼ��
--=========================================================
function DWHecheng_OnLoad()
	g_DWHECHENG_Item = -1
	g_DWHECHENG_DemandMoney = 50000
	DWHecheng_OK:Disable()
	
	g_DWHecheng_Frame_UnifiedPosition=DWHecheng_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- �¼�����
--=========================================================
function DWHecheng_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 1000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �")
			return
		end
		BeginCareObject_DWHecheng()
		DWHecheng_Clear()
		DWHecheng_UpdateBasic()
		this:Show()
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if IsWindowShow("DWHecheng") then
			if arg1 ~= nil then
				DWHecheng_Update(arg1)
			end
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWHecheng_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWHECHENG_Item == tonumber(arg0)) then
			DWHecheng_Resume_Equip()
		end
	elseif (event == "UPDATE_DWHECHENG") then
		if arg0 ~= nil then
			DWHecheng_Update(arg0)
		end
		DWHecheng_UpdateBasic()
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWHecheng_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWHECHENG_GRID_SKIP + 1) then
			DWHecheng_Resume_Equip()
			DWHecheng_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWHECHENG") then
		DWHecheng_OK_Clicked(1)
	
	elseif (event == "ADJEST_UI_POS" ) then
		DWHecheng_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWHecheng_Frame_On_ResetPos()
	end
end

--=========================================================
-- ���»�����ʾ��Ϣ
--=========================================================
function DWHecheng_UpdateBasic()
	DWHecheng_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWHecheng_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ���������Ǯ
	if g_DWHECHENG_Item == -1 then
		g_DWHECHENG_DemandMoney = 0
	else
		g_DWHECHENG_DemandMoney = 50000
	end

	DWHecheng_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWHECHENG_DemandMoney))
	DWHecheng_OK:Disable()
end

--=========================================================
-- ���ý���
--=========================================================
function DWHecheng_Clear()
	if g_DWHECHENG_Item ~= -1 then
		DWHecheng_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWHECHENG_Item, 0)
		g_DWHECHENG_Item = -1
		
		DWHecheng_OK:Disable()
	end

	g_DWHECHENG_DemandMoney = 50000
	DWHecheng_UpdateBasic()
end

--=========================================================
-- ���½���
--=========================================================
function DWHecheng_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		local ItemID = theAction:GetDefineID()
		if ItemID < 30110001 or ItemID > 30110021 then
			PushDebugMessage("Ch� c� th� ��a v�o �i�u V�n а T߶ng")
			return
		end
		-- �ж��Ƿ�Ϊ��ȫʱ��
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		-- �ж���Ʒ�Ƿ�Ϊ����ͼ��
		--if LifeAbility:IsDiaowenPic(index) == -1 then
		--	PushDebugMessage("#{ZBDW_091105_2}")
		--	return
		--end

		-- �ж���Ʒ�Ƿ����(������߼�֮ǰ�����Ѿ��ж���)
		if PlayerPackage:IsLock(index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end
		
		-- ����ո����Ѿ���ͼ����, �滻֮
		if g_DWHECHENG_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWHECHENG_Item, 0)
		end
		DWHecheng_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWHECHENG_Item = index
		DWHecheng_OK:Enable()
		DWHecheng_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		DWHecheng_Clear()
		DWHecheng_OK:Disable()
		DWHecheng_DemandMoney:SetProperty("MoneyNumber", 0)
	end
	
	--DWHecheng_UpdateBasic()
end

--=========================================================
-- ȡ�������ڷ������Ʒ
--=========================================================
function DWHecheng_Resume_Equip()
	if this:IsVisible() then
		DWHecheng_Clear()
	end
end

--=========================================================
-- �ж��Ƿ�������Ʒ���ѷź�
-- ֻ�ڵ�� OK ��ť��ʱ������������
--=========================================================
function DWHecheng_Check_AllItem()
	DWHecheng_UpdateBasic()

	if g_DWHECHENG_Item == -1 then
		return 1
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWHECHENG_DemandMoney then
		return 44
	end

	return 0
end


local EB_FREE_BIND = 0;				-- �ް�����
local EB_BINDED = 1;				-- �Ѿ���
local EB_GETUP_BIND =2			-- ʰȡ��
local EB_EQUIP_BIND =3			-- װ����
--=========================================================
-- ȷ��ִ�й���
--=========================================================
function DWHecheng_OK_Clicked(okFlag)

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnCreateItem")
		Set_XSCRIPT_ScriptID(045050)
		Set_XSCRIPT_Parameter(0, 211) --211: Hop Thanh Dieu Van--
		Set_XSCRIPT_Parameter(1, g_DWHECHENG_Item)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- �رս���
--=========================================================
function DWHecheng_Close()
	this:Hide()
	return
end

--=========================================================
-- ��������
--=========================================================
function DWHecheng_OnHiden()
	StopCareObject_DWHecheng()
	DWHecheng_Clear()
	return
end

--=========================================================
-- ��ʼ����NPC��
-- �ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
-- ����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_DWHecheng()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWHecheng")
	return
end

--=========================================================
-- ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_DWHecheng()
	this:CareObject(g_CaredNpc, 0, "DWHecheng")
	g_CaredNpc = -1
	return
end

--=========================================================
-- ��ҽ�Ǯ�仯
--=========================================================
function DWHecheng_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- �жϽ�Ǯ������
	if selfMoney < g_DWHECHENG_DemandMoney then
		return -1
	end
	return 1
end

function DWHecheng_Frame_On_ResetPos()
  DWHecheng_Frame:SetProperty("UnifiedPosition", g_DWHecheng_Frame_UnifiedPosition);
end
