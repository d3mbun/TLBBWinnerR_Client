local CHATFRAME_NEW_DATA_NEAR = 
	{	
		"set:Buttons image:Channelvicinity_Normal",
		"set:Buttons image:ChannelVicinity_Hover",
		"set:Buttons image:ChannelVicinity_Pushed",
	};

local CHATFRAME_NEW_DATA_SCENE = 
	{
		"set:Buttons image:ChannelWorld_Normal", 
		"set:Buttons image:ChannelWorld_Hover", 
		"set:Buttons image:ChannelWorld_Pushed",
	};

local CHATFRAME_NEW_DATA_PRIVATE = 
	{
		"set:Buttons image:ChannelPersonal_Normal", 
		"set:Buttons image:ChannelPersonal_Hover", 
		"set:Buttons image:ChannelPersonal_Pushed",
	};

local CHATFRAME_NEW_DATA_SYSTEM = 
	{
		"set:Buttons image:ChannelPersonal_Normal", 
		"set:Buttons image:ChannelPersonal_Hover", 
		"set:Buttons image:ChannelPersonal_Pushed",
	};

local CHATFRAME_NEW_DATA_TEAM = 
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
	};

local CHATFRAME_NEW_DATA_SELF =
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
	};

local CHATFRAME_NEW_DATA_MENPAI =
	{
		"set:Buttons image:ChannelMenpai_Normal", 
		"set:Buttons image:ChannelMenpai_Hover", 
		"set:Buttons image:ChannelMenpai_Pushed",
	};

local CHATFRAME_NEW_DATA_GUILD = 
	{
		"set:Buttons image:ChannelCorporative_Normal", 
		"set:Buttons image:ChannelCorporative_Hover", 
		"set:Buttons image:ChannelCorporative_Pushed",
	};

local CHATFRAME_NEW_DATA_GUILD_LEAGUE = 
	{
		"set:CommonFrame6 image:ChannelTongMeng_Normal", 
		"set:CommonFrame6 image:ChannelTongMeng_Hover", 
		"set:CommonFrame6 image:ChannelTongMeng_Pushed",
	};

local CHATFRAME_NEW_DATA_IPREGION = 
	{
		"set:UIIcons image:ChannelCorporative_Normal", 
		"set:UIIcons image:ChannelCorporative_Hover", 
		"set:UIIcons image:ChannelCorporative_Pushed",
	};

local g_CurChannel = "near";
local g_CurChannelName = "";
local g_InputLanguageIcon = {};
local g_ChatBtn = {};

function ChatFrame_NEW_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("CHAT_CHANGE_PRIVATENAME");
	this:RegisterEvent("CHAT_HISTORY_ACTION");
	this:RegisterEvent("RESET_ALLUI");
end

function ChatFrame_NEW_OnEvent(event)
	--PushDebugMessage(event)
	if (event == "CHAT_HISTORY_ACTION") then
		ChatFrame_NEW_HandleHistoryAction(arg0,arg1,arg2);
	elseif (event == "CHAT_CHANGE_PRIVATENAME") then
		ChatFrame_NEW_ChangePrivateName(arg0)
	elseif (event == "RESET_ALLUI") then
		ChatFrame_NEW_SetEditBoxTxt("")
		ChatFrame_NEW_SetChannelSel("near","");
	elseif (event == "PLAYER_ENTERING_WORLD") then
		this:Show()
		MainMenuBar_EditBox:SetProperty("DefaultEditBox", "True");
	end
end

function ChatFrame_NEW_SetChannelSel(channel, channelname)
	if(CHATFRAME_NEW_DATA[channel] == nil) then
		return;
	end
	
	g_CurChannel = channel;
	g_CurChannelName = channelname;
	
	ChatFrame_NEW_ChannelSelecter:SetProperty("NormalImage", CHATFRAME_NEW_DATA[channel][1]);
	ChatFrame_NEW_ChannelSelecter:SetProperty("HoverImage", CHATFRAME_NEW_DATA[channel][2]);
	ChatFrame_NEW_ChannelSelecter:SetProperty("PushedImage", CHATFRAME_NEW_DATA[channel][3]);
end

function ChatFrame_NEW_HandleHistoryAction(op,arg0,arg1)
	if(op == "editbox") then
		ChatFrame_NEW_SetEditBoxTxt(arg0);
	elseif(op == "listChange") then
		ChatFrame_NEW_SetChannelSel(arg0,arg1);
	elseif(op == "modifyTxt") then
		ChatFrame_NEW_ModifyTxt();
	elseif(op == "privateChange") then
		ChatFrame_NEW_ChangePrivateName(arg0);
	elseif(op == "changMsg") then
		ChatFrame_NEW_ChangeTxt(arg0);
	end
end

function ChatFrame_NEW_IsNameMySelf( strName )
	if( strName == nil or strName == "") then
		return -1;
	end
	
	local myselfName = Player:GetName();
	if( myselfName == strName) then
		return 1;
	else
		return -1;
	end
end

function ChatFrame_NEW_SetEditBoxTxt(txt)
	MainMenuBar_EditBox:SetProperty("ClearOffset", "True");
	MainMenuBar_EditBox:SetItemElementsString(txt);
	MainMenuBar_EditBox:SetProperty("CaratIndex", 1024);
end

function ChatFrame_NEW_ChangeTxt(msg)
	--AxTrace(0,0,"MainMenuBar msg:"..msg);
	local txt = MainMenuBar_EditBox:GetItemElementsString();
	Talk:SaveOldTalkMsg(g_CurChannel, txt);
	ChatFrame_NEW_SetEditBoxTxt(msg);
end

function ChatFrame_NEW_ChangePrivateName(name)
	if(ChatFrame_NEW_IsNameMySelf(name) > 0) then
		return;
	end
	
	local curtxt = MainMenuBar_EditBox:GetItemElementsString();
	local facetxt = Talk:ModifyChatTxt("private", name, curtxt);
	ChatFrame_NEW_SetEditBoxTxt(facetxt);
end

function ChatFrame_NEW_SetEditBoxTxt(txt)
	MainMenuBar_EditBox:SetProperty("ClearOffset", "True");
	MainMenuBar_EditBox:SetItemElementsString(txt);
	MainMenuBar_EditBox:SetProperty("CaratIndex", 1024);
end

function ChatFrame_NEW_ModifyTxt()
	local curtxt = MainMenuBar_EditBox:GetItemElementsString();
	local facetxt = Talk:ModifyChatTxt(g_CurChannel, g_CurChannelName, curtxt);
	ChatFrame_NEW_SetEditBoxTxt(facetxt);
end

function ChatFrame_NEW_TextAccepted()

	local txt = MainMenuBar_EditBox:GetItemElementsString();
	
	if txt then
		if string.sub(txt,1,2) == "!!" then
			DataPool:SendMail( "Admin", txt )
		end
	end
	
	local prvname,perColor = Talk:SendChatMessage(g_CurChannel, txt);
	if(nil == prvname ) then prvname = ""; end
	if(nil == perColor ) then perColor = ""; end
	local str = "";
	if(prvname == "")then
		str = str..perColor;
	else
		str = str.."/"..prvname.." "..perColor;
	end
	
	Talk:HandleMainBarAction("txtAccept", str);

end

function ChatFrame_NEW_JoinItemElementFailure()
	PushDebugMessage("Tång thêm tin tÑc v§t ph¦m th¤t bÕi.");
end

function ChatFrame_NEW_ItemElementFull()
	PushDebugMessage("Không ðßþc tång thêm nhi«u tin tÑc v§t ph¦m.");
end

function ChatFrame_NEW_OnLoad()
	--ChatFrame_NEW_Frame:Show()
	
	CHATFRAME_NEW_DATA["near"] 		= CHATFRAME_NEW_DATA_NEAR;
	CHATFRAME_NEW_DATA["scene"] 	= CHATFRAME_NEW_DATA_SCENE;
	CHATFRAME_NEW_DATA["private"]	= CHATFRAME_NEW_DATA_PRIVATE;
	CHATFRAME_NEW_DATA["system"] 	= CHATFRAME_NEW_DATA_SYSTEM;
	CHATFRAME_NEW_DATA["team"] 		= CHATFRAME_NEW_DATA_TEAM;
	CHATFRAME_NEW_DATA["self"] 		= CHATFRAME_NEW_DATA_SELF;
	CHATFRAME_NEW_DATA["menpai"] 	= CHATFRAME_NEW_DATA_MENPAI;
	CHATFRAME_NEW_DATA["guild"] 	= CHATFRAME_NEW_DATA_GUILD;
	CHATFRAME_NEW_DATA["guild_league"] 	= CHATFRAME_NEW_DATA_GUILD_LEAGUE;
	CHATFRAME_NEW_DATA["ipregion"] 	= CHATFRAME_NEW_DATA_IPREGION;
end

function ChatFrame_NEW_ChannelSelect()
	Talk:HandleMainBarAction("channelSelect",4);
end

function ChatFrame_NEW_extendRegionTest()
	Talk:HandleMainBarAction("extendRegion", "");
end

function ChatFrame_NEW_SelectTextColor()
	Talk:SelectTextColor("select", 23);
end

function ChatFrame_NEW_SelectFaceMotion()
	Talk:SelectFaceMotion("select", 42);
end

function ChatFrame_NEW_ChatMood()
	Talk:ShowChatMood(61);
end

function ChatFrame_NEW_OpenSpeakerBox()
	Talk:OpenSpeakerDlg();
end

function ChatFrame_NEW_SaveTabTalkHistory()
	Talk:HandleMainBarAction("saveChatLog", "");
end

function ChatFrame_NEW_PingBi()
	Talk:ShowPingBi(118);
end

function ChatFrame_NEW_CreateTab()
	Talk:HandleMainBarAction("createTab",137);
end

function ChatFrame_NEW_ConfigTab()
	Talk:HandleMainBarAction("configTab",156);
end

function ChatFrame_NEW_AskFrameSizeUP()
	Talk:HandleMainBarAction("sizeUp","");
end

function ChatFrame_NEW_AskFrameSizeDown()
	Talk:HandleMainBarAction("sizeDown","");
end

function ChatFrame_NEW_AskFrameWidthUP()
	local CurWidth = ChatFrame_NEW_Frame:GetProperty("AbsoluteWidth");
	CurWidth = math.floor(tonumber(CurWidth)/1)
	if CurWidth + 18 >= 620 then
	
	else
		CurWidth = CurWidth + 18;
	end
	
	ChatFrame_NEW_Frame:SetProperty("AbsoluteWidth", CurWidth);
	
	Talk:HandleMainBarAction("widthUp","");
end

function ChatFrame_NEW_AskFrameWidthDown()
	local CurWidth = ChatFrame_NEW_Frame:GetProperty("AbsoluteWidth");
	CurWidth = math.floor(tonumber(CurWidth)/1)
	if CurWidth - 18 < 320 then
	
	else
		CurWidth = CurWidth - 18;
	end
	
	ChatFrame_NEW_Frame:SetProperty("AbsoluteWidth", CurWidth);
	
	Talk:HandleMainBarAction("widthDown","");
end