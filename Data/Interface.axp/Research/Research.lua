--UI COMMAND ID 102
local g_MembersCtl = {};
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_CurPage = 1;			--��ǰ�ڵڼ�ҳ
local g_SelActBtn = -1;		--��ǰѡ�е�btn

function Research_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("CITY_SHOW_RESEARCH");
	this:RegisterEvent("CITY_UPDATE_BASE");
end

function Research_OnLoad()
end

function Research_OnEvent(event)
	City_Research_SetCtl();
	if(event == "UI_COMMAND" and tonumber(arg0) == 102) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		City:AskCityResearch();
	elseif(event == "CITY_SHOW_RESEARCH" and arg0 == "open") then
		City_Research_Clear();
		City_Research_Update();
		this:CareObject(g_clientNpcId, 1, "CityResearch");
		this:Show();
	elseif(event == "CITY_SHOW_RESEARCH" and arg0 == "change") then
		if(this:IsVisible()) then
			City_Research_Txt_Clear();
			City_Research_Txt_Update();
			City_Research_Change_ShowPercent();
			City_Research_Act_Clicked(g_SelActBtn);
		end
	elseif(event == "CITY_SHOW_RESEARCH" and arg0 == "update") then
		if(this:IsVisible()) then
			City_Research_List_Update();
		end
	elseif(event == "CITY_SHOW_RESEARCH" and arg0 == "close") then
		this:Hide();
	elseif(event == "CITY_UPDATE_BASE" and this:IsVisible()) then
		City_Research_Txt_Clear();
		City_Research_Txt_Update();
	elseif ( event == "OBJECT_CARED_EVENT") then
		City_Research_CareEventHandle(arg0,arg1,arg2);
	end
end

function City_Research_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end

function City_Research_SetCtl()
	g_MembersCtl =	{
										--Left
										guildname = 		{txt = "",							ctl = Research_Text1},
										mainbuilding = 	{txt = "C�p: ",				ctl = Research_Text2},
										
										guildmoney = 		{txt = "Bang qu�: ",		ctl = Research_Text3},
										degree = {
																		{txt = "Gi� tr� C�ng nghi�p: ",			ctl = Research_Text4},
																		{txt = "Gi� tr� N�ng nghi�p: ",			ctl = Research_Text5},
																		{txt = "Gi� tr� Th߽ng nghi�p: ",			ctl = Research_Text6},
																		{txt = "Gi� tr� Qu�c Ph�ng: ",			ctl = Research_Text7},
																		{txt = "Gi� tr� Khoa h�c k� thu�t: ",			ctl = Research_Text8},
																		{txt = "Gi� tr� m� r�ng: ",			ctl = Research_Text9},
														 },
										
										curitem = 			{txt = "Pha ch� thu�c theo �n: ",				ctl = Research_Text10},
										progress = 			{txt = "Ti�n � nghi�n c�u: ",		ctl = Research_Text11},
										
										--Right
										list = Research_List,
										act = {
														Research_Item1,
														Research_Item2,
														Research_Item3,
														Research_Item4,
													},
										up = Research_UpPage,
										down = Research_DownPage,
										
										--RightBottom   
										needmsg = 			{txt = "Pha ch� thu�c theo �n: ",		ctl = Research_Text12},
										needmoney = 		{txt = "Ng�n l��ng: ",		ctl = Research_Text13},
										needval = 			{txt = "",					ctl = Research_Text14},
										needmission =  	{txt = "Nhi�m v�: ",		ctl = Research_Text15},
									};
end

function City_Research_Clear()
	g_MembersCtl.list:ClearListBox();
	City_Research_Sub_Clear();
	City_Research_Txt_Clear();
end

function City_Research_Txt_Clear()
	local k;
	g_MembersCtl.guildname.ctl:SetText("");
	g_MembersCtl.mainbuilding.ctl:SetText("");
	g_MembersCtl.guildmoney.ctl:SetText("");
	
	for k = 1, table.getn(g_MembersCtl.degree) do
		g_MembersCtl.degree[k].ctl:SetText("");
	end
	
	g_MembersCtl.curitem.ctl:SetText("");
	g_MembersCtl.progress.ctl:SetText("");
end

function City_Research_Sub_Clear()
	City_Research_Act_Clear();
	g_CurPage = 1;
end

function City_Research_Act_Clear()
	local i = 1;
	while i <= 4 do
		g_MembersCtl.act[i]:SetActionItem(-1);
		g_MembersCtl.act[i]:SetPushed(0);
		g_MembersCtl.act[i]:ShowPercentage(-1, -1);
		g_MembersCtl.act[i]:Bright();
		i = i + 1;
	end
	g_SelActBtn = -1;
	
	g_MembersCtl.needmsg.ctl:SetText("");
	g_MembersCtl.needmoney.ctl:SetText("");
	g_MembersCtl.needval.ctl:SetText("");
	g_MembersCtl.needmission.ctl:SetText("");
end

function City_Research_BtnSet()
	local lidx = City_Research_Get_CurSelected_Idx();

	if(lidx < 0) then
		g_MembersCtl.up:Disable();
		g_MembersCtl.down:Disable();
		return;
	end

	local preAction = (City:EnumResearch(lidx, (g_CurPage-1)*4));
	local nextAction = (City:EnumResearch(lidx, (g_CurPage-1)*4+4+1));
		
	if(preAction:GetID() ~= 0)then
		g_MembersCtl.up:Enable();
	else
		g_MembersCtl.up:Disable();
	end
	
	if(nextAction:GetID() ~= 0)then
		g_MembersCtl.down:Enable();
	else
		g_MembersCtl.down:Disable();
	end
end

function City_Research_Update()
	--������Ϣ����
	City_Research_Txt_Update();
	--�о������б�
	local bdList = {City:GetResearchInfo("ResearchBuildingList")};
	local i = 0;
	local txt = "";
	
	local listidx = 0;
	while i < table.getn(bdList) do
		if(0 > City_Research_Is_Hide_Idx(i)) then
			txt = tostring(bdList[i+1]).."Nghi�n c�u ";
			g_MembersCtl.list:AddItem(txt, listidx);
			g_MembersCtl.list:SetItemUserData(listidx, i);
			listidx = listidx + 1;
		end
		i = i + 1;
	end
	--Ĭ��ѡ�е�һ��
	if(listidx > 0) then
		g_MembersCtl.list:SetItemSelectByItemID(0);
	end
end

function City_Research_Txt_Update()
	local k;
	--�������
	local txt = g_MembersCtl.guildname.txt..City:GetBaseInfo("name");
	txt = txt.."("..tostring(City:GetBaseInfo("id"))..")";
	g_MembersCtl.guildname.ctl:SetText(txt);
	--��Ҫ����
	local bName, bLevel = City:GetResearchInfo("MainBuilding");
	txt = g_MembersCtl.mainbuilding.txt..bName;
	txt = txt.."("..tostring(bLevel)..")";
	g_MembersCtl.mainbuilding.ctl:SetText(txt);
	--����ʽ�
	local money = City:GetBaseInfo("money");
	txt = g_MembersCtl.guildmoney.txt;
	if(0 ~= tonumber(money)) then
		txt = txt.."#{_MONEY"..tostring(money).."}";
	else
		txt = txt.."0#-02";
	end
	--AxTrace(0,0,"City_Research guildmoney:"..txt);
	g_MembersCtl.guildmoney.ctl:SetText(txt);
	--���degree
	local de = {City:GetBaseInfo("attr")};
	local deNum = table.getn(de);
	if(deNum > table.getn(g_MembersCtl.degree)) then deNum = table.getn(g_MembersCtl.degree); end
	for k = 1, deNum do
		txt = g_MembersCtl.degree[k].txt;
		txt = txt..tostring(de[k]);
		g_MembersCtl.degree[k].ctl:SetText(txt);
	end
	--��ǰ�о��䷽
	bName, bLevel, _ = City:GetResearchInfo("CurResearch");
	if( -1 == bLevel ) then
	else
		txt = g_MembersCtl.curitem.txt..bName;
		g_MembersCtl.curitem.ctl:SetText(txt);
		--��ǰ�о�����
		local curPro,maxPro = City:GetResearchInfo("ResearchProcess");
		txt = g_MembersCtl.progress.txt..tostring(curPro);
		txt = txt.."/"..tostring(maxPro);
		g_MembersCtl.progress.ctl:SetText(txt);
	end
end

function City_Research_List_Selected()
	local lidx = City_Research_Get_CurSelected_Idx();
	if(lidx < 0) then
		return;
	end
	
	City_Research_Sub_Clear();
	City_Research_BtnSet();
	
	City:AskCityBuildingResearch(lidx);
end

function City_Research_List_Update()
	local lidx = City_Research_Get_CurSelected_Idx();
	
	if(lidx < 0 or lidx == nil) then
		return;
	end
	
	g_CurPage = 1;
	
	local i = 1;
	while i <= 4 do
		City_Research_Act_Set(i);
		
		i = i + 1;
	end
	
	City_Research_Act_Clicked(1);
	City_Research_BtnSet();
end

function City_Research_Change_ShowPercent()
	local lidx = City_Research_Get_CurSelected_Idx();
	
	if(lidx < 0 or lidx == nil) then
		return;
	end
	
	local i = 1;
	while i <= 4 do
		City_Research_Act_Set(i);
		
		i = i + 1;
	end
end

function City_Research_Act_Clicked(id)
	local i = 1;
	while i <= 4 do
		g_MembersCtl.act[i]:SetPushed(0);
		i = i + 1;
	end

	if(id<1 or id>4) then
		return;
	end
	
	--ѡ��״̬
	local ctl = g_MembersCtl.act[tonumber(id)];
	if("False" == ctl:GetProperty("Empty")) then
		ctl:SetPushed(1);
		g_SelActBtn = tonumber(id);
	else
		return;
	end
	
	local lidx = City_Research_Get_CurSelected_Idx();
	if(lidx < 0 or lidx == nil) then
		return;
	end
	--�о�����
	local name,desc = City:GetResearchInfo("ResearchName", lidx, (g_CurPage-1)*4+(tonumber(id)));
	local txt = g_MembersCtl.needmsg.txt.."#c00ccff"..name;
	if("False" == ctl:GetProperty("Gloom")) then
		txt = txt.."��";--..desc;
		g_MembersCtl.needmsg.ctl:SetText(txt);
	else
		txt = txt.."#R(�� ho�n th�nh) #n ";--..desc;
		g_MembersCtl.needmsg.ctl:SetText(txt);
	end
	--�о�����
	local cd = {City:GetResearchInfo("ResearchCondition", lidx, (g_CurPage-1)*4+(tonumber(id)))};
	if(cd[1] == -2) then return; end
	--0.��Ǯ
	local money = cd[1];
	txt = g_MembersCtl.needmoney.txt;
	if(0 ~= tonumber(money)) then
		txt = txt.."#{_MONEY"..tostring(money).."}";
	else
		txt = txt.."0#-02";
	end
	g_MembersCtl.needmoney.ctl:SetText(txt);
	--1.����ֵ
	local nt,nv = cd[3], cd[4];
	txt = g_MembersCtl.needval.txt..tostring(City_Research_GetNeedTxt(nt));
	txt = txt..": #cFF0000"..tostring(nv);
	g_MembersCtl.needval.ctl:SetText(txt);
	--2.������
	local mn = cd[2];
	txt = g_MembersCtl.needmission.txt..tostring(mn);
	g_MembersCtl.needmission.ctl:SetText(txt);
end

function City_Research_GetNeedTxt(nt)
	if( tonumber(nt) == 0 ) then
		return "Gi� tr� c�ng nghi�p ";
	elseif( tonumber(nt) == 1 ) then
		return "Gi� tr� n�ng nghi�p ";
	elseif( tonumber(nt) == 2 ) then
		return "Gi� tr� th߽ng nghi�p ";
	elseif( tonumber(nt) == 3 ) then
		return "Gi� tr� qu�c ph�ng ";
	elseif( tonumber(nt) == 4 ) then
		return "Gi� tr� khoa h�c ";
	elseif( tonumber(nt) == 5 ) then
		return "Gi� tr� khu�ch tr߽ng ";
	else
		return "";
	end
end

function City_Research_UpPage()
	City_Research_NextPage(-1);
end

function City_Research_DownPage()
	City_Research_NextPage(1);
end

function City_Research_NextPage(dir)
	local lidx = City_Research_Get_CurSelected_Idx();
	
	if(lidx < 0 or lidx == nil) then
		return;
	end
	
	if(g_CurPage == 1 and dir < 0) then return; end --�Ѿ��ǵ�һҳ
	local newPage = g_CurPage+dir;
	local newAction = (City:EnumResearch(lidx, (newPage-1)*4+1));
	if(newAction:GetID() == 0) then return; end --��ҳ�ĵ�һ��λ���Ͼ�û���о���Ŀ
	
	g_CurPage = newPage;	
	local i = 1;
	while i <= 4 do
		City_Research_Act_Set(i);
		
		i = i + 1;
	end
	
	City_Research_Act_Clicked(1);
	City_Research_BtnSet();
end

function City_Research_Do()
	local lidx = City_Research_Get_CurSelected_Idx();
	if(lidx < 0 or lidx == nil or g_SelActBtn < 0) then
		return;
	end
	
	City:DoConfirm(8, lidx, (g_CurPage-1)*4+g_SelActBtn);
end

function City_Research_Stop()
	City:DoConfirm(7);
end

function City_Research_Act_Set(id)
	local lidx = City_Research_Get_CurSelected_Idx();
	if(lidx < 0 or lidx == nil or tonumber(id) < 0) then
		return;
	end
	
	local theAction, isCurrent, isExist = City:EnumResearch(lidx, (g_CurPage-1)*4+(tonumber(id)));
	if theAction:GetID() ~= 0 then
		--����ActionItem
		g_MembersCtl.act[tonumber(id)]:SetActionItem(theAction:GetID());
		--�����Ƿ��ǵ�ǰ�о�
		if(isCurrent < 0) then
			g_MembersCtl.act[tonumber(id)]:ShowPercentage(-1, -1);
		elseif(isCurrent > 0) then
			local curProcess,maxProcess = City:GetResearchInfo("ResearchProcess");
			g_MembersCtl.act[tonumber(id)]:ShowPercentage(curProcess, maxProcess);
		end
		--�����Ƿ��Ѿ���ɵ��о�
		if(isExist < 0) then
			g_MembersCtl.act[tonumber(id)]:Bright();
		elseif(isExist > 0) then
			g_MembersCtl.act[tonumber(id)]:Gloom();
		end
	else
		g_MembersCtl.act[tonumber(id)]:SetActionItem(-1);
	end
end

function City_Research_Is_Hide_Idx(idx)
	--Ŀǰ����ʾ�Ľ��������ͣ���Ӧenum BUILDING_TYPE
	local tHide = {0,1,4,6,7,8,9,12,13,14,15,16,17};
	local i = 1;
	while i <= table.getn(tHide) do
		if(tHide[i] == idx) then return 1; end
		i = i + 1;
	end
	return -1;
end

function City_Research_Get_CurSelected_Idx()
	local lidx = g_MembersCtl.list:GetFirstSelectItem();
	if(lidx < 0 or lidx == nil) then
		return -1;
	end
	
	return g_MembersCtl.list:GetItemUserData(lidx);
end