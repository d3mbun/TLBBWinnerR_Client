--*--------------------------------------------------------------------------------------------------------------------
--* �����ص�lua�ű�
--* 1, �������.
--* 2, ��Ա�򿪶�����Ϣ����.
--* 3, �ӳ��򿪶�����Ϣ����.
--* 4, �ӳ��������߽���.
--*
--*---------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------
-- ȫ����Ҫ�õ��ı���.
--
local g_iTeamInfoType = 4;				-- ��������
																	-- 0 : �򿪶�����Ϣ�Ի���
																	-- 1 : ������Ի���
																	-- 2 : ������Ի���.
																	-- 3 : �ӳ��򿪶�����Ϣ�Ի���.
																	-- 4 : �������Ҵ򿪽���
																	-- -1: �رս���

-----------------------------------------------------------------------------------------------------------------------
-- �������
--
local g_iTeamCount_Invite   = 0;	-- �������ĸ���.
local g_iCurShowTeam_Invite = 0;	-- �ڽ�������ʾ�Ķ���
																	-- -1 : û����ʾ�Ķ���.


------------------------------------------------------------------------------------------------------------------------
-- ��Ա�򿪶�����Ϣ����
--



------------------------------------------------------------------------------------------------------------------------
-- �ӳ��򿪶�����Ϣ����
--
local g_iTeamMemberCount_Team = 0;	-- ��ǰ�����ж�Ա�ĸ���.
local g_iCurSel_Team = -1;						-- ��ǰѡ��Ķ�Ա.


------------------------------------------------------------------------------------------------------------------------
-- �ӳ��������߽���
--
local g_iSel = -1;									-- �ڽ�����ѡ��Ķ�Ա
																	-- -1 : û��ѡ���Ա.


local g_iCurPageShowCount  = 6; 	-- ��ǰҳ����ʾ�������˵ĸ���.
local g_iMemberCount_Apply = 0;		-- �����ʱ, ��Ա�ĸ���.
local g_iCurSel_Apply      = 0;   -- ��ǰѡ���������.(��ǰҳ�������)
local g_iCurShowPage_Apply = 0;   -- ��ǰѡ���ҳ��.
local g_iCurSelApply_Apply = 0;   -- ��ǰѡ�������, (��ͷ��ʼ)


local g_iRealSelApplyIndex      = 0;	-- ��ǰʵ��ѡ��������ߵ�����
local g_iRealSelInvitorIndex    = 0;	-- ��ǰʵ��ѡ��������������
local g_iRealSelTeamMemberIndex = 0;  -- ��ǰʵ��ѡ���������������
--local g_iRealSelInvitorIndexPingbi = 0;	-- ��ǰʵ��ѡ��������������,���ΰ�ť�õ�

------------------------------------------------------------------------------------------------------------------------
-- ����ؼ�
--
local g_Team_PlayerInfo_Name   = {};
local g_Team_PlayerInfo_School = {};
local g_Team_PlayerInfo_Level  = {};

local g_Team_PlayerInfo_Dead = {};
local g_Team_PlayerInfo_Deadlink = {};

local g_Team_Ui_Model_Disable = {};

-------------------------------------------------------------------------------------------------------------------------
-- ģ�ͽ���
--
local g_TeamFrame_FakeObject = {};


function Team_Frame_PreLoad()

	-- �򿪴��ڽ���
	this:RegisterEvent("TEAM_OPEN_TEAMINFO_DLG");
	
	-- ˢ�¶�Ա��Ϣ
	this:RegisterEvent("TEAM_REFRESH_MEMBER");
	
	-- �����뿪����
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	-- �ж����¼�, ����, ����
	this:RegisterEvent("TEAM_NOTIFY_APPLY");
	--����
	this:RegisterEvent("RESET_ALLUI");
	
	-- ȷ�Ͻ�ɢ����			add by WTT	20090212
--	this:RegisterEvent("CONFIRM_DISMISS_TEAM");

end

function Team_Frame_OnLoad()
	-- ����
	g_Team_PlayerInfo_Name[0] = Team_PlayerInfo1_Name;
	g_Team_PlayerInfo_Name[1] = Team_PlayerInfo2_Name;
	g_Team_PlayerInfo_Name[2] = Team_PlayerInfo3_Name;
	g_Team_PlayerInfo_Name[3] = Team_PlayerInfo4_Name;
	g_Team_PlayerInfo_Name[4] = Team_PlayerInfo5_Name;
	g_Team_PlayerInfo_Name[5] = Team_PlayerInfo6_Name;

	g_Team_PlayerInfo_School[0] = Team_PlayerInfo1_School;
	g_Team_PlayerInfo_School[1] = Team_PlayerInfo2_School;
	g_Team_PlayerInfo_School[2] = Team_PlayerInfo3_School;
	g_Team_PlayerInfo_School[3] = Team_PlayerInfo4_School;
	g_Team_PlayerInfo_School[4] = Team_PlayerInfo5_School;
	g_Team_PlayerInfo_School[5] = Team_PlayerInfo6_School;

	g_Team_PlayerInfo_Level[0] = Team_PlayerInfo1_Level;
	g_Team_PlayerInfo_Level[1] = Team_PlayerInfo2_Level;
	g_Team_PlayerInfo_Level[2] = Team_PlayerInfo3_Level;
	g_Team_PlayerInfo_Level[3] = Team_PlayerInfo4_Level;
	g_Team_PlayerInfo_Level[4] = Team_PlayerInfo5_Level;
	g_Team_PlayerInfo_Level[5] = Team_PlayerInfo6_Level;

	g_TeamFrame_FakeObject[0] = TeamFrame_FakeObject1;
	g_TeamFrame_FakeObject[1] = TeamFrame_FakeObject2;
	g_TeamFrame_FakeObject[2] = TeamFrame_FakeObject3;
	g_TeamFrame_FakeObject[3] = TeamFrame_FakeObject4;
	g_TeamFrame_FakeObject[4] = TeamFrame_FakeObject5;
	g_TeamFrame_FakeObject[5] = TeamFrame_FakeObject6;

	-- �������
	g_Team_PlayerInfo_Dead[0] = Team_Die_Icon1;
	g_Team_PlayerInfo_Dead[1] = Team_Die_Icon2;
	g_Team_PlayerInfo_Dead[2] = Team_Die_Icon3;
	g_Team_PlayerInfo_Dead[3] = Team_Die_Icon4;
	g_Team_PlayerInfo_Dead[4] = Team_Die_Icon5;
	g_Team_PlayerInfo_Dead[5] = Team_Die_Icon6;

	-- ���߱��
	g_Team_PlayerInfo_Deadlink[0] = Team_Downline_Icon1;
	g_Team_PlayerInfo_Deadlink[1] = Team_Downline_Icon2;
	g_Team_PlayerInfo_Deadlink[2] = Team_Downline_Icon3;
	g_Team_PlayerInfo_Deadlink[3] = Team_Downline_Icon4;
	g_Team_PlayerInfo_Deadlink[4] = Team_Downline_Icon5;
	g_Team_PlayerInfo_Deadlink[5] = Team_Downline_Icon6;
	
	
	-- ui ����ģ��
	g_Team_Ui_Model_Disable[0] = Team_Model1_Disable;
	g_Team_Ui_Model_Disable[1] = Team_Model2_Disable;
	g_Team_Ui_Model_Disable[2] = Team_Model3_Disable;
	g_Team_Ui_Model_Disable[3] = Team_Model4_Disable;
	g_Team_Ui_Model_Disable[4] = Team_Model5_Disable;
	g_Team_Ui_Model_Disable[5] = Team_Model6_Disable;
	

	Team_Die_Icon1:Hide();
	Team_Die_Icon2:Hide();
	Team_Die_Icon3:Hide();
	Team_Die_Icon4:Hide();
	Team_Die_Icon5:Hide();
	Team_Die_Icon6:Hide();


	Team_Downline_Icon1:Hide();
	Team_Downline_Icon2:Hide();
	Team_Downline_Icon3:Hide();
	Team_Downline_Icon4:Hide();
	Team_Downline_Icon5:Hide();
	Team_Downline_Icon6:Hide();

	Team_Exp_Mode:ComboBoxAddItem( "Ph�n ph�i �u", 0 );
	Team_Exp_Mode:ComboBoxAddItem( "Ph�n ph�i ri�ng", 1 );
	Team_Exp_Mode:ComboBoxAddItem( "M� th�c thu�n th�", 2 );
	
end

function Team_StateUpdate()
	-- ���ظ��水ť
	AxTrace( 0,0,"Lo�i h�nh nh�m==="..tostring(g_iTeamInfoType));
	Team_Follow_Button:Hide();

	if( Player:InTeamFollowMode() ) then
		Team_AbortTeamFollow_Button:Show();
	else
		Team_AbortTeamFollow_Button:Hide();
	end
	--����ɾ����3�����ͣ�����3�����Ͷ����0
	if( g_iTeamInfoType == 3 ) then
		g_iTeamInfoType = 0;
	end
	if( 0 == g_iTeamInfoType) then
	-- �򿪶�����Ϣ
		-- ����Լ�����Ϣ
		DataPool:SetSelfInfo();
		-- ��ʾ����
		local leader = Player:IsLeader();
		
		if( leader == 1 ) then
			AxTrace( 0,0, "TeamFrame_OpenLeaderTeamInfo = "..tonumber( leader ) );	
			TeamFrame_OpenLeaderTeamInfo();
		else
			AxTrace( 0,0, "TeamFrame_OpenTeamInfo = "..tonumber( leader ) );
			TeamFrame_OpenTeamInfo();
		end
		-- ѡ���һ��
		SelectPos(0);
		Team_Button_Frame6:Hide();
		

	elseif(1 == g_iTeamInfoType) then
	-- �ӳ��������������б�

		-- ��ʾ����
		ShwoLeaderFlat(0);
		TeamFrame_OpenApplyList();
		Team_Update_ExpMode( -1 );
			-- ѡ���һ��
		SelectPos(0);
		
	elseif(2 == g_iTeamInfoType) then
	-- ������Ի���.

		ClearInfo();
		-- ��ʾ����
		TeamFrame_OpenInvite();
		Team_Update_ExpMode( -1 );
			-- ѡ���һ��
		SelectPos(0);

	elseif(3 == g_iTeamInfoType) then
	-- �ӳ�������б�

		-- ����Լ�����Ϣ
		DataPool:SetSelfInfo();
		-- ��ʾ����
		
		-- ѡ���һ��
		SelectPos(0);
		
		-- �������һ����ť
		Team_Button_Frame6:Hide();
		
	elseif(4 == g_iTeamInfoType) then
	-- �������Ҵ򿪽���
		TeamFrame_OpenCreateTeamSelf();
		Team_Update_ExpMode( -1 );
	end

		
end

function Team_Frame_OnEvent(event)


	
	--ShwoLeaderFlat(0);
	---------------------------------------------------------------------------------------------
	--
	-- �򿪽����¼�.
	--
	if ( event == "TEAM_OPEN_TEAMINFO_DLG" ) then

		--����uiģ������.
		HideUIModelDisable();
		-- �õ��򿪵ĶԻ������ʾ����.
		local iShow = tonumber(arg0);
		AxTrace( 0,0, "Lo�i h�nh nh�m==="..tostring(g_iTeamInfoType).."   "..tostring( iShow ));
		if(-1 == iShow) then
		
			Team_Close();
			return;
		elseif( 4 == iShow ) then
			if(this:IsVisible()) then
			else
				return;
			end
		elseif( 3 == iShow ) then
			
		else
			-- �����ť����˸.	
			-- �����ǰ�����Ǵ򿪵�. ��رս���
			if(this:IsVisible()) then
			
				Team_Close();
				return;
			end;
		end;
		-- �������û�д򿪾ͷ���.
		-- ��������, ��ˢ������.
--		if DataPool:GetApplyMemberCount() > 0 then
	--		g_iTeamInfoType = 1;
		--end
		Team_StateUpdate();
		return;

	end


	------------------------------------------------------------------------------------
	--
	-- ˢ�¶�Ա��Ϣ�¼�
	--
	if(event == "TEAM_REFRESH_MEMBER") then
		AxTrace( 0,0, "TEAM_REFRESH_MEMBER"..tostring( arg0 ) );
		if (this:IsVisible()) then
			if( tonumber( arg0 ) == 100 ) then
				Team_Update_ExpMode( 0 );	
				return;
			end;
		end;
		if(this:IsVisible()) then
		
			-- ֻҪ���ڴ�ʱ, ��ˢ�½�������		
			-- ���統ǰ����򿪶�Ա��Ϣ.
			if(g_iTeamInfoType == 0) then
				-- ��ս���
				ClearUIModel();
				-- �õ�Ҫˢ�¶�Ա��λ��
				local iMemberIndex = tonumber(arg0);
				if((iMemberIndex >= 0) and (iMemberIndex < 6)) then
					ShwoLeaderFlat(1);
					-- ˢ�¶�Ա��Ϣ.
					TeamFrame_RefreshTeamMember_Team(iMemberIndex);
				end;
				-- ˢ��uiģ��
				RefreshUIModel();
			end
			return;
		end;-- if(this:IsVisible()) then
	end;


	------------------------------------------------------------------------------------------
	--
	-- �뿪�����¼�
	--
	if( event == "PLAYER_LEAVE_WORLD") then
		Team_Close();
		return;
	end
	
	
	-------------------------------------------------------------------------------------------
	--
	-- �ж����¼�, ����, ����
	--
	if( event == "TEAM_NOTIFY_APPLY") then
		g_iTeamInfoType = tonumber(arg0);
		AxTrace( 0,0, "TEAM_NOTIFY_APPLY"..tostring( arg0 ) );
		if( this:IsVisible() ) then
			--����uiģ������.
			-- 0 : �򿪶�����Ϣ�Ի���
			-- 1 : ������Ի���
			-- 2 : ������Ի���.
			-- 3 : �ӳ��򿪶�����Ϣ�Ի���.
			-- -1: �رս���
--			if DataPool:GetApplyMemberCount() > 0 then
	--			g_iTeamInfoType = 1;
		--	end
			Team_StateUpdate();
		end
		return;
	end
	if( event == "RESET_ALLUI") then
		g_iTeamInfoType = 4;
		return;
	end
	
	
	----------------------------------------------------------------------------------------------
	--
	-- ȷ�Ͻ�ɢ����			add by WTT	20090212
	--
--	if ( event == "CONFIRM_DISMISS_TEAM" )	then
	--	Team_Confirm_Dismiss_Team();
		--return;	
	--end
	
end



------------------------------------------------------------------------------------------------------------------
-- ��������¼�
--
function TeamFrame_Select1()

	g_iSel = 0;
	
	--AxTrace( 0,0, "sel+++=ͬ������+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	--FlashTeamButton(0);
	if(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���õ�ǰѡ�е�������
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);


	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		-- g_iRealSelInvitorIndex = g_iSel;
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;
		
	elseif(0 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		if(0 == g_iTeamMemberCount_Team) then

			-- ������������0, ����.
			return;
		end
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Disable();
			-- ��ֹ�ӳ�������ť
			Team_Button_Frame4:Disable();
		end
		-- ��¼��ǰѡ�е�����
		--SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
	end

end

------------------------------------------------------------------------------------------------------------------
-- ��������¼�
--
function TeamFrame_Select2()

	g_iSel = 1;

	--AxTrace( 0,0, "sel=="..tostring(g_iSel));
	--FlashTeamButton(1);
	if(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���õ�ǰѡ�е�������
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ��ֹ�ӳ�������ť
			Team_Button_Frame4:Enable();
		end
	end

end

------------------------------------------------------------------------------------------------------------------
-- ��������¼�
--
function TeamFrame_Select3()

	g_iSel = 2;
	--FlashTeamButton(2);
	--AxTrace( 0,0, "sel+++=ͬ������+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���õ�ǰѡ�е�������
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ��ֹ�ӳ�������ť
			Team_Button_Frame4:Enable();
		end

	end

end




------------------------------------------------------------------------------------------------------------------
-- ��������¼�
--
function TeamFrame_Select4()

	g_iSel = 3;
	--FlashTeamButton(3);
	--AxTrace( 0,0, "sel+++=ͬ������+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���õ�ǰѡ�е�������
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ��ֹ�ӳ�������ť
			Team_Button_Frame4:Enable();
		end
	end

end

------------------------------------------------------------------------------------------------------------------
-- ��������¼�
--
function TeamFrame_Select5()

	g_iSel = 4;
	--FlashTeamButton(0);
	--AxTrace( 0,0, "sel+++=ͬ������+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���õ�ǰѡ�е�������
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ��ֹ�ӳ�������ť
			Team_Button_Frame4:Enable();
		end
		
	end

end

------------------------------------------------------------------------------------------------------------------
-- ��������¼�
--
function TeamFrame_Select6()

	g_iSel = 5;
	--FlashTeamButton(1);
	--AxTrace( 0,0, "sel+++=ͬ������+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���õ�ǰѡ�е�������
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		-- ��¼��ǰѡ�е�����
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ��ֹ�ӳ�������ť
			Team_Button_Frame4:Enable();
		end

	end





end


------------------------------------------------------------------------------------------------------------------
-- ��ť Team_Follow ����¼�
--
function Team_Button_Team_Follow_Click()

	if( 0 == g_iTeamInfoType) then
		-- �򿪶�����Ϣ
		-- �ӳ��򿪶�����Ϣ�Ի���.
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			Player:TeamFrame_AskTeamFollow();
			Team_Close();
		end

	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

	elseif(3 == g_iTeamInfoType) then
		

	end

end




------------------------------------------------------------------------------------------------------------------
-- ��ť0����¼�
--
function Team_Button_Frame0_Click()

	if( 0 == g_iTeamInfoType) then
		-- �ӳ��������������б�
		local leader = Player:IsLeader();
		if( leader == 1 ) then
				-- �õ������˵ĸ���.
			iMemberCount_Apply = DataPool:GetApplyMemberCount();
			if(0 == iMemberCount_Apply) then
				return;
			end
			TeamFrame_OpenApplyList();
		end
	elseif(1 == g_iTeamInfoType) then
		-- �ӳ�����б�

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.
	end
end



------------------------------------------------------------------------------------------------------------------
-- ��ť1����¼�
--
function Team_Button_Frame1_Click()

	if( 0 == g_iTeamInfoType) then
		-- �򿪶�����Ϣ
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			Player:DismissTeam();			-- �򿪽�ɢ����Ķ���ȷ�ϴ���			add by WTT	20090212		
			Team_Close();
		end
	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��򿪶����б�
		DataPool:SetSelfInfo();
		TeamFrame_OpenLeaderTeamInfo();

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.
	end

end

------------------------------------------------------------------------------------------------------------------
-- ��ť2����¼�
--
function Team_Button_Frame2_Click()

	if( 0 == g_iTeamInfoType) then
		-- �򿪶�����Ϣ
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			Player:LeaveTeam();
			Team_Close();
		end
	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ǰ��ҳ
		TeamFrame_PageUp_Apply();

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.
	end

end


------------------------------------------------------------------------------------------------------------------
-- ��ť3����¼�
--
function Team_Button_Frame3_Click()

	if( 0 == g_iTeamInfoType) then
		-- �򿪶�����Ϣ
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			if((-1 == g_iSel) or (0 == g_iSel))then

			-- ����ڽ�����û��ѡ��һ����Ա�ͷ���
			-- ����ѡ�е����Լ�(�ӳ�), Ҳ����.
			return;
			end

			-- �߳�һ����Ա.
			--Player:KickTeamMember();
			
			local iTeamCount = DataPool:GetTeamMemberCount();
			--AxTrace( 0,0, "��ǰѡ��"..tostring(g_iSel).."���Ѹ���"..tostring(iTeamCount));
			if(iTeamCount <= g_iSel) then
			
				return;
			end;
			Player:KickTeamMember(g_iRealSelTeamMemberIndex);
			
			Team_Close();
		end
	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- ���ҳ
		TeamFrame_PageDown_Apply();

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ��ǰ��ҳ
		TeamFrame_PageUp();

	elseif(3 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

		--AxTrace( 0,0, "��ǰѡ��==="..tostring(g_iSel));
		

	end


end

------------------------------------------------------------------------------------------------------------------
-- ��ť4����¼�
--
function Team_Button_Frame4_Click()


	if( 0 == g_iTeamInfoType) then
		-- �򿪶�����Ϣ
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			local iTeamCount = DataPool:GetTeamMemberCount();
		
			if((-1 == g_iSel) or (0 == g_iSel))then

				AxTrace( 0,0, "Tr߷ng"..tostring(g_iSel));
				-- ����ڽ�����û��ѡ��һ����Ա�ͷ���
				-- ����ѡ�е����Լ�(�ӳ�), Ҳ����.
						
				return;
			end

			
			if( iTeamCount <= g_iSel) then
			
				AxTrace( 0,0, "Tr߷ng"..tostring(g_iSel).."  "..tostring(iTeamCount));
				return;
			end;
			
			AxTrace( 0,0, "Tr߷ng"..tostring(g_iSel));
			-- �����ӳ�.
			-- Player:AppointLeader();
			Player:AppointLeader(g_iRealSelTeamMemberIndex);
			Team_Close();

		else
			Player:LeaveTeam();
			Team_Close();
		end

	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		DataPool:ClearAllApply();
		-- ������һ�ζӳ��򿪽����ǲ鿴������Ϣ
		--DataPool:SetTeamFrameOpenFlag(3);
		g_iTeamInfoType = 0;
		Team_Close();


	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ���ҳ
		TeamFrame_PageDown();
	end



end

------------------------------------------------------------------------------------------------------------------
-- ��ť5����¼�
--
function Team_Button_Frame5_Click()


	if( 0 == g_iTeamInfoType) then
		-- �򿪶�����Ϣ
		--SendAddFriendMsg();
		
	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		if((-1 == g_iSel))then

			-- ����ڽ�����û��ѡ��һ����Ա�ͷ���
			-- ����ѡ�е����Լ�(�ӳ�), Ҳ����.
			return;
		end

		-- ͬ�������߼������
		TeamFrame_AgreeJoinTeam_Apply();


	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- ͬ��������
		TeamFrame_AgreeJoinTeam_Invite();
		Team_Close();

	elseif(3 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.
	

	end


end

------------------------------------------------------------------------------------------------------------------
-- ��ť6����¼�
--
function Team_Button_Frame6_Click()

	if( 0 == g_iTeamInfoType) then
	elseif(1 == g_iTeamInfoType) then
		-- �ӳ��������������б�

		-- �ܾ������߼������.
		TeamFrame_RejectJoinTeam_Apply();
		--DataPool:SetTeamFrameOpenFlag(3);
		if(g_iMemberCount_Apply <= 0) then
			
			g_iTeamInfoType = 0;
			Team_Close();
		end;	

	elseif(2 == g_iTeamInfoType) then
		-- ������Ի���.

		-- �ܾ��������.
		TeamFrame_RejectJoinTeam_Invite();
		--DataPool:SetTeamFrameOpenFlag(0);
		if(g_iTeamCount_Invite <= 0) then
		
			g_iTeamInfoType = 4;
			Team_Close();
		end
		
	elseif(3 == g_iTeamInfoType) then
		-- �ӳ��򿪶�����Ϣ�Ի���.

	elseif(4 == g_iTeamInfoType) then
		-- �������Ҵ򿪽���
		Player:CreateTeamSelf();
		Team_Close();
	end

end



------------------------------------------------------------------------------------------------------------------
-- �򿪶�����Ϣ
--
function TeamFrame_OpenTeamInfo()

		-- ���ui����
		ClearUIModel();

		-- �����������
		HideDeadFlag();

		-- ���ص��߱��
		HideDeadLinkFlag();

		-- ���ضӳ����
		ShwoLeaderFlat(0);


		g_iSel = -1;

		-- ���öԻ���Ĳ�������
		g_iTeamInfoType = 0;
		g_iTeamInfoType  = 0;

		-- ��ʾ��ȷ����ʾ����
		Team_Button_Frame0:Hide();
		Team_Button_Frame1:Hide();
		Team_Button_Frame2:Hide();
		Team_Button_Frame3:Hide();
		Team_Button_Frame4:Hide();
		Team_Button_Frame5:Hide();
		Team_Button_Frame6:Hide();
--		Team_Button_Frame7:Hide();

		-- ���ð�ť����
		Team_Button_Frame4:Show();
		Team_Button_Frame5:Show();
		Team_Button_Frame6:Show();
		Team_Button_Frame4:Enable();
		Team_Button_Frame5:Enable();
		Team_Button_Frame6:Enable();
		Team_Button_Frame4:SetText("R�i kh�i");
		Team_Button_Frame5:SetText("H�o h�u");
		Team_Button_Frame6:SetText("M�i k�t h�o h�u");
		--Team_Button_Frame7:SetToolTip("");--������治��ʾtooltips
		Team_Name:SetText("#gFF0FA0Th�ng tin nh�m");

		Team_Update_ExpMode( 0 ); 
		-- ��ǰ�����ж�Ա�ĸ���.
		g_iTeamMemberCount_Team = DataPool:GetTeamMemberCount();

		-- ��������������, ����ʾ����.
		if(g_iTeamMemberCount_Team <= 0) then
			this:Hide();
			--Team_Close();

		end;

		-- ���õ�ǰѡ��,
		g_iCurSel_Team = 0;

		-- ��ս���
		for i = 0, 5 do
			g_Team_PlayerInfo_Name[i]:SetText("");
			g_Team_PlayerInfo_School[i]:SetText("");
			g_Team_PlayerInfo_Level[i]:SetText("");

		end;

		-- ˢ��ÿ����Ա.

		-- ��ʾ�ӳ����
		if(g_iTeamMemberCount_Team > 0) then
			ShwoLeaderFlat(1);
		end;

		for i = 0, g_iTeamMemberCount_Team - 1 do

			TeamFrame_RefreshTeamMember_Team(i);

		end;
		Team_Show();
end


------------------------------------------------------------------------------------------------------------------
--
-- �������Ҵ򿪽���
--
function TeamFrame_OpenCreateTeamSelf()

		-- ���ui����
		ClearUIModel();

		-- �����������
		HideDeadFlag();

		-- ���ص��߱��
		HideDeadLinkFlag();

		-- ���ضӳ����
		ShwoLeaderFlat(0);

		-- ��ʾ��ȷ����ʾ����
		Team_Button_Frame0:Hide();
		Team_Button_Frame1:Hide();
		Team_Button_Frame2:Hide();
		Team_Button_Frame3:Hide();
		Team_Button_Frame4:Hide();
		Team_Button_Frame5:Hide();
		Team_Button_Frame6:Hide();
--		Team_Button_Frame7:Hide();

		-- ���ð�ť����
		Team_Button_Frame6:Show();
		Team_Button_Frame6:Enable();
		Team_Button_Frame6:SetText("T� l�p �i");
		Team_Name:SetText("#gFF0FA0Nh�m");

		-- ��ս���
		for i = 0, 5 do
			g_Team_PlayerInfo_Name[i]:SetText("");
			g_Team_PlayerInfo_School[i]:SetText("");
			g_Team_PlayerInfo_Level[i]:SetText("");

		end;
		
		SelectPos(0);
		Team_Show();
end


------------------------------------------------------------------------------------------------------------------
-- �������б�
--
function TeamFrame_OpenApplyList()


	ShwoLeaderFlat(0);
	-- ���ui����
	ClearUIModel();
	-- ��ս���
	for i = 0, 5 do
		g_Team_PlayerInfo_Name[i]:SetText("");
		g_Team_PlayerInfo_School[i]:SetText("");
		g_Team_PlayerInfo_Level[i]:SetText("");

	end;

	-- ���öԻ���Ĳ�������
	g_iTeamInfoType  = 1;
	g_iTeamInfoType = 1;
	

	-- ��ʾ��ȷ����ʾ����
	Team_Button_Frame0:Hide();
	Team_Button_Frame1:Hide();
	Team_Button_Frame2:Hide();
	Team_Button_Frame3:Hide();
	Team_Button_Frame4:Hide();
	Team_Button_Frame5:Hide();
	Team_Button_Frame6:Hide();
--	Team_Button_Frame7:Hide();

	Team_Button_Frame1:Show();
	Team_Button_Frame2:Show();
	Team_Button_Frame3:Show();
	Team_Button_Frame4:Show();
	Team_Button_Frame5:Show();
	Team_Button_Frame6:Show();
--	Team_Button_Frame7:Show();
	
	Team_Button_Frame2:Enable();
	Team_Button_Frame2:Disable();
	Team_Button_Frame3:Disable();
	Team_Button_Frame4:Disable();
	Team_Button_Frame5:Disable();
	Team_Button_Frame6:Disable();
--	Team_Button_Frame7:Disable();
	
	Team_Button_Frame1:SetText("Tin t�c nh�m");
	Team_Button_Frame2:SetText("Tr߾c");
	Team_Button_Frame3:SetText("Sau");
	Team_Button_Frame4:SetText("X�a h�t danh s�ch");
	Team_Button_Frame5:SetText("аng �");
	Team_Button_Frame6:SetText("T� ch�i");
	--Team_Button_Frame7:SetText("Che ng߶i ch�i");
	--Team_Button_Frame7:SetToolTip("Che ng߶i ch�i n�y");
	Team_Name:SetText("#gFF0FA0Danh s�ch � ngh�");


	-- �õ������˵ĸ���.
	g_iMemberCount_Apply = DataPool:GetApplyMemberCount();
	--AxTrace(0, 0, "^^�õ��������"..tostring(g_iMemberCount_Apply))

	if(0 == g_iMemberCount_Apply) then
		this:Hide();
		return;
	end

	-- ���õ�ǰ��ʾ��ҳ��.
	g_iCurShowPage_Apply = 0;

	-- ���õ�ǰѡ�������.
	g_iCurSel_Apply = 0;

	-- ˢ�µ�ǰҳ��.
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);

	-- �ӵ�0ҳ��ʼ.
	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);


	-- ��ֹ���ҳ
	if(g_iCurShowPage_Apply < iPageCount) then
		Team_Button_Frame3:Enable();
	end

	Team_Button_Frame4:Enable();
	Team_Button_Frame5:Enable();
	Team_Button_Frame6:Enable();
--	Team_Button_Frame7:Enable();
	
	Team_Show();


end


------------------------------------------------------------------------------------------------------------------
-- ��������Ϣ
--
function TeamFrame_OpenInvite()

	--���ui����
	ClearUIModel();

	g_iSel = -1;

	-- ���öԻ���Ĳ�������
	g_iTeamInfoType = 2;
	g_iTeamInfoType  = 2;

	-- ��ʾ��ȷ����ʾ����
	Team_Button_Frame0:Hide();
	Team_Button_Frame1:Hide();
	Team_Button_Frame2:Hide();
	Team_Button_Frame3:Hide();
	Team_Button_Frame4:Hide();
	Team_Button_Frame5:Hide();
	Team_Button_Frame6:Hide();
--	Team_Button_Frame7:Hide();

	Team_Button_Frame3:Show();
	Team_Button_Frame4:Show();
	Team_Button_Frame5:Show();
	Team_Button_Frame6:Show();
--	Team_Button_Frame7:Show();

	Team_Button_Frame3:Enable();
	Team_Button_Frame4:Enable();
	Team_Button_Frame5:Enable();
	Team_Button_Frame6:Enable();
--	Team_Button_Frame7:Enable();

	Team_Button_Frame3:SetText("Tr߾c");
	Team_Button_Frame4:SetText("Sau");
	Team_Button_Frame5:SetText("аng �");
	Team_Button_Frame6:SetText("T� ch�i");
--	Team_Button_Frame7:SetText("Che ng߶i ch�i");
--	Team_Button_Frame7:SetToolTip("Che ng߶i ch�i n�y");
	Team_Name:SetText("#gFF0FA0L�i m�i khung c�a s� n�i chuy�n");

	-- �õ��������ĸ���.
	g_iTeamCount_Invite   = DataPool:GetInviteTeamCount();
	if( g_iTeamCount_Invite == 0 ) then
		this:Hide();
		return;
	end
	-- ��ǰѡ�������
	g_iCurShowTeam_Invite = 0;

	-- ��ֹ��ǰ��ҳ
	if(0 == g_iCurShowTeam_Invite) then
		Team_Button_Frame3:Disable();
	end

	-- ��ֹ���ҳ
	if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then
		Team_Button_Frame4:Disable();
	end

	-- ��ʾ������Ϣ
	TeamFrame_RefreshTeamInfo_Invite();

	if(0 == g_iTeamCount_Invite) then

		Team_Button_Frame5:Disable();
		Team_Button_Frame6:Disable();
	end;
	
	-- ���ضӳ����
	ShwoLeaderFlat(1);
	Team_Show();
end


------------------------------------------------------------------------------------------------------------------
-- �򿪶ӳ�������Ϣ
--
function TeamFrame_OpenLeaderTeamInfo()

	-- ���ui����
	ClearUIModel();

	-- �����������
	HideDeadFlag();

	-- ���ص��߱��
	HideDeadLinkFlag();

	-- ���ضӳ����
	ShwoLeaderFlat(0);

	g_iSel = -1;

	-- ���öԻ���Ĳ�������
	g_iTeamInfoType = 0;
	
	Team_Follow_Button:Show();

	-- ��ʾ��ȷ����ʾ����
	Team_Button_Frame0:Show();
	Team_Button_Frame1:Show();
	Team_Button_Frame2:Show();
	Team_Button_Frame3:Show();
	Team_Button_Frame4:Show();
	Team_Button_Frame5:Show();
	Team_Button_Frame6:Show();
--	Team_Button_Frame5:Hide();

	Team_Button_Frame0:Enable();
	Team_Button_Frame1:Enable();
	Team_Button_Frame2:Enable();
	if( g_iSel == -1 ) then
		Team_Button_Frame3:Disable();
	else
		Team_Button_Frame3:Enable();
	end
	Team_Button_Frame4:Enable();
	Team_Button_Frame5:Enable();
	Team_Button_Frame6:Enable();
	--Team_Button_Frame5:Disable();

	Team_Button_Frame0:SetText("Ы ngh�");
	Team_Button_Frame1:SetText("Gi�i t�n");
	Team_Button_Frame2:SetText("R�i kh�i");
	Team_Button_Frame3:SetText("M�i ra");
	Team_Button_Frame4:SetText("Tr߷ng");
	Team_Button_Frame5:SetText("H�o h�u");
	Team_Button_Frame6:SetText("M�i k�t h�o h�u");
	--Team_Button_Frame7:SetToolTip("");--������治��ʾtooltips
	Team_Name:SetText("#gFF0FA0Th�ng tin nh�m");

	Team_Update_ExpMode( 1 );
	-- ���ؼ�Ϊ����
	Team_Button_Frame6:Hide();
	-- ��ǰ�����ж�Ա�ĸ���.
	g_iTeamMemberCount_Team = DataPool:GetTeamMemberCount();
	if( g_iTeamMemberCount_Team <= 0 ) then
		this:Hide();
		return;
	end;
	-- ���õ�ǰѡ��,
	g_iCurSel_Team = 0;

	-- ��ս���
	for i = 0, 5 do
		g_Team_PlayerInfo_Name[i]:SetText("");
		g_Team_PlayerInfo_School[i]:SetText("");
		g_Team_PlayerInfo_Level[i]:SetText("");

	end;

	-- ��ʾ�ӳ����
	if(g_iTeamMemberCount_Team > 0) then
		ShwoLeaderFlat(1);
	end;

	-- ˢ��ÿ����Ա.
	for i = 0, g_iTeamMemberCount_Team - 1 do

		TeamFrame_RefreshTeamMember_Team(i);

	end;
	
	-- ѡ���һ��
	SelectPos(0);
	Team_Show();
end



------------------------------------------------------------------------------------------------------------------
-- �����������Ϣ
--
function TeamFrame_RefreshTeamInfo_Invite()

	for i = 0, 5 do
			g_Team_PlayerInfo_Name[i]:SetText("");
			g_Team_PlayerInfo_School[0]:SetText("");
			g_Team_PlayerInfo_Level[i]:SetText("");

	end

	-- �õ����ѵĸ���
	if(-1 == g_iCurShowTeam_Invite) then

		return;
	end

	local iTeamMemberCount = DataPool:GetInviteTeamMemberCount(g_iCurShowTeam_Invite);

	for MemberIndex = 0, iTeamMemberCount - 1 do
		-- ��ʾһ����Ա
		--ShwoLeaderFlat(1);
		TeamFrame_RefreshTeamMember_Invite(MemberIndex);
	end


end



-------------------------------------------------------------------------------------------------------------------
-- ˢ��ĳһ����Ա����Ϣ, �򿪽���.
--
function TeamFrame_RefreshTeamMember_Invite(index)

		local szNick;		-- �ǳ�
		local iFamily;	-- ����
		local iLevel;	  -- �ȼ�
		local iCapID;		-- ñ��
		local iHead;		-- ͷ
		local iArmourID;-- ����
		local iCuffID;  -- ����
		local iFootID;	-- ��
		local iWeaponID;-- ����

		-- �õ���Ա����ϸ��Ϣ
		szNick
		,iFamily
		,iLevel
		,iCapID
		,iHead
		,iArmourID
		,iCuffID
		,iFootID
		,iWeaponID
		= DataPool:GetInviteTeamMemberInfo( g_iCurShowTeam_Invite, index );


		g_Team_PlayerInfo_Name[index]:SetText(tostring(szNick));
		g_Team_PlayerInfo_School[index]:SetText(tostring(iFamily));
		g_Team_PlayerInfo_Level[index]:SetText(tostring(iLevel));

		local strModelName = DataPool:GetInviteTeamMemberUIModelName( g_iCurShowTeam_Invite, index);

		-- ��ʾ������Ϣ
		ShowFamily(index, iFamily);

		-- ��ʾģ��
		--AxTrace( 0,0, "==�������Ķ�Ա����"..tostring(strModelName).."λ��"..tostring(index));
		g_TeamFrame_FakeObject[index]:SetFakeObject("");
		g_TeamFrame_FakeObject[index]:SetFakeObject(strModelName);

end



-------------------------------------------------------------------------------------------------------------------
-- �򿪶������������ǰ��ҳ
--
function TeamFrame_PageUp()

	-- ��ǰ��һҳ
	g_iCurShowTeam_Invite = g_iCurShowTeam_Invite - 1;
	if(g_iCurShowTeam_Invite < 0) then
		g_iCurShowTeam_Invite = 0;
	end
	
	--AxTrace( 0,0, "�õ��������ı��"..tostring(g_iCurShowTeam_Invite));
		
	-- ��ֹ��ǰ��ҳ
	if(0 == g_iCurShowTeam_Invite) then
		Team_Button_Frame3:Disable();
	end

	-- ��ֹ���ҳ
	if(g_iCurShowTeam_Invite < (g_iTeamCount_Invite - 1)) then
		Team_Button_Frame4:Enable();
	end


	-- ���õ�ǰѡ�еĶ���.
	g_iRealSelInvitorIndex = g_iCurShowTeam_Invite;
	
	ClearUIModel();
	-- ˢ�µ�ǰ����
	TeamFrame_RefreshTeamInfo_Invite();

end



-------------------------------------------------------------------------------------------------------------------
-- �򿪶�������������ҳ
--
function TeamFrame_PageDown()

	-- ���һҳ
	g_iCurShowTeam_Invite = g_iCurShowTeam_Invite + 1;
	if(g_iCurShowTeam_Invite >=  (g_iTeamCount_Invite - 1)) then
		g_iCurShowTeam_Invite = g_iCurShowTeam_Invite;
	end

	-- ��ֹ���ҳ
	if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then
		Team_Button_Frame4:Disable();
	end

	-- ����ǰ��
	if(g_iCurShowTeam_Invite > 0) then
		Team_Button_Frame3:Enable();
	end

	-- ���õ�ǰѡ�еĶ�������.
	g_iRealSelInvitorIndex = g_iCurShowTeam_Invite;
	ClearUIModel();
	-- ˢ�µ�ǰ����
	TeamFrame_RefreshTeamInfo_Invite();

end



-------------------------------------------------------------------------------------------------------------------
-- ��������ܾ��������
--
function TeamFrame_RejectJoinTeam_Invite()

		--AxTrace( 0,0, "����������1"..tostring(g_iTeamCount_Invite));
		-- û��������鷵��
		if(0 == g_iTeamCount_Invite) then

			return;
		end;

		-- ���;ܾ����������Ϣ.
		-- Player:RejectJoinTeam();
		--AxTrace( 0,0, "�������ѡ��1"..tostring(g_iRealSelInvitorIndex));
		Player:RejectJoinTeam(g_iRealSelInvitorIndex);

		g_iTeamCount_Invite = g_iTeamCount_Invite - 1;
		--AxTrace( 0,0, "����������2"..tostring(g_iTeamCount_Invite));
		if(g_iTeamCount_Invite <= 0) then

			-- �رս���
			Team_Close();
			return;
		end

		--
		if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then

			g_iCurShowTeam_Invite = g_iTeamCount_Invite - 1;
		end

		-- ���õ�ǰѡ��Ķ��顣		
		g_iRealSelInvitorIndex = g_iCurShowTeam_Invite;
		-- ��ֹ��ǰ��ҳ
		if(0 == g_iCurShowTeam_Invite) then

			Team_Button_Frame3:Disable();

		else

			Team_Button_Frame3:Enable();

		end


		-- ��ֹ���ҳ
		if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then

			Team_Button_Frame4:Disable();

		else

			Team_Button_Frame4:Enable();

		end

		-- ��ʾ������Ϣ
		TeamFrame_RefreshTeamInfo_Invite();


end


-------------------------------------------------------------------------------------------------------------------
-- �����������ͬ��������
--
function TeamFrame_AgreeJoinTeam_Invite()


		-- û��������鷵��
		--AxTrace( 0,0, "��������������ͬ��"..tostring(g_iTeamCount_Invite));
		if(0 == g_iTeamCount_Invite) then

			return;
		end;

		-- ͬ��������
		-- Player:AgreeJoinTeam();
		--AxTrace( 0,0, "�������ѡ�񣽣�ͬ�� "..tostring(g_iRealSelInvitorIndex));
		Player:AgreeJoinTeam(g_iRealSelInvitorIndex);

		-- �رս���, ��һ�δ����Խ�����.
		g_iTeamInfoType = 4;
		
		-- ���ؽ���
		Team_Close();
end



--------------------------------------------------------------------------------------------------------------------
-- �رմ����¼�
--
function TeamFrame_CloseWindow()

	--if( g_iTeamInfoType == 1 ) then
		TeamFrame_RejectJoinTeam_Apply();
	--elseif(g_iTeamInfoType == 2) then
		--TeamFrame_RejectJoinTeam_Invite();
	--end
	
	Team_Close();


end



--------------------------------------------------------------------------------------------------------------------
-- ˢ�¶�Ա��Ϣ, ����ͨ������Ϣ
--
function TeamFrame_RefreshTeamMember_Team(index)

	local szNick;		-- �ǳ�
	local iFamily;	-- ����
	local iLevel;	  -- �ȼ�
	--local iCapID;		-- ñ��
	--local iHead;		-- ͷ
	--local iArmourID;-- ����
	--local iCuffID;  -- ����
	--local iFootID;	-- ��
	--local iWeaponID;-- ����
	local bDeadlink;
	local bDead;
	local bSex;


	-- �õ���Ա����ϸ��Ϣ
	szNick
	,iFamily
	,iLevel
	--,iCapID
	--,iHead
	--,iArmourID
	--,iCuffID
	--,iFootID
	--,iWeaponID
	,bDead
	,bDeadlink
	,bSex
	= DataPool:GetTeamMemInfoByIndex( index );


	g_Team_PlayerInfo_Name[index]:SetText(tostring(szNick));
	g_Team_PlayerInfo_School[index]:SetText(tostring(iFamily));
	g_Team_PlayerInfo_Level[index]:SetText(tostring(iLevel));
	
	--AxTrace(0, 0, "����������Ϣ"..tostring(bDead)..tostring(bDead).."����"..tostring(index));
	if(bDead > 0) then
		g_Team_PlayerInfo_Dead[index]:Show();
	end;

	if(bDeadlink > 0) then
		-- ���߱��
		g_Team_PlayerInfo_Deadlink[index]:Show();
	end;

	-- ��ʾ������Ϣ
	ShowFamily(index, iFamily);


	-- �õ�uiģ����Ϣ
	local strModelName = DataPool:GetTeamMemUIModelName(index);

	--AxTrace( 0,0, tostring(strModelName));
	-- ��ʾģ��
	g_TeamFrame_FakeObject[index]:SetFakeObject(strModelName);
	--AxTrace(0, 0, "ˢ��"..tostring(strModelName));
	
	
	local bIsInScene = DataPool:IsTeamMemberInScene(index);
	if(0 == bIsInScene) then
	
		--AxTrace( 0,0, "��ʾ���� --"..tostring(index));
		g_Team_Ui_Model_Disable[index]:Show();
	else
	
		--AxTrace( 0,0, "�������� = "..tostring(index));
		g_Team_Ui_Model_Disable[index]:Hide();
	end;

end



--------------------------------------------------------------------------------------------------------------------
-- ˢ�µ�ǰҳ����Ϣ, ���������
--
function TeamFrame_RefreshCurShowApplyPage_Apply(index)

	ClearUIModel();
	
	ShwoLeaderFlat(0);
	-- ��վɵĽ���.
	for iUI = 0, 5 do
			g_Team_PlayerInfo_Name[iUI]:SetText("");
			g_Team_PlayerInfo_School[iUI]:SetText("");
			g_Team_PlayerInfo_Level[iUI]:SetText("");

	end

	if(g_iMemberCount_Apply <= 0) then

		-- ���������ߵĸ���С�ڵ���0 , ��ˢ�½���Ū
		return;

	end


	-- ��Ա��Ϣ.
	local szNick;		-- �ǳ�
	local iFamily;	-- ����
	local iLevel;	  -- �ȼ�
	local iCapID;		-- ñ��
	local iHead;		-- ͷ
	local iArmourID;-- ����
	local iCuffID;  -- ����
	local iFootID;	-- ��
	local iWeaponID;-- ����


	local iCurShowStart = index * g_iCurPageShowCount;
	local iCurShowEnd   = iCurShowStart + g_iCurPageShowCount;
	local iUIIndex = 0;

	if(iCurShowEnd > g_iMemberCount_Apply) then

		iCurShowEnd = g_iMemberCount_Apply;
	end;

	for i = iCurShowStart, iCurShowEnd - 1 do

		-- ˢ�µ�ǰ�����ÿһ����������Ϣ.

		-- �õ���Ա����ϸ��Ϣ
		szNick
		,iFamily
		,iLevel
		,iCapID
		,iHead
		,iArmourID
		,iCuffID
		,iFootID
		,iWeaponID
		= DataPool:GetApplyMemberInfo(i);

		g_Team_PlayerInfo_Name[iUIIndex]:SetText(tostring(szNick));
		g_Team_PlayerInfo_School[iUIIndex]:SetText(tostring(iFamily));
		g_Team_PlayerInfo_Level[iUIIndex]:SetText(tostring(iLevel));

		-- ��ʾ������Ϣ
		ShowFamily(iUIIndex, iFamily);

		-- �õ�uiģ����Ϣ
		local strModelName = DataPool:GetApplyMemberUIModelName(i);

		-- ��ʾģ��
		g_TeamFrame_FakeObject[iUIIndex]:SetFakeObject(strModelName);

		iUIIndex = iUIIndex + 1;

	end
	
	SelectPos(0);

end



--------------------------------------------------------------------------------------------------------------------
-- ���������, ѡ��һ��������
--
function TeamFrame_SetCurSelectedApply_Apply(index)

	if(0 == g_iMemberCount_Apply) then

		--���û��������, ����.
		return;
	end

	-- ת����ǰʵ��ѡ���������.
	local iCurSelApply = g_iCurShowPage_Apply * g_iCurPageShowCount + index;

	-- ����������Ա��������.
	--if(iCurSelApply >= g_iMemberCount_Apply) then

	--	return;
	--end;

	-- ����ѡ��������
	-- ʵ������, ���ǽ�������
	g_iRealSelApplyIndex = iCurSelApply;       
	--DataPool:SetCurSelApply(iCurSelApply);
	g_iCurSelApply_Apply = iCurSelApply;
	
end


--------------------------------------------------------------------------------------------------------------------
-- ���������, ͬ��������
--
function TeamFrame_AgreeJoinTeam_Apply(index)

	if(g_iCurSelApply_Apply >= g_iMemberCount_Apply) then
		
		return;
	end
	-- ͬ��������
	--Player:SendAgreeJoinTeam_Apply();
	Player:SendAgreeJoinTeam_Apply(g_iRealSelApplyIndex);
	
	g_iMemberCount_Apply = g_iMemberCount_Apply - 1;

	if(g_iMemberCount_Apply <= 0) then

		Team_Close();
		-- �´δ򿪽����Ƕӳ������Ķ�����Ϣ
		--DataPool:SetTeamFrameOpenFlag(3);
		g_iTeamInfoType = 0;
	end

	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);

	if(g_iCurShowPage_Apply >= iPageCount) then

		-- �����µ���ʾҳ
		g_iCurShowPage_Apply = iPageCount;

	end;

	-- ɾ��һ��������
	DataPool:EraseApply(g_iCurSelApply_Apply);
	-- ˢ���µ��������
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);

end


--------------------------------------------------------------------------------------------------------------------
-- ���������, �ܾ��������
--
function TeamFrame_RejectJoinTeam_Apply(index)

	if(g_iCurSelApply_Apply >= g_iMemberCount_Apply) then
		
		return;
	end
	-- ���;ܾ����������Ϣ.
	--Player:SendRejectJoinTeam_Apply();
	Player:SendRejectJoinTeam_Apply(g_iRealSelApplyIndex);
	
	g_iMemberCount_Apply = g_iMemberCount_Apply - 1;

	if(g_iMemberCount_Apply <= 0) then

		Team_Close();
		-- �´δ򿪽����Ƕӳ������Ķ�����Ϣ
		--DataPool:SetTeamFrameOpenFlag(3);
		g_iTeamInfoType = 0;
	end

	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);

	if(g_iCurShowPage_Apply >= iPageCount) then

		-- �����µ���ʾҳ
		g_iCurShowPage_Apply = iPageCount;

	end;

	-- ɾ��һ��������
	DataPool:EraseApply(g_iCurSelApply_Apply);
	-- ˢ���µ��������
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);
	Team_Show();
end



-------------------------------------------------------------------------------------------------------------------
-- �򿪶������������ǰ��ҳ
--
function TeamFrame_PageUp_Apply()

	-- �ӵ�0ҳ��ʼ.
	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);


	-- ��ǰ��һҳ
	g_iCurShowPage_Apply = g_iCurShowPage_Apply - 1;
	if(g_iCurShowPage_Apply < 0) then
		g_iCurShowPage_Apply = 0;
	end

	-- ��ֹ��ǰ��ҳ
	--if(0 == g_iCurShowTeam_Invite) then
	if(0 == g_iCurShowPage_Apply) then
		Team_Button_Frame2:Disable();
	end

	-- ��ֹ���ҳ
	if(g_iCurShowPage_Apply < iPageCount) then
		Team_Button_Frame3:Enable();
	end


	ClearUIModel();
	-- ˢ�µ�ǰ����
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);


end



-------------------------------------------------------------------------------------------------------------------
-- �򿪶�������������ҳ
--
function TeamFrame_PageDown_Apply()

	-- �ӵ�0ҳ��ʼ.
	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);


	-- ���һҳ
	g_iCurShowPage_Apply = g_iCurShowPage_Apply + 1;
	if(g_iCurShowPage_Apply >=  iPageCount ) then

		g_iCurShowPage_Apply = iPageCount;
	end

	-- ��ֹ���ҳ
	if(g_iCurShowPage_Apply >= iPageCount) then
		Team_Button_Frame3:Disable();
	end

	-- ����ǰ��
	if(g_iCurShowPage_Apply > 0) then
		Team_Button_Frame2:Enable();
	end

	ClearUIModel();
	-- ˢ�µ�ǰ����
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);

end


--------------------------------------------------------------------------------------------------------------------
--
-- ���ui����
--
function ClearUIModel()

	g_TeamFrame_FakeObject[0]:SetFakeObject("");
	g_TeamFrame_FakeObject[1]:SetFakeObject("");
	g_TeamFrame_FakeObject[2]:SetFakeObject("");
	g_TeamFrame_FakeObject[3]:SetFakeObject("");
	g_TeamFrame_FakeObject[4]:SetFakeObject("");
	g_TeamFrame_FakeObject[5]:SetFakeObject("");

	HideUIModelDisable();
end;


--------------------------------------------------------------------------------------------------------------------
--
-- ��ʾ����
--
function ShowFamily(MemIndex, Family)

	local strName = "Kh�ng c�";

	-- �õ���������.
	if(0 == Family) then
		strName = "Thi�u L�m";

	elseif(1 == Family) then
		strName = "Minh Gi�o";

	elseif(2 == Family) then
		strName = "C�i Bang";

	elseif(3 == Family) then
		strName = "V� �ang";

	elseif(4 == Family) then
		strName = "Nga My";

	elseif(5 == Family) then
		strName = "Tinh T�c";

	elseif(6 == Family) then
		strName = "Thi�n Long";

	elseif(7 == Family) then
		strName = "Thi�n S�n";

	elseif(8 == Family) then
		strName = "Ti�u Dao";

	elseif(9 == Family) then
		strName = "Kh�ng c�";
		
	elseif(10 == Family) then
		strName = "M� Dung";
	end

	-- ������ʾ������.
	g_Team_PlayerInfo_School[MemIndex]:SetText(strName);

end;

function HideDeadFlag()

	-- �������
	g_Team_PlayerInfo_Dead[0]:Hide();
	g_Team_PlayerInfo_Dead[1]:Hide();
	g_Team_PlayerInfo_Dead[2]:Hide();
	g_Team_PlayerInfo_Dead[3]:Hide();
	g_Team_PlayerInfo_Dead[4]:Hide();
	g_Team_PlayerInfo_Dead[5]:Hide();

end;

function HideDeadLinkFlag()

	-- ���߱��
	g_Team_PlayerInfo_Deadlink[0]:Hide();
	g_Team_PlayerInfo_Deadlink[1]:Hide();
	g_Team_PlayerInfo_Deadlink[2]:Hide();
	g_Team_PlayerInfo_Deadlink[3]:Hide();
	g_Team_PlayerInfo_Deadlink[4]:Hide();
	g_Team_PlayerInfo_Deadlink[5]:Hide();

end;

function ShwoLeaderFlat(bShow)

	if(0 == bShow) then

		Team_Captain_Icon:Hide();
	else

		Team_Captain_Icon:Show();
	end;

end;

function Team_Button_Abort_Team_Follow_Click()
	Player:StopFollow();
	Team_AbortTeamFollow_Button:Hide();
end

--ÿ�δ򿪽���ѡ��
function SelectPos(index)

		if(0 == index) then
			TeamFrame_Select1();
			Team_Model_1:SetCheck(1);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(1 == index) then
			TeamFrame_Select2();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(1);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(2 == index) then
			TeamFrame_Select3();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(1);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(3 == index) then
			TeamFrame_Select4();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(3);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(4 == index) then
			TeamFrame_Select5();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(1);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(5 == index) then
			TeamFrame_Select6();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(1);
			return
		end;
		
		
end


function ClearInfo()

	ShwoLeaderFlat(0);
	HideDeadFlag();
	HideDeadLinkFlag();
	
	-- ��վɵĽ���.
	for iUI = 0, 5 do
			g_Team_PlayerInfo_Name[iUI]:SetText("");
			g_Team_PlayerInfo_School[iUI]:SetText("");
			g_Team_PlayerInfo_Level[iUI]:SetText("");
	end

end;

function RefreshUIModel()
	-- ��ǰ�����ж�Ա�ĸ���.
	g_iTeamMemberCount_Team = DataPool:GetTeamMemberCount();
	if( g_iTeamMemberCount_Team <= 0 ) then
		return;
	end
	ClearUIModel();
	-- ˢ��ÿ����Ա.
	for i = 0, g_iTeamMemberCount_Team - 1 do

		-- �õ�uiģ����Ϣ
		local strModelName = DataPool:GetTeamMemUIModelName(i);

		-- ��ʾģ��
		g_TeamFrame_FakeObject[i]:SetFakeObject(strModelName);
	end;

end;


----------------------------------------------------------------------------------------
--
-- ����ģ��.
--
function HideUIModelDisable()

	g_Team_Ui_Model_Disable[0]:Hide();
	g_Team_Ui_Model_Disable[1]:Hide();
	g_Team_Ui_Model_Disable[2]:Hide();
	g_Team_Ui_Model_Disable[3]:Hide();
	g_Team_Ui_Model_Disable[4]:Hide();
	g_Team_Ui_Model_Disable[5]:Hide();

end;


-----------------------------------------------------------------------------------------
--
-- ���ͼ�Ϊ������Ϣ
--
function SendAddFriendMsg()

		local iGUID = Player:GetTeamMemberGUID(g_iSel);
		if(-1 == iGUID) then
			
			return;
		end
		
		DataPool:AddFriend(Friend:GetCurrentTeam(), iGUID);
end;

function Team_ExpMode_change()
	local mode, nIndex = Team_Exp_Mode:GetCurrentSelect();
	DataPool:SetTeamExpMode(nIndex);
end


function Team_Update_ExpMode( isTeam )
	if( tonumber( isTeam ) == -1 ) then
		Team_Exp_Mode:Hide();
		Team_Exp_Mode_Text:Hide();
		return
	end
	local expMode = DataPool:GetTeamExpMode();
	
	local isLeader = Player:IsLeader();
	AxTrace( 0,0, "update expmode = "..tostring( expMode ).." Leader = "..tostring( isLeader ) );
	if( tonumber( isLeader ) == 0 ) then --���Ƕӳ�
		if( expMode == 1 ) then
			Team_Exp_Mode_Text:SetText( "Ph�n ph�i ri�ng" );
		elseif( expMode == 0 ) then
			Team_Exp_Mode_Text:SetText( "Ph�n ph�i �u" );
		else
			Team_Exp_Mode_Text:SetText( "M� th�c thu�n th�" );
		end
		Team_Exp_Mode_Text:Show();
		Team_Exp_Mode:Hide();
	else
		Team_Exp_Mode:SetCurrentSelect( expMode );
		Team_Exp_Mode_Text:Hide();
		Team_Exp_Mode:Show();
	end
end


function Team_Close()

	--if( g_iTeamInfoType == 1 ) then
		--g_iTeamInfoType = 0;
--	elseif (g_iTeamInfoType == 2) then
		--if(g_iTeamCount_Invite <= 0) then                 --����д��Ϊ�˱���ͬʱ�ӵ�������롣
			--g_iTeamInfoType = 4;
		--end
	--end
	
	this:Hide();
end

function Team_Show()

	this:Show();
end

-- ȷ�Ͻ�ɢ����
-- add by WTT		20090212
function Team_Confirm_Dismiss_Team ()

	Player:DismissTeam();						-- ��ɢ����
	Team_Close();										-- �ر���Ӵ���

end
