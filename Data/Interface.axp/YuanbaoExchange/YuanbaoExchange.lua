local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Exchange_Rate = 1;
local g_Point = 0;
local g_Object = -1;
local g_YuanbaoExchange_Frame_UnifiedPosition;

function YuanbaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function YuanbaoExchange_OnLoad()
	g_YuanbaoExchange_Frame_UnifiedPosition=YuanbaoExchange_Frame:GetProperty("UnifiedPosition");
	local str0 = "#YQuà T£ng Bäo ThÕch khi quy ð±i Nguyên Bäo"
	local str1 = "#GL¥n 1#W: Khi quy ð±i s¯ nguyên bäo t× #G400 #Wtr· lên s¨ nh§n ðßþc viên #GH°ng Bäo ThÕch C¤p 3#W."
	local str2 = "#GL¥n 2#W: Khi quy ð±i s¯ nguyên bäo t× #G1666 #Wtr· lên s¨ nh§n ðßþc #GPhiªu Ð±i Bäo ThÕch C¤p 4#W."
	local str3 = "#GL¥n 3#W: Khi quy ð±i s¯ nguyên bäo t× #G1666 #Wtr· lên s¨ nh§n ðßþc #GPhiªu Ð±i Bäo ThÕch C¤p 4#W."
	local str_note0 = "--------------------"
	local str_note = "Lßu ý: Khi quy ð±i, vui lòng ð¬ tay näi có 2 ô tr¯ng trong túi ðÕo cø và túi nguyên li®u!"
	
	
	-- YuanbaoExchange_Text4:SetText(str0.."#r"..str1.."#r"..str2.."#r"..str3.."#r"..str_note)
end

function YuanbaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2001 ) then
			if this:IsVisible() then
				YuanbaoExchange_Close();
				return
			end
			g_Object = Get_XParam_INT(0);
			BeginCareObject_YuanbaoExchange(Target:GetServerId2ClientId(g_Object));
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			YuanbaoExchange_OnShown();
			this:Show();
			YuanbaoExchange_Count_Change();
			YuanbaoExchange_Max:Disable()
			YuanbaoExchange_OK : Disable()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2003 ) then
		if(this:IsVisible()) then
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			g_Point = Get_XParam_INT(0);
			YuanbaoExchange_Text1 : SetText("S¯ B€C t°n: "..(g_Point/1000))
			YuanbaoExchange_Max:Enable()
			YuanbaoExchange_OK:Enable()
			YuanbaoExchange_Moral_Value:Enable();
		end
	elseif ( event == "OBJECT_CARED_EVENT") then
		YuanbaoExchange_CareEventHandle(arg0,arg1,arg2);
	
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		YuanbaoExchange_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YuanbaoExchange_Frame_On_ResetPos()
	end

end

function YuanbaoExchange_OnShown()
	YuanbaoExchange_Clear();
	YuanbaoExchange_Update();
end

function YuanbaoExchange_Clear()
	YuanbaoExchange_Text1 : SetText("")
	YuanbaoExchange_Moral_Value : SetText("")
	YuanbaoExchange_Text3 : SetText("")
	g_Point = 0;
	Exchange_Rate = 1;
end

function YuanbaoExchange_Update()
	Exchange_Rate = Get_XParam_INT(1)/1000
	
	YuanbaoExchange_Text1 : SetText("#cff0000#bS¯ ði¬m dß ðang ðßþc tra, xin ðþi...")
	YuanbaoExchange_Text3 : SetText("S¯ ði¬m Nguyên Bäo nh§n ðßþc:  0")
	
end

function YuanbaoExchange_OK_Clicked()
	local str = YuanbaoExchange_Moral_Value : GetText();
	
	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 1 "..tostring(str));

	if str == nil or str == "" then
		YuanbaoExchange_Text3 : SetText("S¯ ði¬m Nguyên Bäo nh§n ðßþc:  0")
		PushDebugMessage("M¶i ði«n vào giá tr¸ ngân lßþng các hÕ ð±i")
		return
	end
	
	if tonumber(str) > 2000000 then
		PushDebugMessage("M²i l¥n ð±i giá tr¸ ngân lßþng l¾n nh¤t là 25.000, m¶i ði«n vào chæ s¯ nhö h½n ho£c b¢ng 2.000.000!")
		return
	end
	if( tonumber(str) <= 0 ) then
		PushDebugMessage("S¯ lßþng nguyên bäo m²i l¥n ð±i ít nh¤t là 1 ði¬m, xin vui lòng nh§p con s¯ l¾n h½n ho£c b¢ng 1")
		return
	end
	
	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 2");
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("BuyYuanbao");
		Set_XSCRIPT_ScriptID(181000);
		Set_XSCRIPT_Parameter(0,tonumber(str));
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
	
	YuanbaoExchange_Close();
end

function YuanbaoExchange_Close()
	YuanbaoExchange_OnHiden();
	this:Hide()
end

function YuanbaoExchange_Cancel_Clicked()
	YuanbaoExchange_Close();
	return;
end

function YuanbaoExchange_OnHiden()
	StopCareObject_YuanbaoExchange(objCared)
	YuanbaoExchange_Clear()
	return
end

function YuanbaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			YuanbaoExchange_Close();
		end
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_YuanbaoExchange(objCaredId)

	g_Object = objCaredId;
	--AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "YuanbaoExchange");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_YuanbaoExchange(objCaredId)
	this:CareObject(objCaredId, 0, "YuanbaoExchange");
	g_Object = -1;

end

function YuanbaoExchange_Count_Change()
	local str = YuanbaoExchange_Moral_Value : GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	YuanbaoExchange_Moral_Value:SetTextOriginal( str );
	YuanbaoExchange_Text3 : SetText("S¯ ði¬m Nguyên Bäo nh§n ðßþc: "..tostring( 1000*Exchange_Rate * strNumber ) )
end

function YuanbaoExchange_Max_Clicked()
	local maxYuanBao = 25000;
	local point2YuanBao = math.floor(g_Point/(Exchange_Rate*1000));
	if point2YuanBao < 0 then point2YuanBao = 0; end
	
	YuanbaoExchange_Moral_Value:SetProperty("ClearOffset", "True");
	if point2YuanBao > maxYuanBao then
		YuanbaoExchange_Moral_Value:SetText(tostring(maxYuanBao));
	else
		YuanbaoExchange_Moral_Value:SetText(tostring(point2YuanBao));
	end
	YuanbaoExchange_Moral_Value:SetProperty("CaratIndex", 1024);
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function YuanbaoExchange_Frame_On_ResetPos()
  YuanbaoExchange_Frame:SetProperty("UnifiedPosition", g_YuanbaoExchange_Frame_UnifiedPosition);
end