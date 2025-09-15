--***********************************************************************************************************************************************
-- ¸´»î½çÃæ		
--×¢Òâ£¬´Ë½çÃæÎª¸´»î×¨ÓÃ£¬Çë²»ÒªÓÃÀ´×öÆäËûÓÃÍ¾
--***********************************************************************************************************************************************
local Current_status = 0;
local Current_Quest = -1;
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-- ´Ë´¦¶¨ÒåÐèÒª±£´æÊý¾ÝµÄ¾Ö²¿±äÁ¿
--

--------------------------------------------------------
-- µ±Ç°¶Ô»°¿òµÄ²Ù×÷ÀàÐÍ
local g_Event;

local Event_Relive = 0;
local Event_Callof = 1;


--***********************************************************************************************************************************************
--
-- OnLoad
--
--************************************************************************************************************************************************
function Relive_PreLoad()

	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("RELIVE_REFESH_TIME");

	--À­ÈË¼¼ÄÜ
	this:RegisterEvent("OPEN_CALLOF_PLAYER");
	
end

function Relive_OnLoad()
end


--***********************************************************************************************************************************************
--
-- ÊÂ¼þÏìÓ¦º¯Êý
--
--
--************************************************************************************************************************************************
function Relive_OnEvent(event)
	AxTrace( 0,0, "here");
	if ( event == "RELIVE_SHOW" ) then
	
		Relive_Text:SetText( "Các hÕ ðã tØ nÕn, nhßng vçn còn nhæng kÖ ni®m h°i tß·ng v¾i nhân gian, các hÕ mu¯n tiªp tøc ch¶ ðþi hay là giäi thoát linh h°n?" );
--		Relive_Time_Text:SetText( arg2 );
		Relive_Time_Text : SetProperty("Timer",tostring(arg2));
		--ÓÐ¸´»î°´Å¥
		if ( arg0 == "1" ) then
			Relive_Fool_Button:Enable();
		--ÎÞ¸´»î°´Å¥
		else
			Relive_Fool_Button:Disable();
		end
		--ÓÐ¸´»î°´Å¥
		if ( arg1 == "1" ) then
			Relive_Relive_Button:Enable();
		--ÎÞ¸´»î°´Å¥
		else
			Relive_Relive_Button:Disable();
		end
		
		Question_Help:Disable();
		Question_Close:Disable();
		Current_status = 0;
		Relive_Fool_Button:SetText("Tân thü");
		Relive_Release_Button:SetText("Ð¥u thai");
		Relive_Relive_Button:SetText("H°i sinh");

		Question_Text:SetText("#gFF0FA0H°i sinh");
		this:Show();
		g_Event = Event_Relive;

	elseif ( event == "RELIVE_HIDE" ) then
		Current_status = 0;
		this:Hide();

	elseif ( event == "RELIVE_REFESH_TIME" ) then
	
		Relive_Time_Text : SetProperty("Timer",tostring(arg0));
		Current_status = 0;
	
		
	elseif ( event == "OPEN_CALLOF_PLAYER" )  then
		
		Relive_Text:SetText(arg0 .. "Kéo các hÕ ði, có ð°ng ý không?");
			
		Relive_Release_Button:SetText("Duy®t");
		Relive_Relive_Button:SetText("HuÖ");

		Question_Text:SetText("#gFF0FA0Kéo ngß¶i");

		Relive_Time_Text:SetProperty("Timer",tostring( arg3 ));
		this:Show()
		g_Event = Event_Callof;
		
	end
end



--***********************************************************************************************************************************************
--
-- µã»÷³öÇÏ°´Å¥
--
--
--************************************************************************************************************************************************
function Relive_Out_Ghost()

	if( g_Event == Event_Callof )  then
		Friend:CallOf("ok");
		this:Hide();
	
	elseif(g_Event == Event_Relive)then
		if(Current_status == 1) then
			if(Current_Quest > -1) then
				QuestFrameMissionAbnegate(Current_Quest);
			end
			this:Hide();
			return;
		else
			Player:SendReliveMessage_OutGhost();
		end
		
	end

end


--***********************************************************************************************************************************************
--
-- µã»÷¸´»î°´Å¥
--
--
--***********************************************************************************************************************************************
function Relive_Relive()

	if( g_Event == Event_Relive )  then
		if(Current_status == 1) then
			this:Hide();
			return;
		else
			Player:SendReliveMessage_Relive();
		end;
		 
	elseif(g_Event == Event_Callof)then 
		this:Hide();
	
	end

end

--¼ÆÊ±Æ÷£½0
function Relive_Time_Zero()
	if( g_Event == Event_Callof )  then
		this:Hide();
	end;

end

function Relive_Out_Fool()
	Player:SendReliveMessage_Fool();
end