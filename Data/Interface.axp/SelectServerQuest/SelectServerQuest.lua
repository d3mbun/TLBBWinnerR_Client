

------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿Çø
--
--
local g_iYesNoType = -1;	-- yes-no ¶Ô»°¿òÀàĞÍ
													-- -1 -- ÆÕÍ¨ĞÅÏ¢ÌáÊ¾
													-- 0 - ÍË³öÓÎÏ·
													-- 1 - É¾³ı½ÇÉ«
													-- 2 - ¸ü»»ÕÊºÅ
													-- 3 - ¶Ï¿ªÍøÂç
													-- 4 - È·ÈÏÊÇ·ñÉ¾³ı10¼¶ÒÔÉÏÍæ¼Ò
													-- 5 - 7ÌìÄÚÌáĞÑÉ¾³ı10¼¶ÒÔÉÏÍæ¼Ò
													-- 6 - 7Ììºó£¬14ÌìÄÚÌáĞÑÉ¾³ı10¼¶ÒÔÉÏÍæ¼Ò
													-- 7 - ÊÇ·ñÉ¾³ı10¼¶ÒÔÏÂÍæ¼Ò
													-- 8 É¾³ıÍæ¼Ò
													-- 9 ÊÇ·ñ×¢²á
local g_strMessageData;

local g_bagIndex = -1
-- ×¢²áonLoadÊÂ¼ş
function LoginSelectServerQuest_PreLoad()
	
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO");
	
	-- ¹Ø±Õ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_SYSTEM_INFO");
	
	
	-- µã»÷È·¶¨°´Å¥¹Ø±ÕÍøÂç
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET");   

	-- ÏÔÊ¾²»´ø°´Å¥µÄĞÅÏ¢
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON");   
	-- ÏÔÊ¾yes-noĞÅÏ¢
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_YESNO");   
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_OK");   
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CANCEL"); 
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CLOSE"); 
	this:RegisterEvent("UI_COMMAND");

end

function LoginSelectServerQuest_OnLoad()
	
	-- ÉèÖÃ×ÜÊÇÔÚ×îÉÏ²ãÏÔÊ¾
	SelectServerQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");
	
	-- 
	

end
function LoginSelectUpdateRect()
	local nWidth, nHeight = SelectServerQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	SelectServerQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	AxTrace( 0,0, "LastWindowSize ="..tostring( nWindowWidth )..","..tostring(nWindowHeight) );
	--SelectServerQuest_Frame_sub:SetWindowSize( nWindowWidth, nWindowHeight );
end

local TimerArg = "";
local g_QuitType = 0;
local g_bIsQuitMsgBox = 0;
-- OnEvent
function LoginSelectServerQuest_OnEvent(event)
		g_bIsQuitMsgBox = 0;
    SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )

	--AxTrace( 0,0, "get event");
	SelectServerQuest_Button2:Hide();
	SelectServerQuest_Button1:Hide();
	SelectServerQuest_Time_Text : Hide();
	SelectServerQuest_InfoWindow:Show();
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO" ) then
	
		g_iYesNoType = -1;
		--AxTrace( 0,0, "ÏÔÊ¾ÏµÍ³ĞÅÏ¢");
		if( arg1 ~= "WAITFORQUIT" ) then
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
		end
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ğóng");
		SelectServerQuest_Button1:Enable()
		
		if( arg1 == "USERONLINE" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif(arg1 == "USERFROMMAINPRO") then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Hide();
		    SelectServerQuest_Button2:Hide();
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "MIBAOERROR" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(60));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "WAITFORQUIT" ) then
		    if(arg3~=nil and tonumber(arg3)~=nil)then
			if(tonumber(arg3)>0)then
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(10));
				SelectServerQuest_InfoWindow:SetText("Sau 10 giây s¨ thoát khöi trò ch½i");
				LoginSelectUpdateRect();
				
			else
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
				SelectServerQuest_InfoWindow:SetText("Sau 3 giây s¨ thoát khöi trò ch½i!");
				LoginSelectUpdateRect();
			end
		    else
			 SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
			 SelectServerQuest_InfoWindow:SetText("Sau 3 giây s¨ thoát khöi trò ch½i!");
			LoginSelectUpdateRect();
		    end
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:SetText("HuÖ");
		    SelectServerQuest_Button1:Show();
		    SelectServerQuest_Button1:Enable()
		    TimerArg = arg1;
		    g_QuitType = tonumber(arg2);
		    g_bIsQuitMsgBox = 1;
		    arg1 = nil;
		else
		    TimerArg = nil;
		    arg1 = nil;
		    SelectServerQuest_Time_Text : Hide()    
		end
				
		this:Show();
		return;
	end
	
	
	
	
	if( event == "GAMELOGIN_CLOSE_SYSTEM_INFO") then
		
		g_iYesNoType = -1;
		this:Hide();
		return;
	end
	
	--AxTrace( 0,0, "event yes no");
	if( event == "GAMELOGIN_SYSTEM_INFO_YESNO") then
		
		if( tonumber(arg1) == 11 ) then
			GameProduceLogin:CheckAccountNoMibao();
		else 
			--AxTrace( 0,0, "ÏÔÊ¾yes no");
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
			g_iYesNoType = tonumber(arg1);
		
			SelectServerQuest_Button1:SetText("Duy®t");
			SelectServerQuest_Button2:SetText("HuÖ");
			SelectServerQuest_Button2:Show();
			SelectServerQuest_Button1:Show();
			this:Show();
			return;
		end
	end
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON" ) then
	
	    if( nil ~= arg1 ) then
	        local strArg = tostring( arg1 )
			if( strArg == "CharSel_EnterGame" ) then
			--if( strArg == "CharSel_EnterGam" ) then
				SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.900000,-118.000000}}" )
			end
		arg1 = nil;
	    end
	
		g_iYesNoType = -1;--tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		this:Show();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_Button2:Hide();
		return;


	end
	if( event == "GAMELOGIN_SYSTEM_INFO_OK" ) then
		AxTrace( 0,0,"GAMELOGIN_SYSTEM_INFO_OK" );
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		if g_iYesNoType == 0 then
			SelectServerQuest_Button1:SetText("Ğóng");
		else
			SelectServerQuest_Button1:SetText("Duy®t");
		end
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CANCEL" ) then
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("HuÖ");
		this:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CLOSE" ) then
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("Ğóng");
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	
	
	
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET") then
		
		--AxTrace( 0,0, "ĞèÒª¹Ø±ÕÍøÂç.");
		g_iYesNoType = 3;
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ğóng");
		this:Show();
		return;
	end
	
	-- ÑªÔ¡Éñ±ø¡ª¡ªÉñÆ÷ÖıÔì
	if ( event == "UI_COMMAND" and tonumber(arg0) == 13906) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263#{XYSB_080925_001}");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ğóng");
		SelectServerQuest_Button1:Enable()
		
		this:Show();
	end
	
	-- ÑªÔ¡Éñ±ø¡ª¡ªÉñÆ÷ÖØÖı
	if ( event == "UI_COMMAND" and tonumber(arg0) == 12032203) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263 Sau khi tiªp tøc rèn luy®n th¥n khí s¨ b¸ hüy di®t, nhæng bäo thÕch ğã khäm nÕm ho£c cß¶ng hóa lên Th¥n khí cûng s¨ m¤t theo.");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ğóng");
		SelectServerQuest_Button1:Enable()
		
		this:Show();
	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 300077) then
		g_iYesNoType = 12;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_21}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,toMaxLevel)	
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_28}%d#{ZSKSSJ_081113_29}%d#{ZSKSSJ_081113_30}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,petLevel ,petLevel + levelCanUp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		end
		
		LoginSelectUpdateRect();
		
		SelectServerQuest_Button1:SetText("Duy®t");
		SelectServerQuest_Button2:SetText("HuÖ");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		
	end
	
	
	
end


-------------------------------------------------------------
--
-- °´Å¥1 µã»÷ÊÂ¼ş
--
function SelectServerQuest_Bn1Click()
-- 0 - ÍË³öÓÎÏ·
-- 4 - È·ÈÏÊÇ·ñÉ¾³ı10¼¶ÒÔÉÏÍæ¼Ò
-- 5 - 7ÌìÄÚÌáĞÑÉ¾³ı10¼¶ÒÔÉÏÍæ¼Ò
-- 6 - 7Ììºó£¬14ÌìÄÚÌáĞÑÉ¾³ı10¼¶ÒÔÉÏÍæ¼Ò
-- 7 - ÊÇ·ñÉ¾³ı10¼¶ÒÔÏÂÍæ¼Ò
-- 8 - ´óÓÚ10¼¶µÃÌáÊ¾
	if( -1 == g_iYesNoType and 1 == g_bIsQuitMsgBox) then
		CancelQuitWait(); --È¡ÏûÍË³ö
	end
	if(0 == g_iYesNoType) then		
		QuitApplication("quit");
	elseif(1 == g_iYesNoType) then		
	elseif(2==g_iYesNoType) then
		GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
	elseif( 3 == g_iYesNoType ) then
		GameProduceLogin:CloseNetConnect();
	elseif( 4 == g_iYesNoType ) then
			local strInfo;
		  strInfo ="Nhân v§t cüa các hÕ không th¬ xóa ngay ğßşc, xin 3 ngày sau trong vòng 14 ngày ğång nh§p vào trò ch½i, ğªn LÕc Dß½ng (268, 46) tìm Quan Hán Th÷ ho£c ĞÕi Lı (80, 136) tìm Chu Xß½ng xác nh§n, là có th¬ xóa. Lúc xác nh§n xóa nhân v§t không th¬ có bang hµi, kªt hôn, kªt bái, m· ti®m trÕng thái, nªu không vi®c xóa nhân v§t s¨ b¸ hüy. Quá 14 ngày không xác nh§n thao tác xóa nhân v§t s¨ vô hi®u."
		  GameProduceLogin:ShowMessageBox( strInfo, "OK", "8" );--qds Ã»ÓĞ¸ø³ö¶Ô»°¿òÔì³É²»ÄÜÉ¾³ı½ÇÉ«
		  --strInfo ="ÄúµÄ½ÇÉ«²»ÄÜÂíÉÏÉ¾³ı£¬ÇëÔÚ3ÌìÒÔºó14ÌìÒÔÄÚµÇÂ¼ÓÎÏ·£¬µ½ÂåÑô£¨268£¬46£©ÕÒµ½¹ØººÊÙ»òÕßµ½´óÀí£¨80£¬136£©ÕÒµ½ÖÜ²ÖÈ·ÈÏ£¬¼´¿ÉÓÀ¾ÃÉ¾³ı¡£È·ÈÏÉ¾³ıÊ±½ÇÉ«²»ÄÜ´¦ÓÚÓĞ°ï»á¡¢½á»é¡¢½á°İ¡¢Ê¦Í½¡¢¿ªµê×´Ì¬£¬·ñÔòÉ¾³ı½«±»È¡Ïû¡£³¬¹ı14ÌìÃ»ÓĞÔÙ´ÎÉ¾³ıÔòÉ¾³ı²Ù×÷ÎŞĞ§¡£"
	elseif( 5 == g_iYesNoType ) then
	elseif( 6 == g_iYesNoType ) then
	elseif( 7 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 8 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:LoginPlayer( 1 );
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "Phäi chång kích hoÕt_gõ nút OK");
	elseif(11 == g_iYesNoType) then
		GameProduceLogin:CheckAccountNoMibao();
	elseif(12 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300077 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end;
	
	this:Hide();
end


-------------------------------------------------------------
--
-- °´Å¥2 µã»÷ÊÂ¼ş
--
function SelectServerQuest_Bn2Click()

	if(3 == g_iYesNoType) then
		GameProduceLogin:CloseNetConnect();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:PassportButNotReg();
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "Phäi chång kích hoÕt_gõ nút NO");	
	end
	
	this:Hide();
end

function SelectServerQuest_TimeOut()
  if( TimerArg == "USERONLINE" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "MIBAOERROR" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "USERFROMMAINPRO") then
	this:Hide();
	TimerArg = nil
  elseif(TimerArg == "WAITFORQUIT") then
	if(tonumber(g_QuitType)==0)then
		QuitApplication("quit");
	else
		AskRet2SelServer();
	end
	this:Hide();
	TimerArg = nil
	g_QuitType = nil
   end
end

function SelectServerQuest_Frame_OnHiden()
	DataPool:SetCanUseHotKey(1);
end