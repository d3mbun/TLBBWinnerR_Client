
local strMenPaiName ={
						"Thiªu Lâm",
						"Minh Giáo",	
						"Cái Bang",	
						"Võ Ðang",	
						"Nga My",	
						"Tinh Túc",	
						"Thiên Long",	
						"Thiên S½n",	
						"Tiêu Dao",
						"Tân thü",	
						"Mµ Dung",
						"ÐÕi T¯ng",
						"ÐÕi T¯ng",
						"ÐÕi T¯ng",
						"ÐÕi Liêu",
						"ÐÕi Liêu",
						"ÐÕi Lý",	
						"Tây HÕ",	
						"Th± Ph°n",	
						"Mãng Cái",	
						"Di Dân",	
						"Lang Nhân",	
						"BÕch Miêu",	
						"H¡c Miêu",	
						"Tu La",	
						"Næ",
						"Nam",
						"NgÕc Th¥n",	
						"Dã thú",	
						"Løc lâm",	
						"Yêu ma",};


function TargetFrame_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED")
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_RELATIVE");
	this:RegisterEvent("MAINTARGET_OPEN")
end

function TargetFrame_OnLoad()

end

function TargetFrame_OnEvent(event)

	if ( event == "MAINTARGET_OPEN" ) then
	
		--AxTrace(0,0,"´ò¿ªmain target");
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_Update_Name_Team();
		TargetFrame_Update_HP_Team();
		TargetFrame_Update_MP_Team();
		TargetFrame_Update_Rage_Team();
		TargetFrame_Update_Level_Team();
		this:Show();
		return;
	end;
	
	if ( event == "MAINTARGET_CHANGED" ) then
	
		AxTrace(0,0,"id === "..tostring(arg0));
	  if(-1 == tonumber(arg0)) then
	  
	  	this:Hide();
	  	return;
	  end;
	  
		if( Target:IsPresent()) then
			this:Show();
			TargetFrame_Update_Name();
			TargetFrame_Update_HP();
			TargetFrame_Update_MP();
			TargetFrame_Update_Rage();
			TargetFrame_Update_Level();
		else
		
			if(Target:IsTargetTeamMember()) then
			
				this:Show();
				TargetFrame_DataBack:Show();
				TargetFrame_DataBack2:Hide();
			else
				this:Hide();
			end;
				
		end
		return;
	end
	
	
	
	if( (event == "UNIT_MP") and Target:IsPresent()) then
		TargetFrame_Update_MP();
		return;
	end

	if( (event == "UNIT_HP") and Target:IsPresent()) then
		TargetFrame_Update_HP();
		return;
	end

	if( (event == "UNIT_RAGE") and Target:IsPresent()) then
		TargetFrame_Update_Rage();
		return;
	end

	if( (event == "UNIT_LEVEL") and Target:IsPresent()) then
		TargetFrame_Update_Level();
		return;
	end

	if( (event == "UNIT_RELATIVE") and Target:IsPresent()) then
		TargetFrame_Update_Name();
		return;
	end
	
	
	
	
end

function TargetFrame_Update_Name()
	local txtColor="#cFFFFFF";
--or Target:GetData("ISNPC") == 0
--ÒÔÇ°Íæ¼ÒÍ³Ò»ÏÔÊ¾Îª°×É«£¬¸ù¾ÝÈîÃ¶5ÔÂ27ÈÕÎÄµµ¸ü¸Ä£¬Íæ¼ÒºÍNPC×ßÍ¬Ò»¹æÔò¡£
	if Target:GetData( "RELATIVE" ) == 2  then 
		txtColor = "#W"
	else
		txtColor = "#R"
	end
	TargetFrame_NameBar : Show();
	local occupation = Target:GetData("OCCUPATION")
	
	AxTrace(0,1,"OCCUPATION="..occupation)
	if(occupation == -1) then
		TargetFrame_NameBar : SetImageColor("FF00FF00")
	elseif(occupation == 0) then
		TargetFrame_NameBar : SetImageColor("FFFFFFFF")
	elseif(occupation == 1) then
		TargetFrame_NameBar : SetImageColor("FFFF0000")
	end

	TargetFrame_Name:SetText( txtColor..Target:GetName());
	TargetFrame_Name:Show();
	AxTrace( 8,0,txtColor..Target:GetName() );
	local szIcon = Target : GetData("PORTRAIT");
	TargetFrame_Icon:SetProperty("Image", szIcon);
--Ìí¼ÓÅÐ¶ÏÄ¿±êÊôÐÔµÄÉè¼Æ
	--¡°³è¡±¡°ÈË¡±¡°¿þ¡±¡°ÊÞ¡±¡°Ã§¡±¡°ÐÞ¡±¡°Ñý¡±
	local nNpcType = Target:GetData( "TYPE" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName"..tostring( nNpcType ) );
	
	--1.ÓÑºÃ
	--2.ÖÐÁ¢
	--3.ÕäÊÞ
	--4.ÆÕÍ¨µÐÈË
	--5.¾«Ó¢µÐÈË
	--6.µÐ·½boss	
	local nNpcRelation = Target:GetData( "RELATION" );
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame"..tostring( nNpcRelation ) );
	
	--¸úÐÂÃÅÅÉ
	local nNpcReputation = Target:GetData( "MEMPAI" );
	if( nNpcReputation == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nNpcReputation ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nNpcReputation + 1 ] );
	end
	
end

function TargetFrame_Update_HP()
	local nNpcRelation = Target:GetData( "RELATION" );
	if( tonumber( nNpcRelation ) == 6 ) then
		TargetFrame_DataBack:Hide();
		TargetFrame_DataBack2:Show();
		local hp = Target:GetHPPercent();
		TargetFrame_HP_Boss1:SetProgress( hp * 3, 1 );
		TargetFrame_HP_Boss2:SetProgress( ( hp - 0.33333 ) * 3, 1 );
		TargetFrame_HP_Boss3:SetProgress( ( hp - 0.66666 ) * 3, 1 );
	else
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_HP:SetProgress(Target:GetHPPercent(), 1);
		TargetFrame_Update_Name();
	end
end

function TargetFrame_Update_MP()
	TargetFrame_MP:SetProgress(Target:GetMPPercent(), 1);
end

function TargetFrame_Update_Rage()
	TargetFrame_SP:SetProgress(Target:GetRagePercent(), 1);
end

function TargetFrame_Update_Level()

	local txtColor="#cFFFFFF";
	local level =  Target:GetData( "LEVEL" ) - Player:GetData( "LEVEL" );
	
	AxTrace( 0,0, "C¤p khác bi®t là "..tostring( level ) );

--¸ù¾ÝÈîÃ¶5ÔÂ27ÈÕ²ß»®ÎÄµµÐÞ¸ÄÈçÏÂ
	if( level > 5 ) then
		txtColor = "#R";
	elseif( level > 2 ) then
		txtColor = "#cff9000";
		--ÒÔÇ°ÊÇc9ccf00£¬¸ù¾ÝÑîÒ«Ìá¹©µÄ.jpgÐÞ¸Ä
	elseif( level >= -2 ) then
		txtColor="#Y";
	elseif( level >= -5 ) then
		txtColor="#W"
	else
--		txtColor="#c4b4b4b";
--¸ù¾ÝÑîÒ«¿ÚÊöÐÞ¸Ä
		txtColor="#W";
	end
	

	if( tonumber( Target:GetData( "LEVEL" ) ) >= 200 ) then
		TargetFrame_LevelText:SetText(txtColor .."?");
	else
		TargetFrame_LevelText:SetText(txtColor .. tostring(Target:GetData( "LEVEL" )));
	end
end

function TargetFrame_ArtLayout_Click()
	ShowContexMenu("other_player");
end

-- ÏÔÊ¾ÓÒ¼ü²Ëµ¥
function TargetFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Target ÓÒ¼ü²Ëµ¥!");
	OpenTargetMenu();
end


function	TargetFrame_Update_Name_Team()

	local strName = Target:TargetFrame_Update_Name_Team();
	local nMenpai = Target:TargetFrame_Update_Menpai_Team();
	TargetFrame_Name:SetText(strName);
	if( tonumber(nMenpai) == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nMenpai ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nMenpai + 1 ] );
	end
	local strIcon = Target:TargetFrame_Update_Icon_Team();
	TargetFrame_Icon:SetProperty("Image", strIcon);
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame1" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName2" );
end;

function 	TargetFrame_Update_HP_Team()

	local TeamHP = Target:TargetFrame_Update_HP_Team();
	TargetFrame_HP:SetProgress(TeamHP, 1);
end;
	
function	TargetFrame_Update_MP_Team()
	
	local TeamMp = Target:TargetFrame_Update_MP_Team();
	TargetFrame_MP:SetProgress(TeamMp, 1);
end;

function	TargetFrame_Update_Rage_Team()

	local TeamRange = Target:TargetFrame_Update_Rage_Team();
	TargetFrame_SP:SetProgress(TeamRange, 1000);
end;

function	TargetFrame_Update_Level_Team()

	local TeamLevel = Target:TargetFrame_Update_Level_Team();
	TargetFrame_LevelText:SetText(tostring(TeamLevel));
end;