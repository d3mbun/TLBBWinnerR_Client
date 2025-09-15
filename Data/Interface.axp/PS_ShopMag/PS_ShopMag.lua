local PS_BUTTON_NUM = 20;
local PS_BUTTON = {};

local PS_STALL_NUM = 10;
local PS_STALL_BOTTON = {};

local g_nCurSelectItem = -1;
local g_nCurStallIndex = -1;

local g_StallNum = 0;
local g_bCurStallOpen = 0;

--��־��ǰ�����޽��滹����Ʒ����
local STALL_NONE = 0
local STALL_ITEM = 1;
local STALL_PET  = 2;
local g_CurStallObj = STALL_NONE;

local g_SaleOuting = 0;
 
local g_PetIndex  = {};

--��־�Լ���ݣ��������ǻ�ƣ�
g_SelfPlace  = "";

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_lastIndex = -1;
--===============================================
-- PreLoad
--===============================================
function PS_ShopMag_PreLoad()
	this:RegisterEvent("PS_OPEN_MY_SHOP");
	this:RegisterEvent("PS_UPDATE_MY_SHOP");
	this:RegisterEvent("PS_SELF_ITEM_CHANGED");
	this:RegisterEvent("PS_SELF_SELECT");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_SHOP_RENAME");
	this:RegisterEvent("PS_CLOSE_ALL_SHOP");
    this:RegisterEvent("UI_COMMAND");
	
end

--===============================================
-- OnLoad
--===============================================
function PS_ShopMag_OnLoad()
	
	PS_BUTTON[1]  = PS_ShopMag_Item1; 
	PS_BUTTON[2]  = PS_ShopMag_Item2; 
	PS_BUTTON[3]  = PS_ShopMag_Item3; 
	PS_BUTTON[4]  = PS_ShopMag_Item4; 
	PS_BUTTON[5]  = PS_ShopMag_Item5; 
	PS_BUTTON[6]  = PS_ShopMag_Item6; 
	PS_BUTTON[7]  = PS_ShopMag_Item7; 
	PS_BUTTON[8]  = PS_ShopMag_Item8; 
	PS_BUTTON[9]  = PS_ShopMag_Item9; 
	PS_BUTTON[10] = PS_ShopMag_Item10;
	PS_BUTTON[11] = PS_ShopMag_Item11;
	PS_BUTTON[12] = PS_ShopMag_Item12;
	PS_BUTTON[13] = PS_ShopMag_Item13;
	PS_BUTTON[14] = PS_ShopMag_Item14;
	PS_BUTTON[15] = PS_ShopMag_Item15;
	PS_BUTTON[16] = PS_ShopMag_Item16;
	PS_BUTTON[17] = PS_ShopMag_Item17;
	PS_BUTTON[18] = PS_ShopMag_Item18;
	PS_BUTTON[19] = PS_ShopMag_Item19;
	PS_BUTTON[20] = PS_ShopMag_Item20;
	
	PS_STALL_BOTTON[1]   = PS_ShopMag_Page1;
	PS_STALL_BOTTON[2]   = PS_ShopMag_Page2;
	PS_STALL_BOTTON[3]   = PS_ShopMag_Page3;
	PS_STALL_BOTTON[4]   = PS_ShopMag_Page4;
	PS_STALL_BOTTON[5]   = PS_ShopMag_Page5;
	PS_STALL_BOTTON[6]   = PS_ShopMag_Page6;
	PS_STALL_BOTTON[7]   = PS_ShopMag_Page7;
	PS_STALL_BOTTON[8]   = PS_ShopMag_Page8;
	PS_STALL_BOTTON[9]   = PS_ShopMag_Page9;
	PS_STALL_BOTTON[10]  = PS_ShopMag_Page10;
	
	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end
	
end

--===============================================
-- OnEvent
--===============================================
function PS_ShopMag_OnEvent(event)
	if ( event == "PS_OPEN_MY_SHOP" )   then
		this:Show();
		--objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_ShopMag");	
		PS_ShopMag_FriendID:SetText( "" );


		--��ѯ�ǲ��Ǵ����̳�״̬
		g_SaleOuting = PlayerShop:IsSaleOut("self");

		--�л������޻�����Ʒ
		if( tonumber(arg1) == 1 ) then
			g_CurStallObj = STALL_ITEM;
			PS_ShopMag_PetList:Hide();
			PS_ShopMag_Item_Frame:Show();
			PS_ShopMag_OpenRecycleShop_Btn:Show();
		else
			g_CurStallObj = STALL_PET;
			PS_ShopMag_PetList:Show();
			PS_ShopMag_Item_Frame:Hide();
			PS_ShopMag_OpenRecycleShop_Btn:Hide();
		end
		
		g_nCurStallIndex = 1;

		PlayerShop:SetCurSelectPage("self",g_nCurStallIndex-1);
		g_StallNum = PlayerShop:GetStallNum("self");
		
		PS_ShopMag_UpdateFrame();
		
	--�����̵�
	elseif(event == "PS_SHOP_RENAME")      then
		--����
		local szShopName = PS_ShopMag_MerchantName:GetText();
		PS_ShopMag_MerchantName:SetText(szShopName);
		PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);
		
		
	--�����̵�
	elseif(event == "PS_UPDATE_MY_SHOP")      then
		if(this:IsVisible() == false)  then
			return;
		end
		
		--��ѯ�ǲ��Ǵ����̳�״̬
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		PlayerShop:ClearSelectPos("self");
		g_StallNum = PlayerShop:GetStallNum("self");
		PS_ShopMag_UpdateFrame();
		
	elseif(event == "PS_SELF_ITEM_CHANGED")   then
		--��ѯ�ǲ��Ǵ����̳�״̬
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		PS_ShopMag_UpdateFrame();
		
	--ѡ����Ʒ�Ĳ���
	elseif(event == "PS_SELF_SELECT")   then
		--��ѯ�ǲ��Ǵ����̳�״̬
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		g_nCurSelectItem = PlayerShop:GetSelectIndex("self");
		PS_ShopMag_UpdateFrame();
		
		local nOnSale = PlayerShop:IsSelectOnSale("item");
	 	
	 	if nOnSale == 0  then
	 		PS_ShopMag_DownStall:SetText("L�n gi�");
	 	else
	 		PS_ShopMag_DownStall:SetText("H� gi�");
	 	end

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--ȡ������
			this:CareObject(objCared, 0, "PS_ShopMag");
		end	
		
	elseif( event == "PS_CLOSE_ALL_SHOP" )    then
		this:Hide();
		
		--ȡ������
		this:CareObject(objCared, 0, "PS_ShopMag");
		
	elseif( event == "UI_COMMAND" )    then
	    if( tonumber(arg0) == 19810222 ) then
    	    this:Hide();
		
		    --ȡ������
		    this:CareObject(objCared, 0, "PS_ShopMag");
    	end
	 	
	end
end

--===============================================
-- ѡ�����޵Ĳ���
--===============================================
function PS_ShopMag_PetList_Selected()
	
	local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end
	
	PlayerShop:SetSelectPet( g_PetIndex[nIndex] );
	local nOnSale = PlayerShop:IsSelectOnSale("pet",g_PetIndex[nIndex]);

 	if nOnSale == 0  then
 		PS_ShopMag_DownStall:SetText("L�n gi�");
 	else
 		PS_ShopMag_DownStall:SetText("H� gi�");
 	end
 	
 	--֪ͨC����
	PlayerShop:SetCurSelectPetIndex("self",g_nCurStallIndex-1,g_PetIndex[nIndex]);
	
	--֪ͨ����ˢ��"����"��"�۸�"
	-- ��ʾ���ڵ�ѡ�е���Ʒ���������޵ļ۸�
	if( g_CurStallObj == STALL_PET )then
		local nMoney = PlayerShop:GetObjPrice("self","pet");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szPetName = PlayerShop:GetObjName("self","pet");
		PS_ShopMag_TradeName:SetText(szPetName);
		
	end	
	
end

--===============================================
-- UpdateFrame()
--===============================================
function PS_ShopMag_UpdateFrame()
	
	if( g_nCurStallIndex > g_StallNum )   then 
		g_nCurStallIndex = 1;
		PlayerShop:AskStallData("self",g_nCurStallIndex -1);
		return;
	end
	
	--����  --��Ϊ������ by wangdw
	local szName = PlayerShop:GetShopInfo("self","ownername");
	PS_ShopMag_Shopkeeper_Name:SetChatString("#YCh� ti�m: #{_INFOUSR".. szName .. "}");
	
	--����ID
	local szID = PlayerShop:GetShopInfo("self","ownerid");
	PS_ShopMag_Shopkeeper_ID:SetText("ID ch� ti�m:  ".. szID);
	
	--����
	local szShopName = PlayerShop:GetShopInfo("self","shopname");
	PS_ShopMag_MerchantName:SetText(szShopName);
	PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);

	--����
	local szShopDesc = PlayerShop:GetShopInfo("self","desc");
	PS_ShopMag_Bewrite:SetText(szShopDesc);
	
	--��������
	local nBaseMoney = PlayerShop:GetMoney("base","self");
	PS_ShopMag_ShopCorpus:SetProperty("MoneyNumber", tostring(nBaseMoney));
	
	--ӯ���ʽ�
	local nProfitMoney = PlayerShop:GetMoney("profit","self");
	PS_ShopMag_ShopProfit:SetProperty("MoneyNumber", tostring(nProfitMoney));
	
	--��ҵָ��
	local szCommercialFactor = PlayerShop:GetCommercialFactor();
	PS_ShopMag_CommerceExponential:SetText("Ch� s� th߽ng nghi�p: " .. szCommercialFactor);
	
	--����������
	PS_ShopMag_Curtail:Enable();
	PS_ShopMag_Continuation:Enable();
	if ( g_StallNum == 1 )   then
		PS_ShopMag_Curtail:Disable();					--����
	end
	
	if(g_StallNum == 10)  then
		PS_ShopMag_Continuation:Disable();			--����
	end
	
	--֪ͨC����
	PlayerShop:SetCurSelectPage("self",g_nCurStallIndex-1);
	
	--ˢ�½�����ؿؼ�
	if( g_nCurStallIndex == 1 )  then
		PS_ShopMag_Last:Disable();
	else
		PS_ShopMag_Last:Enable();
	end
	
	if( g_nCurStallIndex == g_StallNum )   then
		PS_ShopMag_Next:Disable();
	else
		PS_ShopMag_Next:Enable();
	end
	
	PS_ShopMag_CurrentlyPageNumber:SetText(tostring(g_nCurStallIndex).."/".. tostring(g_StallNum));
	for i=1 ,PS_STALL_NUM  do
		PS_STALL_BOTTON[i]:Disable();
	end
	for i=1 ,g_StallNum  do
		PS_STALL_BOTTON[i]:Enable();
	end
	
	if( g_CurStallObj == STALL_ITEM )then
		PS_ShopMag_UpdateItem();
	else
		PS_ShopMag_UpdatePet();
	end
	
	--��ʾ�����̨��ǰ��״̬��Open����Close
	g_bCurStallOpen = PlayerShop:IsOpenStall("self",g_nCurStallIndex -1);
	
	if (g_bCurStallOpen == 2)  then 
		PS_ShopMag_Open:SetText("��ng c�a");
		PS_ShopMag_DownStall:Enable();
		PS_ShopMag_Stall_State:SetText("Tr�ng th�i qu�y h�ng hi�n t�i: #GKhai tr߽ng");
	else
		PS_ShopMag_Open:SetText("Khai tr߽ng");
		PS_ShopMag_DownStall:Disable();
		PS_ShopMag_Stall_State:SetText("Tr�ng th�i qu�y h�ng hi�n t�i: #R��ng c�a");
	end
	
	-- ��ʾ���ڵ�ѡ�е���Ʒ���������޵ļ۸�
	if( g_CurStallObj == STALL_ITEM )then
		local nMoney = PlayerShop:GetObjPrice("self","item");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szItemName = PlayerShop:GetObjName("self","item");
		PS_ShopMag_TradeName:SetText(szItemName);
		
	else
		local nMoney = PlayerShop:GetObjPrice("self","pet");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szPetName = PlayerShop:GetObjName("self","pet");
		PS_ShopMag_TradeName:SetText(szPetName);
		 
	end	
	
	PS_ShopMag_ShowHide_Windows();

	--�ϻ��˹�����
	PS_ShopMag_FriendList:ClearListBox();
	local nNum = PlayerShop:GetFriendNum();
	for i=0 ,nNum-1  do
		local szFriendName = PlayerShop:EnumFriend(i);
		PS_ShopMag_FriendList:AddItem(szFriendName, i);
	
	end
	PS_STALL_BOTTON[g_nCurStallIndex]:SetCheck(1);
	
end

--===============================================
-- ������Ʒ,��Show���е�Window��Ȼ�������ҪHide���
--===============================================
function PS_ShopMag_ShowHide_Windows()

	PS_ShopMag_NameAmend:Show();			-- �޸ĵ���
	PS_ShopMag_BewriteAmend:Show();		-- �޸��̵�˵��
	PS_ShopMag_SortAmend:Show();			-- �޸�����

	PS_ShopMag_DrawMoney:Show();			-- ֧ȡ
	
	PS_ShopMag_AccountBook:Show();		-- �˱�
	PS_ShopMag_Open:Show();						-- ����
	PS_ShopMag_DownStall:Show();			-- ��(��)��
	PS_ShopMag_TakeBack:Show();				-- ȡ��
	PS_ShopMag_DisposeOf:Show();			-- �̳�
	PS_ShopMag_Curtail:Show();				-- ����
	PS_ShopMag_Continuation:Show();		-- ����
	
	PS_ShopMag_Add:Show();						-- ��Ӻ������
	PS_ShopMag_FriendID:Show();				-- ���ID�����
	PS_ShopMag_Del:Show();						-- ɾ���������
	PS_ShopMag_ViewLog:Show();				-- �鿴����¼
	if( g_CurStallObj == STALL_ITEM ) then
			PS_ShopMag_OpenRecycleShop_Btn:Show();
	else
			PS_ShopMag_OpenRecycleShop_Btn:Hide();
	end
	--PS_ShopMag_OpenRecycleShop_Btn:Show();			--�չ�
	if( g_SaleOuting == 1) then --�����̳�״̬
		PS_ShopMag_DisposeOf:SetText("Tr� l�i");
		--�ûҲ���ʹ�õĹ���						
		PS_ShopMag_SortAmend:Hide();		-- �޸�����
		PS_ShopMag_Open:Hide();         -- ����
		PS_ShopMag_DownStall:Hide();    -- ��(��)��
		PS_ShopMag_TakeBack:Hide();     -- ȡ��
		PS_ShopMag_NameAmend:Hide();    -- �޸ĵ���
		PS_ShopMag_BewriteAmend:Hide(); -- �޸��̵�˵��
		PS_ShopMag_DrawMoney:Hide();    -- ֧ȡ
		PS_ShopMag_AccountBook:Hide();	-- �˱�
		PS_ShopMag_Curtail:Hide();			-- ����
		PS_ShopMag_Continuation:Hide();	-- ����
		
		--����
		local szShopName = PlayerShop:GetShopInfo("self","shopname");
		szShopName = szShopName .. "(�ang chuy�n ra)"
		PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);
		
		--��Ʒ�������϶�
		for i=1 , 20   do
			PS_BUTTON[i]:SetProperty("DraggingEnabled", "False");
		end
		
		PS_ShopMag_OpenRecycleShop_Btn:Hide();	--�չ�
	else
		PS_ShopMag_DisposeOf:SetText("chuy�n ra");
		--�ظ���Ʒ���϶�
		for i=1 , 20   do
			PS_BUTTON[i]:SetProperty("DraggingEnabled", "True");
		end
	end

	-- ����Լ������
	g_SelfPlace = PlayerShop:GetSelfPlace();
	if(g_SelfPlace ~= "boss")   then
		PS_ShopMag_NameAmend:Hide();
		PS_ShopMag_BewriteAmend:Hide();
		PS_ShopMag_SortAmend:Hide();
		PS_ShopMag_DisposeOf:Hide();
		PS_ShopMag_Curtail:Hide();
		PS_ShopMag_Continuation:Hide();
		PS_ShopMag_Add:Hide();
		PS_ShopMag_FriendID:Hide();
		PS_ShopMag_DrawMoney:Hide();
		PS_ShopMag_Del:Hide();
	end

end
--�չ���ť
function PS_ShopMag_OpenRecycleShop_Click()
	local SelfPlace = PlayerShop:GetSelfPlace();
	PlayerShop:OpenRecycleShopDLG(SelfPlace);
end

--===============================================
-- ������Ʒ
--===============================================
function PS_ShopMag_UpdateItem()

	-- ���������б�
	PS_ShopMag_SelectSort:ResetList();
	PS_ShopMag_SelectSort:ComboBoxAddItem("V�t ph�m",0);
	PS_ShopMag_SelectSort:ComboBoxAddItem("B�o th�ch",1);
	PS_ShopMag_SelectSort:ComboBoxAddItem("V� kh�",2);
	PS_ShopMag_SelectSort:ComboBoxAddItem("Gi�p tr�",3);
	PS_ShopMag_SelectSort:ComboBoxAddItem("V�t li�u",4);

	--�̵�����
	local nShopSubType = PlayerShop:GetCurShopType("self");
	PS_ShopMag_SelectSort:SetCurrentSelect(nShopSubType - 1);
	-- ע�⵱ǰ���Ƶ��ǵ�g_nCurStallIndex����̨�ϵ���Ʒ
	g_nCurSelectItem = PlayerShop:GetSelectIndex("self");
	
	for i=1, PS_BUTTON_NUM    do
		local theAction, bLocked = PlayerShop:EnumItem(g_nCurStallIndex -1, i-1, "self");

		if theAction:GetID() ~= 0 then
			PS_BUTTON[i]:SetActionItem(theAction:GetID());
			if g_nCurSelectItem == i   then
				PS_BUTTON[i]:SetPushed(1);
			else
				PS_BUTTON[i]:SetPushed(0);
			end
		else
			PS_BUTTON[i]:SetActionItem(-1);
		end
	end

end

--===============================================
-- ���������б�
--===============================================
function PS_ShopMag_UpdatePet()

	-- ���������б�
	PS_ShopMag_SelectSort:ResetList();
	PS_ShopMag_SelectSort:ComboBoxAddItem("Tr�n Th�",0);

	--�̵�����
	local nShopSubType = PlayerShop:GetCurShopType("self");
	PS_ShopMag_SelectSort:SetCurrentSelect(nShopSubType - 6);
	
	PS_ShopMag_PetList:ClearListBox();
	
	local PetInListIndex = 0
	for i=1,  20  do
		local szPetName,bOnSale,szType = PlayerShop:EnumPet("self",g_nCurStallIndex -1, i-1);
		if (szPetName ~= "")   then
			if(bOnSale ~= 0)  then
				-- ��ɫ��ʾ���ڵ���Ʒ�Ǵ����ϼܵ�״̬
				szPetName = "#c808080" .. szPetName;
			end
			PS_ShopMag_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")", PetInListIndex);
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end
	end
	
end

--===============================================
-- ȡ��
--===============================================
function PS_ShopMag_Retake_Click()
	
	if( g_CurStallObj == STALL_ITEM )    then
		PlayerShop:RetackItem("item");
	else
		--����ǲ��������ޱ�ѡ��
		local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
		
		if(nIndex == -1)  then
			PushDebugMessage("M�i ch�n tr߾c m�t con Tr�n th�")
			return;
		end
		
		PlayerShop:RetackItem("pet");
	end
end

--===============================================
-- �ϼ�(�¼�)
--===============================================
function PS_ShopMag_UpDownStall_Click()

	if( g_CurStallObj == STALL_ITEM )     then
		if(PS_ShopMag_DownStall:GetText() == "L�n gi�")  then
			PlayerShop:InputMoney("ps_upitem");
		else
			PlayerShop:DownSale("item");
		end
		
	elseif( g_CurStallObj == STALL_PET )  then
		
		--����ǲ��������ޱ�ѡ��
		local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
		
		if(nIndex == -1)  then
			return;
		end
		
		if(PS_ShopMag_DownStall:GetText() == "L�n gi�")  then
			PlayerShop:InputMoney("ps_uppet");
		else
			PlayerShop:DownSale("pet");
		end
	end
	
end

--===============================================
-- ��һ��
--===============================================
function PS_ShopMag_Last_Click()
	if(g_nCurStallIndex == 1) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex - 1;
	
	--���������������
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("self",g_nCurStallIndex -1);

end

--===============================================
-- ��һ��
--===============================================
function PS_ShopMag_Next_Click()
	if(g_nCurStallIndex == g_StallNum) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex + 1;
	
	--���������������
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("self",g_nCurStallIndex -1);

end

--===============================================
-- 1 2 3 4 5 6 7 8 9 10
--===============================================
function PS_ShopMag_Page_Click(nIndex)
	g_nCurStallIndex = nIndex;

	--���������������
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("self",g_nCurStallIndex -1);

end

--===============================================
-- ���뱾��
--===============================================
function PS_ShopMag_ImmitCorpus_Click()
	PlayerShop:InputMoney("immitbase");
end

--===============================================
-- ����
--===============================================
function PS_ShopMag_Immit_Click()
	PlayerShop:InputMoney("immit");
end

--===============================================
-- ֧ȡ
--===============================================
function PS_ShopMag_DrawMoney_Click()
	PlayerShop:InputMoney("draw");
end

--===============================================
-- ����(����)           "PS_ShopMag_Open"
--===============================================
function PS_ShopMag_OpenCloseStall_Click()
	if(g_nCurStallIndex ~= -1)  then
		if ( g_bCurStallOpen == 1 )  then
			PlayerShop:OpenStall(g_nCurStallIndex -1, 1);
		else
			PlayerShop:OpenStall(g_nCurStallIndex -1, 0);
		end		
	end
	
end

--===============================================
-- �޸Ĺ������
--===============================================
function PS_ShopMag_ModifyShopAD()

	local szAd = PS_ShopMag_Bewrite:GetText();
	PlayerShop:Modify("ad",szAd);

end

--===============================================
-- �޸��̵�����
--===============================================
function PS_ShopMag_ModifyShopName()

	local szName = PS_ShopMag_MerchantName:GetText();
	PlayerShop:Modify("name",szName);

end

--===============================================
-- �Ҽ�ѡ�����ޣ��鿴���ޣ�
--===============================================
function PS_ShopMag_PetList_RClick()
	local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end
	
	PlayerShop:ViewPetDesc("self",g_PetIndex[nIndex]);
end

--===============================================
-- �̳�(�̻�)
--===============================================
function PS_ShopMag_DisposeOf_Click()
	
	if(g_SaleOuting == 0)   then
		PlayerShop:Transfer("sale");
	else
		PlayerShop:Transfer("info","back",0);
	end
end

--===============================================
-- �Ƿ����̳�״̬�Ľ�����£�1=�̳�״̬��
--===============================================
function PS_ShopMag_Close()
	PlayerShop:CloseShop("self");
end

--===============================================
-- �򿪹ر��˱�
--===============================================
function PS_ShopMag_AccountBook_Clicked()
	PlayerShop:OpenMessage("exchange",0);
end

--===============================================
-- ɾ���������
--===============================================
function PS_ShopMag_Del_Click()

	local nIndex = PS_ShopMag_FriendList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end

	PlayerShop:DealFriend("del", nIndex);
end

--===============================================
-- �鿴����¼
--===============================================
function PS_ShopMag_ViewLog_Click()
	PlayerShop:OpenMessage("manager",0);
end

--===============================================
-- ��Ӻ������
--===============================================
function PS_ShopMag_Add_Click()
	PlayerShop:DealFriend("add", PS_ShopMag_FriendID:GetText());
end

--===============================================
-- ѡ�кϻ���
--===============================================
function PS_ShopMag_FriendList_Selected()
	
end

--===============================================
-- ����
--===============================================
function PS_ShopMag_Curtail_Click()
	PlayerShop:ChangeShopNum("del");
end

--===============================================
-- ����
--===============================================
function PS_ShopMag_Continuation_Click()
	PlayerShop:ChangeShopNum("add");
end

function PS_ShopMag_SelectSort_Selected()
	
	local szName, nIndex = PS_ShopMag_SelectSort:GetCurrentSelect();
	if(nIndex == -1)  then
		return;
	end
	
	if(g_lastIndex ~= nIndex)then
		--�رյ�����
		PlayerShop:CloseChangeTypeMsgBox();
	end
end
--===============================================
-- �޸��̵�����
--===============================================
function PS_ShopMag_SortAmend_Click()
	local szName, nIndex = PS_ShopMag_SelectSort:GetCurrentSelect();
	if(nIndex == -1)then
		PushDebugMessage("C�c h� l�a ch�n v� hi�u, xin ti�p t�c th� l�i");
		return;
	end
	if( g_CurStallObj == STALL_ITEM )     then
		local nShopSubType = PlayerShop:GetCurShopType("self");		
		if(nIndex+1 == nShopSubType)then
			PushDebugMessage("Xin ch�n 1 lo�i h�nh th߽ng ti�m kh�c r�i s�a ch�a!");
			return;
		end
		g_lastIndex = nIndex;
		PlayerShop:ModifySubType("ps_type", nIndex+1);
	else
		PushDebugMessage("Xin ch�n 1 lo�i h�nh th߽ng ti�m kh�c r�i s�a ch�a!");
		return;		
	end	
end

--===============================================
-- OnHiden
--===============================================
function PS_ShopMag_Frame_OnHiden()
	-- ֪ͨ��صĽ���رգ�(PetList,PS_Input,)
	PlayerShop:CloseShopMag();
end

