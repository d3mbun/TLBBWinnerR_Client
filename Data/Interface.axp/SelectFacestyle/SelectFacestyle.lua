local g_Facestyle_Icon = {}
local MAX_OBJ_DISTANCE = 3.0;
local g_nCurPage = 0								-- µ±Ç°Ñ¡ÔñµÄÍ¼±êÔÚµÚ¼¸Ò³
local g_nCurSelect = 0							-- µ±Ç°Ñ¡ÔñµÄÍ¼±ê±àºÅ
local g_Style_Index = {}
local g_Style_Count = 0							-- Êµ¼ÊÉÏÓÐ¶àÉÙ¸öÁ³ÐÍ¿É¹©Ñ¡Ôñ
local g_Original_Style = 0				
local STYLE_PAGE_BUTTON = 12				-- Ã¿Ò³¶àÉÙ¸öÍ¼±ê
local MAX_STYLE = 200								-- ×î¶àÓÐ¶àÉÙÍ¼±ê

local g_SelectFacestyle_Frame_UnifiedPosition;

--==================================
-- SelectFacestyle_PreLoad
--==================================
function SelectFacestyle_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--==================================
-- SelectFacestyle_OnLoad
--==================================
function SelectFacestyle_OnLoad()
	g_Facestyle_Icon[1]		= SelectFacestyle_Skill1_BKG
	g_Facestyle_Icon[2] 	= SelectFacestyle_Skill2_BKG
	g_Facestyle_Icon[3] 	= SelectFacestyle_Skill3_BKG
	g_Facestyle_Icon[4] 	= SelectFacestyle_Skill4_BKG
	g_Facestyle_Icon[5] 	= SelectFacestyle_Skill5_BKG
	g_Facestyle_Icon[6] 	= SelectFacestyle_Skill6_BKG
	g_Facestyle_Icon[7] 	= SelectFacestyle_Skill7_BKG
	g_Facestyle_Icon[8] 	= SelectFacestyle_Skill8_BKG
	g_Facestyle_Icon[9] 	= SelectFacestyle_Skill9_BKG
	g_Facestyle_Icon[10]	= SelectFacestyle_Skill10_BKG
	g_Facestyle_Icon[11]	= SelectFacestyle_Skill11_BKG
	g_Facestyle_Icon[12]	= SelectFacestyle_Skill12_BKG
	
	for i=1, MAX_STYLE do
		g_Style_Index[i] = -1
	end	

g_SelectFacestyle_Frame_UnifiedPosition=SelectFacestyle_Frame:GetProperty("UnifiedPosition");

end

--==================================
-- SelectFacestyle_OnEvent
--==================================
function SelectFacestyle_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 928) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
				PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ð«");
				return;
		end

		if(IsWindowShow("SelectHairstyle")) then
			CloseWindow("SelectHairstyle", true);
		end

		if(IsWindowShow("SelectHairColor")) then
			CloseWindow("SelectHairColor", true);
		end
		
		if(this:IsVisible() and tonumber(g_Original_Style)) then
			DataPool : Change_MyFaceStyle(g_Original_Style);
		end
		SelectFacestyle_OnShown()
		BeginCareObject_SelectFacestyle(objCared)

	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) ~= objCared) then
			Close_Facestyle()
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			Close_Facestyle()
		end
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			SelectFacestyle_Model : Hide();
			SelectFacestyle_Model : Show();
			SelectFacestyle_Model:SetFakeObject("Player_Head");
	end
	if (event == "ADJEST_UI_POS" ) then
		SelectFacestyle_Frame_On_ResetPos()
	end
	if (event == "VIEW_RESOLUTION_CHANGED") then
		SelectFacestyle_Frame_On_ResetPos()
	end

end

--==================================
-- SelectFacestyle_OnShown
--==================================
function SelectFacestyle_OnShown()
	for i,eachstyle in g_Facestyle_Icon do
		eachstyle : SetPushed(0)
	end
	
	-- µÃµ½µ±Ç°µÄÁ³ÐÍ
	g_Original_Style = DataPool : Get_MyFaceStyle();

	SelectFacestyle_Update();
	this:Show();
end

--==================================
-- SelectFacestyle_Update
--==================================
function SelectFacestyle_Update()

	local i;
	local k = 1;
	
	for i,eachstyle in g_Facestyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end
	
	-- ±í¸ñCharFaceGeo.txtÀï1-99ÎªÅ®ÐÔÁ³ÐÍ£¬100-200ÎªÄÐÐÔÁ³ÐÍ
	-- ±í¸ñÅäÖÃµÄÓÐµãÎÊÌâ£¬Ó¦¸ÃÊÇ1-100ÎªÅ®ÐÔÁ³ÐÍ£¬101-200ÎªÄÐÐÔÁ³ÐÍ
	for i=0, MAX_STYLE do		
		local ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyFaceStyle_Item(i);
		
		-- ItemID == -1£¬ËµÃ÷Change_MyFaceStyle_Item()º¯Êý·µ»ØµÄÁ³ÐÍÐÅÏ¢µÄÐÔ±ðÓëµ±Ç°½ÇÉ«²»Ò»ÖÂ¡£ÕâÀïÖ»ÐèÒªºÍµ±Ç°½ÇÉ«ÐÔ±ðÒ»ÑùµÄÁ³ÐÍÊý¾Ý¡£
		-- SelectType == 2£¬Ö»ÓÐÔÚÓÎÏ·ÖÐ¿ÉÑ¡µÄÁ³ÐÍ£»SelectType == 3£¬ÓÎÏ·ÖÐ¡¢³õÊ¼Ê±¶¼¿ÉÑ¡µÄÁ³ÐÍ
		if(ItemID ~= -1 and SelectType >= 2) then
			if k > STYLE_PAGE_BUTTON * (g_nCurPage) and k <= STYLE_PAGE_BUTTON * (g_nCurPage+1) then
				local m = k - STYLE_PAGE_BUTTON * (g_nCurPage);
				IconFile = GetIconFullName(IconFile)
				g_Facestyle_Icon[m]:SetProperty("NormalImage",IconFile)
				g_Facestyle_Icon[m]:SetProperty("HoverImage",IconFile)
				g_Facestyle_Icon[m]:SetToolTip(StyleName)
				g_Style_Index[m] = i;
			end
			k = k+1
		end
	end
	-- ¼ÇÂ¼±í¸ñÖÐ×Ü¹²ÓÐ¶àÉÙ¸öÁ³ÐÍ
	g_Style_Count = k-1
	--PushDebugMessage ("g_Style_Count = "..g_Style_Count)
	
	if(g_Style_Count <= 0) then
		SelectFacestyle_Require:SetText("Không có khuôn m£t có th¬ thay ð±i");
		SelectFacestyle_CurrentlyPage:SetText("1/1");
		SelectFacestyle_Model : SetFakeObject( "" );
		SelectFacestyle_Model : SetFakeObject( "Player_Head" );
		SelectFacestyle_PageUp : Disable();
		SelectFacestyle_PageDown : Disable();
		SelectFacestyle_Accept : Disable();
		return;
	end
	
	SelectFacestyle_Model : SetFakeObject( "Player_Head" )

	g_nCurSelect = 0;
	SelectFacestyle_WarningText : SetText("Xin lña ch÷n khuôn m£t tÕi giao di®n phía trên bên phäi, sau ðó ¤n \"xác nh§n\"");
	
	-- ·­Ò³ÉèÖÃ
	if g_nCurPage == 0 then
		SelectFacestyle_PageUp : Disable();				-- µÚ1Ò³
	else
		SelectFacestyle_PageUp : Enable();				-- ²»ÊÇµÚ1Ò³
	end

	if (g_nCurPage+1)*STYLE_PAGE_BUTTON < g_Style_Count then
		SelectFacestyle_PageDown : Enable();			-- ²»ÊÇ×îºó1Ò³
	else
		SelectFacestyle_PageDown : Disable();			-- ×îºó1Ò³
	end

end

--==================================
--×ó×ª
--==================================
function SelectFacestyle_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(-0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
--ÓÒ×ª
--==================================
function SelectFacestyle_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
--¹Ø±Õ
--==================================
function Close_Facestyle()
	g_HaveChange = 0
	g_nCurPage = 0
	g_nCurSelect = 0
	SelectFacestyle_Model : SetFakeObject( "" );
	StopCareObject_SelectFacestyle(objCared)
	this:Hide();	
end

--==================================
--¿ªÊ¼¹ØÐÄNPC
--==================================
function BeginCareObject_SelectFacestyle(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "SelectFacestyle");
end

--==================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--==================================
function StopCareObject_SelectFacestyle(objCaredId)
	this:CareObject(objCaredId, 0, "SelectFacestyle");
	g_Object = -1;
end

--==================================
--È¡Ïû
--==================================
function SelectFacestyle_Cancel_Clicked()
	DataPool : Change_MyFaceStyle(g_Original_Style);
	Close_Facestyle()
end

--==================================
--È·ÈÏ
--==================================
function SelectFacestyle_OK_Clicked()
	-- Ã»ÓÐÑ¡ÔñÁ³ÐÍ
	if(g_nCurSelect == 0 )then
		PushDebugMessage("Xin lña 1 mô hình di®n mÕo.");
		return;
	end

	-- µÃµ½Ñ¡ÔñµÄÁ³ÐÍÐÅÏ¢
	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyFaceStyle_Item(g_Style_Index[g_nCurSelect]);

	-- ¼ì²éµÀ¾ß
	if(ItemID ~= -1 and SelectType >= 2) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemID) < ItemCount) then
			PushDebugMessage("Thiªu Ð¸nh Nhan Châu");
			return;
		end
	end
	
	-- µÃµ½Íæ¼ÒµÄ½ð±ÒºÍ½»×ÓÊýÄ¿
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")
	
	if (nMoney + nMoneyJZ) < CostMoney then
		PushDebugMessage("Ngân lßþng không ðü");
		return
	end
	
	-- µ÷ÊÔÐÅÏ¢£¬µ±Ç°Ñ¡ÔñµÄÁ³ÐÍID
	--PushDebugMessage ("StyleId = "..g_Style_Index[g_nCurSelect])
	-- Èç¹ûÑ¡ÔñµÄÁ³ÐÍºÍµ±Ç°Á³ÐÍ²»Í¬
	if g_Style_Index[g_nCurSelect] ~= g_Original_Style then

		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(805029);
			Set_XSCRIPT_Parameter(0,g_Style_Index[g_nCurSelect]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_Facestyle();
		
	else

		PushDebugMessage("Xin hãy ch÷n 1 loÕi khuôn m£t khác v¾i lúc trß¾c ðó.");

	end
	
end

--==================================
--Ñ¡ÖÐÒ»¸öÍ¼±ê
--==================================
function SelectFacestyle_Clicked(nIndex)

	-- Ñ¡ÖÐÎÞÐ§Í¼±êÊ±µÄ´¦Àí
	if ((nIndex < 0) or (nIndex + STYLE_PAGE_BUTTON * (g_nCurPage) > g_Style_Count))  then
		g_HaveChange = 0
		if(g_nCurSelect > 0 )then
			g_Facestyle_Icon[g_nCurSelect]:SetPushed(0);
		end
		g_nCurSelect = 0
		DataPool : Change_MyFaceStyle(g_Original_Style);
		SelectFacestyle_WarningText : SetText("Xin lña ch÷n khuôn m£t tÕi giao di®n phía trên bên phäi, sau ðó ¤n \"xác nh§n\"");
		return
	end

	-- Ñ¡ÖÐÓÐÐ§Í¼±êÊ±µÄ´¦Àí
	if(g_nCurSelect > 0 )then
		g_Facestyle_Icon[g_nCurSelect]:SetPushed(0);
	end
	g_nCurSelect = nIndex
	g_Facestyle_Icon[g_nCurSelect]:SetPushed(1);

	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyFaceStyle_Item(g_Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);

	SelectFacestyle_WarningText : SetText("C¥n ðÕo cø: #G"..name.."#r#W C¥n tiêu hao: #Y#{_EXCHG"..CostMoney.."}#W#rXin ch÷n hình khuôn m£t trên hình góc phäi phía trên, sau ðó ¤n \"Xác nh§n\".");
	DataPool : Change_MyFaceStyle(g_Style_Index[nIndex])
	g_HaveChange = 1

end

--=========================================
--·­Ò³
--=========================================
function SelectFacestyle_Page(nPage)
	
	g_nCurPage = g_nCurPage + nPage;

	SelectFacestyle_Update();

end

function SelectFacestyle_Frame_On_ResetPos()
  SelectFacestyle_Frame:SetProperty("UnifiedPosition", g_SelectFacestyle_Frame_UnifiedPosition);
end
