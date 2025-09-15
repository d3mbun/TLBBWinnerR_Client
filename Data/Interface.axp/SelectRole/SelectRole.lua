
-----------------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿Çø
--

-- Ãû×Ö
local g_RoleName = {};

-- ÃÅÅÉ
local g_iMenPai = {};

-- µÈ¼¶
local g_iLevel = {};

-- µÈ¼¶
local g_iDelTime = {};

-- ÔÚ½çÃæÉÏÏÔÊ¾µÄuiÄ£ÐÍ
local g_UIModel = {};

-- Ñ¡Ôñ°´Å¥
local g_BnSelCheck = {};

-- µ±Ç°Ñ¡ÔñµÄ½ÇÉ«
local g_iCurSelRole = 0;

-- µ±Ç°½ÇÉ«µÄ¸öÊý
local g_iCurRoleCount = 0;

-- Èç¹ûÊÇ´´½¨³É¹¦ºóË¢ÐÂ½çÃæ£¬ ÒªÑ¡ÖÐ×îºó´´½¨µÄÕâ¸ö½ÇÉ«.
--
-- 0 -- ´´½¨½ÇÉ«Ê§°Ü¡£
-- 1 -- ´´½¨½ÇÉ«³É¹¦¡£
local g_bCreateSuccess = 0;

------------------------------------------------------------------------------------------------------------------
--
-- º¯ÊýÇø
--

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectRole_PreLoad()
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_CHARACTOR");
	
	-- ¹Ø±Õ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_CHARACTOR");
	
	-- Ë¢ÐÂ½ÇÉ«ÐÅÏ¢
	this:RegisterEvent("GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR"); 
	
	-- ´´½¨½ÇÉ«³É¹¦¡£
	this:RegisterEvent("GAMELOGIN_CREATE_ROLE_OK"); 

	this:RegisterEvent("ENTER_GAME"); 
	
	this:RegisterEvent("GAMELOGIN_SELECTCHARACTER"); 
	
end

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectRole_OnLoad()

	-- ½ÇÉ«Ãû×Ö
	--g_RoleName[1] = SelectRole_Role1_Name;
	--g_RoleName[2] = SelectRole_Role2_Name;
	--g_RoleName[3] = SelectRole_Role3_Name;
	
	g_RoleName[1] = ""
	g_RoleName[2] = ""
	g_RoleName[3] = ""
		
	-- ½ÇÉ«ÃÅÅÉ
	g_iMenPai[1] = 0;
	g_iMenPai[2] = 0;
	g_iMenPai[3] = 0;
	
	-- ½ÇÉ«µÈ¼¶
	g_iLevel[1] = 0;
	g_iLevel[2] = 0;
	g_iLevel[3] = 0;
	
	g_iDelTime[1] = 0;
	g_iDelTime[2] = 0;
	g_iDelTime[3] = 0;
	
end

-- OnEvent
function LoginSelectRole_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_SELECT_CHARACTOR" ) then
	    
	    local CurSelIndex = GameProduceLogin:GetCurSelectRole();
	    
		-- Ä¬ÈÏÑ¡ÔñµÚÒ»¸öÈËÎï¡£
		g_iCurSelRole = CurSelIndex + 1  --1;
		
		AxTrace( 1, 0, g_iCurSelRole )
		
		SelectRole_ClearInfo();
		SelectRole_RefreshRoleInfo();
		this:Show();
		return;
	end
	
	
	if( event == "GAMELOGIN_CLOSE_SELECT_CHARACTOR" ) then
	
		-- Çå¿ÕÊý¾Ý
		SelectRole_ClearInfo();
		this:Hide();
		return;
	end
	
	
	-- Ë¢ÐÂ½ÇÉ«
	if( event == "GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR") then
		
		SelectRole_RefreshRoleInfo();
		return;
	end
	
	
	-- ´´½¨½ÇÉ«³É¹¦¡£
	if( event == "GAMELOGIN_CREATE_ROLE_OK") then
		
		g_bCreateSuccess = 1;
		return;
	end

	if( event == "ENTER_GAME" ) then
		GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
		return;
	end
	
	if( event == "GAMELOGIN_SELECTCHARACTER" ) then
	   local CurSel = tonumber( arg0 )
	   
	   if( 0 == CurSel ) then 
	     SelectRole_SelectRole1()
	   end
	   
	   if( 1 == CurSel ) then 
	     SelectRole_SelectRole2()
	   end
	   
	   if( 2 == CurSel ) then 
	     SelectRole_SelectRole3()
	   end
	   
	end
			
 		
end



---------------------------------------------------------------------------------------------
--
-- ½øÈëÓÎÏ·
--
function SelectRole_EnterGame()

	-- ·¢ËÍ½øÈëÓÎÏ·ÏûÏ¢
	GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
end

---------------------------------------------------------------------------------------------
--
-- ´´½¨½ÇÉ«
--
function SelectRole_CreateRole()

	--´Ë´¦²»Ö±½Ó´ÓÈËÎïÑ¡Ôñ½çÃæÇÐ»»µ½ÈËÎï´´½¨½çÃæ....
	--ÏòLoginÇëÇó´´½¨ÈËÎïµÄÍ¼ÐÎÑéÖ¤ÐÅÏ¢....ÑéÖ¤ÐÅÏ¢µ½À´ºó»á¿ªÆôÑéÖ¤½çÃæ....ÑéÖ¤Í¨¹ýºóÑéÖ¤½çÃæ»áÇÐ»»µ½ÈËÎï´´½¨Á÷³Ì....
	DataPool:AskCreateCharCode();

end



---------------------------------------------------------------------------------------------
--
-- É¾³ý½ÇÉ«
--
function SelectRole_DelRole()

	GameProduceLogin:SetCurSelect( g_iCurSelRole - 1 );
	-- ´ÓÈËÎïÑ¡Ôñ½çÃæÇÐ»»µ½ÈËÎï´´½¨½çÃæ.
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	strName
	,iMenPai
	,iLevel
	,iDelTime
	= GameProduceLogin:GetRoleInfo(g_iCurSelRole-1);
	if( iLevel == 0 ) then --ËµÃ÷Ã»ÓÐ½ÇÉ«
		strInfo="Không ch÷n nhân v§t";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "6" );
		return;
	end
	if( iLevel >= 1 ) then --Èç¹û´óÓÚ10¼¶
		if( iDelTime >= 11 ) then--ËµÃ÷»¹²»ÄÜÉ¾³ýÄØ£¬³öÌáÊ¾¶Ô»°¿ò
			strInfo="Hüy bö xin ðã ðßa cho"..tostring( 14 - iDelTime ).."ngày r°i, sau 3 ngày khi hüy bö nhân v§t, trong vòng 14 ngày ðång nh§p trò ch½i, hãy ðªn thành LÕc Dß½ng (268, 46) tìm Quan Hán Th÷ ho£c ho£c ÐÕi Lý (80, 136) tìm Chu Xß½ng xác nh§n.";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "6" );
		elseif( iDelTime > 0 ) then		--ËµÃ÷¿ÉÒÔÉ¾³ýÄØ£¬³öÌáÊ¾¶Ô»°¿ò
			strInfo="Xin ðång nh§p vào trò ch½i, ðªn LÕc Dß½ng (268,46) tìm Quan Hán Th÷ ho£c ÐÕi Lý (80,136) tìm Chu Xß½ng xác nh§n, có th¬ xóa bö. Các hÕ c¥n phäi không có bang hµi, kªt hôn, m· ti®m, kªt bái, sß ð° các loÕi quan h® này m¾i có th¬ xóa bö. ";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "5" );
		else --ËµÃ÷ÒªÉ¾³ýÁË£¬³öÏÖÌáÊ¾¶Ô»°¿ò
			strInfo = "Các hÕ quyªt ð¸nh mu¯n s¨"..tostring( iLevel ).."Nhân v§t c¤p #c00ff00"..strName.."#cffffff hüy bö không?";
			GameProduceLogin:ShowMessageBox( strInfo, "YesNo", "4" );
		end
	else --Ö±½Ó³öÏÖÌáÊ¾£¬ÊÇ·ñÉ¾³ý
		strInfo = "Các hÕ quyªt ð¸nh mu¯n s¨"..tostring( iLevel ).."Nhân v§t c¤p #c00ff00"..strName.."#cffffff hüy bö không?";
		GameProduceLogin:ShowMessageBox( strInfo, "YesNo", "7" );
	end
	
end
	
	
---------------------------------------------------------------------------------------------
--
-- ·µ»Øµ½ÉÏÒ»²½
--				
function SelectRole_Return()
			
	GameProduceLogin:ExitToAccountInput_YesNo();	
	--GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
end
				

---------------------------------------------------------------------------------------------------------------
--
--   Ë¢ÐÂ½ÇÉ«ÐÅÏ¢
--
function SelectRole_RefreshRoleInfo()

	-- Çå¿Õ½çÃæ.
	SelectRole_ClearInfo();
	
	g_iCurRoleCount = GameProduceLogin:GetRoleCount();
	-- µÃµ½ÈËÎïµÄ¸öÊý
	AxTrace( 0,0, "ÐÕt ðßþc s¯ nhân v§t "..tostring(g_iCurRoleCount));
	
	if(0 == g_iCurRoleCount) then
	
		return;
	end;
	
	for index =0 , g_iCurRoleCount-1 do
	 		
	 		AxTrace( 0,0, "Hi¬n th¸ nhân v§t "..tostring(index));
			SelectRole_GetRoleInfo(index);
	end
	
	-- Ñ¡Ôñ½ÇÉ«
	if(1 == g_bCreateSuccess) then
			
			-- ´´½¨³É¹¦ºó
			g_iCurSelRole = g_iCurRoleCount;
			g_bCreateSuccess = 0;
	end
			
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end


---------------------------------------------------------------------------------------------------------------
--
--   Ë¢ÐÂ½ÇÉ«ÐÅÏ¢
--
function SelectRole_GetRoleInfo(index)

	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	
	strName
	,iMenPai
	,iLevel
	,iDelTime
	= GameProduceLogin:GetRoleInfo(index);
	
	-- ÉèÖÃÃû×Ö
	--g_RoleName[index+1]:SetText(strName);
	g_RoleName[index+1] = strName;
	g_iMenPai[index+1] = iMenPai;
	g_iLevel[index+1]  = iLevel;
	g_iDelTime[index+1] = iDelTime;
	
end

---------------------------------------------------------------------------------------------------------------
--
--   Çå¿Õ½ÇÉ«ÐÅÏ¢.
--
function SelectRole_ClearInfo()

	SelectRole_TargetInfo_Name_Text:SetText("");
	SelectRole_TargetInfo_Menpai_Text:SetText("");
	SelectRole_TargetInfo_Level_Text:SetText("");
	SelectRole_TargetInfo_Delete:Hide();
	--g_RoleName[1]:SetText("");
	--g_RoleName[2]:SetText("");
	--g_RoleName[3]:SetText("");
	
	--g_UIModel[1]:SetFakeObject("");
	--g_UIModel[2]:SetFakeObject("");
	--g_UIModel[3]:SetFakeObject("");
		
end


---------------------------------------------------------------------------------------------------------------
--
--   Ñ¡Ôñ½ÇÉ«1.
--
function SelectRole_SelectRole1()

	AxTrace( 0,0, " Ch÷n 1");	
	g_iCurSelRole = 1;
	if(g_iCurRoleCount < g_iCurSelRole) then

		AxTrace( 0,0, " Chßa ch÷n 1 trong s¯ dß¾i ðây");	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end

---------------------------------------------------------------------------------------------------------------
--
--   Ñ¡Ôñ½ÇÉ«2.
--
function SelectRole_SelectRole2()

	AxTrace( 0,0, " Ch÷n 2");	
	g_iCurSelRole = 2;
	if(g_iCurRoleCount < g_iCurSelRole) then
	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end


---------------------------------------------------------------------------------------------------------------
--
--   Ñ¡Ôñ½ÇÉ«3.
--
function SelectRole_SelectRole3()

	AxTrace( 0,0, " Ch÷n 3");	
	g_iCurSelRole = 3;
	if(g_iCurRoleCount < g_iCurSelRole) then
	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end


---------------------------------------------------------------------------------------------------------------
--
--   Í¨¹ýË÷Òý, Ñ¡Ôñ½ÇÉ«
--
function SelectRole_ShowSelRoleInfo(index)

	if(g_iCurRoleCount < index or 0 >= index ) then
	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
		
	if(index < 1)	then
	
		return;
	end;
	-- ÏÔÊ¾Ãû×Ö
	AxTrace(0, 0, "show sel info index="..index);
	--SelectRole_TargetInfo_Name_Text:SetText(g_RoleName[index]:GetText());
	SelectRole_TargetInfo_Name_Text:SetText( "#c00ff00Nhân v§t: #cffffff"..g_RoleName[index] );
	
	
	-- ÏÔÊ¾ÃÅÅÉ
	local strName = "Không có";
	local Family  = g_iMenPai[index];

	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == Family) then
		strName = "Thiªu Lâm";

	elseif(1 == Family) then
		strName = "Minh Giáo";

	elseif(2 == Family) then
		strName = "Cái Bang";

	elseif(3 == Family) then
		strName = "Võ Ðang";

	elseif(4 == Family) then
		strName = "Nga My";

	elseif(5 == Family) then
		strName = "Tinh Túc";

	elseif(6 == Family) then
		strName = "Thiên Long";

	elseif(7 == Family) then
		strName = "Thiên S½n";

	elseif(8 == Family) then
		strName = "Tiêu Dao";

	elseif(10 == Family) then
		strName = "Mµ Dung";
		
	end
	SelectRole_TargetInfo_Menpai_Text:SetText("#c00ff00Môn phái: #cffffff"..strName);
	
	-- ÏÔÊ¾µÈ¼¶
	SelectRole_TargetInfo_Level_Text:SetText("#c00ff00ÐÆng c¤p: #cffffff"..tostring(g_iLevel[index]));

	if(tonumber(g_iDelTime[index])>0)then
		if(g_iDelTime[index]>=11)then
			SelectRole_TargetInfo_Delete:SetText("#c00ff00"..(3-(14-g_iDelTime[index])).." ngày sau có th¬ xóa nhân v§t");
		else
			SelectRole_TargetInfo_Delete:SetText("#c00ff00 ðã có th¬ xóa nhân v§t");
		end
		
		SelectRole_TargetInfo_Delete:Show();
	else
		SelectRole_TargetInfo_Delete:Hide();
	end
	-- ÉèÎªÑ¡Ôñ×´Ì¬
	--g_BnSelCheck[index]:SetCheck(1);
	

end


function SelectRole_SelRole_MouseEnter(index)

	SelectRole_Info:SetText("Lña ch÷n nhân v§t ðång nh§p");
end
	
function SelectRole_MouseLeave()

	SelectRole_Info:SetText("");
end

function SelectRole_Play_MouseEnter()

	SelectRole_Info:SetText("Vào trò ch½i");
end

function SelectRole_Create_MouseEnter()

	SelectRole_Info:SetText("TÕo nhân v§t");
end

function SelectRole_Delete_MouseEnter()

	SelectRole_Info:SetText("Xóa nhân v§t");
end

function SelectRole_Last_MouseEnter()

	SelectRole_Info:SetText("Quay lÕi giao di®n ðång ký tài khoän");
end;


function SelectRole_Role_Modle_TurnRightBegin(index)

	if(1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(0.3);
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateBegin(0.3);
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateBegin(0.3);
		
	end;
		
end;
		
		
function SelectRole_Role_Modle_TurnRightEnd(index)

	if(1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateEnd();
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateEnd();
	
	end;	
		
end;

function SelectRole_Role_Modle_TurnLeftBegin(index)

	if(1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(-0.3);
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateBegin(-0.3);
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateBegin(-0.3);
		
	end;
	
end;


function SelectRole_Role_Modle_TurnLeftEnd(index)
		
	if(1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateEnd();
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateEnd();
	
	end;	
		
end;





function SelectRole_Role_Modle_TurnRight( start )
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1) then		
        --GameProduceLogin:ModelRotBegin(0.3)
            GameProduceLogin:ModelRotBegin(1.0)   --Ã¿ÃëÒ»È¦
	--ÏòÓÒÐý×ª½áÊø
	else
        GameProduceLogin:ModelRotEnd( 0.0 )
	end
	
end

function SelectRole_Role_Modle_TurnLeft( start )
	if(start == 1) then
            --GameProduceLogin:ModelRotBegin(-0.3)
            GameProduceLogin:ModelRotBegin(-1.0)   --Ã¿Ãë-1È¦
	else		
        GameProduceLogin:ModelRotEnd( 0.0 )
	end
	
end

function SelectRole_Modle_ZoomOut( start )
	if(start == 1) then
	    GameProduceLogin:ModelZoom( -1.0 )
	else
	    GameProduceLogin:ModelZoom( 0.0 )
	end
	
end

function SelectRole_Modle_ZoomIn( start )
    if(start == 1) then
         GameProduceLogin:ModelZoom( 1.0 )
	else
	     GameProduceLogin:ModelZoom( 0.0 )
	end
	
end