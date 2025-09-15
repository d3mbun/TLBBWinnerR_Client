
local g_InputMood_Frame_UnifiedPosition;
--===============================================
-- OnLoad
--===============================================
function InputMood_PreLoad()
	this:RegisterEvent("MOOD_SET");
		this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function InputMood_OnLoad()
 g_InputMood_Frame_UnifiedPosition=InputMood_Frame:GetProperty("UnifiedPosition");
end

--===============================================
-- OnEvent
--===============================================
function InputMood_OnEvent(event)
	local Mood = DataPool:GetMood();
	if ( event == "MOOD_SET" ) then
		InputMood_Input:SetText( "" );
		this:Show();
		InputMood_Input:SetProperty("DefaultEditBox", "True");
		if(Mood == "߀�]��ã�") then 
		Mood="V�nCh�aNgh�Ra"
		end
		InputMood_Input:SetText(Mood);

		InputMood_Input:SetSelected( 0, -1 );
		
	elseif (event == "ADJEST_UI_POS" ) then
		InputMood_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		InputMood_Frame_On_ResetPos()
		
	end
end

--===============================================
-- ȷ��
--===============================================
function InputMood_EventOK()
	local strMood = InputMood_Input:GetText();
	if( strMood == "" ) then 
		PushDebugMessage("T�m tr�ng kh�ng ���c � tr�ng");
		return;
	end
	DataPool:SetMood( strMood );
	this:Hide();
end

--===============================================
-- ȡ��
--===============================================
function InputMood_EventCancel()
	this:Hide();
end

--===============================================
-- �ر��Զ�ִ��
--===============================================
function InputMood_OnHiden()
	InputMood_Input:SetProperty("DefaultEditBox", "False");
end

function InputMood_Frame_On_ResetPos()
  InputMood_Frame:SetProperty("UnifiedPosition", g_InputMood_Frame_UnifiedPosition);
end

function InputMood_ShowMood_Clicked()
	local strMood = InputMood_Input:GetText();
	if( strMood == "" ) then 
		PushDebugMessage("T�m tr�ng kh�ng ���c � tr�ng");
		return;
	end
	if(DataPool:GetMood() == "߀�]��ã�") then 
	DataPool:SetMood( "V�nCh�aNgh�Ra" );
	end
	Friend:ViewFeel();
end