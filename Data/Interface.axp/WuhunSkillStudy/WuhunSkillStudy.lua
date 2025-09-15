--  WuhunSkillStudy
local m_UI_NUM = 20090722
local m_ObjCared = -1
local m_Equip_Idx = -1
local WuhunSkillUp_Confirm = -0

local WuhunSkillStudy_Index = -1

local UI_TYPE_STUDY	= 1
local UI_TYPE_RESET	= 2

local m_UIType = 0

local needMoney = 0

local resetConfirm = 0

--PreLoad
function WuhunSkillStudy_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_SKILL")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

--OnLoad
function WuhunSkillStudy_OnLoad()

end

function WuhunSkillStudy_ClearItem()
	if WuhunSkillStudy_Index ~= -1 then
		WuhunSkillStudy_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunSkillStudy_Index, 0 )
		WuhunSkillStudy_Index = -1
	end

	if WuhunSkillStudy_Index == -1 then
		WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", 0)
		WuhunSkillStudy_OK:Disable()
	end
end

function WuhunSkillStudy_UpdateItem(Pos)
	if WuhunSkillStudy_Index == -1 then
		local Index = EnumAction(Pos, "packageitem")
		local IndexID = Index:GetDefineID()
		if IndexID == -1 then
			return
		end
		
		if IndexID < 10308001 or IndexID > 10308004 then
			PushDebugMessage("N½i này chï có th¬ ð£t vào Võ H°n.")
			return
		end
		
		WuhunSkillStudy_Object:SetActionItem(Index:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunSkillStudy_Index = Pos
	end
	
	if WuhunSkillStudy_Index ~= -1 then
		WuhunSkillStudy_OK:Enable()
		WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunSkillStudy_OK:Disable()
		WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

--OnEvent
function WuhunSkillStudy_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017) then
		if IsWindowShow("WuhunSkillStudy") then
			WuhunSkillStudy_UpdateItem(tonumber(arg1))
		end
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunSkillStudy_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		if m_UIType == UI_TYPE_STUDY then
			WuhunSkillStudy_Title:SetText("#{WH_xml_XX(26)}")
			WuhunSkillStudy_Info:SetText("#{WH_xml_XX(27)}")
			WuhunSkillStudy_Info2:SetText("#{WH_xml_XX(28)}")
		
		elseif m_UIType == UI_TYPE_RESET then
			WuhunSkillStudy_Title:SetText("#{WH_xml_XX(39)}")
			WuhunSkillStudy_Info:SetText("#{WH_xml_XX(40)}")
			WuhunSkillStudy_Info2:SetText("#{WH_xml_XX(41)}")
		end

		WuhunSkillStudy_Update(-1)
		this:Show();
	elseif (event == "UPDATE_KFS_SKILL" and this:IsVisible() ) then
		
		if arg0 ~= nil then
			WuhunSkillStudy_Update( tonumber(arg0) )
		end
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunSkillStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunSkillStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunSkillStudy_Update(m_Equip_Idx)
		end 
	end
end

--Update UI
function WuhunSkillStudy_Update(itemIdx)
	WuhunSkillStudy_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunSkillStudy_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
end

--OnOK
function WuhunSkillStudy_OK_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045001)
		if m_UIType == UI_TYPE_STUDY then
			Set_XSCRIPT_Parameter(0, 1079) 
		elseif m_UIType == UI_TYPE_RESET then
			Set_XSCRIPT_Parameter(0, 1078) 
		end
		Set_XSCRIPT_Parameter(1, WuhunSkillStudy_Index)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
	WuhunSkillStudy_OnHiden()
end

--Right button clicked
function WuhunSkillStudy_Resume_Equip()

	WuhunSkillStudy_Update(-1)

end

--Care Obj
function WuhunSkillStudy_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--handle Hide Event
function WuhunSkillStudy_OnHiden()

	WuhunSkillStudy_ClearItem()
	this:Hide()

end