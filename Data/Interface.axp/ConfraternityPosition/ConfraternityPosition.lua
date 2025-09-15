local GUILD_POSITION_SIZE = 10; --������ְλ��
local g_ConfraternityPosition_Frame_UnifiedPosition;
function ConfraternityPosition_PreLoad()
	this:RegisterEvent("GUILD_SHOW_APPOINTPOS");
	this:RegisterEvent("GUILD_FORCE_CLOSE");

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternityPosition_OnLoad()
		g_ConfraternityPosition_Frame_UnifiedPosition=ConfraternityPosition_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityPosition_OnEvent(event)
	if(event == "GUILD_SHOW_APPOINTPOS") then
		ConfraternityPosition_PositionList:ClearListBox();
		local i = 0;
		while i < GUILD_POSITION_SIZE do
			local szMsg = Guild:GetMyGuildInfo("Appoint", i);
			--AxTrace(0,0,"Guild Position:"..tostring(i).." pos:"..tostring(szMsg));
			if(nil ~= szMsg and "" ~= szMsg) then
				ConfraternityPosition_PositionList:AddItem(szMsg,i);
			else
				break;
			end
			i = i + 1;
		end
		
		if(nil ~= Guild:GetMyGuildInfo("Appoint", 0)) then
			ConfraternityPosition_PositionList:SetItemSelectByItemID(0);
		end
		this:Show();
	elseif(event == "GUILD_FORCE_CLOSE") then
		this:Hide();
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityPosition_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityPosition_Frame_On_ResetPos()
	end
end

function Guild_Position_Confirm()
	local selidx = ConfraternityPosition_PositionList:GetFirstSelectItem();
	-- add by zchw 
	local szMsg = Guild:GetMyGuildInfo("Appoint", selidx);
	if szMsg == "Th߽ng nh�n " then
		local Num = Guild:GetMemberBak();
		local szLvl = Guild:GetMembersInfo(Num, "Level");	
		if szLvl < 40 then
			PushDebugMessage("Bang Ch�ng d߾i c�p 40 kh�ng th� ���c nh�n ch�c l� Th߽ng Nh�n !");
			return;
		end
	-- end
	end	
	if(-1 ~= selidx) then
		--���������ӿ�
		Guild:AdjustMemberAuth(selidx);
	end
	this:Hide();
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityPosition_Frame_On_ResetPos()
  ConfraternityPosition_Frame:SetProperty("UnifiedPosition", g_ConfraternityPosition_Frame_UnifiedPosition);
end