-------------------------------------------------------
--"¹ÙÔ±ÁĞ±í"½çÃæ½Å±¾
--create by xindefeng
-------------------------------------------------------

local g_OfficialCtls = nil		--¹ÙÔ±ÁĞ±í½çÃæ¿Ø¼ş½á¹¹
local g_ListIdx2IDTbl = nil		--List¿Ø¼şÉÏĞòÁĞºÅÓë³ÉÔ±IDºÅ¶ÔÓ¦±í

local g_positionInfo = {
	"Ğşi phê chu¦n",
	" Bang chúng ",
	" Tinh Anh ",
	" Thß½ng Nhân ",
	"SÑ giä H°ng Hoa ",
	"SÑ giä Công vø ",
	"SÑ giä Nµi vø ",
	"Phó Bang Chü ",
	"Bang Chü ",
};

local g_menpaiInfo = {
	"Thiªu Lâm",
	"Minh Giáo",
	"Cái Bang",
	"Võ Ğang",
	"Nga My",
	"Tinh Túc",
	"Thiên Long",
	"Thiên S½n",
	"Tiêu Dao",
	"Không có",
	"Mµ Dung",
}

local g_Confraternity_OfficialPositionList_Frame_UnifiedPosition;

--ÊÂ¼ş×¢²á
function Confraternity_OfficialPositionList_PreLoad()
	this:RegisterEvent("GUILD_SHOW_OFFICIALLIST")
	this:RegisterEvent("GUILD_ANY_SORTDATE")
	this:RegisterEvent("GUILD_FORCE_CLOSE")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function Confraternity_OfficialPositionList_OnLoad()
		g_Confraternity_OfficialPositionList_Frame_UnifiedPosition=Confraternity_OfficialPositionList_Frame:GetProperty("UnifiedPosition");
end

--ÊÂ¼şÏìÓ¦
function Confraternity_OfficialPositionList_OnEvent(event)
	Confraternity_OfficialPositionList_SetCtl()--ÏÈÉèÖÃÒ»ÏÂ¿Ø¼ş

	if(event == "GUILD_SHOW_OFFICIALLIST") then
		Confraternity_OfficialPositionList_Close()
		Confraternity_OfficialPositionList_Clear()
		Confraternity_OfficialPositionList_Update()
		Confraternity_OfficialPositionList_Show()
	elseif(event == "GUILD_ANY_SORTDATE") then	--À´ĞÂÊı¾İÖ®Ç°×ª·¢Í¨ÖªC´úÂëÅÅÒ»ÏÂĞò
		Guild:SortAnyGuildMembersByPosition()
	elseif(event == "GUILD_FORCE_CLOSE") then
		Confraternity_OfficialPositionList_Close()
	end
	
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		Confraternity_OfficialPositionList_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Confraternity_OfficialPositionList_Frame_On_ResetPos()
	end
	
end

--½«ËùÓĞµÄÏÔÊ¾ĞÅÏ¢µÄ¿Ø¼ş·ÅÈë½á¹¹ÖĞ,±ãÓÚ²Ù×İ
function Confraternity_OfficialPositionList_SetCtl()
	g_OfficialCtls = {
										list = Confraternity_OfficialPositionList_MemberList,	--¹ÙÔ±ÁĞ±í
										officalname = Confraternity_OfficialPositionList_Info1_Text,--¹ÙÔ±Ãû×Ö
										info_menpai = {txt = Confraternity_OfficialPositionList_Info2_Text, msg = Confraternity_OfficialPositionList_Info2},--ÃÅÅÉ
										info_level = {txt = Confraternity_OfficialPositionList_Info3_Text, msg = Confraternity_OfficialPositionList_Info3},	--µÈ¼¶
										info_gongxiandu = {txt = Confraternity_OfficialPositionList_Info4_Text, msg = Confraternity_OfficialPositionList_Info4},--¹±Ï×¶È
										info_benzhougongxiandu = {txt = Confraternity_OfficialPositionList_Info7_Text, msg = Confraternity_OfficialPositionList_Info7},--±¾ÖÜ¹±Ï×¶È
										info_rubangdate =	{txt = Confraternity_OfficialPositionList_Info5_Text, msg = Confraternity_OfficialPositionList_Info5},--Èë°ïÊ±¼ä
										info_lixiandate =	{txt = Confraternity_OfficialPositionList_Info6_Text, msg = Confraternity_OfficialPositionList_Info6},--ÀëÏßÊ±¼ä
										desc = Confraternity_OfficialPositionList_Tenet,			--°ï»á×ÚÖ¼
										edit = Confraternity_OfficialPositionList_EditTenet		--°ï»á×ÚÖ¼µÄÄÚÈİ
								 	 }
end

--Çå¿Õ½çÃæ
function Confraternity_OfficialPositionList_Clear()
	--Çå¿Õ¹ÙÔ±ÁĞ±í
	g_OfficialCtls.list:ClearListBox()

	--Çå¿Õ¹ÙÔ±Ãû×Ö
	g_OfficialCtls.officalname:SetText("")

	--Çå¿ÕËùÓĞinfo¿Ø¼ş
	g_OfficialCtls.info_menpai.txt:SetText("")
	g_OfficialCtls.info_level.txt:SetText("")
	g_OfficialCtls.info_gongxiandu.txt:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("")
	g_OfficialCtls.info_rubangdate.txt:SetText("")
	g_OfficialCtls.info_lixiandate.txt:SetText("")

	g_OfficialCtls.info_menpai.msg:SetText("")
	g_OfficialCtls.info_level.msg:SetText("")
	g_OfficialCtls.info_gongxiandu.msg:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText("")
	g_OfficialCtls.info_rubangdate.msg:SetText("")
	g_OfficialCtls.info_lixiandate.msg:SetText("")

	--Çå¿Õ°ï»á×ÚÖ¼
	g_OfficialCtls.desc:SetText("")
	g_OfficialCtls.desc:Show()

	g_OfficialCtls.edit:SetText("")
	g_OfficialCtls.edit:SetProperty("CaratIndex", 1024)
	g_OfficialCtls.edit:Hide()

	--Çå¿ÕË÷ÒıID¶ÔÓ¦±í
	g_ListIdx2IDTbl = nil
end

--Ë¢ĞÂÏÔÊ¾ÆäËûÊı¾İ
function Confraternity_OfficialPositionList_Flush(selected)
	local str = nil
	local selectedID = g_ListIdx2IDTbl[selected]

	if  selectedID == nil then
		return
	end

	--¹ÙÔ±Ãû³Æ
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Name")--Ä¬ÈÏÑ¡ÖĞÁĞ±íÀïµÄµÚÒ»¸öÈË
	local guid = ""
	_, guid = Guild:GetAnyGuildMembersInfo(selectedID, "GUID")--»ñÈ¡guidÊ®Áù½øÖÆ×Ö·û´®
	g_OfficialCtls.officalname:SetText(str.."("..guid..")")

	--ÃÅÅÉ
	str = Guild:GetAnyGuildMembersInfo(selectedID, "MenPai")
	g_OfficialCtls.info_menpai.txt:SetText("Phái:  ")
	g_OfficialCtls.info_menpai.msg:SetText(g_menpaiInfo[str+1])

	--µÈ¼¶
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Level")
	g_OfficialCtls.info_level.txt:SetText("C¤p: ")
	g_OfficialCtls.info_level.msg:SetText(str)

	--¹±Ï×¶È
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "CurCon").."/"..Guild:GetAnyGuildMembersInfo(selectedID, "MaxCon")
	g_OfficialCtls.info_gongxiandu.txt:SetText("Ğµ c¯ng hiªn: ")
	g_OfficialCtls.info_gongxiandu.msg:SetText(szMsg)

	--±¾ÖÜ¹±Ï×¶È
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "ContriPerWeek")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("C¯ng hiªn tu¥n này:")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText(szMsg)

	--Èë°ïÊ±¼ä
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "JoinTime");
	g_OfficialCtls.info_rubangdate.txt:SetText("Ngày vào bang: ")
	g_OfficialCtls.info_rubangdate.msg:SetText(szMsg)

	--ÀëÏßÊ±¼ä
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "LogOutTime")
	g_OfficialCtls.info_lixiandate.txt:SetText("Ngày r¶i mÕng: ")
	g_OfficialCtls.info_lixiandate.msg:SetText(szMsg)
end

--Ë¢ĞÂÏÔÊ¾"¹ÙÔ±ÁĞ±í"List
function Confraternity_OfficialPositionList_ShowList()
	--List Ctl
	local OfficialsCount = 0			--¹ÙÔ±ÊıÁ¿
	local UnSortIdx = 0						--Î´ÅÅĞòÇ°Ë÷ÒıºÅ
	local Color = nil							--ÏÔÊ¾ÑÕÉ«
	local Position = nil					--Ö°Î»(ºÅ)
	local Name = nil							--Ãû×Ö

	local listidx = 0	--listÖĞÏÔÊ¾Ë÷ÒıºÅ
	local i = 0

	g_ListIdx2IDTbl = nil	--ÏÈÇå¿Õ

	OfficialsCount = Guild:GetAnyGuildMembersInfo(0, "OfficialsNum")	--»ñÈ¡¹ÙÔ±ÊıÁ¿(Ê×²ÎÎŞĞ§)
	while i < OfficialsCount do
		--»ñÈ¡Î´ÅÅĞòÇ°Ë÷ÒıºÅ
		UnSortIdx = Guild:Sort2UnSortIndex(i)

		--»ñÈ¡Êı¾İ
		Color = Guild:GetAnyGuildMembersInfo(UnSortIdx, "ShowColor") 	--»ñÈ¡ÏÔÊ¾ÑÕÉ«
		Position = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Position")--Ö°Î»
		Name = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Name")				--»ñÈ¡³ÉÔ±Ãû×Ö

		--¸ø¿Ø¼ş¼ÓÒ»Ïî
		g_OfficialCtls.list:AddItem(Color..g_positionInfo[Position]..Name, listidx);

		--Î¬»¤±í
		g_ListIdx2IDTbl[listidx] = UnSortIdx

		listidx = listidx + 1

		i = i + 1
	end

	g_OfficialCtls.list:SetItemSelectByItemID(0)	--Ä¬ÈÏÑ¡ÖĞÁĞ±íÀïµÄµÚÒ»¸öÈË


end

--ÏÔÊ¾Êı¾İ
function Confraternity_OfficialPositionList_Update()
	--title
	Confraternity_OfficialPositionList_DragTitle:SetText("#gFF0FA0Danh sánh thành viên")

	--Ë¢ĞÂÏÔÊ¾"¹ÙÔ±ÁĞ±í"List
	Confraternity_OfficialPositionList_ShowList()

	--Ë¢ĞÂÏÔÊ¾ÆäËûÊı¾İ
	Confraternity_OfficialPositionList_Selected()

	--°ï»á×ÚÖ¼
	local str = Guild:GetAnyGuildMembersInfo(0, "Desc")--Ê×²ÎÎŞĞ§
	g_OfficialCtls.desc:SetText(str)
end

--ÓÃ»§Ñ¡Ôñ·¢Éú¸Ä±ä,Ë¢ĞÂÒ»ÏÂ
function Confraternity_OfficialPositionList_Selected()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--µÃµ½Ñ¡ÖĞÏîË÷ÒıºÅ
	if (idx == -1) then
		return
	end

	Confraternity_OfficialPositionList_Flush(idx)--Ë¢ĞÂ
end

--ÏÔÊ¾ÓÒ¼ü²Ëµ¥
function Confraternity_OfficialPositionList_PopMenu()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--µÃµ½Ñ¡ÖĞÏîË÷ÒıºÅ
	if( idx == -1 ) then
		return
	end

	Guild:Show_OfficialPopMenu(tonumber(g_ListIdx2IDTbl[idx])) --Í¨ÖªC´úÂëÒªÏÔÊ¾ÓÒ¼ü²Ëµ¥
end

--ÏÔÊ¾½çÃæ
function Confraternity_OfficialPositionList_Show()
	this:Show()
end

--¹Ø±Õ½çÃæ
function Confraternity_OfficialPositionList_Close()
	this:Hide()
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Confraternity_OfficialPositionList_Frame_On_ResetPos()
  Confraternity_OfficialPositionList_Frame:SetProperty("UnifiedPosition", g_Confraternity_OfficialPositionList_Frame_UnifiedPosition);
end