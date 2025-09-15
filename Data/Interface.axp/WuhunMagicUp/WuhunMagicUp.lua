local m_UI_NUM = 20090721
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local WuhunMagicUp_Confirm = 0;
local WuhunMagicUp_Index1 = -1
local WuhunMagicUp_Index2 = -1

local UI_TYPE_ATTR	= 1
local UI_TYPE_COMPOUND	= 2
local UI_TYPE_LIFE	= 3
local UI_TYPE_SLOT	= 4
local UI_PHAMGIA	= 9
local UI_CAMTINH	= 10
local m_UIType = 0

local m_Money_COMPOUND = {}

local INDEX_ATTRBOOK_BEGIN	= 30700214	--Óù¡¤ÕÛ±ùÊôÐÔÊé
local INDEX_ATTRBOOK_END	= 30700229	--±©¡¤°Î¶¾ÊôÐÔÊé

local INDEX_ADDLIFE = 30700233 --ÑÓÊÙµ¤

local INDEX_SLOT_ITEM1 = 20310158 --÷ëÄ¾½£
local INDEX_SLOT_ITEM2 = 20310159 --ÆÆÌì½£

local needMoney = 0

local needConfirm = 1
--PreLoad
function WuhunMagicUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_MAGICUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function WuhunMagicUp_OnLoad()
	--Îä»êºÏ³ÉÏûºÄMoney
	m_Money_COMPOUND[1] = 10000
	m_Money_COMPOUND[2] = 10000
	m_Money_COMPOUND[3] = 15000
	m_Money_COMPOUND[4] = 15000
	m_Money_COMPOUND[5] = 20000
	m_Money_COMPOUND[6] = 20000
	m_Money_COMPOUND[7] = 25000
	m_Money_COMPOUND[8] = 25000
	m_Money_COMPOUND[9] = 30000


end

function WuhunMagicUp_UpdateItem(Pos)
	if WuhunMagicUp_Index1 == -1 then
		local Index1 = EnumAction(Pos, "packageitem")
		local Index1ID = Index1:GetDefineID()
		if Index1ID == -1 then
			return
		end

		if Index1ID < 10308001 or Index1ID > 10308004 then
			PushDebugMessage("N½i này chï có th¬ ð£t vào Võ H°n.")
			return
		end
		WuhunMagicUp_Object1:SetActionItem(Index1:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunMagicUp_Index1 = Pos
	elseif WuhunMagicUp_Index2 == -1 then
		local Index2 = EnumAction(Pos, "packageitem")
		local Index2ID = Index2:GetDefineID()
		if Index2ID == -1 then
			return
		end
		
		--Hoc Ky Nang--
		if m_UIType == UI_TYPE_ATTR then
			if Index2ID < 30700214 or Index2ID > 30700229 then
				PushDebugMessage("N½i này chï có th¬ ð£t vào Sách Thuµc Tính Võ H°n.")
				return
			end
		end
		
		--Hop Thanh--
		if m_UIType == UI_TYPE_COMPOUND then
			if Index2ID < 10308001 or Index2ID > 10308004 then
				PushDebugMessage("N½i này chï có th¬ ð£t vào Võ H°n nguyên li®u.")
				return
			end
		end
		
		--Mo Rong TT--
		if m_UIType == UI_TYPE_SLOT then
			if Index2ID ~= 20310158 and Index2ID ~= 20310159 then
				PushDebugMessage("N½i này chï có th¬ ð£t vào Lân Mµc Ti­n ho£c Phá Thiên Ti­n.")
				return
			end
		end 
		
		--Tay Diem Truong Thanh--
		if m_UIType == UI_PHAMGIA then
			if Index2ID < 30700237 or Index2ID > 30700242 then
				PushDebugMessage("N½i này chï có th¬ ð£t vào H°i Thiên ThÕch.")
				return
			end
		end 
		
		if m_UIType == UI_CAMTINH then
			if Index2ID < 30700243 or Index2ID > 30700245 then
				PushDebugMessage("N½i này chï có th¬ ð£t vào Võ H°n D¸ch Tß¾ng Ðan")
				return
			end
		end 
		
		WuhunMagicUp_Object2:SetActionItem(Index2:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunMagicUp_Index2 = Pos
	end
	
	if WuhunMagicUp_Index1 ~= -1 and WuhunMagicUp_Index2 ~= -1 then
		WuhunMagicUp_OK:Enable()
		WuhunMagicUp_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunMagicUp_OK:Disable()
		WuhunMagicUp_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

--OnEvent
function WuhunMagicUp_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017) then
		if IsWindowShow("WuhunMagicUp") then
			WuhunMagicUp_UpdateItem(tonumber(arg1))
		end
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunMagicUp_Confirm = 0;
		WuhunMagicUp_ClearAll()
		WuhunMagicUp_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)

		if m_UIType == UI_TYPE_ATTR then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(22)}")	--À©Õ¹ÊôÐÔÑ§Ï°
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(23)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(24)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(25)}")

		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(18)}")	--ºÏ³É
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(21)}")

		elseif m_UIType == UI_TYPE_LIFE then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(42)}")	--Ôö¼ÓÊÙÃü
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(43)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(44)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(45)}")

		elseif m_UIType == UI_TYPE_SLOT then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(84)}")	--¿ª±ÙÊôÐÔÀ¸
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(85)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(86)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(87)}")
		elseif m_UIType == UI_PHAMGIA then
			WuhunMagicUp_Title:SetText("#gFF0FA0T¦y LÕi Ph¦m Giá Võ H°n")	--¿ª±ÙÊôÐÔÀ¸
			WuhunMagicUp_Info:SetText("#{WHXCZL_xml_XX(07)}")
			WuhunMagicUp_Info2:SetText("#cfff263Hãy ðßa vào Võ H°n c¥n t¦y tï l® trß·ng thành:")
			WuhunMagicUp_Info3:SetText("#cfff263Hãy ðßa vào Th¥n ThÕch:")
		elseif m_UIType == UI_CAMTINH then
			WuhunMagicUp_Title:SetText("#gFF0FA0Thay Ð±i C¥m Tinh Võ H°n")	--¿ª±ÙÊôÐÔÀ¸
			WuhunMagicUp_Info:SetText("#{WHGBSX_091015_01}")
			WuhunMagicUp_Info2:SetText("#cfff263Hãy ðßa vào Võ H°n c¥n thay ð±i c¥m tinh:")
			WuhunMagicUp_Info3:SetText("C¥n ðßa vào Võ H°n D¸ Tß½ng Ðan:")
		end

		WuhunMagicUp_Update(-1)
		WuhunMagicUp_Update_Sub(-1)
		this:Show();

	--elseif (event == "UPDATE_KFS_MAGICUP" and this:IsVisible() ) then
  elseif (event == "UI_COMMAND" and tonumber(arg0) == 20170124) then
		if m_UIType == UI_TYPE_COMPOUND then
			if arg2 ~= nil and tonumber(arg2) == 2 and arg1 ~= nil then
				if m_Equip_Idx ~= -1 then
					WuhunMagicUp_Update_Sub( tonumber(arg1) )
				else
					WuhunMagicUp_Update( tonumber(arg1) )
				end
			elseif arg2 ~= nil and tonumber(arg2) == 1 and arg1 ~= nil then
				WuhunMagicUp_Update_Sub( tonumber(arg1) )
			elseif arg2 ~= nil and tonumber(arg2) == 0 and arg1 ~= nil then
				WuhunMagicUp_Update( tonumber(arg1) )
			end
		else
			if arg2 ~= nil and tonumber(arg2) == 0 and arg1 ~= nil then
				WuhunMagicUp_Update( tonumber(arg1) )

			elseif arg2 ~= nil and tonumber(arg2) == 2 and arg1 ~= nil then
				WuhunMagicUp_Update( tonumber(arg1) )

			elseif arg2 ~= nil and tonumber(arg2) == 1 and arg1 ~= nil then
				WuhunMagicUp_Update_Sub( tonumber(arg1) )
			end
		end

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunMagicUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		WuhunMagicUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunMagicUp_Update(m_Equip_Idx)

		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunMagicUp_Update_Sub(m_Equip_Item)

		end
	end
end

--Update UI
function WuhunMagicUp_Update(itemIdx)
	WuhunMagicUp_UICheck();
end

function WuhunMagicUp_Update_Sub(itemIdx)
	WuhunMagicUp_UICheck()
end

--Care Obj
function WuhunMagicUp_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function WuhunMagicUp_OK_Clicked()
	-- if Enchase_IsBind(WuhunMagicUp_Index2) == 1 then
		-- if WuhunMagicUp_Confirm == 0 then
			-- ShowSystemInfo("BIND_CONFIRM");
			-- WuhunMagicUp_Confirm = 1;
			-- return
		-- end
	-- end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(45001)
		Set_XSCRIPT_Parameter(0, 10*100+m_UIType) --10 for pos, 01 for function--
		Set_XSCRIPT_Parameter(1, WuhunMagicUp_Index1)
		Set_XSCRIPT_Parameter(2, WuhunMagicUp_Index2)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	
	WuhunMagicUp_ClearAll()
	if m_UIType ~= UI_PHAMGIA then
		WuhunMagicUp_OnHiden()
	end
end

--Right button clicked
function WuhunMagicUp_Resume_Equip()

	WuhunMagicUp_Update(-1)

end

--Right button clicked
function WuhunMagicUp_Resume_Item()

	WuhunMagicUp_Update_Sub(-1)

end

--handle Hide Event
function WuhunMagicUp_OnHiden()
	WuhunMagicUp_ClearAll()
	this:Hide()
end

function WuhunMagicUp_ClearAll()
	if WuhunMagicUp_Index1 ~= -1 then
		WuhunMagicUp_Object1:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunMagicUp_Index1, 0 )
		WuhunMagicUp_Index1 = -1
	end
	
	if WuhunMagicUp_Index2 ~= -1 then
		WuhunMagicUp_Object2:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunMagicUp_Index2, 0 )
		WuhunMagicUp_Index2 = -1
	end
end

function WuhunMagicUp_UICheck()
	WuhunMagicUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunMagicUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
end

function WuhunMagicUp_ClearItem(Num)
	if Num == 1 then
		if WuhunMagicUp_Index1 ~= -1 then
			WuhunMagicUp_Object1:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item( WuhunMagicUp_Index1, 0 )
			WuhunMagicUp_Index1 = -1
		end
	end
	
	if Num == 2 then
		if WuhunMagicUp_Index2 ~= -1 then
			WuhunMagicUp_Object2:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item( WuhunMagicUp_Index2, 0 )
			WuhunMagicUp_Index2 = -1
		end
	end
	
	if WuhunMagicUp_Index1 == -1 or WuhunMagicUp_Index2 == -1 then
		WuhunMagicUp_DemandMoney:SetProperty("MoneyNumber", 0)
		WuhunMagicUp_OK:Disable()
	end
end

--Help
function WuhunMagicUp_Help_Clicked()
	if m_UIType == UI_TYPE_ATTR then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	elseif m_UIType == UI_TYPE_COMPOUND then
		Helper:GotoHelper("*WuhunMagicUp")
	elseif m_UIType == UI_TYPE_LIFE then
		Helper:GotoHelper("*Wuhun")
	elseif m_UIType == UI_TYPE_SLOT then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	end

end
