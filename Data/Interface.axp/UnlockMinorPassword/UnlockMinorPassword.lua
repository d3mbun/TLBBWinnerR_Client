g_InputPassword_CurrectOperate = 0;  --1Ϊpk״̬�л���Ҫ�����봰��. 2Ϊ������ʱ����Ҫ���������
g_InputPassword_PKModeWant = 0;  --1Ϊpk״̬�л���Ҫ�����봰��.

function UnlockMinorPassword_PreLoad()
	
	-- �򿪽���
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
		
		UnLockMinorPassword_Frame_Title:SetText( "#{UITEXT_INPUTMINORPW}" )   --( "�����������" )
		UnLockMinorPassword_WarningText:SetText( "#{UITEXT_PKNEEDPW}" )   --( "�л�PKģʽ��ʱ����Ҫ�����������" )
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
		
		UnLockMinorPassword_Frame_Title:SetText( "#{UITEXT_INPUTMINORPW}" )   --( "�����������" )
		UnLockMinorPassword_WarningText:SetText( "#{UITEXT_BANKNEEDPW}" )   --( "��������Ҫ�����������" )
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
-- �޸����롣
--
function UnLockMinorPassword_ChangePassword_OnClick()

	-- �򿪸�������Ի���
	OpenChangeMinorPasswordDlg();
	UnLockMinorPassword_Close();
end


----------------------------------------------------------------------------------------------------
--
-- ���ȷ����ť��
--
function UnLockMinorPassword_OK()
    if( 2 == g_InputPassword_CurrectOperate ) then
        local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
        local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("���벻������4���ַ���");
			return;
		end
		
		BankAcquireListWithPW( strPassword )
		
		--Player:ChangePVPModeWithPassword( g_InputPassword_PKModeWant, strPassword )
        -- ���ش���.
	   UnLockMinorPassword_Close();
        return
    end
    
    if( 1 == g_InputPassword_CurrectOperate ) then
        
        local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
        local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("���벻������4���ַ���");
			return;
		end
		
		Player:ChangePVPModeWithPassword( g_InputPassword_PKModeWant, strPassword )
        -- ���ش���.
	     UnLockMinorPassword_Close();
        return
    end

	local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
	local iLen = string.len(strPassword);
	if(iLen < 4) then
	
		ShowSystemTipInfo("M�t kh�u kh�ng ���c �t h�n 4 k� t�!");
		return;
	end;
	
	-- �������롣
	UnLockMinorPassword(strPassword);
	
	-- ���ش���.
	UnLockMinorPassword_Close();

end;


----------------------------------------------------------------------------------------------------
--
-- ǿ�ƽ��
--
function UnLockMinorPassword_ForceUnLock_OnClick()

	-- ǿ�ƽӴ�����
	ForceUnLockMinorPassword();
	
	-- ���ش���.
	UnLockMinorPassword_Close();
end;



----------------------------------------------------------------------------------------------------
--
-- �˳�
--
function UnLockMinorPassword_Cancel()

	-- ���������ð�ť
	--OpenSetMinorPasswordDlg();
	
	-- ���ش���.
	UnLockMinorPassword_Close();
		
end;

function UnLockMinorPassword_Frame_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end

function UnLockMinorPassword_Close()
		-- ���ش���.
	
	this:Hide();
end