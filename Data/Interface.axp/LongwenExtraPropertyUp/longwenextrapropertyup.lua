
local m_UI_NUM = 20110730
local m_ObjCared = -1
local m_Equip_Idx = -1

local UI_TYPE_ATTRLEVELUP_HP		= 1		--血上限
local UI_TYPE_ATTRLEVELUP_RESIST	= 2		--冰火玄毒
local UI_TYPE_ATTRLEVELUP_BUFF		= 3		--减伤BUFF

--给服务器传送的参数
local TYPE_COMPOUND				= 1
local TYPE_STARUP				= 2
local TYPE_PRORESET				= 3
local TYPE_ATTRSTUDY_HP			= 4
local TYPE_ATTRSTUDY_BUFF		= 5
local TYPE_ATTRSTUDY_RESIST		= 6
local TYPE_ATTRLEVELUP_HP		= 7
local TYPE_ATTRLEVELUP_BUFF		= 8
local TYPE_ATTRLEVELUP_RESIST	= 9

--其它
local m_UIType = -1
local m_needMoney = 20000
local m_needConfirm = 1
local m_DefaultHight = 420	--窗口默认高度
local m_FrameHight = 480	--窗口高度

--龙纹三个扩展属性的索引号起始
local m_AppendId = {1, 11, 21, 31, 41, 51 } -- 血上限、减伤、冰、火、玄、毒


--PreLoad-LongwenExtraPropertyUp.lua
function LongwenExtraPropertyUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_LW_ATTRLEVELUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function LongwenExtraPropertyUp_OnLoad()
end

--OnEvent
function LongwenExtraPropertyUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		LongwenExtraPropertyUp_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		LongwenExtraPropertyUp_Update(-1)
		LongwenExtraPropertyUp_Item_Change(-1)
		LongwenExtraPropertyUp_UICheck()
		this:Show();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		LongwenExtraPropertyUp_Update( tonumber(arg1) )
	elseif (event == "UPDATE_LW_ATTRLEVELUP" and this:IsVisible() ) then

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		LongwenExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		LongwenExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) ~= -1 and tonumber(arg0) ~= m_Equip_Idx and m_Equip_Idx ~= -1 then
			LongwenExtraPropertyUp_Item_Change(m_Equip_Idx)
		end
		
	end
end

--Update UI
function LongwenExtraPropertyUp_Update(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
		if EquipPoint ~= 18 then
			PushDebugMessage("#{LW_KVK_110704_07}") -- 此处只能放入龙纹。
			return
		end
	
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		LongwenExtraPropertyUp_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx

	else
		LongwenExtraPropertyUp_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	
	LongwenExtraPropertyUp_UICheck();
end


function LongwenExtraPropertyUp_Item_Change(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
		if EquipPoint ~= 18 then
          LongwenExtraPropertyUp_Object:SetActionItem(-1);
		  LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		  m_Equip_Idx = -1;
		  LongwenExtraPropertyUp_UICheck();
				return
			end	
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		LongwenExtraPropertyUp_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
		LongwenExtraPropertyUp_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	LongwenExtraPropertyUp_UICheck();
	
end

--Care Obj
function LongwenExtraPropertyUp_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function LongwenExtraPropertyUp_OK_Clicked()
	if m_Equip_Idx == -1 then
		return
	end
		local EquipPoint = LifeAbility:Get_Equip_Point(m_Equip_Idx)
		if EquipPoint ~= 18 then
			PushDebugMessage("#{LW_KVK_110704_07}") -- 此处只能放入龙纹。
			return
		end

	 local selfMoney = Player:GetData("MONEY")
		if selfMoney < m_needMoney then
			PushDebugMessage("#{LW_KVK_110704_13}")  --对不起，你身上金钱不足，无法继续进行。
			return
		end
		
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnLongWen")
	Set_XSCRIPT_ScriptID(000202)
	Set_XSCRIPT_Parameter(0,3)
	Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	Set_XSCRIPT_Parameter(2,m_UIType)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end


--Right button clicked
function LongwenExtraPropertyUp_Resume_Equip()
	LongwenExtraPropertyUp_Update(-1)
end


function LongwenExtraPropertyUp_UICheck()
	LongwenExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	LongwenExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	LongwenExtraPropertyUp_NeedMoney:SetProperty("MoneyNumber", 0)
	LongwenExtraPropertyUp_OK:Disable()
	LongwenExtraPropertyUp_Text2:SetText("")
	LongwenExtraPropertyUp_Info:SetText("")
	LongwenExtraPropertyUp_Frame:SetProperty("AbsoluteHeight", m_DefaultHight)
	
	if m_UIType == UI_TYPE_ATTRLEVELUP_HP then						--血上限升级
		LongwenExtraPropertyUp_Info:SetText("#{LW_KVK_XML_26}")
	elseif m_UIType == UI_TYPE_ATTRLEVELUP_RESIST then				--减抗下限升级
		LongwenExtraPropertyUp_Info:SetText("#{LW_KVK_XML_30}")
	elseif m_UIType == UI_TYPE_ATTRLEVELUP_BUFF then				--减伤BUFF升级
		LongwenExtraPropertyUp_Info:SetText("#{LW_KVK_XML_32}")
	end
	
	if m_Equip_Idx ~= -1 then
		LongwenExtraPropertyUp_NeedMoney : SetProperty("MoneyNumber", m_needMoney)				
		LongwenExtraPropertyUp_OK:Enable()
	end
end
--CleanUp
function LongwenExtraPropertyUp_CleanUp()
end

--close & cancel
function LongwenExtraPropertyUp_Close()
	this:Hide()
end

function LongwenExtraPropertyUp_Cancel_Clicked()
	this:Hide()
end

--handle Hide Event
function LongwenExtraPropertyUp_Frame_OnHiden()
	LongwenExtraPropertyUp_Update(-1)
	LongwenExtraPropertyUp_Item_Change(-1)
end


