-- 扩展属性学习界面

local m_UI_NUM = 20110729
local m_ObjCared = -1
local m_Equip_Idx = -1

--扩展属性学习的类型
local UI_TYPE_ATTRSTUDY_HP		= 0		--血上限
local UI_TYPE_ATTRSTUDY_RESIST	= 1		--冰火玄毒
local UI_TYPE_ATTRSTUDY_BUFF	= 2		--减伤BUFF

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
local m_UIType = 0
local m_needMoney = 0
local m_needConfirm = 1
local m_IsReady = 0
local m_select = -1
--local m_DefaultHight = 400	--默认高度
--local m_FrameHight = 460	--窗口高度

--龙纹三个扩展属性的索引号起始
local m_LearnMoney			= 10000						--学习花费的金钱固定
local m_DepleteItemNum		= 10						--缀龙石·元、暴、护的个数
local m_DepleteItemHp		= { 20310181, 20310189 }	--缀龙石·元
local m_DepleteItemResist	= { 20310182, 20310190 }	--缀龙石·暴
local m_DepleteItemBuff		= { 20310183, 20310191 }	--缀龙石·护

local m_ResistIdSection =	{							--取值区间，用于减抗学习判定
								{MinId = 21, MaxId = 30},				--冰
								{MinId = 31, MaxId = 40},				--火
								{MinId = 41, MaxId = 50},				--玄
								{MinId = 51, MaxId = 60},				--毒
							}
local m_BuffIdSection =	{							--取值区间
								{MinId = 11, MaxId = 20},				--冰
								{MinId = 61, MaxId = 70},				--火
								{MinId = 71, MaxId = 80},				--玄
								{MinId = 81, MaxId = 90},				--毒
							}

local m_AttrExList = {}


--PreLoad-LongwenExtraPropertyStudy.lua
function LongwenExtraPropertyStudy_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_LW_ATTRSTUDY")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("AFTER_UPDATE_LW_BIND_CONFIRM")
end

--OnLoad
function LongwenExtraPropertyStudy_OnLoad()
	m_AttrExList[1] = LongwenExtraPropertyStudy_Property1			--冰
	m_AttrExList[2] = LongwenExtraPropertyStudy_Property3			--火
	m_AttrExList[3] = LongwenExtraPropertyStudy_Property2			--玄
	m_AttrExList[4] = LongwenExtraPropertyStudy_Property4			--毒
end

--OnEvent
function LongwenExtraPropertyStudy_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		LongwenExtraPropertyStudy_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = tonumber(Get_XParam_INT(1))
		
		if m_UIType == UI_TYPE_ATTRSTUDY_RESIST or m_UIType == UI_TYPE_ATTRSTUDY_BUFF or m_UIType == UI_TYPE_ATTRSTUDY_HP then
			LongwenExtraPropertyStudy_Update(-1)
			LongwenExtraPropertyStudy_Item_Change(-1)
			LongwenExtraPropertyStudy_UICheck()
			this:Show();
		end

	elseif (event == "UPDATE_LW_ATTRSTUDY" and this:IsVisible() ) then
		if m_UIType == UI_TYPE_ATTRSTUDY_RESIST or m_UIType == UI_TYPE_ATTRSTUDY_BUFF then
			
			if CheckPhoneMibaoAndMinorPassword() ~= 1 then			--判断电话密保和二级密码保护
				return
			end
			
			if arg0 ~= nil then
				LongwenExtraPropertyStudy_Update( tonumber(arg0) )
			end
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		LongwenExtraPropertyStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if arg1 ~= nil  then
		    LongwenExtraPropertyStudy_Update( tonumber(arg1) )
		end 
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		LongwenExtraPropertyStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) ~= -1 and tonumber(arg0) ~= m_Equip_Idx and m_Equip_Idx ~= -1 then
			LongwenExtraPropertyStudy_Item_Change(m_Equip_Idx)
		end
		
	elseif (event == "AFTER_UPDATE_LW_BIND_CONFIRM" and this:IsVisible()) then
		LongwenExtraPropertyStudy_OK_Clicked_Continue()
		
	end
end

--Update UI
function LongwenExtraPropertyStudy_Update(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		if (m_UIType == UI_TYPE_ATTRSTUDY_RESIST or m_UIType == UI_TYPE_ATTRSTUDY_BUFF or m_UIType == UI_TYPE_ATTRSTUDY_HP) and (itemIdx ~= -1) then
		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
		if EquipPoint ~= 18 then
			PushDebugMessage("#{LW_KVK_110704_07}") -- 此处只能放入龙纹。
			return
			end
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		LongwenExtraPropertyStudy_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx

	else
		LongwenExtraPropertyStudy_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	
	LongwenExtraPropertyStudy_UICheck();
end


function LongwenExtraPropertyStudy_Item_Change(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if (m_UIType == UI_TYPE_ATTRSTUDY_RESIST or m_UIType == UI_TYPE_ATTRSTUDY_BUFF  or m_UIType == UI_TYPE_ATTRSTUDY_HP) and (itemIdx ~= -1) then
		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
		if EquipPoint ~= 18 then
				PushDebugMessage("#{LW_KVK_110704_07}") -- 此处只能放入龙纹。
				return
			end
			
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		LongwenExtraPropertyStudy_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
		LongwenExtraPropertyStudy_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	LongwenExtraPropertyStudy_UICheck();

end

--Select 1 Attr
function LongwenExtraPropertyStudy_Select_AttrEx(idx)
	m_select = idx
	LongwenExtraPropertyStudy_UICheck()
end

--Care Obj
function LongwenExtraPropertyStudy_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function LongwenExtraPropertyStudy_OK_Clicked()
	if m_Equip_Idx == -1 then
		return
	end
	-- 判断是否为安全时间2012.6.8-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	if m_UIType == UI_TYPE_ATTRSTUDY_RESIST or m_UIType == UI_TYPE_ATTRSTUDY_BUFF  or m_UIType == UI_TYPE_ATTRSTUDY_HP then
		
		local EquipPoint = LifeAbility:Get_Equip_Point(m_Equip_Idx)
		if EquipPoint ~= 18 then
			PushDebugMessage("#{LW_KVK_110704_07}") -- 此处只能放入龙纹。
			return
		end
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		
		if selfMoney < m_LearnMoney then
			PushDebugMessage("#{LW_KVK_110704_13}")  --对不起，你身上金钱不足，无法继续进行。
			return
		end
		
			LongwenExtraPropertyStudy_OK_Clicked_Continue()
	   end
	
end

--OnOK
function LongwenExtraPropertyStudy_OK_Clicked_Continue()
	if m_Equip_Idx == -1 then
		return
	end

if m_UIType == UI_TYPE_ATTRSTUDY_RESIST or m_UIType == UI_TYPE_ATTRSTUDY_BUFF  or m_UIType == UI_TYPE_ATTRSTUDY_HP then
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnLongWen")
	Set_XSCRIPT_ScriptID(000202)
	Set_XSCRIPT_Parameter(0, 2)
	Set_XSCRIPT_Parameter(1, m_UIType)
	Set_XSCRIPT_Parameter(2, m_Equip_Idx)
	Set_XSCRIPT_Parameter(3, m_select)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()		
		
		
	end
end


--Right button clicked
function LongwenExtraPropertyStudy_Resume_Equip()
	LongwenExtraPropertyStudy_Update(-1)
end


function LongwenExtraPropertyStudy_UICheck()
	LongwenExtraPropertyStudy_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	LongwenExtraPropertyStudy_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	LongwenExtraPropertyStudy_NeedMoney : SetProperty("MoneyNumber", 0)
	LongwenExtraPropertyStudy_OK:Disable()
	LongwenExtraPropertyStudy_Info:SetText("")
	--LongwenExtraPropertyStudy_Frame:SetProperty("AbsoluteHeight", m_DefaultHight)
	LongwenExtraPropertyStudy_Property1:Hide()
	LongwenExtraPropertyStudy_Property2:Hide()
	LongwenExtraPropertyStudy_Property3:Hide()
	LongwenExtraPropertyStudy_Property4:Hide()
	LongwenExtraPropertyStudy_Text2:Hide()
	for i = 1 , 4 do
		m_AttrExList[i]:SetCheck(0)
	end

	if m_UIType == UI_TYPE_ATTRSTUDY_RESIST then
	    LongwenExtraPropertyStudy_Property1:Show()
	    LongwenExtraPropertyStudy_Property2:Show()
	    LongwenExtraPropertyStudy_Property3:Show()
	    LongwenExtraPropertyStudy_Property4:Show()
		LongwenExtraPropertyStudy_Text2:Show()
		LongwenExtraPropertyStudy_Property1:SetText("#{LW_KVK_XML_21}")
		LongwenExtraPropertyStudy_Property2:SetText("#{LW_KVK_XML_22}")
		LongwenExtraPropertyStudy_Property3:SetText("#{LW_KVK_XML_23}")
		LongwenExtraPropertyStudy_Property4:SetText("#{LW_KVK_XML_24}")
		--LongwenExtraPropertyStudy_Frame:SetProperty("AbsoluteHeight", m_FrameHight)
		LongwenExtraPropertyStudy_Info:SetText("#{LW_KVK_XML_20}")
	elseif m_UIType == UI_TYPE_ATTRSTUDY_BUFF then
		LongwenExtraPropertyStudy_Property1:Show()
	    LongwenExtraPropertyStudy_Property2:Show()
	    LongwenExtraPropertyStudy_Property3:Show()
	    LongwenExtraPropertyStudy_Property4:Show()
		LongwenExtraPropertyStudy_Text2:Show()
		LongwenExtraPropertyStudy_Property1:SetText("#{LW_KVK_XML_52}")
		LongwenExtraPropertyStudy_Property2:SetText("#{LW_KVK_XML_53}")
		LongwenExtraPropertyStudy_Property3:SetText("#{LW_KVK_XML_54}")
		LongwenExtraPropertyStudy_Property4:SetText("#{LW_KVK_XML_55}")
		--LongwenExtraPropertyStudy_Frame:SetProperty("AbsoluteHeight", m_FrameHight)
		LongwenExtraPropertyStudy_Info:SetText("#{LW_KVK_XML_25}")
	else
	LongwenExtraPropertyStudy_Info:SetText("#{LW_KVK_XML_18}")
	if m_Equip_Idx ~= -1 then
	m_select = 1
	end
	end
	
	if m_Equip_Idx ~= -1 then
		
		if m_select < 1 or m_select > 4 then
			return
		end
		
		m_AttrExList[m_select]:SetCheck(1)
		
			LongwenExtraPropertyStudy_NeedMoney : SetProperty("MoneyNumber", m_LearnMoney)

		
		LongwenExtraPropertyStudy_OK:Enable()
	else
		m_select = -1
	end
end

--CleanUp
function LongwenExtraPropertyStudy_CleanUp()
end

--close & cancel
function LongwenExtraPropertyStudy_Close()
	this:Hide()
end

function LongwenExtraPropertyStudy_Cancel_Clicked()
	this:Hide()
end

--handle Hide Event
function LongwenExtraPropertyStudy_Frame_OnHiden()
	LongwenExtraPropertyStudy_Update(-1)
	LongwenExtraPropertyStudy_Item_Change(-1)
end

