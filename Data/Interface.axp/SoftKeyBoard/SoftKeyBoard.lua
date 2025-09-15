function SoftKeyBoard_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("TOGGLE_WINDOW");
	this:RegisterEvent("SET_SOFTKEY_AIM");
end

-- 注册onLoad事件
function SoftKeyBoard_OnLoad()
end

function SoftKeyBoard_OnEvent(event)
    if( event == "OPEN_WINDOW" ) then
     	if( arg0 == "SoftKeyBoard" ) then
			SoftKeyBoard_Show();
		end
	elseif( event == "SET_SOFTKEY_AIM" ) then
     	SoftKeyBoard_SoftKey:SetAimEditBox( arg0 );
	-- 打开帐号输入界面
 	elseif( event == "CLOSE_WINDOW" ) then
		if( arg0 == "SoftKeyBoard" ) then
			SoftKeyBoard_Close();
		end
	elseif( event == "TOGGLE_WINDOW" ) then
		if( arg0 == "SoftKeyBoard" ) then
			if( this:IsVisible() ) then
				SoftKeyBoard_Close();
			else
				SoftKeyBoard_Show();
			end
		end
	end
	
end

function SoftKeyBoard_Show()
	AxTrace( 0,0,"SoftKeyBoard_Show" );
	if IsWindowShow("LoginLogOn") then
		SoftKeyBoard_Back:SetProperty("UnifiedXPosition", "{0.500000,-99.000000}");
		SoftKeyBoard_Back:SetProperty("UnifiedYPosition", "{0.434900,100.000000}");
	else
		SoftKeyBoard_Back:SetProperty("UnifiedXPosition", "{0.500000,-242.000000}");
		SoftKeyBoard_Back:SetProperty("UnifiedYPosition", "{0.434900,114.000000}");
	end
	this:Show();
end

function SoftKeyBoard_Close()
	AxTrace( 0,0,"SoftKeyBoard_Close" );
	this:Hide();
end
