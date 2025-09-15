--===============================================
-- OnLoad()
--===============================================
function Operation_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_GAMESETUP");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");
	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("TOGLE_INPUTSETUP");

end
function Operation_Ret2SelServer_Clicked()
	EnterQuitWait(1);
	Operation_Close();
	--AskRet2SelServer();
end;
function Operation_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function Operation_OnEvent(event)
	
	if ( event == "TOGLE_SYSTEMFRAME" ) then
		if( this:IsVisible()  ) then
			Operation_Close();
		else
			Operation_Open();
		end
	elseif(event == "TOGLE_GAMESETUP" ) then
		
		Operation_Close();
	elseif(event == "TOGLE_SOUNDSETUP" ) then
		
		Operation_Close();
	elseif(event == "TOGLE_VIEWSETUP" ) then
		
		Operation_Close();
	elseif(event == "TOGLE_INPUTSETUP" ) then
		
		Operation_Close();
	elseif(event == "RELIVE_SHOW") then
		Operation_Info:Disable();
		Operation_View:Disable();
		Operation_Sound:Disable();
		Operation_Geme:Disable();
		Operation_2Menu:Disable();
		Operation_Acce_Custom:Disable();
	elseif(event == "RELIVE_HIDE") then
		Operation_Info:Enable();
		Operation_View:Enable();
		Operation_Sound:Enable();
		Operation_Geme:Enable();
		Operation_2Menu:Enable();
		Operation_Acce_Custom:Enable();
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function Operation_UpdateFrame()

end



--===============================================
-- ��Ƶ����
--===============================================
function Operation_View_Clicked()
	SystemSetup:ViewSetup();
end
--===============================================
-- ��������
--===============================================
function Operation_Sound_Clicked()
	SystemSetup:SoundSetup();
end
--===============================================
-- ��������
--===============================================
function Operation_UI_Clicked()
	SystemSetup:UISetup();
end
--===============================================
-- ��������
--===============================================
function Operation_Input_Clicked()
	SystemSetup:InputSetup();
end

--===============================================
-- ��Ϸ������
--===============================================
function Operation_Game_Clicked()
	SystemSetup:GameSetup();
end

--===============================================
-- ��������
--===============================================
function Operation_Help_Clicked()
--	Helper:GotoHelper("");
end

--===============================================
-- �˳���Ϸ
--===============================================
function Operation_QuitGame_Clicked()
	QuitApplication("quest");
	Operation_Close();
end

--===============================================
-- ������Ϸ
--===============================================
function Operation_BackGame_Clicked()
	SystemSetup:BackGame();
	
	Operation_Close();
end

function Operation_Close()
	this:Hide();
end

function Operation_Open()
	this:Show();
end

function Operation_Info_Clicked()

end

function Operation_FanPage_Clicked()
	GameProduceLogin:OpenURL( "https://www.facebook.com/tlbbmoira/" )
end

function Operation_GiftCode_Clicked()
	PushEvent("UI_COMMAND",1026001)
	this:Hide();
end

function Operation_Feedback_Clicked()
	PushEvent("UI_COMMAND",1025001)
	this:Hide();
end

function Operation_Ranking_Clicked()
	PushEvent("UI_COMMAND",1003001)
	this:Hide();
end

function Operation_TopDonate_Clicked()
	PushEvent("UI_COMMAND",1023001)
	this:Hide();
end

function Operation_TopUseKNB_Clicked()
	PushEvent("UI_COMMAND",1024001)
	this:Hide();
end