
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
-- ע�ᴰ�ڹ��ĵ������¼�
--=========================================================
function DWShike_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWSHIKE")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWSHIKE")	-- ȷ�Ͻ��е���ʴ�̵���Ϣ

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- �����ʼ��
--=========================================================
function DWShike_OnLoad()
	g_DWSHIKE_Item[1] = -1
	g_DWSHIKE_Item[2] = -1
	g_DWSHIKE_Item[3] = -1
	g_DWSHIKE_Object[1] = DWShike_Object
	g_DWSHIKE_Object[2] = DWShike_Object2
	g_DWSHIKE_Object[3] = DWShike_Object3
	-- ʼ�տ��Ե�� OK ��ť, Ϊ�˷�����ʾ�����Ϣ
	DWShike_OK:Disable()

	g_DWShike_Frame_UnifiedPosition=DWShike_Frame:GetProperty("UnifiedPosition");

end

--=========================================================
-- �¼�����
--=========================================================
function DWShike_OnEvent(event)
	-- PushDebugMessage(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 2000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �")
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
-- ���»�����ʾ��Ϣ
--=========================================================
function DWShike_UpdateBasic()
	DWShike_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWShike_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ���������Ǯ
	if g_DWSHIKE_Item[1] == -1 then
		g_DWSHIKE_DemandMoney = 0
	else
		g_DWSHIKE_DemandMoney = 50000
	end
	DWShike_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWSHIKE_DemandMoney))
end

--=========================================================
-- ���ý���
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
-- ���½���
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
		-- �ж��Ƿ�Ϊ��ȫʱ��
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		if u_index == 4 then
			PushDebugMessage("Trang b� n�y �� ���c kh�c �i�u v�n.")
			return		
		end

		if u_index == -1 then
			-- �쳣���
			PushDebugMessage("Trang b� n�y kh�ng th� ti�n h�nh �i�u v�n.")
			--DWShike_Clear()
			return		
		end

		-- ����ʴ�̲��ж�װ���Ƿ������ - 2009-12-07
		-- �ж���Ʒ�Ƿ����(������߼�֮ǰ�����Ѿ��ж���)
		if u_index ~= 1 and PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end

		-- ����ո����Ѿ��ж�Ӧ��Ʒ��, �滻֮
		if g_DWSHIKE_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[u_index], 0)
		end
		g_DWSHIKE_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWSHIKE_Item[u_index] = i_index

		-- �ж�������Ʒ�Ƿ��Ѿ�����
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
-- ȡ�������ڷ������Ʒ
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
-- �ж��Ƿ�������Ʒ���ѷź�
-- ֻ�ڵ�� OK ��ť��ʱ������������
--=========================================================
function DWShike_Check_AllItem()
	DWShike_UpdateBasic()
	for i = 1, 3 do
		if g_DWSHIKE_Item[i] == -1 then
			return i
		end
	end

	-- �鿴ʴ�̷��͵����Ƿ��ǰ󶨵�
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
	-- ��� ʴ�̷� ���� ����һ���ǰ󶨵ģ��ǾͲ����Զ���¥�䡢��¥�����
	--[����� 2010-1-27 TT65847 �ǰ󶨵���¥�� ��¥��������ƣ��������δ�󶨵�]
	-- ��� ʴ�̷� ���� ����һ���ǰ󶨵ģ��ǾͲ����Զ���¥�䡢��¥�����
	-- ���� 2009-12-11 13:38:04
	--if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
		--if ( 0 == isEquipBind ) then
			--if(isShikeBind == 1 or isDiaowenBind == 1) then
				--return 6
			--end
		--end
	--end
	--[/����� 2010-1-27 TT65847 �ǰ󶨵���¥�� ��¥��������ƣ��������δ�󶨵�]

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWSHIKE_DemandMoney then
		return 44
	end

	local EquipPoint = LifeAbility:Can_Diaowen(g_DWSHIKE_Item[1], g_DWSHIKE_Item[3])
	if EquipPoint == -1 then
		return 5
	end

	local dwId = LifeAbility:GetDiaowenId(g_DWSHIKE_Item[3])
	-- �жϵ��ƺ�װ���Ƿ�����(����������OK��ť��), ͬʱ������Ƶ�����ȼ�
	if LifeAbility:CheckDwAndEquipPoint(dwId, EquipPoint) <= 0 then
		return 4
	end

	DWShike_OK:Disable()
	return 0
end

local EB_BINDED = 1;				-- �Ѿ���
--=========================================================
-- ȷ��ִ�й���
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
-- �رս���
--=========================================================
function DWShike_Close()
	this:Hide()
	return
end

--=========================================================
-- ��������
--=========================================================
function DWShike_OnHiden()
	StopCareObject_DWShike()
	DWShike_Clear()
	return
end

--=========================================================
-- ��ʼ����NPC��
-- �ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
-- ����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_DWShike()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWShike")
	return
end

--=========================================================
-- ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_DWShike()
	this:CareObject(g_CaredNpc, 0, "DWShike")
	g_CaredNpc = -1
	return
end

--=========================================================
-- ��ҽ�Ǯ�仯
--=========================================================
function DWShike_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- �жϽ�Ǯ������
	if selfMoney < g_DWSHIKE_DemandMoney then
		return -1
	end
	return 1
end

function DWShike_Frame_On_ResetPos()
  DWShike_Frame:SetProperty("UnifiedPosition", g_DWShike_Frame_UnifiedPosition);
end

