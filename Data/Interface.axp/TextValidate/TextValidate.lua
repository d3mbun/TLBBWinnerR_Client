--��ǰ��������....
local g_TextValidate_UIType = -1;

local g_TextValidate_UITypes = {
	CREATE_ROLE	= 0,	--������ɫ��֤....
	LOGIN_CHECK	= 1,	--��½��֤....
	EXCHANGE	= 2,		--������֤....
	LEVELUP_CHECK	= 3,--������֤....
	ANTIVIOLENCE_CHECK = 4, --��������֤, czf add
}

local g_TextValidate_UserLoginType = "";
local g_TextValidate_UserLoginRoleId = -1;
local g_TextValidate_UserLoginScene = -1;


function TextValidate_PreLoad()

	--������ɫ....
	this:RegisterEvent("SHOW_CREATE_ROLE_CODE_VALIDATE");	--�򿪲����±�ͼ����֤����....
	this:RegisterEvent("CREATE_ROLE_CODE_RET");	--����˷�����֤�Ƿ�ͨ��....

	--��¼....
	this:RegisterEvent("SHOW_LOGIN_CODE_VALIDATE");	--�򿪲����±�ͼ����֤����....
	this:RegisterEvent("LOGIN_CODE_RET");	--����˷�����֤�Ƿ�ͨ��....
	this:RegisterEvent("TEXTVALIDATE_SAVELOGINSELECT");	--���������֤ǰ�ĵ�½ѡ��....

	---------------------------------------------------------------
	--�������begin
	this:RegisterEvent("EXCHANGE_BOX_CLOSED");	--���׺йرյ�ʱ��Ҫ�ص������
	this:RegisterEvent("EXCHANGE_THISBOX_INVALID");	--����ʱ�˶Ի����Ѿ���Ч
	this:RegisterEvent("ACCEPT_EXCHANGE_CODE_VALIDATE");	--������֤�����Ϣ	
	this:RegisterEvent("EXCHANGE_IF_CODE_VALIDATE");	--������֤���Ƿ�ͨ��
	--�������end
	---------------------------------------------------------------

	--������֤....
	this:RegisterEvent("SHOW_LEVELUP_CODE_VALIDATE");	--�򿪲����±�ͼ����֤����....
	this:RegisterEvent("LEVELUP_CODE_RET");	--����˷�����֤�Ƿ�ͨ��....

	--add by czf ������2010-7
	this:RegisterEvent("SHOW_ANTIVIOLENT_CODE_VALIDATE");	--�򿪲����·�������ͼ����֤����....
	this:RegisterEvent("ANTIVIOLENT_CODE_RET");	--����˷�����֤�Ƿ�ͨ��....
	this:RegisterEvent("CLOSE_TEXTVALIDATE");	--�ر�ͼ����֤��
	--add end

end

function TextValidate_OnLoad()

end

function TextValidate_OnEvent(event)

	if ( event == "SHOW_CREATE_ROLE_CODE_VALIDATE"  ) then	--�򿪲����±�ͼ����֤����....

		g_TextValidate_UIType = g_TextValidate_UITypes.CREATE_ROLE;
		--����ͼ����֤��Ϣ....
		--����ӿ��Ǹ�ѡ�����ͼ����֤�õ�....����������ͼ����֤����Ҳ��������ӿ�....
		--5�������ֱ���5���ؼ�������....����1��ͼ�οؼ�������..����2~5�Ǵ𰸿ؼ�������....
		--���ú��ˢ����֤ͼƬ��ͼ�οؼ�....��ˢ��4���𰸵�4���𰸿ؼ���Text����....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--������״δ򿪴���(����ˢ��ͼƬ)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end

		--ÿ��ˢ�´��ڶ��������λ��....
		TextValidate_RandomWindowPos()

	elseif event == "CREATE_ROLE_CODE_RET" then	--����˷�����֤�Ƿ�ͨ��....
		
		if g_TextValidate_UIType ~= g_TextValidate_UITypes.CREATE_ROLE then
			return
		end

		if arg0 == "no" then
			--��֤ʧ��
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--��֤�ɹ�....��رս��沢�л������ﴴ������....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
		end
		

		--============================================

	elseif ( event == "SHOW_LOGIN_CODE_VALIDATE" ) then	--�򿪲����±�ͼ����֤����....

		g_TextValidate_UIType = g_TextValidate_UITypes.LOGIN_CHECK

		--����ͼ����֤��Ϣ....
		--����ӿ��Ǹ�ѡ�����ͼ����֤�õ�....����������ͼ����֤����Ҳ��������ӿ�....
		--5�������ֱ���5���ؼ�������....����1��ͼ�οؼ�������..����2~5�Ǵ𰸿ؼ�������....
		--���ú��ˢ����֤ͼƬ��ͼ�οؼ�....��ˢ��4���𰸵�4���𰸿ؼ���Text����....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--������״δ򿪴���(����ˢ��ͼƬ)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end

		--ÿ��ˢ�´��ڶ��������λ��....
		TextValidate_RandomWindowPos()

	elseif event == "LOGIN_CODE_RET" then	--����˷�����֤�Ƿ�ͨ��....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.LOGIN_CHECK then
			return
		end

		if arg0 == "no" then
			--��֤ʧ��
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--��֤�ɹ�....��رս���....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
		end

	elseif event == "TEXTVALIDATE_SAVELOGINSELECT" then	--���������֤ǰ�ĵ�½ѡ��....

		g_TextValidate_UserLoginType = tostring(arg0)
		g_TextValidate_UserLoginRoleId = tonumber(arg2)
		g_TextValidate_UserLoginScene = tonumber(arg3)

	--============================================

	elseif ( event == "SHOW_LEVELUP_CODE_VALIDATE" ) then	--�򿪲����±�ͼ����֤����....

		g_TextValidate_UIType = g_TextValidate_UITypes.LEVELUP_CHECK

		--����ͼ����֤��Ϣ....
		--����ӿ��Ǹ�ѡ�����ͼ����֤�õ�....����������ͼ����֤����Ҳ��������ӿ�....
		--5�������ֱ���5���ؼ�������....����1��ͼ�οؼ�������..����2~5�Ǵ𰸿ؼ�������....
		--���ú��ˢ����֤ͼƬ��ͼ�οؼ�....��ˢ��4���𰸵�4���𰸿ؼ���Text����....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--������״δ򿪴���(����ˢ��ͼƬ)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end

		--ÿ��ˢ�´��ڶ��������λ��....
		TextValidate_RandomWindowPos()

	elseif event == "LEVELUP_CODE_RET" then	--����˷�����֤�Ƿ�ͨ��....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.LEVELUP_CHECK then
			return
		end

		if arg0 == "no" then
			--��֤ʧ��
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--��֤�ɹ�....��رս���....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
		end

	end

	---------------------------------------------------------------
	--�������begin
	if  event == "ACCEPT_EXCHANGE_CODE_VALIDATE" then  --����ͼ����֤���������������ظ�����Ҫ�Ƿ���ϲ��ļ�
		g_TextValidate_UIType = g_TextValidate_UITypes.EXCHANGE;
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--�������ˢ��ͼƬ
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");	--���־�����ǰ�Ǹ�
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end	
		--ÿ��ˢ�´��ڶ��������λ��....
		TextValidate_RandomWindowPos()
	end
	if  event == "EXCHANGE_THISBOX_INVALID" or event == "EXCHANGE_BOX_CLOSED" then 
		if this:IsVisible() and g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE then	--���ڽ�����˵����������g_TextValidate_UIType���ж�
			--PushDebugMessage("Hide1")
			this : Hide();
		end
	end
	if event == "EXCHANGE_IF_CODE_VALIDATE" then	--����˷�����֤�Ƿ�ͨ��....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.EXCHANGE then
			return
		end

		if arg0 == "no" then
			--��֤ʧ��
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--��֤�ɹ�....��رս���....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
			Exchange:AcceptExchange();
		end

	end
	--�������end
	---------------------------------------------------------------

	--===================================================
	-------------------------add by czf ���������� 2010-7-----------------------------
	if ( event == "SHOW_ANTIVIOLENT_CODE_VALIDATE" ) then	--�򿪲����±�ͼ����֤����....

		g_TextValidate_UIType = g_TextValidate_UITypes.ANTIVIOLENCE_CHECK

		--����ͼ����֤��Ϣ....
		--����ӿ��Ǹ�ѡ�����ͼ����֤�õ�....����������ͼ����֤����Ҳ��������ӿ�....
		--5�������ֱ���5���ؼ�������....����1��ͼ�οؼ�������..����2~5�Ǵ𰸿ؼ�������....
		--���ú��ˢ����֤ͼƬ��ͼ�οؼ�....��ˢ��4���𰸵�4���𰸿ؼ���Text����....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--������״δ򿪴���(����ˢ��ͼƬ)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
			DataPool:CloseSystemInfoWindow(); --czf �ر�ϵͳ��Ϣ����
		end
		--ÿ��ˢ�´��ڶ��������λ��....
		TextValidate_RandomWindowPos()
		--this:Show();

	elseif event == "ANTIVIOLENT_CODE_RET" then	--����˷�����֤�Ƿ�ͨ��....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.ANTIVIOLENCE_CHECK then
			return
		end

		if arg0 == "no" then
			--��֤ʧ��
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--��֤�ɹ�....��رս���....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "-1"); 
			this:Hide(); -- czf
		end
	elseif event == "CLOSE_TEXTVALIDATE" then
		if this:IsVisible() then
			this:Hide();
		end
	end
	----------------------add end------------------------------
	--===================================================
	
end

function TextValidate_BtnCommitClick()
		
	--�������������ַ����������....
	local strInput = TextValidate_Input:GetText();
	if( strInput == "" ) then
		TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		return;
	end
	if g_TextValidate_UIType == g_TextValidate_UITypes.CREATE_ROLE then
		DataPool:SendCreateCharCode( strInput )
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LOGIN_CHECK then
		DataPool:SendLoginCode( strInput )
	elseif (g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE)then	
		 Exchange:SendExchangeCheckCode( strInput )
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LEVELUP_CHECK then
		AnswerLevelUpCode( strInput )
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.ANTIVIOLENCE_CHECK then --czf add
		DataPool:SendAntiViolentCode( strInput )
	end
	TextValidate_DisableWindowSomeTime();

end

function TextValidate_BtnCloseClick()
	if (g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE)then	
		 Exchange:SendEnableAcceptBtn();
	elseif (g_TextValidate_UIType == g_TextValidate_UITypes.ANTIVIOLENCE_CHECK)then
		DataPool:DisconnectLoginServer(); --czf �Ͽ���login��socket����
	end
	--PushDebugMessage("Hide2")
	this:Hide();
end

function TextValidate_BtnChangePicClick()
	--��Login�����µ�ͼ����֤��Ϣ....
	if g_TextValidate_UIType == g_TextValidate_UITypes.CREATE_ROLE then
		DataPool:AskCreateCharCode();
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LOGIN_CHECK then
		DataPool:AskLoginCode();
	elseif (g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE)then
		Exchange:AskExchangeCheckCode();
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LEVELUP_CHECK then
		AskNewLevelUpCode();
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.ANTIVIOLENCE_CHECK then --czf add
		DataPool:AskAntiViolentCode();
	end
	TextValidate_DisableWindowSomeTime();
end


--���ô���һ��ʱ��....��ֹ������Login����ͼƬ....
function TextValidate_DisableWindowSomeTime()
	TextValidate_Accept:SetProperty("Disabled", "True");
	TextValidate_ChangePic:SetProperty("Disabled", "True");
	TextValidate_Close:SetProperty("Disabled", "True");
	TextValidate_StopWatch1:SetProperty("Timer", "3");
end

function TextValidate_TimeReach1()
	TextValidate_Accept:SetProperty("Disabled", "False");
	TextValidate_ChangePic:SetProperty("Disabled", "False");
	TextValidate_Close:SetProperty("Disabled", "False");
	TextValidate_StopWatch1:SetProperty("Timer", "-1");
end

function TextValidate_TimeReach2()

	TextValidate_StopWatch2:SetProperty("Timer", "-1");
	TextValidate_Input:SetProperty("DefaultEditBox", "False");
	--PushDebugMessage("Hide3")
	this:Hide();

	if(g_TextValidate_UIType == g_TextValidate_UITypes.CREATE_ROLE)then		

		GameProduceLogin:ChangeToCreateRoleDlgFromSelectRole();

	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LOGIN_CHECK then

		--����֮ǰ�������ҵ�¼ѡ���Զ�������Ϸ....
		if g_TextValidate_UserLoginType == "NormalLogin" then
			GameProduceLogin:SendEnterGameMsg(g_TextValidate_UserLoginRoleId)
		elseif g_TextValidate_UserLoginType == "NewPlayerLogin" then
			GameProduceLogin:EnterNewRoleScene(g_TextValidate_UserLoginRoleId, g_TextValidate_UserLoginScene)
		end

		g_TextValidate_UserLoginType = "";
		g_TextValidate_UserLoginRoleId = -1;
		g_TextValidate_UserLoginScene = -1;

	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LEVELUP_CHECK then

		AskLevelUpAfterValidate();

	end

end

--**********************************
--�������λ��
--**********************************
function TextValidate_RandomWindowPos()

	local x = -95
	local y = 44
	x = x + math.random(-160,160)
	y = y + math.random(-160,160)
	TextValidate_Frame:SetProperty("UnifiedXPosition", "{0.4,"..x.."}")
	TextValidate_Frame:SetProperty("UnifiedYPosition", "{0.2,"..y.."}")

end

---------------------------------------------------------------
-- New begin
function TextValidate_Frame_Hidden()
	TextValidate_Input:SetProperty("DefaultEditBox", "False");
	TextValidate_StopWatch2:SetProperty("Timer", "-1");
	TextValidate_StopWatch1:SetProperty("Timer", "-1");
end
-- New end
---------------------------------------------------------------

function TextValidate_Input_TextAccepted()
	TextValidate_BtnCommitClick()
end