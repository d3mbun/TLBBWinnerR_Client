local g_ListType = 0;
local g_ConfraternityPK_Frame_UnifiedPosition;

function ConfraternityPK_PreLoad()
	this:RegisterEvent("GUILD_SHOW_ENEMYLIST");	
	this:RegisterEvent("GUILD_UPDATE_ENEMYLIST");
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityPK_OnLoad()
	g_ConfraternityPK_Frame_UnifiedPosition=ConfraternityPK_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityPK_OnEvent(event)
	if ( event == "GUILD_SHOW_ENEMYLIST") then
		g_ListType = tonumber(arg0);
		ConfraternityPK_InitDlg()
		ConfraternityPK_UpdateDlg()
		this:Show()
	end
	if ( event == "GUILD_UPDATE_ENEMYLIST") then
		if(this:IsVisible())then
			ConfraternityPK_UpdateDlg()
			this:Show();
		end
	end
	
	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityPK_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityPK_Frame_On_ResetPos()
	end
	
end

function ConfraternityPK_InitDlg()
	if(g_ListType == 0) then
		ConfraternityPK_DragTitle:SetText("#{ConfraternityPK_XML_1}")
		ConfraternityPK_LookupButton:SetText("#{ConfraternityPK_XML_4}"); --�鿴����ӭս�б�
		ConfraternityPK_List_Text:SetText("#{ConfraternityPK_XML_2}"); --���ﵱǰ��ս�б�
		ConfraternityPK_StartBtn:Show();
	else
		ConfraternityPK_DragTitle:SetText("#{ConfraternityPK_XML_10}")
		ConfraternityPK_LookupButton:SetText("#{ConfraternityPK_XML_5}") --������ս�б�
		ConfraternityPK_List_Text:SetText("#{ConfraternityPK_XML_11}"); --���ﵱǰӦս�б�
		ConfraternityPK_StartBtn:Hide();
	end
	
end

function ConfraternityPK_UpdateDlg()
		ConfraternityPK_List:RemoveAllItem();
		local nNum = City:GetEnemyNum(g_ListType);
		for i=0 , nNum-1 do
			local nGulidid = City:EnumCityEnemy(g_ListType,i,"guildid");
			local szGuildName = City:EnumCityEnemy(g_ListType,i,"name");
			local szLeftTime = City:EnumCityEnemy(g_ListType,i,"lefttime");
		
			if(nIsFavor == 1)  then
				szShopName = "#B" .. szShopName;
				szState    = "#B" .. szState;
				szType     = "#B" .. szType;
			end
			ConfraternityPK_List:AddNewItem(nGulidid, 0, i);
			ConfraternityPK_List:AddNewItem(szGuildName, 1, i);
			ConfraternityPK_List:AddNewItem(szLeftTime, 2, i);	
		end		
end

function ConfraternityPK_StartBtn_Click()
	if(g_ListType == 0) then
		City:OpenAddEnemyDlg();
	end
end

function ConfraternityPK_LookupButton_Click()
	if(g_ListType==nil)then
		return;
	end
	City:AskEnemyList(1-g_ListType);
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityPK_Frame_On_ResetPos()
  ConfraternityPK_Frame:SetProperty("UnifiedPosition", g_ConfraternityPK_Frame_UnifiedPosition);
end