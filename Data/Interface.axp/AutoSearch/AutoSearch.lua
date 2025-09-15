
--��ǰ��������....���õĳ�������������ʾ��Tabҳ��ͬ....
-- -1 ��Ч
--  0 ����   --ȫ�������ܣ��̵꣬����
--  1 ����   --ȫ��������
--  2 ���䵺 --ȫ����������ޣ�����
--  3 ����   --ȫ�����������
local g_CurSceneType = -1
local g_AutoSearch_Frame_UnifiedPosition;
--���г�����ID�б�....
local g_CitySceneIDList = { 0, 1, 2, 242, 246, 260 }
--���ɳ�����ID�б�....
local g_MenpaiSceneIDList = { 9, 10, 11, 12, 13, 14, 15, 16, 17, 284 }
--���ﳡ����ID�б�....
local g_PetSceneIDList = { 112, 201 }

--��ǰѡ���Tabҳ....
local g_CurSelectTabIndex = 1;

--��ͬ���������¸���Tab��ť����Ӧ�ķ�������....
--������һ����5��Tab....
--�������� ��Ч=-1��ȫ=0����=1����=2����=3����=4����=5����=6����=7���޷����ǩ=99
local g_TableTabIndex2TabType = {
	{	0,	5,	6,	7,	-1,	},
	{	0,	5,	-1,	-1,	-1,	},
	{	0,	2,	3,	4,	-1,	},
	{	0,	1,	2,	-1,	-1,	},
}

--�ϴθ��±�����ʱ������ڳ���ID....
local g_LastUpdateSceneID = -1;

--����Tabҳ���Զ�Ѱ·����....��������ʱ������¼���....
local g_TabListData = {};
g_TabListData[1] = {};
g_TabListData[2] = {};
g_TabListData[3] = {};
g_TabListData[4] = {};
g_TabListData[5] = {};


function AutoSearch_PreLoad()
	this:RegisterEvent("OPEN_AUTOSEARCH");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("TOGLE_AUTOSEARCH")
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end


function AutoSearch_OnLoad()

	--���ڼ���ʱ��̬�Ĳ�����....ֱ����xml�������еĻ��޷������ֵ�....
	AutoSearch_List:AddColumn( "Danh x�ng", 0, 0.6 );
	AutoSearch_List:AddColumn( "T�m t�t (s� l��c)", 1, 0.4 );

	--*****************************************
	--CEGUI��һ��д�Ĳ�����ĵط�(Bug?)....���¶����б���������ʱ�����һЩ����....
	--����Ϊ��
	--��XML�и������б�������ColumnsSizable=True....�ͻ����øÿؼ���ColumnsSizable=True....���������������е�ColumnsSizable=True....
	--��Щ�����б��籾���ڵ���Ҫ�ڽű��ж�̬�Ĳ�����....��ʱXML�����õ�ColumnsSizable=Trueֻ�����øÿؼ���ColumnsSizable=True....���������е�ColumnsSizable=True(��Ϊ��ʱһ���ж�û��)....
	--����ڽű��ж�̬�����к��е�ColumnsSizable��Ϊû�����ù��Ͳ���True....
	--������ڶ�̬�����к��ڽű��������¸������б�����ColumnsSizable=TrueҲ����....
	--��Ϊ���ø����Ե�ֵʱ���ж��Ƿ��뵱ǰ�����Ե�ֵһ��....���һ����ֱ�ӷ���....���ÿؼ���ColumnsSizable�ڳ�ʼ��XML��ʱ�����True�����Ի�ֱ�ӷ���....Ҳ�Ͳ�������������ø�����....
	--�������붯̬�����о���Ҫ�ڶ�̬����������ú����йص�����....ͬʱ��XML�в��ܶԺ����йص����Խ�������....
	--*****************************************
	AutoSearch_List:SetProperty( "ColumnsSizable", "False" );
	AutoSearch_List:SetProperty( "ColumnsAdjust", "True" );
	AutoSearch_List:SetProperty( "ColumnsMovable", "False" );
  g_AutoSearch_Frame_UnifiedPosition=AutoSearch_Frame:GetProperty("UnifiedPosition");
end

-- OnEvent
function AutoSearch_OnEvent(event)

	if ( event == "OPEN_AUTOSEARCH" ) then

		if( this:IsVisible() ) then
			this:Hide();
		else
			AutoSearch_Open();
		end

	elseif ( event == "SCENE_TRANSED" ) then

		--�л�����ʱ�رձ�����
		this:Hide();
		local curSceneID = GetSceneID();
		if (curSceneID == 112) then
			AutoSearch_Open();
		end
	elseif(event == "UI_COMMAND" and tonumber(arg0)==831021) then
		if( this:IsVisible() ) then
			return;
		else
			AutoSearch_Open();
		end
	elseif ( event == "TOGLE_AUTOSEARCH" ) then
		if ( arg0 == "1" ) then
--			AutoSearch_Frame:SetProperty("UnifiedXPosition", "{1.0,-149.0}")
--			AutoSearch_Frame:SetProperty("UnifiedYPosition", "{0.0,226.0}")
			AutoSearch_Open()
		else
			this:Hide();
		end
	end

		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		AutoSearch_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		AutoSearch_Frame_On_ResetPos()
	end

end


--**********************************
--���Զ�Ѱ·����....
--**********************************
function AutoSearch_Open()
	--������������
	InputPosition_x:SetText("");
	InputPosition_y:SetText("");
	--�򿪴���ʱĬ����Tab1....
	if ( true == AutoSearch_UpdateFrame(1) ) then
		--����Tab1��ťΪѡ��״̬....
		AutoSearch_Tab1:SetCheck(1);
		this:Show();
	else
		--�����������뷽ʽ֮�󣬵�ǰ����û�п�Ѱ·Ŀ�꣬ҲҪ����������ע���������
		--���û���κο�Ѱ·��λ�ã�����ʾ"��ǰ�ĳ���û�п�Ѱ·��Ŀ�ꡣ"
		--PushDebugMessage("��ǰ�ĳ���û�п�Ѱ·��Ŀ�ꡣ");
		this:Show();
	end

end

--**********************************
--�����Զ�Ѱ·����....
--�統ǰ����û�п�Ѱ·��λ���򷵻�false....
--**********************************
function AutoSearch_UpdateFrame( tabIndex )

	g_CurSelectTabIndex = tabIndex;

	--������ҵ�ǰ���ڳ����ĳ�������....
	UpdateCurrentSceneType();

	--���ݵ�ǰ�ĳ������͸���Tab��ť....
	UpdateTabButton();

	--�����Զ�Ѱ·�б�....
	return UpdateList( tabIndex );

end

--**********************************
--������ҵ�ǰ���ڳ����ĳ�������....
--**********************************
function UpdateCurrentSceneType()

	local curSceneID = GetSceneID();

	--����
	for i, sceneId in g_CitySceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 0;
			return;
		end
	end

	--����
	for i, sceneId in g_MenpaiSceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 1;
			return;
		end
	end

	--����
	for i, sceneId in g_PetSceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 2;
			return;
		end
	end

	--��������
	g_CurSceneType = 3;

end

--**********************************
--���ݵ�ǰ�ĳ������͸���Tab��ť....
--**********************************
function UpdateTabButton()

	--����
	if g_CurSceneType == 0 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Show();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("To�n");
		AutoSearch_Tab2:SetText("C�ng");
		AutoSearch_Tab3:SetText("Ti�m");
		AutoSearch_Tab4:SetText("Nh�m");

	--����
	elseif g_CurSceneType == 1 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Hide();
		AutoSearch_Tab4:Hide();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("To�n");
		AutoSearch_Tab2:SetText("C�ng");

	--����
	elseif g_CurSceneType == 2 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Show();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("To�n");
		AutoSearch_Tab2:SetText("Nh�n");
		AutoSearch_Tab3:SetText("Th�");
		AutoSearch_Tab4:SetText("M�nh");

	--����
	elseif g_CurSceneType == 3 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Hide();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("To�n");
		AutoSearch_Tab2:SetText("Qu�i");
		AutoSearch_Tab3:SetText("Nh�n");

	end

end

--**********************************
--�����Զ�Ѱ·�б�....
--�����ǰ����û�п�Ѱ·��λ���򷵻�false....
--**********************************
function UpdateList( tabIndex )

	--���List�ؼ��е�����....
	AutoSearch_List:RemoveAllItem();

	--������ϴθ�������֮�󳡾��ı���....������ϴμ���õĸ�Tabҳ���Զ�Ѱ·����....
	local curSceneID = GetSceneID();
	if g_LastUpdateSceneID ~= curSceneID then
		g_TabListData[1] = nil;
		g_TabListData[2] = nil;
		g_TabListData[3] = nil;
		g_TabListData[4] = nil;
		g_TabListData[5] = nil;
		g_LastUpdateSceneID = curSceneID;
	end

	--��ȡ�����ļ���....�������Զ�Ѱ·���ݵ���ʼ�����λ��....
	local nStart, nEnd = DataPool:GetAutoSearchSceneStartEnd( GetSceneID() )

	--���������û�п�Ѱ·��λ���򷵻�false....
	if nStart == -1 then
		return false;
	end

	--���û�б�Tabҳ���Զ�Ѱ·���������¼���....
	local g_TabListDataTablePtr = g_TabListData[tabIndex];

	if not g_TabListDataTablePtr then

		----PushDebugMessage("��tabҳ�����ݻ�û�У�������")
		g_TabListData[tabIndex] = {};
		g_TabListDataTablePtr = g_TabListData[tabIndex];

		--��䱾�����Զ�Ѱ·���ݵ�ID�����ȼ������....
		local tblPriority = {};
		local nCount = nEnd - nStart + 1;
		local k = 1;
		for i=nStart, nEnd do
			tblPriority[k] = {};
			tblPriority[k].id = i;
			tblPriority[k].pri = DataPool:GetAutoSearchPriority(i);
			k = k + 1;
		end

		--�����ȼ��Ա���������....
		--�㷨�е㲻�����....�߻�Ҫ��Ȩֵ��ͬ����������λ�ò��ܸı�....������ôд��....
		local temp1,temp2;
		for m=nCount, 1, -1 do
			for n=m-1, 1, -1 do
				if tblPriority[m].pri >= tblPriority[n].pri then
					temp1 = tblPriority[m].id;
					temp2 = tblPriority[m].pri;
					tblPriority[m].id = tblPriority[n].id;
					tblPriority[m].pri = tblPriority[n].pri;
					tblPriority[n].id = temp1;
					tblPriority[n].pri = temp2;
				end
			end
		end

		--��������ID˳���Զ�Ѱ·�����ݼӵ���Tabҳ���Զ�Ѱ·���ݱ���....
		local curTabType = TabIndex2TabType(tabIndex);
		local x, y, name, tooltips, info, tabtype;
		k = 1;
		for i=1, nCount do
			x, y, name, tooltips, info, tabtype = DataPool:GetAutoSearch( tblPriority[nCount-i+1].id );
			if 0 == curTabType or curTabType == tabtype then
				g_TabListDataTablePtr[k] = {};
				g_TabListDataTablePtr[k].ID = tblPriority[nCount-i+1].id;
				g_TabListDataTablePtr[k].nPosX = x;
				g_TabListDataTablePtr[k].nPosY = y;
				g_TabListDataTablePtr[k].strName = name;
				g_TabListDataTablePtr[k].strToolTips = tooltips;
				g_TabListDataTablePtr[k].strInfo = info;
				--g_TabListDataTablePtr[k].strInfo = tostring(tblPriority[nCount-i+1].pri).."��"..tostring(tblPriority[nCount-i+1].id);
				k = k + 1;
			end
		end

	end --end of (if not g_TabListDataTablePtr then)

	--��䱾ҳ���Զ�Ѱ·���ݵ�List��....
	local nTabListCount = table.getn( g_TabListDataTablePtr );
	----PushDebugMessage("count ="..tostring(nTabListCount) )
	for i=1, nTabListCount do
		AutoSearch_List:AddNewItem( g_TabListDataTablePtr[i].strName, 0, i-1 );
		AutoSearch_List:AddNewItem( g_TabListDataTablePtr[i].strInfo, 1, i-1 );
		AutoSearch_List:SetRowTooltip( i-1, g_TabListDataTablePtr[i].strToolTips );
	end

	return true;

end

--**********************************
--��ȡ�ڵ�ǰ������ָ��Tab��ť����Ӧ�ķ�������....
--**********************************
function TabIndex2TabType( tabIndex )

	if g_CurSceneType ~= -1 and tabIndex >= 1 and tabIndex <= 5 then
		return g_TableTabIndex2TabType[g_CurSceneType+1][tabIndex];
	else
		return -1;
	end

end

--**********************************
--�Զ�Ѱ·��ָ������....
--**********************************
function AutoMoveTo()
	local nPosX = tonumber(InputPosition_x:GetText());
	local nPosY = tonumber(InputPosition_y:GetText());
	if not nPosX or nPosX <= 0 or not nPosY or nPosY <= 0 then
		return;
	end

	--��ȡ��ǰTabҳ���Զ�Ѱ·����....
	local str = GetDictionaryString("ZDXL_90520_2")
	AutoRunToTarget(nPosX, nPosY)
	local TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if TabListDataTablePtr then
		--ѡ���˵ڼ���....
		local nSelIndex = AutoSearch_List:GetSelectItem();
		if nSelIndex >= 0 then
			nSelIndex = nSelIndex + 1;
			if TabListDataTablePtr[nSelIndex].nPosX == nPosX and TabListDataTablePtr[nSelIndex].nPosY == nPosY then
				--����Ŀ��NPC�����֣������NPC������Զ�����Ի�
				SetAutoRunTargetNPCName( TabListDataTablePtr[nSelIndex].strName );
				AutoRunToTarget(nPosX, nPosY)
			end
		end
	end

	--�Զ��ƶ���ָ��λ��
	local ret = AutoRunToTarget( nPosX, nPosY );
	if ret == 0 then
		PushDebugMessage("#{ZDXL_90520_3}")
	end
end

--**********************************
--˫��....
--**********************************
function OnDoubleClick()
	local TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if TabListDataTablePtr then
		--ѡ���˵ڼ���....
		local nSelIndex = AutoSearch_List:GetSelectItem();
		if nSelIndex >= 0 then
		--ֻ�е���ѡ����ʱ������Ӧ˫����Ϣ����ֹ����˫�����б���Ҳ�ƶ������
			AutoMoveTo()
		end
	end
end

--****************************************
--�����Զ�Ѱ·�б��е�NPC���굽���������
--****************************************
function CopyPosition()

	--��ȡ��ǰTabҳ���Զ�Ѱ·����....
	local TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if not TabListDataTablePtr then
		return;
	end

	--ѡ���˵ڼ���....
	local nSelIndex = AutoSearch_List:GetSelectItem();
	if nSelIndex < 0 then
		return;
	end

	nSelIndex = nSelIndex + 1;
	local strPosX = tostring(TabListDataTablePtr[nSelIndex].nPosX);
	local strPosY = tostring(TabListDataTablePtr[nSelIndex].nPosY);
	InputPosition_x:SetText(strPosX);
	InputPosition_y:SetText(strPosY);
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function AutoSearch_Frame_On_ResetPos()
  AutoSearch_Frame:SetProperty("UnifiedPosition", g_AutoSearch_Frame_UnifiedPosition);
end

function AutoSearch_XEnter()
	if (this:IsVisible()) then
		InputPosition_y:SetProperty("DefaultEditBox", "True");
		InputPosition_x:SetProperty("DefaultEditBox", "False");
	end
end

function AutoSearch_YEnter()
	if (this:IsVisible()) then
		AutoMoveTo()
	end
end


