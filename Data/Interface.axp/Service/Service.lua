local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Current = 0;

local g_Object = -1;
local Prompt_Text = {}

function Service_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_SERVICE");
	this:RegisterEvent("RESUME_ENCHASE_GEM");

end

function Service_OnLoad()
	EQUIP_BUTTONS = Service_Item
	Prompt_Text[1] = "  Các hÕ có th¬ ðúc sØa chæa vû khí b«n hÕ th¤p. Vû khí mu¯n sØa chæa c¥n phäi có ðÆng c¤p ít nh¤t là >= c¤p 40. Vû khí c¤p 40 tr· xu¯ng m¶i tìm thß½ng nhân bán hàng ð¬ sØa chæa.#rVû khí sØa chæa c¥n ðÆng c¤p kÛ nång ðúc cüa các hÕ *12 không nhö h½n ðÆng c¤p yêu c¥u cüa vû khí.#rSØa chæa có th¬ th¤t bÕi, t±ng cµng 3 l¥n th¤t bÕi vû khí báo bö ði. ÐÆng c¤p kÛ nång ðúc cüa các hÕ càng cao, khä nång th¤t bÕi càng nhö.#rM¶i ðßa vû khí sØa chæa ðªn làn v§t ph¦m dß¾i ðây, ¤n nút\"SØa chæa\".#rM²i l¥n sØa chæa tiêu hao sÑc s¯ng = ðÆng c¤p vû khí +4.#rÐÆng c¤p vû khí = yêu c¥u ðÆng c¤p vû khí /10+1 nh§n v« sau."
	Prompt_Text[2] = "  Các hÕ có th¬ may sØa chæa v§t phòng b«n hÕ th¤p. V§t phòng mu¯n sØa chæa c¥n phäi có ðÆng c¤p ít nh¤t là >= c¤p 40. V§t phòng c¤p 40 tr· xu¯ng m¶i tìm thß½ng nhân bán hàng ð¬ sØa chæa.#rV§t phòng sØa chæa c¥n ðÆng c¤p kÛ nång may cüa các hÕ *12 không nhö h½n ðÆng c¤p yêu c¥u cüa v§t phòng.#rSØa chæa có th¬ th¤t bÕi, t±ng cµng 3 l¥n th¤t bÕi v§t phòng s¨ báo bö ði. ÐÆng c¤p kÛ nång may cüa các hÕ càng cao, khä nång th¤t bÕi càng nhö.#rM¶i ðßa v§t phòng sØa chæa ðªn làn v§t ph¦m dß¾i ðây, ¤n nút\"SØa chæa\".#rM²i l¥n sØa chæa tiêu hao sÑc s¯ng = ðÆng c¤p v§t phòng +4.#rÐÆng c¤p v§t phòng= yêu c¥u ðÆng c¤p v§t phòng /10+1 nh§n v« sau."
	Prompt_Text[3] = "  Các hÕ có th¬ công ngh® sØa chæa ð° trang sÑc b«n hÕ th¤p. Ð° trang sÑc mu¯n sØa chæa c¥n phäi có ðÆng c¤p ít nh¤t là >= c¤p 40. Ð° trang sÑc c¤p 40 tr· xu¯ng m¶i tìm thß½ng nhân bán hàng ð¬ sØa chæa.#rÐ° trang sÑc sØa chæa c¥n ðÆng c¤p kÛ nång công ngh® cüa các hÕ *12 không nhö h½n ðÆng c¤p yêu c¥u cüa ð° trang sÑc.#rSØa chæa có th¬ th¤t bÕi, t±ng cµng 3 l¥n th¤t bÕi ð° trang sÑc báo bö ði. ÐÆng c¤p kÛ nång công ngh® cüa các hÕ càng cao, khä nång th¤t bÕi càng nhö.#rM¶i ðßa ð° trang sÑc sØa chæa ðªn làn v§t ph¦m dß¾i ðây, ¤n nút\"SØa chæa\".#rM²i l¥n sØa chæa tiêu hao sÑc s¯ng = ðÆng c¤p ð° trang sÑc +4.#rÐÆng c¤p ð° trang sÑc= yêu c¥u ðÆng c¤p ð° trang sÑc /10+1 nh§n v« sau."
end

function Service_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 41) then
			this:Show();

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ð«");
					return;
			end
			BeginCareObject_Service(objCared)
			Current = Get_XParam_INT(1);
			Service_Text:SetText(Prompt_Text[Current]);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			Service_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (EQUIP_QUALITY == tonumber(arg0) ) then
				Service_Clear()
				Service_Update(tonumber(arg0))
			end
		end
	elseif( event == "UPDATE_SERVICE") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 ~= nil then
			Service_Clear()
			Service_Update(tonumber(arg0));
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 5) then
			Service_Clear()
		end
		
	end
	
end

function Service_OnShown()
	Service_Clear()
end

function Service_Clear()

	EQUIP_BUTTONS : SetActionItem(-1);
	Service_Item_Explain:SetText("")
	LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
	EQUIP_QUALITY = -1;

end

function Service_Update(pos0)
	local pos_packet;
	pos_packet = tonumber(pos0);

	local theAction = EnumAction(pos_packet, "packageitem");
	
	if theAction:GetID() ~= 0 then
		EQUIP_BUTTONS:SetActionItem(theAction:GetID());
		Service_Item_Explain:SetText(theAction:GetName());
		if EQUIP_QUALITY ~= -1 then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
		--ÈÃÖ®Ç°µÄ¶«Î÷±äÁÁ
		EQUIP_QUALITY = pos_packet;
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
	else
		EQUIP_BUTTONS:SetActionItem(-1);
		Service_Item_Explain:SetText("")
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
		return;
	end

--add here
end

function Service_Buttons_Clicked()

	if EQUIP_QUALITY ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnService");
			Set_XSCRIPT_ScriptID(801015);
			Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	else
		PushDebugMessage("M¶i kéo thiªt b¸ sØa chæa vào trong khoang v§t ph¦m.")
	end
	
end

function Service_Close()
	--²¢ÉèÖÃ£¬ÈÃ±³°üÀïµÄÎ»ÖÃ±äÁÁ
	if( this:IsVisible() ) then
		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
	end
	this:Hide();
	Service_Clear();
	StopCareObject_Service(objCared)
end

function Service_Cancel_Clicked()
	Service_Close();
	return;
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Service(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Service");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Service(objCaredId)
	this:CareObject(objCaredId, 0, "Service");
	g_Object = -1;

end

function Resume_Equip()

	if( this:IsVisible() ) then

		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_BUTTONS : SetActionItem(-1);
			Service_Item_Explain:SetText("")
			EQUIP_QUALITY	= -1;
		end	
	end
	
end
