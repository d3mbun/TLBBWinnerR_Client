local m_EquipBagIndex = -1
local m_CurSel_Rs = -1
local m_Rs_Idx = {}

local g_ObjCared = -1
local g_UI_Command = 201405043

local g_RS_UnActived_Image  = "set:CommonFrame25 image:EquipLingPai_Feng"    --- Î´´ò¿×

local g_MainFram_UnifiedPosition

local g_RsLevelUp_NeedItem = 38000601
local g_RsLevelUp_NeedItem_Num = {
6,6,6,7,7,7,9,9,9,12,12,12,16,16,16,21,21,21,27,27,27,34,34,34,42,42,42,
51,51,51,61,61,61,72,72,72,84,84,84,97,97,97,111,111,111,126,126,126,126
}

local g_UnActived_tip = {"" , "#{BHZB_140521_169}" , "#{BHZB_140521_170}" , "#{BHZB_140521_171}"}
local g_SJ_NeedMoney = 50000
--¿Ø¼þ±äÁ¿
local m_MainFram
local m_ActionButton_Equip
local m_ActionButton_Rs = {}
local m_Text_RsLevel = {}
local m_Image_NoMove = {}
local m_Button_OK
local m_Text_CurLevel
local m_Text_NeedItem
local m_Text_NeedNum
local m_CheckButton_Page = {}

local m_StaticText_NeedMoney
local m_StaticText_HaveJZ
local m_StaticText_HaveMoney

function EquipLingPai_OperatingSJ_PreLoad( )

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RL_OPSJ_PUTIN_EQUIP")
	this:RegisterEvent("RL_OPSJ_PACKET_RCLICK")
	this:RegisterEvent("RL_OPSJ_REMOVE_EQUIP")
	this:RegisterEvent("OPEN_RLOPPAGE")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")

	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function EquipLingPai_OperatingSJ_OnLoad( )

	
	
	m_MainFram = EquipLingPai_OperatingSJ_Frame
	m_ActionButton_Equip = EquipLingPai_OperatingSJ_InputIcon
	m_Button_OK = EquipLingPai_OperatingSJ_OK
	
	m_ActionButton_Rs[1] = EquipLingPai_OperatingSJ_FirstGem
	m_ActionButton_Rs[2] = EquipLingPai_OperatingSJ_SecondGem
	m_ActionButton_Rs[3] = EquipLingPai_OperatingSJ_ThirdGem
	m_ActionButton_Rs[4] = EquipLingPai_OperatingSJ_FourthGem
	
	m_Text_RsLevel[1] = EquipLingPai_OperatingSJ_FirstGrade
	m_Text_RsLevel[2] = EquipLingPai_OperatingSJ_SecondGrade
	m_Text_RsLevel[3] = EquipLingPai_OperatingSJ_ThirdGrade
	m_Text_RsLevel[4] = EquipLingPai_OperatingSJ_FourthGrade
	
	m_Image_NoMove[1] = EquipLingPai_OperatingSJ_FirstTuCeng
	m_Image_NoMove[2] = EquipLingPai_OperatingSJ_SecondTuCeng
	m_Image_NoMove[3] = EquipLingPai_OperatingSJ_ThirdTuCeng
	m_Image_NoMove[4] = EquipLingPai_OperatingSJ_FourthTuCeng
	
	m_Text_CurLevel = EquipLingPai_OperatingSJ_Text
	m_Text_NeedItem = EquipLingPai_OperatingSJ_Text1
	m_Text_NeedNum = EquipLingPai_OperatingSJ_Text2
	
	m_CheckButton_Page[1] = EquipLingPai_OperatingSJ_Page1
	m_CheckButton_Page[2] = EquipLingPai_OperatingSJ_Page2
	m_CheckButton_Page[3] = EquipLingPai_OperatingSJ_Page3
	
	m_StaticText_NeedMoney =  EquipLingPai_OperatingSJ_WantNum
	m_StaticText_HaveJZ =  EquipLingPai_OperatingSJ_HaveNum
	m_StaticText_HaveMoney =  EquipLingPai_OperatingSJ_HaveGoldNum

	g_MainFram_UnifiedPosition = m_MainFram:GetProperty( "UnifiedPosition" )

end

function EquipLingPai_OperatingSJ_OnEvent( event )
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 201405043) then
		
		EquipLingPai_OperatingSJ_Init()
		this:Show()
		g_ObjCared = tonumber( Get_XParam_INT(0) )
		if g_ObjCared == -1 then
			return
		end
		this:CareObject( g_ObjCared, 1)

	return
	end
	
	if ( event == "UI_COMMAND" ) and tonumber( arg0 ) == g_UI_Command then
		EquipLingPai_OperatingSJ_Init()
		this:Show()
		g_ObjCared = -1
		local nServerID = Get_XParam_INT( 0 )
		g_ObjCared = DataPool : GetNPCIDByServerID( nServerID )
		if g_ObjCared == -1 then
			return
		end
		this:CareObject( g_ObjCared, 1)
		return
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if arg1 ~= nil then
			EquipLingPai_OperatingSJ_OnItemDragedDropFromBag( tonumber(arg1)  )
		end
	end
	
	if (event == "RL_OPSJ_PACKET_RCLICK"  and this:IsVisible()) then
		if arg0 ~= nil  then
			EquipLingPai_OperatingSJ_OnBagItemRClicked( tonumber(arg0)  )
		end
		return
	end 
	
	if (event == "RL_OPSJ_REMOVE_EQUIP"  and this:IsVisible()) then
		EquipLingPai_OperatingSJ_OnItemDragedDropAway()
		return
	end 

	if event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
            EquipLingPai_OperatingSJ_CleanUp()
			this:Hide()
		end
		return
	end
	
	if event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
            EquipLingPai_OperatingSJ_CleanUp()
			this:Hide()
		end
		return
	end
	
	if event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
            EquipLingPai_OperatingSJ_CleanUp()
			this:Hide()
		end
		return
	end
	
	if (event == "ADJEST_UI_POS" ) then
		EquipLingPai_OperatingSJ_On_ResetPos()
		return
	end
	
	if (event == "VIEW_RESOLUTION_CHANGED") then
		EquipLingPai_OperatingSJ_On_ResetPos()
		return
	end
	
	if (event == "UNIT_MONEY") then
		m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if (event == "MONEYJZ_CHANGE") then
		m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if (event == "PACKAGE_ITEM_CHANGED") then
		
		if this:IsVisible() and arg0 ~= nil and tonumber(arg0) == m_EquipBagIndex then
		
			EquipLingPai_OperatingSJ_Update_AfterLevelup()	
			
		end
		return
	end
end

--WindowÇå¿Õ
function EquipLingPai_OperatingSJ_CleanUp()
	
	m_ActionButton_Equip:SetActionItem(-1)
	
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end

	m_EquipBagIndex = -1
		
	for i=1,4 do
	
		m_ActionButton_Rs[i]:SetActionItem(-1)
		m_ActionButton_Rs[i]:SetProperty( "BackImage", "" )
		m_ActionButton_Rs[i]:SetToolTip( "" )

		m_Text_RsLevel[i]:SetText("")
		m_Image_NoMove[i]:Hide()
	end
	
	m_Rs_Idx = {}
	
	m_CurSel_Rs = -1
	m_Button_OK:Disable()
	
	
	m_Text_CurLevel:SetText("#{BHZB_140521_172}")
	m_Text_NeedItem:SetText("#{BHZB_140521_174}")
	m_Text_NeedNum:SetText("#{BHZB_140521_175}")
	
	m_StaticText_NeedMoney:SetProperty("MoneyNumber", "0")

end

--Window»Ö¸´Ä¬ÈÏ×´Ì¬
function EquipLingPai_OperatingSJ_Init()
	
	EquipLingPai_OperatingSJ_CleanUp()
	m_CheckButton_Page[1]:SetCheck(1)
	m_CheckButton_Page[2]:SetCheck(0)
	m_CheckButton_Page[3]:SetCheck(0)
	
	m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

end

--Ë¢ÐÂ½çÃæ
function EquipLingPai_OperatingSJ_Refresh()
	
	if m_EquipBagIndex == -1 then
		EquipLingPai_OperatingSJ_Init()
		return
	end
	
	
	local theAction = EnumAction(m_EquipBagIndex, "packageitem")
	if theAction:GetID() == 0 then
		EquipLingPai_OperatingSJ_Init()
		return
	end
	local itemID = PlayerPackage:GetItemTableIndex(m_EquipBagIndex)
	if itemID <10155201 or itemID >10155249 then
	PushDebugMessage("Hãy ð£t 1 L®nh Bài vào")
	return
	end
	m_ActionButton_Equip:SetActionItem(theAction:GetID())
	LifeAbility : Lock_Packet_Item(m_EquipBagIndex,1)
	u2,a,b,c,d,a11,b11,c11,d11=1,0,0,0,0,0,0,0,0
	local szAuthor = SuperTooltips:GetAuthorInfo();
	if szAuthor~=nil and string.len(szAuthor)>=50 then
		_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,
		u2,a,a11,b,b11,c,c11,d,d11,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_=CheckAuthorType(szAuthor)
	end	
	for i=1,4 do
		m_ActionButton_Rs[i]:SetPushed(0)
		m_ActionButton_Rs[i]:SetActionItem(-1)
		m_Image_NoMove[i]:Hide()
		m_Rs_Idx[i] = -3
		if u2 <i then
		m_ActionButton_Rs[i]:SetProperty( "BackImage", g_RS_UnActived_Image )
		m_ActionButton_Rs[i]:SetToolTip( g_UnActived_tip[i] )
		m_Text_RsLevel[i]:SetText("#cfff263Chßa m·")
		else
		m_ActionButton_Rs[i]:SetActionItem(-1)
		m_ActionButton_Rs[i]:SetProperty( "BackImage", "" )
		m_Text_RsLevel[i]:SetText("#{BHZB_140521_58}")
		end		
	end	
	if u2 == nil or u2 <1 then 
		return
	end	
	local xBC={}
	xBC[1] ={20800001,20800002,20800003,20800004,20800005,20800006}
	xBC[2] ={20800007,20800008,20800009,20800010}
	xBC[3] ={20800011,20800012,20800013,20800014}
	xBC[4] ={20800015,20800016,20800017,20800018,20800019,20800020}	
	local Gem ={a,b,c,d}
	local GemLv={a11,b11,c11,d11}
	for i =1, 4 do
		if Gem[i] >0 then
			local Prize = GemMelting:UpdateProductAction(xBC[i][Gem[i]])
			if Prize:GetID() ~= 0 then
			m_ActionButton_Rs[i]:SetActionItem( Prize:GetID())
			m_Text_RsLevel[i]:SetText(""..GemLv[i].." c¤p")	
			m_Image_NoMove[i]:Show()
			end		
		end	
	end

end

--´Ó±³°üÍÏ×§µ½UI
function EquipLingPai_OperatingSJ_OnItemDragedDropFromBag( iBagIndex )
	--ÊÍ·ÅÔ­À´µÄ×°±¸
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	
	EquipLingPai_OperatingSJ_Init()
	m_EquipBagIndex = iBagIndex
	--Ë¢ÐÂ½çÃæ
	EquipLingPai_OperatingSJ_Refresh()
	
end

--´Ó±³°üÄÚÓÒ¼üµã»÷
function EquipLingPai_OperatingSJ_OnBagItemRClicked( iBagIndex )
	
	--Èç¹ûÊÇ±¦Öé £¬ÌáÊ¾È¥ÏâÇ¶Ò³Ãæ
	if PlayerPackage:Lua_IsBagItemRS( iBagIndex ) == 1 then
		PushDebugMessage("#{BHZB_140521_259}")	--ÌáÊ¾È¥ÏâÇ¶Ò³Ãæ
		return
	end
	
	--ÊÇ·ñÊÇÁîÅÆ
	if PlayerPackage:Lua_IsBagItemRL( iBagIndex ) ~= 1 then
		PushDebugMessage("#{BHZB_140521_69}")	
		return
	end
	
	--ÊÍ·ÅÔ­À´µÄ×°±¸
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	
	EquipLingPai_OperatingSJ_Init()
	m_EquipBagIndex = iBagIndex
	--Ë¢ÐÂ½çÃæ
	EquipLingPai_OperatingSJ_Refresh()

end

--´ÓActionItemÍÏ×§µ½WindowÖ®Íâ
function EquipLingPai_OperatingSJ_OnItemDragedDropAway(  )
	
	EquipLingPai_OperatingSJ_CleanUp()
	EquipLingPai_OperatingSJ_Init()

end

--ÓÒ¼üµ¥»÷ActionItem
function EquipLingPai_OperatingSJ_OnActionItemRClicked(  )
	
	EquipLingPai_OperatingSJ_CleanUp()
	EquipLingPai_OperatingSJ_Init()

end

--×ó¼üµ¥»÷ActionItem
function EquipLingPai_OperatingSJ_OnActionItemLClicked( nIndex )

	if m_Rs_Idx[nIndex] ~= nil and m_Rs_Idx[nIndex] == -3 then
		if m_ActionButton_Rs[m_CurSel_Rs] ~= nil then
			m_ActionButton_Rs[m_CurSel_Rs]:SetPushed(0)
		end
		m_CurSel_Rs = nIndex
		local Item_Num = {6,12,27,42,62,84,97,111,126}
		local LVBC ={a11,b11,c11,d11}
		if LVBC[nIndex] <=0 then
		PushDebugMessage("Bäo Châu chßa khäm")	--ÌáÊ¾È¥ÏâÇ¶Ò³Ãæ
		return
		end
		
		m_StaticText_NeedMoney:SetProperty("MoneyNumber", 1000000)
		m_Text_CurLevel:SetText("#{BHZB_140521_172} C¤p "..LVBC[nIndex])
		m_Text_NeedItem:SetText("#{BHZB_140521_174} Phï Thúy Tâm Tinh")
		m_Text_NeedNum:SetText("#{BHZB_140521_175}"..Item_Num[LVBC[nIndex]])
		m_ActionButton_Rs[m_CurSel_Rs]:SetPushed(1)
		m_Button_OK:Enable()
	end
	
end

--µã»÷·ÖÒ³
function EquipLingPai_OperatingSJ_OnPageButtonClicked(nIndex)
	
	Variable:SetVariable("RL_OP_Pos", m_MainFram:GetProperty("UnifiedPosition"), 1)

	local UI ={201405043,201405042,201405045,201405044}
	PushEvent("UI_COMMAND",UI[nIndex])

end
--µã»÷OK
function EquipLingPai_OperatingSJ_OnOkClicked(  )

	if m_CurSel_Rs  == -1 then
		return
	end
	
	if m_EquipBagIndex == -1 then
		return
	end
	
	if m_Rs_Idx[m_CurSel_Rs] == -3 then  --Éý¼¶ÒÑÏâÇ¶µÄ·ûÊ¯
	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name( "ActionPingPai" );
			Set_XSCRIPT_ScriptID( 880001 );
			Set_XSCRIPT_Parameter( 0, 3  );
			Set_XSCRIPT_Parameter( 1, m_EquipBagIndex     );         --- ×°±¸±³°üË÷Òý
			Set_XSCRIPT_Parameter( 2, m_CurSel_Rs  - 1   );        --- ÏâÇ¶µÄ·ûÊ¯Ë÷Òý
			Set_XSCRIPT_ParamCount( 3 );
		Send_XSCRIPT();	
		EquipLingPai_OperatingSJ_Init()
		return
	end
end

--µã»÷Cancel
function EquipLingPai_OperatingSJ_OnCancelClicked(  )

	EquipLingPai_OperatingSJ_CleanUp()
	this:Hide()

end

--µã»÷"X"
function EquipLingPai_OperatingSJ_OnCloseClicked(  )

	EquipLingPai_OperatingSJ_CleanUp()
	this:Hide()
	
end

function EquipLingPai_OperatingSJ_OnHiden(  )

	EquipLingPai_OperatingSJ_CleanUp()
	
end

function EquipLingPai_OperatingSJ_On_ResetPos()

	m_MainFram:SetProperty( "UnifiedPosition", g_MainFram_UnifiedPosition )
	
end

function EquipLingPai_OperatingSJ_Update_AfterLevelup()
	
	local nEquipBagIndex = m_EquipBagIndex
	local nCurSel_Rs = m_CurSel_Rs
	EquipLingPai_OperatingSJ_Init()
	
	m_EquipBagIndex = nEquipBagIndex
	EquipLingPai_OperatingSJ_Refresh()
	EquipLingPai_OperatingSJ_OnActionItemLClicked( nCurSel_Rs )
	
end