local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_CreateConfraternity_Frame_UnifiedPosition;
function CreateConfraternity_PreLoad()
	this:RegisterEvent("GUILD_CREATE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function CreateConfraternity_OnLoad()
	g_CreateConfraternity_Frame_UnifiedPosition=CreateConfraternity_Frame:GetProperty("UnifiedPosition");
end

function CreateConfraternity_OnEvent(event)
	if(event == "GUILD_CREATE") then
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "GuildCreate");
		CreateConfraternity_InputConfraternityName:SetText("");
		CreateConfraternity_InputTenet:SetText("M�t th�c l�c Bang h�i m�i n�i");
		CreateConfraternity_InputTenet:SetProperty("CaratIndex", 1024);
		CreateConfraternity_InputConfraternityName:SetProperty("DefaultEditBox", "True");
		if( -1 == Player:GetData("GUILD")) then
			this:Show();
		end
	elseif(event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Guild_Create_Close();
		end
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		CreateConfraternity_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CreateConfraternity_Frame_On_ResetPos()
	end
end

function Guild_Create_Click()
	local szGuildName = CreateConfraternity_InputConfraternityName:GetText();
	local szGuildDesc = CreateConfraternity_InputTenet:GetText();
	
	if(Guild:CreateGuild(szGuildName, szGuildDesc) > 0) then
		Guild_Create_Close();
	end
end

function Guild_Create_Close()
	this:Hide();
	--AxTrace(0,0,"Guild_Create_Close");
	this:CareObject(objCared, 0, "GuildCreate");
end

function CreateConfraternity_Hidden()
	CreateConfraternity_InputConfraternityName:SetProperty("DefaultEditBox", "False");
	CreateConfraternity_InputTenet:SetProperty("DefaultEditBox", "False");
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function CreateConfraternity_Frame_On_ResetPos()
  CreateConfraternity_Frame:SetProperty("UnifiedPosition", g_CreateConfraternity_Frame_UnifiedPosition);
end