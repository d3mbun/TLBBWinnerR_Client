-- ÁúÎÆÌáÉýºÏ³ÉµÈ¼¶½çÃæ

local m_UI_NUM = 20110725
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1
local m_Stuff_Item = -1

local first=0
local second=0

local UI_TYPE_COMPOUND	= 1

local TYPE_COMPOUND		= 1
local TYPE_STARUP		= 2

local m_UIType = 0

local m_Money_COMPOUND = 500000			--ºÏ³É»¨·Ñ¹Ì¶¨Îª1J

local needMoney = 0

local m_needConfirm = 1

--ÁúÎÆÌáÉýºÏ³ÉµÈ¼¶µÄ²ÄÁÏ
local m_LevelupStuff = {
						[1] = { item = 38000184, num = 5  },		--ÖýÎÆÑªÓñ
						[2] = { item = 38000185, num = 10 },		--ÖýÎÆ¾«Óñ
						[3] = { item = 38000186, num = 20 },		--ÖýÎÆÁúÓñ
						}

local m_NeedConfirmLevel = 99			--µÈ¼¶Îª99¼¶£¬ÇÒ...
local m_MaxStuffNum = 89				--²ÄÁÏ×î´óÖµ


--PreLoad
function LongwenLevelUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_LW_LEVELUP")
	this:RegisterEvent("AFTER_UPDATE_LW_LEVELUP_CONFIRM")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function LongwenLevelUp_OnLoad()
end

--OnEvent
function LongwenLevelUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
				
		LongwenLevelUp_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		--if m_UIType == UI_TYPE_COMPOUND then
		--end
		
		LongwenLevelUp_Update(-1)
		LongwenLevelUp_Update_Sub(-1)
		LongwenLevelUp_Update_Stuff(-1)
		LongwenLevelUp_Item_Change(-1)
		this:Show();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
			LongwenLevelUp_Update_Stuff(tonumber(arg1))
		else
			if m_Equip_Idx ~= -1 then
				LongwenLevelUp_Update_Sub( tonumber(arg1) )
			else
				LongwenLevelUp_Update( tonumber(arg1) )
			end
		end		
	elseif (event == "UPDATE_LW_LEVELUP" and this:IsVisible() ) then
		
		if m_UIType == UI_TYPE_COMPOUND then
						
			if arg1 ~= nil and tonumber(arg1) == 3 and arg0 ~= nil then
				
				if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
					LongwenLevelUp_Update_Stuff(tonumber(arg0))
				else
					--PushDebugMessage("1111111111")							--ÔÝÊ±²»ÖªÌáÊ¾Ê²Ã´¡£¡£
				end
				
			elseif arg1 ~= nil and tonumber(arg1) == 2 and arg0 ~= nil then
				
				if m_Equip_Idx ~= -1 then
					LongwenLevelUp_Update_Sub( tonumber(arg0) )
				else
					LongwenLevelUp_Update( tonumber(arg0) )
				end
				
			elseif arg1 ~= nil and tonumber(arg1) == 1 and arg0 ~= nil then
				LongwenLevelUp_Update_Sub( tonumber(arg0) )
				
			elseif arg1 ~= nil and tonumber(arg1) == 0 and arg0 ~= nil then
				LongwenLevelUp_Update( tonumber(arg0) )
			end
		end

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		LongwenLevelUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		LongwenLevelUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			LongwenLevelUp_Item_Change(m_Equip_Idx)
			
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			LongwenLevelUp_Update_Sub(m_Equip_Item)
			
		elseif  arg0 ~= nil and tonumber(arg0) == m_Stuff_Item then
			LongwenLevelUp_Update_Stuff(m_Stuff_Item)
		end
		
	elseif (event == "AFTER_UPDATE_LW_LEVELUP_CONFIRM" and this:IsVisible()) then
		LongwenLevelUp_OK_Clicked_Continue()
		
	end
end

--Update UI
function LongwenLevelUp_Update(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		local itemId=PlayerPackage:GetItemTableIndex(itemIdx)
		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
		
		if itemId==38000184 or itemId==38000185 or itemId==38000186 then
			LongwenLevelUp_Update_Stuff(itemIdx)
			return
		end
		if EquipPoint ~= 18 then
			PushDebugMessage("#{LW_KVK_110704_07}")
			return
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		LongwenLevelUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		LongwenLevelUp_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	LongwenLevelUp_UICheck();

end

function LongwenLevelUp_Update_Sub(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
	
		local itemId=PlayerPackage:GetItemTableIndex(itemIdx)
		local EquipPoint = LifeAbility:Get_Equip_Point(itemIdx)
		
		if itemId==38000184 or itemId==38000185 or itemId==38000186 then
			LongwenLevelUp_Update_Stuff(itemIdx)
			return
		end
		if EquipPoint ~= 18 then
			PushDebugMessage("#{LW_KVK_110704_07}")
			return
		end
		
		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end
		
		LongwenLevelUp_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
		
	else
		LongwenLevelUp_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		m_Equip_Item = -1;
	end

	LongwenLevelUp_UICheck()
end

--Update UI
function LongwenLevelUp_Update_Stuff(itemIdx)		--ÖýÎÆÑªÓñ
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		local itemId=PlayerPackage:GetItemTableIndex(itemIdx)
		
		if itemId~=38000184 and itemId~=38000185 and itemId~=38000186 then
			PushDebugMessage("Chï có th¬ ð£t vào Nguyên li®u Chú Vån!")
			return
		end
			
		if m_Stuff_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Stuff_Item,0);
		end

		LongwenLevelUp_Object3:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Stuff_Item = itemIdx

	else
		LongwenLevelUp_Object3:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Stuff_Item,0);
		m_Stuff_Item = -1;
	end
	LongwenLevelUp_UICheck();

end


function LongwenLevelUp_Item_Change(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		LongwenLevelUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
		LongwenLevelUp_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end
	LongwenLevelUp_UICheck();

end

--Care Obj
function LongwenLevelUp_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function LongwenLevelUp_OK_Clicked()

	if m_Equip_Idx == -1 or m_Equip_Item == -1 then
		return
	end
	
	LongwenLevelUp_OK_Clicked_Continue()
	LongwenLevelUp_Frame_OnHiden()		
end

--OnContinue
function LongwenLevelUp_OK_Clicked_Continue()
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnLongWen")
	Set_XSCRIPT_ScriptID(000202)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	Set_XSCRIPT_Parameter(2,m_Equip_Item)
	Set_XSCRIPT_Parameter(3,m_Stuff_Item)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT();
end


--Right button clicked
function LongwenLevelUp_Resume_Equip()
	LongwenLevelUp_Update(-1)
end

--Right button clicked
function LongwenLevelUp_Resume_Item()
	LongwenLevelUp_Update_Sub(-1)
end

--Right button clicked
function LongwenLevelUp_Resume_Stuff()
	LongwenLevelUp_Update_Stuff(-1)
end


function LongwenLevelUp_UICheck()
	LongwenLevelUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	LongwenLevelUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	LongwenLevelUp_NeedMoney : SetProperty("MoneyNumber", 0)
	LongwenLevelUp_OK:Disable()

	if m_Equip_Idx ~= -1 then
		needMoney = m_Money_COMPOUND
		LongwenLevelUp_NeedMoney : SetProperty("MoneyNumber", needMoney)
	end

	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		LongwenLevelUp_OK:Enable()
	end
end

--close & cancel
function LongwenLevelUp_Close()
	this:Hide()
end

function LongwenLevelUp_Cancel_Clicked()
	this:Hide()
end

--handle Hide Event
function LongwenLevelUp_Frame_OnHiden()
	LongwenLevelUp_Update(-1)
	LongwenLevelUp_Update_Sub(-1)
	LongwenLevelUp_Update_Stuff(-1)
	LongwenLevelUp_Item_Change(-1)
end


