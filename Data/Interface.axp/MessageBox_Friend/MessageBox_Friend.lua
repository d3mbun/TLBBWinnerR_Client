
local InvitePlayer = { NAME = "", GUID = "" }
local g_MessageBox_Friend_Frame_UnifiedPosition;
function MessageBox_Friend_PreLoad()
	this:RegisterEvent("INVITE_ADD_ME_FRIEND");
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function MessageBox_Friend_OnLoad()
  g_MessageBox_Friend_Frame_UnifiedPosition=MessageBox_Friend_Frame:GetProperty("UnifiedPosition");
	InitPlayer();
	this:Hide();
end

function MessageBox_Friend_OnEvent(event)

	if ( event == "INVITE_ADD_ME_FRIEND" ) then
			InitPlayer();
			MessageBox_Friend_Text:Show();
	    InvitePlayer.NAME = tostring( arg0 );
	    InvitePlayer.GUID = tostring( arg1 );
	    MessageBox_Friend_Text:SetText("Ng߶i ch�i "..InvitePlayer.NAME.." xin c�c h� ��a h� v�o danh s�ch h�o h�u!");
			this:Show();
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		MessageBox_Friend_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MessageBox_Friend_Frame_On_ResetPos()
	end	
end


function MessageBox_Friend_Cancel_Clicked()
	this:Hide();
	InitPlayer();
end

function MessageBox_Friend_Detail_Clicked()

	if( Friend:IsPlayerIsFriend( InvitePlayer.NAME ) == 1 ) then	
		local nGroup,nIndex;
		nGroup,nIndex = DataPool:GetFriendByName( InvitePlayer.NAME );
		--Friend:SetCurrentSelect( nIndex );
		DataPool:ShowFriendInfo( InvitePlayer.NAME );
	else
		DataPool:ShowChatInfo( InvitePlayer.NAME );
	end

	--DataPool:ShowChatInfo( InvitePlayer.NAME );
	--AskDetailByGuid(InvitePlayer.GUID);
end

function MessageBox_Friend_Ok_Clicked()
	DataPool:AddFriend( 0, InvitePlayer.NAME);
	this:Hide();
	InitPlayer();
end

function InitPlayer()
  InvitePlayer.NAME = "";
  InvitePlayer.GUID = "";
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function MessageBox_Friend_Frame_On_ResetPos()
  MessageBox_Friend_Frame:SetProperty("UnifiedPosition", g_MessageBox_Friend_Frame_UnifiedPosition);
end