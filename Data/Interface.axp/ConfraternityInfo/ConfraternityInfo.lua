-- ConfraternityInfo_Amount   ���id
-- ConfraternityInfo_CreateTime ����ʱ��
-- ConfraternityInfo_Create	������
-- ConfraternityInfo_Master	���ΰ���
-- ConfraternityInfo_City	����
-- ConfraternityInfo_Locus	���ڵ�
--	ConfraternityInfo_CBD		����
-- ConfraternityInfo_Specialty	��ǰ�о�
-- ConfraternityInfo_CityBuilding ��ǰ����
-- ConfraternityInfo_Level	��ģ
-- ConfraternityInfo_Info1	����
-- ConfraternityInfo_Info4	��ҵ��
-- ConfraternityInfo_Info5	ũҵ��
-- ConfraternityInfo_Info6	��ҵ��
-- ConfraternityInfo_Info7	������
-- ConfraternityInfo_Info8	�Ƽ���
-- ConfraternityInfo_Info9	���Ŷ�
-- ConfraternityInfo_Info3	�����ʽ�
-- ConfraternityInfo_Shangpiao ���������Ʊ��


function ConfraternityInfo_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_SHOW_DETAILINFO");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
	this:RegisterEvent("GUILD_SELFEQUIP_CLICK");
end

function ConfraternityInfo_OnLoad()
end

function ConfraternityInfo_OnEvent(event)
	if(event == "UI_COMMAND") then
		if(tonumber(arg0) == 30 and this:IsVisible()) then
			Guild_Info_Close();
		elseif(tonumber(arg0) == 31) then
			Guild:AskGuildDetailInfo();
		end
	elseif(event == "GUILD_SHOW_DETAILINFO") then
		Guild_Info_Clear();
		Guild_Info_Update();
		Guild_Info_Close();
		Guild_Info_Show();
	elseif(event == "GUILD_FORCE_CLOSE") then
		Guild_Info_Close();
	elseif(event == "GUILD_SELFEQUIP_CLICK") then
		if(this:IsVisible()) then
			Guild_Info_Close();
		end
	end 
end

function Guild_Info_Clear()
	ConfraternityInfo_DragTitle:SetText("");
	--ConfraternityInfo_TitleInfo:SetText("");
	
	-- ConfraternityInfo_Specialty_Text:Hide();
	--ConfraternityInfo_Specialty:Hide();
end

function Guild_Info_Update()
	--local szMsg = Guild:GetMyGuildInfo("Name");
	--ConfraternityInfo_DragTitle:SetText(szMsg.."�����ϸ��Ϣ");
	--2006-9-7 16:04���߻�Ҫ���޸�Ϊ�̶�ҳü
	ConfraternityInfo_DragTitle:SetText("#gFF0FA0Tin t�c t� m� Bang H�i");
	
	--2006-12-7 19:43 TODO:
  --szMsg = "���׶�:"..Guild:GetMyGuildDetailInfo("Con");
  --ConfraternityInfo_TitleInfo:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Name");
	ConfraternityInfo_ConfraternityName:SetText(szMsg);
	
	local leagueName = Guild:GetMyGuildDetailInfo("LeagueName");
	ConfraternityInfo_GuildLeagueName:SetText(leagueName);
	
	--MainInfo
	szMsg = Guild:GetMyGuildDetailInfo("ID");
	ConfraternityInfo_Amount:SetText(szMsg);
		
	szMsg = Guild:GetMyGuildDetailInfo("FoundedTime");
	ConfraternityInfo_CreateTime:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Level");
	ConfraternityInfo_Level:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Creator");
	ConfraternityInfo_Create:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("ChiefName");
	ConfraternityInfo_Master:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CityName");
	if(szMsg == "-1") then
		szMsg = "Kh�ng c� th�nh th�";
	end
	ConfraternityInfo_City:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CurBuilding");
	ConfraternityInfo_CityBuilding:SetText(szMsg);

	
	szMsg = Guild:GetMyGuildDetailInfo("Scene");
	if(szMsg == "-1") then
		szMsg = "Kh�ng c� n�i ch�";
	end
	ConfraternityInfo_Locus:SetText(szMsg);
	szMsg = Guild:GetMyGuildDetailInfo("Comm");
	ConfraternityInfo_CBD:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("CurResearch");
	if(szMsg == "")then
		szMsg = "Kh�ng nghi�n c�u tr߾c m�t";
	end;
	ConfraternityInfo_Specialty:SetText(szMsg);
	
	--TargetInfo
	szMsg = Guild:GetMyGuildDetailInfo("MemNum");
	ConfraternityInfo_Info1:SetText(szMsg);
	
	--szMsg = Guild:GetMyGuildDetailInfo("Honor");
	--ConfraternityInfo_Info2:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("FMoney");
	ConfraternityInfo_Info3:SetProperty("MoneyNumber", tostring(szMsg));
	
	szMsg = Guild:GetMyGuildDetailInfo("Ind");
	ConfraternityInfo_Info4:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("Agr");
	ConfraternityInfo_Info5:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("Com");
	ConfraternityInfo_Info6:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Def");
	ConfraternityInfo_Info7:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Tech");
	ConfraternityInfo_Info8:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Ambi");
	ConfraternityInfo_Info9:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Boom");
	ConfraternityInfo_Info10:SetText( GetColorBoomValueStr(szMsg) );
	
  
  local guildlevel = Guild:GetMyGuildDetailInfo("guildlevel");
  if guildlevel == 0  then
		 szMsg = 0
	else 
	szMsg = 200 + (guildlevel - 1) * 25
  end   	
	ConfraternityInfo_Shangpiao:SetText(szMsg)
end

function Guild_Info_CheckMembers()
	Guild:AskGuildMembersInfo();
end

function Guild_Info_Quit()
	Guild:QuitGuild();
end

function Guild_Info_Show()
	this:Show();
end

function Guild_Info_Close()
	this:Hide();
end