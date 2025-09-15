
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWQIANGHUA_Item = -1
local g_DWQIANGHUA_DemandMoney = 0
local g_DWQIANGHUA_GRID_SKIP = 96
-- ���˿, ǿ���õĵ���, ���� �� -> Ԫ������ -> ��㽻�� ˳��ʹ��
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
-- ע�ᴰ�ڹ��ĵ������¼�
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
-- �����ʼ��
--=========================================================
function DWQianghua_OnLoad()
	g_DWQIANGHUA_Item = -1
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
	g_DWQIANGHUA_Tool_Num = tonumber(1)
	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
	-- ʼ�տ��Ե�� OK ��ť, Ϊ�˷�����ʾ�����Ϣ
	DWQianghua_OK:Disable()

	g_DWQianghua_Frame_UnifiedPosition=DWQianghua_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- �¼�����
--=========================================================
function DWQianghua_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 3000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �")
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
		-- ���Ըĳ��������ǿ��, �ǾͲ�Ҫ�������Ƴ���Ʒ
		if tonumber(arg0) == g_DWQIANGHUA_Item then
			-- ǿ���󲻽�װ������������, ֧�ֳ���ǿ�� - 2009-12-07
			--DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
		end
	elseif (event == "UPDATE_DWQIANGHUA") then
		--������������׵��½��洦������, ����¼��ر��
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
-- ���»�����ʾ��Ϣ
-- ����������Ǯ����ʾ
--=========================================================
function DWQianghua_UpdateBasic(nToolNum)
	DWQianghua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWQianghua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	if nToolNum == nil then
		nToolNum = g_DWQIANGHUA_Tool_Num
	end
	DWQianghua_SetToolNumAndText(nToolNum)

	-- ���������Ǯ
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
end

--=========================================================
-- ���ý���
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
-- ���½���
--=========================================================
function DWQianghua_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")
	
	local ItemID = theAction:GetDefineID()
	if string.sub(ItemID,1,1) ~= "1" then
		PushDebugMessage("Ch� c� th� �t v�o trang b�!")
		return
	end

	if theAction:GetID() ~= 0 then
		-- �ж��Ƿ�Ϊ��ȫʱ��
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
		-- �趨 OK Ϊ���ǿ��Ե��, �����������
		-- �ж���Ʒ�Ƿ�����Ҫ�����趨����button
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
-- ���ӽ��˿������
--=========================================================
function DWQianghua_Addition_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num + 1)
end

--=========================================================
-- ���ٽ��˿������
--=========================================================
function DWQianghua_Decrease_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num - 1)
end

--=========================================================
-- ���˿�����ı�
--=========================================================
function DWQianghua_ToolNumChange()
	local num = DWQianghua_NumericalValue:GetProperty("Text")
	-- �����ı���, ��Ҫ�ٸı�����������, ��Ȼ�û���û�������������������
	-- ���������޸ĵ��ı�
	if num == nil or (not num) or num == "" or tonumber(num) < g_DWQIANGHUA_NUM_LOW then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		return
	end
	-- ����û�ɾ����������������, tonumber �Ľ���ȽϹ���, �޷��Զ�����Ϊĳ��ֵ
	num = tonumber(num)
	if num == g_DWQIANGHUA_Tool_Num then
		return
	end
	-- ��������ı�: ���ȶ���Ч num ���б���, ��Ȼ����Ӱ���������
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
	--�����׵�����ѭ��, ���ڽ�Ǯ��ǿ�������޹�, ����Ҫ������.
	--DWQianghua_UpdateBasic(num)
end

--=========================================================
-- ���˿�����������ʧȥ����?
--=========================================================
function DWQianghua_TextLost()
	DWQianghua_ToolNumChange()
end

--=========================================================
-- ���Ľ��˿���������ñ���
-- Ϊ�˱�֤����������ʼ��ͳһ
--=========================================================
function DWQianghua_SetToolNumAndText(count)
	local num = tonumber(count)
	-- ע�����ﲻҪ�� DWQianghua_ToolNumChange() ������ѭ����
	if count == nil or count == "" or num < g_DWQIANGHUA_NUM_LOW then
		-- ����̫С����
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
-- ȡ�������ڷ������Ʒ
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

	-- ���³�ʼ�����˿������
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
end

--=========================================================
-- �ж��Ƿ�������Ʒ���ѷź�
-- ֻ�ڵ�� OK ��ť��ʱ������������
--=========================================================
function DWQianghua_Check_AllItem()
	DWQianghua_UpdateBasic()

	if g_DWQIANGHUA_Item == -1 then
		g_DWQIANGHUA_DemandMoney = 0
		DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
		return 1
	end

	-- �ж�װ���Ƿ��ܹ�ǿ��(û��ʴ�̵��ƻ���ǿ���������˷��� < 0)
	local ret = LifeAbility:CanEquipDiaowen_Enchase(g_DWQIANGHUA_Item)
	if ret == -1 or ret == -2 then
		return 2
	end
	if ret < 0 then
		return 3
	end

	-- �жϽ��˿����, ����Ľ��˿����
	-- �� Server �ж�

	-- �жϽ�Ǯ�Ƿ��㹻
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		return 44
	end

	--DWQianghua_OK:Disable()
	DWQianghua_OK:Disable()
	return 0
end


local EB_FREE_BIND = 0;				-- �ް�����
local EB_BINDED = 1;				-- �Ѿ���
local EB_GETUP_BIND =2			-- ʰȡ��
local EB_EQUIP_BIND =3			-- װ����
--=========================================================
-- ȷ��ִ�й���
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
-- �رս���
--=========================================================
function DWQianghua_Close()
	this:Hide()
	return
end

--=========================================================
-- ��������
--=========================================================
function DWQianghua_OnHiden()
	StopCareObject_DWQianghua()
	DWQianghua_Clear()
	return
end

--=========================================================
-- ��ʼ����NPC��
-- �ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
-- ����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_DWQianghua()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWQianghua")
	return
end

--=========================================================
-- ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_DWQianghua()
	this:CareObject(g_CaredNpc, 0, "DWQianghua")
	g_CaredNpc = -1
	return
end

--=========================================================
-- ��ҽ�Ǯ�仯
--=========================================================
function DWQianghua_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- �жϽ�Ǯ������
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		--DWQianghua_OK:Disable()
		return -1
	end
	return 1
end

function DWQianghua_Frame_On_ResetPos()
  DWQianghua_Frame:SetProperty("UnifiedPosition", g_DWQianghua_Frame_UnifiedPosition);
end
