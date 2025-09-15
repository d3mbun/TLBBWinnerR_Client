local LOW_POSITION 		= 0;
local MIDDLE_POSITION = 1;
local HIGH_POSITION 	= 2;

local SLIDER_CTRL = {};
local SLIDER_CTRL_NUM = 10;
local SLIDER_String = {};

local CHECK_CTRL  = {};
local CHECK_CTRL_NUM  = 7;
local CHECK_String = {};

local LAST_RES;
local LAST_FULL;



local ErrViewmode = 10;
--===============================================
-- OnLoad()
--===============================================
function ViewSetup_PreLoad()

	this:RegisterEvent("TOGLE_VIEWSETUP");

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_GAMESETUP");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
end

function ViewSetup_OnLoad()

		SLIDER_CTRL[1] = ViewSetup_Item1_Control;
		SLIDER_CTRL[2] = ViewSetup_Item2_Control;
		SLIDER_CTRL[3] = ViewSetup_Item3_Control;
		SLIDER_CTRL[4] = ViewSetup_Item4_Control;
		SLIDER_CTRL[5] = ViewSetup_Item5_Control;
		SLIDER_CTRL[6] = ViewSetup_Item6_Control;
		SLIDER_CTRL[7] = ViewSetup_Item7_Control;
		SLIDER_CTRL[8] = ViewSetup_Item8_Control;
		SLIDER_CTRL[9] = ViewSetup_Item9_Control;
		SLIDER_CTRL[10] = ViewSetup_Item10_Control;
		
		CHECK_CTRL[1]  = ViewSetup_Item_Check1;
		CHECK_CTRL[2]  = ViewSetup_Item_Check2;
		CHECK_CTRL[3]  = ViewSetup_Item_Check4;
		CHECK_CTRL[4]  = ViewSetup_Item_Check5;
		CHECK_CTRL[5]  = ViewSetup_Item_Check6;
		CHECK_CTRL[6]  = ViewSetup_Item_Check7;
		CHECK_CTRL[7]  = ViewSetup_Item_Miwu;

		SLIDER_String[1]   = "dxyy" --µØÐÎÒõÓ°
		SLIDER_String[2]   = "fhj"	--·´»ì½Ç
		SLIDER_String[3]   = "wtdh"	--ÎïÌå¶¯»­
		SLIDER_String[4]   = "gamma"
		SLIDER_String[5]   = "yszl"	--ÑÕÉ«ÖÊÁ¿			±ÈÌØÊý
		SLIDER_String[6]   = "wldx"	--ÎÆÀí´óÐ¡
		SLIDER_String[7]   = "cy"		--²ÉÑù
		SLIDER_String[8]   = "dbxs"	--¶à±ßÐÎÊý
		SLIDER_String[9]   = "rwyy"	--ÈËÎïÒõÓ°
		SLIDER_String[10]   = "ksfw"	--Ä£ÐÍÏÔÊ¾ÖÊÁ¿
		
		CHECK_String[1]   = "dxgg"	--µØÐÎ¸ß¹â
		CHECK_String[2]   = "rwgg"	--ÈËÎï¸ß¹â
		CHECK_String[3]   = "qpfg"	--È«ÆÁ·º¹â
		CHECK_String[4]   = "cztb"	--´¹Ö±Í¬²½
		CHECK_String[5]   = "sdh"	--Ë®¶¯»­
		CHECK_String[6]   = "qpms"	--È«ÆÁÄ£Ê½
		CHECK_String[7]   = "miwu"	--È«ÆÁÄ£Ê½

		
	ViewSetup_Item2_Text1:SetToolTip("KhØ rång cßa càng cao thì hình änh nhân v§t và bän ð° càng m¸n h½n, nhßng cûng c¥n card màn hình cao,#r#RC¥n kh·i ðµng lÕi trò ch½i");
	ViewSetup_Item12_Text:SetToolTip("Kh·i ðµng lÕi lÕi ð¬ ð°ng bµ ðµ phân giäi trong trò ch½i và ðµ phân giäi card màn hình. Có th¬ giäi quyªt v¤n ð« hi¬n th¸ không rõ ràng trong trò ch½i #r#RC¥n kh·i ðµng lÕi trò ch½i");

	ViewSetup_Item15:ComboBoxAddItem("Có", 0);
	ViewSetup_Item15:ComboBoxAddItem("800X600", 1);
	ViewSetup_Item15:ComboBoxAddItem("1024X768", 2);
	ViewSetup_Item15:ComboBoxAddItem("1280X1024", 3);


	for i=1, SLIDER_CTRL_NUM   do
		local temp = SystemSetup:View_GetData( SLIDER_String[i] );
		SLIDER_CTRL[i]:SetProperty( "DocumentSize","1" );
		SLIDER_CTRL[i]:SetProperty( "PageSize","0" );
		SLIDER_CTRL[i]:SetProperty( "StepSize","0.5" );	
	end

end

--===============================================
-- OnEvent()
--===============================================
function ViewSetup_OnEvent(event)
	
	if ( event == "TOGLE_VIEWSETUP" ) then
		this:Show();
		
		ViewSetup_UpdateFrame();

	elseif(event == "TOGLE_GAMESETUP" ) then
		this:Hide();
	elseif(event == "TOGLE_SYSTEMFRAME" ) then
		this:Hide();
	elseif(event == "TOGLE_SOUNDSETUP" ) then
		this:Hide();
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function ViewSetup_UpdateFrame()
	
	for i=1, SLIDER_CTRL_NUM   do
		local temp = SystemSetup:View_GetData( SLIDER_String[i] );
		if (i==10) then
			if(temp == ErrViewmode ) then
				--µÚÒ»´ÎÄ¬ÈÏÎª¸ß
				SLIDER_CTRL[i]:SetPosition(1);
			else
				SLIDER_CTRL[i]:SetPosition(temp/2);
			end;
		else
			SLIDER_CTRL[i]:SetPosition(temp/2);
		end		
		--AxTrace(8,0,"update slider=".. i.." temp =".. temp/2);
	end
	
	for i=1, CHECK_CTRL_NUM    do
		local temp = SystemSetup:View_GetData( CHECK_String[i] );
		CHECK_CTRL[i]:SetCheck(temp);
	end
	
	local curVar = Variable:GetVariable("View_Resoution");
	AxTrace(0, 1, "Res=" .. curVar);
	
	ViewSetup_Item15:SetCurrentSelect(0);
	
	LAST_FULL = Variable:GetVariable("View_FullScreen");
	ViewSetup_Item_Check7:SetCheck(tonumber(LAST_FULL));

		
	if( tonumber( Variable:GetVariable("View_PiFeng" ) ) == 1 ) then
		ViewSetup_Item_Check10:SetCheck( 1 );
	else
		ViewSetup_Item_Check10:SetCheck( 0 );
	end
	ViewSetup_FullScreen_Clicked()
end

--===============================================
-- ViewSetup_Accept_Clicked()
--===============================================
function ViewSetup_Accept_Clicked()

	--ÊÇ·ñÐèÒªÖØÐÂÆô¶¯
	local bNeedReset1 = tonumber(SystemSetup:View_GetData(SLIDER_String[2])) ~= (tonumber(SLIDER_CTRL[2]:GetPosition())*2);
	local bNeedReset2 = tonumber(SystemSetup:View_GetData(CHECK_String[4])) ~= (tonumber(CHECK_CTRL[4]:GetCheck()));
	
	if(bNeedReset1 or bNeedReset2) then
		PushDebugMessage("Kh·i ðµng lÕi trò ch½i");
	end

	for i=1, SLIDER_CTRL_NUM   do
		local temp = SLIDER_CTRL[i]:GetPosition();
			SystemSetup:View_SetData( SLIDER_String[i],temp*2 );
--		AxTrace(0,1,"update slider=".. i.." temp * 2  =".. temp*2);
	end
	
	for i=1, CHECK_CTRL_NUM    do
		local temp = CHECK_CTRL[i]:GetCheck();
--		AxTrace(0,1,"update check=".. i.." temp = ".. temp);
		SystemSetup:View_SetData( CHECK_String[i],temp );
	end

	local bFullScreen = ViewSetup_Item_Check7:GetCheck();

	--µ±Ç°·ÇÈ«ÆÁ
	if(bFullScreen ~= 1) then
		local thisRes, thisResIndex = ViewSetup_Item15:GetCurrentSelect();
--		AxTrace(0,1, "[" .. thisRes .. "]");

		if(thisRes == "800X600") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "800,600", 0);
		elseif(thisRes == "1024X768") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1024,768", 0);
		elseif(thisRes == "1280X1024") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1280,1024", 0);
		else
--			AxTrace(0,1, "err= [" .. thisRes .. "]");
		end
	end
	ViewSetup_PiFeng();
	this:Hide();

end

--===============================================
-- SliderChanged
--===============================================
function ViewSetup_SliderChanged(nIndex)
	local szCurValue =	SLIDER_CTRL[nIndex]:GetPosition();
	
	local fCurValue = szCurValue +0;
	
	AxTrace(0,1,"slider=".. nIndex.." fcurvalue =".. fCurValue);
	if (nIndex == 6)  then
	
		if  fCurValue < 0.5  then 
			fCurValue = LOW_POSITION;
		else
			fCurValue = HIGH_POSITION;
		end
	else
		if (fCurValue < 0.25)      then
			fCurValue = LOW_POSITION;
		elseif(fCurValue < 0.75)   then
			fCurValue = MIDDLE_POSITION;
		else
			fCurValue = HIGH_POSITION;
		end
	end
	AxTrace(0,1,"2 slider=".. nIndex.." fcurvalue =".. fCurValue);

	SLIDER_CTRL[nIndex]:SetPosition(fCurValue/2);

--	ViewSetup_UpdateToGame(SLIDER_String[nIndex], fCurValue);
end

function ViewSetup_FullScreen_Clicked()
	local temp = ViewSetup_Item_Check7:GetCheck();

	if(temp == 1) then
		ViewSetup_Item15:Disable();
	else
		ViewSetup_Item15:Enable();
	end
end

function ViewSetup_Res_Changed()
	ViewSetup_Item_Check7:SetCheck(0);
end

function ViewSetup_Default_Clicked()


	SystemSetup:View_SetData( SLIDER_String[1], 2 );	--µØÐÎÒõÓ°
	SystemSetup:View_SetData( SLIDER_String[2], 0 );	--·´»ì½Ç
	SystemSetup:View_SetData( SLIDER_String[3], 2 );	--ÎïÌå¶¯»­
	SystemSetup:View_SetData( SLIDER_String[4], 1 );	--gamma
	SystemSetup:View_SetData( SLIDER_String[5], 2 );	--ÑÕÉ«ÖÊÁ¿
	SystemSetup:View_SetData( SLIDER_String[6], 1 );	--ÎÆÀí´óÐ¡
	SystemSetup:View_SetData( SLIDER_String[7], 0 );	--²ÉÑù
	SystemSetup:View_SetData( SLIDER_String[9], 0 );	--ÈËÎïÒõÓ°
	SystemSetup:View_SetData( SLIDER_String[10], 2 );	--ÈËÎïÒõÓ°
	
	SystemSetup:View_SetData( CHECK_String[1],1 );	--µØÐÎ¸ß¹â
	SystemSetup:View_SetData( CHECK_String[2],1 );	--ÈËÎï¸ß¹â
	SystemSetup:View_SetData( CHECK_String[3],0 );	--È«ÆÁ·º¹â
	SystemSetup:View_SetData( CHECK_String[4],0 );	--´¹Ö±Í¬²½
	SystemSetup:View_SetData( CHECK_String[5],1 );	--Ë®¶¯»­
	SystemSetup:View_SetData( CHECK_String[6],0 );	--È«ÆÁÄ£Ê½
	SystemSetup:View_SetData( CHECK_String[7],1 );	--ÃÔÎí¿ª¹Ø
	ViewSetup_Item15:Disable();
	
	ViewSetup_UpdateFrame();
	AxTrace(0,1,"xxx");
end

function ViewSetup_PiFeng()
	if( ViewSetup_Item_Check10:GetCheck() == 1 ) then
		Variable:SetVariable("View_PiFeng", "1", 0);
	else
		Variable:SetVariable("View_PiFeng", "0", 0);
	end
end