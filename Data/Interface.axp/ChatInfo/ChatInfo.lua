function ChatInfo_PreLoad()
	this:RegisterEvent("CHAT_SHOWUSERINFO");
end

function ChatInfo_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ChatInfo_OnEvent( event )
	if(event == "CHAT_SHOWUSERINFO") then
		ChatInfo_Show();
	end
end


--===============================================
-- UpdateFrame()
-- �ڼ���Ƶ���ĵڼ�����
--===============================================
function ChatInfo_Update()
	--AxTrace( 0,0,"char PORTRAIT" );
	local strFaceImage = DataPool:GetFriend( "chat", "PORTRAIT" );
	local strMood = DataPool:GetFriend( "chat", "MOOD" );
	ChatInfo_PlayerHead:SetProperty("Image", tostring(strFaceImage));
	--AxTrace( 0,0,"char ID" );
	ChatInfo_ID:SetText( "ID:"..tostring( DataPool:GetFriend( "chat", "ID_TEXT" ) ) );
	--AxTrace( 0,0,"char NAME" );
	ChatInfo_Name:SetText( "H� t�n: "..DataPool:GetFriend( "chat", "NAME"  ) );
	--AxTrace( 0,0,"char LEVEL" );
	ChatInfo_Level:SetText( "C�p: "..tostring( DataPool:GetFriend( "chat", "LEVEL" ) ) );
	--AxTrace( 0,0,"char MENPAI_TEXT" );
	if DataPool:GetFriend( "chat", "MENPAI_TYPE" )==10 then
		ChatInfo_MenPai:SetText( "Ph�i: M� Dung");
	else
		ChatInfo_MenPai:SetText( "Ph�i: "..DataPool:GetFriend( "chat", "MENPAI_TEXT" ) );
	end
	--AxTrace( 0,0,"char GUID_NAME" );
	ChatInfo_Confraternity:SetText( "Bang H�i: "..DataPool:GetFriend( "chat", "GUID_NAME" ) );
	ChatInfo_GuildLeague:SetText( "#{TM_20080311_30}"..DataPool:GetFriend( "chat", "GUILD_LEAGUE_NAME" ) );
	--AxTrace( 0,0,"char MOOD" );
	if(strMood == "߀�]��ã�") then 
	strMood ="V�nCh�aNgh�Ra" 
	end
	ChatInfo_Explain:SetText( "T�m tr�ng: "..strMood.."" );
	--AxTrace( 0,0,"char TITLE" );
	ChatInfo_Agname:SetText( "Danh hi�u: "..DataPool:GetFriend( "chat", "TITLE" ) );
end

function ChatInfo_Show()
	
	ChatInfo_Update();
	this:Show();
end

function ChatInfo_OnHide()
	this:Hide();
end

function ChatInfo_OnHelp()
end

function ChatInfo_AddFriend()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		DataPool:AddFriend( Friend:GetCurrentTeam(), szName);
	end
end

function ChatInfo_SetPrivateName()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Talk:ContexMenuTalk(szName);
	end
end

function ChatInfo_ShengQingTeam()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamApply(szName);
	end
end


function ChatInfo_YaoQingTeam()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamRequest(szName);
	end
end