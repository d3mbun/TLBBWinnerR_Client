g_InputPassword_CurrectOperate = 0;  --1Îªpk×´Ì¬ÇÐ»»ÐèÒªµÄÊäÈë´°¿Ú. 2Îª´ò¿ªÒøÐÐÊ±ºòÐèÒªµÄÊä³ö´°¿Ú
g_InputPassword_PKModeWant = 0;  --1Îªpk×´Ì¬ÇÐ»»ÐèÒªµÄÊäÈë´°¿Ú.

function UnlockMinorPassword_PreLoad()
	
	-- ´ò¿ª½çÃæ
--	this:RegisterEvent("MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG");
--	this:RegisterEvent("OPENINPUTPASSWORD_PKVERIFY");
--	this:RegisterEvent("OPENINPUTPASSWORD_BANKVERIFY");
--	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function UnlockMinorPassword_OnLoad()
end



--===============================================
-- OnEvent()
--===============================================
function UnlockMinorPassword_OnEvent(event)

	if(event == "MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG") then
		this:Show();
		UnLockMinorPassword_MinorPasswordEditBox:SetText( "" );
		UnLockMinorPassword_MinorPasswordEditBox:SetProperty("DefaultEditBox", "True");
		
		g_InputPassword_CurrectOperate = 0
		UnLockMinorPassword_Frame_Title:SetText( "#{INTERFACE_XML_43}" )
		UnLockMinorPassword_WarningText:SetText( "#{INTERFACE_XML_0}" )
		UnLockMinorPassword_ForceUnLock:Show()
		UnLockMinorPassword_ChangeMinorPassword:Show()
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "UnLockMinorPassword_MinorPasswordEditBox" );
	end	
	
	if(event == "OPENINPUTPASSWORD_PKVERIFY") then
		g_InputPassword_PKModeWant = tonumber(arg0);
		UnLockMinorPassword_MinorPasswordEditBox:SetText( "" );
		UnLockMinorPassword_MinorPasswordEditBox:SetProperty("DefaultEditBox", "True");
		UnLockMinorPassword_ForceUnLock:Hide()
		UnLockMinorPassword_ChangeMinorPassword:Hide()
		g_InputPassword_CurrectOperate = 1
		
		UnLockMinorPassword_Frame_Title:SetText( "#{UITEXT_INPUTMINORPW}" )   --( "ÊäÈë¶þ¼¶ÃÜÂë" )
		UnLockMinorPassword_WarningText:SetText( "#{UITEXT_PKNEEDPW}" )   --( "ÇÐ»»PKÄ£Ê½µÄÊ±ºòÐèÒªÊäÈë¶þ¼¶ÃÜÂë" )
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "UnLockMinorPassword_MinorPasswordEditBox" );
		
		this:Show();
	end	
	
	if( event == "OPENINPUTPASSWORD_BANKVERIFY" ) then
		UnLockMinorPassword_MinorPasswordEditBox:SetText( "" );
		UnLockMinorPassword_MinorPasswordEditBox:SetProperty("DefaultEditBox", "True");
		UnLockMinorPassword_ForceUnLock:Hide()
		UnLockMinorPassword_ChangeMinorPassword:Hide()
		g_InputPassword_CurrectOperate = 2
		
		UnLockMinorPassword_Frame_Title:SetText( "#{UITEXT_INPUTMINORPW}" )   --( "ÊäÈë¶þ¼¶ÃÜÂë" )
		UnLockMinorPassword_WarningText:SetText( "#{UITEXT_BANKNEEDPW}" )   --( "´ò¿ªÒøÐÐÐèÒªÊäÈë¶þ¼¶ÃÜÂë" )
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "UnLockMinorPassword_MinorPasswordEditBox" );
		
		this:Show();
	end
	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		UnLockMinorPassword_Close();
	end
				
end	
		

----------------------------------------------------------------------------------------------------
--
-- ÐÞ¸ÄÃÜÂë¡£
--
function UnLockMinorPassword_ChangePassword_OnClick()

	-- ´ò¿ª¸ü¸ÄÃÜÂë¶Ô»°¿ò¡£
	OpenChangeMinorPasswordDlg();
	UnLockMinorPassword_Close();
end


----------------------------------------------------------------------------------------------------
--
-- µã»÷È·¶¨°´Å¥¡£
--
function UnLockMinorPassword_OK()
    if( 2 == g_InputPassword_CurrectOperate ) then
        local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
        local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("ÃÜÂë²»ÄÜÉÙÓÚ4¸ö×Ö·û£¡");
			return;
		end
		
		BankAcquireListWithPW( strPassword )
		
		--Player:ChangePVPModeWithPassword( g_InputPassword_PKModeWant, strPassword )
        -- Òþ²Ø´°¿Ú.
	   UnLockMinorPassword_Close();
        return
    end
    
    if( 1 == g_InputPassword_CurrectOperate ) then
        
        local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
        local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("ÃÜÂë²»ÄÜÉÙÓÚ4¸ö×Ö·û£¡");
			return;
		end
		
		Player:ChangePVPModeWithPassword( g_InputPassword_PKModeWant, strPassword )
        -- Òþ²Ø´°¿Ú.
	     UnLockMinorPassword_Close();
        return
    end

	local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
	local iLen = string.len(strPassword);
	if(iLen < 4) then
	
		ShowSystemTipInfo("M§t kh¦u không ðßþc ít h½n 4 ký tñ!");
		return;
	end;
	
	-- ½âËøÃÜÂë¡£
	UnLockMinorPassword(strPassword);
	
	-- Òþ²Ø´°¿Ú.
	UnLockMinorPassword_Close();

end;


----------------------------------------------------------------------------------------------------
--
-- Ç¿ÖÆ½â³ý
--
function UnLockMinorPassword_ForceUnLock_OnClick()

	-- Ç¿ÖÆ½Ó´¥ÃÜÂë
	ForceUnLockMinorPassword();
	
	-- Òþ²Ø´°¿Ú.
	UnLockMinorPassword_Close();
end;



----------------------------------------------------------------------------------------------------
--
-- ÍË³ö
--
function UnLockMinorPassword_Cancel()

	-- ´ò¿ªÃÜÂëÉèÖÃ°´Å¥
	--OpenSetMinorPasswordDlg();
	
	-- Òþ²Ø´°¿Ú.
	UnLockMinorPassword_Close();
		
end;

function UnLockMinorPassword_Frame_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end

function UnLockMinorPassword_Close()
		-- Òþ²Ø´°¿Ú.
	
	this:Hide();
end