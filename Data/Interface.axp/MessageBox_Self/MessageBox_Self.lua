g_InitiativeClose = 0;
local g_currentList = 0;
local g_currentIndex = 0;
-- °ÚÌ¯µØ×âÌáÊ¾´°¿Ú£¬ÔÚÕâÀïÓÐ·¢ËÍ¸ø·þÎñÆ÷µÄÈ·¶¨¿ªÊ¼°ÚÌ¯µÄÏûÏ¢
local Recycle_Type = -1;
local Recycle_CurSelectItem = -1
local g_FrameInfo = -1;
local FrameInfoList = {
	STALL_RENT_FRAME			= 1,
	DISCARD_ITEM_FRAME			= 2,
	CANNT_DISCARD_ITEM			= 3,
	TEAM_ASKJOIN				= 4,	--ÓÐÈËÑûÇëÄã¼ÓÈë¶ÓÎé
    TEAM_MEMBERINVERT			= 5,	--¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÇóÄãÍ¬Òâ
    TEAM_SOMEASK				= 6,	--Ä³ÈËÉêÇë¼ÓÈë¶ÓÎé
    TEAM_FOLLOW		 			= 7,	--½øÈë×é¶Ó¸úËæÄ£Ê½
    FRAME_AFFIRM_SHOW 			= 8,	--½øÈë·ÅÆúÈÎÎñÈ·ÈÏÄ£Ê½
    GUILD_CREATE_CONFIRM		= 9, 	--°ï»á´´½¨È·ÈÏÄ£Ê½
    SYSTEM_TIP_INFO 			= 10,	--ÏµÍ³ÌáÊ¾¶Ô»°¿òÄ£Ê½
    GUILD_QUIT_CONFIRM 			= 11,	--°ï»áÍË³öÈ·ÈÏÄ£Ê½
    GUILD_DESTORY_CONFIRM		= 12,	--°ï»áÉ¾³ýÈ·ÈÏÄ£Ê½
    CALL_OF						= 13,	--À­ÈË
    NET_CLOSE_MESSAGE			= 14,	--¶Ï¿ªÍøÂç
    PET_FREE_CONFIRM			= 15,	--ÕäÊÞ·ÅÉúÈ·ÈÏ
    CITY_CONFIRM				= 16,	--³ÇÊÐÏà¹ØÈ·ÈÏ
    SAVE_STALL_INFO				= 17,	--±£´æ°ÚÌ¯ÐÅÏ¢
    PET_SYNC_CONFIRM			= 18,	--ÕäÊÞ·±Ö³È·ÈÏ
    QUIT_GAME					= 19,	--ÍË³öÓÎÏ·µÄÈ·ÈÏ
    EQUIP_ITEM					= 20,	--×°±¸ÎïÆ·
    YUANBAO_BUY_ITEM		= 21, --Ôª±¦ÉÌµê¹ºÂòÎïÆ·È·ÈÏ
    CONFIRM_REMOVE_STALL	= 22,--È·ÈÏ³·Ì² add by zchw
    PET_PROCREATE_PROMPT			= 23, -- ÕäÊÞ·±Ö³ÌáÊ¾ zchw

	--Õâ¸ö24Ò»¶¨²»ÄÜ¸Ä£¬¸ÄÁË³ö´íµÄ£¡£¡£¡£¡£¡Chris
	SERVER_CONTROL				= 24,	--Server¿ØÖÆµ¯³öµÄÌáÊ¾¿ò
	DELETE_FRIEND_MESSAGE		= 25,	--È·¶¨É¾³ýºÃÓÑµÄÌáÊ¾¿ò

    GEM_COMBINED_CONFIRM		= 88,	-- È·ÈÏ±¦Ê¯ºÏ³É
   	ENCHASE_CONFIRM					= 99,	-- È·ÈÏÏâÇ¶
   	ENCHASE_FOUR_CONFIRM		= 100,	-- add:lby20080527È·ÈÏ4ÏâÇ¶  
   	 	
   	--CARVE_CONFIRM				= 102,	-- È·ÈÏµñ×Á



    PS_RENAME_MESSAGE			= 116,	--¸ü¸ÄÍæ¼ÒÉÌµêµêÃû
    PS_READ_MESSAGE				= 117,	--¸ü¸ÄÍæ¼ÒÉÌµê½éÉÜ£¨¹ã¸æ£©
    PS_ADD_BASE_MONEY			= 118,	--³äÈë±¾½ð
    PS_ADD_GAIN_MONEY			= 119,	--³äÈëÓ¯Àû½ð
    PS_DEC_GAIN_MONEY			= 120,	--È¡³öÓ¯Àû½ð
    PS_ADD_STALL				= 121,	--Ôö¼Ó¹ñÌ¨
    PS_DEL_STALL				= 122,	--¼õÉÙ¹ñÌ¨
    PS_INFO_PANCHU				= 123,	--ÉÌµêÅÌ³ö
    PS_INFO_PANRU				= 124,	--ÉÌµêÅÌÈë
    PS_INFO_MODIFY_TYPE			= 125,	--¸ü¸ÄÉÌµêÀàÐÍ
    FREEFORALL					= 201,	--FREEFORALL: ¸öÈË»ìÕ½
    FREEFORTEAM					= 202,	--FREEFORTEAM£º ×é¶Ó»ìÕ½
    FREEFORGUILD				= 203,	-- FREEFORGUILD£º°ïÅÉ»ìÕ½
    MAKESUREPVPCHALLENGE		= 204,
    EXCHANGE_MONEY_OVERFLOW			= 205, --½»Ò×ºóÔö¼ÓÍæ¼ÒÊÇ·ñµ½´ïÇ®ÉÏÏÞµÄÅÐ¶¨

    GUILD_DEMIS_CONFIRM		= 206, 			--ìøÈÃÈ·ÈÏ

    CHANGEPROTECTTIME		= 207, 				--°²È«Ê±¼ä
    COMMISION_BUY = 208, 							--¼ÄÊÛÉÌµê¹ºÂòÈ·ÈÏ

    Player_Give_Rose		= 209,
    RECYCLE_DEL_ITEM		=210, 				--È¡ÏûÊÕ¹ºÈ·ÈÏ

    OPEN_IS_SELL_TO_RECSHOP	= 211, 		--³öÊÛÎïÆ·È·ÈÏ

    CONFIRM_STENGTH = 212,

    CHAR_RANAME_CONFIRM = 213,

    CITY_RANAME_CONFIRM = 214,

    CONFIRM_RE_IDENTIFY = 215,

    KICK_MEMBER_MSGBOX = 216,
    
		SAFEBOX_LOCK_CONFIRM = 217,						--±£ÏÕÏäËø¶¨È·ÈÏ¿ò
		SAFEBOX_UNLOCK_CONFIRM = 218,					--±£ÏÕÏä½âËøÈ·ÈÏ¿ò
		
		LOCK_ITEM_CONFIRM_FRAME = 219,        --	¼ÓËøÈ·ÈÏ
    GUILD_LEAGUE_QUIT_CONFIRM = 220,			--	ÍË³ö°ï»áÍ¬ÃËÈ·ÈÏ
    GUILD_LEAGUE_CREATE_CONFIRM = 221,		--	´´½¨°ï»áÍ¬ÃËÈ·ÈÏ
		PET_SKILL_STUDY_CONFIRM = 222,				--	³èÎïÑ§Ï°¼¼ÄÜÈ·ÈÏ
		EXCHANGE_BANGGONG = 223,							--	¶Ò»»°ï¹±ÅÆÈ·ÈÏ
		PUT_GUILDMONEY = 224,									--	°ï»á×Ê½ð¾èÖú
		TLZ_CONFIRM_SETPOS = 225,							--	È·ÈÏÍÁÁéÖéÖØÐÂ¶¨Î»

		DISMISS_TEAM = 226,										--	½âÉ¢¶ÓÎé						WTT		20090212
};

local PVPFLAG = { FREEFORALL = 201, FREEFORTEAM = 202, FREEFORGUILD = 203, MAKESUREPVPCHALLENGE = 204, ACCEPTDUEL = 205, DuelGUID = 0, DuelName = "" }
--FREEFORALL: ¸öÈË»ìÕ½ FREEFORTEAM£º ×é¶Ó»ìÕ½ FREEFORGUILD£º°ïÅÉ»ìÕ½

--
local g_szData;
local g_nData;
local g_nData1
--

local Quest_Number;
local Pet_Number;
local Server_Script_Function = "";
local Server_Script_ID = "";
local Server_Return_1 = 0;
local Server_Return_2 = 0;
local Server_Return_3 = 0;

local g_CityData = {};						--ÓÉÓÚupvalueµÄÏÞÖÆ£¬³ÇÊÐºÍÕäÊÞºÏ³É¹²ÓÃÕâ¸öÊý¾ÝÇø

local strMessageString = "";		--¶Ô»°¿ò×Ö·û
local strMessageData   = 0;			--¶Ô»°¿òÀàÐÍ£¬ÓÃÓÚÌáÊ¾Ê²Ã´µÃ¶Ô»°¿ò
local strMessageArgs = 0;				--°´Å¥²ÎÊý
local strMessageType = "Normal";--°´Å¥·ç¸ñ
local strMessageArgs_2 = 0			--°´Å¥²ÎÊý2

local GemCombinedData = {}

local EnchaseData = {}

local SplitData = {}

local CarveData = {}

local CommisionBuyData = {}  --¼ÄÊÛÉÌµê¹ºÂòÈ·ÈÏ¿òµÄÊý¾Ý

local MAX_OBJ_DISTANCE = 3.0;

local Client_ItemIndex = -1

function CancelLastOp(str)
	if(this:IsVisible() and str ~= g_FrameInfo) then
		MessageBox_Self_Cancel_Clicked(0);
	end
end
--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_PreLoad()
	--this:RegisterEvent("MSGBOX_ACCEPTDUEL");
	this:RegisterEvent("MSGBOX_MAKESUREPVPCHALLENGE");
    this:RegisterEvent("MENU_SHOWACCEPTCHANGEPVP");
	this:RegisterEvent("OPEN_STALL_RENT_FRAME");
	this:RegisterEvent("OPEN_DISCARD_ITEM_FRAME");
	this:RegisterEvent("OPEN_CANNT_DISCARD_ITEM");
	this:RegisterEvent("AFFIRM_SHOW");
	this:RegisterEvent("NET_CLOSE");
	this:RegisterEvent("DELETE_FRIEND");
	this:RegisterEvent("TIME_UPDATE");
	this:RegisterEvent("PET_PROCREATE_PROMPT"); -- zchw pet procreate

	-- zchw fix Transfer bug
	this:RegisterEvent("OBJECT_CARED_EVENT");
	---- ÓÐÈËÑûÇëÄã¼ÓÈë¶ÓÎé
	--this:RegisterEvent("SHOW_TEAM_YES_NO");
	---- ¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄãÍ¬Òâ.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	---- Ä³ÈËÉêÇë¼ÓÈë¶ÓÎé.
	--this:RegisterEvent("TEAM_APPLY");
	---- ¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½
	--this:RegisterEvent("TEAM_FOLLOW_INVITE");

	-- ´´½¨°ï»áÈ·ÈÏ
	this:RegisterEvent("GUILD_CREATE_CONFIRM");
	-- É¾³ý°ï»áÈ·ÈÏ
	this:RegisterEvent("GUILD_DESTORY_CONFIRM");
	-- ÍË³ö°ï»áÈ·ÈÏ
	this:RegisterEvent("GUILD_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_CREATE_CONFIRM");

	this:RegisterEvent("PET_FREE_CONFIRM");

	this:RegisterEvent("OPEN_PS_MESSAGE_FRAME");

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("CITY_CONFIRM");
	--add by zchw
	this:RegisterEvent("OPEN_REMOVE_STALL");
	this:RegisterEvent("OPEN_SAVE_STALL_INFO");

	this:RegisterEvent("PET_SYNC_CONFIRM");
	this:RegisterEvent("QUEST_QUIT_GAME");

	this:RegisterEvent( "MESSAGE_BOX" );

	this:RegisterEvent( "GEM_COMBINED_CONFIRM" );
	this:RegisterEvent( "ENCHASE_CONFIRM" );  
	this:RegisterEvent( "ENCHASE_FOUR_CONFIRM" );-- add:lby20080527È·ÈÏ4ÏâÇ¶
	
	--this:RegisterEvent( "CARVE_CONFIRM" );
	this:RegisterEvent( "EXCHANGE_MONEY_OVERFLOW" );
	this:RegisterEvent( "GUILD_DEMIS_CONFIRM" );
	this:RegisterEvent("YUANBAO_BUY_ITEM_CONFIRM");

	this:RegisterEvent("CHANGEPROTECTTIME");
	
	this:RegisterEvent("CONFIRM_COMMISION_BUY"); --¼ÄÊÛÉÌµê¹ºÂòÈ·ÈÏ

	this:RegisterEvent("PLAYER_GIVE_ROSE");

	this:RegisterEvent( "RECYCLE_DEL_ITEM" );

	this:RegisterEvent( "OPEN_IS_SELL_TO_RECSHOP" );

	this:RegisterEvent( "CLOSE_PS_CHANGETYPE_MSG" );

	this:RegisterEvent( "CONFIRM_STENGTH" );

	this:RegisterEvent( "EXCHANGE_BANGGONG" );
		
	this:RegisterEvent( "PUT_GUILDMONEY" );

	this:RegisterEvent( "CLOSE_STRENGTH_MSGBOX" );

	this:RegisterEvent( "CLOSE_RECYCLESHOP_MSG" );

	this:RegisterEvent( "ENCHASE_CLOSE_MSGBOX" );
	
	this:RegisterEvent( "CITY_RANAME_CONFIRM" );

	this:RegisterEvent( "CHAR_RANAME_CONFIRM" );	

	--µ±logon´ò¿ªµÄÊ±ºò£¬¹Ø±ÕËùÓÐMessageBox
	this:RegisterEvent( "GAMELOGIN_OPEN_COUNT_INPUT" );

	this:RegisterEvent( "CONFIRM_RE_IDENTIFY" );

	this:RegisterEvent( "CLOSE_RE_IDENTIFY_MSGBOX" );
	
	this:RegisterEvent( "KICK_MEMBER_MSGBOX" );
	
	this:RegisterEvent( "CLOSE_KICK_MEMBER_MSGBOX" );
	
	--±£ÏÕÏäËø¶¨È·ÈÏ¿ò
	this:RegisterEvent( "SAFEBOX_LOCK_CONFIRM" );

	--±£ÏÕÏä½âËøÈ·ÈÏ¿ò
	this:RegisterEvent( "SAFEBOX_UNLOCK_CONFIRM" );
	
	this:RegisterEvent( "CLOSE_SAFEBOX_CONFIRM" );
	
	--¼ÓËøÈ·ÈÏ
	this:RegisterEvent( "LOCK_ITEM_CONFIRM" );
	this:RegisterEvent( "OPEN_PETSKILLSTUDY_MSGBOX" );
	this:RegisterEvent( "CLOSE_PETSKILLSTUDY_MSGBOX" );
	--ÍÁÁéÖé¶¨Î»È·ÈÏ
	this:RegisterEvent( "CONFIRM_SETPOS_TLZ" );
	
	-- µ¯³ö½âÉ¢¶ÓÎéµÄ¶þ´ÎÈ·ÈÏ´°¿Ú			add by WTT	20090212
	this:RegisterEvent( "OPNE_DISMISS_TEAM_MSGBOX" );

end

--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_OnLoad()

end

function  MessageBox_Self_UpdateRect()

	local nWidth, nHeight = MessageBox_Self_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBox_Self_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end
--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEventEx(event)

	local objCaredID = -1; -- zchw fix Transfer bug
	if(event == "QUEST_QUIT_GAME") then
		this:Show();
		g_FrameInfo = FrameInfoList.QUIT_GAME;
	-- add by zchw
	elseif event == "OPEN_REMOVE_STALL" then
		CancelLastOp(FrameInfoList.CONFIRM_REMOVE_STALL);
		g_FrameInfo = FrameInfoList.CONFIRM_REMOVE_STALL;
	-- zchw for pet procreate
	elseif event == "PET_PROCREATE_PROMPT" then
		CancelLastOp(FrameInfoList.PET_PROCREATE_PROMPT);
		g_FrameInfo = FrameInfoList.PET_PROCREATE_PROMPT;
	elseif event == "OPEN_SAVE_STALL_INFO"    then
		CancelLastOp(FrameInfoList.SAVE_STALL_INFO);
		g_FrameInfo = FrameInfoList.SAVE_STALL_INFO;
	elseif event == "YUANBAO_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM and this:IsVisible())then
			--Èç¹ûÊÇ¹ØÓÚ¹ºÎïµ¯³öµÄ´°¿Ú£¬²Å¹Ø±Õ
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg2);	--ÔÚ»õ¼ÜµÄÎ»ÖÃ
			g_CityData[2] = tonumber(arg3);	--ÔÚÉÌµêµÄÊÛ¼Û
			g_CityData[3] = arg1;	--»õÎïÃû³Æ
			CancelLastOp(FrameInfoList.YUANBAO_BUY_ITEM);
			g_FrameInfo = FrameInfoList.YUANBAO_BUY_ITEM;
		end
	elseif( event == "PET_SYNC_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		CancelLastOp(FrameInfoList.PET_SYNC_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SYNC_CONFIRM;
	--¼ÄÊÛÉÌµê¹ºÂòÈ·ÈÏÏûÏ¢
	elseif event == "CONFIRM_COMMISION_BUY" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.COMMISION_BUY and this:IsVisible())then
			--Èç¹ûÊÇ¼ÄÊÛÉÌµêÈ·ÈÏ¿ò£¬²Å¹Ø±Õ
				CommisionBuyData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			CommisionBuyData = {};
			CommisionBuyData[1] = arg1;	--ÎïÆ·Ãû³Æ
			CommisionBuyData[2] = arg2;	--¼Û¸ñ
			CancelLastOp(FrameInfoList.COMMISION_BUY);
			g_FrameInfo = FrameInfoList.COMMISION_BUY;
		end
	elseif event == "TIME_UPDATE" then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.STALL_RENT_FRAME ) then
			local xNow, yNow;
			xNow, yNow = Player:GetPos();
			
			local askPosX = Variable:GetVariable("AskBaiTanPosX");
			local askPosY = Variable:GetVariable("AskBaiTanPosY");
			
			if(tostring(xNow) ~= askPosX or tostring(yNow) ~= askPosY) then
				MessageBox_Self_Cancel_Clicked(1);
			end
		end

		return -1;
	end
	if g_FrameInfo == FrameInfoList.QUIT_GAME   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Các hÕ quyªt r¶i bö thª gi¾i Thiên Long Bát Bµ?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "RECYCLE_DEL_ITEM" ) then
		Recycle_Type = tonumber(arg0);
		Recycle_CurSelectItem = tonumber(arg1);
		CancelLastOp(FrameInfoList.RECYCLE_DEL_ITEM);
		g_FrameInfo = FrameInfoList.RECYCLE_DEL_ITEM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Các hÕ có mu¯n xác nh§n hüy bö l¥n thu mua này không?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "OPEN_IS_SELL_TO_RECSHOP" ) then
		Recycle_Bag_idx = tonumber(arg0);
		Recycle_Shop_idx = tonumber(arg1);
		Recycle_Shop_Num =  tonumber(arg2);
		Recycle_Shop_AllPrice =  tonumber(arg3);
		CancelLastOp(FrameInfoList.OPEN_IS_SELL_TO_RECSHOP);
		g_FrameInfo = FrameInfoList.OPEN_IS_SELL_TO_RECSHOP;
		local name = PlayerShop:GetRecycleItem(Recycle_Shop_idx,3,"name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#W Nguyên li®u mà các hÕ c¥n bán là #G"..name.."#W, S¯ lßþng là"..Recycle_Shop_Num.."#W, S¯ ti«n vàng nh§n ðßþc là #Y#{_MONEY"..Recycle_Shop_AllPrice.."}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	if ( event == "CONFIRM_STENGTH" ) then
		Stength_Equip_Idx = tonumber(arg0);
		Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_STENGTH);
		g_FrameInfo = FrameInfoList.CONFIRM_STENGTH;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Sau khi cß¶ng hóa s¨ l§p tÑc kh¤u tr× ði v§t ph¦m trong täy näi Cß¶ng hóa tinh hoa khóa ð¸nh, Trang b¸ sau khi Cß¶ng hóa cûng s¨ khóa ð¸nh cùng v¾i nhân v§t, có mu¯n xác nh§n cß¶ng hóa không? #r gþi ý: Nªu nhß không mu¯n sau khi cß¶ng hóa trang b¸ b¸ khóa ð¸nh, xin hãy c¤t Cß¶ng hóa tinh hoa khóa ð¸nh ðó vào Thß½ng ph¯ r°i hãy ðªn ðây cß¶ng hóa.";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	
	if ( event == "EXCHANGE_BANGGONG" ) then
		BangGong_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --ÕâÀï²»ÐèÒªÔÚÊ¹ÓÃGetNPCIDByServerIDÁË
		if ObjCaredID ~= -1 then
			--¿ªÊ¼¹ØÐÄNPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local extravalue = math.floor(BangGong_Value*0.1)
		CancelLastOp(FrameInfoList.EXCHANGE_BANGGONG);
		g_FrameInfo = FrameInfoList.EXCHANGE_BANGGONG;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BGCH_8922_28}"..BangGong_Value.."#{BGCH_8922_29}"..extravalue.."#{BGCH_8922_30}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	
	if ( event == "PUT_GUILDMONEY" ) then
		GuildMoney_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --ÕâÀï²»ÐèÒªÔÚÊ¹ÓÃGetNPCIDByServerIDÁË
		if ObjCaredID ~= -1 then
		--¿ªÊ¼¹ØÐÄNPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local value = math.floor(GuildMoney_Value*0.9)
		CancelLastOp(FrameInfoList.PUT_GUILDMONEY);
		g_FrameInfo = FrameInfoList.PUT_GUILDMONEY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BPZJ_0801014_008}#{_EXCHG"..GuildMoney_Value.."}#{BPZJ_0801014_009}#{_EXCHG"..value.."}#{BPZJ_0801014_013}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "CONFIRM_RE_IDENTIFY" ) then
		RID_Equip_Idx = tonumber(arg0);
		--Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_RE_IDENTIFY);
		g_FrameInfo = FrameInfoList.CONFIRM_RE_IDENTIFY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Khi giám ð¸nh lÕi tß ch¤t cüa trang b¸ thì s¨ ßu tiên kh¤u tr× ra Kim Cang Sa ho£c Kim Cang Toä ðã c¯ ð¸nh, giám ð¸nh lÕi xong tß ch¤t trang b¸ thì trang b¸ s¨ c¯ ð¸nh, xác nh§n tiªp tøc khäm ð¸nh không ?  #r#GNh¡c nh·: Nªu nhß không mu¯n c¯ ð¸nh trang b¸ sau khi khäm ð¸nh, mong b¢ng hæu hãy bö Kim Cang Sa ho£c Kim Cang Töa  ðã c¯ ð¸nh vào Thß½ng Kh¯ r°i hãy quay lÕi khäm ð¸nh.#W";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "KICK_MEMBER_MSGBOX" ) then
		Member_Idx = tonumber(arg0);
		Member_Name = arg1;
		CancelLastOp(FrameInfoList.KICK_MEMBER_MSGBOX);
		g_FrameInfo = FrameInfoList.KICK_MEMBER_MSGBOX;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Các hÕ có ð°ng ý làm cho ngß¶i ch½i #G"..Member_Name.."#W Bäi tr× xu¤t bang hµi không?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	
	return 1;
end

--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEvent(event)
	if event == "GEM_COMBINED_CONFIRM" then
		
		GemCombinedData[1] = tonumber( arg0 )
		GemCombinedData[2] = tonumber( arg1 )
		GemCombinedData[3] = tonumber( arg2 )
		GemCombinedData[4] = tonumber( arg3 )
		GemCombinedData[5] = tonumber( arg4 )
		GemCombinedData[6] = tonumber( arg5 )
		GemCombinedData[7] = arg6
		CancelLastOp(FrameInfoList.GEM_COMBINED_CONFIRM);
		g_FrameInfo = FrameInfoList.GEM_COMBINED_CONFIRM
		MessageBox_Self_UpdateFrame()
		return
	end

	if event == "EXCHANGE_MONEY_OVERFLOW" then
		MessageBox_Self_Text:SetText( "#YNgân lßþng cüa các hÕ ðã quá mÑc gi¾i hÕn, hãy tiêu b¾t ði. Lßu ý: không ðßþc #Rthoát khöi trò ch½i ho£c d¸ch ð±i ð¸a danh#Y, nªu không các hÕ s¨ b¸ m¤t ði s¯ ti«n vßþt gi¾i hÕn ðó" );
		
		MessageBox_Self_UpdateRect();
		CancelLastOp(FrameInfoList.EXCHANGE_MONEY_OVERFLOW);
		g_FrameInfo = FrameInfoList.EXCHANGE_MONEY_OVERFLOW
		
		this:Show();
	end
	if event == "GUILD_DEMIS_CONFIRM" then
		local TargetName = tostring( arg0 );
		MessageBox_Self_Text:SetText( "Các hÕ có quyªt ð¸nh nhß¶ng ngôi Bang chü cho "..TargetName.." không? Sau khi nhß¶ng ngôi thì chÑc vø cüa các hÕ là phó bang chü!" );		
		MessageBox_Self_UpdateRect();	
		CancelLastOp(FrameInfoList.GUILD_DEMIS_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DEMIS_CONFIRM
		this:Show();
	end

	if event == "ENCHASE_CONFIRM" then
		MessageBox_Self_Text:SetText( "Không có nguyên li®u ð£c thù s¨ khiªn vi®c khäm nÕm có th¬ th¤t bÕi và bäo thÕch s¨ m¤t. Các hÕ xác ð¸nh mu¯n tiªp tøc khäm nÕm ?" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_CONFIRM
		this:Show();
	end
	
	if event == "ENCHASE_FOUR_CONFIRM" then  -- add:lby20080527È·ÈÏ4ÏâÇ¶
		MessageBox_Self_Text:SetText( "Không có nguyên li®u ð£c thù s¨ khiªn vi®c khäm nÕm có th¬ th¤t bÕi và bäo thÕch s¨ m¤t. Các hÕ xác ð¸nh mu¯n tiªp tøc khäm nÕm ?" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_FOUR_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_FOUR_CONFIRM
		this:Show();
	end

	-- ´ò¿ªÕäÊÞ¼¼ÄÜÑ§Ï°µÄ¶þ´ÎÈ·ÈÏ½çÃæ
	if event == "OPEN_PETSKILLSTUDY_MSGBOX" then
		MessageBox_Self_Text:SetText( "Trân thú cüa các hÕ s¡p ðßþc 2 kÛ nång Thü Ðµng, tiêu hao #{_EXCHG990000}, các hÕ ð°ng ý không?" );
		CancelLastOp(FrameInfoList.PET_SKILL_STUDY_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SKILL_STUDY_CONFIRM
		this:Show();
	end
	
	-- ¹Ø±ÕÕäÊÞ¼¼ÄÜÑ§Ï°µÄ¶þ´ÎÈ·ÈÏ½çÃæ
	if(event == "CLOSE_PETSKILLSTUDY_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
	
--	if event == "CARVE_CONFIRM" then
--		MessageBox_Self_Text:SetText( "×¢Òâ£¡#ÄúÒªµñ×ÁµÄ±¦Ê¯»òµñ×Á·ûÎªÒÑ°ó¶¨ÎïÆ·£¬µñ×ÁºóµÄ±¦Ê¯Ò²½«ÓëÄú°ó¶¨£¬È·ÈÏÒª¼ÌÐøµñ×ÁµÄ»°ÇëÔÙ´Îµã»÷µñ×Á°´Å¥¡£" );
--		CarveData[1] = tostring( arg0 )
--		CarveData[2] = tonumber( arg1 )
--		CarveData[3] = tonumber( arg2 )
--		CarveData[4] = tonumber( arg3 )
--		CarveData[5] = tonumber( arg4 )
--		CancelLastOp(FrameInfoList.CARVE_CONFIRM);
--		g_FrameInfo = FrameInfoList.CARVE_CONFIRM
--		this:Show();
--	end
	
	if(event == "OPEN_STALL_RENT_FRAME") then
		CancelLastOp(FrameInfoList.STALL_RENT_FRAME);
		--¼ÇÂ¼µ±Ç°Î»ÖÃ
		local xPos, yPos;
		xPos, yPos = Player:GetPos();
		Variable:SetVariable("AskBaiTanPosX", tostring(xPos), 1);
		Variable:SetVariable("AskBaiTanPosY", tostring(yPos), 1);
		
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.STALL_RENT_FRAME;
		

	elseif ( event == "MSGBOX_MAKESUREPVPCHALLENGE" ) then
	    local TargetName = tostring( arg0 )
	    --AxTrace(0,0,"MSGBOX_MAKESUREPVPCHALLENGE");
		CancelLastOp(FrameInfoList.MAKESUREPVPCHALLENGE);
		g_FrameInfo = FrameInfoList.MAKESUREPVPCHALLENGE;
	    MessageBox_Self_Text:SetText( "Các hÕ xác ð¸nh cùng"..TargetName.."tuyên chiªn không? Sau khi giªt chªt ð¯i phß½ng s¨ tång ði¬m sát khí? Sát khí cao thì lúc nhân v§t chªt s¨ t±n th¤t r¤t l¾n." );
		MessageBox_Self_UpdateRect();
		this:Show();

	elseif ( event == "MENU_SHOWACCEPTCHANGEPVP" ) then
		local Mode = tonumber( arg0 )
		local ModeText = ""
		if( 1 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORALL);
		    --AxTrace(0,0,FrameInfoList.FREEFORALL);
		    g_FrameInfo = FrameInfoList.FREEFORALL;
		    ModeText = "Hình thÑc này có th¬ công kích t¤t cä ngß¶i ch½i tr× bän thân, m¶i xác nh§n"
		end
		if( 2 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORTEAM);
		    --AxTrace(0,0,FrameInfoList.FREEFORTEAM);
		    g_FrameInfo = FrameInfoList.FREEFORTEAM;
		    ModeText = "Hình thÑc này có th¬ công kích t¤t cä ngß¶i ch½i tr× ngß¶i trong t± ðµi, m¶i xác nh§n"
		end
		if( 3 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORGUILD)
		    --AxTrace(0,0,FrameInfoList.FREEFORGUILD);
		    g_FrameInfo = FrameInfoList.FREEFORGUILD;
		    ModeText = "#{TM_20080311_18}"
		end
		if( Mode >= 1 and Mode <= 3 ) then
		    MessageBox_Self_Text:SetText( ModeText );
			MessageBox_Self_UpdateRect();
		    this:Show();
		end

	elseif ( event == "MSGBOX_ACCEPTDUEL" ) then
	    local Name = tostring( arg0 )
	    local GUID = tostring( arg1 )
	    PVPFLAG.DuelName = Name
	    PVPFLAG.DuelGUID = GUID
	    g_FrameInfo = PVPFLAG.ACCEPTDUEL;
	    local MsgText = Name.."thách ð¤u v¾i bÕn, các hÕ có ð°ng ý không? Chú ý: trong tr§n ð¤u nªu tØ vong s¨ b¸ tr×ng phÕt."
	    MessageBox_Self_Text:SetText( MsgText )
		MessageBox_Self_UpdateRect();
	    this:Show();

	elseif(event == "OPEN_DISCARD_ITEM_FRAME") then
		argDISCARD_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.DISCARD_ITEM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.DISCARD_ITEM_FRAME;

	elseif(event == "OPEN_CANNT_DISCARD_ITEM") then
		argCANNT_DISCARD_ITEM0 = arg0
		CancelLastOp(FrameInfoList.CANNT_DISCARD_ITEM);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.CANNT_DISCARD_ITEM;
		
	elseif(event == "LOCK_ITEM_CONFIRM") then
		argLOCK_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.LOCK_ITEM_CONFIRM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.LOCK_ITEM_CONFIRM_FRAME;

	elseif(event == "AFFIRM_SHOW") then
		this:Show();
		g_InitiativeClose = 0;
		Quest_Number = tonumber(arg2);
		argFRAME_AFFIRM_SHOW0 = arg0;
		CancelLastOp(FrameInfoList.FRAME_AFFIRM_SHOW);
		g_FrameInfo = FrameInfoList.FRAME_AFFIRM_SHOW;


	-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
	elseif ( event == "GUILD_CREATE_CONFIRM" ) then
		argCREATE_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_CREATE_CONFIRM;
		MessageBox_Self_Text:SetText("Mu¯n kh·i tÕo" .. argCREATE_CONFIRM0 .. "không?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- °ï»áÉ¾³ýÐèÍæ¼ÒÈ·ÈÏ
	elseif ( event == "GUILD_DESTORY_CONFIRM" ) then
		argDESTORY_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_DESTORY_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DESTORY_CONFIRM;
		MessageBox_Self_Text:SetText("Mu¯n hüy bö" .. argDESTORY_CONFIRM0 .. "không?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- °ï»áÍË³öÐèÍæ¼ÒÈ·ÈÏ
	elseif ( event == "GUILD_QUIT_CONFIRM" ) then
		argQUIT_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_QUIT_CONFIRM;
		MessageBox_Self_Text:SetText("Mu¯n thoát ra" .. argQUIT_CONFIRM0 .. "không?");
		MessageBox_Self_UpdateRect();
		this:Show();
	
	--°ï»áÍ¬ÃËÍË³öÈ·ÈÏ
	elseif event == "GUILD_LEAGUE_QUIT_CONFIRM" then
		argQUIT_LEAGUE_CONFIRM0 = arg0;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM
		MessageBox_Self_Text:SetText( "B¢ng hæu xác nh§n r¶i bö"..argQUIT_LEAGUE_CONFIRM0.."Ð°ng Minh không ?" );		
		MessageBox_Self_UpdateRect();	
		this:Show();
		
	--°ï»áÍ¬ÃË´´½¨È·ÈÏ
	elseif event == "GUILD_LEAGUE_CREATE_CONFIRM" then
		argCREATE_LEAGUE_CONFIRM0 = arg0;
		argCREATE_LEAGUE_CONFIRM1 = arg1;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM
		MessageBox_Self_Text:SetText( "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}" );		
		MessageBox_Self_UpdateRect();	
		this:Show();
		

	-- ·þÎñÆ÷¶ÏÁË
	elseif ( event == "NET_CLOSE" ) then
		argNET_CLOSE0 = arg0 
		CancelLastOp(FrameInfoList.NET_CLOSE_MESSAGE);
		g_FrameInfo = FrameInfoList.NET_CLOSE_MESSAGE;
		this:Show();

	elseif ( event == "PET_FREE_CONFIRM") then
		Pet_Number = tonumber(arg0);
		CancelLastOp(FrameInfoList.PET_FREE_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_FREE_CONFIRM;
		this:Show();

	elseif ( event == "OPEN_PS_MESSAGE_FRAME" )  then


		AxTrace(0,0,"arg0 = " .. arg0);


		if( arg0 == "name" )    then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_RENAME_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_RENAME_MESSAGE;

		elseif( arg0 == "ad" )  then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_READ_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_READ_MESSAGE;

		elseif( arg0 == "immitbase" )		then -- ±¾½ð
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_BASE_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_BASE_MONEY;

		elseif( arg0 == "immit" )				then -- Ó¯Àû½ð´æÈë
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_GAIN_MONEY;

		elseif( arg0 == "draw" )				then -- Ó¯Àû½ðÈ¡³ö
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_DEC_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_DEC_GAIN_MONEY;

		elseif( arg0 == "add_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_ADD_STALL);
			g_FrameInfo = FrameInfoList.PS_ADD_STALL;


		elseif( arg0 == "del_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_DEL_STALL);
			g_FrameInfo = FrameInfoList.PS_DEL_STALL;
			

		elseif( arg0 == "sale" )     	then 	-- ÅÌ³ö
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU;
			

		elseif( arg0 == "back" )     	then	-- È¡ÏûÅÌ³ö
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANRU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANRU;

		elseif( arg0 == "ps_type" )		then	-- ¸ü¸ÄÍæ¼ÒÉÌµêµÄ×ÓÀàÌáÊ¾ÐÅÏ¢
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_MODIFY_TYPE);
			g_FrameInfo = FrameInfoList.PS_INFO_MODIFY_TYPE;


		end
	elseif ( event == "UI_COMMAND" ) then
		--AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == FrameInfoList.SERVER_CONTROL then
				CancelLastOp(FrameInfoList.SERVER_CONTROL);
				g_FrameInfo = FrameInfoList.SERVER_CONTROL;
				-- zchw fix Transfer bug
				local xx = Get_XParam_INT(1);
				ObjCaredID = DataPool : GetNPCIDByServerID(xx);
				if ObjCaredID ~= -1 then	
					--¿ªÊ¼¹ØÐÄNPC
					this:CareObject(ObjCaredID, 1, "MsgBox");
				end
		else
				return;
		end
	-- zchw fix Transfer bug
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if ObjCaredID ~= -1 then	
				this:CareObject(ObjCaredID, 0, "MsgBox");
			end
			this:Hide();
		end
	elseif( event == "DELETE_FRIEND" ) then
		g_currentList = tonumber(arg0);
		g_currentIndex = tonumber(arg1);
		CancelLastOp(FrameInfoList.DELETE_FRIEND_MESSAGE);
		g_FrameInfo = FrameInfoList.DELETE_FRIEND_MESSAGE;
	elseif( event == "CITY_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		g_CityData[3] = arg2;
		g_CityData[4] = arg3;
		g_CityData[5] = arg4;
		g_CityData[6] = arg5;
		g_CityData[7] = arg6;
		g_CityData[8] = arg7;
		CancelLastOp(FrameInfoList.CITY_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_CONFIRM;
	elseif( event == "MESSAGE_BOX" ) then
		MeesageBox_Init();
		return;
	elseif( event == "CHANGEPROTECTTIME" ) then
		g_ChangeTiemArg0 = tonumber(arg0);
		g_ChangeTiemArg1 = tonumber(arg1);
		CancelLastOp(FrameInfoList.CHANGEPROTECTTIME);
		g_FrameInfo = FrameInfoList.CHANGEPROTECTTIME;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0th¶i gian an toàn");
		if(g_ChangeTiemArg0 == 0)then
			MessageBox_Self_Text:SetText("Mµt khi thiªt l§p th¶i gian an toàn, l¥n lên mÕng sau trong th¶i gian an toàn s¨ không th¬ tiªn hành r¤t nhi«u vi®c, cho nên các hÕ vui lòng thiªt l§p th¶i gian an toàn cüa mình 1 cách hþp lý. Xác nh§n mu¯n thiªt l§p không ?");
		else
			MessageBox_Self_Text:SetText("Tài khoän s¨ an toàn h½n khi th¶i gian an toàn tång nhßng trong th¶i gian này không th¬ thñc hi®n nhi«u thao tác. Hãy cài ð£t hþp lí chúng. Các hÕ có mu¯n tång th¶i gian an toàn?");
			--ÕÊºÅ  to  ÕËºÅ
		end
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	elseif(event == "PLAYER_GIVE_ROSE")then
		g_RoseArg0 = arg0;
		g_RoseArg1 = arg1;
		g_RoseArg2 = arg2;
		g_RoseArg3 = arg3;
		g_RoseArg4 = arg4;
		if(g_RoseArg0==nil or g_RoseArg1 == nil )then
			return;
		end
		CancelLastOp(FrameInfoList.Player_Give_Rose);
		g_FrameInfo = FrameInfoList.Player_Give_Rose;
		MessageBox_Self_Text:SetText("#cFFF263 phäi chång t£ng #c00ff00999 ðóa hoa h°ng#cFFF263 cho #c00ff00"..g_RoseArg0.."#cFFF263?");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "CLOSE_PS_CHANGETYPE_MSG" ) then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE)then
			this:Hide();
		end
		return;
	end
	if(event == "CLOSE_STRENGTH_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_STENGTH  then 
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.SERVER_CONTROL then
				this:Hide();
			end
		end
		return;
	end
	
	if(event == "CLOSE_RE_IDENTIFY_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY  then 
				this:Hide();
			end
		end
		return;
	end
	
	if(event == "CLOSE_KICK_MEMBER_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX  then 
				this:Hide();
			end
		end
		return;
	end

	if(event == "CLOSE_SAFEBOX_CONFIRM" ) then
		if(this:IsVisible()) then
			if (g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM or g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM) then 
				this:Hide();
			end
		end
		return;
	end	
	

	if(event == "CLOSE_RECYCLESHOP_MSG" ) then
		if(this:IsVisible()) then
			
			if g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM  then 
				CancelLastOp(-1);
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP then
				CancelLastOp(-1);
				this:Hide();
			end
		end
		return;
	end

	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
	
	
	
	-- add:lby20080527È·ÈÏ4ÏâÇ¶ENCHASE_FOUR_CONFIRM
	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "CHAR_RANAME_CONFIRM" ) then
		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0SØa tên nhân v§t");
		MessageBox_Self_Text:SetText("Chú ý, Các hÕ chï có 1 l¥n sØa ð±i tên. #r Các hÕ có mu¯n xác nh§n sØa ð±i tên là #G"..g_arg_chrc.."#cFFF263 không?");	
		CancelLastOp(FrameInfoList.CHAR_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CHAR_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if(event == "CITY_RANAME_CONFIRM" ) then
		g_arg_circ = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0 ð±i tên bang hµi");
		MessageBox_Self_Text:SetText("Chú ý, Các hÕ chï có 1 l¥n sØa ð±i tên. #r Các hÕ có mu¯n xác nh§n sØa ð±i tên bang hµi là #G"..g_arg_circ.."#cFFF263 không?");	
		CancelLastOp(FrameInfoList.CITY_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "GAMELOGIN_OPEN_COUNT_INPUT") then
		if(this:IsVisible()) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
		
	if(event == "SAFEBOX_LOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_LOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_LOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0 Khóa ð¸nh Rß½ng bäo hi¬m");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_10}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if(event == "SAFEBOX_UNLOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_UNLOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_UNLOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0 Giäi khóa Rß½ng bäo hi¬m");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_07}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if (event == "CONFIRM_SETPOS_TLZ") then
		CancelLastOp(FrameInfoList.TLZ_CONFIRM_SETPOS);
		g_FrameInfo = FrameInfoList.TLZ_CONFIRM_SETPOS;
		
		local itemIdx = tonumber(arg0)
		local szSceneName = tostring(arg1);
		local iPosX = tonumber(arg2);
		local iPosZ = tonumber(arg3);
		
		Client_ItemIndex = itemIdx
		
		if (szSceneName ~= "") then
			MessageBox_Self_Text:SetText("#{TLZ_081114_1}"..szSceneName.." ("..iPosX..","..iPosZ..")".."#{TLZ_081114_2}")
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			MessageBox_Self_OK_Clicked()
			this:Hide()
			return
		end
		
	end
	
	-- µ¯³ö½âÉ¢¶ÓÎéµÄ¶þ´ÎÈ·ÈÏ´°¿Ú			add by WTT	20090212
	if (event == "OPNE_DISMISS_TEAM_MSGBOX")	then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Giäi tán ðµi");			-- ÉèÖÃ±êÌâ
		MessageBox_Self_Text:SetText( "#{TeamDismiss_090912_1}" );	-- ÉèÖÃÄÚÈÝ
		CancelLastOp(FrameInfoList.DISMISS_TEAM);
		g_FrameInfo = FrameInfoList.DISMISS_TEAM;
		MessageBox_Self_UpdateRect();																-- »Ö¸´´°¿Ú´óÐ¡µ½³õÊ¼´óÐ¡
		this:Show();
		return;
	end

	if(MessageBox_Self_OnEventEx(event) > 0) then
		MessageBox_Self_UpdateFrame();
	end

end

function MeesageBox_Init()
	strMessageString = tostring( arg0 );
	strMessageData	= tostring( arg1 );
	strMessageArgs = tostring(arg2);
	strMessageType	= tostring(arg3);
	strMessageArgs_2 = tostring(arg4)
	CancelLastOp(FrameInfoList.EQUIP_ITEM);
	g_FrameInfo = FrameInfoList.EQUIP_ITEM;
	MessageBox_Update();
end

function MessageBox_Update()
	this:Show();
	MessageBox_Self_OK_Button:Hide();
	MessageBox_Self_Cancel_Button:Hide();
	MessageBox_Self_Text:SetText( strMessageString );
	MessageBox_Self_DragTitle:SetText("#gFF0FA0#gFF0FA0Ð°ng ý")
	if( strMessageType == "Normal" ) then
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "OK" ) then
		MessageBox_Self_OK_Button:Show();
	elseif( strMessageType == "Cancel" ) then
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "NoButton" ) then
	elseif( strMessageType == "Hide" ) then
		this:Hide();
	end
	MessageBox_Self_UpdateRect();
end
function MessageBox_Self_City_UpdateFrame()
	--AxTrace(0,0,"MessageBox_Self_City_UpdateFrame:"..tostring(g_CityData[1]));
	--È¡Ïûµ±Ç°½¨Éè½¨ÖþÎïµÄÈ·ÈÏÐÅÏ¢
	if(g_CityData[1] == 0) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Hüy bö xây dñng hi®n tÕi");
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		local szExist = City:GetBuildingInfo(bId, "exist");
		if(tonumber(szExist) > 0) then szExist = "Thång c¤p"; else szExist = "Thi công"; end
		local szCurPro = tostring(City:GetCityManageInfo("CurProgress"));
		local szAttr = (City:GetBuildingInfo(bId, "condattrname"));

		local msg = "Bang hi®n th¶i ðang"..szExist..szName..", ðã hoàn thành tiªn ðµ "..szCurPro..". Nªu ch¤m dÑt, ";
		msg = msg..szExist.."s¨ th¤t bÕi, t¤t cä tiªn ðµ s¨ là 0, không hoàn lÕi b¤t cÑ ngân lßþng nào cüa Bang và "..szAttr..", các hÕ mu¯n kªt thúc ";
		msg = msg..szExist.."không?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ÉêÇëÁìµØÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 1) then
		local szPortName = City:GetPortInfo(g_CityData[2], "Name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Xin lãnh ð¸a");
		--ÄãÈ·¶¨ÒªÉêÇëËùÔÚÓÚAAµÄ¡°BB¡±ÁìµØÂð£¿ÕâÏîÐÐÎªÐèÒªÏûºÄ1000¸ö½ð±Ò¡£
		local msg = "#cFFF263Các hÕ quyªt ð¸nh ch÷n #cFE7E82"..tostring(szPortName).."#cFFF263cüa#H"..g_CityData[3].."#cFFF263";
		msg = msg.."Lãnh ð¸a ß? Mu¯n v§y c¥n tiêu hao 1000#-14 ho£c 1 Kiªn Thành L®nh Bài.";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ÐÞ½¨»òÉý¼¶½¨ÖþÎï
	elseif(g_CityData[1] == 2 or g_CityData[1] == 3) then
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		if(bLevel == -1 or bId == -1) then
			local szExist = "";
			if(g_CityData[1] == 2) then
				MessageBox_Self_DragTitle:SetText("#gFF0FA0Xây dñng kiªn trúc m¾i");
				szExist = "Thi công";
			else
				MessageBox_Self_DragTitle:SetText("#gFF0FA0Nâng c¤p kiªn trúc");
				szExist = "Thång c¤p";
			end

			local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
			--½¨ÉèÌõ¼þ
			local cd = {City:GetBuildingInfo(g_CityData[2], "condition")};
			--0.½ðÇ®
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.ÏûºÄÖµ
			local szAttr = (City:GetBuildingInfo(g_CityData[2], "condattrname"));
			local szAttrVal = tostring(cd[4]);
			--2.ÈÎÎñÊý
			local mn = tostring(cd[2]);

			local msg = szExist..szName.." c¥n ngân lßþng cüa Bang "..money..", tiêu hao "..szAttr..szAttrVal;
			msg = msg.." ði¬m, ð°ng th¶i công b¯ "..mn.." nhi®m vø, các hÕ quyªt ð¸nh không?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(0);	--È¡Ïûµ±Ç°½¨ÖþµÄÈ·ÈÏÐÅÏ¢
		end
	--½µ¼¶»ò²ð»Ù½¨ÖþÎï
	elseif(g_CityData[1] == 4 or g_CityData[1] == 5) then
		local szExist = "";
		if(g_CityData[1] == 4) then
			MessageBox_Self_DragTitle:SetText("#gFF0FA0HÕ c¤p kiªn trúc");
			szExist = "HÕ c¤p ";
		else
			MessageBox_Self_DragTitle:SetText("#gFF0FA0Phá bö kiªn trúc");
			szExist = "Phá bö ";
		end

		local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
		local szPreAttr = "";
		_,szPreAttr = City:GetBuildingInfo(g_CityData[2], "condattrname");
		local msg = szExist..szName.." s¨ làm cho tác døng và chÑc nång cüa kiªn trúc giäm b¾t, nhßng không hoàn trä b¤t cÑ ngân lßþng nào cüa Bang và ";
		msg = msg..szPreAttr..", các hÕ có quyªt ð¸nh làm nhß v§y không?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ÐÞ¸Ä³ÇÊÐ·´Õ¹Ç÷ÊÆÁùÂÊÖµ
	elseif(g_CityData[1] == 6) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0SØa chæa phß½ng hß¾ng phát tri¬n");
		local msg = "Phß½ng hß¾ng sØa chæa phát tri¬n s¨ tiêu hao Bang quÛ 50#-02, các hÕ mu¯n quyªt ð¸nh làm nhß v§y không?"
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--È¡ÏûÑÐ¾¿µÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 7) then
		local rName, _, rIdx = City:GetResearchInfo("CurResearch");
		local szCurPro = tostring(City:GetResearchInfo("ResearchProcess"));

		MessageBox_Self_DragTitle:SetText("#gFF0FA0Nghiên cÑu kªt thúc");
		local msg = "Bang này hi®n th¶i ðang nghiên cÑu "..rName..", ðã hoàn thành tiªn ðµ "..szCurPro..". Nªu ch¤m dÑt, ";
		msg = msg.."Nghiên cÑu s¨ th¤t bÕi, t¤t cä tiªn ðµ s¨ là 0, không hoàn trä b¤t cÑ ngân lßþng cüa Bang và nhæng giá tr¸ thuµc tính, các hÕ quyªt ð¸nh mu¯n kªt thúc sñ nghiên cÑu hi®n tÕi không?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();		
		this:Show();
	--¿ªÊ¼ÑÐ¾¿µÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 8) then
		local rName = City:GetResearchInfo("CurResearch");
		if("" == rName) then
			local bIdx = tonumber(g_CityData[2]);
			local rIdx = tonumber(g_CityData[3]);
			MessageBox_Self_DragTitle:SetText("#gFF0FA0Nghiên cÑu pha chª thu¯c theo ð½n");
			local szResearchName = City:GetResearchInfo("ResearchName", bIdx, rIdx);
			--½¨ÉèÌõ¼þ
			local cd = {City:GetResearchInfo("ResearchCondition", bIdx, rIdx)};
			--0.½ðÇ®
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.ËùÐèÖµ
			local szAttr = City:GetResearchInfo("RCAttrName", bIdx, rIdx);
			local szAttrVal = tostring(cd[4]);
			--2.ÈÎÎñÊý
			local mn = tostring(cd[2]);
			local msg = "Nghiên cÑu "..szResearchName.." c¥n ngân lßþng cüa Bang "..money..", tiêu hao ";
			msg = msg..szAttr..szAttrVal..", ð°ng th¶i công b¯ nhi®m vø"..mn.." nhi®m vø, các hÕ quyªt ð¸nh không?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(7);	--È¡Ïûµ±Ç°ÑÐ¾¿µÄÈ·ÈÏÐÅÏ¢
		end
	--´´½¨ÉÌÒµÂ·ÏßµÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 9) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Sáng l§p giao thß½ng");
		local msg = "S¯ hi®u cüa thao tác này là "..tostring(g_CityData[2])..". Thành lâp tuyªn ðß¶ng thß½ng mÕi cüa Bang, chï c¥n 2 bên cùng thành l§p tuyªn ðß¶ng thß½ng mÕi, tuyªn ðß¶ng m¾i có hi®u lñc, các hÕ quyªt ð¸nh mu¯n thành l§p không?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--È¡ÏûÉÌÒµÂ·ÏßµÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 10) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Hüy bö giao thß½ng");
		local dt = {City:GetCityRoadInfo("RoadDetail", g_CityData[2])};
		local msg = "";
		if(dt[4]) then
			msg = "Thao tác này s¨ làm cho b±n bang và bang hµi ð¯i tác ð½n phß½ng kªt thúc hành vi thß½ng mÕi này, các hÕ quyªt ð¸nh mu¯n tiªp tøc tiªn hành thao tác không?";
		else
			msg = "Thao tác này có phäi s¨ làm cho b±n bang và bang hµi ð¯i tác tiªp tøc có khä nång cùng nhau xây dñng tuyªn ðß¶ng thß½ng mÕi này, các hÕ quyªt ð¸nh mu¯n tiªp tøc tiªn hành thao tác không?";
		end
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
end

function MessageBox_Self_City_OK_Clicked()
	if(g_CityData[1] == 0) then
		local nBuildingId;
		_,_,nBuildingId = City:GetCityManageInfo("CurBuilding");
		City:DoBuilding(nBuildingId, "cancelup");
	elseif(g_CityData[1] == 1) then
		City:CreateCity(g_CityData[2],g_CityData[3]);
	elseif(g_CityData[1] == 2) then
		City:DoBuilding(g_CityData[2], "create");
	elseif(g_CityData[1] == 3) then
		City:DoBuilding(g_CityData[2], "up");
	elseif(g_CityData[1] == 4) then
		City:DoBuilding(g_CityData[2], "down");
	elseif(g_CityData[1] == 5) then
		City:DoBuilding(g_CityData[2], "destory");
	elseif(g_CityData[1] == 6) then
		local k;
		local valTab = {};
		for k = 2, 8 do
			valTab[k-1] = tonumber(g_CityData[k]);
		end
		City:FixCityTrend(
												valTab[1],valTab[2],valTab[3],valTab[4],
												valTab[5],valTab[6],valTab[7],valTab[8]
										 );
	elseif(g_CityData[1] == 7) then
		local rName, bIdx, rIdx = City:GetResearchInfo("CurResearch");
		City:DoResearch(bIdx, rIdx, "cancelresearch");
	elseif(g_CityData[1] == 8) then
		City:DoResearch(tonumber(g_CityData[2]), tonumber(g_CityData[3]), "research");
	elseif(g_CityData[1] == 9) then
		City:DoCityRoad("create", g_CityData[2]);
	elseif(g_CityData[1] == 10) then
		City:DoCityRoad("cancel", g_CityData[2]);
	end
	g_CityData = {};
end

function MessageBox_Self_City_Cancel_Clicked()
	g_CityData = {};
end


--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrameEx()

	if( g_FrameInfo==FrameInfoList.SAVE_STALL_INFO) then
		
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Bäo lßu v¸ trí cØa hàng");
		local szInfo;
		szInfo = "#{INTERFACE_XML_681}";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- add by zchw
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Thu hàng");
		local szInfo;
		szInfo = "B¢ng hæu xác nh§n mu¯n thu hàng không ?";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- zchw for pet procreate
	elseif (g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Chú ý");
		MessageBox_Self_Text:SetText("#{PET_FANZHI_20080313_01}");
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Mua v§t ph¦m ");
		local szInfo;
		szInfo = "Mua"..g_CityData[3].." c¥n hao phí "..tostring(g_CityData[2]).." nguyên bäo, các hÕ xác nh§n không ?";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Mua v§t ph¦m ");
		local szInfo;
		szInfo = "Mua"..CommisionBuyData[1].." c¥n hao phí "..CommisionBuyData[2]..", các hÕ xác nh§n không ?";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
		
	end

end

--===============================================
-- UpdateTitle
--===============================================
function UpdateTitle()
    --ÒòÎªÔÚMessageBox_Self_UpdateFrameº¯ÊýÖÐ,"upvalue"ÑÏÖØ³¬Ô±,Ôö¼ÓÁËÕâ¸öº¯ÊýÓÃÀ´¸ü¸ÄmsgboxµÄ±êÌâ
    if ( PVPFLAG.FREEFORALL == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0Thay ð±i PK");
    elseif ( PVPFLAG.FREEFORTEAM == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0Thay ð±i PK");
    elseif ( PVPFLAG.FREEFORGUILD == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0Thay ð±i PK");
    elseif ( PVPFLAG.MAKESUREPVPCHALLENGE == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Xác nh§n tuyên chiªn");
	end
	MessageBox_Self_UpdateRect();

end

--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrame()

	MessageBox_Self_DragTitle:SetText("#gFF0FA0");
	UpdateTitle()

	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		this : Show()
		MessageBox_Self_Text : SetText( GemCombinedData[7] )
		MessageBox_Self_UpdateRect();
		return
	end

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--ÌáÊ¾±¾µÄ·ÑÓÃ
		local nPosTax = StallSale:GetPosTax();
		local nTradeTax = StallSale:GetTradeTax();

		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(nPosTax);

		local szMoneyPosTax = "";
		if(nGoldCoin ~= 0)   then
		 	szMoneyPosTax = tostring(nGoldCoin) .. "#-14";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoneyPosTax = szMoneyPosTax .. tostring(nSilverCoin) .. "#-15";
		end
		if(nCopperCoin ~= 0)   then
			szMoneyPosTax = szMoneyPosTax .. tostring(nCopperCoin) .. "#-16";
		end

		local nCoinType = StallSale:GetStallType()
		if (nCoinType == 1) then --Ôª±¦°ÚÌ¯
			local szInfo = "#{YBBT_081031_1}".. szMoneyPosTax .."#{YBBT_081031_2}1#{YBBT_081031_3}";
			MessageBox_Self_Text:SetText(szInfo);
		else
			local szInfo = "#{YBBT_081031_4}".. szMoneyPosTax .."#{YBBT_081031_5}".. tostring(nTradeTax) .."#{YBBT_081031_6}";
			MessageBox_Self_Text:SetText(szInfo);
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--Í¨Öª½â³ýËø¶¨
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Tiêu hüy v§t ph¦m");
		local szStr = "Các hÕ th§t lòng mu¯n tiêu hüy ".. argDISCARD_ITEM_FRAME0 .."?"
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Tiêu hüy v§t ph¦m");
		local szStr = argCANNT_DISCARD_ITEM0.."Ðây là v§t ph¦m nhi®m vø, không ðßþc tiêu hüy";
		MessageBox_Self_Text:SetText(szStr);
		
	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Khoá");
		local szStr = "#cff0000 Chú ý! #r#YVì bäo v® sñ an toàn cüa tài khoän các hÕ, nên thß¶ng sØ døng chÑc nång khóa ð¸nh v§t ph¦m ho£c trân thú, ð°ng th¶i m²i l¥n mu¯n giäi khóa c¥n thiªt ðþi hªt #G3 ngày#W m¾i có th¬ giäi khóa ðßþc, các hÕ có ð°ng ý xác nh§n khóa ð¸nh không?";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0T× bö nhi®m vø");
		local szStr = "#cFFF263Các hÕ th§t lòng mu¯n t× bö #Rnhi®m vø: "..argFRAME_AFFIRM_SHOW0.."#cFFF263 không?";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Thành l§p Bang hµi");
		local szStr = "Các hÕ xác nh§n sáng l§p" .. argCREATE_CONFIRM0 .. " bang hµi không?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0Giäi tán");
		local szStr = "Các hÕ xác nh§n hüy bö" .. argDESTORY_CONFIRM0 .. " bang hµi không?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Rút lui bang hµi");
		local szStr = "Các hÕ xác nh§n rút lui" .. argQUIT_CONFIRM0 .. " bang hµi không?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0R¶i bö Ð°ng Minh ");
		local szStr = "Các hÕ xác nh§n rút lui" .. argQUIT_LEAGUE_CONFIRM0 .. "Ð°ng Minh không ?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Thiªt l§p Ð°ng Minh");
		local szStr = "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		MessageBox_Self_Text:SetText(argNET_CLOSE0);
	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Phóng sinh trân thú");
		local petname = Pet:GetPetList_Appoint(Pet_Number) ;
		local strname, pettype = Pet:GetName(Pet_Number);
		local szStr = "Có mu¯n xác nh§n phóng sinh ["..petname.."]("..pettype..")?" ;
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0SØa ð±i tên cØa hàng");
		--Íæ¼ÒÉÌµê¸üÃûÐèÒªµÄ½ðÇ®Êý×Ö
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "SØa ð±i tên gian hàng c¥n chi trä phí kim tñ 2".."#-02".. "* chï s¯ thß½ng nghi®p, chï s¯ thß½ng nghi®p hi®n tÕi là ".. PlayerShop:GetCommercialFactor().."C¥n chi ra"..szMoney..", các hÕ mu¯n quyªt ð¸nh sØa ð±i không?"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--Íæ¼ÒÉÌµê¸ü¸ü¸ÄÉÌµêËµÃ÷ÐèÒªµÄ½ðÇ®Êý×Ö
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Ð±i gi¾i thi®u");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "SØa ð±i gian hàng và miêu tä c¥n chi trä phí Bút mñc".."50#-03".. "* chï s¯ thß½ng nghi®p, chï s¯ thß½ng nghi®p hi®n tÕi là ".. PlayerShop:GetCommercialFactor().."C¥n chi ra"..szMoney..", các hÕ mu¯n quyªt ð¸nh sØa ð±i không?"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0NÕp ti«n vào");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Các hÕ s¨ nÕp vào" .. szMoney .. ", h® th¯ng s¨ thu cüa các hÕ 3% thuª ð¥u tß, các hÕ s¨ c¥n phäi chi ngoài " .. szMoney1 .. ", các hÕ quyªt ð¸nh nÕp vào không?";

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0 Nh§p vào ti«n lþi nhu§n");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Các hÕ s¨ nÕp vào" .. szMoney .. ", h® th¯ng s¨ thu cüa các hÕ 3% thuª ð¥u tß, các hÕ s¨ c¥n phäi chi ngoài " .. szMoney1 .. ", các hÕ quyªt ð¸nh nÕp vào không?";

		MessageBox_Self_Text:SetText(szInfo);

	

	elseif(g_FrameInfo == FrameInfoList.PS_DEC_GAIN_MONEY)    then

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Server_Script_Function = Get_XParam_STR(0);
		Server_Script_ID = Get_XParam_INT(0);
		Server_Return_1 = Get_XParam_INT(1);
		Server_Return_2 = Get_XParam_INT(2);

		MessageBox_Self_Text:SetText(Get_XParam_STR(1));

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0M· rµng qu¥y hàng");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "M· rµng qu¥y hàng c¥n chi ra 30#-02*chï s¯ thß½ng nghi®p*2*103%, chï s¯ thß½ng nghi®p hi®n th¶i là".. PlayerShop:GetCommercialFactor() ..", c¥n chi ra" .. szMoney .. ", các hÕ mu¯n quyªt ð¸nh m· rµng không?"

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Giäm b¾t qu¥y hàng");
		MessageBox_Self_Text:SetText("Sau khi thu giäm qu¥y hàng, s¯ hàng hóa cüa các hÕ bày ra bán trong qu¥y hàng cûng s¨ b¸ h® th¯ng thu h°i. Các hÕ có xác ð¸nh mu¯n làm nhß v§y không ?");

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Chuy¬n ra khöi cØa hàng");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Chuy¬n ra khöi cØa hàng c¥n chi ra 15#-02*chï s¯ thß½ng nghi®p, chï s¯ thß½ng nghi®p hi®n tÕi là ".. PlayerShop:GetCommercialFactor() ..", c¥n chi ra" .. szMoney .. ", các hÕ quyªt ð¸nh chuy¬n ra khöi cØa hàng không?"
		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)  then   --ÅÌÈë

		MessageBox_Self_DragTitle:SetText("#gFF0FA0Chuy¬n vào cØa hàng");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Hüy bö chuy¬n ra qu¥y hàng c¥n chi ra 5#-02*chï s¯ thß½ng nghi®p, chï s¯ thß½ng nghi®p hi®n tÕi là ".. PlayerShop:GetCommercialFactor() ..", c¥n chi ra" .. szMoney .. ", Các hÕ xác nh§n chuy¬n vào cØa ti®m sao?"

		MessageBox_Self_Text:SetText(szInfo);

	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Ð±i loÕi hình cØa hàng");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);
		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "SØa ð±i loÕi hình cØa hàng c¥n chi ra phí d÷n?5#-02 *chï s¯ thß½ng nghi®p, chï s¯ thß½ng nghi®p hi®n th¶i là".. PlayerShop:GetCommercialFactor() ..", c¥n chi ra" .. szMoney .. ", các hÕ mu¯n quyªt ð¸nh sØa ð±i không?"

		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0 hüy bö xác nh§n");
		local szInfo;
		local relationtype = DataPool:GetFriend(g_currentList,g_currentIndex, "RELATION_TYPE" )
		if relationtype == 7 then
			szInfo = "#cFFF263Các hÕ quyªt ð¸nh mu¯n hüy bö ".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."không ? Sau khi xóa bö s¨ không th¬ cùng ð¯i phß½ng tham gia b¤t cÑ hoÕt ðµng sß ð° nào.";
		else
			szInfo = "#cFFF263Các hÕ quyªt ð¸nh mu¯n hüy bö ".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".." không?";
		end
		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_UpdateFrame();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Trân thú h²n hþp");
		local msg = "Các hÕ quyªt ð¸nh mu¯n s¨";
		MessageBox_Self_Text:SetText(msg);
	elseif( g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Ð±i Bang C¯ng Bài");
	elseif( g_FrameInfo == FrameInfoList.PUT_GUILDMONEY ) then
		MessageBox_Self_DragTitle:SetText("#{BPZJ_0801014_020}");
	end

	MessageBox_Self_UpdateFrameEx();
	MessageBox_Self_UpdateRect();	
	this:Show();
end

--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function MessageBox_Self_OK_Clicked_Ex()
    AxTrace( 0, 0, "MessageBox_OnOKClick" )
	if( g_FrameInfo == FrameInfoList.FREEFORALL ) then --Í¬Òâ¿ªÆô¸öÈË»ìÕ½
        AxTrace( 0, 0, "FrameInfoList.FREEFORALL" )
        Player:ChangePVPMode( 1 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORTEAM ) then --Í¬Òâ¿ªÆô¶ÓÎé»ìÕ½
        AxTrace( 0, 0, "FrameInfoList.FREEFORTEAM" )
        Player:ChangePVPMode( 3 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORGUILD ) then  --Í¬Òâ¿ªÆô°ïÅÉ»ìÕ½
        AxTrace( 0, 0, "FrameInfoList.FREEFORGUILD" )
        Player:ChangePVPMode( 4 );
    end
    if( g_FrameInfo == FrameInfoList.MAKESUREPVPCHALLENGE ) then  --È·ÈÏÐûÕ½
        AxTrace( 0, 0, "FrameInfoList.MAKESUREPVPCHALLENGE" )
        Player:PVP_Challenge( 2 );     --2ÎªÐûÕ½È·ÈÏ¶Ô»°¿òÈ·ÈÏ
    end
    
    if(g_FrameInfo == FrameInfoList.CHANGEPROTECTTIME)then
	if(g_ChangeTiemArg1 ~= nil)then
		SendSetProtectTimeMsg(g_ChangeTiemArg1);
		g_ChangeTiemArg1 =nil;
	end
    end
    if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
        DuelAccept( tostring( PVPFLAG.DuelName ),tostring( PVPFLAG.DuelGUID ), 1 )
    end


	if( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		StallSale:CloseStall("ok");
	-- add by zchw	
		StallSale:CloseStallMessage();
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		StallSale:CloseStall("ask");
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		PushEvent(462, 0); --PETPROCREATE_KEY_STATE 
		Pet:ConfirmPetProcreate(1);
		
	elseif  g_FrameInfo == FrameInfoList.QUIT_GAME  then
		EnterQuitWait(0);
		--QuitApplication("quit");
	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)    then
		PlayerShop:ChangeShopNum("del_ok");
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)    then
		PlayerShop:Transfer("apply", "sale", g_nData);
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)    then
		PlayerShop:Transfer("apply", "back", g_nData);
	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		PlayerShop:ModifySubType("ps_type_ok", tonumber(g_nData));
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		DataPool:DelFriend( g_currentList, g_currentIndex );
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_OK_Clicked();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_PetSyn_OK_Clicked();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_DEMIS_CONFIRM) then
		Guild:DemisGuildOK();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		GuildLeague:Quit();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		local r=GuildLeague:Create(argCREATE_LEAGUE_CONFIRM0,argCREATE_LEAGUE_CONFIRM1)
		if r==-1 then
			PushDebugMessage("#{TM_20080311_05}")
		elseif r==-2 then
			PushDebugMessage("#{TM_20080311_07}")	
		end
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		NpcShop:BulkBuyItem(g_CityData[1],1);
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		CommisionShop:OnBuyConfrimed();
	end
	if( FrameInfoList.Player_Give_Rose == g_FrameInfo ) then
		Player:UseRose(tonumber(g_RoseArg1),tonumber(g_RoseArg2),tonumber(g_RoseArg3),tonumber(g_RoseArg4))
	end

	if(g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM) then
		if(Recycle_Type<0 or Recycle_CurSelectItem<0) then
			return
		end
		PlayerShop:SendCancelRecItemMsg(Recycle_Type,Recycle_CurSelectItem);
		Recycle_Type =-1;
		Recycle_CurSelectItem = -1;
	end

	if(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx<0 or Recycle_Shop_idx<0) then
			return
		end
		PlayerShop:SendSellItem2RecycleShopMsg(Recycle_Bag_idx,Recycle_Shop_idx);
		Recycle_Bag_idx =-1;
		Recycle_Shop_idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_STENGTH) then
		if(Stength_Equip_Idx<0 or Stength_Item_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishEnhance");
			Set_XSCRIPT_ScriptID(809262);
			Set_XSCRIPT_Parameter(0,tonumber(Stength_Equip_Idx));
			Set_XSCRIPT_Parameter(1,tonumber(Stength_Item_Idx));
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		Stength_Equip_Idx =-1;
		Stength_Item_Idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG) then
		if(BangGong_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("BanggongExchange");
			Set_XSCRIPT_ScriptID(805009);
			Set_XSCRIPT_Parameter(0,BangGong_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		BangGong_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.PUT_GUILDMONEY) then
		if(GuildMoney_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PutGuildMoney");
			Set_XSCRIPT_ScriptID(805012);
			Set_XSCRIPT_Parameter(0,GuildMoney_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		GuildMoney_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY) then
		if(RID_Equip_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishReAdjust");
			Set_XSCRIPT_ScriptID(809261);
			Set_XSCRIPT_Parameter(0,tonumber(RID_Equip_Idx));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		RID_Equip_Idx =-1;
	end
	if(g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX) then
		if(Member_Idx < 0) then
			return
		end
		Guild:SureKickGuild(tonumber(Member_Idx));
		Member_Idx =-1;
		Member_Name = "";
	end
	
	if (g_FrameInfo == FrameInfoList.TLZ_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(330001);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	
end

function MessageBox_OnOKClick()
	if( strMessageData == "EquipBind" ) then -- °ó¶¨
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end
	this:Hide();
end
--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function MessageBox_Self_OK_Clicked()
	
	if g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM then
		SafeBox("reallock");
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM then
		SafeBox("realunlock");
		this : Hide()
		return
	end
	
	if g_FrameInfo == FrameInfoList.CITY_RANAME_CONFIRM then
		Guild : SendCityRnameMsg( g_arg_circ )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.CHAR_RANAME_CONFIRM then
		Target : SendCharRnameMsg( g_arg_chrc )
		this : Hide()
		return
	end	
	
	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		LifeAbility : Do_Combine( GemCombinedData[1], GemCombinedData[2],
			GemCombinedData[3], GemCombinedData[4],
			GemCombinedData[5], GemCombinedData[6], 1 )
		this : Hide()
		return
	end
	
	if g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM then
		LifeAbility : Do_Enchase( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

-- add:lby20080527È·ÈÏ4ÏâÇ¶ENCHASE_FOUR_CONFIRM
	if g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM then
		LifeAbility : Do_Enchase_Four( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

	-- ³èÎïÑ§Ï°¼¼ÄÜÈ·ÈÏ£ºÁ½¸öÊÖ¶¯¼¼ÄÜÑ§Ï°
	if g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM then
		Pet:ConfirmPetSkillStudy()
		this:Hide()
		return
	end

--	if g_FrameInfo == FrameInfoList.CARVE_CONFIRM then
--	  Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name(CarveData[1]);
--		Set_XSCRIPT_ScriptID(CarveData[2]);
--		Set_XSCRIPT_Parameter(0,CarveData[3]);
--		Set_XSCRIPT_Parameter(1,CarveData[4]);
--		Set_XSCRIPT_ParamCount(CarveData[5]);
--	  Send_XSCRIPT();
--		this:Hide()
--		return
--	end
	

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--Í¨Öª·þÎñÆ÷¾ö¶¨¿ªÊ¼ÔÚÕâÀï°ÚÌ¯
		StallSale:AgreeBeginStall();

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--Í¨ÖªÏú»ÙÎïÆ·
		DiscardItem();

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		--ÈÎÎñÎïÆ·²»ÄÜÏú»Ù
		g_InitiativeClose = 1;
		this:Hide();
	
	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		--Í¨Öª¼ÓËøÎïÆ·
		LockAfterConfirm();

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		--·ÅÆúÈÎÎñ
		if(Quest_Number > -1) then
			QuestFrameMissionAbnegate(Quest_Number);
		end
		g_InitiativeClose = 1;
		this:Hide();


	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		Guild:CreateGuildConfirm(1);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		Guild:CreateGuildConfirm(2);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		Guild:CreateGuildConfirm(3);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		Pet : Go_Free(Pet_Number);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		--Íæ¼ÒÉÌµê¸üÃûÐèÒªµÄ½ðÇ®Êý×Ö
		PlayerShop:Modify("name_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--Íæ¼ÒÉÌµê¸ü¸ü¸ÄÉÌµêËµÃ÷ÐèÒªµÄ½ðÇ®Êý×Ö
		PlayerShop:Modify("ad_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		PlayerShop:ApplyMoney("immitbase_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		PlayerShop:ApplyMoney("immit_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name(Server_Script_Function);
			Set_XSCRIPT_ScriptID(Server_Script_ID);
			Set_XSCRIPT_Parameter(0,Server_Return_1);
			Set_XSCRIPT_Parameter(1,Server_Return_2);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)    then
		PlayerShop:ChangeShopNum("add_ok");
	end
	
	if( g_FrameInfo == FrameInfoList.EQUIP_ITEM ) then
		MessageBox_OnOKClick();
		return;
	end
	
	-- È·ÈÏ½âÉ¢¶ÓÎé			add by WTT	20090212
	if g_FrameInfo == FrameInfoList.DISMISS_TEAM then
		Player:ConfirmDismissTeam()
		this:Hide()
		return
	end

	MessageBox_Self_OK_Clicked_Ex();
	this:Hide();
end

function MessageBox_Self_PetSyn_OK_Clicked()
	Pet:Syn_Do(g_CityData[1], g_CityData[2]);
	g_CityData = {};
end
--===============================================
-- ·ÅÆú°ÚÌ¯(IDCONCEL)
--===============================================
function MessageBox_Self_Cancel_Clicked(bClick)
	if( 1 == bClick ) then
		--AxTrace( 0, 0, bClick )
		if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
		end
    end

	if ( g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME ) then
		--Í¨Öª½â³ýËø¶¨
		DiscardItemCancelLocked();

    elseif ( g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME ) then
		--Í¨Öª½â³ý¼ÓËø
		CancelLockAfterConfirm();

	elseif ( g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM ) then
		Guild:CreateGuildConfirm(0);

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_Cancel_Clicked();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		g_CityData = {};
	-- add by zchw
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		this:Hide();
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		if bClick == 1 then
			PushEvent(462, 1); --PETPROCREATE_KEY_STATE
		end
		this:Hide();
	elseif( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		if bClick == 1 then
			StallSale:CloseStall("cancel");
			-- add by zchw
			StallSale:CloseStallMessage();
		end
		-- add by zchw
		StallSale:CloseStallMessage();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		g_CityData = {};
--	elseif( g_FrameInfo == FrameInfoList.SERVER_CONTROL ) then
--		Clear_XSCRIPT();
--			Set_XSCRIPT_Function_Name(Server_Script_Function);
--			Set_XSCRIPT_ScriptID(Server_Script_ID);
--			Set_XSCRIPT_Parameter(0,Server_Return_1);
--			Set_XSCRIPT_Parameter(1,-1);
--			Set_XSCRIPT_ParamCount(2);
--		Send_XSCRIPT();
	elseif(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx ~=nil and tonumber(Recycle_Bag_idx)>0) then
			PlayerShop:CancelSellItem2RecycleShop(Recycle_Bag_idx);
		end
	end

	this:Hide();


end

function MessageBox_Self_Help()
	if( g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE ) then
		Helper:GotoHelper( "61" );
	else
		Helper:GotoHelper("*MessageBox_Self");
	end
end