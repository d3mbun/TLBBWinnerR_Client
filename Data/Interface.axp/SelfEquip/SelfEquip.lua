local Version = 20200622
local iactive=0
local iIceResistLimit,iFireResistLimit,iThunderResistLimit,iPoisonResistLimit = 0,0,0,0;
--------------------------------------------------------------------------------
-- ×°±¸°´Å¥Êý¾Ý¶¨Òå
--
local  g_WEAPON;		--ÎäÆ÷
local  g_ARMOR;			--ÒÂ·þ
local  g_CAP;				--Ã±×Ó
local  g_CUFF;			--ÊÖÌ×
local  g_BOOT;			--Ð¬
local  g_RING;			--½äÖ¸
local  g_SASH;			--Ñü´ø
local  g_NECKLACE;	--ÏîÁ´
local  g_Dark;			--°µÆ÷
local  g_RING_2;		--½äÖ¸2
local  g_CHARM;			--»¤·û
local  g_CHARM_2;		--»¤·û2
local  g_WRIST;			--»¤Íó
local  g_SHOULDER;	--»¤¼ç
local  g_DRESS;			--Ê±×°

local  g_EquipMask ={}
---------------------------------------------------------------------------------
-- µãÊý¶¨Òå
--
local g_XiulianTipTable = {"#{XL_XML_90}","#{XL_XML_91}","#{XL_XML_92}","#{XL_XML_93}","#{XL_XML_94}"
							,"#{XL_XML_95}","#{XL_XML_96}","#{XL_XML_97}","#{XL_XML_98}","#{XL_XML_99}"
							,"#{XL_XML_100}"}

local g_RemainPoint 			= 0;	-- Ê£ÓàµãÊý
local g_CurExperience 	  = 0;	-- µ±Ç°Ê£Óà¾­Ñé
local g_RequireExperience = 0;  -- Éý¼¶ËùÐè¾­Ñé

local g_AddStr = 0;					-- ·ÖÅäÔÚÁ¦Á¿ÉÏµÄÊ£ÓàµãÊý.
local g_AddSpr = 0;					-- ·ÖÅäÔÚÁéÆøÉÏµÄÊ£ÓàµãÊý.
local g_AddCon = 0;					-- ·ÖÅäÔÚÌåÖÊÉÏµÄÊ£ÓàµãÊý.
local g_AddInt = 0;					-- ·ÖÅäÔÚ¶¨Á¦ÉÏµÄÊ£ÓàµãÊý.
local g_AddDex = 0;					-- ·ÖÅäÔÚÉí·¨ÉÏµÄÊ£ÓàµãÊý.

local g_CurRemainPoint = 0;				-- ·ÖÅäºóµÄÊ£ÓàµãÊý

-- ÊÇ·ñ´ò¿ª³ÆºÅ½çÃæ
local g_bOpenTitleDlg = 0;
local SELFEQUIP_TAB_TEXT = {};
local LEVEL_MAX_ENABLE =149;	--×î´óÔÊÐíµÈ¼¶

local g_PropertyTable = {}


function SelfEquip_PreLoad()
	
	this:RegisterEvent("SCENE_TRANSED");
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("UI_COMMAND");

	--Àë¿ª³¡¾°£¬×Ô¶¯¹Ø±Õ
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	-- ¸üÐÂ×°±¸
	this:RegisterEvent("REFRESH_EQUIP");

	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MAX_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_MAX_MP");
	this:RegisterEvent("UNIT_RAGE");			-- ×¢²áÅ­Æø

	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_MAX_EXP");
	this:RegisterEvent("UNIT_STR");
	this:RegisterEvent("UNIT_SPR");
	this:RegisterEvent("UNIT_CON");
	this:RegisterEvent("UNIT_INT");
	this:RegisterEvent("UNIT_DEX");
	this:RegisterEvent("UNIT_POINT_REMAIN");
	this:RegisterEvent("UNIT_XIULIAN_STR");
	this:RegisterEvent("UNIT_XIULIAN_SPR");
	this:RegisterEvent("UNIT_XIULIAN_CON");
	this:RegisterEvent("UNIT_XIULIAN_INT");
	this:RegisterEvent("UNIT_XIULIAN_DEX");

	this:RegisterEvent("UNIT_ATT_PHYSICS");
	this:RegisterEvent("UNIT_ATT_MAGIC");
	this:RegisterEvent("UNIT_DEF_PHYSICS");
	this:RegisterEvent("UNIT_DEF_MAGIC");
	this:RegisterEvent("UNIT_HIT");
	this:RegisterEvent("UNIT_MISS");
	this:RegisterEvent("UNIT_CRITICAL_ATTACK");
	this:RegisterEvent("UNIT_CRITICAL_DEFENCE");
	this:RegisterEvent("CUR_TITLE_CHANGED"); 		--µ±Ç°³ÆºÅ¸Ä±ä
	this:RegisterEvent("UNIT_XIULIAN_ATT_PHYSICS");
	this:RegisterEvent("UNIT_XIULIAN_ATT_MAGIC");
	this:RegisterEvent("UNIT_XIULIAN_DEF_PHYSICS");
	this:RegisterEvent("UNIT_XIULIAN_DEF_MAGIC");
	this:RegisterEvent("UNIT_XIULIAN_HIT");
	this:RegisterEvent("UNIT_XIULIAN_MISS");

	this:RegisterEvent("UNIT_DEF_COLD");				--·ÀÓùÊôÐÔ
	this:RegisterEvent("UNIT_DEF_FIRE");
	this:RegisterEvent("UNIT_DEF_LIGHT");
	this:RegisterEvent("UNIT_DEF_POSION");
	this:RegisterEvent("UNIT_MENPAI");

	this:RegisterEvent("UNIT_ATT_COLD");				--¹¥»÷ÊôÐÔ
	this:RegisterEvent("UNIT_ATT_FIRE");
	this:RegisterEvent("UNIT_ATT_LIGHT");
	this:RegisterEvent("UNIT_ATT_POSION");

	this:RegisterEvent("UNIT_RESISTOTHER_COLD");			--¼õ¿¹ÊôÐÔ
	this:RegisterEvent("UNIT_RESISTOTHER_FIRE");
	this:RegisterEvent("UNIT_RESISTOTHER_LIGHT");
	this:RegisterEvent("UNIT_RESISTOTHER_POSION");

	this:RegisterEvent("UNIT_VIGOR");		-- ×¢²á»îÁ¦Öµ
	this:RegisterEvent("UNIT_ENERGY");	-- ×¢²á¾«Á¦Öµ

	this:RegisterEvent("GUILD_SHOW_MYGUILDNAME"); --°ï»áÐÅÏ¢¸üÐÂ

	-- ÊÖ¶¯µ÷ÕûµãÊý³É¹¦
	this:RegisterEvent("MANUAL_ATTR_SUCCESS_EQUIP");

	this:RegisterEvent("UPDATE_DUR");

	this:RegisterEvent("SEX_CHANGED");
end

function SelfEquip_OnLoad()

	-- action buttion °´Å¥
	g_WEAPON   = SelfEquip_11;		--ÎäÆ÷
	g_ARMOR    = SelfEquip_12;		--ÒÂ·þ
	g_CAP      = SelfEquip_1;		--Ã±×Ó
	g_CUFF     = SelfEquip_4;		--ÊÖÌ×
	g_BOOT     = SelfEquip_6;		--Ð¬
	g_RING     = SelfEquip_7;		--½äÖ¸
	g_SASH     = SelfEquip_5;		--Ñü´ø
	g_NECKLACE = SelfEquip_13;		--ÏîÁ´
	g_Dark	   = SelfEquip_14;		--°µÆ÷
	g_RING_2	 = SelfEquip_8;		--½äÖ¸2
	g_CHARM		 = SelfEquip_9;		--»¤·û
	g_CHARM_2	 = SelfEquip_10;		--»¤·û2
	g_WRIST		 = SelfEquip_3;		--»¤Íó
	g_SHOULDER = SelfEquip_2;		--»¤¼ç
	g_DRESS		 = SelfEquip_15;		--Ê±×°

	g_EquipMask[0]	= SelfEquip_11_Mask;
	g_EquipMask[2]	= SelfEquip_12_Mask;
	g_EquipMask[1]	= SelfEquip_1_Mask;
	g_EquipMask[3]	= SelfEquip_4_Mask;
	g_EquipMask[4]	= SelfEquip_6_Mask;
	g_EquipMask[6]	= SelfEquip_7_Mask;
	g_EquipMask[5]	= SelfEquip_5_Mask;
	g_EquipMask[7]	= SelfEquip_13_Mask;
	g_EquipMask[8]	= SelfEquip_14_Mask;
	g_EquipMask[11]	= SelfEquip_8_Mask;
	g_EquipMask[12]	= SelfEquip_9_Mask;
	g_EquipMask[13]	= SelfEquip_10_Mask;
	g_EquipMask[14]	= SelfEquip_3_Mask;
	g_EquipMask[15]	= SelfEquip_2_Mask;
	g_EquipMask[16]	= SelfEquip_15_Mask;

    g_PropertyTable[1] = SelfEquip_Str_Plus;
    g_PropertyTable[2] = SelfEquip_Nimbus_Plus;
    g_PropertyTable[3] = SelfEquip_PhysicalStrength_Plus;
    g_PropertyTable[4] = SelfEquip_Stability_Plus;
    g_PropertyTable[5] = SelfEquip_Footwork_Plus;
    g_PropertyTable[6] = SelfEquip_Perporty1_Plus;
    g_PropertyTable[7] = SelfEquip_Perporty2_Plus;
    g_PropertyTable[8] = SelfEquip_Perporty3_Plus;
    g_PropertyTable[9] = SelfEquip_Perporty4_Plus;
    g_PropertyTable[10] = SelfEquip_Perporty7_Plus;
    g_PropertyTable[11] = SelfEquip_Perporty6_Plus;

	SELFEQUIP_TAB_TEXT = {
		[0] = "Ð°",
		"Nhân",
		"Thú",
		"KÜ",
		"Khác",
	};
end

function SelfEquip_DoSubDress()
	local NowTime = tonumber(os.date("%Y%m%d"))
	local SaveTime = DataPool:GetPlayerMission_DataRound(306)
	
	if NowTime > SaveTime then
		g_DRESS:DoSubAction();
	end
end

-- OnEvent
function SelfEquip_OnEvent(event)
	if event == "PLAYER_ENTERING_WORLD" or event == "SCENE_TRANSED" or event == "REFRESH_EQUIP" then
		SelfEquip_DoSubDress()
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 32001 then --Add First Point
		Player:SendAskManualAttr(1, 1, 1, 1, 1);
		
		local Logic = Get_XParam_INT(0)
		
		PushDebugMessage("Phân ph¯i ði¬m hoàn t¤t!")
		if Logic == 7413 then
			PushEvent("REFRESH_EQUIP")
		end
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 32002 then --Giam Khang Am
		--iIceResistLimit = Get_XParam_INT(0);
		
		--PushEvent("REFRESH_EQUIP")
	end
	
	-- ÏÔÊ¾tooltip
	SelfEquip_SetStateTooltip();

	if ( event == "OPEN_EQUIP" ) then

		if(this:IsVisible()) then
			SelfEquip_Close();
			return;
		end
		SelfEquip_Open();


		SelfEquip_FakeObject:SetFakeObject("Player");
		local selfUnionPos = Variable:GetVariable("SelfUnionPos");
		if(selfUnionPos ~= nil) then
			SelfEquip_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end

		Equip_OnUpdateShow();
		Equip_RefreshEquip();

		--ÔÚ´ò¿ªµÄÊ±ºò£¬½«ÊôÐÔÒ³µÄÈ±Ê¡Ò³½øÐÐµ÷Õû
		SelfEquip_SelfEquip:SetCheck(1);
		SelfEquip_SelfData:SetCheck(0);
		SelfEquip_Pet:SetCheck(0);

		-- ÏÔÊ¾¾«Á¦
		SelfEquip_ShowVigor();

		-- ÏÔÊ¾»îÁ¦
		SelfEquip_ShowEnergy();
		SelfEquip_SetTabColor(0);
	end

	if( event == "PLAYER_LEAVE_WORLD") then
		SelfEquip_Close();
		return;
	end
--[[
	if("CUR_TITLE_CHANGED" == event) then
		GetCurTitle();
		return;
	end

	if(event == "GUILD_SHOW_MYGUILDNAME") then
		GetGuildTitle();
		return;
	end
--]]
	-- ×°±¸±ä»¯Ê±Ë¢ÐÂ×°±¸.
	if ("REFRESH_EQUIP" == event) then
		--PushDebugMessage(os.)
		
		local Cloth_Effect = SystemSetup:Get_Display_Dress();
		local Player_GUID = Player:GetGUID();
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DoAction")
		Set_XSCRIPT_ScriptID(045000)
		Set_XSCRIPT_Parameter(0,1)
		Set_XSCRIPT_Parameter(1,Version)
		Set_XSCRIPT_Parameter(2,Cloth_Effect)
		Set_XSCRIPT_Parameter(3,Player_GUID)
		Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT();
		
		Equip_RefreshEquip();
		return;
	end

	if("MANUAL_ATTR_SUCCESS_EQUIP" == event) then

		-- ·ÖÅäÊôÐÔ³É¹¦.
		SelfEquip_ManualAttr_Success();
		--AxTrace( 0,0, "even  ·ÖÅäµãÊý³É¹¦ ====  "..tostring(event));

		-- ÉèÖÃÊÖ¶¯µ÷½ÚµãÊý°´Å¥µÄ×´Ì¬.
		SetAcceptButtonState();

		Equip_OnUpdateShow();
		return;
	end

	--ÒÔÏÂÊÂ¼þÏÞÓÚ´°¿Ú´ò¿ªÊ±
	if(this:IsVisible()) then

		local nNumber=0;
		local nMaxnumber=0;
		local strName;
		--AxTrace( 0,0, "even ===="..tostring(event));
		-- µÈ¼¶
		if ((event == "UNIT_LEVEL" or event == "UNIT_MAX_EXP") and arg0 == "player") then
			--nNumber = Player:GetData( "LEVEL" );
			--SelfEquip_Level:SetText( "Level " .. tostring( nNumber ) );
			--nNumber = Player:GetData("NEEDEXP");
			--SelfEquip_Exp1:SetText( tostring( nNumber ) );
			-- Ë¢ÐÂËùÓÐÐÅÏ¢
			Equip_OnUpdateShow();

		-- Ñª
		elseif((event == "UNIT_HP" or event == "UNIT_MAX_HP")  and arg0 == "player") then
			nNumber = Player:GetData("HP");
			nMaxnumber = Player:GetData( "MAXHP" );

			local strHpText = tostring( nNumber ).."/"..tostring( nMaxnumber );
			strHpText = "#cFAFFA4"..strHpText;
			SelfEquip_HP:SetText( strHpText );
		-- mana
		elseif((event == "UNIT_MP" or event == "UNIT_MAX_MP")  and arg0 == "player") then
			nNumber = Player:GetData( "MP" );
			nMaxnumber = Player:GetData( "MAXMP" );

			local strMpText = tostring( nNumber ).."/"..tostring( nMaxnumber ) ;
			strMpText = "#cFAFFA4"..strMpText;
			SelfEquip_MP:SetText( strMpText );

		-- Å­Æø
		elseif((event == "UNIT_RAGE" )  and arg0 == "player") then
			-- Å­Æø
		  nNumber = Player:GetData("RAGE");
		  nMaxnumber = Player:GetData("MAXRAGE");

		  local strRageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
		  strRageText = "#cFAFFA4"..strRageText;
			SelfEquip_SP:SetText(strRageText );
		--¾­ÑéÖµ
		elseif(event == "UNIT_EXP" and arg0 == "player") then
			nNumber = Player:GetData("EXP");
			SelfEquip_Exp2:SetText( "#cC8B88E"..tostring( nNumber ) );

			-- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
			g_RequireExperience = Player:GetData("NEEDEXP");
			SelfEquip_Exp1:SetText( "#cC8B88E"..tostring( g_RequireExperience ) );

			-- ¸ù¾Ý¾­Ñé½ûÖ¹»òÕß´ò¿ªÉý¼¶
			if(nNumber >= g_RequireExperience and tonumber(Player:GetData("LEVEL"))<LEVEL_MAX_ENABLE) then

				SelfEquip_UpLevel:Enable();
			else

				SelfEquip_UpLevel:Disable();
			end


		--STR
		elseif(event == "UNIT_STR" and arg0 == "player") then
			nNumber = Player:GetData("STR");
			SelfEquip_Str:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_STR" and arg0 == "player") then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_STR");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Str_Plus:SetText( StrText );
			else
				SelfEquip_Str_Plus:SetText("");
			end


		--SPR
		elseif(event == "UNIT_SPR" and arg0 == "player") then
			nNumber = Player:GetData("SPR");
			SelfEquip_Nimbus:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_SPR" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_SPR");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Nimbus_Plus:SetText( StrText );
			else
				SelfEquip_Nimbus_Plus:SetText("");
			end

		--CON
		elseif(event == "UNIT_CON" and arg0 == "player") then
			nNumber = Player:GetData("CON");
			SelfEquip_PhysicalStrength:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_CON" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_CON");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_PhysicalStrength_Plus:SetText( StrText );
			else
				SelfEquip_PhysicalStrength_Plus:SetText("");
			end

		--INT
		elseif(event == "UNIT_INT" and arg0 == "player") then
			nNumber = Player:GetData("INT");
			SelfEquip_Stability:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_INT" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_INT");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Stability_Plus:SetText( StrText );
			else
				SelfEquip_Stability_Plus:SetText("");
			end

		--DEX
		elseif(event == "UNIT_DEX" and arg0 == "player") then
			nNumber = Player:GetData("DEX");
			SelfEquip_Footwork:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_DEX" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_DEX");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Footwork_Plus:SetText( StrText );
			else
				SelfEquip_Footwork_Plus:SetText("");
			end
		--POINT_REMAIN
		elseif(event == "UNIT_POINT_REMAIN" and arg0 == "player") then
			-- ÖØÖÃÊôÐÔµãµÄ·ÖÅä
			SelfEquip_ResetCharRemainPoint();

		--ATT_PHYSICS
		elseif(event == "UNIT_ATT_PHYSICS" and arg0 == "player") then
			nNumber = Player:GetData("ATT_PHYSICS");
			SelfEquip_Perporty1:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_ATT_PHYSICS" and arg0 == "player") then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_ATTP");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty1_Plus:SetText( StrText );
			else
				SelfEquip_Perporty1_Plus:SetText("");
			end
		--DEF_PHYSICS
		elseif(event == "UNIT_DEF_PHYSICS" and arg0 == "player") then
			nNumber = Player:GetData("DEF_PHYSICS");
			if nNumber > 999999 then --Îª°ïÕ½ÐÞ¸ÄµÄ modified by hukai
				SelfEquip_Perporty3:SetText( "??????" );
			else
				SelfEquip_Perporty3:SetText( tostring( nNumber ) );
			end

		elseif(event == "UNIT_XIULIAN_DEF_PHYSICS" and arg0 == "player") then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_DEFP");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty3_Plus:SetText( StrText );
			else
				SelfEquip_Perporty3_Plus:SetText("");
			end
		--ATT_MAGIC
		elseif(event == "UNIT_ATT_MAGIC" and arg0 == "player") then
			nNumber = Player:GetData("ATT_MAGIC");
			SelfEquip_Perporty2:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_ATT_MAGIC" and arg0 == "player" ) then
		    if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_ATTM");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty2_Plus:SetText( StrText );
			else
				SelfEquip_Perporty2_Plus:SetText("");
			end

		--DEF_MAGIC
		elseif(event == "UNIT_DEF_MAGIC" and arg0 == "player") then
			nNumber = Player:GetData("DEF_MAGIC");
			if nNumber > 999999 then --Îª°ïÕ½ÐÞ¸ÄµÄ modified by hukai
				SelfEquip_Perporty4:SetText( "??????" );
			else
				SelfEquip_Perporty4:SetText( tostring( nNumber ) );
			end

		elseif(event == "UNIT_XIULIAN_DEF_MAGIC" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_DEFM");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty4_Plus:SetText( StrText );
			else
				SelfEquip_Perporty4_Plus:SetText("");
			end


		--UNIT_HUIXINFANGYU
--		elseif(event == "UNIT_MISS" and arg0 == "player") then
--			nNumber = Player:GetData("MISS");
--			SelfEquip_Perporty5:SetText( tostring( nNumber ) );

		--UNIT_MISS
		elseif(event == "UNIT_MISS" and arg0 == "player") then
			nNumber = Player:GetData("MISS");
			SelfEquip_Perporty6:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_MISS" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_MISS");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty6_Plus:SetText( StrText );
			else
				SelfEquip_Perporty6_Plus:SetText("");
			end

		--UNIT_HIT
		elseif(event == "UNIT_HIT" and arg0 == "player") then
			nNumber = Player:GetData("HIT");
			SelfEquip_Perporty7:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_HIT" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_HIT");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty7_Plus :SetText( StrText );
			else
				SelfEquip_Perporty7_Plus :SetText("");
			end

		--UNIT_CRITICAL_ATTACK
		elseif(event == "UNIT_CRITICAL_ATTACK" and arg0 == "player") then
			nNumber = Player:GetData("CRITICALATTACK");
			SelfEquip_Perporty8:SetText( tostring( nNumber ) );

		--UNIT_CRITICAL_DEFENCE
		elseif(event == "UNIT_CRITICAL_DEFENCE" and arg0 == "player") then
			nNumber = Player:GetData("CRITICALDEFENCE");
			SelfEquip_Perporty9:SetText( tostring( nNumber ) );

		--±ù·ÀÓù
		elseif(event == "UNIT_DEF_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--»ð·ÀÓù
		elseif(event == "UNIT_DEF_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--µç·ÀÓù
		elseif(event == "UNIT_DEF_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¶¾·ÀÓù
		elseif(event == "UNIT_DEF_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õ±ù¿¹
		elseif(event == "UNIT_RESISTOTHER_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õ»ð¿¹
		elseif(event == "UNIT_RESISTOTHER_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õµç¿¹
		elseif(event == "UNIT_RESISTOTHER_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õ¶¾¿¹
		elseif(event == "UNIT_RESISTOTHER_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--±ù¹¥»÷
		elseif(event == "UNIT_ATT_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--»ð¹¥»÷
		elseif(event == "UNIT_ATT_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--µç¹¥»÷
		elseif(event == "UNIT_ATT_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--¶¾¹¥»÷
		elseif(event == "UNIT_ATT_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		elseif(event == "UNIT_VIGOR" and arg0 == "player") then

			SelfEquip_ShowVigor();

		elseif(event == "UNIT_ENERGY" and arg0 == "player") then

			SelfEquip_ShowEnergy();
		elseif( event == "UPDATE_DUR" ) then
			SelfEquip_UpdateMask();
		else

			-- ²»ÒªÄ¬ÈÏµÄÇé¿öÏÂµ÷ÓÃÕâ¸öº¯Êý£¬ »áÔì³ÉÊôÐÔµãÊýÄªÃûÆäÃîµÄË¢ÐÂ¡£
			-- 2006-3-23
			--Equip_OnUpdateShow();
		end;

		if event == "SEX_CHANGED"  then
			SelfEquip_FakeObject : Hide();
			SelfEquip_FakeObject : Show();
			SelfEquip_FakeObject:SetFakeObject("Player");
		end
		return;
	end

	-- ÆäËüÊÂ¼þ¶¼¸üÐÂÈËÎïµÄ»ù±¾ÐÅÏ¢.
	--Equip_OnUpdateShow();

end

-- ¸üÐÂÖ÷½Ç»ù±¾ÐÅÏ¢
function Equip_OnUpdateShow()



	g_RemainPoint 			= 0;	-- Ê£ÓàµãÊý
	g_CurExperience 	  = 0;	-- µ±Ç°Ê£Óà¾­Ñé
	g_RequireExperience = 0;  -- Éý¼¶ËùÐè¾­Ñé

	g_AddStr = 0;					-- ·ÖÅäÔÚÁ¦Á¿ÉÏµÄÊ£ÓàµãÊý.
	g_AddSpr = 0;					-- ·ÖÅäÔÚÁéÆøÉÏµÄÊ£ÓàµãÊý.
	g_AddCon = 0;					-- ·ÖÅäÔÚÌåÖÊÉÏµÄÊ£ÓàµãÊý.
	g_AddInt = 0;					-- ·ÖÅäÔÚ¶¨Á¦ÉÏµÄÊ£ÓàµãÊý.
	g_AddDex = 0;					-- ·ÖÅäÔÚÉí·¨ÉÏµÄÊ£ÓàµãÊý.
	g_CurRemainPoint = 0;	-- ·ÖÅäºóµÄÊ£ÓàµãÊý


	local nNumber=0;
	local nMaxnumber=0;
	local strName;

	-- ½ûÖ¹Ôö¼ÓÇ±ÄÜ°´Å¥.
	Equip_Addition_Button1:Disable();
	Equip_Decrease_Button1:Disable();

	Equip_Addition_Button2:Disable();
	Equip_Decrease_Button2:Disable();

	Equip_Addition_Button3:Disable();
	Equip_Decrease_Button3:Disable();

	Equip_Addition_Button4:Disable();
	Equip_Decrease_Button4:Disable();

	Equip_Addition_Button5:Disable();
	Equip_Decrease_Button5:Disable();

	-- ÔÊÐí°´Å¥
	-- SelfEquip_Accept:Enalbe();

	-- ½ûÖ¹Ôö¼Ó°´Å¥
	-- SelfEquip_Accept:Disable();

	-- µÃµ½×Ô¼ºµÄÃû×Ö
  strName = Player:GetName();
	SelfEquip_PageHeader:SetText("#gFF0FA0".. strName );

	-- µÃµ½ÑªÖµ
	nNumber = Player:GetData("HP");
	nMaxnumber = Player:GetData( "MAXHP" );
	local HPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	HPText = "#cFAFFA4"..HPText;
	SelfEquip_HP:SetText( HPText );


	-- µÃµ½Ä§·¨Öµ
	nNumber = Player:GetData( "MP" );
	nMaxnumber = Player:GetData( "MAXMP" );

	local MPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	MPText = "#cFAFFA4"..MPText;
	SelfEquip_MP:SetText( MPText );

	-- Å­Æø
  nNumber = Player:GetData("RAGE");
  nMaxnumber = Player:GetData("MAXRAGE");
  local RageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
  RageText = "#cFAFFA4"..RageText;
 	SelfEquip_SP:SetText( RageText );

	-- µÃµ½µ±Ç°¾­Ñé
	g_CurExperience = Player:GetData("EXP");
	local CurExpText = tostring( g_CurExperience );
	CurExpText = "#cC8B88E"..CurExpText;
	SelfEquip_Exp2:SetText( CurExpText );

	-- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
	g_RequireExperience = Player:GetData("NEEDEXP");
	local NeedExpText =  tostring( g_RequireExperience );
	NeedExpText = "#cC8B88E"..NeedExpText;
	SelfEquip_Exp1:SetText( NeedExpText );

	-- ¸ù¾Ý¾­Ñé½ûÖ¹»òÕß´ò¿ªÉý¼¶
	if(g_CurExperience >= g_RequireExperience) then

		SelfEquip_UpLevel:Enable();
	else

		SelfEquip_UpLevel:Disable();
	end

	-- µÃµ½µÈ¼¶
	nNumber = Player:GetData( "LEVEL" );
	local LevelText = tostring( nNumber ).."  c¤p";
	LevelText = "#cC8B88E"..LevelText;
	SelfEquip_Level:SetText( LevelText );

	-- Èç¹ûµÈ¼¶´óÓÚÄ³Öµ½ûÖ¹°´Å¥.
	if( LEVEL_MAX_ENABLE <= nNumber ) then
		SelfEquip_UpLevel:Disable();
	end

  -- Á¦Á¿
  nNumber = Player:GetData("STR");
  local StrText = tostring( nNumber );
  --StrText = "#DED784"..StrText;
	SelfEquip_Str:SetText( StrText );

	-- ÁéÆø
  nNumber = Player:GetData("SPR");
  local SprText = tostring( nNumber );
  --SprText = "#DED784"..SprText;
	SelfEquip_Nimbus:SetText( SprText );

	-- ÌåÖÊ
	nNumber = Player:GetData("CON");
	local ConText = tostring( nNumber );
	SelfEquip_PhysicalStrength:SetText( ConText );


	-- ¶¨Á¦
	nNumber = Player:GetData("INT");
	SelfEquip_Stability:SetText( tostring( nNumber ) );

	-- Éí·¨
	nNumber = Player:GetData("DEX");
	SelfEquip_Footwork:SetText( tostring( nNumber ) );

	-- Ê£ÓàµãÊý
	g_RemainPoint = Player:GetData("POINT_REMAIN");
	SelfEquip_Potential:SetText( tostring( g_RemainPoint ) );
	--AxTrace( 0,0, "µÃµ½Ê£ÓàµãÊý"..tostring( g_RemainPoint ));
	g_CurRemainPoint = g_RemainPoint;

	if(g_CurRemainPoint > 0) then

		Equip_Addition_Button1:Enable();
		Equip_Addition_Button2:Enable();
		Equip_Addition_Button3:Enable();
		Equip_Addition_Button4:Enable();
		Equip_Addition_Button5:Enable();

	end;


	-- ÎïÀí¹¥»÷
	nNumber = Player:GetData("ATT_PHYSICS");
	SelfEquip_Perporty1:SetText( tostring( nNumber ) );

	-- ÎïÀí·ÀÓù
	nNumber = Player:GetData("DEF_PHYSICS");
	if nNumber > 999999 then --Îª°ïÕ½ÐÞ¸ÄµÄ modified by hukai
		SelfEquip_Perporty3:SetText( "??????" );
	else
		SelfEquip_Perporty3:SetText( tostring( nNumber ) );
	end

	-- Ä§·¨¹¥»÷
	nNumber = Player:GetData("ATT_MAGIC");
	SelfEquip_Perporty2:SetText( tostring( nNumber ) );

	-- Ä§·¨·ÀÓù
	nNumber = Player:GetData("DEF_MAGIC");
	if nNumber > 999999 then --Îª°ïÕ½ÐÞ¸ÄµÄ modified by hukai
		SelfEquip_Perporty4:SetText( "??????" );
	else
		SelfEquip_Perporty4:SetText( tostring( nNumber ) );
	end

	-- ÉÁ±ÜÂÊ
	nNumber = Player:GetData("MISS");
	SelfEquip_Perporty6:SetText( tostring( nNumber ) );

	-- ÃüÖÐÂÊ
	nNumber = Player:GetData("HIT");
	SelfEquip_Perporty7:SetText( tostring( nNumber ) );

	--zhangqiang£¬ÐÞÁ¶ÊôÐÔ¼Ó³É==============================
	if Player:GetData("XIULIANFLAG") > 0 then
		nNumber = Player:GetData("XIULIAN_STR");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Str_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_SPR");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Nimbus_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_CON");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_PhysicalStrength_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_INT");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Stability_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_DEX");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Footwork_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_HIT");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty7_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_ATTP");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty1_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_DEFP");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty3_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_ATTM");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty2_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_DEFM");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty4_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_MISS");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty6_Plus:SetText( StrText );
	else
		SelfEquip_Str_Plus:SetText( "" );
		SelfEquip_Nimbus_Plus:SetText( "" );
		SelfEquip_PhysicalStrength_Plus:SetText( "" );
		SelfEquip_Stability_Plus:SetText( "" );
		SelfEquip_Footwork_Plus:SetText( "" );
		SelfEquip_Perporty7_Plus:SetText( "" );
		SelfEquip_Perporty1_Plus:SetText( "" );
		SelfEquip_Perporty3_Plus:SetText( "" );
		SelfEquip_Perporty2_Plus:SetText( "" );
		SelfEquip_Perporty4_Plus:SetText( "" );
		SelfEquip_Perporty6_Plus:SetText( "" );
	end
	--=======================================================

	-- »áÐÄ¹¥»÷
	nNumber = Player:GetData("CRITICALATTACK");
	SelfEquip_Perporty8:SetText( tostring( nNumber ) );

	SelfEquip_Perporty8_Plus:SetText( "" );

	-- »áÐÄ·ÀÓù
	nNumber = Player:GetData("CRITICALDEFENCE");
	SelfEquip_Perporty9:SetText( tostring( nNumber ) );

	SelfEquip_Perporty9_Plus:SetText( "" );

	-- »îÁ¦
	SelfEquip_ShowVigor();

	-- ¾«Á¦
	SelfEquip_ShowEnergy();

	-- ÃÅÅÉ
	local menpai = Player:GetData("MEMPAI");
	local strName = "";

	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == menpai) then
		strName = "Thiªu Lâm";

	elseif(1 == menpai) then
		strName = "Minh Giáo";

	elseif(2 == menpai) then
		strName = "Cái Bang";

	elseif(3 == menpai) then
		strName = "Võ Ðang";

	elseif(4 == menpai) then
		strName = "Nga My";

	elseif(5 == menpai) then
		strName = "Tinh Túc";

	elseif(6 == menpai) then
		strName = "Thiên Long";

	elseif(7 == menpai) then
		strName = "Thiên S½n";

	elseif(8 == menpai) then
		strName = "Tiêu Dao";

	elseif(9 == menpai) then
		strName = "Không có";
		
	elseif(10 == menpai) then
		strName = "Mµ Dung";
	end

	-- ÉèÖÃÏÔÊ¾µÄÃÅÅÉ.
	SelfEquip_MenPai:SetText(strName);

	SetAcceptButtonState();

end

-- Ë¢ÐÂ×°±¸
function Equip_RefreshEquip()


	--  Çå¿Õ°´Å¥ÏÔÊ¾Í¼±ê
	g_WEAPON:SetActionItem(-1);			--ÎäÆ÷
	g_CAP:SetActionItem(-1);				--Ã±×Ó
	g_ARMOR:SetActionItem(-1);			--¿ø¼×
	g_CUFF:SetActionItem(-1);				--ÊÖÌ×
	g_BOOT:SetActionItem(-1);				--Ð¬
	g_SASH:SetActionItem(-1);				--Ñü´ø
	g_RING:SetActionItem(-1);				--½äÖ¸
	g_NECKLACE:SetActionItem(-1);		--ÏîÁ´
	g_Dark:SetActionItem(-1);			--°µÆ÷
	g_RING_2:SetActionItem(-1);			--½äÖ¸2
	g_CHARM:SetActionItem(-1);			--»¤·û
	g_CHARM_2:SetActionItem(-1);		--»¤·û2
	g_WRIST:SetActionItem(-1);			--»¤Íó
	g_SHOULDER:SetActionItem(-1);		--»¤¼ç
	g_DRESS:SetActionItem(-1);			--Ê±×°

	local ActionWeapon 		= EnumAction(0, "equip");
	local ActionCap    		= EnumAction(1, "equip");
	local ActionArmor  		= EnumAction(2, "equip");
	local ActionCuff   		= EnumAction(3, "equip");
	local ActionBoot   		= EnumAction(4, "equip");
	local ActionSash   		= EnumAction(5, "equip");
	local ActionRing    	= EnumAction(6, "equip");
	local ActionNecklace	= EnumAction(7, "equip");
	local ActionMount			= EnumAction(17, "equip");
	local ActionRing_2		= EnumAction(11, "equip");
	local ActionCharm 		= EnumAction(12, "equip");
	local ActionCharm_2   = EnumAction(13, "equip");
	local ActionWrist  		= EnumAction(14, "equip");
	local ActionShoulder  = EnumAction(15, "equip");
	local ActionDress   	= EnumAction(16, "equip");

	-- ÏÔÊ¾ÈËÉíÉÏµÄÎäÆ÷×°±¸
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--ÎäÆ÷
	g_CAP:SetActionItem(ActionCap:GetID());						--Ã±×Ó
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--¿ø¼×
	g_CUFF:SetActionItem(ActionCuff:GetID());					--»¤Íó
	g_BOOT:SetActionItem(ActionBoot:GetID());					--Ð¬
	g_SASH:SetActionItem(ActionSash:GetID());					--Ñü´ø
	g_RING:SetActionItem(ActionRing:GetID());					--½ä×Ó
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--ÏîÁ´
	g_Dark:SetActionItem(ActionMount:GetID());				--°µÆ÷
	g_RING_2:SetActionItem(ActionRing_2:GetID());			--½äÖ¸2
	g_CHARM:SetActionItem(ActionCharm:GetID());			--»¤·û
	g_CHARM_2:SetActionItem(ActionCharm_2:GetID());		--»¤·û2
	g_WRIST:SetActionItem(ActionWrist:GetID());			--»¤Íó
	g_SHOULDER:SetActionItem(ActionShoulder:GetID());		--»¤¼ç
	g_DRESS:SetActionItem(ActionDress:GetID());			--Ê±×°

	local IsDisplay = SystemSetup:Get_Display_Dress();
	if IsDisplay == 1 then
		IsDisplay = 0
	else
		IsDisplay = 1
	end
	SelfEquip_Mode:SetCheck(IsDisplay);
	SelfEquip_UpdateMask();
end

function SelfEquip_Equip_Click( nTypeIn,buttonIn )

	local nType = tonumber( nTypeIn );
	local button = tonumber( buttonIn );
	if( nType == 11 ) then
		if( button == 1 ) then
			g_WEAPON:DoAction();	--ÎäÆ÷
		else
			g_WEAPON:DoSubAction();	--ÎäÆ÷
		end
	elseif( nType == 12 ) then
		if( button == 1 ) then
			g_ARMOR:DoAction();	--ÒÂ·þ
		else
			g_ARMOR:DoSubAction();	--ÒÂ·þ
		end
	elseif( nType == 1 ) then
		if( button == 1 ) then
			g_CAP:DoAction();	--Ã±×Ó
		else
			g_CAP:DoSubAction();	--Ã±×Ó
		end
	elseif( nType == 4 ) then
		if( button == 1 ) then
			g_CUFF:DoAction();	--ÊÖÌ×
		else
			g_CUFF:DoSubAction();	--ÊÖÌ×
		end
	elseif( nType == 6 ) then
		if( button == 1 ) then
			g_BOOT:DoAction();	--Ð¬
		else
			g_BOOT:DoSubAction();	--Ð¬
		end
	elseif( nType == 7 ) then
		if( button == 1 ) then
			g_RING:DoAction();	--½äÖ¸
		else
			g_RING:DoSubAction();	--½äÖ¸
		end
	elseif( nType == 5 ) then
		if( button == 1 ) then
			g_SASH:DoAction();	--Ñü´ø
		else
			g_SASH:DoSubAction();	--Ñü´ø
		end
	elseif( nType == 13) then
		if( button == 1 ) then
			g_NECKLACE:DoAction();	--ÏîÁ´
		else
			g_NECKLACE:DoSubAction();	--ÏîÁ´
		end
	elseif( nType == 14 ) then
		if( button == 1 ) then
			g_Dark:DoAction();	--°µÆ÷
		else
			g_Dark:DoSubAction();	--°µÆ÷
		end
	elseif( nType == 2 ) then
		if( button == 1 ) then
			g_SHOULDER:DoAction();	--»¤¼ç
		else
			g_SHOULDER:DoSubAction();	--»¤¼ç
		end
	elseif( nType == 3 ) then
		if( button == 1 ) then
			g_WRIST:DoAction();	--»¤Íó
		else
			g_WRIST:DoSubAction();	--»¤Íó
		end
	elseif( nType == 8 ) then
		if( button == 1 ) then
			g_RING_2:DoAction();	--½äÖ¸2
		else
			g_RING_2:DoSubAction();	--½äÖ¸
		end
	elseif( nType == 9 ) then
		if( button == 1 ) then
			g_CHARM:DoAction();	--»¤·û
		else
			g_CHARM:DoSubAction();	--»¤·û
		end
	elseif( nType == 10 ) then
		if( button == 1 ) then
			g_CHARM_2:DoAction();	--»¤·û2
		else
			g_CHARM_2:DoSubAction();	--»¤·û2
		end
	elseif( nType == 15 ) then
		if( button == 1 ) then
			g_DRESS:DoAction();	--Ê±×°
		else
			g_DRESS:DoSubAction();	--Ê±×°
		end
	end
end


----------------------------------------------------------------------------
-- Á¦Á¿µãÊý°´Å¥
--
-- ¼õÉÙÁ¦Á¿µãÊý°´Å¥
function SelfEquip_Dec1_Click()

	if (g_AddStr > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end;

		g_AddStr = g_AddStr - 1;
	end

	if(g_AddStr <= 0) then
		g_AddStr = 0;
		Equip_Decrease_Button1:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Á¦Á¿
	ShowCurStr();

end

-- Ôö¼ÓÁ¦Á¿µãÊý°´Å¥
function SelfEquip_Add1_Click()

	if (g_CurRemainPoint > 0) then
		g_AddStr = g_AddStr + 1;
		if(g_AddStr > 0) then
			Equip_Decrease_Button1:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Á¦Á¿
	ShowCurStr();

end


-----------------------------------------------------------------------------
-- ÁéÆøµãÊý°´Å¥
--
-- ¼õÉÙÁéÆøµãÊý°´Å¥
function SelfEquip_Dec2_Click()

	if (g_AddSpr > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddSpr = g_AddSpr - 1;
	end

	if(g_AddSpr <= 0) then

		g_AddSpr = 0;
		Equip_Decrease_Button2:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÁéÆø
	ShowCurSpr();

end

-- Ôö¼ÓÁéÆøµãÊý°´Å¥
function SelfEquip_Add2_Click()

	if (g_CurRemainPoint > 0) then
		g_AddSpr = g_AddSpr + 1;
		if(g_AddSpr > 0) then
			Equip_Decrease_Button2:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÁéÆø
	ShowCurSpr();

end


-----------------------------------------------------------------------------
-- ÌåÖÊµãÊý°´Å¥
--
-- ¼õÉÙÌåÖÊµãÊý°´Å¥
function SelfEquip_Dec3_Click()

	if (g_AddCon > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddCon = g_AddCon - 1;
	end

	if(g_AddCon <= 0) then

		g_AddCon = 0;
		Equip_Decrease_Button3:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÌåÖÊ
	ShowCurCon();


end

-- Ôö¼ÓÌåÖÊµãÊý°´Å¥
function SelfEquip_Add3_Click()

	if (g_CurRemainPoint > 0) then
		g_AddCon = g_AddCon + 1;
		if(g_AddCon > 0) then
			Equip_Decrease_Button3:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÌåÖÊ
	ShowCurCon();

end


-------------------------------------------------------------------------------
-- ¶¨Á¦µãÊý°´Å¥
--
-- ¼õÉÙ¶¨Á¦µãÊý°´Å¥
function SelfEquip_Dec4_Click()

	if (g_AddInt > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddInt = g_AddInt - 1;
	end

	if(g_AddInt <= 0) then

		g_AddInt = 0;
		Equip_Decrease_Button4:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾¶¨Á¦
	ShowCurInt();

end

-- Ôö¼Ó¶¨Á¦µãÊý°´Å¥
function SelfEquip_Add4_Click()

	if (g_CurRemainPoint > 0) then
		g_AddInt = g_AddInt + 1;
		if(g_AddInt > 0) then
			Equip_Decrease_Button4:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then

		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾¶¨Á¦
	ShowCurInt();

end



--------------------------------------------------------------------------------
-- Éí·¨µãÊý°´Å¥
--
-- ¼õÉÙÉí·¨µãÊý°´Å¥
function SelfEquip_Dec5_Click()

	if (g_AddDex > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddDex = g_AddDex - 1;
	end

	if(g_AddDex <= 0) then

		g_AddDex = 0;
		Equip_Decrease_Button5:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Éí·¨
	ShowCurDex();

end

-- Ôö¼ÓÉí·¨µãÊý°´Å¥
function SelfEquip_Add5_Click()

	if (g_CurRemainPoint > 0) then
		g_AddDex = g_AddDex + 1;
		if(g_AddDex > 0) then
			Equip_Decrease_Button5:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then

		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Éí·¨
	ShowCurDex();

end

--------------------------------------------------------------------------------
--
-- ´ò¿ªËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function EanbleAskAttrBn(bEnable)

	Equip_Addition_Button1:Enable();
	Equip_Addition_Button2:Enable();
	Equip_Addition_Button3:Enable();
	Equip_Addition_Button4:Enable();
	Equip_Addition_Button5:Enable();
end

--------------------------------------------------------------------------------
--
-- ´ò¿ªËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function EanblePointAddButtion()

	Equip_Addition_Button1:Enable();
	Equip_Addition_Button2:Enable();
	Equip_Addition_Button3:Enable();
	Equip_Addition_Button4:Enable();
	Equip_Addition_Button5:Enable();
end


--------------------------------------------------------------------------------
--
-- ½ûÖ¹ËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function DisablePointAddButtion()

	Equip_Addition_Button1:Disable();
	Equip_Addition_Button2:Disable();
	Equip_Addition_Button3:Disable();
	Equip_Addition_Button4:Disable();
	Equip_Addition_Button5:Disable();
end


--------------------------------------------------------------------------------
--
-- ´ò¿ªËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function EanblePointDecButtion()

	Equip_Decrease_Button1:Enable();
	Equip_Decrease_Button2:Enable();
	Equip_Decrease_Button3:Enable();
	Equip_Decrease_Button4:Enable();
	Equip_Decrease_Button5:Enable();
end


--------------------------------------------------------------------------------
--
-- ½ûÖ¹ËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function DisablePointDecButtion()

	Equip_Decrease_Button1:Disable();
	Equip_Decrease_Button2:Disable();
	Equip_Decrease_Button3:Disable();
	Equip_Decrease_Button4:Disable();
	Equip_Decrease_Button5:Disable();
end


---------------------------------------------------------------------------------
--
-- ÏÔÊ¾µ±Ç°µÄÇ±ÄÜ
--
function ShowCurRemainPoint()

	SelfEquip_Potential:SetText( tostring( g_CurRemainPoint ) );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾Á¦Á¿
--
function ShowCurStr()

	SelfEquip_Str:SetText( tostring( g_AddStr + Player:GetData("STR") ) );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾ÁéÆø
--
function ShowCurSpr()

	SelfEquip_Nimbus:SetText( tostring( g_AddSpr + Player:GetData("SPR"))  );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾ÌåÖÊ
--
function ShowCurCon()

	SelfEquip_PhysicalStrength:SetText( tostring( g_AddCon + Player:GetData("CON"))  );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾¶¨Á¦
--
function ShowCurInt()

	SelfEquip_Stability:SetText( tostring( g_AddInt + Player:GetData("INT"))  );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾Éí·¨
--
function ShowCurDex()

	SelfEquip_Footwork:SetText( tostring( g_AddDex + Player:GetData("DEX"))  );

end



---------------------------------------------------------------------------------
--
-- ½ûÖ¹, ´ò¿ªÉêÇëÇ±ÄÜ°´Å¥Ç±ÄÜ°´Å¥
--
function SetAcceptButtonState()

	if(g_CurRemainPoint == g_RemainPoint) then

		SelfEquip_Accept:Disable();
	else

		--SelfEquip_Accept:Disable();
		SelfEquip_Accept:Enable();
	end;

end

---------------------------------------------------------------------------------
--
-- ÉêÇëÔö¼ÓÇ±ÄÜ
--
function SelfEquip_Accept_Click()
	-- ·¢ËÍ¸ü¸ÄÊôÐÔÇëÇó.
	Player:SendAskManualAttr(g_AddStr, g_AddSpr, g_AddCon, g_AddInt, g_AddDex);
end


---------------------------------------------------------------------------------
--
-- ÊÖ¶¯µ÷Õû³É¹¦
--
function SelfEquip_ManualAttr_Success()

	g_AddStr = 0;					-- ·ÖÅäÔÚÁ¦Á¿ÉÏµÄÊ£ÓàµãÊý.
	g_AddSpr = 0;					-- ·ÖÅäÔÚÁéÆøÉÏµÄÊ£ÓàµãÊý.
	g_AddCon = 0;					-- ·ÖÅäÔÚÌåÖÊÉÏµÄÊ£ÓàµãÊý.
	g_AddInt = 0;					-- ·ÖÅäÔÚ¶¨Á¦ÉÏµÄÊ£ÓàµãÊý.
	g_AddDex = 0;					-- ·ÖÅäÔÚÉí·¨ÉÏµÄÊ£ÓàµãÊý.

	-- ½ûÖ¹ËùÓÐ¼õÉÙµãÊý°´Å¥
	DisablePointDecButtion();

	-- Ê£ÓàÃ»ÓÐ·ÖÅäµÄµãÊý
	g_RemainPoint = g_CurRemainPoint;
	if(g_CurRemainPoint > 0) then

		EanblePointAddButtion();
	end


end

---------------------------------------------------------------------------------
--
-- µã»÷³ÆºÅ°´Å¥
--
function TitleButton_Click()

	g_bOpenTitleDlg = 1;
	-- ´ò¿ª³ÆºÅ½çÃæ
	OpenTitleList();
	--AxTrace( 0,0, "´ò¿ª³ÆºÅ½çÃæ");

end

----------------------------------------------------------------------------------
--
-- µã»÷°ï»á°´Å¥
--
function OpenConfraternity_click()
	Guild:ToggleGuildDetailInfo();
end

----------------------------------------------------------------------------------
--
-- Ñ¡×°Íæ¼ÒÄ£ÐÍ£¨Ïò×ó)
--
function SelfEquip_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SelfEquip_FakeObject:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		SelfEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- Ñ¡×°Íæ¼ÒÄ£ÐÍ£¨ÏòÓÒ)
--
function SelfEquip_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SelfEquip_FakeObject:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		SelfEquip_FakeObject:RotateEnd();
	end
end

---------------------------------------------------------------------------------
--
-- ÉèÖÃ×´Ì¬tooltip
--
function SelfEquip_SetStateTooltip()


	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceDefine  		= Player:GetData( "DEFENCECOLD" );
	local iFireDefine 		= Player:GetData( "DEFENCEFIRE" );
	local iThunderDefine	= Player:GetData( "DEFENCELIGHT" );
	local iPoisonDefine		= Player:GetData( "DEFENCEPOISON" );

	local iIceAttack  		= Player:GetData( "ATTACKCOLD" );
	local iFireAttack 		= Player:GetData( "ATTACKFIRE" );
	local iThunderAttack	= Player:GetData( "ATTACKLIGHT" );
	local iPoisonAttack		= Player:GetData( "ATTACKPOISON" );

	local iIceResistOther	= Player:GetData( "RESISTOTHERCOLD" );
	local iFireResistOther= Player:GetData( "RESISTOTHERFIRE" );
	local iThunderResistOther	= Player:GetData( "RESISTOTHERLIGHT" );
	local iPoisonResistOther= Player:GetData( "RESISTOTHERPOISON" );

	iIceResistLimit = DataPool:GetPlayerMission_DataRound(301)
	iFireResistLimit = DataPool:GetPlayerMission_DataRound(302)
	iThunderResistLimit = DataPool:GetPlayerMission_DataRound(303)
	iPoisonResistLimit = DataPool:GetPlayerMission_DataRound(304)
	
	SelfEquip_IceFastness:SetToolTip("Bång công: "..tostring(iIceAttack).."#rKháng Bång: "..tostring(iIceDefine).."#rGiäm kháng Bång: "..tostring(iIceResistOther).."#{JKXX_091228_1} "..tostring(iIceResistLimit) );
	SelfEquip_FireFastness:SetToolTip("Höa công: "..tostring(iFireAttack).."#rKháng Höa: "..tostring(iFireDefine).."#rGiäm kháng Höa: "..tostring(iFireResistOther).."#{JKXX_091228_2} "..tostring(iFireResistLimit) );
	SelfEquip_ThunderFastness:SetToolTip("Huy«n công: "..tostring(iThunderAttack).."#rKháng Huy«n: "..tostring(iThunderDefine).."#rGiäm kháng Huy«n: "..tostring(iThunderResistOther).."#{JKXX_091228_3} "..tostring(iThunderResistLimit) );
	SelfEquip_PoisonFastness:SetToolTip("Ðµc công: "..tostring(iPoisonAttack).."#rKháng Ðµc: "..tostring(iPoisonDefine).."#rGiäm kháng Ðµc: "..tostring(iPoisonResistOther).."#{JKXX_091228_4} "..tostring(iPoisonResistLimit) );

end


---------------------------------------------------------------------------------
--
-- ÏÔÊ¾»îÁ¦
--
function SelfEquip_ShowVigor()
	--
	local iVigor = Player:GetData("VIGOR");
	local iVigorMax = Player:GetData("MAXVIGOR");
	local VigorText = tostring(iVigor).."/"..tostring(iVigorMax);
	SelfEquip_Vigor:SetText( VigorText );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾»îÁ¦
--
function SelfEquip_ShowEnergy()
	--

	local iEnergy 	 = Player:GetData("ENERGY");
	local iEnergyMax = Player:GetData("MAXENERGY");
	local EnergyText = tostring(iEnergy).."/"..tostring(iEnergyMax);
	SelfEquip_Energy:SetText(EnergyText);


end


----------------------------------------------------------------------------------------
--
-- ¹Ø±Õ½çÃæ
--

function SelfEquip_CloseUI()

	-- ´ò¿ª»òÕß¹Ø±Õ³ÆºÅ½çÃæ
	CloseTitleList();
	SelfEquip_FakeObject:SetFakeObject("");
	SelfEquip_Close();

end;


function Pet_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
	SelfEquip_SetTabColor(0);
end

--´ò¿ª×Ô¼ºµÄ×ÊÁÏÒ³Ãæ
function Pet_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");

end

function SelfEquip_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end

	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = SelfEquip_SelfEquip,
								SelfEquip_SelfData,
								SelfEquip_Pet,
								SelfEquip_Ride,
								SelfEquip_OtherInfo,
							};

	while i < 5 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function Ride_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();
	SelfEquip_SetTabColor(0);
end

function Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
    UpdateDoubleExpData();

end

function SelfEquip_Wuhun_Switch()
	local Level = Player:GetData("LEVEL")
	if Level < 65 then
		SelfEquip_Wuhun : SetCheck(0)
		PushDebugMessage("C¤p 65 m¾i có th¬ sØ døng.")
	else
		Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
		PushEvent("UI_COMMAND",20111211)
	end
end

function SelfEquip_Xiulian_Page_Switch()
	PushDebugMessage("ChÑc nång chßa m·!")
	SelfEquip_SelfEquip:SetCheck(1)
	SelfEquip_Xiulian:SetCheck(0)
end

function SelfEquip_UpdateMask()

	local i
	for i=0,16 do
		if i ~= 9 and i ~=10 then
			SelfEquip_UpdateMaskByIndex( i );
		end
	end
end
function SelfEquip_UpdateMaskByIndex( index )

	local ActionIndex = EnumAction(index, "equip");
	if( ActionIndex:GetEquipDur() < 0.1 ) then
		g_EquipMask[ index ]:Show();
	else
		g_EquipMask[ index ]:Hide();
	end

end

function SelfEquip_Open()
	this:Show();
end
function SelfEquip_Close()
	this:Hide();
end

function SelfEquip_DressDisPlay()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	local IsDisplay = SystemSetup:Get_Display_Dress();	
--	local IsDisplay = SelfEquip_Mode : GetCheck()
	AxTrace(0,0,"IsDisplay="..IsDisplay)
	SelfEquip_Mode : SetCheck(IsDisplay)
	if IsDisplay == 1 then
		IsDisplay = 0
	else
		IsDisplay = 1
	end
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("DoAction")
	Set_XSCRIPT_ScriptID(045000)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_Parameter(1,Version)
	Set_XSCRIPT_Parameter(2,IsDisplay)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	AxTrace(0,0,"IsDisplay 2 ="..IsDisplay)

	SystemSetup:Set_Display_Dress(IsDisplay);
end

function SelfEquip_AskLevelup()
    local PlayerLevel = Player:GetData( "LEVEL" )
    local EvaluateLevelList = { 30, 45, 65, 75, 85 }

    local strMasterName = GetMasterName()

    if "" ~= strMasterName then   --¿Õ´®±íÊ¾ÔÚºÃÓÑÁÐ±íÖÐÃ»ÓÐÕÒµ½Ê¦¸¸Ãû×Ö,ôßÃ»ÓÐÊ¦¸¸
        local ListSize = table.getn( EvaluateLevelList )
		for i = 1, ListSize do
			if EvaluateLevelList[ i ] == ( PlayerLevel+1 ) and PlayerLevel < 45 then
				--´ò¿ªÆÀ¼Û½çÃæ

				AskEvaluateAndLevelup()
				return
			end
		end
    end

    AskLevelUp( tonumber(0) )

end

function SelfEquip_ShowTooltip(Subject)
	if (g_PropertyTable[Subject] ~= nil) then
		if g_PropertyTable[Subject]:GetText() == "" then
			g_PropertyTable[Subject]:SetToolTip("")
		else
			if (g_XiulianTipTable[Subject] ~= nil) then
				g_PropertyTable[Subject]:SetToolTip( g_XiulianTipTable[Subject] )
			end
		end
	end
end

function SelfEquip_ResetCharRemainPoint()
	g_AddStr = 0;					-- ·ÖÅäÔÚÁ¦Á¿ÉÏµÄÊ£ÓàµãÊý.
	g_AddSpr = 0;					-- ·ÖÅäÔÚÁéÆøÉÏµÄÊ£ÓàµãÊý.
	g_AddCon = 0;					-- ·ÖÅäÔÚÌåÖÊÉÏµÄÊ£ÓàµãÊý.
	g_AddInt = 0;					-- ·ÖÅäÔÚ¶¨Á¦ÉÏµÄÊ£ÓàµãÊý.
	g_AddDex = 0;					-- ·ÖÅäÔÚÉí·¨ÉÏµÄÊ£ÓàµãÊý.

	-- ½ûÓÃÊôÐÔµãµÄÔö¼ÓºÍ¼õÉÙ²Ù×÷
	DisablePointAddButtion();
	DisablePointDecButtion();

	-- »ñÈ¡Ê£ÓàÊôÐÔµã
	local nNumber 		= Player:GetData("POINT_REMAIN");
	g_CurRemainPoint 	= nNumber;
	g_RemainPoint   	= nNumber;

	-- ¸üÐÂÏÔÊ¾
	ShowCurStr();
	ShowCurSpr();
	ShowCurCon();
	ShowCurInt();
	ShowCurDex();
	ShowCurRemainPoint();

	if(g_CurRemainPoint > 0) then
		EanblePointAddButtion();
	end

	-- ÉèÖÃÊÖ¶¯µ÷½ÚµãÊý°´Å¥µÄ×´Ì¬.
	SetAcceptButtonState();
end

function SelfEquip_CharDressTime()
	
end