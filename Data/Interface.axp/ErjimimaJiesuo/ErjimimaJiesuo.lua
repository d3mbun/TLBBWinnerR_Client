local g_CurrectOperate = 0;  --1Ϊpk״̬�л���Ҫ�����봰��. 2Ϊ������ʱ����Ҫ���������
local g_PKModeWant = 0;  --1Ϊpk״̬�л���Ҫ�����봰��.


function ErjimimaJiesuo_PreLoad()
	-- �򿪽���
	this:RegisterEvent("MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG");
	this:RegisterEvent("OPENINPUTPASSWORD_PKVERIFY");
	this:RegisterEvent("OPENINPUTPASSWORD_BANKVERIFY");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end


function ErjimimaJiesuo_OnLoad()


end

function ErjimimaJiesuo_OnEvent( event )
	if(event == "MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG") then
		g_CurrectOperate = 0
		ErjimimaJiesuo_Show()
	end	
	
	if(event == "OPENINPUTPASSWORD_PKVERIFY") then
		g_PKModeWant = tonumber(arg0);
		g_CurrectOperate = 1
		ErjimimaJiesuo_Show()
	end	
	
	if( event == "OPENINPUTPASSWORD_BANKVERIFY" ) then
		g_CurrectOperate = 2
		ErjimimaJiesuo_Show()
	end

	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ErjimimaJiesuo_Close();
	end
end

function ErjimimaJiesuo_Show()
		CloseWindow("SafeTime" , true)
		CloseWindow("ErjimimaXiugai", true)
		CloseWindow("ErjimimaShezhi", true)
		CloseWindow("Fangdao", true)
		CloseWindow("DianhuaMibao", true)
		
		local safeTimePos = Variable:GetVariable("SafeTimePos");
		if(safeTimePos ~= nil) then
			ErjimimaJiesuo_Frame:SetProperty("UnifiedPosition", safeTimePos);
		end
		this:Show();
		ErjimimaJiesuo_Jiesuo:SetText( "" );
		ErjimimaJiesuo_SoftKey:SetAimEditBox( "ErjimimaJiesuo_Jiesuo" );

		ErjimimaJiesuo_AQtime:SetCheck(0)
		ErjimimaJiesuo_Erjimima:SetCheck(1)
		ErjimimaJiesuo_TelMibao:SetCheck(0)
end

function ErjimimaJiesuo_Jiesuo_OnActive()
	ErjimimaJiesuo_SoftKey:SetAimEditBox( "ErjimimaJiesuo_Jiesuo" );
end

function ErjimimaJiesuo_AQtime_Clicked()
	ErjimimaJiesuo_Close();
	OpenDlg4ProtectTime();
end


function ErjimimaJiesuo_Close()
	Variable:SetVariable("SafeTimePos", ErjimimaJiesuo_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function ErjimimaJiesuo_OnHide()
	Variable:SetVariable("SafeTimePos", ErjimimaJiesuo_Frame:GetProperty("UnifiedPosition"), 1);
end

function ErjimimaJiesuo_gotoWeb()
	GameProduceLogin:OpenURL(GetWeblink("WEB_CYOU_INDEX"))
end

function ErjimimaJiesuo_OK_Click()
	if( 2 == g_CurrectOperate ) then
		local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
		local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("���벻������4���ַ���");
			return;
		end
		BankAcquireListWithPW( strPassword )
		-- ���ش���.
		ErjimimaJiesuo_Close();
	        return
	end
    
	if( 1 == g_CurrectOperate ) then
		local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
		local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("���벻������4���ַ���");
			return;
		end
		Player:ChangePVPModeWithPassword( g_PKModeWant, strPassword )
	        -- ���ش���.
		ErjimimaJiesuo_Close();
		return
	end

	local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
	local iLen = string.len(strPassword);
	if(iLen < 4) then
	
		ShowSystemTipInfo("M�t kh�u kh�ng ���c �t h�n 4 k� t�!");
		return;
	end;
	-- �������롣
	UnLockMinorPassword(strPassword);
	-- ���ش���.
	ErjimimaJiesuo_Close();
end

--ǿ�ƽ������
function ErjimimaJiesuo_Jiechu()
	-- ǿ�ƽӴ�����
	ForceUnLockMinorPassword();
	
	-- ���ش���.
	ErjimimaJiesuo_Close();
end

function ErjimimaJiesuo_TelMibao_Clicked()
	ErjimimaJiesuo_Close();
	OpenDianhuaMibao();
end