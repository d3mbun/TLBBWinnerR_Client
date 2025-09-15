g_InitiativeClose = 0;

local InviteIndex = 0;

local g_Frame = {};
local g_ShowText = {};

--===============================================
-- OnLoad()
--===============================================
function TeamMessageBox1_PreLoad()

	-- ��Ա����ĳ�˼����������ͬ��.
	this:RegisterEvent("TEAM_MEMBER_INVITE");

end

function TeamMessageBox1_OnLoad()

	-- �Ի���
	g_Frame[1] = TeamMessageBox1_Frame;
	g_Frame[2] = TeamMessageBox2_Frame;
	g_Frame[3] = TeamMessageBox3_Frame;
	g_Frame[4] = TeamMessageBox4_Frame;
	g_Frame[5] = TeamMessageBox5_Frame;

	-- ��ʾ����
	g_ShowText[1] = TeamMessageBox1_Text;
	g_ShowText[2] = TeamMessageBox2_Text;
	g_ShowText[3] = TeamMessageBox3_Text;
	g_ShowText[4] = TeamMessageBox4_Text;
	g_ShowText[5] = TeamMessageBox5_Text;

	this:Show();


end

--===============================================
-- OnEvent()
--===============================================
function TeamMessageBox1_OnEvent(event)

	-- ��Ա����ĳ�˼����������ͬ��
	if ( event == "TEAM_MEMBER_INVITE" ) then
		TeamMessageBox_Show_Message(arg0, arg1, arg2, arg3, arg4);
	end;

	TeamMessageBox1_UpdateFrame();

end

--===============================================
-- UpdateFrame
--===============================================
function TeamMessageBox1_UpdateFrame()


end

--===============================================
-- ���ȷ����IDOK��
--===============================================
function TeamMessageBox1_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(1);
	g_Frame[1]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox1_Cancel_Clicked()

	--��������������������
		Player:SendRejectJoinTeam_TeamMemberInvite(1);
	g_Frame[1]:Hide();

end



--===============================================
-- ���ȷ����IDOK��
--===============================================
function TeamMessageBox2_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(2);
	g_Frame[2]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox2_Cancel_Clicked()

	--��������������������
		Player:SendRejectJoinTeam_TeamMemberInvite(2);
	g_Frame[2]:Hide();


end




--===============================================
-- ���ȷ����IDOK��
--===============================================
function TeamMessageBox3_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(3);
	g_Frame[3]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox3_Cancel_Clicked()

	--��������������������
		Player:SendRejectJoinTeam_TeamMemberInvite(3);
	g_Frame[3]:Hide();


end





--===============================================
-- ���ȷ����IDOK��
--===============================================
function TeamMessageBox4_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(4);
	g_Frame[4]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox4_Cancel_Clicked()

	--��������������������
		Player:SendRejectJoinTeam_TeamMemberInvite(4);
	g_Frame[4]:Hide();


end






--===============================================
-- ���ȷ����IDOK��
--===============================================
function TeamMessageBox5_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(5);
	g_Frame[5]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox5_Cancel_Clicked()

	--��������������������
		Player:SendRejectJoinTeam_TeamMemberInvite(5);
	g_Frame[5]:Hide();


end


function TeamMessageBox_Show_Message(strInviter, strDesName, strDesLevel,strDestMenpai,strPos)

	local menpai = tonumber(strDestMenpai);
	local indexMess = tonumber(strPos);
	local strMenPai

	if(0 == menpai) then
		strMenPai = "Thi�u L�m";

		elseif(1 == menpai) then
			strMenPai = "Minh Gi�o";

		elseif(2 == menpai) then
			strMenPai = "C�i Bang";

		elseif(3 == menpai) then
			strMenPai = "V� �ang";

		elseif(4 == menpai) then
			strMenPai = "Nga My";

		elseif(5 == menpai) then
			strMenPai = "Tinh T�c";

		elseif(6 == menpai) then
			strMenPai = "Thi�n Long";

		elseif(7 == menpai) then
			strMenPai = "Thi�n S�n";

		elseif(8 == menpai) then
			strMenPai = "Ti�u Dao";

		elseif(10== menpai) then
			strMenPai = "M� Dung";

	else
		strMenPai = "Kh�ng c�";
	end


	if(-1 == indexMess) then
		return;
	end;

	indexMess = indexMess+ 1;
	this:Show();
	g_Frame[indexMess]:Show();

	local strShowInfo ="";
	strShowInfo ="#R" ..strInviter.. "#cfff263M�i#R " .. strDesName .. "#G["..strDesLevel.." c�p"..strMenPai.."]#cfff263 C�c h� c� �ng � gia nh�p �i kh�ng?";
	g_ShowText[indexMess]:SetText(strShowInfo);
end
