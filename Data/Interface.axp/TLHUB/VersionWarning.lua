
function VersionWarning_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function VersionWarning_OnLoad()

end


function VersionWarning_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 1002001 then
		if this:IsVisible() then
			--this:Hide();
			return;
		end
		
		VersionWarning_Update(0) --0: default--
		this:Show();
	end

	if event == "PLAYER_LEAVE_WORLD" then
		VersionWarning_OnHidden();
		return;
	end
end

function VersionWarning_Update(num)
	VersionWarning_Timer:SetProperty("Timer",30);
end

function VersionWarning_Confirm_OK()	
	--PushDebugMessage("OK EXIT")
	QuitApplication("quit");
end

function VersionWarning_Help()
	PushDebugMessage("Yêu c¥u c§p nh§t phiên bän Client!")
end

function VersionWarning_OnHidden()
	this:Hide()
end