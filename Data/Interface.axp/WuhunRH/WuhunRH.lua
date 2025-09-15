local m_UI_NUM = 20090824
local m_ObjCared = -1
local WuhunRH_Index1 = -1
local WuhunRH_Index2 = -1
local WuhunRH_Index3 = -1
local WuhunRH_Level = -1
local WuhunRH_Item1ID = -1
local WuhunRH_Item2ID = -1
local WuhunRH_Item3ID = -1
local WuhunRH_Confirm = 0;
local m_slotItem = {-1 , -1 ,-1}
local m_itemAction = {}
local m_SlotDirty = {0 , 0 , 0}
local INDEX_ATTRUP_BEGIN	= 20310122	--���ʯ������1����
local INDEX_ATTRUP_END		= 20310157	--���ʯ������9����
local g_RunHunShi = { 
	
	{
		20310122,	--���ʯ������1����
		20310123,	--���ʯ������2����
		20310124,	--���ʯ������3����
		20310125,	--���ʯ������4����
		20310126,	--���ʯ������5����
		20310127,	--���ʯ������6����
		20310128,	--���ʯ������7����
		20310129,	--���ʯ������8����
		20310130,	--���ʯ������9����
	},
	{
		20310131,	--���ʯ������1����
		20310132,	--���ʯ������2����
		20310133,	--���ʯ������3����
		20310134,	--���ʯ������4����
		20310135,	--���ʯ������5����
		20310136,	--���ʯ������6����
		20310137,	--���ʯ������7����
		20310138,	--���ʯ������8����
		20310139,	--���ʯ������9����
	},
	{
		20310140,	--���ʯ���ƣ�1����
		20310141,	--���ʯ���ƣ�2����
		20310142,	--���ʯ���ƣ�3����
		20310143,	--���ʯ���ƣ�4����
		20310144,	--���ʯ���ƣ�5����
		20310145,	--���ʯ���ƣ�6����
		20310146,	--���ʯ���ƣ�7����
		20310147,	--���ʯ���ƣ�8����
		20310148,	--���ʯ���ƣ�9����
	},

	{
		20310149,	--���ʯ������1����
		20310150,	--���ʯ������2����
		20310151,	--���ʯ������3����
		20310152,	--���ʯ������4����
		20310153,	--���ʯ������5����
		20310154,	--���ʯ������6����
		20310155,	--���ʯ������7����
		20310156,	--���ʯ������8����
		20310157,	--���ʯ������9����
	},
}

--���ʯ���Ľ�Ǯ
local g_RunHunShi_Money = {5000 , 5000 ,10000 ,10000 ,15000 ,15000 ,20000, 20000 }

local isComfirmed = 0
--=========
--PreLoad==
--=========
function WuhunRH_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	
	this:RegisterEvent("RHHC_PUT_ONE");
end
--=========
--OnLoad
--=========
function WuhunRH_OnLoad()
	m_itemAction[1] = WuhunRH_Space1
	m_itemAction[2] = WuhunRH_Space2
	m_itemAction[3] = WuhunRH_Space3

end

function WuhunRH_UpdateItem(Pos)
	if WuhunRH_Index1 == -1 then
		local Index1 = EnumAction(Pos, "packageitem")
		WuhunRH_Item1ID = Index1:GetDefineID();
		if WuhunRH_Item1ID == -1 then
			return
		end
		
		if WuhunRH_Item1ID < 20310122 or WuhunRH_Item1ID > 20310157 then
			PushDebugMessage("N�i n�y ch� c� th� �t v�o Nhu�n H�n Th�ch")
			return
		end
		
		if (WuhunRH_Item1ID >= 20310126 and WuhunRH_Item1ID <= 20310130)
		or (WuhunRH_Item1ID >= 20310135 and WuhunRH_Item1ID <= 20310139)
		or (WuhunRH_Item1ID >= 20310144 and WuhunRH_Item1ID <= 20310148)
		or (WuhunRH_Item1ID >= 20310153 and WuhunRH_Item1ID <= 20310157)
		then
			WuhunRH_Level = 5;
		else
			WuhunRH_Level = 0;
		end
		
		WuhunRH_Space1:SetActionItem(Index1:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunRH_Index1 = Pos
		
	elseif WuhunRH_Index2 == -1 then
		local Index2 = EnumAction(Pos, "packageitem")
		WuhunRH_Item2ID = Index2:GetDefineID();
		if WuhunRH_Item2ID == -1 then
			return
		end
		
		if WuhunRH_Item2ID < 20310122 or WuhunRH_Item2ID > 20310157 then
			PushDebugMessage("N�i n�y ch� c� th� �t v�o Nhu�n H�n Th�ch")
			return
		end
		
		if WuhunRH_Item2ID ~= WuhunRH_Item1ID then
			PushDebugMessage("H�y �t v�o nh�ng Nhu�n H�n Th�ch c�ng lo�i!")
			return
		end
		WuhunRH_Space2:SetActionItem(Index2:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunRH_Index2 = Pos
		
	elseif WuhunRH_Index3 == -1 then
		if WuhunRH_Level == 5 then
			PushDebugMessage("Nhu�n H�n Th�ch c�p 5 tr� l�n khi h�p th�nh ch� c�n 2 vi�n.")
			return
		end
		local Index3 = EnumAction(Pos, "packageitem")
		WuhunRH_Item3ID = Index3:GetDefineID();
		if WuhunRH_Item3ID == -1 then
			return
		end
		
		if WuhunRH_Item3ID < 20310122 or WuhunRH_Item3ID > 20310157 then
			PushDebugMessage("N�i n�y ch� c� th� �t v�o Nhu�n H�n Th�ch")
			return
		end
		
		if WuhunRH_Item3ID ~= WuhunRH_Item1ID then
			PushDebugMessage("H�y �t v�o nh�ng Nhu�n H�n Th�ch c�ng lo�i!")
			return
		end
		WuhunRH_Space3:SetActionItem(Index3:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunRH_Index3 = Pos
	end
	
	if WuhunRH_Level == 0 then 
		if WuhunRH_Index1 ~= -1 and WuhunRH_Index2 ~= -1 and WuhunRH_Index3 ~= -1 then
			local Index1 = EnumAction(WuhunRH_Index1, "packageitem")
			local Index2 = EnumAction(WuhunRH_Index2, "packageitem")
			local Index3 = EnumAction(WuhunRH_Index3, "packageitem")
			
			if Index1:GetDefineID() == Index2:GetDefineID() and Index2:GetDefineID() == Index3:GetDefineID() then
				WuhunRH_SuccessValue:SetText("C� th� h�p th�nh");
				WuhunRH_OK:Enable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 50000)
			else
				WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
				WuhunRH_OK:Disable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
			end
		else
			WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
			WuhunRH_OK:Disable()
			WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
		end
	end
	
	if WuhunRH_Level == 5 then 
		if WuhunRH_Index1 ~= -1 and WuhunRH_Index2 ~= -1 then
			local Index1 = EnumAction(WuhunRH_Index1, "packageitem")
			local Index2 = EnumAction(WuhunRH_Index2, "packageitem")
			
			if Index1:GetDefineID() == Index2:GetDefineID() then
				WuhunRH_SuccessValue:SetText("C� th� h�p th�nh");
				WuhunRH_OK:Enable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 50000)
			else
				WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
				WuhunRH_OK:Disable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
			end
		else
			WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
			WuhunRH_OK:Disable()
			WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
		end
	end
end

function WuhunRH_ClearItem(Num)
	if Num == 1 then
		--if WuhunRH_Index1 ~= -1 then
		--	WuhunRH_Space1:SetActionItem(-1)
		--	LifeAbility:Lock_Packet_Item( WuhunRH_Index1, 0 )
		--	WuhunRH_Index1 = -1
		--end
		WuhunRH_ClearAll()
	end
	
	if Num == 2 then
		if WuhunRH_Index2 ~= -1 then
			WuhunRH_Space2:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item( WuhunRH_Index2, 0 )
			WuhunRH_Index2 = -1
		end
	end
	
	if Num == 3 then
		if WuhunRH_Index3 ~= -1 then
			WuhunRH_Space3:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item( WuhunRH_Index3, 0 )
			WuhunRH_Index3 = -1
		end
	end
	
	if WuhunRH_Level == 0 then 
		if WuhunRH_Index1 ~= -1 and WuhunRH_Index2 ~= -1 and WuhunRH_Index3 ~= -1 then
			local Index1 = EnumAction(WuhunRH_Index1, "packageitem")
			local Index2 = EnumAction(WuhunRH_Index2, "packageitem")
			local Index3 = EnumAction(WuhunRH_Index3, "packageitem")
			
			if Index1:GetDefineID() == Index2:GetDefineID() and Index2:GetDefineID() == Index3:GetDefineID() then
				WuhunRH_SuccessValue:SetText("C� th� h�p th�nh");
				WuhunRH_OK:Enable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 50000)
			else
				WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
				WuhunRH_OK:Disable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
			end
		else
			WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
			WuhunRH_OK:Disable()
			WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
		end
	end
	
	if WuhunRH_Level == 5 then 
		if WuhunRH_Index1 ~= -1 and WuhunRH_Index2 ~= -1 then
			local Index1 = EnumAction(WuhunRH_Index1, "packageitem")
			local Index2 = EnumAction(WuhunRH_Index2, "packageitem")
			
			if Index1:GetDefineID() == Index2:GetDefineID() then
				WuhunRH_SuccessValue:SetText("C� th� h�p th�nh");
				WuhunRH_OK:Enable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 50000)
			else
				WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
				WuhunRH_OK:Disable()
				WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
			end
		else
			WuhunRH_SuccessValue:SetText("Kh�ng th� h�p th�nh");
			WuhunRH_OK:Disable()
			WuhunRH_NeedMoney:SetProperty("MoneyNumber", 0)
		end
	end
end

function WuhunRH_ClearAll()
	if WuhunRH_Index1 ~= -1 then
		WuhunRH_Space1:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunRH_Index1, 0 )
		WuhunRH_Index1 = -1
	end
	
	if WuhunRH_Index2 ~= -1 then
		WuhunRH_Space2:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunRH_Index2, 0 )
		WuhunRH_Index2 = -1
	end
	
	if WuhunRH_Index3 ~= -1 then
		WuhunRH_Space3:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunRH_Index3, 0 )
		WuhunRH_Index3 = -1
	end
end
--=========
--OnEvent
--=========
function WuhunRH_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017) then
		if IsWindowShow("WuhunRH") then
			WuhunRH_UpdateItem(tonumber(arg1))
		end
	end

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunRH_Confirm = 0;
		WuhunRH_BeginCareObj( Get_XParam_INT(0) );
		WuhunRh_CleanUp()
		this:Show();
		WuhunRH_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		WuhunRH_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunRH_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunRH_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "RHHC_PUT_ONE" and this:IsVisible()) then 
		if arg0 ~= nil and arg1 ~= nil then
			WuhunRH_Put_One(tonumber(arg0) , tonumber(arg1))
		end
	elseif event == "PACKAGE_ITEM_CHANGED" and this : IsVisible() then
		if not arg0 or tonumber( arg0 ) == -1 then
			return
		end

		for i = 1, 3 do
			if m_slotItem[i] == tonumber( arg0 ) then
				WuhunRH_TakeOff_One(i)
				break
			end
		end
	end
end

function WuhunRH_Put_One(itemIdx , slot_id)

end
--=========
--Update UI
--=========
function WuhunRH_Update()
	WuhunRH_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	WuhunRH_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

end
--=========
--Care Obj
--=========
function WuhunRH_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end
--=========
--OnOK
--=========
function WuhunRH_OK_Clicked()
	local BindItem1 = Enchase_IsBind(WuhunRH_Index1)
	local BindItem2 = Enchase_IsBind(WuhunRH_Index2)
	local BindItem3 = Enchase_IsBind(WuhunRH_Index3)
	
	if BindItem1 + BindItem2 + BindItem3 >= 1 then
		ShowSystemInfo("BIND_CONFIRM");
		WuhunRH_Confirm = 1;
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(45001)
		Set_XSCRIPT_Parameter(0, 1076) --8 for pos, 01 for function--
		Set_XSCRIPT_Parameter(1, WuhunRH_Index1)
		Set_XSCRIPT_Parameter(2, WuhunRH_Index2)
		Set_XSCRIPT_Parameter(3, WuhunRH_Index3)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	
	WuhunRH_OnHiden()
end

--=========
--handle Hide Event
--=========
function WuhunRH_OnHiden()
	WuhunRH_ClearAll()
	this:Hide();
end

function WuhunRH_Close()
	WuhunRH_ClearAll()
	this:Hide()
end

function WuhunRH_TakeOff_One(idx)
	if m_slotItem[idx] > 0 then
		LifeAbility : Lock_Packet_Item(m_slotItem[idx],0);
		m_itemAction[idx]:SetActionItem(-1);
		m_slotItem[idx] = -1
		m_SlotDirty[idx] = 1
		isComfirmed = 0
		WuhunRH_Update()
	end
end

function WuhunRh_CleanUp()
	for i =1 , 3 do
		if m_slotItem[i] > 0 then
			LifeAbility : Lock_Packet_Item(m_slotItem[i],0);
		end
		m_itemAction[i]:SetActionItem(-1);
		m_slotItem[i] = -1 
		m_m_SlotDirty[i] = 0
	end
	isComfirmed = 0
	WuhunRH_OK:Disable()
	WuhunRH_SuccessValue:SetText("#{WH_xml_XX(51)}")

end
--�õ���ǰUI�����ʯ�ȼ�
function WuhunRH_GetLevel()
	local level = 0
	for i=1 , 3 do
		if m_slotItem[i] >0 then			
			local itemID = PlayerPackage:GetItemTableIndex(m_slotItem[i])
			for j = 1, 4 do
				if itemID >= g_RunHunShi[j][1]  and itemID < g_RunHunShi[j][9]  then
					for k = 1 , 8 do
						if g_RunHunShi[j][k] == itemID then
							level = k
						end
					end
				end
			end
			break
		end
	end
	return level
end
--�õ���ǰUI���м������ʯ
function WuhunRH_GetNum()
	local num = 0
	for i=1 , 3 do
		if m_slotItem[i] > 0 then
			num = num + 1
		end
	end
	return num
end
--ͨ�����ʯ��ID�õ����ʯ�ȼ�
function WuhunRH_GetLevel_By_TableIndex(tableidx)
	local level = 0
	for i = 1, 4 do
		for j = 1 , 9 do
			if g_RunHunShi[i][j] == tableidx then
				level = j
			end
		end
	end
	return level
end