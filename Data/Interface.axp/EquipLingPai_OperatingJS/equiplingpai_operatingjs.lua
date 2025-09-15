-- [���������Ϊ����ľ����] add by DuanXiaoTong_2014/12/29
-- PushDebugMessage
-- !!!reloadscript =EquipLingPai_OperatingJS
-- ScriptGlobal_Format
---------------------------------------------------------------------------
local g_Controls = {};									-- �ؼ�
local g_TableSel = 1;									-- ��ǩҳ(Ĭ��ѡ��1)
local g_GemBagIndex = -1;								-- �ѷ��뱦ʯ�� nBagIndex
local g_ObjCared = -1;									-- NPC ObjId
local g_NeedJiaoZi = 100000;							-- ���轻��
local g_GiveXinJingNum = {								-- �������ľ�����
	"Kh�ng th� ph� v�", "6", "12", "18", "25",
	"32", "39", "48", "57", "66",
	"78", "90", "102", "118", "134",
	"150", "171", "192", "213", "240",
	"267", "294", "328", "362", "396",
	"438", "480", "522", "573", "624",
	"675", "736", "797", "858", "930",
	"1002", "1074", "1158", "1242", "1326",
	"1423", "1520", "1617", "1728", "1839",
	"1950", "2076", "2202", "2328", "2454",
};

local g_Position;		-- λ��
---------------------------------------------------------------------------


--*********************************
-- PreLoad
--*********************************
function EquipLingPai_OperatingJS_PreLoad()
	this : RegisterEvent( "OPEN_RLOPPAGE" );				-- ��UI
	this : RegisterEvent( "RL_OPJS_PACKET_RCLICK" );		-- �����Ҽ������ʯ
	this : RegisterEvent( "RL_OPJS_PUTIN_EQUIP" );			-- ������ק����װ��
	this : RegisterEvent( "RL_OPJS_REMOVE_EQUIP" );			-- ��ʯ���������ק�Ƴ�װ��
	this : RegisterEvent( "UNIT_MONEY" );					-- ��Ҹı�
	this : RegisterEvent( "MONEYJZ_CHANGE" );				-- ���Ӹı�
	this : RegisterEvent( "UI_COMMAND" );					-- UI_COMMAND
	this : RegisterEvent( "ADJEST_UI_POS" );				-- ��Ϸ���ڳߴ緢���ı�
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- ��Ϸ�ֱ��ʷ����˱仯
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- ѡ������
	this : RegisterEvent( "PLAYER_LEAVE_WORLD" );			-- �뿪����
end


--*********************************
-- OnLoad
--*********************************
function EquipLingPai_OperatingJS_OnLoad()
	g_Controls = {
		-- ���
		Framework = EquipLingPai_OperatingJS_Frame;
		-- ��ǩҳ
		Label = {
			ShengJi 	= EquipLingPai_OperatingJS_Page1;
			XiangQian 	= EquipLingPai_OperatingJS_Page2;
			ZhaiChu 	= EquipLingPai_OperatingJS_Page3;
			JiSui 		= EquipLingPai_OperatingJS_Page4;
		};
		-- ��ʯ��
		GemSlot = EquipLingPai_OperatingJS_InputIcon;
		-- ����
		Number = EquipLingPai_OperatingJS_OutputNumber;
		-- ��Ҫ����
		NeedJiaoZi = EquipLingPai_OperatingJSWantNum;
		-- ӵ�н���
		OwnJiaoZi = EquipLingPai_OperatingJSHaveNum;
		-- ӵ�н��
		OwnCoin = EquipLingPai_OperatingJS_HaveGoldNum;
		-- ȷ��
		BtnOK = EquipLingPai_OperatingJS_OK;
		-- ȡ��
		BtnCancel = EquipLingPai_OperatingJS_Cancel;
	};

	-- ��ʼ��λ��
	g_Position = g_Controls.Framework:GetProperty( "UnifiedPosition" )
end


--*********************************
-- OnEvent
--*********************************
function EquipLingPai_OperatingJS_OnEvent(event)
	--
	if (event == "UI_COMMAND" and tonumber(arg0) == 201405044) then
		-- λ��
	this:Show();
		-- NPC ObjId
		g_ObjCared = tonumber( Get_XParam_INT(0) );
		if ( g_ObjCared == -1 ) then
			return
		end
		this:CareObject( g_ObjCared, 1 );
		-- ��ʾ
		
		EquipLingPai_OperatingJS_RefreshUI();
	
		elseif (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		--
		local nBagIndex = tonumber( arg1 );
		EquipLingPai_OperatingJS_OnPacketRClick( nBagIndex );
	elseif ( event == "RL_OPJS_PUTIN_EQUIP" and this:IsVisible() and tonumber( arg0 ) ~= nil ) then
		--
		local nBagIndex = tonumber( arg0 );
		EquipLingPai_OperatingJS_OnItemDragedDropFromBag( nBagIndex );
	elseif ( event == "RL_OPJS_REMOVE_EQUIP" ) then
		-- �Ƴ�װ��
		EquipLingPai_OperatingJS_OnItemDragedDropAway();
	elseif ( event == "UNIT_MONEY" ) then
		-- ӵ�н��
		local nCoin = Player:GetData( "MONEY" );
		g_Controls.OwnCoin:SetProperty( "MoneyNumber", nCoin );
	elseif ( event == "MONEYJZ_CHANGE" ) then
		-- ӵ�н���
		local nJiaoZi = Player:GetData( "MONEY_JZ" );
		g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", nJiaoZi );
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 88001101 ) then
		-- �Ƴ�װ��
		EquipLingPai_OperatingJS_OnItemDragedDropAway();
	elseif ( event == "ADJEST_UI_POS" ) then
		-- �ָ�Ĭ��λ��
		g_Controls.Framework:SetProperty( "UnifiedPosition", g_Position );
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		-- �ָ�Ĭ��λ��
		g_Controls.Framework:SetProperty( "UnifiedPosition", g_Position );
	elseif ( event == "GAMELOGIN_SELECTCHARACTER" ) then
		g_GemBagIndex = -1
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then
		-- �ͷ�ԭ���ı�ʯ
		if ( g_GemBagIndex ~= -1 ) then
			LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
			g_GemBagIndex = -1;
		end
	end
end


--*********************************
-- ���UI
--*********************************
function EquipLingPai_OperatingJS_CleanupUIControls()
	-- ��ǩҳ
	g_Controls.Label.ShengJi:SetCheck( 0 );
	g_Controls.Label.XiangQian:SetCheck( 0 );
	g_Controls.Label.ZhaiChu:SetCheck( 0 );
	g_Controls.Label.JiSui:SetCheck( 1 );
	-- ��ʯ��
	g_Controls.GemSlot:SetActionItem( -1 );
	-- ����
	g_Controls.Number:SetText( "" );
	-- ��Ҫ����
	g_Controls.NeedJiaoZi:SetProperty( "MoneyNumber", 0 );
	-- ӵ�н���
	g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", 0 );
	-- ӵ�н��
	g_Controls.OwnCoin:SetProperty( "MoneyNumber", 0 );
end


--*********************************
-- ˢ��UI
--*********************************
function EquipLingPai_OperatingJS_RefreshUI()
	-- ���UI
	EquipLingPai_OperatingJS_CleanupUIControls();

	if ( g_GemBagIndex ~= -1 ) then
		-- ��ʯ��
		local theAction = EnumAction( g_GemBagIndex, "packageitem" );
		if ( theAction:GetID() ~= 0 ) then
			g_Controls.GemSlot:SetActionItem( theAction:GetID() );
			LifeAbility:Lock_Packet_Item( g_GemBagIndex, 1 );
		end
		-- ����
		local nLevel = PlayerPackage:Lua_GetBagItemRsLevel( g_GemBagIndex );
		g_Controls.Number:SetText( g_GiveXinJingNum[ nLevel ] );
		-- ��Ҫ����
		g_Controls.NeedJiaoZi:SetProperty( "MoneyNumber", g_NeedJiaoZi );
	end
	-- ӵ�н���
	local nJiaoZi = Player:GetData( "MONEY_JZ" );
	g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", nJiaoZi );
	-- ӵ�н��
	local nCoin = Player:GetData( "MONEY" );
	g_Controls.OwnCoin:SetProperty( "MoneyNumber", nCoin );
end


--*********************************
-- �����Ҽ������ʯ
--*********************************
function EquipLingPai_OperatingJS_OnPacketRClick( nBagIndex )
	local theAction = EnumAction(nBagIndex, "packageitem")
	if theAction:GetID() == 0 then
	EquipLingPai_OperatingJS_CleanupUIControls()
		return
	end
	if PlayerPackage:GetItemTableIndex(nBagIndex) < 20800001  or PlayerPackage:GetItemTableIndex(nBagIndex) > 20800020  then
		PushDebugMessage( "#{JSBZ_141226_12}" );
	return
	end
		-- �ͷ�ԭ���ı�ʯ
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
	end
	-- ����
	if ( PlayerPackage:IsLock( nBagIndex ) == 1 ) then
		PushDebugMessage( "#{JSBZ_141226_13}" );
		return
	end
	g_Controls.GemSlot:SetActionItem( theAction:GetID() );
	LifeAbility:Lock_Packet_Item(nBagIndex, 1 );
	g_GemBagIndex = nBagIndex
	-- ��Ҫ����
	g_Controls.Number:SetText( g_GiveXinJingNum[ 2 ] );
	g_Controls.NeedJiaoZi:SetProperty( "MoneyNumber", g_NeedJiaoZi );
	-- ӵ�н���
	local nJiaoZi = Player:GetData( "MONEY_JZ" );
	g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", nJiaoZi );
	-- ӵ�н��
	local nCoin = Player:GetData( "MONEY" );
	g_Controls.OwnCoin:SetProperty( "MoneyNumber", nCoin );



	-- ˢ��UI
--	EquipLingPai_OperatingJS_RefreshUI();
end


--*********************************
-- �ӱ�����ק
--*********************************
function EquipLingPai_OperatingJS_OnItemDragedDropFromBag( nBagIndex )
	--
	if ( nBagIndex == -1 ) then
		return
	end

	-- ������
	if ( PlayerPackage:Lua_IsBagItemRS( nBagIndex ) ~= 1 ) then
		PushDebugMessage( "#{JSBZ_141226_12}" );
		return
	end

	-- ����
	if ( PlayerPackage:IsLock( nBagIndex ) == 1 ) then
		PushDebugMessage( "#{JSBZ_141226_13}" );
		return
	end
	-- �ͷ�ԭ���ı�ʯ
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
	end
	-- ���� nBagIndex
	g_GemBagIndex = nBagIndex;
	if ( g_GemBagIndex == -1 ) then
		return
	end
	-- ˢ��UI
	EquipLingPai_OperatingJS_RefreshUI();
end


--*********************************
-- �Ƴ�װ��
--*********************************
function EquipLingPai_OperatingJS_OnItemDragedDropAway()
	-- �ͷ�ԭ���ı�ʯ
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
		g_GemBagIndex = -1;
	end
    -- ˢ��UI
	EquipLingPai_OperatingJS_RefreshUI();
end


--********************************
-- ������
--********************************
function EquipLingPai_OperatingJS_CheckShredding()
	-- ��ȫʱ��
	if ( tonumber( DataPool:GetLeftProtectTime() ) > 0 ) then
		PushDebugMessage( "#{OR_PILFER_LOCK_FLAG}" );
		return 0;
	end
	-- ������
	if ( g_GemBagIndex == -1 ) then
		PushDebugMessage( "#{JSBZ_141226_15}" );
		return 0;
	end

	-- ����
	if ( PlayerPackage:IsLock( g_GemBagIndex ) == 1 ) then
		PushDebugMessage( "#{JSBZ_141226_13}" );
		return 0;
	end
	-- ����
	local nCoin = Player:GetData( "MONEY" );
	local nJiaoZi = Player:GetData( "MONEY_JZ" );
	if ( nCoin + nJiaoZi < g_NeedJiaoZi ) then
		PushDebugMessage( "#{JSBZ_141226_18}" );
		return 0;
	end
	return 1;
end


--==========================================================================--
-- ��Ӧ�¼�
--==========================================================================--


--*********************************
-- �ر�
--*********************************
function EquipLingPai_OperatingJS_OnCloseClicked()
	-- �ͷ�ԭ���ı�ʯ
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
		g_GemBagIndex = -1;
	end
	-- ˢ��UI
	EquipLingPai_OperatingJS_RefreshUI();
	-- ����UI
	this:Hide();
	--
	g_ObjCared = -1
end


--*********************************
-- ����
--*********************************
function EquipLingPai_OperatingJS_OnHiden()
	-- �ͷ�ԭ���ı�ʯ
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
		g_GemBagIndex = -1;
	end
	--
	g_ObjCared = -1
end


--*********************************
-- ��ǩҳ
--*********************************
function EquipLingPai_OperatingJS_OnPageButtonClicked( nIndex )
	if ( g_ObjCared == -1 ) then
		return
	end
	local UI ={201405043,201405042,201405045,201405044}
	PushEvent("UI_COMMAND",UI[nIndex])
end


--********************************
-- ActionButton
--********************************
function EquipLingPai_OperatingJS_OnActionItemRClicked()
	-- �Ƴ�װ��
	EquipLingPai_OperatingJS_OnItemDragedDropAway();
end


--********************************
-- ȷ��
--********************************
function EquipLingPai_OperatingJS_OnOkClicked()
	-- ���
	if ( EquipLingPai_OperatingJS_CheckShredding() ~= 1 ) then
		return
	end

	-- ����
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "ActionPingPai" );
		Set_XSCRIPT_ScriptID( 880001 );
		Set_XSCRIPT_Parameter( 0,6 );
		Set_XSCRIPT_Parameter( 1, g_GemBagIndex );
		Set_XSCRIPT_ParamCount( 2 );
	Send_XSCRIPT();
	EquipLingPai_OperatingJS_OnHiden();
end


--********************************
-- ȡ��
--********************************
function EquipLingPai_OperatingJS_OnCancelClicked()
	-- �Ƴ�װ��
	EquipLingPai_OperatingJS_OnItemDragedDropAway();
	-- ����UI
	this:Hide();
	--
	g_ObjCared = -1
end
