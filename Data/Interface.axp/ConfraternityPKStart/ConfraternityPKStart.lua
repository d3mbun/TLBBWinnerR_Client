local g_ConfraternityPKStart_Frame_UnifiedPosition;

function ConfraternityPKStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDENEMY_DLG");		

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternityPKStart_OnLoad()
	g_ConfraternityPKStart_Frame_UnifiedPosition=ConfraternityPKStart_Frame:GetProperty("UnifiedPosition");
end


function ConfraternityPKStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDENEMY_DLG") then
		ConfraternityPKStart_InitDlg()
		this:Show()
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityPKStart_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityPKStart_Frame_On_ResetPos()
	end
end

function ConfraternityPKStart_InitDlg()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityPKStart_Input:SetText("");
end


function ConfraternityPKStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityPKStart_OnHide()
end

function ConfraternityPKStart_OnHide()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityPKStart_Accept_BtnClick()
	local guid = ConfraternityPKStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("id bang h�i kh�ng th� b� tr�ng!");
		return;
	end
	City:SendAddEnemyMsg(tonumber(guid));
	this:Hide();
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityPKStart_Frame_On_ResetPos()
  ConfraternityPKStart_Frame:SetProperty("UnifiedPosition", g_ConfraternityPKStart_Frame_UnifiedPosition);
end