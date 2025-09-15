local g_MembersCtl = {};
local g_TabSel = -1;
local g_ListToMember;
local g_MemberSel = {};

local GUILD_REQUIRES_INFO = 1;	--ȫ�������Ա��Ϣ
local GUILD_MEMBERS_INFO = 2;		--ȫ����Ա��Ϣ
local GUILD_MANAGE_TAB_TEXT = {};
local g_ShowMsgFlag = false;


local g_positionInfo = {
	"#G��i ph� duy�t: ",
	" Bang ch�ng ",
	" Tinh Anh ",
	" Th߽ng Nh�n ",
	"S� gi� H�ng Hoa ",
	"S� gi� C�ng v� ",
	"S� gi� N�i v� ",
	"Ph� Bang Ch� ",
	"Bang Ch� ",
};

local g_menpaiInfo = {
	"Thi�u L�m",
	"Minh Gi�o",
	"C�i Bang",
	"V� �ang",
	"Nga My",
	"Tinh T�c",
	"Thi�n Long",
	"Thi�n S�n",
	"Ti�u Dao",
	"Kh�ng c�",
	"M� Dung",
};


function ConfraternityManage_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_SHOW_MEMBERINFO");
	this:RegisterEvent("GUILD_UPDATE_MEMBERINFO");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("GUILD_SELFEQUIP_CLICK");	
	this:RegisterEvent("SHOW_GUILDWAR_ANIMI");
end

function ConfraternityManage_OnLoad()
	g_MemberSel[GUILD_REQUIRES_INFO] = -1;
	g_MemberSel[GUILD_MEMBERS_INFO] = -1;
	
	GUILD_MANAGE_TAB_TEXT = {
		"H�i vi�n ",
		"Xin v�o ",
	};
	
end

function ConfraternityManage_OnEvent(event)
	Guild_Manage_SetCtl();
	
	if ( event == "UI_COMMAND") then
		if(tonumber(arg0) == 31 and this:IsVisible()) then
			Guild_Manage_Closed();
		elseif(tonumber(arg0) == 30) then
			Guild:AskGuildMembersInfo();	--����ÿ�δ򿪽����ʱ���������Ҫ����
		end
	elseif( event == "GUILD_SHOW_MEMBERINFO" ) then
		--׼������
		Guild:PrepareMembersInfomation();
		Guild_Manage_SelectTab(GUILD_MEMBERS_INFO);
		this:Hide();
		this:Show();
	elseif( event == "GUILD_UPDATE_MEMBERINFO" and this:IsVisible()) then
		--׼������
		Guild:PrepareMembersInfomation();
		Guild_Manage_SelectTab(g_TabSel);
	elseif( event == "GUILD_FORCE_CLOSE" ) then
		Guild_Manage_Closed();
	elseif( event == "ACCELERATE_KEYSEND" ) then
		Guild_Manage_HandleAccKey(arg0);
	elseif( event == "GUILD_SELFEQUIP_CLICK" ) then
		if(this:IsVisible()) then
			Guild_Manage_Closed();
		else
			Guild:AskGuildMembersInfo();	--����ÿ�δ򿪽����ʱ���������Ҫ����
		end
	elseif( event == "SHOW_GUILDWAR_ANIMI" ) then	--��ս�ı䡰�����ս��������ɫ ʹ�ò��Ű�ս�������¼�������Ժ������ʾ�Ͱ�ս������ͬ������ô��Ҫ�����µ��¼���
       local type = arg0;
		if(arg0=="show") then
                ConfraternityManage_7:SetText("#g0071BFBang h�i tuy�n chi�n");
                ConfraternityManage_7:SetToolTip("Bang h�i c�a b�ng h�u �ang bang chi�n");
        else
                ConfraternityManage_7:SetText("Bang h�i chi�n");
                ConfraternityManage_7:SetToolTip("");        
        end
	end

end

function Guild_Manage_SetCtl()
	g_MembersCtl = {
									list = ConfraternityManage_MemberList,
									header = ConfraternityManage_PageHeader,
									count = ConfraternityManage_Online,
									name = ConfraternityManage_Info1_Text,
									info = {
														{txt = ConfraternityManage_Info2_Text, msg = ConfraternityManage_Info2,},
														{txt = ConfraternityManage_Info3_Text, msg = ConfraternityManage_Info3,},
														{txt = ConfraternityManage_Info4_Text, msg = ConfraternityManage_Info4,},
														{txt = ConfraternityManage_Info5_Text, msg = ConfraternityManage_Info5,},
														{txt = ConfraternityManage_Info6_Text, msg = ConfraternityManage_Info6,},
														{txt = ConfraternityManage_Info7_Text, msg = ConfraternityManage_Info7,},
												 },
									desc = ConfraternityManage_Tenet,
									edit = ConfraternityManage_EditTenet,
									
									btn = {
													ConfraternityManage_1,
													ConfraternityManage_2,
													ConfraternityManage_3,
													ConfraternityManage_4,
													ConfraternityManage_5,
													ConfraternityManage_6,
													ConfraternityManage_7,
													ConfraternityManage_8		--add by xindefeng
											  },
																
									ConfraternityManage_Tab2,
									ConfraternityManage_Tab1,
								 };
 	local id=Player:GetData("GUILDLEAGUE")
	if id>=0 then
		ConfraternityManage_9:Enable();
	else
		ConfraternityManage_9:Disable();
	end 
end

function Guild_Manage_Clear()
	g_MembersCtl.list:ClearListBox();
	g_MembersCtl.header:SetText("");
	g_MembersCtl.count:SetText("");
	g_MembersCtl.name:SetText("");
	Guild_Manage_ClearInfo();
	g_MembersCtl.desc:SetText("");
	g_MembersCtl.desc:Show();
	
	g_MembersCtl.edit:SetText("");
	g_MembersCtl.edit:SetProperty("CaratIndex", 1024);
	g_MembersCtl.edit:Hide();
	
	g_ListToMember = nil;
end

function Guild_Manage_ClearInfo()
	local i = 1;
	while g_MembersCtl.info[i] ~= nil do
		g_MembersCtl.info[i].txt:SetText("");
		g_MembersCtl.info[i].msg:SetText("");
		i=i+1;
	end
end

function Guild_Manage_SelectTab( idx )
	if(idx <= 0 or idx == nil or idx > 2) then
		return;
	end
	Guild:CloseKickGuildBox();
	Guild_Manage_SetTabColor(idx);
	
	--��ս�����ʾ
	Guild_Manage_Clear();
	--��ʼ���½���
	if( Guild:GetMembersNum(5) == 0 ) then
		g_TabSel = 2;		--֮����Ҫ����������Ϊ�߻�Ҫ��Tab2������ʾ����״̬
	end
	g_TabSel = idx;
	Guild_Manage_BtnSet();
	Guild_Manage_Update()
end

--�����ڶ���Tab,����û����
function Guild_PlayTab2()
	if( this: IsVisible() and Guild:GetMembersNum(5) > 0 ) then
		if( ConfraternityManage_Tab2 : GetCheck() == 0 ) then
			ConfraternityManage_Tab2 : SetCheck(1);
		else
			ConfraternityManage_Tab2 : SetCheck(0);
		end
	else
		KillTimer("Guild_PlayTab2()");
		--�ָ�״̬
		ConfraternityManage_Tab2 : SetCheck(0);	
		
	end
end

function Guild_Manage_BtnSet()
	--��ť��ʾ����
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		g_MembersCtl.btn[1]:Show();
		g_MembersCtl.btn[2]:Show();
		g_MembersCtl.btn[3]:Show();
		--g_MembersCtl.btn[4]:Show();
		g_MembersCtl.btn[5]:Show();
		g_MembersCtl.btn[7]:Show();
		g_MembersCtl.btn[8]:Show();		--add by xindefeng
		
		g_MembersCtl.btn[1]:SetText("B� nhi�m ");
		g_MembersCtl.btn[2]:SetText("�u�i ra");
		g_MembersCtl.btn[3]:SetText("Nh߶ng ng�i");
		g_MembersCtl.btn[4]:SetText("Gi�i t�n");
		g_MembersCtl.btn[5]:SetText("S�a �i t�n ch�");
		g_MembersCtl.btn[6]:SetText("R�i kh�i");
	elseif(g_TabSel == GUILD_REQUIRES_INFO) then
		if( Guild:GetMembersNum(5) == 0 ) then --���û�����������
			if g_ShowMsgFlag == false then
				PushDebugMessage("B�n bang tr߾c m�t ch�a c� h�i vi�n d� b�");
			else
				g_ShowMsgFlag = false;
			end
			g_TabSel = GUILD_MEMBERS_INFO;
			ConfraternityManage_Tab2 : FlashMe(0);
			Guild_Manage_BtnSet(g_TabSel);
			ConfraternityManage_Tab2 : Disable();
			--KillTimer("Guild_PlayTab2()");
			return;
		else
			ConfraternityManage_Tab2 : FlashMe(1);
			ConfraternityManage_Tab2 : Enable();
		end
		g_MembersCtl.btn[1]:Show();
		g_MembersCtl.btn[2]:Show();
		g_MembersCtl.btn[3]:Hide();
		g_MembersCtl.btn[4]:Hide();
		g_MembersCtl.btn[5]:Hide();
		g_MembersCtl.btn[7]:Hide();
		g_MembersCtl.btn[8]:Hide();	--add by xindefeng
		
		g_MembersCtl.btn[1]:SetText("Ti�p nh�n");
		g_MembersCtl.btn[2]:SetText("C� tuy�t");
		g_MembersCtl.btn[6]:SetText("R�i kh�i");
	end
	
	--��ťEnable��Disable����
	local szPower = Guild:GetMyGuildPower(); --"1111111111" ��10��λ�ô���10��Ȩ��
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		--ְ�����Ȩ1
		Guild_Manage_BtnEnableDisable(szPower,1,1);
		--Ȩ�޵���Ȩ2
		--��������Ȩ4
		Guild_Manage_BtnEnableDisable(szPower,4,2);
		--����Ȩ5
		Guild_Manage_BtnEnableDisable(szPower,5,3);
		--֧ȡ����Ȩ6
		--������Ȩ7
		--�뿪���Ȩ8
		--��ɢ���Ȩ9
		Guild_Manage_BtnEnableDisable(szPower,9,4);
		--�޸İ����ּȨ10
		Guild_Manage_BtnEnableDisable(szPower,10,5);
	elseif(g_TabSel == GUILD_REQUIRES_INFO) then
		--���հ���Ȩ3
		Guild_Manage_BtnEnableDisable(szPower,3,1);
		Guild_Manage_BtnEnableDisable(szPower,3,2);
	end
	
	if( Guild:GetMembersNum(5) == 0 ) then --���û�����������
		ConfraternityManage_Tab2_Mask : SetToolTip("B�n bang tr߾c m�t ch�a c� h�i vi�n d� b�");
		ConfraternityManage_Tab2_Mask : Enable();
		ConfraternityManage_Tab2:Disable();
	else
		ConfraternityManage_Tab2 : SetToolTip("Hi�n t�i c� h�i vi�n d� b� mu�n gia nh�p v�o b�n bang");
		ConfraternityManage_Tab2_Mask : Disable();
		ConfraternityManage_Tab2:Enable();
		ConfraternityManage_Tab2 : FlashMe(1);
	end
end

function Guild_Manage_BtnEnableDisable(szPower, szidx, btnidx)
	local iPower = string.byte(szPower,szidx);
	if(iPower == 48) then			--'0'
		g_MembersCtl.btn[btnidx]:Disable();
	elseif(iPower == 49) then  --'1'
		g_MembersCtl.btn[btnidx]:Enable();
	end
end

function Guild_Manage_Update()
	if(g_TabSel <= 0 or g_TabSel > 2) then
		return;
	end
	if( g_TabSel == GUILD_MEMBERS_INFO ) then
		g_MembersCtl[g_TabSel]:SetCheck(1);
	elseif( Guild:GetMembersNum(5) > 0 ) then
		g_MembersCtl[g_TabSel]:SetCheck(1);
	else
		g_MembersCtl[GUILD_MEMBERS_INFO]:SetCheck(0);
	end
	
	--�Լ���������
	--local szMsg = Guild:GetMyGuildInfo("Name");
	--g_MembersCtl.header:SetText(szMsg .. "����Ա����");
	--20060710���߻�Ҫ��ֻ��ʾ��Ա����
	g_MembersCtl.header:SetText("#gFF0FA0Qu�n l� h�i vi�n");
	
	--�Լ�������ּ
	szMsg = Guild:GetMyGuildInfo("Desc");
	g_MembersCtl.desc:SetText(szMsg);
	
	--����
	g_MembersCtl.count:SetText("H�i vi�n: "..Guild:GetMembersNum(3).."/"..Guild:GetMembersNum(2));
	
	--��Ա�б�
	g_ListToMember = {};
	local listidx = 0;
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		--local totalNum = Guild:GetMembersNum(1);
		local totalNum = Guild:GetMembersNum(4);
		local i = 0;
		
		while i < totalNum do
			--if( -1 ~= Guild:GetMembersInfo(i, "GUID")) then
				--��Ч������
				--if(GUILD_REQUIRES_INFO ~= Guild:GetMembersInfo(i, "Position")) then
					--szMsg = Guild:GetMembersInfo(i, "Name");
					--g_MembersCtl.list:AddItem(g_positionInfo[Guild:GetMembersInfo(i, "Position")]..szMsg, listidx);
					--g_ListToMember[listidx] = i;
					--listidx = listidx + 1;
				--end
			--end
			local guildIdx = Guild:GetShowMembersIdx(i);
			local color,strTips = Guild:GetMembersInfo(guildIdx, "ShowColor");
			szMsg = Guild:GetMembersInfo(guildIdx, "Name");
			g_MembersCtl.list:AddItem(color..g_positionInfo[Guild:GetMembersInfo(guildIdx, "Position")]..szMsg, listidx);
			g_MembersCtl.list:SetItemTooltip(listidx,strTips);
			g_ListToMember[listidx] = guildIdx;
			
			listidx = listidx + 1;
			i = i + 1;
		end
	elseif(g_TabSel == GUILD_REQUIRES_INFO) then
		--local totalNum = Guild:GetMembersNum(1);
		local totalNum = Guild:GetMembersNum(5);
		local i = 0;

		while i < totalNum do
			--if( -1 ~= Guild:GetMembersInfo(i, "GUID")) then
				--��Ч������
				--if(GUILD_REQUIRES_INFO == Guild:GetMembersInfo(i, "Position")) then
					--szMsg = Guild:GetMembersInfo(i, "Name");
					--g_MembersCtl.list:AddItem(szMsg, listidx);
					--g_ListToMember[listidx] = i;
					--listidx = listidx + 1;
				--end
			--end
			local guildIdx = Guild:GetShowTraineesIdx(i);
			local color,strTips = Guild:GetMembersInfo(guildIdx, "ShowColor");
			szMsg = Guild:GetMembersInfo(guildIdx, "Name");
			g_MembersCtl.list:AddItem(color..g_positionInfo[Guild:GetMembersInfo(guildIdx, "Position")]..szMsg, listidx);
			g_MembersCtl.list:SetItemTooltip(listidx,strTips);
			g_ListToMember[listidx] = guildIdx;
			
			listidx = listidx + 1;
			i = i + 1;
		end
	end
	
	Guild_Manage_JudgeSelectMember();
end

function Guild_Manage_JudgeSelectMember()
	if(g_MemberSel[g_TabSel] < 0 or nil == g_ListToMember[g_MemberSel[g_TabSel]]
		 or g_MemberSel[g_TabSel] >= g_MembersCtl.list:GetItemNumber()) then
		g_MemberSel[g_TabSel] = -1;
		--Ĭ��ѡ���б���ĵ�һ����
		if(nil ~= g_ListToMember[0]) then
			g_MembersCtl.list:SetItemSelectByItemID(0);
			Guild_Manage_Selected();
		end		
	else
		--ѡ���ϴ�ѡ�е���
		g_MembersCtl.list:SetItemSelectByItemID(g_MemberSel[g_TabSel]);
		Guild_Manage_Selected();
	end
end

function Guild_Manage_Selected()
	g_MemberSel[g_TabSel] = g_MembersCtl.list:GetFirstSelectItem();
	Guild_Manage_SetMembersInfo(g_MemberSel[g_TabSel]);
	Guild:CloseKickGuildBox();
end

function Guild_Manage_SetMembersInfo( lidx )
	if(lidx < 0 or lidx == nil) then
		return;
	end
	
	Guild_Manage_ClearInfo();
	local szMsg;

	--����
	szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "Name");
	local szId;
	_,szId = Guild:GetMembersInfo(g_ListToMember[lidx], "GUID");
	g_MembersCtl.name:SetText(szMsg.."("..szId..")");
	
	--����
	szMsg = g_menpaiInfo[Guild:GetMembersInfo(g_ListToMember[lidx], "MenPai")+1];
	g_MembersCtl.info[1].txt:SetText("Ph�i:  ");
	g_MembersCtl.info[1].msg:SetText(szMsg);
	
	--�ȼ�
	szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "Level");
	g_MembersCtl.info[2].txt:SetText("C�p: ");
	g_MembersCtl.info[2].msg:SetText(szMsg);
	
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		--���׶�	
		--2006-12-7 19:44 TODO
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "CurCon").."/"..Guild:GetMembersInfo(g_ListToMember[lidx], "MaxCon");
		--szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "CurCon");
		g_MembersCtl.info[3].txt:SetText("е c�ng hi�n: ");
		g_MembersCtl.info[3].msg:SetText(szMsg);
		--���ʱ��
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "JoinTime");
		g_MembersCtl.info[4].txt:SetText("Ng�y v�o bang: ");
		g_MembersCtl.info[4].msg:SetText(szMsg);
		--����ʱ��
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "LogOutTime");
		g_MembersCtl.info[5].txt:SetText("Th�i gian l�n m�ng:");
		g_MembersCtl.info[5].msg:SetText(szMsg);
		--ÿ�ܹ��׶�
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "ContriPerWeek");
		g_MembersCtl.info[6].txt:SetText("C�ng hi�n tu�n n�y:");
		g_MembersCtl.info[6].msg:SetText(szMsg);
	end
end
function Show_PopMenu()
	local index = ConfraternityManage_MemberList:GetFirstSelectItem();
	if( index > -1 ) then
		if(g_TabSel>0 and g_TabSel<3)then
			Guild:Show_PopMemu(tonumber(index),tonumber(g_TabSel));
		end
	end
	
end

function Guild_Manage_BtnClick( idx )
	if(g_TabSel < 0) then
		return;
	end
	
	Guild:CloseKickGuildBox();
	local iMember = g_ListToMember[g_MemberSel[g_TabSel]];
	if(nil ~= iMember) then
		if( idx == 1 ) then
			--btn1
			if(g_TabSel == GUILD_MEMBERS_INFO) then
				Guild:AskGuildAppointPosInfo(iMember);
			elseif(g_TabSel == GUILD_REQUIRES_INFO) then
				Guild:RecruitGuild(iMember);
				g_ShowMsgFlag = true;
			end
		elseif(idx == 2 ) then
			--btn2
			Guild:KickGuild(iMember);
			if(g_TabSel == GUILD_REQUIRES_INFO) then
				g_ShowMsgFlag = true;
			end
		end
	end
	
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		if(idx == 3 ) then
			--btn3
			Guild:DemisGuild();
		elseif(idx == 4 ) then
			--btn4
			Guild:DestoryGuild();
		elseif(idx == 5 ) then
			--btn5
			Guild_Manage_ChangeDesc();
		elseif(idx == 7 ) then
			--btn7
			if(nil ~= iMember) then
				local m_GUID = Guild:GetMembersInfo(iMember, "GUID");
				if(-1 ~= m_GUID) then
					DataPool:AddFriend(Friend:GetCurrentTeam(), m_GUID);
				end
			end
		--add & comment by xindefeng	
		--����:���������޸�ְλ�Ľ���
		--�ǰ���:����ֻ���Բ鿴ְλ�Ľ���
		elseif(idx == 8)then	--btn8
			Guild:AskCurCustomPositionName()
		end
		
	end

	if(idx == 6) then
		--btn6
		Guild_Manage_Closed();
	end
	
	if(idx == 10) then
		ConfraternityManage_DoCommerceNet();
	end
	
end

function Guild_Manage_CheckDetail()
	Guild:AskGuildDetailInfo();
	--Guild_Manage_Closed();
	Guild:CloseKickGuildBox();
end

function Guild_Manage_Closed()
	g_MemberSel[GUILD_REQUIRES_INFO] = -1;
	g_MemberSel[GUILD_MEMBERS_INFO] = -1;
	this:Hide();
end

function Guild_Manage_ChangeDesc()
	if(g_MembersCtl.edit:IsVisible()) then
		Guild_Manage_ChangeDescFin();
	elseif(g_MembersCtl.desc:IsVisible()) then
		Guild_Manage_ChangeDescBegin();
	end
end

function Guild_Manage_ChangeDescBegin()

	--���û�������������������һ�Σ�ע�⣺Player:IsLocked() == 0��ʾ����
	if Player:IsHavePassword() == 1 and Player:IsLocked() == 0 then
		OpenUnLockeMinorPasswordDlg()
		return
	end
	
	local szMsg = Guild:GetMyGuildInfo("Desc");
	
	g_MembersCtl.edit:SetText(szMsg);
	g_MembersCtl.edit:SetProperty("CaratIndex", 1024);
	g_MembersCtl.edit:SetProperty("DefaultEditBox", "True");
	g_MembersCtl.edit:Show();
	
	g_MembersCtl.desc:Hide();
	g_MembersCtl.btn[5]:SetText("S�a �i");
end

function Guild_Manage_ChangeDescFin()
	local szMsg = g_MembersCtl.edit:GetText();
	g_MembersCtl.edit:SetProperty("DefaultEditBox", "False");
	g_MembersCtl.edit:Hide();
	
	--g_MembersCtl.desc:SetText(szMsg);
	g_MembersCtl.desc:Show();
	
	Guild:FixGuildInfo("Desc", szMsg);
	g_MembersCtl.btn[5]:SetText("S�a �i t�n ch�");
end

function ConfraternityManage_Hidden()
	g_MembersCtl.edit:SetProperty("DefaultEditBox", "False");
	Guild:CloseKickGuildBox();
end

function Guild_Manage_HandleAccKey( op )
	if( op == "acc_guild") then
		if(this:IsVisible()) then
			Guild_Manage_Closed();
		else
			Guild:AskGuildMembersInfo();
		end
	end
end

function Guild_Manage_SetTabColor(idx)
	if(idx == nil or idx <= 0 or idx > 2) then
		return;
	end	
	
	local i = 1;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								ConfraternityManage_Tab2,
								ConfraternityManage_Tab1,
							};
	if( idx ==2 ) then
		if( Guild:GetMembersNum(5) == 0 ) then
				tab[1] : SetText( "#cbbbbbb" .. GUILD_MANAGE_TAB_TEXT[2]);
			else
				tab[1] : SetText( "#G" .. GUILD_MANAGE_TAB_TEXT[2]);
		end
	  tab[2] : SetText( noselColor..GUILD_MANAGE_TAB_TEXT[1] );
	else
		tab[2] : SetText( selColor..GUILD_MANAGE_TAB_TEXT[1] );
		if( Guild:GetMembersNum(5) == 0 ) then
			tab[1] : SetText( "#cbbbbbb" .. GUILD_MANAGE_TAB_TEXT[2]);
		else
			tab[1] : SetText( "#G" .. GUILD_MANAGE_TAB_TEXT[2]);
		end
	end


end

function ConfraternityManage_XuanZhan_BtnClick()
	City:OpenGuildWarDlg();
	Guild:CloseKickGuildBox();
end

function ConfraternityManage_DoLeagueInfo()
	GuildLeague:ShowInfoWindow();
end

function ConfraternityManage_DoCommerceNet()
	City:AskCityRoad(1);
end