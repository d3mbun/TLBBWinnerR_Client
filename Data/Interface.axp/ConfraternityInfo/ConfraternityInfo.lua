-- ConfraternityInfo_Amount   °ï»áid
-- ConfraternityInfo_CreateTime ´´½¨Ê±¼ä
-- ConfraternityInfo_Create	´´½¨ÈË
-- ConfraternityInfo_Master	ÏÖÈÎ°ïÖ÷
-- ConfraternityInfo_City	³ÇÊÐ
-- ConfraternityInfo_Locus	ËùÔÚµØ
--	ConfraternityInfo_CBD		ÉÌÇø
-- ConfraternityInfo_Specialty	µ±Ç°ÑÐ¾¿
-- ConfraternityInfo_CityBuilding µ±Ç°½¨Éè
-- ConfraternityInfo_Level	¹æÄ£
-- ConfraternityInfo_Info1	ÈËÊý
-- ConfraternityInfo_Info4	¹¤Òµ¶È
-- ConfraternityInfo_Info5	Å©Òµ¶È
-- ConfraternityInfo_Info6	ÉÌÒµ¶È
-- ConfraternityInfo_Info7	¹ú·À¶È
-- ConfraternityInfo_Info8	¿Æ¼¼¶È
-- ConfraternityInfo_Info9	À©ÕÅ¶È
-- ConfraternityInfo_Info3	¹ú¼Ò×Ê½ð
-- ConfraternityInfo_Shangpiao ±¾ÈÕ×î´óÉÌÆ±Êý


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
	--ConfraternityInfo_DragTitle:SetText(szMsg.."°ï»áÏêÏ¸ÐÅÏ¢");
	--2006-9-7 16:04°´²ß»®ÒªÇóÐÞ¸ÄÎª¹Ì¶¨Ò³Ã¼
	ConfraternityInfo_DragTitle:SetText("#gFF0FA0Tin tÑc tï mï Bang Hµi");
	
	--2006-12-7 19:43 TODO:
  --szMsg = "¹±Ï×¶È:"..Guild:GetMyGuildDetailInfo("Con");
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
		szMsg = "Không có thành th¸";
	end
	ConfraternityInfo_City:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CurBuilding");
	ConfraternityInfo_CityBuilding:SetText(szMsg);

	
	szMsg = Guild:GetMyGuildDetailInfo("Scene");
	if(szMsg == "-1") then
		szMsg = "Không có n½i ch²";
	end
	ConfraternityInfo_Locus:SetText(szMsg);
	szMsg = Guild:GetMyGuildDetailInfo("Comm");
	ConfraternityInfo_CBD:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("CurResearch");
	if(szMsg == "")then
		szMsg = "Không nghiên cÑu trß¾c m¡t";
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