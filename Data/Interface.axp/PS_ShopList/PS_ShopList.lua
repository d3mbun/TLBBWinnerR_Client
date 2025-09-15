
local g_Selectindex = -1;
local g_nShopIndex = {};
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local OpenType =0; --0:�̵��б� 1:�չ��̵��б�
local g_LastSelect_NormalShop =""
local g_LastSelect_RecycleShop =""
--===============================================
-- OnLoad
--===============================================
function PS_ShopList_PreLoad()
	this:RegisterEvent("PS_OPEN_SHOPLIST");						-- �������̵���б�
	this:RegisterEvent("PS_UPDATE_SEARCH_SHOPLIST");	-- �򿪷������к���б�
	this:RegisterEvent("PS_OPEN_RECYCLESHOPLIST");	-- �򿪷������к���б�
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_UPDATE_SEARCH_RECYCLESHOPLIST");
	
end

function PS_ShopList_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_ShopList_OnEvent(event)
	if ( event == "PS_OPEN_SHOPLIST" ) then
		OpenType = 0;
		this:Show();
		--objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Shoplist");
	
		g_Selectindex = -1;

		PS_ShopList_Search_UpdateFrame();
		
	elseif( event == "PS_UPDATE_SEARCH_SHOPLIST" )  then
		g_Selectindex = -1;
		OpenType = 0;
		PS_ShopList_Search_UpdateFrame();
		
	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--ȡ������
			this:CareObject(objCared, 0, "PS_Shoplist");
		end	
	elseif(event == "PS_UPDATE_SEARCH_RECYCLESHOPLIST")then
		OpenType = 1;
		g_Selectindex = -1;
		PS_ShopList_Search_UpdateFrame();
	end

end

--===============================================
-- UpdateFrame()   �Ѿ�û��ʹ�����������
--===============================================
function PS_ShopList_UpdateFrame()
	
	--��ҵָ��
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("Ch� s� th߽ng nghi�p; " .. szTemp);
	
	PS_ShopList_ShopList:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("all");
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		--	    ����,     ������, ������, ����
		local szShopName,OpenNum,SaleNum,szType = PlayerShop:EnumShop(i);
		local szState = SaleNum.."/"..OpenNum;
		PS_ShopList_ShopList:AddNewItem(szShopName, 0, i);
		PS_ShopList_ShopList:AddNewItem(szState, 1, i);
		PS_ShopList_ShopList:AddNewItem(szType, 2, i);	
		
		g_nShopIndex[i] = i;
	end
	
	UpdateShopInfo();	
	
end

--===============================================
-- ��ʾ�����ѯ���
--===============================================
function PS_ShopList_Search_UpdateFrame()
	PS_ShopList_Check_Item:Show();
	PS_ShopList_Check_Item2:Show();
	local ListCtr ;
	if(OpenType == 0) then
		PS_ShopList_Check_Item2:SetCheck(1);
		PS_ShopList_Check_Item:SetCheck(0);
		PS_ShopList_RecycleShopList:Hide();
		PS_ShopList_ShopList:Show();
		PS_ShopList_Button_Accept:SetProperty("Text", "Mua b�n");
		ListCtr = PS_ShopList_ShopList;
		PS_ShopList_Find:Show();
		PS_ShopList_Button_Remove:Show();
		PS_ShopList_Button_Manage:Show();
	else
		PS_ShopList_Check_Item2:SetCheck(0);
		PS_ShopList_Check_Item:SetCheck(1);
		PS_ShopList_RecycleShopList:Show();
		PS_ShopList_ShopList:Hide();
		PS_ShopList_Button_Accept:SetProperty("Text", "�em b�n");
		ListCtr = PS_ShopList_RecycleShopList;
		PS_ShopList_Find:Hide();
		PS_ShopList_Button_Manage:Show();
		PS_ShopList_Button_Remove:Hide();
	end


	

	PS_ShopList_DragTitle:SetText("#gFF0FA0C�a h�ng th߽ng h�i");

	local szType = PlayerShop:GetShopListType();
	if(szType == "panchu" and OpenType==0)  then
		PS_ShopList_Find:Hide()
		PS_ShopList_Check_Item:Hide();
		PS_ShopList_Check_Item2:Hide();
		PS_ShopList_Button_Remove:Hide();
		PS_ShopList_Button_Manage:Hide();
		PS_ShopList_Button_Accept:SetText("Xem");
		PS_ShopList_DragTitle:SetText("#gFF0FA0 ti�u chu�n ��a ra c�a h�ng");

	end


	--���˵������
	PS_ShopList_Since:SetText("");				-- ����ʱ��
	PS_ShopList_ShopOwner:SetText("");		-- ��������
	PS_ShopList_ShopOwnerID:SetText("");	-- ����ID
	PS_ShopList_ShopInfo:SetText("");			-- ����

	g_Selectindex = -1;

	--��ҵָ��
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("Ch� s� th߽ng nghi�p: " .. szTemp);
	ListCtr:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("search");
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		local nIndex = PlayerShop:EnumSearchShopIndex(i);
		
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(nIndex);
		local szState = SaleNum.."/"..OpenNum;

		if OpenType ==0 and szShopName == g_LastSelect_NormalShop then
			g_Selectindex = i;
		end
		
		if OpenType ==1 and szShopName == g_LastSelect_RecycleShop then
			g_Selectindex = i;
		end

		if nFrezeType == 1 then
			szShopName = "#cCCCCCC" .. szShopName
			szState    = "#cCCCCCC" .. szState
			szType     = "#cCCCCCC" .. szType
			nRecItemnum =  "#cCCCCCC" .. nRecItemnum
		elseif nIsFavor == 1 then
			szShopName = "#B" .. szShopName;
			szState    = "#B" .. szState;
			szType     = "#B" .. szType;
			nRecItemnum =  "#B" .. nRecItemnum;
		end

		if(OpenType == 0) then
			ListCtr:AddNewItem(szShopName, 0, i);
			ListCtr:AddNewItem(szState, 1, i);
			ListCtr:AddNewItem(szType, 2, i);
		else
			ListCtr:AddNewItem(szShopName, 0, i);
			ListCtr:AddNewItem(nRecItemnum, 1, i);
		end
		
		g_nShopIndex[i] = nIndex;
		
	end

	if (g_Selectindex >= 0) then
		ListCtr:SetSelectItem(g_Selectindex)
		ListCtr:SetVertScollPosition(g_Selectindex)
	end
end

--===============================================
-- Refuse
--===============================================
function PS_ShopListRefuse_Clicked()
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "PS_Shoplist");

end

--===============================================
-- Accept
--===============================================
function PS_ShopListAccept_Clicked(szType)
	--ȥ��ѡ�е��б�
	if( g_Selectindex >= 0 )      then
		if OpenType ==1 then
			--�չ��̵�,����
			PlayerShop:OpenRecycleShopDLG2(g_nShopIndex[g_Selectindex],szType);
			return
		else
			if( szType == "buy" )    then
				PlayerShop:AskOpenShop("buy",g_nShopIndex[g_Selectindex]);
			else
				PlayerShop:AskOpenShop("manage",g_nShopIndex[g_Selectindex]);
			end
		end
	else 
		PushDebugMessage("M�i ch�n c�a h�ng");
		return;
	end
	
--	this:Hide();
	--ȡ������
--	this:CareObject(objCared, 0, "PS_Shoplist");
	
end

--===============================================
-- ����б�
--===============================================
function PS_ShopList_SelectChanged()
	
	local nIndex = PS_ShopList_ShopList:GetSelectItem();
	
	g_Selectindex = nIndex;
	
	if(g_Selectindex == -1)  then
		return;
	end
	PlayerShop:SetCurSelShopIdx(g_nShopIndex[nIndex]);
	
	local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[nIndex]);
	
	g_LastSelect_NormalShop = szShopName;
	
	--������ʾ����Ϣ
	UpdateShopInfo()
	
end

function PS_RecycleShopList_SelectChanged()
	
	local nIndex = PS_ShopList_RecycleShopList:GetSelectItem();
	
	g_Selectindex = nIndex;
	
	if(g_Selectindex == -1)  then
		return;
	end
	PlayerShop:SetCurSelShopIdx(g_nShopIndex[nIndex]);
	
	local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[nIndex]);
	
	g_LastSelect_RecycleShop = szShopName;
	
	--������ʾ����Ϣ
	UpdateShopInfo()
	
end

--===============================================
-- �����̵����Ϣ
--===============================================
function UpdateShopInfo()

	if g_Selectindex == -1    then
		return;
	end
	
	--������Ϣ
	-- ����ʱ��
	local szSince = PlayerShop:EnumShopInfo("since",g_nShopIndex[g_Selectindex]);
	PS_ShopList_Since:SetText("Th�i gian t�o: ".. szSince);
	
	-- �������� --��Ϊ������ by wangdw
	local szName = PlayerShop:EnumShopInfo("ownername",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwner:SetChatString("#YCh� ti�m: #{_INFOUSR".. szName .. "}");
	
	-- ����ID
	local szID = PlayerShop:EnumShopInfo("ownerid",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwnerID:SetText("ID:".. szID);
	
	-- ����
	local szInfo = "";
	if(OpenType == 0)then
		 szInfo = PlayerShop:EnumShopInfo("desc",g_nShopIndex[g_Selectindex]);
	else
		 szInfo = PlayerShop:EnumShopInfo("recdesc",g_nShopIndex[g_Selectindex]);
	end
		
	PS_ShopList_ShopInfo:SetText(szInfo);
	
	-- ����/ȥ�� ����
	if( g_Selectindex == -1 )   then 
		return;
	end
	local szShopName,OpenNum,SaleNum,szType,nIsFavor = PlayerShop:EnumShop(g_nShopIndex[g_Selectindex]);
	if(nIsFavor == 1)   then
		PS_ShopList_Button_Remove:SetText("B� t�n ti�m");
	else
		PS_ShopList_Button_Remove:SetText("#{INTERFACE_XML_353}");
	end
	
end


--===============================================
-- Close
--===============================================
function PS_CreateShopClose_Clicked()
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "PS_Shoplist");
end

--===============================================
-- ����
--===============================================
function PS_ShopList_Find_Clicked()
	PlayerShop:OpenFindShop();
end

--===============================================
-- ����/ȥ�� ����
--===============================================
function PS_ShopList_Favor_Clicked()
	local selectIndex = PS_ShopList_ShopList:GetSelectItem();
	if(selectIndex < 0)     then
		return;
	end
	PlayerShop:AddFavor(g_nShopIndex[selectIndex]);
	
	local totalCount = PS_ShopList_ShopList:GetItemCount();
	
	--����������Զ�ѡ����һ���꣬����Ѿ������һ�����ˣ���ѡ��ǰһ�������ֻ��һ���꣬��ѡ���Լ�
	if(selectIndex + 1 < totalCount) then
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex + 1]);
		g_LastSelect_NormalShop = szShopName;
	elseif(selectIndex - 1 >= 0) then
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex - 1]);
		g_LastSelect_NormalShop = szShopName;
	else
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex]);
		g_LastSelect_NormalShop = szShopName;
	end
end

--===============================================
-- OnHiden
--===============================================
function PS_ShopList_Frame_OnHiden()
	PlayerShop:CloseSearchFrame();

end

function PS_ShopList_ChangeTabIndex(idx)
	
	if(idx==0)then
		if(PS_ShopList_Check_Item2:GetCheck()~=1)then
			PlayerShop:FindShop("all",0);
		end
	else
		if(PS_ShopList_Check_Item:GetCheck()~=1)then
			PlayerShop:FindShop("recycleshop",0);
		end
	end
end
