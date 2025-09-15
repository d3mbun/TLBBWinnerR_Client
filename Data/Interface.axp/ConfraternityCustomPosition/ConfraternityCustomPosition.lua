-------------------------------------------------------
--"×Ô¶¨Òå°ï»áÖ°Î»Ãû³Æ"½çÃæ½Å±¾
--create by xindefeng
-------------------------------------------------------

local g_NameCtls = nil	--ÐèÒªÓÃµ½µÄ¿Ø¼þ±í

--±ê×¼°ï»áÖ°Î»Ãû³Æ
local g_StdPositionName = {
	"Bang chü ",			--9
	"Phó bang chü ",		--8
	"Nµi vø sÑ ",		--7
	"Công vø sÑ ",		--6
	"Ho¢ng hóa sÑ ",		--5
	"Thß½ng nhân ",			--4
	"Tinh anh ",			--3
	"Bang chúng "			--2
}

--Reset°´Å¥ÊÇ·ñÊ¹ÓÃ¹ý±êÖ¾
local g_ResetBtnFlag = {0,0,0,0,0,0,0,0}

local g_SaveForReset = nil --±£´æ´ò¿ª½çÃæÊ±"×Ô¶¨ÒåÖ°Î»Ãû³Æ"ÓÃÓÚReset
local g_ConfraternityCustomPosition_Frame_UnifiedPosition;

--ÊÂ¼þ×¢²á
function ConfraternityCustomPosition_PreLoad()
	this:RegisterEvent("GUILD_SHOW_CUSTOMPOSITION")
	this:RegisterEvent("GUILD_FORCE_CLOSE")
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityCustomPosition_OnLoad()	
		g_ConfraternityCustomPosition_Frame_UnifiedPosition=ConfraternityCustomPosition_Frame:GetProperty("UnifiedPosition");
end

--ÊÂ¼þÏìÓ¦
function ConfraternityCustomPosition_OnEvent(event)	
	if( event == "GUILD_SHOW_CUSTOMPOSITION" ) then
		ConfraternityCustomPosition_SetCtls()	--ÉèÖÃ¿Ø¼þ
		g_ResetBtnFlag = {0,0,0,0,0,0,0,0}
		
		ConfraternityCustomPosition_Clear()
		ConfraternityCustomPosition_Update()
		ConfraternityCustomPosition_Show()
	elseif( event == "GUILD_FORCE_CLOSE" ) then	
		ConfraternityCustomPosition_Close()
	end
	
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityCustomPosition_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityCustomPosition_Frame_On_ResetPos()
	end
end

--ÉèÖÃ¿Ø¼þ±í
function ConfraternityCustomPosition_SetCtls()
	g_NameCtls = nil;
	
	g_NameCtls = {
									oldNames = {
										          	CurCustomPosition1,
										          	CurCustomPosition2,
										          	CurCustomPosition3,
										          	CurCustomPosition4,
										          	CurCustomPosition5,
										          	CurCustomPosition6,
										          	CurCustomPosition7,
										          	CurCustomPosition8,
										         },
									newNames = {
										          	Edit_CustomPosition1,
										          	Edit_CustomPosition2,
										          	Edit_CustomPosition3,
										          	Edit_CustomPosition4,
										          	Edit_CustomPosition5,
										          	Edit_CustomPosition6,
										          	Edit_CustomPosition7,
										          	Edit_CustomPosition8
										         },
									ResetBtn = {
																ConfraternityCustomPosition_Reset_Button1,
																ConfraternityCustomPosition_Reset_Button2,
																ConfraternityCustomPosition_Reset_Button3,
																ConfraternityCustomPosition_Reset_Button4,
																ConfraternityCustomPosition_Reset_Button5,
																ConfraternityCustomPosition_Reset_Button6,
																ConfraternityCustomPosition_Reset_Button7,
																ConfraternityCustomPosition_Reset_Button8
														}
								}
end

--Çå¿Õ½çÃæÊý¾Ý
function ConfraternityCustomPosition_Clear()	
end

--Ë¢ÐÂ½çÃæÏÔÊ¾µÄÊý¾Ý
function ConfraternityCustomPosition_Update()
	local szMsg = nil
	
	ConfraternityCustomPosition_Title:SetText("#gFF0FA0Tñ l§p chÑc v¸ ")
	
	--ÏÔÊ¾µ±Ç°"×Ô¶¨ÒåÖ°Î»Ãû³Æ"
	for i=1,8 do
		g_NameCtls.ResetBtn[i]:SetText("Khôi phøc")		--ÐÞ¸Ä°´Å¥Ãû×Ö
		
		szMsg = Guild:GetCurCustomPositionName(10-i)		
		g_SaveForReset[i] = szMsg	--±£´æÒ»ÏÂ,ÓÃÓÚ±È½ÏÅÐ¶ÏÊÇ·ñ¸Ä¹ý		
		if((szMsg == "") or (szMsg == g_StdPositionName[i]))then
			szMsg = g_StdPositionName[i]
			g_NameCtls.ResetBtn[i]:Disable()	--´ÓÀ´Ã»ÓÐ¸Ä¹ý,°´Å¥²»ÄÜÊ¹ÓÃ,»Òµô
		else
			szMsg = szMsg.."("..g_StdPositionName[i]..")"
			g_NameCtls.ResetBtn[i]:Enable()						--¸Ä¹ý,°´Å¥¿ÉÒÔÊ¹ÓÃ			
		end
		
		--ÉèÖÃµ±Ç°×Ô¶¨ÒåÖ°Î»Ãû³Æ
		g_NameCtls.oldNames[i]:SetText(szMsg)
		
	end
	
	--½«±à¼­¿òÇå¿Õ
	for i=1,8 do
		g_NameCtls.newNames[i]:SetText("")
	end	
	
end

--´ò¿ª½çÃæ
function ConfraternityCustomPosition_Show()	
	this:Show()
end

--¹Ø±Õ´°¿Ú
function ConfraternityCustomPosition_Close()
	this:Hide()
end

--¸´Î»°´Å¥
function ConfraternityCustomPosition_Reset(BtnId)
	g_NameCtls.oldNames[BtnId]:SetText(g_StdPositionName[BtnId])
	g_NameCtls.newNames[BtnId]:SetText("")
		
	g_ResetBtnFlag[BtnId] = 1	--ÉèÖÃÊ¹ÓÃ±êÖ¾	
	
	g_NameCtls.ResetBtn[BtnId]:SetText("#{INTERFACE_XML_1154}")
	g_NameCtls.ResetBtn[BtnId]:Disable()	--»Ö¸´Ò»´Î¾Í²»ÄÜÔÙÓÃÁË£¬»Òµô
end

--È·¶¨
function ConfraternityCustomPosition_Ok()
	local szOld = nil
	local szNew = nil
	local bIsChanged = 0	--¼ÇÂ¼ÊÇ·ñÓÐ¸Ä±ä
	local bLegal = 1			--ÊÇ·ñºÏ·¨
	local result = 0			--ÐÞ¸Ä½á¹û
	local bTipFlag = 0		--ÊÇ·ñÐèÒªÌáÊ¾"ÄúµÄÊäÈëµ±ÖÐÓÐ×ªÒå×Ö·û"
	
	--ÔÚ¼ÇÂ¼"ÐÂÐÞ¸ÄµÄ°ï»á×Ô¶¨ÒåÖ°Î»Ãû³Æ"Ö®Ç°,ÏÈÇå¿ÕÒ»ÏÂÊý¾Ý½á¹¹
	Guild:ClearCustomPositionName()
	
	for i=1,8 do		
		--»ñÈ¡ÊäÈë
		szNew = g_NameCtls.newNames[i]:GetText()
		
		--¼ì²âÊÇ·ñÓÐÎ¥·¨×Ö·û£¬Èç¹û¼ì²âÍ¨¹ýÔò´æ´¢ÏÂÀ´
		result = 0	--Ã¿´Î¶¼ÒªÉèÖÃ
		if(g_ResetBtnFlag[i] == 1)then	--Ê¹ÓÃÁËÏàÓ¦µÄReset°´Å¥,»Ö¸´±ê×¼Ö°Î»Ãû×Ö
			bIsChanged = bIsChanged + 1	--·¢Éú¸Ä±ä
			result = Guild:AskModifyCustomPositionName(10-i, tostring(g_StdPositionName[i]), 1)	--¼ì²â´æ´¢
		elseif((szNew ~= "") and (szNew ~= g_SaveForReset[i]))then	--»òÕß×Ô¶¨ÒåÁËÖ°Î»Ãû³Æ
			bIsChanged = bIsChanged + 1	--·¢Éú¸Ä±ä
			result = Guild:AskModifyCustomPositionName(10-i, tostring(szNew), 0)			--¼ì²â´æ´¢
		end
		
		--¸ø³öÎ¥·¨ÌáÊ¾
		if (result == -1) then
			PushDebugMessage("B¢ng hæu nh§p vào \""..szNew.." Phi pháp, mong b¢ng hæu chú ý ngôn t× !")	
			bLegal = 0	--±êÊ¶ÓÐÎ¥·¨×Ö·û
			
			bIsChanged = bIsChanged - 1	--¸Ä±äÊýÁ¿¼õ1
		elseif (result == -2) then			
			bTipFlag = 1		--ÐèÒªÌáÊ¾"ÄúµÄÊäÈëµ±ÖÐÓÐ×ªÒå×Ö·û£¡"
			bLegal = 0	--±êÊ¶ÓÐÎ¥·¨×Ö·û
			
			bIsChanged = bIsChanged - 1	--¸Ä±äÊýÁ¿¼õ1
		end		
	end
	
	--ÓÐ²»ºÏ·¨×Ö·û´®Ö±½Ó·µ»Ø
	if(bLegal == 0) then
		if(bTipFlag == 1)then	--ÐèÒªÌáÊ¾
			PushDebugMessage("B¢ng hæu nh§p vào ký tñ phi pháp !")	--ÌáÊ¾£º"ÄúµÄÊäÈëµ±ÖÐÓÐ×ªÒå×Ö·û£¡"
		end
		return
	end
	
	--·¢°ü
	if(bIsChanged > 0) then	--ÓÐ¸Ä±ä
		Guild:AskModifyCustomPositionName(0)
	end
	
	--¹Ø±Õ´°¿Ú
	this:Hide()	
end

--È¡Ïû
function ConfraternityCustomPosition_Cancel()
	this:Hide()
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function ConfraternityCustomPosition_Frame_On_ResetPos()
  ConfraternityCustomPosition_Frame:SetProperty("UnifiedPosition", g_ConfraternityCustomPosition_Frame_UnifiedPosition);
end