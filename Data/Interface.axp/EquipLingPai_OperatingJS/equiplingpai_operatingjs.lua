-- [ËÄÏó±¦Öé»÷ËéÎªôä´äÐÄ¾«Éè¼Æ] add by DuanXiaoTong_2014/12/29
-- PushDebugMessage
-- !!!reloadscript =EquipLingPai_OperatingJS
-- ScriptGlobal_Format
---------------------------------------------------------------------------
local g_Controls = {};									-- ¿Ø¼þ
local g_TableSel = 1;									-- ±êÇ©Ò³(Ä¬ÈÏÑ¡ÖÐ1)
local g_GemBagIndex = -1;								-- ÒÑ·ÅÈë±¦Ê¯µÄ nBagIndex
local g_ObjCared = -1;									-- NPC ObjId
local g_NeedJiaoZi = 100000;							-- ËùÐè½»×Ó
local g_GiveXinJingNum = {								-- »÷Ëé»ñµÃÐÄ¾«ÊýÁ¿
	"Không th¬ phá vÞ", "6", "12", "18", "25",
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

local g_Position;		-- Î»ÖÃ
---------------------------------------------------------------------------


--*********************************
-- PreLoad
--*********************************
function EquipLingPai_OperatingJS_PreLoad()
	this : RegisterEvent( "OPEN_RLOPPAGE" );				-- ´ò¿ªUI
	this : RegisterEvent( "RL_OPJS_PACKET_RCLICK" );		-- ±³°üÓÒ¼üµã»÷±¦Ê¯
	this : RegisterEvent( "RL_OPJS_PUTIN_EQUIP" );			-- ±³°üÍÏ×§·ÅÈë×°±¸
	this : RegisterEvent( "RL_OPJS_REMOVE_EQUIP" );			-- ·ûÊ¯»÷Ëé½çÃæÍÏ×§ÒÆ³ý×°±¸
	this : RegisterEvent( "UNIT_MONEY" );					-- ½ð±Ò¸Ä±ä
	this : RegisterEvent( "MONEYJZ_CHANGE" );				-- ½»×Ó¸Ä±ä
	this : RegisterEvent( "UI_COMMAND" );					-- UI_COMMAND
	this : RegisterEvent( "ADJEST_UI_POS" );				-- ÓÎÏ·´°¿Ú³ß´ç·¢Éú¸Ä±ä
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- Ñ¡ÔñÈËÎï
	this : RegisterEvent( "PLAYER_LEAVE_WORLD" );			-- Àë¿ª³¡¾°
end


--*********************************
-- OnLoad
--*********************************
function EquipLingPai_OperatingJS_OnLoad()
	g_Controls = {
		-- ¿ò¼Ü
		Framework = EquipLingPai_OperatingJS_Frame;
		-- ±êÇ©Ò³
		Label = {
			ShengJi 	= EquipLingPai_OperatingJS_Page1;
			XiangQian 	= EquipLingPai_OperatingJS_Page2;
			ZhaiChu 	= EquipLingPai_OperatingJS_Page3;
			JiSui 		= EquipLingPai_OperatingJS_Page4;
		};
		-- ±¦Ê¯²Û
		GemSlot = EquipLingPai_OperatingJS_InputIcon;
		-- ÊýÁ¿
		Number = EquipLingPai_OperatingJS_OutputNumber;
		-- ÐèÒª½»×Ó
		NeedJiaoZi = EquipLingPai_OperatingJSWantNum;
		-- ÓµÓÐ½»×Ó
		OwnJiaoZi = EquipLingPai_OperatingJSHaveNum;
		-- ÓµÓÐ½ð±Ò
		OwnCoin = EquipLingPai_OperatingJS_HaveGoldNum;
		-- È·¶¨
		BtnOK = EquipLingPai_OperatingJS_OK;
		-- È¡Ïû
		BtnCancel = EquipLingPai_OperatingJS_Cancel;
	};

	-- ³õÊ¼»¯Î»ÖÃ
	g_Position = g_Controls.Framework:GetProperty( "UnifiedPosition" )
end


--*********************************
-- OnEvent
--*********************************
function EquipLingPai_OperatingJS_OnEvent(event)
	--
	if (event == "UI_COMMAND" and tonumber(arg0) == 201405044) then
		-- Î»ÖÃ
	this:Show();
		-- NPC ObjId
		g_ObjCared = tonumber( Get_XParam_INT(0) );
		if ( g_ObjCared == -1 ) then
			return
		end
		this:CareObject( g_ObjCared, 1 );
		-- ÏÔÊ¾
		
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
		-- ÒÆ³ý×°±¸
		EquipLingPai_OperatingJS_OnItemDragedDropAway();
	elseif ( event == "UNIT_MONEY" ) then
		-- ÓµÓÐ½ð±Ò
		local nCoin = Player:GetData( "MONEY" );
		g_Controls.OwnCoin:SetProperty( "MoneyNumber", nCoin );
	elseif ( event == "MONEYJZ_CHANGE" ) then
		-- ÓµÓÐ½»×Ó
		local nJiaoZi = Player:GetData( "MONEY_JZ" );
		g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", nJiaoZi );
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 88001101 ) then
		-- ÒÆ³ý×°±¸
		EquipLingPai_OperatingJS_OnItemDragedDropAway();
	elseif ( event == "ADJEST_UI_POS" ) then
		-- »Ö¸´Ä¬ÈÏÎ»ÖÃ
		g_Controls.Framework:SetProperty( "UnifiedPosition", g_Position );
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		-- »Ö¸´Ä¬ÈÏÎ»ÖÃ
		g_Controls.Framework:SetProperty( "UnifiedPosition", g_Position );
	elseif ( event == "GAMELOGIN_SELECTCHARACTER" ) then
		g_GemBagIndex = -1
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then
		-- ÊÍ·ÅÔ­À´µÄ±¦Ê¯
		if ( g_GemBagIndex ~= -1 ) then
			LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
			g_GemBagIndex = -1;
		end
	end
end


--*********************************
-- Çå¿ÕUI
--*********************************
function EquipLingPai_OperatingJS_CleanupUIControls()
	-- ±êÇ©Ò³
	g_Controls.Label.ShengJi:SetCheck( 0 );
	g_Controls.Label.XiangQian:SetCheck( 0 );
	g_Controls.Label.ZhaiChu:SetCheck( 0 );
	g_Controls.Label.JiSui:SetCheck( 1 );
	-- ±¦Ê¯²Û
	g_Controls.GemSlot:SetActionItem( -1 );
	-- ÊýÁ¿
	g_Controls.Number:SetText( "" );
	-- ÐèÒª½»×Ó
	g_Controls.NeedJiaoZi:SetProperty( "MoneyNumber", 0 );
	-- ÓµÓÐ½»×Ó
	g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", 0 );
	-- ÓµÓÐ½ð±Ò
	g_Controls.OwnCoin:SetProperty( "MoneyNumber", 0 );
end


--*********************************
-- Ë¢ÐÂUI
--*********************************
function EquipLingPai_OperatingJS_RefreshUI()
	-- Çå¿ÕUI
	EquipLingPai_OperatingJS_CleanupUIControls();

	if ( g_GemBagIndex ~= -1 ) then
		-- ±¦Ê¯²Û
		local theAction = EnumAction( g_GemBagIndex, "packageitem" );
		if ( theAction:GetID() ~= 0 ) then
			g_Controls.GemSlot:SetActionItem( theAction:GetID() );
			LifeAbility:Lock_Packet_Item( g_GemBagIndex, 1 );
		end
		-- ÊýÁ¿
		local nLevel = PlayerPackage:Lua_GetBagItemRsLevel( g_GemBagIndex );
		g_Controls.Number:SetText( g_GiveXinJingNum[ nLevel ] );
		-- ÐèÒª½»×Ó
		g_Controls.NeedJiaoZi:SetProperty( "MoneyNumber", g_NeedJiaoZi );
	end
	-- ÓµÓÐ½»×Ó
	local nJiaoZi = Player:GetData( "MONEY_JZ" );
	g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", nJiaoZi );
	-- ÓµÓÐ½ð±Ò
	local nCoin = Player:GetData( "MONEY" );
	g_Controls.OwnCoin:SetProperty( "MoneyNumber", nCoin );
end


--*********************************
-- ±³°üÓÒ¼üµã»÷±¦Ê¯
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
		-- ÊÍ·ÅÔ­À´µÄ±¦Ê¯
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
	end
	-- ¼ÓËø
	if ( PlayerPackage:IsLock( nBagIndex ) == 1 ) then
		PushDebugMessage( "#{JSBZ_141226_13}" );
		return
	end
	g_Controls.GemSlot:SetActionItem( theAction:GetID() );
	LifeAbility:Lock_Packet_Item(nBagIndex, 1 );
	g_GemBagIndex = nBagIndex
	-- ÐèÒª½»×Ó
	g_Controls.Number:SetText( g_GiveXinJingNum[ 2 ] );
	g_Controls.NeedJiaoZi:SetProperty( "MoneyNumber", g_NeedJiaoZi );
	-- ÓµÓÐ½»×Ó
	local nJiaoZi = Player:GetData( "MONEY_JZ" );
	g_Controls.OwnJiaoZi:SetProperty( "MoneyNumber", nJiaoZi );
	-- ÓµÓÐ½ð±Ò
	local nCoin = Player:GetData( "MONEY" );
	g_Controls.OwnCoin:SetProperty( "MoneyNumber", nCoin );



	-- Ë¢ÐÂUI
--	EquipLingPai_OperatingJS_RefreshUI();
end


--*********************************
-- ´Ó±³°üÍÏ×§
--*********************************
function EquipLingPai_OperatingJS_OnItemDragedDropFromBag( nBagIndex )
	--
	if ( nBagIndex == -1 ) then
		return
	end

	-- ËÄÏó±¦Öé
	if ( PlayerPackage:Lua_IsBagItemRS( nBagIndex ) ~= 1 ) then
		PushDebugMessage( "#{JSBZ_141226_12}" );
		return
	end

	-- ¼ÓËø
	if ( PlayerPackage:IsLock( nBagIndex ) == 1 ) then
		PushDebugMessage( "#{JSBZ_141226_13}" );
		return
	end
	-- ÊÍ·ÅÔ­À´µÄ±¦Ê¯
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
	end
	-- ±£´æ nBagIndex
	g_GemBagIndex = nBagIndex;
	if ( g_GemBagIndex == -1 ) then
		return
	end
	-- Ë¢ÐÂUI
	EquipLingPai_OperatingJS_RefreshUI();
end


--*********************************
-- ÒÆ³ý×°±¸
--*********************************
function EquipLingPai_OperatingJS_OnItemDragedDropAway()
	-- ÊÍ·ÅÔ­À´µÄ±¦Ê¯
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
		g_GemBagIndex = -1;
	end
    -- Ë¢ÐÂUI
	EquipLingPai_OperatingJS_RefreshUI();
end


--********************************
-- »÷Ëé¼ì²é
--********************************
function EquipLingPai_OperatingJS_CheckShredding()
	-- °²È«Ê±¼ä
	if ( tonumber( DataPool:GetLeftProtectTime() ) > 0 ) then
		PushDebugMessage( "#{OR_PILFER_LOCK_FLAG}" );
		return 0;
	end
	-- ËÄÏó±¦Öé
	if ( g_GemBagIndex == -1 ) then
		PushDebugMessage( "#{JSBZ_141226_15}" );
		return 0;
	end

	-- ¼ÓËø
	if ( PlayerPackage:IsLock( g_GemBagIndex ) == 1 ) then
		PushDebugMessage( "#{JSBZ_141226_13}" );
		return 0;
	end
	-- ½»×Ó
	local nCoin = Player:GetData( "MONEY" );
	local nJiaoZi = Player:GetData( "MONEY_JZ" );
	if ( nCoin + nJiaoZi < g_NeedJiaoZi ) then
		PushDebugMessage( "#{JSBZ_141226_18}" );
		return 0;
	end
	return 1;
end


--==========================================================================--
-- ÏìÓ¦ÊÂ¼þ
--==========================================================================--


--*********************************
-- ¹Ø±Õ
--*********************************
function EquipLingPai_OperatingJS_OnCloseClicked()
	-- ÊÍ·ÅÔ­À´µÄ±¦Ê¯
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
		g_GemBagIndex = -1;
	end
	-- Ë¢ÐÂUI
	EquipLingPai_OperatingJS_RefreshUI();
	-- Òþ²ØUI
	this:Hide();
	--
	g_ObjCared = -1
end


--*********************************
-- Òþ²Ø
--*********************************
function EquipLingPai_OperatingJS_OnHiden()
	-- ÊÍ·ÅÔ­À´µÄ±¦Ê¯
	if ( g_GemBagIndex ~= -1 ) then
		LifeAbility:Lock_Packet_Item( g_GemBagIndex, 0 );
		g_GemBagIndex = -1;
	end
	--
	g_ObjCared = -1
end


--*********************************
-- ±êÇ©Ò³
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
	-- ÒÆ³ý×°±¸
	EquipLingPai_OperatingJS_OnItemDragedDropAway();
end


--********************************
-- È·¶¨
--********************************
function EquipLingPai_OperatingJS_OnOkClicked()
	-- ¼ì²é
	if ( EquipLingPai_OperatingJS_CheckShredding() ~= 1 ) then
		return
	end

	-- »÷Ëé
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
-- È¡Ïû
--********************************
function EquipLingPai_OperatingJS_OnCancelClicked()
	-- ÒÆ³ý×°±¸
	EquipLingPai_OperatingJS_OnItemDragedDropAway();
	-- Òþ²ØUI
	this:Hide();
	--
	g_ObjCared = -1
end
