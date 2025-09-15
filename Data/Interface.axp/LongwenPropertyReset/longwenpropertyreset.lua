-- 龙纹重洗属性界面

local m_UI_NUM = 20110727
local m_ObjCared = -1
local m_Equip_Idx = -1

local UI_TYPE_PRORESET	= 1

local TYPE_COMPOUND		= 1
local TYPE_STARUP		= 2
local TYPE_PRORESET		= 3

local m_UIType = 0

--重洗属性需要的物品
local m_DepleteItem = 20310180		--静元水，暂时用高级根骨丹替代
local m_NeedMoney   = {2000, 4000, 6000, 8000, 10000, 12000, 14000, 14000, 14000, 14000, 14000}	--按静云水个数不同而不同
local m_NeedItemNum = {1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7}			--数量按等级不同而不同


--PreLoad
function LongwenPropertyReset_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_LW_PRORESET")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function LongwenPropertyReset_OnLoad()
end

--OnEvent
function LongwenPropertyReset_OnEvent(event)
	
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then		
		LongwenPropertyReset_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		LongwenPropertyReset_Update(-1)
		
		this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		LongwenPropertyReset_Update( tonumber(arg1))

	elseif (event == "UPDATE_LW_PRORESET" and this:IsVisible() ) then
	
		if m_UIType == UI_TYPE_PRORESET then
			

			
			if arg0 ~= nil then
				LongwenPropertyReset_Update( tonumber(arg0) )
			end
		end

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		LongwenPropertyReset_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		LongwenPropertyReset_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			LongwenPropertyReset_Update(m_Equip_Idx)
		end

	end
end

--Update UI
function LongwenPropertyReset_Update(itemIdx)
    local  itemIdx  =  tonumber(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem")
	
	if theAction:GetID() ~= 0 then
		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
			if EquipPoint ~= 18 then
				PushDebugMessage("#{LW_KVK_110704_07}") -- 此处只能放入龙纹。
				return
			end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		LongwenPropertyReset_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx

	else
		LongwenPropertyReset_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	
	LongwenPropertyReset_UICheck();
end

--Care Obj
function LongwenPropertyReset_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function LongwenPropertyReset_OK_Clicked()
	if m_Equip_Idx == -1 then
		return
	end

		
	local selfMoney = Player:GetData("MONEY") 
	local nNeedMoney = 40000
		
		if selfMoney < nNeedMoney then
			PushDebugMessage("#{LW_KVK_110704_13}")  --对不起，你身上金钱不足，无法继续进行。
			return
		end
		
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnLongWen")
	Set_XSCRIPT_ScriptID(000202)
	Set_XSCRIPT_Parameter(0,4)
	Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
		
	local tEquip_Idx = m_Equip_Idx
	local theAction = EnumAction(tEquip_Idx, "packageitem")
	if theAction:GetID() ~= 0 then
		LongwenPropertyReset_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(tEquip_Idx,1);
		m_Equip_Idx = tEquip_Idx
	else
		LongwenPropertyReset_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1
	end
		
end
--end


--Right button clicked
function LongwenPropertyReset_Resume_Equip()
	LongwenPropertyReset_Update(-1)
end


function LongwenPropertyReset_UICheck()
	LongwenPropertyReset_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	LongwenPropertyReset_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	LongwenPropertyReset_NeedMoney : SetProperty("MoneyNumber", 0)
	LongwenPropertyReset_Text2:SetText("")
	LongwenPropertyReset_OK:Disable()

	needConfirm = 1

	local str = ""		--当前龙纹重洗属性需要：净元水%s个
	local costItemNum = 1
	if m_Equip_Idx ~= -1 then
	LongwenPropertyReset_NeedMoney : SetProperty("MoneyNumber", 40000)
	str = string.format("#{LW_KVK_XML_16}#G x%s#{LW_KVK_XML_39}#{LW_KVK_XML_41}", tostring(costItemNum))
	LongwenPropertyReset_Text2:SetText(str)
	LongwenPropertyReset_OK:Enable()
	end
end

--close & cancel
function LongwenPropertyReset_Close()
	this:Hide()
end

function LongwenPropertyReset_Cancel_Clicked()
	this:Hide()
end

--handle Hide Event
function LongwenPropertyReset_Frame_OnHiden()
	LongwenPropertyReset_Update(-1)
end
