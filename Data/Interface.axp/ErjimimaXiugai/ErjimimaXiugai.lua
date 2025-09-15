function ErjimimaXiugai_PreLoad()
	-- �򿪽���
	this:RegisterEvent("MINORPASSWORD_OPEN_CHANGE");
	this:RegisterEvent("MINORPASSWORD_CLEAR_PASSWORD_DLG");

end


function ErjimimaXiugai_OnLoad()


end

function ErjimimaXiugai_OnEvent( event )
	if(event == "MINORPASSWORD_OPEN_CHANGE") then

		if( this:IsVisible() ) then
			return;
		end
		
		local safeTimePos = Variable:GetVariable("SafeTimePos");
		if(safeTimePos ~= nil) then
			ErjimimaXiugai_Frame:SetProperty("UnifiedPosition", safeTimePos);
		end

		CloseWindow("SafeTime", true)
		CloseWindow("ErjimimaShezhi", true)
		CloseWindow("ErjimimaJiesuo", true)
		CloseWindow("Fangdao", true)
		CloseWindow("DianhuaMibao", true)

		this:Show();
		ErjimimaXiugai_Before:SetText( "" );
		ErjimimaXiugai_After:SetText( "" );
		ErjimimaXiugai_Queren:SetText( "" );
		ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_Before" );
		ErjimimaXiugai_AQtime:SetCheck(0);
		ErjimimaXiugai_Erjimima:SetCheck(1)
		ErjimimaXiugai_TelMibao:SetCheck(0);

	elseif(event == "MINORPASSWORD_CLEAR_PASSWORD_DLG") then 
	
		ErjimimaXiugai_Before:SetText( "" );
		ErjimimaXiugai_After:SetText( "" );
		ErjimimaXiugai_Queren:SetText( "" );
	end

end

function ErjimimaXiugai_Before_OnActive()
	ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_Before" );
end
function ErjimimaXiugai_After_OnActive()
	ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_After" );
end
function ErjimimaXiugai_Queren_OnActive()
	ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_Queren" );
end

function ErjimimaXiugai_AQtime_Clicked()
	ErjimimaXiugai_Close();
	OpenDlg4ProtectTime();
end

function ErjimimaXiugai_Close()
	Variable:SetVariable("SafeTimePos", ErjimimaXiugai_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function ErjimimaXiugai_OnHide()
	Variable:SetVariable("SafeTimePos",ErjimimaXiugai_Frame:GetProperty("UnifiedPosition"), 1);
end

function ErjimimaXiugai_OK_Click()
	-- �ɵ�����
	local strPasswordOld = ErjimimaXiugai_Before:GetText();
	
	-- �µ����롣
	local strPassword1 = ErjimimaXiugai_After:GetText(); 
	local strPassword2 = ErjimimaXiugai_Queren:GetText();

	
	-- ������벻һ��
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("M�t kh�u nh�p v�o kh�ng ��ng")
		
		ErjimimaXiugai_Before:SetText( "" );
		ErjimimaXiugai_After:SetText( "" );
		ErjimimaXiugai_Queren:SetText( "" );
		return
	end;
	
	
	local iLenOld = string.len(strPasswordOld);
	local iLenNew = string.len(strPassword1);
	if(iLenOld < 4) then
	
		ShowSystemTipInfo("M�t kh�u c� kh�ng ���c �t h�n 4 k� t�!");
		return;
	end;
	
	if(iLenNew < 4) then
	
		ShowSystemTipInfo("M�t kh�u m�i kh�ng ���c �t h�n 4 k� t�!");
		return;
	end;

	-- �������һ�¡����͸ı�������Ϣ��
	ModifyMinorPassword(strPasswordOld, strPassword1);
	
	ErjimimaXiugai_Before:SetText( "" );
	ErjimimaXiugai_After:SetText( "" );
	ErjimimaXiugai_Queren:SetText( "" );
end

--ǿ�ƽ��
function ErjimimaXiugai_Jiechu()
	-- ǿ�ƽӴ�����
	ForceUnLockMinorPassword();
	
	-- ���ش���.
	ErjimimaXiugai_Close();

end

function ErjimimaXiugai_TelMibao_Clicked()
	ErjimimaXiugai_Close();
	OpenDianhuaMibao();
end