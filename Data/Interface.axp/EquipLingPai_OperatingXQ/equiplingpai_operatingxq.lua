local m_EquipBagIndex = -1
local m_Rs_Idx = {}
local m_Rs_Color = {}

local g_ObjCared = -1

local g_RS_UnActived_Image  = "set:CommonFrame25 image:EquipLingPai_Feng"    --- 未打孔

local g_MainFram_UnifiedPosition

local g_UnActived_tip = {"" , "#{BHZB_140521_169}" , "#{BHZB_140521_170}" , "#{BHZB_140521_171}"}

local g_XQ_NeedMoney = 100000

--控件变量
local m_MulitiText_Intro
local m_MainFram
local m_ActionButton_Equip
local m_ActionButton_Rs = {}
local m_Text_RsLevel = {}
local m_Image_NoMove = {}
local m_Button_OK
local m_CheckButton_Page = {}
local m_Animate_Sel = {}

local m_StaticText_NeedMoney
local m_StaticText_HaveJZ
local m_StaticText_HaveMoney

function EquipLingPai_OperatingXQ_PreLoad( )

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RL_OPXQ_PUTIN_EQUIP")
	this:RegisterEvent("RL_OPXQ_PUTIN_RS")
	this:RegisterEvent("RL_OPXQ_PACKET_RCLICK")
	this:RegisterEvent("RL_OPXQ_REMOVE_EQUIP")
	this:RegisterEvent("RL_OPXQ_REMOVE_RS")
	this:RegisterEvent("RL_OPXQ_SWITCH_RS")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("OPEN_RLOPPAGE")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")

	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function EquipLingPai_OperatingXQ_OnLoad( )

	m_MainFram = EquipLingPai_OperatingXQ_Frame
	m_ActionButton_Equip = EquipLingPai_OperatingXQ_InputIcon
	m_Button_OK = EquipLingPai_OperatingXQ_OK
	
	m_ActionButton_Rs[1] = EquipLingPai_OperatingXQ_FirstGem
	m_ActionButton_Rs[2] = EquipLingPai_OperatingXQ_SecondGem
	m_ActionButton_Rs[3] = EquipLingPai_OperatingXQ_ThirdGem
	m_ActionButton_Rs[4] = EquipLingPai_OperatingXQ_FourthGem
	
	m_Text_RsLevel[1] = EquipLingPai_OperatingXQ_FirstGrade
	m_Text_RsLevel[2] = EquipLingPai_OperatingXQ_SecondGrade
	m_Text_RsLevel[3] = EquipLingPai_OperatingXQ_ThirdGrade
	m_Text_RsLevel[4] = EquipLingPai_OperatingXQ_FourthGrade
	
	m_Image_NoMove[1] = EquipLingPai_OperatingXQ_FirstTuCeng
	m_Image_NoMove[2] = EquipLingPai_OperatingXQ_SecondTuCeng
	m_Image_NoMove[3] = EquipLingPai_OperatingXQ_ThirdTuCeng
	m_Image_NoMove[4] = EquipLingPai_OperatingXQ_FourthTuCeng
	
	m_CheckButton_Page[1] = EquipLingPai_OperatingXQ_Page1
	m_CheckButton_Page[2] = EquipLingPai_OperatingXQ_Page2
	m_CheckButton_Page[3] = EquipLingPai_OperatingXQ_Page3
	
	m_StaticText_NeedMoney =  EquipLingPai_OperatingXQWantNum
	m_StaticText_HaveJZ =  EquipLingPai_OperatingXQHaveNum
	m_StaticText_HaveMoney =  EquipLingPai_OperatingXQ_HaveGoldNum
	
	m_Animate_Sel[1] = EquipLingPai_OperatingXQ_Check1
	m_Animate_Sel[2] = EquipLingPai_OperatingXQ_Check2
	m_Animate_Sel[3] = EquipLingPai_OperatingXQ_Check3
	m_Animate_Sel[4] = EquipLingPai_OperatingXQ_Check4

	g_MainFram_UnifiedPosition = m_MainFram:GetProperty( "UnifiedPosition" )

	m_Rs_Color[1] = 0
	m_Rs_Color[2] = 0
	m_Rs_Color[3] = 0
	m_Rs_Color[4] = 0
	
	
	for i=2,4 do 
		m_ActionButton_Rs[i]:Hide()
	end

end

function EquipLingPai_OperatingXQ_OnEvent( event )

	if (event == "UI_COMMAND" and tonumber(arg0) == 201405042) then
		
		this:Show()
		EquipLingPai_OperatingXQ_Init()
		g_ObjCared = tonumber(Get_XParam_INT(0) )
		if g_ObjCared == -1 then
			return
		end
	for i=2,4 do 
	m_ActionButton_Rs[i]:Hide()
	end
	this:CareObject( g_ObjCared, 1)
	return
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
			if ( tonumber(arg1) >=0) and ( tonumber(arg1) <=29) then
			EquipLingPai_OperatingXQ_OnItemEquipDragedDropFromBag( tonumber(arg1)  )
			elseif ( tonumber(arg1) >=30) and ( tonumber(arg1) <=59) then
			EquipLingPai_OperatingXQ_OnItemRsDragedDropFromBag( tonumber(arg1))
		   end
		return			
	end
	
	if (event == "RL_OPXQ_PUTIN_EQUIP"  and this:IsVisible()) then
		if arg0 ~= nil then
			EquipLingPai_OperatingXQ_OnItemEquipDragedDropFromBag( tonumber(arg0)  )
		end
		return
	end 
	
	if (event == "RL_OPXQ_PUTIN_RS"  and this:IsVisible()) then
		if arg0 ~= nil then
			EquipLingPai_OperatingXQ_OnItemRsDragedDropFromBag( tonumber(arg0) , tonumber(arg1)  )
		end
		return
	end
	
	if (event == "RL_OPXQ_PACKET_RCLICK"  and this:IsVisible()) then
		if arg0 ~= nil  then
			EquipLingPai_OperatingXQ_OnBagItemRClicked( tonumber(arg0)  )
		end
		return
	end 
	
	if (event == "RL_OPXQ_REMOVE_EQUIP"  and this:IsVisible()) then
		EquipLingPai_OperatingXQ_OnItemEquipDragedDropAway()
		return
	end 	
	
	if (event == "RL_OPXQ_SWITCH_RS"  and this:IsVisible()) then
		if arg0 ~= nil  and arg1 ~= nil then
			EquipLingPai_OperatingXQ_OnItemDragedDropFromSelf( tonumber(arg0) ,  tonumber(arg1) )
		end
		return
	end
	
	if (event == "RL_OPXQ_REMOVE_RS"  and this:IsVisible()) then
		EquipLingPai_OperatingXQ_OnItemRsDragedDropAway()
		return
	end

	if event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
            EquipLingPai_OperatingXQ_CleanUp()
			this:Hide()
		end
		return
	end
	
	if event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
            EquipLingPai_OperatingXQ_CleanUp()
			this:Hide()
		end
		return
	end
	
	if event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
            EquipLingPai_OperatingXQ_CleanUp()
			this:Hide()
		end
		return
	end
	
	if (event == "ADJEST_UI_POS" ) then
		EquipLingPai_OperatingXQ_On_ResetPos()
		return
	end
	
	if (event == "VIEW_RESOLUTION_CHANGED") then
		EquipLingPai_OperatingXQ_On_ResetPos()
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
		
			EquipLingPai_OperatingXQ_Update_AfterXQ()	
			
		end
		return
	end
	
end

--Window清空
function EquipLingPai_OperatingXQ_CleanUp()
	m_ActionButton_Equip:SetActionItem(-1)
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end

	m_EquipBagIndex = -1
		
	for i=1,4 do
	
		m_ActionButton_Rs[i]:SetActionItem(-1)
		m_ActionButton_Rs[i]:SetProperty( "BackImage", "" )
		m_ActionButton_Rs[i]:SetToolTip( "" )
		
		if m_Rs_Idx[i] ~= nil and m_Rs_Idx[i] >= 0 then
			LifeAbility : Lock_Packet_Item(m_Rs_Idx[i],0)
		end
		m_Text_RsLevel[i]:SetText("")
		m_Image_NoMove[i]:Hide()
		m_Animate_Sel[i]:Hide()
	end
	
	m_Rs_Idx = {}
	m_Rs_Color = {}
	m_Button_OK:Disable()
	
	m_StaticText_NeedMoney:SetProperty("MoneyNumber", "0")
	
end

--Window恢复默认状态
function EquipLingPai_OperatingXQ_Init()
	
	EquipLingPai_OperatingXQ_CleanUp()
	m_Rs_Color[1] = 0
	m_Rs_Color[2] = 0
	m_Rs_Color[3] = 0
	m_Rs_Color[4] = 0
	
	m_CheckButton_Page[1]:SetCheck(0)
	m_CheckButton_Page[2]:SetCheck(1)
	m_CheckButton_Page[3]:SetCheck(0)
	
	m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

end

--刷新界面
function EquipLingPai_OperatingXQ_Refresh()
	
	if m_EquipBagIndex == -1 then
	
		EquipLingPai_OperatingXQ_Init()
		return
		
	end
	
	local theAction = EnumAction(m_EquipBagIndex, "packageitem")
	if theAction:GetID() == 0 then
		
		EquipLingPai_OperatingXQ_Init()
		return
		
	end
	
	m_ActionButton_Equip:SetActionItem(theAction:GetID())
	LifeAbility : Lock_Packet_Item(m_EquipBagIndex,1)
	
	
end

--从背包拖拽令牌到UI
function EquipLingPai_OperatingXQ_OnItemEquipDragedDropFromBag( itemIdx )  
	
	local theAction = EnumAction(itemIdx, "packageitem")
	if theAction:GetID() ~= 0 then
	local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
	
	if itemID <10155201 or itemID >10155249 then
	PushDebugMessage("H銀 穑t 1 L畁h B鄆 v鄌")
	return
	end	
	if m_EquipBagIndex ~= -1 then
	LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
    end
	m_ActionButton_Equip:SetActionItem(theAction:GetID())
	LifeAbility : Lock_Packet_Item(itemIdx ,1)
	m_EquipBagIndex = itemIdx
	else
     EquipLingPai_OperatingXQ_Init()
	end	
end

--从背包拖拽宝珠到UI
function EquipLingPai_OperatingXQ_OnItemRsDragedDropFromBag( iBagIndex )
	if m_EquipBagIndex == -1 then
		PushDebugMessage("H銀 穑t 1 L畁h B鄆 v鄌")	--请先放入符石传说
		return
	end
	local theAction = EnumAction(iBagIndex, "packageitem")
	if theAction:GetID() ~= 0 then

	local itemID = PlayerPackage:GetItemTableIndex(iBagIndex)
		if m_Rs_Idx[1] ~= nil and m_Rs_Idx[1] >= 0 then
			LifeAbility : Lock_Packet_Item(m_Rs_Idx[1],0)
		end
		if itemID < 20800001  or itemID > 20800020  then
		PushDebugMessage( "#{JSBZ_141226_12}" );
			return
		end
		m_ActionButton_Rs[1]:SetActionItem(theAction:GetID())
		LifeAbility : Lock_Packet_Item(iBagIndex,1)
		m_Rs_Idx[1] = iBagIndex
		m_Animate_Sel[1]:Show()		
	end	
	if m_EquipBagIndex ~= -1 and m_Rs_Idx[1] ~= -1 then
		m_Button_OK:Enable()
	end
end

function ScriptGlobal_Format(arg0,arg1)
	str = "" 
	str = string.format(arg0,arg1)
	return str
end	

--从背包内右键点击
function EquipLingPai_OperatingXQ_OnBagItemRClicked( iBagIndex )
	

end

--从ActionItem A拖拽到 ActionItem B
function EquipLingPai_OperatingXQ_OnItemDragedDropFromSelf( fromIdx ,toIdx )

end

--从ActionItem拖拽到Window之外
function EquipLingPai_OperatingXQ_OnItemEquipDragedDropAway(  )
	
	EquipLingPai_OperatingXQ_CleanUp()
	EquipLingPai_OperatingXQ_Init()

end

--从ActionItem拖拽到Window之外
function EquipLingPai_OperatingXQ_OnItemRsDragedDropAway(  )
	
end

--右键单击ActionItem
function EquipLingPai_OperatingXQ_OnActionItemEquipRClicked(  )
	
	EquipLingPai_OperatingXQ_CleanUp()
	EquipLingPai_OperatingXQ_Init()

end

--右键单击ActionItem
function EquipLingPai_OperatingXQ_OnActionItemRsRClicked( nIndex  )
	

end

--点击分页
function EquipLingPai_OperatingXQ_OnPageButtonClicked(nIndex)
	
	local UI ={201405043,201405042,201405045,201405044}
	PushEvent("UI_COMMAND",UI[nIndex])

end

--点击OK
function EquipLingPai_OperatingXQ_OnOkClicked(  )
	
	if m_EquipBagIndex == -1 then
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "ActionPingPai" );
		Set_XSCRIPT_ScriptID( 880001 );
		Set_XSCRIPT_Parameter( 0,2); 
		Set_XSCRIPT_Parameter( 1, m_EquipBagIndex     );  
		Set_XSCRIPT_Parameter( 2, m_Rs_Idx[1]  );  
		Set_XSCRIPT_ParamCount( 3 );
	Send_XSCRIPT();	
	 EquipLingPai_OperatingXQ_Init()
end

--点击Cancel
function EquipLingPai_OperatingXQ_OnCancelClicked(  )

	EquipLingPai_OperatingXQ_CleanUp()
	this:Hide()

end

--点击"X"
function EquipLingPai_OperatingXQ_OnCloseClicked(  )

	EquipLingPai_OperatingXQ_CleanUp()
	this:Hide()
	
end

function EquipLingPai_OperatingXQ_OnHiden(  )

	EquipLingPai_OperatingXQ_CleanUp()
	
end

function EquipLingPai_OperatingXQ_On_ResetPos()

	m_MainFram:SetProperty( "UnifiedPosition", g_MainFram_UnifiedPosition )
	
end

function EquipLingPai_OperatingXQ_Update_AfterXQ()

		local nEquipBagIndex = m_EquipBagIndex
		EquipLingPai_OperatingXQ_Init()
		m_EquipBagIndex = nEquipBagIndex
		
		EquipLingPai_OperatingXQ_Refresh()
		
end
