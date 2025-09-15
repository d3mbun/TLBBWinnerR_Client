-- PetSavvyGGD.lua
-- ÕäÊŞºÏ³É½çÃæ

local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

local theNPC = -1													-- ¹¦ÄÜ NPC
local MAX_OBJ_DISTANCE = 3.0

local currentChoose = -1

local moneyCosts = {													-- Ë÷ÒıÊÇÕäÊŞµÄµ±Ç°ÎòĞÔÖµ
	[0] = 100,
	[1] = 110,
	[2] = 121,
	[3] = 133,
	[4] = 146,
	[5] = 161,
	[6] = 177,
	[7] = 194,
	[8] = 214,
	[9] = 235,
}

function PetSavvyGGD_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- Íæ¼Ò´ÓÁĞ±íÑ¡¶¨Ò»Ö»ÕäÊŞ
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- Íæ¼ÒÉíÉÏµÄÕäÊŞÊı¾İ·¢Éú±ä»¯£¬°üÀ¨Ôö¼ÓÒ»Ö»ÕäÊŞ
	this : RegisterEvent( "DELETE_PET" )							-- Íæ¼ÒÉíÉÏ¼õÉÙÒ»Ö»ÕäÊŞ
	this : RegisterEvent( "OBJECT_CARED_EVENT" )					-- ¹ØĞÄ NPC µÄ´æÔÚºÍ·¶Î§
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--½»×ÓÆÕ¼° Vega
end

function PetSavvyGGD_OnLoad()
	PetSavvyGGD_Clear()
end


function PetSavvyGGD_OK_Clicked()
	-- Ê×ÏÈÅĞ¶¨Íæ¼ÒÊÇ·ñ·ÅÈëĞèÒªÌáÉıµÄÕäÊŞ£¬Èç¹ûÃ»ÓĞ·ÅÈëNPC½«»áµ¯³ö¶Ô»°²¢·µ»Ø£º
	if mainPet.idx == -1 then
	-- Çë·ÅÈëÄúÒªÌáÉıÎòĞÔµÈ¼¶µÄÕäÊŞ¡£
		ShowSystemTipInfo( "M¶i các hÕ nh§p yêu c¥u c¥n nâng cao nh§n thÑc thú quı cüa bÕn." )
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
	
	--¼ì²é ¸ú¹Ç µ¤
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	AxTrace(0,0,"nSavvyNeed:"..nSavvyNeed);
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "Th¤p";
		nItemIdGenGuDan = 30502000;
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "Trung"
		nItemIdGenGuDan = 30502001;
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "Cao"
		nItemIdGenGuDan = 30502002;
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	local bExist1 = IsItemExist( 30504038 );
	
	if bExist + bExist1 <= 0 then
		local msg = "Nâng ngµ tính ğªn "..nSavvyNeed.." C¥n "..msgTemp.." c¤p cån c¯t ğan. ";
		PetSavvyGGD_GGD : SetText( msg );
		SetNotifyTip( msg );
		return;
	end
	
	-- ·¢ËÍ UI_Command ½øĞĞºÏ³É
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetSavvy" )
		Set_XSCRIPT_ScriptID( 800106 )
		Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
		Set_XSCRIPT_Parameter( 1, mainPet.guid.low )		
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
		
	
end

function PetSavvyGGD_Cancel_Clicked()
	this : Hide()
end

function PetSavvyGGD_SelectPet( petIdx )
	if -1 == petIdx then
		return
	end
	
	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	-- ÅĞ¶Ï petIdex ´ú±íµÄÊÇ±»ÌáÉıµÄ³è»¹ÊÇ¸¨Öú³è
	-- Èç¹ûÊÇ±»ÌáÉıµÄ³è

		-- Èç¹ûÔ­À´ÒÑ¾­Ñ¡ÔñÁËÒ»¸ö±»ÌáÉıµÄ³è
		-- ÔòÇå¿ÕÔ­À´µÄÊı¾İ
		PetSavvyGGD_RemoveMainPet()

		-- XX Èç¹ûÔ­À´¾ÍÓĞ¸¨Öú³è²¢ÇÒ¸¨Öú³è²»·ûºÏĞÂµÄÌõ¼ş
		-- XX ÔòÇå¿Õ¸¨Öú³èµÄÊı¾İ
		-- ¼ÇÂ¼¸Ã³èµÄÎ»ÖÃºÅ¡¢GUID
		mainPet.idx = petIdx
		mainPet.guid.high = guidH
		mainPet.guid.low = guidL
		
		local savvy = Pet : GetSavvy( mainPet.idx )
		
		if savvy <=9 then
			-- ½«ÕäÊŞÃû×ÖÌîµ½ÎÄ±¾¿òÖĞ
			PetSavvyGGD_Pet : SetText( petName )
			-- ¸øÕäÊŞÉÏËø
			Pet : SetPetLocation( petIdx, 3 )
		else
			--ÎòĞÔ´óÓÚ9¾Í²»ÄÜÔÙÌáÉıÁË....
			PetSavvyGGD_Pet : SetText( "" )
			PetSavvyGGD_GGD : SetText( "" )
			PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", 0 )
			PetSavvyGGD_Text2 : SetText( "Không có cách nào thång c¤p" )
			PetSavvyGGD_OK:Disable();
			return
		end

	-- ¸üĞÂ½ğÇ®ºÍ¼¸ÂÊÏÔÊ¾
	PetSavvyGGD_CalcSuccOdds()
	PetSavvyGGD_CalcCost()
	
	local savvy = Pet : GetSavvy( mainPet.idx )
	--¼ì²é ¸ú¹Ç µ¤
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	AxTrace(0,0,"nSavvyNeed:"..nSavvyNeed);
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "Th¤p";		
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "Trung"		
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "Cao"		
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	
	if bExist <= 0 then
		local msg = "Nâng ngµ tính ğªn "..nSavvyNeed.."C¥n "..msgTemp.." c¤p cån c¯t ğan. ";
		PetSavvyGGD_GGD : SetText( msg );		
		return;
	end
	
end

function PetSavvyGGD_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19820425 then	-- ´ò¿ª½çÃæ
		if this : IsVisible() then									-- Èç¹û½çÃæ¿ª×Å£¬Ôò²»´¦Àí
			return
		end

		this : Show()
		PetSavvyGGD_Pet : SetText( "" )
		PetSavvyGGD_Text2 : SetText( "" )
		PetSavvyGGD_NeedMoney:SetProperty("MoneyNumber", tostring(0));
		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetSavvyGGD_OK:Disable();
		return
	end
	
	if event == "REPLY_MISSION_PET" then		-- Íæ¼ÒÑ¡ÁËÒ»Ö»ÕäÊŞ
		PetSavvyGGD_GGD : SetText( "" );
		PetSavvyGGD_SelectPet( tonumber( arg0 ) )
	
		PetSavvyGGD_SelfMoney_Text:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_PET_PAGE" and this : IsVisible() then		-- Íæ¼ÒÉíÉÏµÄÕäÊŞÊı¾İ·¢Éú±ä»¯£¬°üÀ¨Ôö¼ÓÒ»Ö»ÕäÊŞ
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "DELETE_PET" and this : IsVisible() then			-- Íæ¼ÒÉíÉÏ¼õÉÙÒ»Ö»ÕäÊŞ
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- ¹ØĞÄ NPC µÄ´æÔÚºÍ·¶Î§
		Pet : ShowPetList( 0 )
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ı£¬×Ô¶¯¹Ø±Õ
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			
			PetSavvyGGD_Cancel_Clicked()
		end
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
	
end

function PetSavvyGGD_Choose_Clicked( type )

	-- ¹ØÒ»ÏÂÔÙ¿ª£¬Çå¿ÕÊı¾İ
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end


function PetSavvyGGD_Close()
	Pet : ShowPetList( 0 )
	StopCareObject()
	PetSavvyGGD_Clear()
end

function PetSavvyGGD_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation( mainPet.idx, -1 )
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
end

function PetSavvyGGD_Clear()
	PetSavvyGGD_RemoveMainPet()
	
	PetSavvyGGD_GGD : SetText( "" );
	PetSavvyGGD_Pet : SetText( "" );
	PetSavvyGGD_Text2 : SetText( "#cFF0000TÖ l® thành công" )
	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )

	PetSavvyGGD_OK : Disable()

	currentChoose = -1
end

function PetSavvyGGD_Check()
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
function PetSavvyGGD_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetSavvyGGD_Text2 : SetText( "#cFF0000TÖ l® thành công" )
		PetSavvyGGD_OK : Disable()
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
		[9] = 100,
	}

	local savvy = Pet : GetSavvy( mainPet.idx )
	local str = "#cFF0000"
	local odds = succOdds[savvy]
	if not odds then
		str = "Không có cách nào thång c¤p"
		PetSavvyGGD_OK : Disable()
	else
		str = str .. math.floor( odds / 10 ) .. "%"
		PetSavvyGGD_OK : Enable()
	end

	PetSavvyGGD_Text2 : SetText( str )
end

-- ¼ÆËã½ğÇ®ÏûºÄ
function PetSavvyGGD_CalcCost()
	if mainPet.idx == -1 then
		PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( cost ) )
end


function PetSavvyGGD_UpdateSelected()
	-- ÅĞ¶Ï±»Ñ¡ÖĞµÄÕäÊŞÊÇ·ñ»¹ÔÚ±³°üÀï
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( mainPet.guid.high, mainPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- Èç¹û²»ÔÚÔòÉ¾µô
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetSavvyGGD_Pet : SetText( "" )
		-- ·ñÔòÅĞ¶ÏÕäÊŞµÄÎ»ÖÃÊÇ·ñ·¢Éú±ä»¯
		elseif newIdx ~= mainPet.idx then
			-- Èç¹û·¢Éú±ä»¯Ôò¶ÔÎ»ÖÃ½øĞĞ¸üĞÂ
			mainPet.idx = newIdx
		end
	end

	PetSavvyGGD_SelectPet( mainPet.idx );
	
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

	this : CareObject( theNPC, 1, "PetSavvyGGD" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject()
	this : CareObject( theNPC, 0, "PetSavvyGGD" )
	Pet : ShowPetList( 0 )
	theNPC = -1
end
