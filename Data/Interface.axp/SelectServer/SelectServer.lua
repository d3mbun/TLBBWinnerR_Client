-------------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿
--
local g_LastServer = -1;
local g_LastArea   = -1;
local g_LastServerName = "";
local CriticalSpeed1 =250
local CriticalSpeed2 =500
local CriticalSpeed3 =1000

local CriticalSpeed =200; 
local CurPage = 0
local NetSpeed ={"#e010101T¯c ðµ: #c4CFA4CT¯t","#e010101T¯c ðµ: #c4CFA4CB§n rµn","#e010101T¯c ðµ: Chßa biªt", "#e010101T¯c ðµ mÕng: #cff0000T¡c ngh¨n" }
local PageSize = 12

-- ÇøÓò°´Å¥µÄ¸öÊý
local LOGIN_SERVER_AREA_COUNT = 4;
--Ä¿Ç°ÓÐÐ§µÄÇøÓò°´Å¥¸öÊý£¬ÓÉÓÚ½çÃæ¸Ä¶¯Ì«´ó£¬ÅÂÒÔºóÓÐÈËÓÖ·´»Ú£¬¼ÓÕâ¸ö±äÁ¿£¬Ö÷ÒªÊÇ²»ÏëÈ¥µô·­Ò³´úÂë¡£
local EFFECT_LOGIN_SERVER_AREA_COUNT = 12; 
-- ¹«²âÇøÓò°´Å¥µÄ¸öÊý
local LOGIN_SERVER_TESTAREA_COUNT = 4;
-- ÇøÓò°´Å¥
local g_BnArea = {};

-- ¹«²âÇøÓò°´Å¥
local g_BntestArea = {};

-- µ±Ç°Ñ¡ÔñµÄÇøÓò
local g_iCurSelArea = 0;
-- login server ¿Í»§¶ËË÷Òý
local g_AreaIndex ={};
-- login server Ãû×Ö
local g_AreaName = {};
-- login server Ãû×Ö
local g_AreaDis = {};
-- testlogin server ¿Í»§¶ËË÷Òý
local g_testAreaIndex ={};
-- login server Ãû×Ö
local g_testAreaName = {};
-- login server Ãû×Ö
local g_testAreaDis = {};
-- µ±Ç°Ñ¡ÔñµÄÇøÓòÃû×Ö
local g_iCurSelAreaName;

--ÇøÓòtips
local g_AreaTip = {};
local g_testAreaTip = {};

-- Ñ¡ÔñµÄÍøÂç½ÓÈëÉÌ
local g_iNetProvide = 0;					-- 0 : µçÐÅ
								-- 1 : ÍøÍ¨
								-- 2 : ÆäËû
								-- 3£ºÄ¬ÈÏ


--¼ÇÔØÄ¬ÈÏÍøÂç½ÓÈëÉÌ¡£
local default_iNetProvide	=	1;

local g_idBackSound = -1;

-- Ñ¡Ôñ´úÀí	tongxi ,×¢ÊÍµô
--local g_UseProxy = 0;
-- ¼ÇÔØÍÆ¼ö·þÎñÆ÷µÄ¸öÊý
local indexForCommendable = 1;
------------------------------------------------------------------------------
--
-- login server ÐÅÏ¢
--

-- login server µÄ¸öÊý
--local LOGIN_SERVER_COUNT = 55;    -- modify by zchw 45-->55
local LOGIN_SERVER_COUNT = 15;    

local COMMENDABLE_LOGIN_SERVER_COUNT = 9;

-- login server °´Å¥
local g_BnLoginServer = {};
-- login server ×´Ì¬
local g_LoginServerStatus = {};
-- login server Ãû×Ö
local g_LoginServerName = {};
-- login server ÍÆ¼öµÈ¼¶
local g_LoginServerCommendableLevel = {};
-- login server ÊÇ·ñÐÂ¿ª
local g_LoginServerIsNew = {};



-- ÍÆ¼ö·þÎñÆ÷°´Å¥
local g_CommendableBnLoginServer = {};
-- ÍÆ¼ö·þÎñÆ÷Ãû×Ö
local g_CommendableLoginServerName = {};
-- ÍÆ¼ö·þÎñÆ÷Index
local g_CommendableLoginServerServerIndex = {};
-- ÍÆ¼ö·þÎñÆ÷ÇøÓòIndex
local g_CommendableLoginServerAreaIndex = {};
-- ÍÆ¼ö·þÎñÆ÷ÍÆ¼öµÈ¼¶
local g_CommendableLoginServerCommendableLevel = {};
-- ÍÆ¼ö·þÎñÆ÷ÊÇ·ñÐÂ·þ
local g_CommendableLoginServerIsNew = {};
-- ÍÆ¼ö·þÎñÆ÷ ×´Ì¬
local g_CommendableLoginServerStatus = {};



-------------------------------------------------------------------------------
--
-- ÆäËûÐÅÏ¢
--

-- µ±Ç°Ñ¡ÔñµÄlogin server
local g_iCurSelLoginServer = -1;
-- µ±Ç°Ñ¡ÔñµÄÍÆ¼ölogin server index
local g_iCurComSelLoginServer = -1;

-- ÇøÓòµÄ¸öÊý
local g_iCurAreaCount = 0;
--¹«²âÇøÓò¸öÊý
local g_iCurTestAreaCount = 0;

local g_FirstLogin = 1;


local StatMax = 10;

-------------------------------------------------------------------------------------------------------------
--
-- º¯ÊýÇø.
--
--

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectServer_PreLoad()
	-- ´ò¿ªÑ¡Ôñ·þÎñÆ÷½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_SERVER");

	-- Ñ¡ÔñÇøÓò
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_SERVER");

	-- ´ò¿ªÑ¡Ôñ·þÎñÆ÷½çÃæ
	this:RegisterEvent("GAMELOGIN_SELECT_AREA");

	-- Ñ¡Ôñlogin
	this:RegisterEvent("GAMELOGIN_SELECT_LOGINSERVER");

	-- Ñ¡ÔñÊÇ·ñÊ¹ÓÃ´úÀí
	this:RegisterEvent("GAMELOGIN_SELECT_USEPROXY");

	-- ×¢²áÑ¡ÔñÒ»¸ölogin serverÊÂ¼þ
	this:RegisterEvent("GAMELOGIN_SELECT_LOGIN_SERVER");

	-- Íæ¼Ò½øÈë³¡¾°
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	--ping½á¹û
	this:RegisterEvent("PING_RESAULT");
	--ÉÏ´ÎµÇÂ¼µÄ·þÎñÆ÷
	this:RegisterEvent("GAMELOGIN_LASTSELECT_AREA_AND_SERVER");
	
end

function LoginSelectServer_OnLoad()
	
	-- µÃµ½ÇøÓò°´Å¥
	g_BnArea[1] = SelectServer_Subarea1;
	g_BnArea[2] = SelectServer_Subarea2;
	g_BnArea[3] = SelectServer_Subarea3;
	g_BnArea[4] = SelectServer_Subarea4;
	-- g_BnArea[5] = SelectServer_Subarea5;
	-- g_BnArea[6] = SelectServer_Subarea6;
	-- g_BnArea[7] = SelectServer_Subarea7;
	-- g_BnArea[8] = SelectServer_Subarea8;
	-- g_BnArea[9] = SelectServer_Subarea9;
	-- g_BnArea[10] = SelectServer_Subarea10;
	-- g_BnArea[11] = SelectServer_Subarea11;
	-- g_BnArea[12] = SelectServer_Subarea12;

	-- g_BnArea[13] = SelectServer_Subarea13;
	-- g_BnArea[14] = SelectServer_Subarea14;
	-- g_BnArea[15] = SelectServer_Subarea15;
	-- g_BnArea[16] = SelectServer_Subarea16;
	-- g_BnArea[17] = SelectServer_Subarea17;
	-- g_BnArea[18] = SelectServer_Subarea18;
	-- g_BnArea[19] = SelectServer_Subarea19;
	-- g_BnArea[20] = SelectServer_Subarea20;
	-- g_BnArea[21] = SelectServer_Subarea21;
	-- g_BnArea[22] = SelectServer_Subarea22;
	-- g_BnArea[23] = SelectServer_Subarea23;
	-- g_BnArea[24] = SelectServer_Subarea24;
	
	g_BntestArea[1] = SelectServer2_Subarea1;
	g_BntestArea[2] = SelectServer2_Subarea2;
	g_BntestArea[3] = SelectServer2_Subarea3;
	g_BntestArea[4] = SelectServer2_Subarea4;
	--g_BntestArea[5] = SelectServer2_Subarea5;
	--µÃµ½ÍÆ¼ö·þÎñÆ÷ÁÐ±í
	g_CommendableBnLoginServer[1] = SelectServer_Commendable_Subarea1;
	g_CommendableBnLoginServer[2] = SelectServer_Commendable_Subarea2;
	g_CommendableBnLoginServer[3] = SelectServer_Commendable_Subarea3;
	g_CommendableBnLoginServer[4] = SelectServer_Commendable_Subarea4;
	g_CommendableBnLoginServer[5] = SelectServer_Commendable_Subarea5;
	g_CommendableBnLoginServer[6] = SelectServer_Commendable_Subarea6;
	g_CommendableBnLoginServer[7] = SelectServer_Commendable_Subarea7;
	g_CommendableBnLoginServer[8] = SelectServer_Commendable_Subarea8;
	g_CommendableBnLoginServer[9] = SelectServer_Commendable_Subarea9;	

	
	local i;
	for i = 1, LOGIN_SERVER_AREA_COUNT do
		
	 	g_BnArea[i]:SetProperty("CheckMode", "1");
		
		g_AreaName[i] = "";
		g_AreaDis[i] = "";
		g_AreaTip[i] = "";
		g_testAreaTip[i] = "";
	end
	
	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
	 	-- Login server °´Å¥
		
	 	g_CommendableBnLoginServer[i]:SetProperty("CheckMode", "1");
		-- login server Ãû×Ö
		g_CommendableLoginServerName[i] = "";
		--login server index
		g_CommendableLoginServerIndex[i]=-1;
	end
	-- µÃµ½·þÎñÆ÷°´Å¥
	g_BnLoginServer[1] = SelectServer_Server1;
	g_BnLoginServer[2] = SelectServer_Server2;
	g_BnLoginServer[3] = SelectServer_Server3;
	g_BnLoginServer[4] = SelectServer_Server4;
	g_BnLoginServer[5] = SelectServer_Server5;
	g_BnLoginServer[6] = SelectServer_Server6;
	g_BnLoginServer[7] = SelectServer_Server7;
	g_BnLoginServer[8] = SelectServer_Server8;
	g_BnLoginServer[9] = SelectServer_Server9;
	g_BnLoginServer[10] = SelectServer_Server10;

	g_BnLoginServer[11] = SelectServer_Server11;
	g_BnLoginServer[12] = SelectServer_Server12;
	g_BnLoginServer[13] = SelectServer_Server13;
	g_BnLoginServer[14] = SelectServer_Server14;
	g_BnLoginServer[15] = SelectServer_Server15;
	g_BnLoginServer[16] = SelectServer_Server16;
	g_BnLoginServer[17] = SelectServer_Server17;
	g_BnLoginServer[18] = SelectServer_Server18;
	g_BnLoginServer[19] = SelectServer_Server19;
	g_BnLoginServer[20] = SelectServer_Server20;
	--
	g_BnLoginServer[21] = SelectServer_Server21;
	g_BnLoginServer[22] = SelectServer_Server22;
	g_BnLoginServer[23] = SelectServer_Server23;
	g_BnLoginServer[24] = SelectServer_Server24;
	g_BnLoginServer[25] = SelectServer_Server25;
	g_BnLoginServer[26] = SelectServer_Server26;
	g_BnLoginServer[27] = SelectServer_Server27;
	g_BnLoginServer[28] = SelectServer_Server28;
	g_BnLoginServer[29] = SelectServer_Server29;
	g_BnLoginServer[30] = SelectServer_Server30;
	g_BnLoginServer[31] = SelectServer_Server31;
	g_BnLoginServer[32] = SelectServer_Server32;
	g_BnLoginServer[33] = SelectServer_Server33;
	g_BnLoginServer[34] = SelectServer_Server34;
	g_BnLoginServer[35] = SelectServer_Server35;
  --
	g_BnLoginServer[36] = SelectServer_Server36;
	g_BnLoginServer[37] = SelectServer_Server37;
	g_BnLoginServer[38] = SelectServer_Server38;
	g_BnLoginServer[39] = SelectServer_Server39;
	g_BnLoginServer[40] = SelectServer_Server40;
	g_BnLoginServer[41] = SelectServer_Server41;
	g_BnLoginServer[42] = SelectServer_Server42;
	g_BnLoginServer[43] = SelectServer_Server43;
	g_BnLoginServer[44] = SelectServer_Server44;
	g_BnLoginServer[45] = SelectServer_Server45;
	--
	---- add by zchw
	--g_BnLoginServer[46] = SelectServer_Server46;
	--g_BnLoginServer[47] = SelectServer_Server47;
	--g_BnLoginServer[48] = SelectServer_Server48;
	--g_BnLoginServer[49] = SelectServer_Server49;
	--g_BnLoginServer[50] = SelectServer_Server50;
	--g_BnLoginServer[51] = SelectServer_Server51;
	--g_BnLoginServer[52] = SelectServer_Server52;
	--g_BnLoginServer[53] = SelectServer_Server53;
	--g_BnLoginServer[54] = SelectServer_Server54;
	--g_BnLoginServer[55] = SelectServer_Server55;
	
		
	for i = 1, LOGIN_SERVER_COUNT do
	 	-- Login server °´Å¥
	 	g_BnLoginServer[i]:SetProperty("CheckMode", "1");

		-- login server ×´Ì¬
		g_LoginServerStatus[i] = 0;

		-- login server Ãû×Ö
		g_LoginServerName[i] = "";
		
		g_LoginServerCommendableLevel[i]="";
	end
	-- Òþ²ØËùÓÐÍÆ¼ö·þÎñÆ÷
	HideAllCommendableBn();	
	-- µÃµ½·þÎñÆ÷ÐÅÏ¢
	LoginSelectServer_GetServerInfo();

	-- µÃµ½ÍÆ¼öµÄ·þÎñÆ÷

	-- µäÐÍÌá¹©ÉÌ
	SelectServer_Line1:SetProperty("CheckMode", "1");
	SelectServer_Line2:SetProperty("CheckMode", "1");
	SelectServer_Line3:SetProperty("CheckMode", "1");
	SelectServer_Line4:SetProperty("CheckMode", "1");

	-- ÍøÂç·þÎñÉÌ°´Å¥.
	SelectServer_Line1:SetText("Ði®n tín");
	SelectServer_Line2:SetText("MÕng internet");
	SelectServer_Line3:SetText("MÕng giáo døc");

	--Í¯Ï² Ìí¼ÓÄ¬ÈÏ°´Å¥
	SelectServer_Line4:SetText("M£c ð¸nh");

	local strNormalColor = "#cFFF263";
	SelectServer_Help_Text1:SetText(	strNormalColor.."#e010101#cff0000Ðö: Ð¥y#cffffff" );
	SelectServer_Help_Text2:SetText(	strNormalColor.."#e010101#cECE58DNhÕt: T¯t#cffffff" );
	SelectServer_Help_Text3:SetText(	strNormalColor.."#e010101#c959595Xám: Bäo dßÞng#cffffff" );
	SelectServer_Help_Text4:SetText(	strNormalColor.."#e010101#cff8a00Da cam: S¡p ð¥y#cffffff" );
	SelectServer_Help_Text5:SetText(	strNormalColor.."#e010101#c4CFA4CXanh lá: Cñc t¯t#cffffff" );


	-- ´ò¿ª½çÃæ
	SelectServer_Frame:SetProperty("AlwaysOnTop", "True");

	-- ÏÈÒþ²ØËùÓÐ°´Å¥¡£
	HideAreaBn();
	-- ÏÈÒþ²ØËùÓÐ°´Å¥¡£
	HideTestAreaBn();


end

function HideAllCommendableBn()
	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
		g_CommendableBnLoginServer[i]:Hide();
	end;
end
--ÊÇ·ñ×Ô¶¯°ÑÑ¡ÔñµÄ·þÎñÆ÷ÐòºÅ±ä³É0£¬·ÀÖ¹.txtÎÄ¼þÓÐ´óµÄ±ä¶¯
local autoZero = 0;
-- OnEvent
function LoginSelectServer_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_SELECT_SERVER" ) then

		this:Show();

		-- ÏÔÊ¾´æÔÚµÄÇøÓò°´Å¥¡£
		ShowAreaBn();
		ShowTestAreaBn();
		--ÏÔÊ¾ÉÏÏÂ·­Ò³
		UpdateUpAddDownButton();

		-- ²¥·Å±³¾°ÒôÀÖ
		if(g_idBackSound == -1) then
			g_idBackSound = Sound:PlaySound(113, true);
		end
		
		--if( 1 == g_FirstLogin ) then
           -- GameProduceLogin:ShowMessageBox( "    Ä¿Ç°Ö»¿ª·ÅÁËÒ»Ì¨ÍøÍ¨·þÎñÆ÷ÓÃÓÚ²âÊÔ£¬Èç¹ûÄúÊÇµçÐÅµÄÓÃ»§£¬ÇëÔÚ·þÎñÆ÷Ñ¡Ôñ½çÃæµÄÓÒ±ßÑ¡Ôñ¡°µçÐÅ¡±½øÐÐµÇÂ¼£¬ÕâÑù²ÅÄÜÊ¹ÓÃ»¥Áª»¥Í¨¹¦ÄÜÒÔ±£Ö¤ÄúµÄÁ¬½ÓËÙ¶È¡£", "OK", "1" );
		    --g_FirstLogin = 0
		--end
		
		return;
	end


	-- ¹Ø±Õ½çÃæ
	if( event == "GAMELOGIN_CLOSE_SELECT_SERVER") then

		this:Hide();
		return;
	end

	-- Ñ¡ÔñÒ»¸ölogin server
	if( event == "GAMELOGIN_SELECT_LOGIN_SERVER") then
		local num = tonumber(arg0);
		for aindex = 1,g_iCurAreaCount do 
			if(num == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				SelectServer_SelectLoginServer(tonumber(arg1),1);
			return;
			end	
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(num == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				SelectServer_SelectLoginServer(tonumber(arg1),1);
				return;
			end
		end
		return;
	end

	-- Ñ¡ÔñÇøÓò
	if( event == "GAMELOGIN_SELECT_AREA") then
		autoZero = 0;

		local num = tonumber(arg0);
		for aindex = 1,g_iCurAreaCount do 
			if(num == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				return;
			end	
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(num == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				return;
			end
		end
		--ÍêÈ«Ã»ÓÐÕÒµ½£¬ËµÃ÷ÎÄ¼þÓÐÁË´óµÄ±ä»¯
		CurPage = 0;
		autoZero = 1;
		SelectServer_SelectAreaServer(1 - CurPage*PageSize -1);
		return;
	end;

	-- Ñ¡Ôñlogin
	if( event == "GAMELOGIN_SELECT_LOGINSERVER") then
		if ( g_BnLoginServer[tonumber(arg0)+1]:GetProperty("Disabled")=="False") then
			if(autoZero == 0 )then
				SelectServer_SelectLoginServer(tonumber(arg0),0);	
			else
				SelectServer_SelectLoginServer(0,0);	
				autoZero = 0;
			end	
		end;
		return;
	end;

	-- Ê¹ÓÃ´úÀí
	--Í¯Ï²
	if( event == "GAMELOGIN_SELECT_USEPROXY" ) then
		if tonumber(arg0) == 1 then
			--SelectServer_Deputize:SetCheck(1)
			SelectServer_SelectLine2();
		elseif tonumber(arg0) == 0 then
			--SelectServer_Deputize:SetCheck(0)
			SelectServer_SelectLine1();
		elseif tonumber(arg0) == 2 then
			SelectServer_SelectLine3();
		else
			SelectServer_SelectLine4();
		end
	
		return;
	end;
	
	-- ½øÈë³¡¾°£¬Í£Ö¹±³¾°ÒôÀÖ
	if( event == "PLAYER_ENTERING_WORLD") then
		if(g_idBackSound ~= -1) then
			Sound:StopSound(g_idBackSound);
			g_idBackSound = -1;
		end
	end
	--ping½á¹û
	if(event == "PING_RESAULT")then
		local num = tonumber(arg0)
		if(num ~=nil)then
			if(num>=0)then
				if(num<=CriticalSpeed)then
					SelectServer_Text2:SetText(NetSpeed[1]);
				elseif( num<=CriticalSpeed2 ) then
				    SelectServer_Text2:SetText(NetSpeed[2]);
				elseif( num<=CriticalSpeed3 ) then
				    SelectServer_Text2:SetText(NetSpeed[4]);
				else
				    SelectServer_Text2:SetText(NetSpeed[3]);
				--else
				--	SelectServer_Text2:SetText(NetSpeed[2]);
				end
				SelectServer_Text2:SetToolTip("Kéo dài th¶i gian mÕng: "..num);
			else
				SelectServer_Text2:SetText(NetSpeed[3]);			
				SelectServer_Text2:SetToolTip("Kéo dài th¶i gian mÕng: chßa biªt");			
			end
		end
	end

	--ÉÏ´ÎµÇÂ¼·þÎñÆ÷
	if( event == "GAMELOGIN_LASTSELECT_AREA_AND_SERVER") then
		local numArea =-1;
		local numServer = -1;
		if(arg0~=nil)then
			numArea = tonumber(arg0);
			g_LastArea = numArea
		end
		if(arg1~=nil)then
			numServer = tonumber(arg1);
			g_LastServer = numServer
		end
		if(numArea ~= -1 and numServer~=-1)then
			local have = 0;
			for aindex = 1,g_iCurAreaCount do 
				if(numArea == g_AreaIndex[aindex]) then
					have = 1;
					break;
				end	
			end
			for bindex = 1,g_iCurTestAreaCount do
				if(numArea == g_testAreaIndex[bindex]) then
					have = 1;
					break;
				end
			end
			if(have == 1)then
				local tmpServerName= GameProduceLogin:GetAreaLoginServerInfo(numArea, numServer);
				g_LastServerName = tmpServerName;
				SelectServer_Server_Last:SetText(tmpServerName);
				SelectServer_Server_Last:Enable();
				if(g_iCurSelArea == g_LastArea and g_LastServer ==g_iCurSelLoginServer)then
					SelectServer_Server_Last:SetCheck(1);
				end
			else
				SelectServer_Server_Last:SetText("Không");
				SelectServer_Server_Last:Disable();
			end
		else
			SelectServer_Server_Last:SetText("Không");
			SelectServer_Server_Last:Disable();
		end
		return;
	end;
	

end

function SelectServer_SelectLastServer()
	if(g_LastArea ~=-1 and g_LastServer ~= -1)then
		for aindex = 1,g_iCurAreaCount do 
			if(g_LastArea == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				SelectServer_SelectLoginServer(g_LastServer,1);
				return;
			end	
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(g_LastArea == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				SelectServer_SelectLoginServer(g_LastServer,1);
				return;
			end
		end

	end
end

--------------------------------------------------------------------------------------------------------------
--
-- µÃµ½·þÎñÆ÷ÐÅÏ¢
--

function LoginSelectServer_GetServerInfo()

	 	local iCurAreaCount = GameProduceLogin:GetServerAreaCount();
	 	local strAreaName = "Không có máy chü phøc vø";
		local iLoginServerCount = -1;
		local ServerName;
		local ServerStatus;
		--ÍÆ¼öµÈ¼¶
		local RecommendLevel; 
		local IsNew;
		indexForCommendable = 0;
		local testindex = 0;
		local nomalindex =0;
		local tuijian=0;
	 	for index = 0, iCurAreaCount - 1 do
			tuijian =0;
			if(testindex>=LOGIN_SERVER_TESTAREA_COUNT and nomalindex>=EFFECT_LOGIN_SERVER_AREA_COUNT) then
				break;
			end
			local areaname = GameProduceLogin:GetServerAreaName(index);
	 		-- µÃµ½ÇøÓòÃû×Ö.
			local i = string.find(areaname,"-");
			if(i~=nil and i<string.len(areaname)) then
				if(string.sub(areaname,1,i-1)=="MÕng internet" and testindex<LOGIN_SERVER_TESTAREA_COUNT)then
					testindex = testindex +1;
					g_testAreaName[testindex] = string.sub(areaname,i+1);
					g_testAreaDis[testindex] = GameProduceLogin:GetServerAreaDis(index);
					g_testAreaIndex[testindex] = index;
					tuijian = 1;
					g_testAreaTip[testindex] = GameProduceLogin:GetServerAreaDis(index);
				elseif(string.sub(areaname,1,i-1)=="Công tr¡c" and nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
					nomalindex = nomalindex +1;
	 				g_AreaName[nomalindex] = string.sub(areaname,i+1);
					g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
					g_AreaIndex[nomalindex] = index;
					tuijian = 1;
					g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				end
			elseif(nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
				nomalindex = nomalindex +1;
	 			g_AreaName[nomalindex] = GameProduceLogin:GetServerAreaName(index);
				g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				g_AreaIndex[nomalindex] = index;
				tuijian = 1;
				g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
			end;
	 		-- ÉèÖÃÃû×Ö.
			iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(index);
			if(iLoginServerCount > LOGIN_SERVER_COUNT) then
				iLoginServerCount=LOGIN_SERVER_COUNT;
			end
			--µÃµ½ÍÆ¼ö·þÎñÆ÷ÁÐ±í
			if(tuijian==1)then 
				for i=0,iLoginServerCount-1 do
					if(indexForCommendable>=COMMENDABLE_LOGIN_SERVER_COUNT) then
							break;
					end;
					ServerName,
					ServerStatus,
					--ServerID,
					--AreaID,
					RecommendLevel,
					IsNew
						= GameProduceLogin:GetAreaLoginServerInfo(index, i);
						-- ÍÆ¼ö·þÎñÆ÷id
					if(RecommendLevel>0 and indexForCommendable <COMMENDABLE_LOGIN_SERVER_COUNT and ServerStatus ~= StatMax) then
						indexForCommendable = indexForCommendable + 1;
						g_CommendableLoginServerName[indexForCommendable] = ServerName;
						g_CommendableLoginServerServerIndex[indexForCommendable] = i;
						g_CommendableLoginServerAreaIndex[indexForCommendable] = index;
						g_CommendableLoginServerCommendableLevel[indexForCommendable] = RecommendLevel;
						g_CommendableLoginServerIsNew[indexForCommendable] = IsNew;
						g_CommendableLoginServerStatus[indexForCommendable] = ServerStatus;

					end;			
				end
			end;
	 	end
		if(indexForCommendable>=1)then
			SortCommendableLoginServer();
			
			local strName="";
			for i = 1,indexForCommendable do
				g_CommendableBnLoginServer[i]:Show();
				local tmpAreaName = GameProduceLogin:GetServerAreaName(g_CommendableLoginServerAreaIndex[i]);
				local _i = string.find(tmpAreaName,"-");
				if(_i~=nil and _i<string.len(tmpAreaName)) then
					if(string.sub(tmpAreaName,1,_i-1)=="Công tr¡c" or string.sub(tmpAreaName,1,_i-1)=="MÕng internet")then
						tmpAreaName = string.sub(tmpAreaName,_i+1);
					end
				end
				strName =tmpAreaName.."-"..g_CommendableLoginServerName[i];								
				if(g_CommendableLoginServerIsNew[i]~=0)then
					strName =strName.."(M¾i)";
				end
				if(0 == g_CommendableLoginServerStatus[i]) then
					strName = "#cff0000#e010101"..strName.."#cffffff";
				elseif(1 == g_CommendableLoginServerStatus[i]) then

					strName = "#cff8a00#e010101"..strName.."#cffffff";
				elseif(2 == g_CommendableLoginServerStatus[i]) then

					strName = "#cECE58D#e010101"..strName.."#cffffff";
				elseif(3 == g_CommendableLoginServerStatus[i]) then

					strName = "#c4CFA4C#e010101"..strName.."#cffffff";
				else

					strName = "#c959595#e010101"..strName.."#cffffff";
					g_CommendableBnLoginServer[i]:Disable();
				end				
			
				g_CommendableBnLoginServer[i]:SetText(strName);
				g_CommendableBnLoginServer[i]:SetCheck(0);
			end;
		end;
		g_iCurAreaCount =nomalindex ;
		g_iCurTestAreaCount = testindex;
end

--ÅÅÐòÁÐ£¬´ÓÐ¡µ½´ó
function SortCommendableLoginServer()

	local TotalCount = indexForCommendable;
	local tmp ;
	local p=0;
	for j = 1 , TotalCount -1 do
		for i=1, TotalCount-j do
			if(g_CommendableLoginServerCommendableLevel[i]>g_CommendableLoginServerCommendableLevel[i+1]) then
				tmp = g_CommendableLoginServerCommendableLevel[i];
				g_CommendableLoginServerCommendableLevel[i] = g_CommendableLoginServerCommendableLevel[i+1];
				g_CommendableLoginServerCommendableLevel[i+1] = tmp;

				tmp = g_CommendableLoginServerName[i];
				g_CommendableLoginServerName[i] = g_CommendableLoginServerName[i+1];
				g_CommendableLoginServerName[i+1] = tmp;			
				
				tmp = g_CommendableLoginServerServerIndex[i];
				g_CommendableLoginServerServerIndex[i] = g_CommendableLoginServerServerIndex[i+1];
				g_CommendableLoginServerServerIndex[i+1] = tmp;	

				tmp = g_CommendableLoginServerAreaIndex[i];
				g_CommendableLoginServerAreaIndex[i] = g_CommendableLoginServerAreaIndex[i+1];
				g_CommendableLoginServerAreaIndex[i+1] = tmp;	

				tmp = g_CommendableLoginServerIsNew[i];
				g_CommendableLoginServerIsNew[i] = g_CommendableLoginServerIsNew[i+1];
				g_CommendableLoginServerIsNew[i+1] = tmp;	
				
				tmp = g_CommendableLoginServerStatus[i];
				g_CommendableLoginServerStatus[i] = g_CommendableLoginServerStatus[i+1];
				g_CommendableLoginServerStatus[i+1] = tmp;
			end
		end;
	end;
end;
--------------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÒ»¸ö¹«²âÇøÓò
--
function SelectServer_SelectTestAreaServer(index)
	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄÇøÓòË÷Òý.	
	g_iCurSelArea = g_testAreaIndex[index+1];

	-- ÉèÖÃÑ¡ÔñµÄÃû×Ö
	g_iCurSelAreaName = g_testAreaName[index+1];

	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	g_BntestArea[index+1]:SetCheck(1);

	-- Òþ²ØÇøÓò°´Å¥.
	SelectServer_HideLoginServerBn();

	-- µÃµ½login serverµÄÐÅÏ¢
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);

	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	for indexLoginServer = 0, iLoginServerCount - 1 do	
		SelectServer_GetAndShowLoginServer(indexLoginServer);
	end
	for iArea = 1, g_iCurAreaCount do	
		g_BnArea[iArea]:SetCheck(0);
	end
	DisableSelect();
end
--------------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÒ»¸öÇøÓò
--
function SelectServer_SelectAreaServer(index)

	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄÇøÓòË÷Òý.	
	g_iCurSelArea = g_AreaIndex[index+CurPage*PageSize+1];

	-- ÉèÖÃÑ¡ÔñµÄÃû×Ö
	g_iCurSelAreaName = g_AreaName[index+CurPage*PageSize+1];

	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	g_BnArea[index+1]:SetCheck(1);

	-- Òþ²ØÇøÓò°´Å¥.
	SelectServer_HideLoginServerBn();

	-- µÃµ½login serverµÄÐÅÏ¢
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);

	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	for indexLoginServer = 0, iLoginServerCount - 1 do	
		SelectServer_GetAndShowLoginServer(indexLoginServer);
	end
	for itestArea = 1, g_iCurTestAreaCount do	
		g_BntestArea[itestArea]:SetCheck(0);
	end
	DisableSelect();
end

function DisableSelect()
		g_iCurSelLoginServer =-1;
		g_iCurComSelLoginServer = -1;
		for i = 1,indexForCommendable do
				g_CommendableBnLoginServer[i]:SetCheck(0)		
		end;
		NotFlashAll();
		SelectServer_Text2:SetToolTip("");
		SelectServer_Text1:SetText("");
		SelectServer_Text2:SetText("");
		SelectServer_Text3:SetText("");
		--SelectServer_Accept:Disable();
end
--function EnableSelect()
--		SelectServer_Accept:Enable();
--end
--------------------------------------------------------------------------------------------------------------
--
-- ´ÓÍÆ¼öÁÐ±íÀïÑ¡ÔñÒ»¸ölogin server
--
--------------------------------------------------------------------------------------------------------------
function Commendable_SelectLoginServer(index)
	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	if(g_CommendableBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end
	
	g_iCurComSelLoginServer = index;

	g_CommendableBnLoginServer[index]:SetCheck(1);

	local strLoginServerStatus = "???";
	
	if(0 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff0000Ð¥y#cffffff";
	elseif(1 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff8a00S¡p ð¥y#cffffff";
	elseif(2 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cECE58DT¯t#cffffff";
	elseif(3 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#c4CFA4CCñc t¯t#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595Bäo dßÞng#cffffff";
	end
	
	i = g_CommendableLoginServerAreaIndex[index]
	SelectServer_ShowServerInfo(g_AreaName[i+1].."  "..g_CommendableLoginServerName[index], "", strLoginServerStatus);
	--Í¬Ê±¸üÐÂÏÂÃæµÄ·þÎñÆ÷ºÍserver
	g_iCurSelArea = g_CommendableLoginServerAreaIndex[index];
	for aindex = 1,g_iCurAreaCount do 
		if(g_iCurSelArea == g_AreaIndex[aindex]) then
			AxTrace(0,2,"5" )
			CurPage = math.floor((aindex-1)/PageSize);
			ShowPage();
			SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
			SelectServer_SelectLoginServer(g_CommendableLoginServerServerIndex[index],1);
			return;
		end	
	end
	for bindex = 1,g_iCurTestAreaCount do
		if(g_iCurSelArea == g_testAreaIndex[bindex]) then
			SelectServer_SelectTestAreaServer(bindex-1);
			SelectServer_SelectLoginServer(g_CommendableLoginServerServerIndex[index],1);
			return;
		end
	end
end;
--
-- Ñ¡ÔñÒ»¸ölogin server
--
function SelectServer_SelectLoginServer(index,flash)
	if(g_BnLoginServer[index+1]:GetProperty("Disabled")=="True") then
		return;
	end
	
	GameProduceLogin:SetPingServer(g_iCurSelArea,index);
	--EnableSelect();
	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄlogin server
	g_iCurSelLoginServer = index;

	if(g_LastServer == g_iCurSelLoginServer and g_LastArea == g_iCurSelArea)then
		SelectServer_Server_Last:SetCheck(1);
	else
		SelectServer_Server_Last:SetCheck(0);
	end
	
	if(flash==1)then
		g_BnLoginServer[index+1]:FlashMe(1);
	else
		NotFlashAll();
	end
	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	g_BnLoginServer[index+1]:SetCheck(1);
	local strLoginServerStatus = "???";

	if(0 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cff0000Ð¥y#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c9E5705S¡p ð¥y#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cECE58DT¯t#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c4CFA4CCñc t¯t#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595Bäo dßÞng#cffffff";
	end

	-- ÉèÖÃÐÅÏ¢
	SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_LoginServerName[index+1], "", strLoginServerStatus);

	--¸üÐÂÍÆ¼ö·þÎñÆ÷
	local tmpNum = 0
	--if(g_LoginServerCommendableLevel[index+1]>0) then
		for i = 1,indexForCommendable do
			if(g_CommendableLoginServerAreaIndex[i] == g_iCurSelArea and g_CommendableLoginServerServerIndex[i] == g_iCurSelLoginServer)then
				g_iCurComSelLoginServer = i;
				g_CommendableBnLoginServer[i]:SetCheck(1)
			else
				tmpNum = tmpNum+1;
				g_CommendableBnLoginServer[i]:SetCheck(0)	
			end;			
		end;
		if tmpNum>=indexForCommendable then
			g_iCurComSelLoginServer = -1
		end;
	--else 
	--	g_iCurComSelLoginServer = -1;
	--end;

end

function NotFlashAll()
	for i=1,LOGIN_SERVER_COUNT do
		g_BnLoginServer[i]:FlashMe(0);
		g_BnLoginServer[i]:SetCheck(0);
	end
end
--------------------------------------------------------------------------------------------------------------
--
-- µÃµ½Ò»¸ölogin serverÐÅÏ¢²¢ÏÔÊ¾
--
function SelectServer_GetAndShowLoginServer(index)

	g_LoginServerName[index+1]
	,g_LoginServerStatus[index+1]
	,g_LoginServerCommendableLevel[index+1]
	,g_LoginServerIsNew[index+1]
	= GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, index);
	g_BnLoginServer[index+1]:Enable();
	g_BnLoginServer[index+1]:Show();
	if(g_LoginServerStatus[index+1] == StatMax) then
		g_BnLoginServer[index+1]:Hide();
		return;
	end
	local strName = g_LoginServerName[index+1];

	if(g_LoginServerIsNew[index+1]==1)then
		strName = strName.."(M¾i)";
	end;

	if(0 == g_LoginServerStatus[index+1]) then

		strName = "#cff0000#e010101"..strName.."#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strName = "#cff8a00#e010101"..strName.."#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strName = "#cECE58D#e010101"..strName.."#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strName = "#c4CFA4C#e010101"..strName.."#cffffff";
	else

		strName = "#c959595#e010101"..strName.."#cffffff";
		g_BnLoginServer[index+1]:Disable();
	end

	g_BnLoginServer[index+1]:SetText(strName);
	
	

end

--------------------------------------------------------------------------------------------------------------
--
-- Òþ²Ølogin server °´Å¥
--
function SelectServer_HideLoginServerBn()

	local index;
	for index = 1, LOGIN_SERVER_COUNT  do
 		g_BnLoginServer[index]:Hide();
 	end

end

--------------------------------------------------------------------------------------------------------------
--
-- Òþ²Ølogin server °´Å¥
--
function SelectServer_ShowServerInfo(ServerName, NetStatus, ServerStatus)
	SelectServer_Text2:SetToolTip("");
	SelectServer_Text1:SetText("#e010101Máy chü: #cFFFF00"..ServerName);
	SelectServer_Text2:SetText(NetStatus);
	SelectServer_Text3:SetText("#e010101TrÕng thái: "..ServerStatus);

end

---------------------------------------------------------------------------------------------------------------
--
--  È·¶¨Ñ¡ÔñÒ»¸ö·þÎñÆ÷
--
function SelectServer_SelectOk()

	-- Á¬½Óµ½login server
	--Í¯Ï²£¬²»Ê¹ÓÃ´úÀí,´«Èë·þÎñÆ÷¹©Ó¦ÉÌ
	AxTrace(0,2,"g_iCurSelArea="..g_iCurSelArea )
	AxTrace(0,2,"g_iCurComSelLoginServer ="..g_iCurComSelLoginServer )
	AxTrace(0,2,"g_iCurSelLoginServer ="..g_iCurSelLoginServer )
	AxTrace(0,2,"\n")
	GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, g_iNetProvide);
	return;
end

---------------------------------------------------------------------------------------------------------------
--
--   ×Ô¶¯Ñ¡ÔñÒ»¸ö·þÎñÆ÷
--
function SelectServer_SelectAuto()
	GameProduceLogin:AutoSelLoginServer(g_iNetProvide);
end

---------------------------------------------------------------------------------------------------------------
--
--   ÍË³öÓÎÏ·
--
function SelectServer_Exit()
	QuitApplication("quit");
end


---------------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñµçÐÅ
--
function SelectServer_SelectLine1()

	-- Ñ¡ÔñµçÐÅ
	g_iNetProvide = 0;

	-- Ñ¡ÖÐµçÐÅ
	SelectServer_Line1:SetCheck(1);
	SelectServer_Line2:SetCheck(0);
	SelectServer_Line3:SetCheck(0);

	--tongxi
	SelectServer_Line4:SetCheck(0)

end


---------------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍøÍ¨
--
function SelectServer_SelectLine2()

	-- Ñ¡ÔñÍøÍ¨
	g_iNetProvide = 1;

	-- Ñ¡ÖÐÍøÍ¨
	SelectServer_Line1:SetCheck(0);
	SelectServer_Line2:SetCheck(1);
	SelectServer_Line3:SetCheck(0);

	--tongxi
	SelectServer_Line4:SetCheck(0);
end


---------------------------------------------------------------------------------------------------------------
--
-- ÆäËû
--
function SelectServer_SelectLine3()

	-- Ñ¡ÔñÆäËû
	g_iNetProvide = 2;

	-- Ñ¡ÖÐÆäËû
	SelectServer_Line1:SetCheck(0);
	SelectServer_Line2:SetCheck(0);
	SelectServer_Line3:SetCheck(1);
	--tongxi
	SelectServer_Line4:SetCheck(0);
end


---------------------------------------------------------------------------------------------------------------
--
-- Ä¬ÈÏ tongxi
--
function SelectServer_SelectLine4()

	-- Ñ¡ÔñÄ¬ÈÏ
	g_iNetProvide = 3;

	-- Ñ¡ÖÐÆäËû
	SelectServer_Line1:SetCheck(0);
	SelectServer_Line2:SetCheck(0);
	SelectServer_Line3:SetCheck(0);
	--tongxi
	SelectServer_Line4:SetCheck(1);
end

---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëÍÆ¼ö·þÎñÆ÷
--
function Commendable_LoginServer_MouseEnter(index)

	SelectServer_Info:SetText(g_CommendableLoginServerName[index]..tostring(" Máy chü phøc vø"));
end

---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëÇøÓò°´Å¥
--
function SelectServer_LoginServer_MouseEnter(index)

	SelectServer_Info:SetText(g_LoginServerName[index+1]..tostring(" Máy chü phøc vø"));
end

---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëÇøÓò°´Å¥
--
function SelectServer_LastServer_MouseEnter()
	if(g_LastServerName~="") then
		SelectServer_Info:SetText(g_LastServerName..tostring(" Máy chü phøc vø"));
	else
		SelectServer_Info:SetText("");
	end
end
---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ªÇøÓò°´Å¥
--
function SelectServer_LastServer_MouseLeave()

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ªÇøÓò°´Å¥
--
function SelectServer_LoginServer_MouseLeave(index)

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê¹«²âÇøÓò °´Å¥
--
function SelectServer_TestArea_MouseEnter(index)

	SelectServer_Info:SetText(g_testAreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ª¹«²âÇøÓò °´Å¥
--
function SelectServer_TestArea_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëlogin server °´Å¥
--
function SelectServer_Area_MouseEnter(index)

	SelectServer_Info:SetText(g_AreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ªlogin server °´Å¥
--
function SelectServer_Area_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


function SelectServer_Accept_MouseEnter()

	SelectServer_Info:SetText("Nh¤n vào s¨ có th¬ vào các cøm máy chü ðã ch÷n.");
end;

function SelectServer_MouseLeave()

	SelectServer_Info:SetText("");
end;

function SelectServer_Automatic_MouseEnter()

	SelectServer_Info:SetText("Giúp ðÞ các hÕ lña ch÷n bµ máy phøc vø t¯t nh¤t.");
end;


function SelectServer_Cancel_MouseEnter()

	SelectServer_Info:SetText("R¶i khöi Thiên Long Bát Bµ.");
end;



function SelectServer_MouseEnter_Line(index)

	if(1 == index) then

		SelectServer_Info:SetText("Nªu là tiªp nh§n ði®n tín, m¶i ch÷n ði¬m dß¾i cùng \"Lña ch÷n tñ ðµng\"");
		return;
	end

	if(2 == index) then

		SelectServer_Info:SetText("Nªu là tiªp nh§n mang internet, m¶i ch÷n ði¬m dß¾i cùng \"Lña ch÷n tñ ðµng\"");
		return;
	end

	if(3 == index) then

		SelectServer_Info:SetText("Nªu là tiªp nh§n mÕng giáo døc, m¶i ch÷n ði¬m dß¾i cùng \"Lña ch÷n tñ ðµng\"");
		return;
	end

	if(4 == index) then
		SelectServer_Info:SetText("Tiªp nh§n nh§n ng¥m, m¶i thü ðµng lña ch÷n 1 bµ máy phøc vø");
		return;
	end
end


function HideTestAreaBn()
	local index;
	--SelectServer2_Commendable_Text:Hide();
	for index = 1, LOGIN_SERVER_TESTAREA_COUNT  do
 		g_BntestArea[index]:Hide();
 	end
end
function HideAreaBn()
	local index;
	for index = 1, LOGIN_SERVER_AREA_COUNT  do
 		g_BnArea[index]:Hide();
 	end
end
function ShowTestAreaBn()
	local index;
	local index1 = 1;
	if g_iCurTestAreaCount<=0 then return; end
	--SelectServer2_Commendable_Text:Show();
	for index = 1,LOGIN_SERVER_TESTAREA_COUNT  do
 		if(index <= g_iCurTestAreaCount) then		
			g_BntestArea[index1]:SetText(g_testAreaName[index]);
			g_BntestArea[index1]:SetToolTip(g_testAreaTip[index]);
			g_BntestArea[index1]:Show();
 		end;
		index1 = index1+1
 	end
end

function ShowAreaBn()
	local index;
	local index1 = 1;
	AxTrace(3,3,"g_iCurAreaCount="..g_iCurAreaCount )
	for index = CurPage*PageSize+1, (CurPage+1)*PageSize do
			
 		if(index <= g_iCurAreaCount) then		
			g_BnArea[index1]:SetText(g_AreaName[index]);
			g_BnArea[index1]:SetToolTip(g_AreaTip[index]);
			g_BnArea[index1]:Show();
 		end;
		index1 = index1+1
 	end
end


-- Ë«»÷Ñ¡ÔñÒ»¸ö·þÎñÆ÷¡£
function SelectServer_ConfirmSelectLine(index)
	AxTrace(0,2,"7" )
	-- Ñ¡ÖÐÒ»¸ölogin server
	SelectServer_SelectLoginServer(index,0);

	-- È·ÈÏÑ¡ÔñÒ»¸ö·þÎñÆ÷
	SelectServer_SelectOk();

end;
-- Ë«»÷Ñ¡ÔñÒ»¸ö·þÎñÆ÷¡£
function SelectServer_LastConfirmSelectLine()

	-- Ñ¡ÖÐÒ»¸ölogin server
	SelectServer_SelectLastServer();

	-- È·ÈÏÑ¡ÔñÒ»¸ö·þÎñÆ÷
	SelectServer_SelectOk();

end;
-- Ë«»÷Ñ¡ÔñÒ»¸ö·þÎñÆ÷¡£
function Commendable_ConfirmSelectLine(index)
	-- Ñ¡ÖÐÒ»¸ölogin server
	Commendable_SelectLoginServer(index);

	-- È·ÈÏÑ¡ÔñÒ»¸ö·þÎñÆ÷
	SelectServer_SelectOk();

end;

function SelectServer_PageUp()
	CurPage = CurPage - 1
	ShowPage()
	SelectServer_SelectAreaServer(0);

end

function SelectServer_PageDown()
	CurPage = CurPage + 1
	ShowPage()
	SelectServer_SelectAreaServer(0);
end;

function ShowPage()
	--¸üÐÂ·­Ò³°´Å¥
	--UpdateUpAddDownButton();
	--hide all
	--HideAreaBn();
	--show 
	--ShowAreaBn();
end;
function UpdateUpAddDownButton()
	--SelectServer_Subarea_PageUp:Hide();
	--SelectServer_Subarea_PageDown:Hide();
	--if(g_iCurAreaCount-CurPage*PageSize>PageSize)then
	--	SelectServer_Subarea_PageDown:Show()
	--end
	--if(CurPage>0)then
	--	SelectServer_Subarea_PageUp:Show()
	--end
end;

--ÉêÇëÕÊºÅ
function SelectServer_AccountReg()
--    GameProduceLogin:StartAccountReg()
	GameProduceLogin:OpenURL( "" )
end

--ÕÊºÅ³äÖµ
function SelectServer_AccountChongZhi()
	--if(Variable:GetVariable("System_CodePage") == "1258") then
   -- GameProduceLogin:OpenURL( "http://www.tinhkiem.us/" )
  --elseif(Variable:GetVariable("System_CodePage") == "950") then --Ì¨Íå
  --  GameProduceLogin:OpenURL( "http://www.tinhkiem.us/" )
	--else
   -- GameProduceLogin:OpenURL( "http://www.tinhkiem.us/" )
 -- end
end

function SelectServer_shangyibu_click()
	GameProduceLogin:GoToCampaignDlg();
end