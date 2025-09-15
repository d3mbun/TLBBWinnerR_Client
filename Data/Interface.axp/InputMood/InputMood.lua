
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
		if(Mood == "還沒想好！") then 
		Mood="V鏽Ch遖Ngh頡a"
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
-- 确定
--===============================================
function InputMood_EventOK()
	local strMood = InputMood_Input:GetText();
	if( strMood == "" ) then 
		PushDebugMessage("T鈓 tr課g kh鬾g 疬㧟 瓞 tr痭g");
		return;
	end
	DataPool:SetMood( strMood );
	this:Hide();
end

--===============================================
-- 取消
--===============================================
function InputMood_EventCancel()
	this:Hide();
end

--===============================================
-- 关闭自动执行
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
		PushDebugMessage("T鈓 tr課g kh鬾g 疬㧟 瓞 tr痭g");
		return;
	end
	if(DataPool:GetMood() == "還沒想好！") then 
	DataPool:SetMood( "V鏽Ch遖Ngh頡a" );
	end
	Friend:ViewFeel();
end