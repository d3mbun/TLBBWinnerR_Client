local FeedBack_Send = 0

function FeedBack_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function FeedBack_OnLoad()

end

function FeedBack_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 1025001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		FeedBack_Update()
		this:Show();
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		FeedBack_OnHidden();
		return;
	end
end

function FeedBack_Update()
	if FeedBack_Send == 1 then
		FeedBack_EditContent:SetText("")
		
		FeedBack_Send = 0;
	end
end

function FeedBack_Buttons_Clicked()
	FeedBack_SendMail()
end

function FeedBack_Empty()
	-- PushDebugMessage("Empty")
end

function FeedBack_SendMail()
	local szValue = FeedBack_EditContent:GetText();
	if szValue == "" then
		PushDebugMessage("Không ðßþc gØi nµi dung tr¯ng!");
		return
	end
	
	local SendFeedback = -1;
	if this:IsVisible() then
		SendFeedback = DataPool:SendMail("Admin", szValue)
	end
	
	if SendFeedback == 0 then
		FeedBack_Send = 1
	
		PushDebugMessage("B±n môn ðã tiªp nh§n ðóng góp cüa các hÕ!");
		FeedBack_OnHidden()
	end
end

function FeedBack_Help()
	PushDebugMessage("")
end

function FeedBack_OnHidden()
	this:Hide()
end