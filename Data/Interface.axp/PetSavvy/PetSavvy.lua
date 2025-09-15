-- PetSavvy.lua
-- ÕäÊŞºÏ³É½çÃæ

local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

local theNPC = -1													-- ¹¦ÄÜ NPC
local MAX_OBJ_DISTANCE = 3.0

local currentChoose = -1

local moneyCosts = {													-- Ë÷ÒıÊÇÕäÊŞµÄµ±Ç°ÎòĞÔÖµ
	[0] = 10000,
	[1] = 11000,
	[2] = 12100,
	[3] = 13310,
	[4] = 14641,
	[5] = 16105,
	[6] = 17716,
	[7] = 19487,
	[8] = 21436,
	[9] = 23579,
}

function PetSavvy_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- Íæ¼Ò´ÓÁĞ±íÑ¡¶¨Ò»Ö»ÕäÊŞ
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- Íæ¼ÒÉíÉÏµÄÕäÊŞÊı¾İ·¢Éú±ä»¯£¬°üÀ¨Ôö¼ÓÒ»Ö»ÕäÊŞ
	this : RegisterEvent( "DELETE_PET" )							-- Íæ¼ÒÉíÉÏ¼õÉÙÒ»Ö»ÕäÊŞ
	this : RegisterEvent( "OBJECT_CARED_EVENT" )					-- ¹ØĞÄ NPC µÄ´æÔÚºÍ·¶Î§
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--½»×ÓÆÕ¼° Vega
end

function PetSavvy_OnLoad()
	PetSavvy_Clear()
end

function PetSavvy_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19820424 then	-- ´ò¿ª½çÃæ
		if this : IsVisible() then									-- Èç¹û½çÃæ¿ª×Å£¬Ôò²»´¦Àí
			return
		end
		Pet : ShowPetList( 0 )
		PetSavvy_Clear()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "REPLY_MISSION_PET" and this : IsVisible() then		-- Íæ¼ÒÑ¡ÁËÒ»Ö»ÕäÊŞ
		PetSavvy_SelectPet( tonumber( arg0 ) )
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_PET_PAGE" and this : IsVisible() then		-- Íæ¼ÒÉíÉÏµÄÕäÊŞÊı¾İ·¢Éú±ä»¯£¬°üÀ¨Ôö¼ÓÒ»Ö»ÕäÊŞ
		PetSavvy_UpdateSelected()
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "DELETE_PET" and this : IsVisible() then			-- Íæ¼ÒÉíÉÏ¼õÉÙÒ»Ö»ÕäÊŞ
		PetSavvy_UpdateSelected()
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- ¹ØĞÄ NPC µÄ´æÔÚºÍ·¶Î§
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ı£¬×Ô¶¯¹Ø±Õ
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSavvy_Cancel_Clicked()
		end
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
end

function PetSavvy_Choose_Clicked( type )
	if type == "main" then
		currentChoose = 1
		PetSavvy_Other_PetList1_Select : Disable()
		PetSavvy_Other_PetList2_Select : Enable()
	elseif type == "assis" then
		currentChoose = 2
		PetSavvy_Other_PetList1_Select : Enable()
		PetSavvy_Other_PetList2_Select : Disable()
	else
		return
	end

	-- ¹ØÒ»ÏÂÔÙ¿ª£¬Çå¿ÕÊı¾İ
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

function PetSavvy_OK_Clicked()
	-- Ê×ÏÈÅĞ¶¨Íæ¼ÒÊÇ·ñ·ÅÈëĞèÒªÌáÉıµÄÕäÊŞ£¬Èç¹ûÃ»ÓĞ·ÅÈëNPC½«»áµ¯³ö¶Ô»°²¢·µ»Ø£º
	if mainPet.idx == -1 then
	-- Çë·ÅÈëÄúÒªÌáÉıÎòĞÔµÈ¼¶µÄÕäÊŞ¡£
		ShowSystemTipInfo( "M¶i các hÕ nh§p yêu c¥u c¥n nâng cao nh§n thÑc thú quı cüa bÕn." )
		return
	end

	-- ÅĞ¶¨Íæ¼ÒÊÇ·ñ·ÅÈë²ÎÓëºÏ³ÉµÄÕäÊŞ£¬Èç¹ûÃ»ÓĞ·ÅÈëNPC½«»áµ¯³ö¶Ô»°²¢·µ»Ø£º
	if assisPet.idx == -1 then
		-- Çë·ÅÈëÄúÒª²ÎÓëºÏ³ÉµÄÕäÊŞ¡£
		ShowSystemTipInfo( "M¶i cho vào thú quı kªt hşp mà các hÕ mu¯n tham gia." )
		return
	end

	-- ÅĞ¶Ï¸¨Öú³èÊÇ·ñ·ûºÏÌõ¼ş
	if PetSavvy_Check() == 0 then
		-- Èç¹û²»·ûºÏÔò·µ»Ø
		return
	end

	-- ÅĞ¶¨Íæ¼ÒµÄ½ğÇ®ÊÇ·ñ×ã¹»£¬Èç¹û²»¹»½«»áµ¯³ö¶Ô»°¡£
	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	-- ÄúµÄ½ğÇ®²»×ã£¬ÇëÈ·ÈÏ
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--½»×ÓÆÕ¼° Vega
	if selfMoney < cost then
		ShowSystemTipInfo( "Ngân lßşng cüa các hÕ không ğü, m¶i xác nh§n." )
		return
	end

	-- ·¢ËÍ UI_Command ½øĞĞºÏ³É
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetSavvy" )
		Set_XSCRIPT_ScriptID( 800104 )
		Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
		Set_XSCRIPT_Parameter( 1, mainPet.guid.low )
		Set_XSCRIPT_Parameter( 2, assisPet.guid.high )
		Set_XSCRIPT_Parameter( 3, assisPet.guid.low )
		Set_XSCRIPT_ParamCount( 4 )
	Send_XSCRIPT()
end

function PetSavvy_Cancel_Clicked()
	
	this:Hide()
end

function PetSavvy_Close()
	StopCareObject()
	Pet : ShowPetList( 0 )
	PetSavvy_Clear()
end

function PetSavvy_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation( mainPet.idx, -1 )
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
	PetSavvy_Pet1_Text : SetText( "" )
end

function PetSavvy_RemoveAssisPet()
	if assisPet.idx ~= -1 then
		Pet : SetPetLocation( assisPet.idx, -1 )
	end

	assisPet.idx = -1
	assisPet.guid.high = -1
	assisPet.guid.low = -1
	PetSavvy_Pet2_Text : SetText( "" )
end

function PetSavvy_Clear()
	PetSavvy_RemoveMainPet()
	PetSavvy_RemoveAssisPet()

	PetSavvy_Text2 : SetText( "#cFF0000TÖ l® thành công" )
	PetSavvy_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )

	PetSavvy_OK : Disable()

	currentChoose = -1
	PetSavvy_Other_PetList1_Select : Enable()
	PetSavvy_Other_PetList2_Select : Enable()
end

function PetSavvy_Check()
	if mainPet.idx == -1 or assisPet.idx == -1 then
		return 0
	end

	if mainPet.idx == assisPet.idx then
		ShowSystemTipInfo( "M¶i cho vào 2 con trân thú khác nhau." )
		return 0
	end

	-- ÅĞ¶¨²ÎÓëÕäÊŞµÄĞ¯´øµÈ¼¶ÊÇ·ñ´óÓÚµÈÓÚĞèÒªÌáÉıµÄÕäÊŞµÄĞ¯´øµÈ¼¶£¬Èç¹û²»ÊÇ£¬Ôòµ¯³ö¶Ô»°²¢·µ»Ø£º
	local mainCarryLevel = Pet : GetTakeLevel( mainPet.idx )
	local assisCarryLevel = Pet : GetTakeLevel( assisPet.idx )
	if assisCarryLevel < mainCarryLevel then
		-- ÄúµÄ²ÎÓëºÏ³ÉµÄÕäÊŞĞ¯´øµÈ¼¶Îªa£¬±ØĞëÒªÕÒĞ¯´øµÈ¼¶´óÓÚµÈÓÚbµÄ²ÅÄÜ²ÎÓëºÏ³É¡££¨aÎª²ÎÓëºÏ³ÉÕäÊŞµÄĞ¯´øµÈ¼¶¡¢bÎªĞèÒªÌáÉıµÄÕäÊŞµÄĞ¯´øµÈ¼¶£©
		ShowSystemTipInfo( "C¤p mang theo cüa thú quı cüa các hÕ khi tham gia liên kªt là" .. assisCarryLevel .. ", c¥n tìm ğÆng c¤p mang theo l¾n h½n ho£c b¢ng" .. mainCarryLevel .. "m¾i có th¬ tham gia hşp thành" )
		return 0
	end

	-- ÅĞ¶¨²ÎÓëºÏ³ÉµÄÕäÊŞµÄ¸ù¹ÇÊÇ·ñ´óÓÚµÈÓÚĞèÒªÌáÉıµÄÕäÊŞµÄÎòĞÔµÈ¼¶£¬Èç¹ûÅĞ¶¨²»³ÉÁ¢Ôòµ¯³ö¶Ô»°²¢·µ»Ø£º
	local savvy = Pet : GetSavvy( mainPet.idx )
	local con = Pet : GetBasic( assisPet.idx )
	if con < savvy then
		-- ²ÎÓëºÏ³ÉµÄÕäÊŞµÄ¸ù¹Ç±ØĞë´óÓÚµÈÓÚa£¨aÎªĞèÒªÌáÉıµÄÕäÊŞµÄÎòĞÔµÈ¼¶£©
		ShowSystemTipInfo( "Cån c¯t cüa thú quı kªt hşp tham gia b¡t buµc phäi b¢ng ho£c nhi«u h½n " .. savvy .. "." )
		return 0
	end

	return 1
end

-- ¼ÆËã³É¹¦ÂÊ
function PetSavvy_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetSavvy_Text2 : SetText( "#cFF0000TÖ l® thành công" )
		PetSavvy_OK : Disable()
		return
	end

	succOdds = {													-- Ë÷ÒıÊÇÕäÊŞµÄµ±Ç°ÎòĞÔÖµ
		[0] = 1000,
		[1] = 850,
		[2] = 750,
		[3] = 600,
		[4] = 200,
		[5] = 310,
		[6] = 310,
		[7] = 30,
		[8] = 70,
		[9] = 60,
	}

	local savvy = Pet : GetSavvy( mainPet.idx )
	local str = "#cFF0000 tÖ l® thành công: "
	local odds = succOdds[savvy]
	if not odds then
		str = "Không có cách nào thång c¤p"
		PetSavvy_OK : Disable()
	else
		str = str .. math.floor( odds / 10 ) .. "%"
		PetSavvy_OK : Enable()
	end

	PetSavvy_Text2 : SetText( str )
end

-- ¼ÆËã½ğÇ®ÏûºÄ
function PetSavvy_CalcCost()
	if mainPet.idx == -1 then
		PetSavvy_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	PetSavvy_NeedMoney : SetProperty( "MoneyNumber", tostring( cost ) )
end

function PetSavvy_SelectPet( petIdx )
	if -1 == petIdx then
		return
	end

	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	-- ÅĞ¶Ï petIdex ´ú±íµÄÊÇ±»ÌáÉıµÄ³è»¹ÊÇ¸¨Öú³è
	-- Èç¹ûÊÇ±»ÌáÉıµÄ³è
	if currentChoose == 1 then
		-- Èç¹ûÔ­À´ÒÑ¾­Ñ¡ÔñÁËÒ»¸ö±»ÌáÉıµÄ³è
		-- ÔòÇå¿ÕÔ­À´µÄÊı¾İ
		PetSavvy_RemoveMainPet()

		-- XX Èç¹ûÔ­À´¾ÍÓĞ¸¨Öú³è²¢ÇÒ¸¨Öú³è²»·ûºÏĞÂµÄÌõ¼ş
		-- XX ÔòÇå¿Õ¸¨Öú³èµÄÊı¾İ
		-- ¼ÇÂ¼¸Ã³èµÄÎ»ÖÃºÅ¡¢GUID
		mainPet.idx = petIdx
		mainPet.guid.high = guidH
		mainPet.guid.low = guidL

		-- ½«ÕäÊŞÃû×ÖÌîµ½ÎÄ±¾¿òÖĞ
		PetSavvy_Pet1_Text : SetText( petName )

		-- ¸øÕäÊŞÉÏËø
		Pet : SetPetLocation( petIdx, 3 )
	-- Èç¹ûÊÇ¸¨Öú³è
	elseif currentChoose == 2 then
		if PlayerPackage:IsPetLock(petIdx) == 1 then
			PushDebugMessage("Ğã thêm khóa v¾i Trân Thú")
			return
		end
		-- XX Èç¹ûÃ»ÓĞ±»ÌáÉıµÄ³è´æÔÚ
		-- XX ÔòÌáÊ¾ĞèÒªÏÈ·ÅÈë±»ÌáÉıµÄ³è²¢·µ»Ø
		-- XX ÅĞ¶Ï¸¨Öú³èÊÇ·ñ·ûºÏÌõ¼ş
		-- XX Èç¹û²»·ûºÏÔò·µ»Ø
		-- Èç¹ûÔ­À´¾ÍÓĞ¸¨Öú³è
		-- ÔòÇå¿ÕÔ­À´µÄÊı¾İ
		PetSavvy_RemoveAssisPet()

		-- ¼ÇÂ¼¸Ã³èµÄÎ»ÖÃºÅ¡¢GUID
		assisPet.idx = petIdx
		assisPet.guid.high = guidH
		assisPet.guid.low = guidL

		-- ½«ÕäÊŞÃû×ÖÌîµ½ÎÄ±¾¿òÖĞ
		PetSavvy_Pet2_Text : SetText( petName )

		-- ¸øÕäÊŞÉÏËø
		Pet : SetPetLocation( petIdx, 3 )
	end

	-- ¸üĞÂ½ğÇ®ºÍ¼¸ÂÊÏÔÊ¾
	PetSavvy_CalcSuccOdds()
	PetSavvy_CalcCost()
end

function PetSavvy_UpdateSelected()
	-- AxTrace( 0, 1, "mainPet.guid.high=".. mainPet.guid.high .. "mainPet.guid.low=" .. mainPet.guid.low )
	-- AxTrace( 0, 1, "assisPet.guid.high=".. assisPet.guid.high .. "assisPet.guid.low=" .. assisPet.guid.low )
	-- AxTrace( 0, 1, "mainPet.idx=" .. mainPet.idx .. "assisPet.idx=" .. assisPet.idx )
	-- ÅĞ¶Ï±»Ñ¡ÖĞµÄÕäÊŞÊÇ·ñ»¹ÔÚ±³°üÀï
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( mainPet.guid.high, mainPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- Èç¹û²»ÔÚÔòÉ¾µô
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetSavvy_Pet1_Text : SetText( "" )
		-- ·ñÔòÅĞ¶ÏÕäÊŞµÄÎ»ÖÃÊÇ·ñ·¢Éú±ä»¯
		elseif newIdx ~= mainPet.idx then
			-- Èç¹û·¢Éú±ä»¯Ôò¶ÔÎ»ÖÃ½øĞĞ¸üĞÂ
			mainPet.idx = newIdx
		end
	end

	-- ÅĞ¶Ï±»Ñ¡ÖĞµÄÕäÊŞÊÇ·ñ»¹ÔÚ±³°üÀï
	if assisPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( assisPet.guid.high, assisPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- Èç¹û²»ÔÚÔòÉ¾µô
		if newIdx == -1 then
			assisPet.idx = -1
			assisPet.guid.high = -1
			assisPet.guid.low = -1
			PetSavvy_Pet2_Text : SetText( "" )
		-- ·ñÔòÅĞ¶ÏÕäÊŞµÄÎ»ÖÃÊÇ·ñ·¢Éú±ä»¯
		elseif newIdx ~= assisPet.idx then
			-- Èç¹û·¢Éú±ä»¯Ôò¶ÔÎ»ÖÃ½øĞĞ¸üĞÂ
			assisPet.idx = newIdx
		end
	end
end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	if theNPC == -1 then
		PushDebugMessage("Chßa phát hi®n NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "PetSavvy" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject()
	this : CareObject( theNPC, 0, "PetSavvy" )
	theNPC = -1
end
