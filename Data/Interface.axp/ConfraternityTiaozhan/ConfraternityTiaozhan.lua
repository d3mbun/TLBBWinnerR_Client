
local g_ConfraternityTiaozhan_Frame_UnifiedPosition;
--�������ֽ�����ս����

function ConfraternityTiaozhan_PreLoad()
	this:RegisterEvent("GUILD_SHOW_TIAOZHAN");

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")			
end

function ConfraternityTiaozhan_OnLoad()
	g_ConfraternityTiaozhan_Frame_UnifiedPosition=ConfraternityTiaozhan_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityTiaozhan_OnEvent(event)
	if ( event == "GUILD_SHOW_TIAOZHAN") then
		local guildName = City : GetAttackGuildName();
		if(guildName == nil) then
			return;
		end
		ConfraternityTiaozhan_Text : SetText(guildName.."#{BHXZ_081103_09}");
		this:Show()
	end
	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityTiaozhan_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityTiaozhan_Frame_On_ResetPos()
	end
end

function ConfraternityTiaozhan_InitDlg()
	
end

function ConfraternityTiaozhan_Help()
	
end

function ConfraternityTiaozhan_Accept_Click()
	City:ReponseGuildBattle(1);	
	this:Hide();
end

function ConfraternityTiaozhan_Refuse_Click()
	City:ReponseGuildBattle(0);
	this:Hide();
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityTiaozhan_Frame_On_ResetPos()
  ConfraternityTiaozhan_Frame:SetProperty("UnifiedPosition", g_ConfraternityTiaozhan_Frame_UnifiedPosition);
end