





-------------------------------------------------------------------------------------------------------
--
-- ע���¼�
--
function ChangeMinorPassword_PreLoad()
	
	-- �򿪽���
	this:RegisterEvent("MINORPASSWORD_OPEN_CHANGE_PASSWORD_DLG");
	this:RegisterEvent("MINORPASSWORD_CLEAR_PASSWORD_DLG");
end

function ChangeMinorPassword_OnLoad()
end


--===============================================
-- OnEvent()
--===============================================
function ChangeMinorPassword_OnEvent(event)

	if(event == "MINORPASSWORD_OPEN_CHANGE_PASSWORD_DLG") then
		this:Show();
		ChangeMinorPassword_EditBox1:SetText( "" );
		ChangeMinorPassword_EditBox2:SetText( "" );
		ChangeMinorPassword_EditBox3:SetText( "" );
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "ChangeMinorPassword_EditBox1" );
	elseif(event == "MINORPASSWORD_CLEAR_PASSWORD_DLG") then 
	
		ClearPassword_Box();
	end	
		
end	

function ChangeMinorPassword_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end


-------------------------------------------------------------------------------------------------------
--
-- ���ȷ�����ö����������밴ť��
--
function ChangeMinorPassword_SetPassword()
	
	-- �ɵ�����
	local strPasswordOld = ChangeMinorPassword_EditBox1:GetText();
	
	-- �µ����롣
	local strPassword1 = ChangeMinorPassword_EditBox2:GetText(); 
	local strPassword2 = ChangeMinorPassword_EditBox3:GetText();

	
	-- ������벻һ��
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("M�t kh�u nh�p v�o kh�ng ��ng")
		
		ChangeMinorPassword_EditBox1:SetText("");
		ChangeMinorPassword_EditBox2:SetText(""); 
		ChangeMinorPassword_EditBox3:SetText("");
		return;
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
	
	this:Hide();

end


-------------------------------------------------------------------------------------------------------
--
-- ���ȡ�����ö����������밴ť��
--
function ChangeMinorPassword_Cancel()
	CloseWindow( "SoftKeyBoard" );
 	this:Hide();
 	
 	-- �򿪽����Ի��� ���ԡ�
 	--OpenUnLockeMinorPasswordDlg();
end;

-------------------------------------------------------------------------------------------------------
--
-- ���������ť
--
function ChangeMinorPassword_Help()

end;


-------------------------------------------------------------------------------------------------------
--
-- �������
--
function ClearPassword_Box()

	-- �ɵ�����
	ChangeMinorPassword_EditBox1:SetText("");
	
	-- �µ����롣
	ChangeMinorPassword_EditBox2:SetText(""); 
	ChangeMinorPassword_EditBox3:SetText("");
	
end;


function ChangeMinorPassword_EditBox1_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox1" );
end
function ChangeMinorPassword_EditBox2_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox2" );
end
function ChangeMinorPassword_EditBox3_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox3" );
end
