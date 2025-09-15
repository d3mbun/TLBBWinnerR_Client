local m_EquipBagIndex = -1

local g_ObjCared = -1
local g_UI_Command = 201406285

local g_MainFram_UnifiedPosition

local g_NeedMoney = 20000

--控件变量
local m_MainFram
local m_ActionButton_Equip
local m_Button_OK
local m_Text_StarInfo
local m_Text_NextStarInfo
local m_Text_Success
local m_Text_MustSuccessNum

local m_Text_CurLevel
local m_Text_NeedItem
local m_Text_NeedNum
local m_CheckButton_Page = {}

local m_StaticText_NeedMoney
local m_StaticText_HaveJZ
local m_StaticText_HaveMoney

function EquipLingPai_Star_PreLoad( )

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RL_STAR_PUTIN_EQUIP")	
	this:RegisterEvent("RL_STAR_PACKET_RCLICK")	
	this:RegisterEvent("RL_STAR_REMOVE_EQUIP")
	this:RegisterEvent("MONEY_CHANGE_EX")
	this:RegisterEvent("MONEYJZ_CHANGE_EX")
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX")
	
end

function EquipLingPai_Star_OnLoad( )
	
	m_MainFram = EquipLingPai_Star_Frame
	m_ActionButton_Equip = EquipLingPai_Star_Object
	m_Button_OK = EquipLingPai_Star_OK
	
	m_Text_StarInfo = EquipLingPai_Star_ZhanShi1_Text
	m_Text_NextStarInfo = EquipLingPai_Star_ZhanShi2_Text
	m_Text_Success = EquipLingPai_Star_Info4
	m_Text_MustSuccessNum = EquipLingPai_Star_Info6
	
	m_StaticText_NeedMoney =  EquipLingPai_Star_NeedMoney
	m_StaticText_HaveJZ =  EquipLingPai_Star_SelfJiaozi
	m_StaticText_HaveMoney =  EquipLingPai_Star_SelfMoney
	
	g_MainFram_UnifiedPosition = EquipLingPai_Star_Frame:GetProperty( "UnifiedPosition" )

end

function EquipLingPai_Star_OnEvent( event )

	if ( event == "UI_COMMAND" ) and tonumber( arg0 ) == g_UI_Command then
		EquipLingPai_Star_Init()
		this:Show()
		g_ObjCared = -1
		local xx = Get_XParam_INT( 0 )
		g_ObjCared = DataPool : GetNPCIDByServerID( xx )
		if g_ObjCared == -1 then
			return
		end
		this:CareObject( g_ObjCared, 1)
		return
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
			EquipLingPai_Star_OnItemDragedDropFromBag( tonumber(arg1)  )
	end
	if (event == "RL_STAR_PUTIN_EQUIP"  and this:IsVisible()) then
		if arg0 ~= nil then
			EquipLingPai_Star_OnItemDragedDropFromBag( tonumber(arg0)  )
		end
		return
	end
	
	if (event == "RL_STAR_PACKET_RCLICK"  and this:IsVisible()) then
		if arg0 ~= nil  then
			EquipLingPai_Star_OnBagItemRClicked( tonumber(arg0)  )
		end
		return
	end
	
	if (event == "RL_STAR_REMOVE_EQUIP"  and this:IsVisible()) then
		EquipLingPai_Star_OnItemDragedDropAway()
		return
	end 
	
	if event == "HIDE_ON_SCENE_TRANSED"  then
        EquipLingPai_Star_CleanUp()
		this:Hide()
		return
	end
	
	if (event == "ADJEST_UI_POS" ) then
		EquipLingPai_Star_On_ResetPos()
		return
	end
	
	if (event == "VIEW_RESOLUTION_CHANGED") then
		EquipLingPai_Star_On_ResetPos()
		return
	end
	
	if (event == "MONEY_CHANGE_EX") then
		m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if (event == "MONEYJZ_CHANGE_EX") then
		m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if (event == "PACKAGE_ITEM_CHANGED_EX" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_EquipBagIndex then
			EquipLingPai_Star_Refresh()
		end 
		return
	end

	
end

--Window清空
function EquipLingPai_Star_CleanUp()
	
	m_ActionButton_Equip:SetActionItem(-1)
	
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end

	m_EquipBagIndex = -1
		
	m_Button_OK:Disable()

	m_Text_StarInfo:SetText("")
	m_Text_NextStarInfo:SetText("")
	m_Text_Success:SetText("")
	m_Text_MustSuccessNum:SetText("")
	
	m_StaticText_NeedMoney:SetProperty("MoneyNumber", "0")
	
end

--Window恢复默认状态
function EquipLingPai_Star_Init()

	EquipLingPai_Star_CleanUp()
	m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
end

function EquipLingPai_Star_Refresh()

	if m_EquipBagIndex == -1 then
	
		EquipLingPai_Star_Init()
		return
		
	end
	
	local theAction = EnumAction(m_EquipBagIndex, "packageitem")
	if theAction:GetID() == 0 then
		
		EquipLingPai_Star_Init()
		return
		
	end
	
	m_ActionButton_Equip:SetActionItem(theAction:GetID())
	LifeAbility : Lock_Packet_Item(m_EquipBagIndex,1)
	
	local nStarLevel =SuperTooltips:GetEquipQual();
	local nStar ={10,14,20,28,40,55,75,100,130,-1}
	local nStarUp ={100,85,70,60,45,30,25,10,5,-1}
	nStarEffect =nStar[nStarLevel]
	strSuccess =nStarUp[nStarLevel].."%"
	nMustSuccessTry="100%"
	nNextStarLevel=nStarLevel+1
	nNextStarEffect =nStar[nStarLevel+1]
	if nStarLevel and nStarLevel > 0 then
		m_Text_StarInfo:SetText("#{BHZB_140521_234}#G"..tostring(nStarLevel).."#r#{BHZB_140521_236}#G"..tostring(nStarEffect).."%#r#{BHZB_140521_237}#G"..tostring(nStarEffect).."%")
		if nStarLevel < 8 then
			m_Text_Success:SetText(strSuccess)
			m_Text_MustSuccessNum:SetText(tostring(nMustSuccessTry))
			m_Text_NextStarInfo:SetText("#{BHZB_140521_234}#G"..tostring(nNextStarLevel).."#r#{BHZB_140521_236}#G"..tostring(nNextStarEffect).."%#r#{BHZB_140521_237}#G"..tostring(nNextStarEffect).."%")
			m_Button_OK:Enable()
			m_StaticText_NeedMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney))
		else
			m_Text_Success:SetText("")
			m_Text_MustSuccessNum:SetText("")
			m_Text_NextStarInfo:SetText("#{BHZB_140521_234}#{BHZB_140521_250}#r#{BHZB_140521_236}#{BHZB_140521_250}#r#{BHZB_140521_237}#{BHZB_140521_250}")
			m_Button_OK:Disable()
			m_StaticText_NeedMoney:SetProperty("MoneyNumber", "0")
		end

	end
	
end

--从背包拖拽到UI
function EquipLingPai_Star_OnItemDragedDropFromBag( iBagIndex )
	
	--是否是令牌
	local itemID = PlayerPackage:GetItemTableIndex(iBagIndex)	
	if itemID <10155201 or itemID >10155249 then
		PushDebugMessage("#{BHZB_140521_109}")	
		return
	end
	
	--释放原来的装备
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	
	EquipLingPai_Star_Init()
	m_EquipBagIndex = iBagIndex
	--刷新界面
	EquipLingPai_Star_Refresh()
end

--从背包内右键点击
function EquipLingPai_Star_OnBagItemRClicked( iBagIndex )
	
	--是否是令牌
	if PlayerPackage:Lua_IsBagItemRL( iBagIndex ) ~= 1 then
		PushDebugMessage("#{BHZB_140521_109}")	
		return
	end
	
	--释放原来的装备
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	
	EquipLingPai_Star_Init()
	m_EquipBagIndex = iBagIndex
	--刷新界面
	EquipLingPai_Star_Refresh()	

end

--从ActionItem拖拽到Window之外
function EquipLingPai_Star_OnItemDragedDropAway(  )
	
	EquipLingPai_Star_CleanUp()
	EquipLingPai_Star_Init()

end

--右键单击ActionItem
function EquipLingPai_Star_OnActionItemRClicked(  )
	
	EquipLingPai_Star_CleanUp()
	EquipLingPai_Star_Init()

end

--左键单击ActionItem
function EquipLingPai_Star_OnActionItemLClicked(  )


end

--点击OK
function EquipLingPai_Star_OnOkClicked(  )
	
	if m_EquipBagIndex == -1 then
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "ActionPingPai" );
		Set_XSCRIPT_ScriptID( 880001 );
		Set_XSCRIPT_Parameter( 0, 7 ); 
		Set_XSCRIPT_Parameter( 1, m_EquipBagIndex     );        
		Set_XSCRIPT_ParamCount( 2 );
	Send_XSCRIPT();	
	EquipLingPai_Star_OnHiden();
end

--点击Cancel
function EquipLingPai_Star_OnCancelClicked(  )

	EquipLingPai_Star_CleanUp()
	this:Hide()

end

--点击"X"
function EquipLingPai_Star_OnCloseClicked(  )

	EquipLingPai_Star_CleanUp()
	this:Hide()
	
end

function EquipLingPai_Star_OnHiden(  )

	EquipLingPai_Star_CleanUp()
	
end

function EquipLingPai_Star_On_ResetPos()

	m_MainFram:SetProperty( "UnifiedPosition", g_MainFram_UnifiedPosition )
	
end
