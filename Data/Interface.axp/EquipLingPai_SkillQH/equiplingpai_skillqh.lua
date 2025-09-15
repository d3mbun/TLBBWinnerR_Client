local m_EquipBagIndex = -1
local EquipLingPai_SkillQH_Update_AfterQH = -1

local g_ObjCared = -1
local g_UI_Command = 201405054
local g_UI_Command_Refresh = 201406284

local g_RS_UnActived_Image  = "set:CommonFrame25 image:EquipLingPai_Feng"    --- Î´´ò¿×

local g_SkillQH_NeedMoney = 100000

local g_MainFram_UnifiedPosition

--¿Ø¼þ±äÁ¿
local m_MainFram
local m_ActionButton_Equip
local m_Button_OK
local m_StaticText_NeedMoney
local m_StaticText_HaveJZ
local m_StaticText_HaveMoney
local m_Text_CurrentSkill
local m_Text_SkillSelInfo
local m_Text_SkillList

function EquipLingPai_SkillQH_PreLoad( )

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RL_SKILL_PUTIN_EQUIP")
	this:RegisterEvent("RL_SKILL_PACKET_RCLICK")
	this:RegisterEvent("RL_SKILL_REMOVE_EQUIP")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function EquipLingPai_SkillQH_OnLoad( )


	
	m_MainFram = EquipLingPai_SkillQH_Frame
	m_ActionButton_Equip = EquipLingPai_SkillQH_InputIcon
	m_Button_OK = EquipLingPai_SkillQH_OK
	
	m_StaticText_NeedMoney =  EquipLingPai_SkillQH_WantNum
	m_StaticText_HaveJZ =  EquipLingPai_SkillQH_HaveNum
	m_StaticText_HaveMoney =  EquipLingPai_SkillQH_HaveGoldNum
	
	m_Text_CurrentSkill = EquipLingPai_SkillQH_CurrentSkillNameText

	m_Text_SkillSelInfo = EquipLingPai_SkillQH_NameShuomingText
	m_Text_SkillList = EquipLingPai_SkillQH_SkillZiKuang
	
	g_MainFram_UnifiedPosition = m_MainFram:GetProperty( "UnifiedPosition" )

end

function EquipLingPai_SkillQH_OnEvent( event )

	if ( event == "UI_COMMAND" ) and tonumber( arg0 ) == g_UI_Command then
		EquipLingPai_SkillQH_Init()
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
	
	if ( event == "UI_COMMAND" ) and tonumber( arg0 ) == g_UI_Command_Refresh and this:IsVisible() then
		
		EquipLingPai_SkillQH_Update_AfterQH()
		return
		
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if arg1 ~= nil then
			EquipLingPai_SkillQH_OnItemDragedDropFromBag( tonumber(arg1)  )
		end
	end
	
	if (event == "RL_SKILL_PACKET_RCLICK"  and this:IsVisible()) then
		if arg0 ~= nil  then
			EquipLingPai_SkillQH_OnBagItemRClicked( tonumber(arg0)  )
		end
		return
	end 
	
	if (event == "RL_SKILL_REMOVE_EQUIP"  and this:IsVisible()) then
		EquipLingPai_SkillQH_OnItemDragedDropAway()
		return
	end 

	if event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
            EquipLingPai_SkillQH_CleanUp()
			this:Hide()
		end
		return
	end
	
	if event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
            EquipLingPai_SkillQH_CleanUp()
			this:Hide()
		end
		return
	end
	
	if event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
            EquipLingPai_SkillQH_CleanUp()
			this:Hide()
		end
		return
	end
	
	if (event == "ADJEST_UI_POS" ) then
		EquipLingPai_SkillQH_On_ResetPos()
		return
	end
	
	if (event == "VIEW_RESOLUTION_CHANGED") then
		EquipLingPai_SkillQH_On_ResetPos()
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
end

--WindowÇå¿Õ
function EquipLingPai_SkillQH_CleanUp()
	
	m_ActionButton_Equip:SetActionItem(-1)
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end

	m_EquipBagIndex = -1

	m_Text_SkillList:ClearListBox()
	m_StaticText_NeedMoney:SetProperty("MoneyNumber", "0")
	m_Button_OK:Disable()

end

--Window»Ö¸´Ä¬ÈÏ×´Ì¬
function EquipLingPai_SkillQH_Init()
	
	EquipLingPai_SkillQH_CleanUp()
	m_Text_CurrentSkill:SetText("")		
	m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	nBuffName={"Hàn Bång Hóa Kình","Viêm Khí Hóa Kình","Huy«n Pháp Hóa Kình","Bách Ðµc Hóa Kình","TÑ Tßþng Quy Nh¤t-Bång","TÑ Tßþng Quy Nh¤t-Höa","TÑ Tßþng Quy Nh¤t-Huy«n","TÑ Tßþng Quy Nh¤t-Ðµc","Khí Ð¸nh Th¥n Nhàn","Khí Xung Tiêu Hán",}
	for i = 1 , 10 do		
		m_Text_SkillList:AddItem(nBuffName[i], i-1)
	end
	m_Text_SkillList:SetItemSelect(0)	
end

function EquipLingPai_SkillQH_NoEqup()

	m_ActionButton_Equip:SetActionItem(-1)
	
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end

	m_StaticText_NeedMoney:SetProperty("MoneyNumber", 100000)
	
end
--Ë¢ÐÂ½çÃæ
function EquipLingPai_SkillQH_Refresh()
	
	if m_EquipBagIndex == -1 then
		EquipLingPai_SkillQH_NoEqup()
		return		
	end
	local theAction = EnumAction(m_EquipBagIndex, "packageitem")
	if theAction:GetID() == 0 then
		return
	end
	local itemID = PlayerPackage:GetItemTableIndex(m_EquipBagIndex)
	if itemID <10155201 or itemID >10155249 then
	PushDebugMessage("Hãy ð£t 1 L®nh Bài vào")
	return
	end
	n1=0
	local szAuthor = SuperTooltips:GetAuthorInfo();
	if szAuthor~=nil and string.len(szAuthor)>=50 then
		_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,
		_,_,_,_,_,_,_,_,_,n1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_=CheckAuthorType(szAuthor)
	end
	nBuffName={"Hàn Bång Hóa Kình","Viêm Khí Hóa Kình","Huy«n Pháp Hóa Kình","Bách Ðµc Hóa Kình","TÑ Tßþng Quy Nh¤t-Bång","TÑ Tßþng Quy Nh¤t-Höa","TÑ Tßþng Quy Nh¤t-Huy«n","TÑ Tßþng Quy Nh¤t-Ðµc","Khí Ð¸nh Th¥n Nhàn","Khí Xung Tiêu Hán",}
	if n1 ==nil or n1<=0 then
		m_Text_CurrentSkill:SetText("(Chßa h÷c)")
	else
		m_Text_CurrentSkill:SetText(nBuffName[n1])
	end
	m_ActionButton_Equip:SetActionItem(theAction:GetID())
	LifeAbility : Lock_Packet_Item(m_EquipBagIndex,1)
	m_Button_OK:Enable()
	
end

--´Ó±³°üÍÏ×§µ½UI
function EquipLingPai_SkillQH_OnItemDragedDropFromBag( iBagIndex )
	
	--ÊÇ·ñ¼ÓËø
	if PlayerPackage:IsLock( iBagIndex ) == 1 then
		PushDebugMessage("#{BSZK_121012_17}")	--µÀ¾ßÒÑÉÏËø
		return
	end

	--ÊÍ·ÅÔ­À´µÄ×°±¸
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	m_Text_CurrentSkill:SetText("")	
	
	EquipLingPai_SkillQH_NoEqup()
	m_EquipBagIndex = iBagIndex
	--Ë¢ÐÂ½çÃæ
	EquipLingPai_SkillQH_Refresh()
	
end

--´Ó±³°üÄÚÓÒ¼üµã»÷
function EquipLingPai_SkillQH_OnBagItemRClicked( iBagIndex )
	
	--ÊÇ·ñ¼ÓËø
	if PlayerPackage:IsLock( iBagIndex ) == 1 then
		PushDebugMessage("#{BSZK_121012_17}")	--µÀ¾ßÒÑÉÏËø
		return
	end
	
	--ÊÍ·ÅÔ­À´µÄ×°±¸
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	
	EquipLingPai_SkillQH_NoEqup()
	m_EquipBagIndex = iBagIndex
	--Ë¢ÐÂ½çÃæ
	EquipLingPai_SkillQH_Refresh()

end

--´ÓActionItemÍÏ×§µ½WindowÖ®Íâ
function EquipLingPai_SkillQH_OnItemDragedDropAway()
	
	EquipLingPai_SkillQH_NoEqup()

end

--ÓÒ¼üµ¥»÷ActionItem
function EquipLingPai_SkillQH_OnActionItemRClicked()
	
	EquipLingPai_SkillQH_NoEqup()

end

function EquipLingPai_SkillQH_OnSelectedChange()
	
	local nSelIdx = m_Text_SkillList:GetFirstSelectItem()
	local nBuffBaseString ={
		"Hàn Bång Hóa Kinh: Có xác su¤t kích hoÕt Hóa Kinh H® Bång, giúp bän thân tång 200 ði¬m Bång công, duy trì 2 giây, hi®u quä này trong 30 giây kích hoÕt 1 l¥n",
		"Li®t Höa Hóa Kinh: Có xác su¤t kích hoÕt Hóa Kinh H® Höa, giúp bän thân tång 200 ði¬m Höa công, duy trì 2 giây, hi®u quä này trong 30 giây kích hoÕt 1 l¥n",
		"Huy«n Lôi Hóa Kinh: Có xác su¤t kích hoÕt Hóa Kinh H® Huy«n, giúp bän thân tång 200 ði¬m Huy«n công, duy trì 2 giây, hi®u quä này trong 30 giây kích hoÕt 1 l¥n",
		"Huyªt Ðµc Hóa Kinh: Có xác su¤t kích hoÕt Hóa Kinh H® Ðµc, giúp bän thân tång 200 ði¬m Ðµc công, duy trì 2 giây, hi®u quä này trong 30 giây kích hoÕt 1 l¥n",
		"TÑ Tßþng Quy Nh¤t-Bång: T¤n công có xác su¤t kích hoÕt, chuy¬n hóa sát thß½ng höa, huy«n, ðµc thành sát thß½ng bång trong 2 giây, 30 giây kích hoÕt 1 l¥n",
		"TÑ Tßþng Quy Nh¤t-Höa: T¤n công có xác su¤t kích hoÕt, chuy¬n hóa sát thß½ng bång, huy«n, ðµc thành sát thß½ng höa trong 2 giây, 30 giây kích hoÕt 1 l¥n",
		"TÑ Tßþng Quy Nh¤t-Huy«n: T¤n công có xác su¤t kích hoÕt, chuy¬n hóa sát thß½ng bång, höa, ðµc thành sát thß½ng huy«n trong 2 giây, 30 giây kích hoÕt 1 l¥n",
		"TÑ Tßþng Quy Nh¤t-Ðµc: T¤n công có xác su¤t kích hoÕt, chuy¬n hóa sát thß½ng bång, höa, huy«n thành sát thß½ng ðµc trong 2 giây, 30 giây kích hoÕt 1 l¥n",
		"Khí Ð¸nh Th¥n Nhàn: T¤n công có xác su¤t kích hoÕt, nh§n 10 ði¬m kháng chí mÕng trong 10 giây, 30 giây kích hoÕt 1 l¥n",
		"Khí Xung Tiêu Hán: T¤n công có xác su¤t kích hoÕt, t¯c ðµ nh§n nµ khí +30% trong 10 giây, 30 giây kích hoÕt 1 l¥n",}
	m_Text_SkillSelInfo:SetText(nBuffBaseString[nSelIdx+1])	
	if m_EquipBagIndex ~= -1 then	
		m_StaticText_NeedMoney:SetProperty("MoneyNumber", tostring(g_SkillQH_NeedMoney))	
	end
	
end

--µã»÷OK
function EquipLingPai_SkillQH_OnOkClicked()

	local nSelIdx = m_Text_SkillList:GetFirstSelectItem()
	if nSelIdx == -1 then
		PushDebugMessage("#{BHZB_140521_205} ")		
		return
	end
	if m_EquipBagIndex == -1 then
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "ActionPingPai" );
		Set_XSCRIPT_ScriptID( 880001 );
		Set_XSCRIPT_Parameter( 0, 5 ); 
		Set_XSCRIPT_Parameter( 1, m_EquipBagIndex );        
		Set_XSCRIPT_Parameter( 2, nSelIdx+1   );        
		Set_XSCRIPT_ParamCount( 3 );
	Send_XSCRIPT();	
	EquipLingPai_SkillQH_OnCloseClicked()
end

--µã»÷Cancel
function EquipLingPai_SkillQH_OnCancelClicked()

	EquipLingPai_SkillQH_CleanUp()
	this:Hide()

end

--µã»÷"X"
function EquipLingPai_SkillQH_OnCloseClicked()

	EquipLingPai_SkillQH_CleanUp()
	this:Hide()
	
end

function EquipLingPai_SkillQH_OnHiden()

	EquipLingPai_SkillQH_CleanUp()
	
end

function EquipLingPai_SkillQH_On_ResetPos()

	m_MainFram:SetProperty( "UnifiedPosition", g_MainFram_UnifiedPosition )
	
end

function EquipLingPai_SkillQH_Update_AfterQH()
	
	local nEquipBagIndex = m_EquipBagIndex
	EquipLingPai_SkillQH_NoEqup()
		
	m_EquipBagIndex = nEquipBagIndex
	EquipLingPai_SkillQH_Refresh()
end