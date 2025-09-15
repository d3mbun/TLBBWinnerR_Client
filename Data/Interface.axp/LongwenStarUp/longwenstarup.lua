-- ���������Ǽ�����

local m_UI_NUM = 20110726
local m_ObjCared = -1
local m_Equip_Idx = -1

local UI_TYPE_STARUP	= 1 --�����������������Ǽ�
local UI_TYPE_STARUP_FENGYANG	= 2 --�ڷ��������Ǽ�

local TYPE_COMPOUND		= 1
local TYPE_STARUP		= 2
local TYPE_PRORESET		= 3

local m_UIType = 0
local m_needMoney = 0
local m_needConfirm = 1
local m_IsReady = 0

local m_Money_COMPOUND = 10000			--�ϳɻ��ѹ̶�Ϊ1J

--�����Ǽ�����Ҫ�Ĳ���1�Ͳ���2��id������
local m_StuffId1 = -1
local m_StuffId2 = -1
local m_StuffNum1 = -1
local m_StuffNum2 = -1
local m_StuffName1 = ""
local m_StuffName2 = ""
local m_str1 = "#{LW_KVK_XML_12}"		--��ǰ���������Ǽ���Ҫ��
local m_str2 = "#{LW_KVK_XML_39}"		--��
local m_str3 = "#{LW_KVK_XML_40}"		--��
local m_str4 = "#{LW_KVK_XML_41}"		--��

--PreLoad
function LongwenStarUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_LW_STARUP")
	this:RegisterEvent("MONEY_CHANGE_EX");
	this:RegisterEvent("MONEYJZ_CHANGE_EX");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX");
	this:RegisterEvent("AFTER_UPDATE_LW_BIND_CONFIRM")
end

--OnLoad
function LongwenStarUp_OnLoad()
end

--OnEvent
function LongwenStarUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then

		LongwenStarUp_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		LongwenStarUp_Update(-1)
		this:Show();

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
			if arg1 ~= nil then
				LongwenStarUp_Update( tonumber(arg1) )
			end
	elseif (event == "UPDATE_LW_STARUP" and this:IsVisible() ) then
		if m_UIType == UI_TYPE_STARUP or m_UIType == UI_TYPE_STARUP_FENGYANG then
			if arg1 ~= nil then
				LongwenStarUp_Update( tonumber(arg1) )
			end
		end
	elseif (event == "MONEY_CHANGE_EX" and this:IsVisible()) then
		LongwenStarUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE_EX" and this:IsVisible()) then
		LongwenStarUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED_EX" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg1) == m_Equip_Idx then
			LongwenStarUp_Item_Change(m_Equip_Idx)
		end

	elseif (event == "AFTER_UPDATE_LW_BIND_CONFIRM" and this:IsVisible()) then
		LongwenStarUp_OK_Clicked_Continue()
		
	end
end

--Update UI
function LongwenStarUp_Update(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		if m_UIType == UI_TYPE_STARUP then

		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
			if EquipPoint ~= 18 then
				PushDebugMessage("#{LW_KVK_110704_07}") -- �˴�ֻ�ܷ������ơ�
				return
			end

			local main_lv =SuperTooltips:GetEquipQual();

			if  main_lv ~= nil and main_lv >= 9 then
				PushDebugMessage("#{LW_KVK_110704_58}")  --�������Ѵﵽ����Ǽ�9�ǣ����ܼ���������
				return
			end
		end

		if m_UIType == UI_TYPE_STARUP_FENGYANG then

		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
			if EquipPoint ~= 18 then
				PushDebugMessage("#{LW_KVK_110704_07}") -- �˴�ֻ�ܷ������ơ�
				return
			end

			local main_lv =SuperTooltips:GetEquipQual();

			if  main_lv ~= nil and main_lv >= 9 then
				PushDebugMessage("#{LW_KVK_110704_58}")  --�������Ѵﵽ����Ǽ�9�ǣ����ܼ���������
				return
			end
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		LongwenStarUp_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		LongwenStarUp_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end

	LongwenStarUp_UICheck();
end

--Item_Change
function LongwenStarUp_Item_Change(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		if m_UIType == UI_TYPE_STARUP or m_UIType == UI_TYPE_STARUP_FENGYANG then

		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
			if EquipPoint ~= 18 then
				PushDebugMessage("#{LW_KVK_110704_07}") -- �˴�ֻ�ܷ������ơ�
				return
			end

			this:Hide()
			return

		end

	else
		LongwenStarUp_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end

	LongwenStarUp_UICheck();
end

--Care Obj
function LongwenStarUp_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function LongwenStarUp_OK_Clicked()
	if m_Equip_Idx == -1 then
		return
	end
	
	if m_UIType == UI_TYPE_STARUP or m_UIType == UI_TYPE_STARUP_FENGYANG then

		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")

		if m_needMoney ~= nil and m_needMoney > 0 and selfMoney < m_needMoney then
			PushDebugMessage("#{LW_KVK_110704_13}")  --�Բ��������Ͻ�Ǯ���㣬�޷��������С�
			return
		end
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnLongWen")
	Set_XSCRIPT_ScriptID(000202)
	Set_XSCRIPT_Parameter(0,5)
	Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
	LongwenStarUp_OK_Clicked_Continue()
	end
end

--OnOK
function LongwenStarUp_OK_Clicked_Continue()
	if m_Equip_Idx == -1 then
		return
	end

	if m_UIType == UI_TYPE_STARUP or m_UIType == UI_TYPE_STARUP_FENGYANG then
		
		-- ����������Ȼ�����ڴ�����
		local tEquip_Idx = m_Equip_Idx
		local theAction = EnumAction(tEquip_Idx, "packageitem")
		if theAction:GetID() ~= 0 then
			LongwenStarUp_Object:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(tEquip_Idx,1);
			m_Equip_Idx = tEquip_Idx
		else
			LongwenStarUp_Object:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
			m_Equip_Idx = -1
		end

	end
end


--Right button clicked
function LongwenStarUp_Resume_Equip()
	LongwenStarUp_Update(-1)
end


function LongwenStarUp_UICheck()
	LongwenStarUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	LongwenStarUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	LongwenStarUp_NeedMoney : SetProperty("MoneyNumber", 0)
	LongwenStarUp_OK:Disable()
	LongwenStarUp_Text2:SetText("")						-- �ɹ���
	local str = ""
	local lv =SuperTooltips:GetEquipQual();
--��ͬ�Ǽ�����Ҫ�Ĳ���
	local m_StarUpStuff = {"Ng�c Long T�y x20","Ng�c Long T�y x60","Ng�c Long T�y x120","Ng�c Long T�y x240","Ng�c Long T�y x400 v� C�u Thi�n Th�i S� C�p x30","Ng�c Long T�y x400 v� C�u Thi�n Th�i Trung C�p x60","Ng�c Long T�y x400 v� C�u Thi�n Th�i Cao C�p x120","Ng�c Long T�y x600 v� Huy�n S�c C�u Thi�n Th�i x300","Huy�n S�c C�u Thi�n Th�i x600"}
	if m_Equip_Idx ~= -1 and lv ~=nil then
		str = "#cfff263T�ng c�p sao Long v�n Hi�n t�i c�n:"..m_StarUpStuff[lv]..""
		LongwenStarUp_NeedMoney : SetProperty("MoneyNumber", 500000)
		LongwenStarUp_Text2:SetText(str)
		LongwenStarUp_OK:Enable()

	end
end


--close & cancel
function LongwenStarUp_Close()
	this:Hide()
end

function LongwenStarUp_Cancel_Clicked()
	this:Hide()
end

--handle Hide Event
function LongwenStarUp_Frame_OnHiden()
	LongwenStarUp_Update(-1)
end
