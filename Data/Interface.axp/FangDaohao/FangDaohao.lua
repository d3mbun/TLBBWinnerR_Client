

function FangDaohao_PreLoad()
	this:RegisterEvent("OPENDLG_FANGDAOHAO");
	this:RegisterEvent("CLOSEDLG_FANGDAOHAO");
end

function FangDaohao_OnLoad()
end

function FangDaohao_OnEvent(event)
	--PushDebugMessage("server�����������������⡣");
	if ( event == "OPENDLG_FANGDAOHAO") then
		this:Show();
	elseif( event == "CLOSEDLG_FANGDAOHAO" ) then
		this:Hide();
	end

end

function FangDaohao_Update()
end

function FangDaohao_gotoWeb()
	GameProduceLogin:OpenURL( "http://sde.game.sohu.com" )
end

function FangDaohao_Close()
	--this:Hide()
end
