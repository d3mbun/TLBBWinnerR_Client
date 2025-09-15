local currentSoftKeyAim = 0;

-- µÇÂ½ÓÊ¼þÃûÁÐ±í
local TailName ={
		[0] = "@game.sohu.com",
		"@changyou.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		}
local g_bLogOnMode;

local PhoneCode ={
	"#{DHMB_080917_001}",
	"#{DHMB_080917_002}",
	"#{DHMB_080917_003}"
}

local PhoneCount = 3

local PhoneIndex = {-1,-1,-1,-1,-1}

local MiBaoDhCount = 0
local PasswdProctectTels = {"", "", "", "", ""}


-- ×¢²áPreLoadÊÂ¼þ
function LoginLogOn_PreLoad()
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- ¹Ø±Õ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- ½øÈëÓÎÏ·ºóÇå¿ÕÕÊºÅ
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	-- passport×¢²áÊ§°Ü
	this:RegisterEvent("PASSPORTREG_FAILD");
	this:RegisterEvent("LOGIN_MIBAO");
	
	-- Í¨Öª¿Í»§¶ËÏÔÊ¾ÃÜ±£ÌáÊ¾
	this:RegisterEvent("GAMELOGIN_NOTIFY_PASSWDTEL_OPENED");

end

-- ×¢²áonLoadÊÂ¼þ
function LoginLogOn_OnLoad()
		
		-- Ëæ»ú¶ÓÁÐÉèÖÃ³õÖµ
		for i=1,PhoneCount do
			PhoneIndex[i] = -1
		end 

	-- Éú³ÉÓÊÏäÕÊºÅµÄÏÂÀ­ÁÐ±í
  local TailCount = 6
	local i = 0;
	
	for i = 0, TailCount-1 do
		LogOn_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	LogOn_Region:SetCurrentSelect( 0 );
	
	-- 081014 start /* Èç¹ûÓÐÎÄ¼þÅäÖÃÃÜ±££¬Ôò¶ÁÅäÖÃ */
	-- ´ÓÅäÖÃÎÄ¼þÀïËæ»úÈ¡3¸öµç»°
	--math.randomseed(os.time() + 250);
	math.random(0,100);math.random(0,100)
	local arrIdx = {-1,-1,-1};
	local MAX_TEL_SHOWCOUNT = 3
	local iGetCount = 0
	MiBaoDhCount = GameProduceLogin:GetPasswdTelCount();
	if( MiBaoDhCount > 0 and MiBaoDhCount < 5000 ) then
		while (iGetCount < MiBaoDhCount and iGetCount < MAX_TEL_SHOWCOUNT) do
			local iTmpIdx = math.random(0,MiBaoDhCount-1);
			local bExitIdx = 0;
			for i = 1, iGetCount do
				if (arrIdx[i] == iTmpIdx) then
					bExitIdx = 1;
					break;
				end;
			end;
			if ( 1 ~= bExitIdx ) then
				iGetCount = iGetCount + 1;
				arrIdx[iGetCount] = iTmpIdx;
			end;
		end;
		if (MiBaoDhCount > MAX_TEL_SHOWCOUNT) then --¿¼ÂÇµ½ÌáÊ¾¿ò´óÐ¡£¬ ÃÜ±£µç»°ÊýÁ¿ÏÞ¶¨Îª3¸ö
			MiBaoDhCount = MAX_TEL_SHOWCOUNT
	end
		
		for i=1,MiBaoDhCount do
			local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
			PasswdProctectTels[i] = strTel;
				end

		local str = "#{DHMB_080917_004}".."#r"
		local str1=""
		for i=1,MiBaoDhCount do
			local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
			PasswdProctectTels[i] = strTel;
			--str1 = str1..strTel.."  "; -- Ë÷ÒýÏÂ±êÆðÊ¼ºÍc++Àï²»Ò»Ñù
		end
		
		 --dengxx
    for i=1,MiBaoDhCount-1 do
		  str1 = str1..PasswdProctectTels[i].." ";
	  end
	  str1 = str1..PasswdProctectTels[MiBaoDhCount];
	  str1 = str1.."#r".."#{DHMB_090205_1}"; 
		MiBaoTips_InfoWindow:SetText(str..str1);
		LogOn_MibaoSetToolTip()
		return;
	end
	-- 081014 end /**/
	
	local iNum1 =math.random(1,3); --µÚÒ»¸öËæ»úÊý×ÜÊÇ1£¬¼ÓÕâ¸öÔö¼ÓËæ»úÐÔ
	for i=1,PhoneCount do
		bFlag = 0
		while bFlag == 0 do
			local iNum =math.random(1,3);
			if 0 == RandNumExist(iNum) then
				PhoneIndex[i] = iNum
				bFlag = 1
			end
		end 
	end

	local str = "#{DHMB_080917_004}".."#r"
	local str1=""
	--dengxx  ÏÔÊ¾¿Õ¼äÌ«Ð¡£¬ÐèÒªÉÙ¿³µôÒ»¸ö¿Õ¸ñ
	for i=1,PhoneCount-1 do
		str1 = str1..PhoneCode[PhoneIndex[i]].." ";
	end
	str1 = str1..PhoneCode[PhoneIndex[PhoneCount]];
	str1 = str1.."#r".."#{DHMB_090205_1}"; 
	MiBaoTips_InfoWindow:SetText(str..str1);
end

function RandNumExist(iNum)
	for i=1,PhoneCount do
		if PhoneIndex[i] ==iNum then
			return 1
		end
	end
	return 0
end

-- OnEvent

function LoginLogOn_OnEvent(event)

AxTrace( 1,1, event );

    if( event == "PASSPORTREG_FAILD" ) then
        local FaildInfo = tonumber( arg0 )
        
        if( 1 == FaildInfo ) then  --×¢²áÊ§°Ü
            LogOn_Enroll1_Frame:Hide();
        end
        if( 2 == FaildInfo ) then  --×¢²áÒÑ¾­´æÔÚ
            LogOn_Enroll1_Frame:Hide();
        end
        if( 3 == FaildInfo ) then  --Ä³Ð©ÐÅÏ¢ÌîÐ´´íÎó,ÔÊÐíÖØÌî
            LogOn_Enroll1_Accept:Enable()
        end
        
    end

	-- ´ò¿ªÕÊºÅÊäÈë½çÃæ
 	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Phone_Protect_Check:SetCheck(0)
		
		-- ½ô¼±ÐÞ¸Ä£¬ÓÉÓÚÍâÍø»¹Ã»ÓÐ¿ªÍ¨´ËÏî·þÎñ£¬ÏÈ¹Ø±Õ Áõ¶Ü 2008.7.30
		--LogOn_Phone_Protect_Check:Disable()
		--LogOn_Phone:Disable()
		
 		AxTrace(0,1,"GAMELOGIN_OPEN_COUNT_INPUT 0")
		this:Show();
		LogOn_Enroll1_Frame:Hide();
			
		if( arg0 == "1" ) then
			LogOn_Enroll1_Frame:Show();
			Logon_Enroll_Init();
			LogOn_Enroll1_Accept:Enable()
			g_bLogOnMode = 1;
		else
			g_bLogOnMode = 0;
			LogOn_Initilize();
		end
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "LogOn_PassWord" );	
		return;
	end
		
	
	-- ¹Ø±ÕÕÊºÅÊäÈë½çÃæ
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		-- Çå¿ÕÃÜÂë.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	-- ½øÈëÓÎÏ·ºóÇå¿ÕÕÊºÅ
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- Çå¿ÕÃÜÂë.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	if(event == "LOGIN_MIBAO" and arg0 == "softkey") then
		if( g_bLogOnMode == 1 ) then
			return;
		end
		if( currentSoftKeyAim == 1 ) then
			LogOn_LogonPassWord_Active();
		else
			LogOn_LogonID_Active();
		end
		return;
	end
	
	if(event == "GAMELOGIN_NOTIFY_PASSWDTEL_OPENED") then
		LogOn_MibaoShowSystemInfo(); 
	end
end

function LogOn_Initilize()
	LogOn_LogonID_Active();
	LogOn_PassWord:SetText("");
	LogOn_ID:SetText("");
	LogOn_PassWord:Enable();
	LogOn_ID:Enable();
end
----------------------------------------------------------------------------------------------------------
--
-- ÍËµ½·þÎñÆ÷Ñ¡Ôñ½çÃæ
--
function LogOn_ExitToSelectServer()
-- ÍËµ½·þÎñÆ÷Ñ¡Ôñ½çÃæ
	GameProduceLogin:ExitToSelectServer();
	
	--this:Hide();
end


----------------------------------------------------------------------------------------------------------
--
-- ÑéÖ¤ÓÃ»§ÃûºÍÃÜÂë
--
function LogOn_CheckAccount()

	-- ÍËµ½·þÎñÆ÷Ñ¡Ôñ½çÃæ
	local strName = LogOn_ID:GetText();
	local strPassword = LogOn_PassWord:GetText();
	local strTail, nIndex = LogOn_Region:GetCurrentSelect();
	local bMiBao = 0;
	if(Variable:GetVariable("System_CodePage") == "1258") then
		-- Dummy
	else
		bMiBao = LogOn_PassWord_Protect_Check:GetCheck();
	end
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = LogOn_Region:GetText();    --ÔÝÊ±ÐÞ¸Ä,ÒòÎªGetCurrentSelectµÄbug,µ¼ÖÂÔÚÄ³Ð©²Ù×÷µÄÊ±ºò²»ÄÜÕýÈ·È¡µÃµ±Ç°µÄÑ¡Ôñ,¶ø½çÃæµ×²ãÕýÔÚÐÞ¸ÄÖÐ,ÔÝÊ±ÓÃ´Ëº¯Êý½â¾öÓÃ»§Ãûºó×ºÎª¿ÕµÄÎÊÌâBugID:15422
	
	if(Variable:GetVariable("System_CodePage") == "1258") then
		strTail = "";
	end
	
		if(Variable:GetVariable("System_CodePage") == "950") then
		strTail = "";
	end

	
	AxTrace( 0,0, "Ki¬m chÑng tên account"..strName.." "..strPassword);
	if( strName =="" ) then
		AxTrace( 0,0, "Không có tài khoän");
		return;
	end
	if( strPassword == "" ) then
		AxTrace( 0,0, "Không có m§t kh¦u");
		return;
	end
	
--	GameProduceLogin:CheckAccount(strName..strTail, strPassword,bMiBao);
	GameProduceLogin:CheckAccount(strTail, bMiBao);
	if(bMiBao == 0) then
		--ÕÊºÅÃÜÂëeditboxÊ§È¥ÊäÈë½¹µã
		LogOn_Frame_OnHiden();
	end
	
	-- Çå¿ÕÃÜÂë.
	--LogOn_PassWord:SetText("");
end;

--ÉêÇëÕÊºÅ
function LogOn_AccountReg()
    -- GameProduceLogin:StartAccountReg()
	GameProduceLogin:OpenURL( "" )
end
----------------------------------------------------------------------------------------------------------
--
-- idÊäÈë¿òÊ§È¥½¹µã
--
function Logon_ID_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonPassWord_Active();
	end
end

function Logon_LogOn_ID_Return()
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest"))) then
		LogOn_LogonPassWord_Active();
	end
end

----------------------------------------------------------------------------------------------------------
--
-- ÃÜÂëÊäÈë¿òÊ§È¥½¹µã
--
function Logon_Password_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonID_Active();
	end
end

function Logon_Password_Return()
	

	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest"))) then
		LogOn_CheckAccount();
	end
end

----------------------------------------------------------------------------------------------------------
--
-- ÕÊºÅÊäÈë
--
function LogOn_ID_MouseEnter()

	LogOn_Info:SetText("Nh§p s¯ tài khoän vào ðây");     --ÕÊºÅ  to  ÕËºÅ

end


----------------------------------------------------------------------------------------------------------
--
-- ÃÜÂëÊäÈë¿òÊ§È¥½¹µã
--
function LogOn_MouseLeave()

	LogOn_Info:SetText("");
end


function LogOn_PassWord_MouseEnter()

	LogOn_Info:SetText("Nh§p m§t kh¦u cüa các hÕ tÕi ðây");
end;


------------------------------------------------------------------------------------------------------
--
-- Ä£Äâ¼üÅÌ
--
function LogOn_KeyBoard()
	ToggleWindow( "SoftKeyBoard" );
	SetSoftKeyAim( "LogOn_PassWord" );	
end


function LogOn_Keyboard_MouseEnter()

	LogOn_Info:SetText("Online · n½i công cµng, ð¬ ðäm bäo an toàn, ð« ngh¸ các hÕ sØ døng");  --ÕÊºÅ  to  ÕËºÅ
end


function LogOn_LogOnGame_MouseEnter()

	LogOn_Info:SetText("Nh¤n nút này ð¬ vào trò ch½i");
end;

function LogOn_Payment_MouseEnter()

	LogOn_Info:SetText("TÕo tài khoän m¾i");  --ÕÊºÅ  to  ÕËºÅ
end

function LogOn_RequisitionID_MouseEnter()

	LogOn_Info:SetText("Ðång ký tài khoän m¾i");	--ÕÊºÅ  to  ÕËºÅ
end;

function LogOn_Author_MouseEnter()

	LogOn_Info:SetText("Ki¬m tra xem xét tin tÑc trò ch½i khai thác ðoàn ðµi");
end;

function LogOn_Last_MouseEnter()

	LogOn_Info:SetText("Ch÷n lÕi máy chü");
end;

function LogOn_LogonID_Active()
	
	SetSoftKeyAim( "LogOn_ID" );	
	LogOn_ID:SetProperty("DefaultEditBox", "True");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 0;
end

function LogOn_LogonPassWord_Active()
	
	SetSoftKeyAim( "LogOn_PassWord" );	
	LogOn_PassWord:SetProperty("DefaultEditBox", "True");
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 1;
end

function LogOn_Frame_OnHiden()
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
end

function Logon_LogOn_Soft_Return()
	if( g_bLogOnMode == 1 ) then
		return;
	end
	if( currentSoftKeyAim == 1 ) then
		
		LogOn_LogonID_Active();
	else
		
		LogOn_LogonPassWord_Active();
	end
	
end

function LogOn_Enroll1_OK(iok)
	local strName 			= LogOn_Enroll1_Name:GetText();
	local strPassword 	= LogOn_Enroll1_Edit1:GetText();
	local strPassEx 		= LogOn_Enroll1_Edit2:GetText();
	local strSupPass  	= LogOn_Enroll1_Edit3:GetText();
	local strSupPassex 	= LogOn_Enroll1_Edit4:GetText();
	local strEmail      = LogOn_Enroll1_Edit6:GetText();
	
	if(iok == 1) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,1, strEmail );
	elseif (iok == 0) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,0, strEmail );
	end
	
	LogOn_Enroll1_Accept:Disable()
	
end
function Logon_Enroll_Init()
	local strName = LogOn_ID:GetText();
	LogOn_Enroll1_Name:SetText( strName );
	LogOn_Enroll1_Edit1:SetText( "");
	LogOn_Enroll1_Edit2:SetText( "" );
	LogOn_Enroll1_Edit3:SetText( "" );
	LogOn_Enroll1_Edit4:SetText( "" );
	LogOn_Enroll1_Edit6:SetText( "" );
	LogOn_PassWord:Disable();
	LogOn_ID:Disable();

end
function LogOn_Enroll1_Cancel()
	g_bLogOnMode = 0;
	LogOn_Enroll1_Frame:Hide();
	LogOn_PassWord:Enable();
	LogOn_ID:Enable();
	
	--·¢ËÍÄ¬ÈÏÃÜÂë
	GameProduceLogin:PassportButNotReg();
	
end

function LogOn_AccountChongZhi()
    GameProduceLogin:OpenURL( "" )
end

function Logon_Enroll_PressTable( iIndex )
	
	if( 1 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit2" );
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 2 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit3" );
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 3 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit4" );
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 4 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit6" );
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 5 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit1" );
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	
end

function LogOn_Show_MibaoPage()
    GameProduceLogin:OpenURL( "" )
end

function PassWordProtectCheckClicked()
	local pwCheck = LogOn_PassWord_Protect_Check:GetCheck();
	local phCheck = LogOn_Phone_Protect_Check:GetCheck();
	if( pwCheck == 1 and phCheck == 1 ) then
		AxTrace( 1,1, "pwCheck == 1 and phCheck == 1");
		LogOn_PassWord_Protect_Check:SetCheck(1)
		LogOn_Phone_Protect_Check:SetCheck(0)
		
	elseif( pwCheck == 1 and phCheck == 0 ) then
		AxTrace( 1,1, "pwCheck == 1 and phCheck == 0");
		LogOn_PassWord_Protect_Check:SetCheck(1)
		LogOn_Phone_Protect_Check:SetCheck(0)
			
	elseif( pwCheck == 0 and phCheck == 1 ) then
		AxTrace( 1,1, "pwCheck == 0 and phCheck == 1");
		LogOn_PassWord_Protect_Check:SetCheck(1)
		LogOn_Phone_Protect_Check:SetCheck(0)
		
	elseif( pwCheck == 0 and phCheck == 0 ) then
		AxTrace( 1,1, "pwCheck == 0 and phCheck == 0");
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Phone_Protect_Check:SetCheck(0)
	end
end

function MibaokaCheckClicked()
	local pwCheck = LogOn_PassWord_Protect_Check:GetCheck();
	local phCheck = LogOn_Phone_Protect_Check:GetCheck();
	AxTrace( 1,1, "onMibaoCheckBoxChangeSelect: "..phCheck.." "..pwCheck);
	if( pwCheck == 1 and phCheck == 1 ) then
		AxTrace( 1,1, "pwCheck == 1 and phCheck == 1");
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Phone_Protect_Check:SetCheck(1)
		
	elseif( pwCheck == 0 and phCheck == 1 ) then
		AxTrace( 1,1, "pwCheck == 0 and phCheck == 1");
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Phone_Protect_Check:SetCheck(1)
			
	elseif( pwCheck == 1 and phCheck == 0 ) then
		AxTrace( 1,1, "pwCheck == 1 and phCheck == 0");
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Phone_Protect_Check:SetCheck(1)
		
	elseif( pwCheck == 0 and phCheck == 0 ) then
		AxTrace( 1,1, "pwCheck == 0 and phCheck == 0");
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Phone_Protect_Check:SetCheck(0)
	end
end

function LogOn_MibaoSetToolTip()
	local strStart = "#{DHMB_081014_001_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_001_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount and i ~= 1) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;
		
	end
	strTmp = strTmp..strEnd
	-- LogOn_Phone_Protect_Text:SetProperty("Tooltip", strTmp); --Õâ¸ö²»ÄÜ×ªÒå
	LogOn_Phone_Protect_Text:SetToolTip(strTmp);
end

function LogOn_MibaoShowSystemInfo()
	local strStart = "#{DHMB_081014_003_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_003_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount and i ~= 1) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;
		
	end
	strTmp = strTmp..strEnd
	GameProduceLogin:GameLoginShowSystemInfo(strTmp);
end