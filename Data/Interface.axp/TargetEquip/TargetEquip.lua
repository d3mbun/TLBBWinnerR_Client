
--------------------------------------------------------------------------------
-- ×°±¸°´Å¥Êý¾Ý¶¨Òå
--
local  g_WEAPON;		--ÎäÆ÷
local  g_ARMOR;			--ÒÂ·þ
local  g_CAP;			--Ã±×Ó
local  g_CUFF;			--»¤Íó
local  g_BOOT;			--Ð¬
local  g_RING;			--½ä×Ó
local  g_SASH;			--Ñü´ø
local  g_NECKLACE;		--ÏîÁ´
local  g_Dark;			--×øÆï---ÒÑÐÞ¸ÄÎª°µÆ÷
local  g_Charm;			-- »¤·û
local  g_Charm2;		-- »¤·û2
local  g_Shoulder;		-- »¤¼ç
local  g_Glove;			-- ÊÖÌ×
local  g_Ring2;			-- ½äÖ¸2
local  g_FashionDress;	-- Ê±×°

local Cur_Name = "";
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

local TARGETEQUIP_TAB_TEXT = {};

function TargetEquip_PreLoad()

	-- ´ò¿ª½çÃæ
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("CLOSE_TARGET_EQUIP");
	this:RegisterEvent("OBJECT_CARED_EVENT");

end

function TargetEquip_OnLoad()

	-- action buttion °´Å¥
	g_WEAPON		= TargetEquip_Equip11;		--ÎäÆ÷
	g_ARMOR			= TargetEquip_Equip12;		--ÒÂ·þ
	g_CAP			= TargetEquip_Equip1;		--Ã±×Ó
	g_CUFF			= TargetEquip_Equip8;		--»¤Íó
	g_BOOT			= TargetEquip_Equip4;		--Ð¬
	g_RING			= TargetEquip_Equip6;		--½ä×Ó
	g_SASH			= TargetEquip_Equip7;		--Ñü´ø
	g_NECKLACE		= TargetEquip_Equip13;		--ÏîÁ´
	g_Dark			= TargetEquip_Equip14;		--×øÆï
	g_Charm			= TargetEquip_Equip9;		-- »¤·û
	g_Charm2		= TargetEquip_Equip10;		-- »¤·û2
	g_Shoulder		= TargetEquip_Equip3;		-- »¤¼ç
	g_Glove			= TargetEquip_Equip2;		-- ÊÖÌ×
	g_Ring2			= TargetEquip_Equip5;		-- ½äÖ¸2
	g_FashionDress	= TargetEquip_Equip15;		-- Ê±×°
	
	TARGETEQUIP_TAB_TEXT = {
		[0] = "Ð°",
		"Nhân",
		"Thú",
		"KÜ",
	};
end
function TargetEquip_SetTabColor(idx)

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = TargetEquip_SelfEquip,
								TargetEquip_TargetData,								
								TargetEquip_Pet,
								TargetEquip_Ride,
							};
	
	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..TARGETEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..TARGETEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
-- OnEvent
function TargetEquip_OnEvent(event)

	if ( event == "MAINTARGET_CHANGED" and tonumber(arg0) == -1) then
--		if(this:IsVisible()) then
--			TargetEquip_CloseUI();
--		end
		return;
	end

	if( "PLAYER_LEAVE_WORLD" == event) then
		this : Hide();
		return;
	end

	-- ×°±¸±ä»¯Ê±Ë¢ÐÂ×°±¸.
	if("OTHERPLAYER_UPDATE_EQUIP" == event) then

		if (not CachedTarget:IsPresent(1)) or (type(CachedTarget:GetData("NPCID", 1))~="number") then
			return;
		end

		local otherUnionPos = Variable:GetVariable("OtherUnionPos");
		if(otherUnionPos ~= nil) then
			TargetEquip_Frame:SetProperty("UnifiedPosition", otherUnionPos);
		end
		TargetEquip_SetTabColor(0);
--		TargetEquip_TargetPet:Disable();
		TargetEquip_SelfEquip:SetCheck(1);
		TargetEquip_TargetData:SetCheck(0);
		TargetEquip_FakeObject:SetFakeObject("");
		CachedTarget:TargetEquip_ChangeModel();
		TargetEquip_FakeObject:SetFakeObject("Target");
		TargetEquip_OnUpdateShow();
		TargetEquip_RefreshEquip();
		this:Show();
		return;
	end

	if( "CLOSE_TARGET_EQUIP" == event ) then

		this : Hide();
		return;
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if( arg1=="destroy") then
			this:Hide();

			--È¡Ïû¹ØÐÄ
			StopCareObject_TargetEquip(objCared);
		end

	end

end

-- ¸üÐÂÖ÷½Ç»ù±¾ÐÅÏ¢
function TargetEquip_OnUpdateShow()
	local PlayerTarget = GetTargetPlayerGUID();
	if PlayerTarget ~= nil then
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045002)
		Set_XSCRIPT_Parameter(0,0)
		Set_XSCRIPT_Parameter(1,PlayerTarget)
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end
	
	local nNumber=0;
	local nMaxnumber=0;
	local strName;

	objCared = CachedTarget:GetData("NPCID",1)

	if(type(objCared) ~="number") then
		return
	end
	
	strCharName =  CachedTarget:GetData("NAME");
	strAccount =  CachedTarget:GetData("ACCOUNTNAME")

	BeginCareObject_TargetEquip(objCared)
	-- µÃµ½×Ô¼ºµÄÃû×Ö
  strName = CachedTarget:GetData("NAME",1);
  Cur_Name = strName;
	TargetEquip_PageHeader:SetText("#gFF0FA0" .. strName );
	--µÃµ½³ÆºÅ
	strName = CachedTarget:GetData("TITLE",1)
	TargetEquip_Agname:SetText( ""..strName );
	strName = CachedTarget:GetData("GUILD",1)
	TargetEquip_Confraternity:SetText( ""..strName );
		-- µÃµ½µÈ¼¶
	nNumber = CachedTarget:GetData("LEVEL",1);
	TargetEquip_Level:SetText("C¤p: " .. tostring( nNumber ));

	-- µÃµ½ÅäÅ¼ÐÅÏ¢
	local szConsort = SystemSetup:GetPrivateInfo("other","Consort");
	TargetEquip_Spouse:SetText(szConsort);

	-- ÃÅÅÉ
	local menpai = CachedTarget:GetData("MEMPAI",1);
	local strName = "";

	-- µÃµ½ÃÅÅÉÃû³Æ.
	-- AxTrace(0,0,"ÃÅ="..menpai);
	if(0 == menpai) then
		strName = "Thiªu Lâm";

	elseif(1 == menpai) then
		strName = "Minh Giáo";

	elseif(2 == menpai) then
		strName = "Cái Bang";

	elseif(3 == menpai) then
		strName = "Võ Ðang";

	elseif(4 == menpai) then
		strName = "Nga My";

	elseif(5 == menpai) then
		strName = "Tinh Túc";

	elseif(6 == menpai) then
		strName = "Thiên Long";

	elseif(7 == menpai) then
		strName = "Thiên S½n";

	elseif(8 == menpai) then
		strName = "Tiêu Dao";

	elseif(9 == menpai) then
		strName = "Không có";

	elseif(10 == menpai) then
		strName = "Mµ Dung";
	end

	-- ÉèÖÃÏÔÊ¾µÄÃÅÅÉ.
	-- AxTrace(0,1,"strName="..strName)
	TargetEquip_MenPai:SetText("" .. strName);

	local szLuck = SystemSetup:GetPrivateInfo("other","luck");
	if(szLuck == "ß@¼Ò»ïºÜ‘Ð£¬Ê²Ã´Ò²›]ÓÐÁôÏÂ!") then 
	szLuck = "Hi®n tÕi hÕ ðang bª quan tu luy®n, xin các hÕ vui lòng quay lÕi sau!"
	end
	TargetEquip_Message:SetText(szLuck);

end

-- Ë¢ÐÂ×°±¸
function TargetEquip_RefreshEquip()

	--  Çå¿Õ°´Å¥ÏÔÊ¾Í¼±ê
	g_WEAPON:SetActionItem(-1);			--ÎäÆ÷
	g_CAP:SetActionItem(-1);				--Ã±×Ó
	g_ARMOR:SetActionItem(-1);			--¿ø¼×
	g_CUFF:SetActionItem(-1);				--»¤Íó
	g_BOOT:SetActionItem(-1);				--Ð¬
	g_SASH:SetActionItem(-1);				--Ñü´ø
	g_RING:SetActionItem(-1);				--½ä×Ó
	g_NECKLACE:SetActionItem(-1);		--ÏîÁ´
	g_Dark:SetActionItem(-1);			--×øÆï
	g_Charm:SetActionItem(-1);		-- »¤·û
	g_Charm2:SetActionItem(-1);		-- »¤·û2
	g_Shoulder:SetActionItem(-1);		-- »¤¼ç
	g_Glove:SetActionItem(-1);		-- ÊÖÌ×
	g_Ring2:SetActionItem(-1);		-- ½äÖ¸2
	g_FashionDress:SetActionItem(-1);		-- Ê±×°

	local ActionWeapon 		= EnumAction(0, "targetequip");
	local ActionCap    		= EnumAction(1, "targetequip");
	local ActionArmor  		= EnumAction(2, "targetequip");
	local ActionGlove		= EnumAction(3, "targetequip");
	local ActionBoot   		= EnumAction(4, "targetequip");
	local ActionSash   		= EnumAction(5, "targetequip");
	local ActionRing    	= EnumAction(6, "targetequip");
	local ActionNecklace	= EnumAction(7, "targetequip");
	local ActionDark		= EnumAction(17, "targetequip");    --ÐÞ¸ÄÎª°µÆ÷  by houzhifang
	local ActionRing2		= EnumAction(11, "targetequip");
	local ActionCharm		= EnumAction(12, "targetequip");
	local ActionCharm2		= EnumAction(13, "targetequip");
	local ActionCuff  		= EnumAction(14, "targetequip");
	local ActionShoulder	= EnumAction(15, "targetequip");
	local ActionDress		= EnumAction(16, "targetequip");

	-- ÏÔÊ¾ÈËÉíÉÏµÄÎäÆ÷×°±¸
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--ÎäÆ÷
	g_CAP:SetActionItem(ActionCap:GetID());						--Ã±×Ó
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--¿ø¼×
	g_CUFF:SetActionItem(ActionCuff:GetID());					--»¤Íó
	g_BOOT:SetActionItem(ActionBoot:GetID());					--Ð¬
	g_SASH:SetActionItem(ActionSash:GetID());					--Ñü´ø
	g_RING:SetActionItem(ActionRing:GetID());					--½ä×Ó
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--ÏîÁ´
	g_Dark:SetActionItem(ActionDark:GetID());				--×øÆï
	g_Charm:SetActionItem(ActionCharm:GetID());		-- »¤·û
	g_Charm2:SetActionItem(ActionCharm2:GetID());		-- »¤·û2
	g_Shoulder:SetActionItem(ActionShoulder:GetID());		-- »¤¼ç
	g_Glove:SetActionItem(ActionGlove:GetID());		-- ÊÖÌ×
	g_Ring2:SetActionItem(ActionRing2:GetID());		-- ½äÖ¸2
	g_FashionDress:SetActionItem(ActionDress:GetID());		-- Ê±×°

end

----------------------------------------------------------------------------------
--
-- Ðý×ªÍæ¼ÒÄ£ÐÍ£¨Ïò×ó)
--
function TargetEquip_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- Ðý×ªÍæ¼ÒÄ£ÐÍ£¨ÏòÓÒ)
--
function TargetEquip_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------------
--
-- ¹Ø±Õ½çÃæ
--

function TargetEquip_CloseUI()
	-- AxTrace(0,1,"asldkfj")
	StopCareObject_TargetEquip(objCared);
	TargetEquip_FakeObject:SetFakeObject("");
	

	CachedTarget:TargetEquip_DestroyUIModel();
end

function Set_To_Private()
		CachedTarget:Set_To_Private(Cur_Name);
end

----------------------------------------------------------------------------------------
--
-- ´ò¿ªÍæ¼ÒÐÅÏ¢½çÃæ
--
function TargetEquip_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end

function Set_To_Friend()
	DataPool:AddFriend( Friend:GetCurrentTeam(),Cur_Name );
end

function TargetEquip_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end

function TargetEquip_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_TargetEquip(objCaredId)

	g_Object = objCaredId;
	-- AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "TargetEquip");

end
function TargetEquip_TargetWuhun_Switch()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	--SystemSetup:OpenRidePage("other");
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end
--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_TargetEquip(objCaredId)
	this:CareObject(objCaredId, 0, "TargetEquip");
	g_Object = -1;

end