--����ս������
local g_ConfraternityWar_Frame_UnifiedPosition;

function ConfraternityWar_PreLoad()
	this:RegisterEvent("UI_COMMAND");

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")			
end

function ConfraternityWar_OnLoad()
	g_ConfraternityWar_Frame_UnifiedPosition=ConfraternityWar_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityWar_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20081010 ) then
		this:Show()
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityWar_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityWar_Frame_On_ResetPos()
	end
end

function ConfraternityWar_XuanZhan_Click()
	City:AskEnemyList(0);
	this:Hide();
	Guild:CloseKickGuildBox();
end

function ConfraternityWar_Zhnegtao_Click()
	City:AskBattleList(0);
	this:Hide();
	Guild:CloseKickGuildBox();
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityWar_Frame_On_ResetPos()
  ConfraternityWar_Frame:SetProperty("UnifiedPosition", g_ConfraternityWar_Frame_UnifiedPosition);
end