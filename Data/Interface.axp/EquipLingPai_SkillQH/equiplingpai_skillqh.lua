local m_EquipBagIndex = -1
local EquipLingPai_SkillQH_Update_AfterQH = -1

local g_ObjCared = -1
local g_UI_Command = 201405054
local g_UI_Command_Refresh = 201406284

local g_RS_UnActived_Image  = "set:CommonFrame25 image:EquipLingPai_Feng"    --- δ���

local g_SkillQH_NeedMoney = 100000

local g_MainFram_UnifiedPosition

--�ؼ�����
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

--Window���
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

--Window�ָ�Ĭ��״̬
function EquipLingPai_SkillQH_Init()
	
	EquipLingPai_SkillQH_CleanUp()
	m_Text_CurrentSkill:SetText("")		
	m_StaticText_HaveMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	m_StaticText_HaveJZ:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	nBuffName={"H�n B�ng H�a K�nh","Vi�m Kh� H�a K�nh","Huy�n Ph�p H�a K�nh","B�ch еc H�a K�nh","T� T��ng Quy Nh�t-B�ng","T� T��ng Quy Nh�t-H�a","T� T��ng Quy Nh�t-Huy�n","T� T��ng Quy Nh�t-еc","Kh� иnh Th�n Nh�n","Kh� Xung Ti�u H�n",}
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
--ˢ�½���
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
	PushDebugMessage("H�y �t 1 L�nh B�i v�o")
	return
	end
	n1=0
	local szAuthor = SuperTooltips:GetAuthorInfo();
	if szAuthor~=nil and string.len(szAuthor)>=50 then
		_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,
		_,_,_,_,_,_,_,_,_,n1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_=CheckAuthorType(szAuthor)
	end
	nBuffName={"H�n B�ng H�a K�nh","Vi�m Kh� H�a K�nh","Huy�n Ph�p H�a K�nh","B�ch еc H�a K�nh","T� T��ng Quy Nh�t-B�ng","T� T��ng Quy Nh�t-H�a","T� T��ng Quy Nh�t-Huy�n","T� T��ng Quy Nh�t-еc","Kh� иnh Th�n Nh�n","Kh� Xung Ti�u H�n",}
	if n1 ==nil or n1<=0 then
		m_Text_CurrentSkill:SetText("(Ch�a h�c)")
	else
		m_Text_CurrentSkill:SetText(nBuffName[n1])
	end
	m_ActionButton_Equip:SetActionItem(theAction:GetID())
	LifeAbility : Lock_Packet_Item(m_EquipBagIndex,1)
	m_Button_OK:Enable()
	
end

--�ӱ�����ק��UI
function EquipLingPai_SkillQH_OnItemDragedDropFromBag( iBagIndex )
	
	--�Ƿ����
	if PlayerPackage:IsLock( iBagIndex ) == 1 then
		PushDebugMessage("#{BSZK_121012_17}")	--����������
		return
	end

	--�ͷ�ԭ����װ��
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	m_Text_CurrentSkill:SetText("")	
	
	EquipLingPai_SkillQH_NoEqup()
	m_EquipBagIndex = iBagIndex
	--ˢ�½���
	EquipLingPai_SkillQH_Refresh()
	
end

--�ӱ������Ҽ����
function EquipLingPai_SkillQH_OnBagItemRClicked( iBagIndex )
	
	--�Ƿ����
	if PlayerPackage:IsLock( iBagIndex ) == 1 then
		PushDebugMessage("#{BSZK_121012_17}")	--����������
		return
	end
	
	--�ͷ�ԭ����װ��
	if m_EquipBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(m_EquipBagIndex,0)
	end
	
	EquipLingPai_SkillQH_NoEqup()
	m_EquipBagIndex = iBagIndex
	--ˢ�½���
	EquipLingPai_SkillQH_Refresh()

end

--��ActionItem��ק��Window֮��
function EquipLingPai_SkillQH_OnItemDragedDropAway()
	
	EquipLingPai_SkillQH_NoEqup()

end

--�Ҽ�����ActionItem
function EquipLingPai_SkillQH_OnActionItemRClicked()
	
	EquipLingPai_SkillQH_NoEqup()

end

function EquipLingPai_SkillQH_OnSelectedChange()
	
	local nSelIdx = m_Text_SkillList:GetFirstSelectItem()
	local nBuffBaseString ={
		"H�n B�ng H�a Kinh: C� x�c su�t k�ch ho�t H�a Kinh H� B�ng, gi�p b�n th�n t�ng 200 �i�m B�ng c�ng, duy tr� 2 gi�y, hi�u qu� n�y trong 30 gi�y k�ch ho�t 1 l�n",
		"Li�t H�a H�a Kinh: C� x�c su�t k�ch ho�t H�a Kinh H� H�a, gi�p b�n th�n t�ng 200 �i�m H�a c�ng, duy tr� 2 gi�y, hi�u qu� n�y trong 30 gi�y k�ch ho�t 1 l�n",
		"Huy�n L�i H�a Kinh: C� x�c su�t k�ch ho�t H�a Kinh H� Huy�n, gi�p b�n th�n t�ng 200 �i�m Huy�n c�ng, duy tr� 2 gi�y, hi�u qu� n�y trong 30 gi�y k�ch ho�t 1 l�n",
		"Huy�t еc H�a Kinh: C� x�c su�t k�ch ho�t H�a Kinh H� еc, gi�p b�n th�n t�ng 200 �i�m еc c�ng, duy tr� 2 gi�y, hi�u qu� n�y trong 30 gi�y k�ch ho�t 1 l�n",
		"T� T��ng Quy Nh�t-B�ng: T�n c�ng c� x�c su�t k�ch ho�t, chuy�n h�a s�t th߽ng h�a, huy�n, �c th�nh s�t th߽ng b�ng trong 2 gi�y, 30 gi�y k�ch ho�t 1 l�n",
		"T� T��ng Quy Nh�t-H�a: T�n c�ng c� x�c su�t k�ch ho�t, chuy�n h�a s�t th߽ng b�ng, huy�n, �c th�nh s�t th߽ng h�a trong 2 gi�y, 30 gi�y k�ch ho�t 1 l�n",
		"T� T��ng Quy Nh�t-Huy�n: T�n c�ng c� x�c su�t k�ch ho�t, chuy�n h�a s�t th߽ng b�ng, h�a, �c th�nh s�t th߽ng huy�n trong 2 gi�y, 30 gi�y k�ch ho�t 1 l�n",
		"T� T��ng Quy Nh�t-еc: T�n c�ng c� x�c su�t k�ch ho�t, chuy�n h�a s�t th߽ng b�ng, h�a, huy�n th�nh s�t th߽ng �c trong 2 gi�y, 30 gi�y k�ch ho�t 1 l�n",
		"Kh� иnh Th�n Nh�n: T�n c�ng c� x�c su�t k�ch ho�t, nh�n 10 �i�m kh�ng ch� m�ng trong 10 gi�y, 30 gi�y k�ch ho�t 1 l�n",
		"Kh� Xung Ti�u H�n: T�n c�ng c� x�c su�t k�ch ho�t, t�c � nh�n n� kh� +30% trong 10 gi�y, 30 gi�y k�ch ho�t 1 l�n",}
	m_Text_SkillSelInfo:SetText(nBuffBaseString[nSelIdx+1])	
	if m_EquipBagIndex ~= -1 then	
		m_StaticText_NeedMoney:SetProperty("MoneyNumber", tostring(g_SkillQH_NeedMoney))	
	end
	
end

--���OK
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

--���Cancel
function EquipLingPai_SkillQH_OnCancelClicked()

	EquipLingPai_SkillQH_CleanUp()
	this:Hide()

end

--���"X"
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