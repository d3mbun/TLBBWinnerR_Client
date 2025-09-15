-------------------------------------------------------
--��"�����ϸ��Ϣ"����ű�
--create by xindefeng
-------------------------------------------------------

local g_QueryGuildID = -1

--�¼�ע��
function ConfraternityInfo2_PreLoad()
	this:RegisterEvent("GUILD_SHOW_DETAILINFO2")
	this:RegisterEvent("GUILD_ID_FORDETAILINFO2")
	this:RegisterEvent("GUILD_FORCE_CLOSE")	
end

function ConfraternityInfo2_OnLoad()
end

--�¼���Ӧ
function ConfraternityInfo2_OnEvent(event)
	if(event == "GUILD_ID_FORDETAILINFO2") then
		g_QueryGuildID = tonumber(arg0)
	elseif(event == "GUILD_SHOW_DETAILINFO2") then
		Guild_Info2_Clear()		
		Guild_Info2_Update()
		Guild_Info2_Close()
		Guild_Info2_Show()
	elseif(event == "GUILD_FORCE_CLOSE") then
		Guild_Info2_Close()	
	end	
end

function Guild_Info2_Clear()
	ConfraternityInfo2_DragTitle:SetText("")
	--ConfraternityInfo2_TitleInfo:SetText("")
end


--������ʾ��Ϣ
function Guild_Info2_Update()
	--title
	ConfraternityInfo2_DragTitle:SetText("#gFF0FA0Tin t�c t� m� Bang H�i")
	
	--Guild Name
	local str = Guild:GetMyGuildDetailInfo("Name")
	ConfraternityInfo2_ConfraternityName:SetText(str)
	
	local leagueName = Guild:GetMyGuildDetailInfo("LeagueName")
	ConfraternityInfo2_GuildLeagueName:SetText(leagueName)
	
	--Main Info
	ConfraternityInfo2_Amount:SetText(tostring(g_QueryGuildID))	--GuildID

	str = Guild:GetMyGuildDetailInfo("FoundedTime")
	ConfraternityInfo2_CreateTime:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Level")
	ConfraternityInfo2_Level:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Creator")
	ConfraternityInfo2_Create:SetText(str)

	str = Guild:GetMyGuildDetailInfo("ChiefName")
	ConfraternityInfo2_Master:SetText(str)

	str = Guild:GetMyGuildDetailInfo("CityName")
	if(str == "-1") then
		str = "Kh�ng c� th�nh th�"
	end
	ConfraternityInfo2_City:SetText(str)
	
	str = Guild:GetMyGuildDetailInfo("CurBuilding")
	ConfraternityInfo2_CityBuilding:SetText(str)
	str = Guild:GetMyGuildDetailInfo("Scene")
	if(str == "-1") then
		str = "Kh�ng c� n�i ch�"
	end
	ConfraternityInfo2_Locus:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Comm")
	ConfraternityInfo2_CBD:SetText(str)

	str = Guild:GetMyGuildDetailInfo("CurResearch")
	if(str == "")then
		str = "Kh�ng nghi�n c�u tr߾c m�t"
	end
	ConfraternityInfo2_Specialty:SetText(str)
	
	str = Guild:GetMyGuildDetailInfo("MemNum")
	ConfraternityInfo2_Info1:SetText(str)	
	
	str = Guild:GetMyGuildDetailInfo("Ind")
	ConfraternityInfo2_Info4:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Agr")
	ConfraternityInfo2_Info5:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Com")
	ConfraternityInfo2_Info6:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Def")
	ConfraternityInfo2_Info7:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Tech")
	ConfraternityInfo2_Info8:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Ambi")
	ConfraternityInfo2_Info9:SetText(str)
end

function Guild_Info2_Show()
	this:Show()
end

function Guild_Info2_Close()
	this:Hide()
end