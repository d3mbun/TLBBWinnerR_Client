--������Ʒ�����޵Ľ���
local STALL_BUTTONS_NUM = 20;
local STALL_BUTTON = {};

-- ��������ֵ��Ҫ����ͬ������ƷID����Ʒλ�ã�
local g_nCurSelectItemID = -1;
local g_nCurSelectItem = -1;

local g_CurrentPage = -1;
local g_DefaultPage = -1;

local PAGE_ITEM  =0;
local PAGE_PET   =1;

local objCared = -1;
local MAX_OBJ_DISTANCE = 6.0;

local g_nCutSelectPet = -1;

local g_nPetID = {};				--����ID��

--===============================================
-- OnLoad()
--===============================================
function StallBuy_PreLoad()

	this:RegisterEvent("OPEN_STALL_BUY");
	this:RegisterEvent("STALL_BUY_SELECT");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("UPDATE_STALL_BUY");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UPDATE_YUANBAO");
end

function StallBuy_OnLoad()

	STALL_BUTTON[1] 	= StallBuy_Item1;
	STALL_BUTTON[2] 	= StallBuy_Item2;
	STALL_BUTTON[3] 	= StallBuy_Item3;
	STALL_BUTTON[4] 	= StallBuy_Item4;
	STALL_BUTTON[5] 	= StallBuy_Item5;
	STALL_BUTTON[6] 	= StallBuy_Item6;
	STALL_BUTTON[7] 	= StallBuy_Item7;
	STALL_BUTTON[8] 	= StallBuy_Item8;
	STALL_BUTTON[9] 	= StallBuy_Item9;
	STALL_BUTTON[10] 	= StallBuy_Item10;
	STALL_BUTTON[11] 	= StallBuy_Item11;
	STALL_BUTTON[12] 	= StallBuy_Item12;
	STALL_BUTTON[13] 	= StallBuy_Item13;
	STALL_BUTTON[14]	= StallBuy_Item14;
	STALL_BUTTON[15]	= StallBuy_Item15;
	STALL_BUTTON[16]	= StallBuy_Item16;
	STALL_BUTTON[17]	= StallBuy_Item17;
	STALL_BUTTON[18]	= StallBuy_Item18;
	STALL_BUTTON[19]	= StallBuy_Item19;
	STALL_BUTTON[20]	= StallBuy_Item20;
	
	for i=0, 20  do
		g_nPetID[i] = -1;
	end

	--��ʱ�����϶�����
	for i=1 ,STALL_BUTTONS_NUM     do
		STALL_BUTTON[i]:SetProperty("DraggingEnabled","False");
	end

end

--===============================================
-- OnEvent()
--===============================================
function StallBuy_OnEvent(event)

	if(event == "OPEN_STALL_BUY") then
		StallBuy_OnStallBuyOpen()
		
		
	elseif(event == "UPDATE_STALL_BUY") then
		g_nCurSelectItemID = -1;
		g_nCurSelectItem = -1;	
		--StallBuy_Buy:Disable();
		
		--��ձ��
		StallBuy_TargetPrice_Money:SetProperty("MoneyNumber","");
		
		--���Ԫ�����
		StallBuy_TargetPrice_Yuanbao:SetText("#cff99000 #WKNB")
		-- ��д̯��������
		StallBuy_Master_Text:SetText("Ch� qu�n: " .. StallBuy:GetStallerName());
		-- ��д̯����GUID
		StallBuy_ID_Text:SetText("ID:" .. StallBuy:GetGuid());
		
		--����Ҫ��ҳ��
		StallBuy_ChangePage(g_CurrentPage);

		
	elseif(event == "STALL_BUY_SELECT") then
		StallBuy_TargetPrice_Money:SetProperty("MoneyNumber","");

		StallBuy_SelectUpdate();
		
	elseif(event == "OPEN_STALL_SALE") then
		this:Hide();
		--ȡ������
		this:CareObject(objCared, 0, "StallBuy");
	
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			StallBuy:CloseStallMessage();
			this:Hide();
		
			--ȡ������
			this:CareObject(objCared, 0, "StallBuy");
		end
		
	elseif (event == "UNIT_MONEY") then
		StallBuy_modifymoney();
		
	elseif (event == "UPDATE_YUANBAO") then
		local nCoinType = StallBuy:GetStallType()
		if(nCoinType == 1) then
			local nYuanbao = Player:GetData("YUANBAO");
			if(nYuanbao ~= nil) then
				StallBuy_Cash_Yuanbao:SetText("#Y"..nYuanbao.." KNB")
			end
		end
	
	end

end

--===============================================
-- SelectUpdate
--===============================================
function StallBuy_OnStallBuyOpen()
	this:Show();

    --�����԰�
    --StallBuy:OpenMessageBuy()
	StallBuy:OpenMessageFrame()

	--���Ľ��׶���
	objCared = tonumber(arg0);
	this:CareObject(objCared, 1, "StallBuy");
		
	--�����ݳ��л��ȱʡҳ��
	--g_DefaultPage = StallBuy:GetDefaultPage();
	g_DefaultPage = StallBuy_GetDefalutPage();

	g_CurrentPage = g_DefaultPage;

	if(g_CurrentPage == PAGE_ITEM)  then
		StallBuy_Item:SetCheck(1);
		StallBuy_Pet:SetCheck(0);
	else
		StallBuy_Item:SetCheck(0);
		StallBuy_Pet:SetCheck(1);
	end

	g_nCurSelectItemID = -1;
	g_nCurSelectItem = -1;	
	
	--��ձ��
	StallBuy_TargetPrice_Money:SetProperty("MoneyNumber","");
	
	--���Ԫ�����
	StallBuy_TargetPrice_Yuanbao:SetText("#cff99000 #WKNB")
	-- ��д̯��������
	StallBuy_Master_Text:SetText("Ch� qu�n: " .. StallBuy:GetStallerName());
	-- ��д̯����GUID
	StallBuy_ID_Text:SetText("ID:" .. StallBuy:GetGuid());
		
	--����Ҫ��ҳ��
	StallBuy_ChangePage(g_CurrentPage);
	
	
	StallBuy_Cash_Money:Hide();
	StallBuy_Cash_Yuanbao:Hide();
	StallBuy_TargetPrice_Yuanbao:Hide();
	StallBuy_TargetPrice_Money:Hide();
	
	local nCoinType = StallBuy:GetStallType()
	
	-- ����ǽ�Ұ�̯
	if (nCoinType == 0) then
		StallBuy_Cash_Money:Show();
		StallBuy_Cash_Yuanbao:Hide();
		StallBuy_TargetPrice_Money:Show();
		StallBuy_Pet:Show();
		StallBuy_Cash:SetText("#{INTERFACE_XML_761}");

	-- Ԫ����̯
	elseif( nCoinType == 1 ) then
		StallBuy_Cash_Yuanbao:Show();
		StallBuy_Cash_Money:Hide();
		StallBuy_TargetPrice_Yuanbao:Show();
		StallBuy_Pet:Show();
		StallBuy_Cash:SetText("#{YBBT_81021_06}");
	else
		PushDebugMessage("S�p h�ng b� l�i");
	end
end

--===============================================
-- ��ȡĬ�ϵ�ҳ��
--===============================================
function StallBuy_GetDefalutPage()
	
	--local nCoinType = StallBuy:GetStallType()
	
	--if( nCoinType == 1 ) then
	--	return  PAGE_ITEM;
	--end
	
	return StallBuy:GetDefaultPage();
	
end

--===============================================
-- SelectUpdate
--===============================================
function StallBuy_SelectUpdate()
	
	local theAction = EnumAction(arg0+0, "st_other");
	
	g_nCurSelectItemID = theAction:GetID();
	g_nCurSelectItem = 0+arg0;

	for i=1, STALL_BUTTONS_NUM do
		if(i==arg0+1) then
			STALL_BUTTON[i]:SetPushed(1);
			--StallBuy_Buy:Enable();
			
		else
			STALL_BUTTON[i]:SetPushed(0);
		end
	end

	--��ʾ���
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	nMoney = StallBuy:GetPrice("item",arg0+0);
	
	local nCoinType = StallBuy:GetStallType()
	
	-- ����ǽ�Ұ�̯
	if (nCoinType == 0) then
		StallBuy_SetItemOrPetPrice(0, nMoney);
		--StallBuy_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));

	-- Ԫ����̯
	elseif( nCoinType == 1 ) then
		StallBuy_SetItemOrPetPrice(1, nMoney);
		--StallBuy_TargetPrice_Yuanbao:SetText("#Y"..tostring(nMoney).." Ԫ��");
	else
		PushDebugMessage("S�p h�ng b� l�i");
	end
end


--===============================================
-- StallBuy_UpdateFrame
--===============================================
function StallBuy_UpdateFrame()

	StallBuy_ClearSelect();

	--��д�Լ��Ľ�Ǯ��
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;
	
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
	local nYuanbao = Player:GetData("YUANBAO")
	local nCoinType = StallBuy:GetStallType()
	-- ����ǽ�Ұ�̯
	if (nCoinType == 0) then
		StallBuy_Cash_Money:SetProperty("MoneyNumber",tostring(nMoney));
	-- Ԫ����̯
	elseif( nCoinType == 1 ) then
		StallBuy_Cash_Yuanbao:SetText("#Y"..tostring(nYuanbao).." KNB");
	else
		PushDebugMessage("S�p h�ng b� l�i");
	end
	
	StallBuy_Name_Text:SetText("T�n s�p: " .. StallBuy:GetStallName());

	if(g_CurrentPage == PAGE_ITEM)     then 
		StallBuy_UpdateItem();
	elseif (g_CurrentPage == PAGE_PET) then
		StallBuy_UpdatePet();
	end
	
	StallBuy_SetTabColor();

end

--===============================================
-- �������
--===============================================
function StallBuy_Buy_Clicked()

	local nCoinType = StallBuy:GetStallType();
	
	if (nCoinType == 1) then
		local nSelfYuanbao = Player:GetData("YUANBAO");
	
		--local nPriceYuanbao = StallBuy:GetPrice("item", g_nCurSelectItem);
		--local nItemName = StallBuy:GetItemName(g_nCurSelectItemID);
		local nPriceYuanbao = 0;
		local nItemName = "";
	
		if(g_CurrentPage == PAGE_ITEM) then
			nPriceYuanbao = StallBuy:GetPrice("item", g_nCurSelectItem);
			nItemName = StallBuy:GetItemName(g_nCurSelectItemID);
			if( nItemName == nil or nPriceYuanbao == nil) then
				PushDebugMessage("H�y ch�n v�t ph�m");
				return
			end
		else
			local nMyPetName = "";
			if(g_nCutSelectPet == -1)  then
				PushDebugMessage("H�y ch�n Tr�n th� ");
				return;
			end
			nItemName, nMyPetName = StallBuy:EnumPet(g_nCutSelectPet);
			nPriceYuanbao = StallBuy:GetPrice("pet",g_nPetID[g_nCutSelectPet]);
			if( nItemName == nil or nPriceYuanbao == nil) then
				PushDebugMessage("H�y ch�n Tr�n th� ");
				return
			end
		end
		
		if (nPriceYuanbao > nSelfYuanbao) then
			if(g_CurrentPage == PAGE_ITEM) then
				PushDebugMessage("#{YBBT_81021_07}");
			else
				PushDebugMessage("#{YBBT_90211_1}");
			end				
			return
		else
			MessageBoxCommon("#{YBBT_081023_3}", "#{YBBT_081023_4}"..nItemName.."#{YBBT_081023_5}"..nPriceYuanbao.."#{YBBT_081023_6}", "StallBuy", "OnBtnBuyOK()", "OnBtnBuyCancel()");
		end
			
	else
		StallBuy_OnBtnBuyOK()
	end
end

function StallBuy_OnBtnBuyOK()
	if( g_CurrentPage == PAGE_ITEM )  then 
		StallBuy:BuyItem(g_nCurSelectItemID,g_nCurSelectItem);
	else
		if(g_nCutSelectPet == -1)  then
			return;
		end
		StallBuy:BuyPet(g_nPetID[g_nCutSelectPet]);
	end
end

function StallBuy_OnBtnBuyCancel()
end

--===============================================
-- �����̯λ��Ϣ
--===============================================
function StallBuy_Message_Clicked()

	StallBuy:OpenMessageBuy();

end

--===============================================
-- �رհ�ť
--===============================================
function StallBuy_Close_Clicked()
	
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "StallBuy");
	StallBuy:CloseStallMessage();
	CloseMessageBoxCommon();
	CloseInputYuanbao();
	

end

--===============================================
-- ��ʾ��Ʒ
--===============================================
function StallBuy_UpdateItem()
	local nItemNum = GetActionNum("st_other");
	for i=0, STALL_BUTTONS_NUM - 1  do
		local theAction = EnumAction(i, "st_other");
		if theAction:GetID() ~= 0 then
			STALL_BUTTON[i+1]:SetActionItem(theAction:GetID());
		else
			STALL_BUTTON[i+1]:SetActionItem(-1);
		end
	end
end

--===============================================
-- ��ʾ����
--===============================================
function StallBuy_UpdatePet()
	StallBuy_PetList:ClearListBox();
	
	local nPetNum = StallBuy:GetPetNum();
	local nIndex =0;
	for i=1 ,STALL_BUTTONS_NUM  do
		local szPetName, szType = StallBuy:EnumPet(i-1);
		if(szPetName ~= "")    then
			StallBuy_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")" , nIndex);
			g_nPetID[nIndex] = i-1;
			nIndex = nIndex + 1;
		end
	end
end

--===============================================
-- ��ҳ
--===============================================
function StallBuy_ChangeTabIndex(nIndex)
	if( nIndex == 1 )    then 
		StallBuy_ChangePage(PAGE_ITEM)
	else
		StallBuy_ChangePage(PAGE_PET)
	end
end


--===============================================
-- ��ҳˢ��
--===============================================
function StallBuy_ChangePage(nPage)
	g_CurrentPage = nPage;
	if(g_CurrentPage == PAGE_ITEM) then
		StallBuy_PetList:Hide();
		StallBuy_Item_Set:Show();
		for i=1, STALL_BUTTONS_NUM   do
			STALL_BUTTON[i]:Show();
		end
		StallBuy_ViewPets:Hide();
	else
		StallBuy_Item_Set:Hide();
		StallBuy_PetList:Show();
		for i=1, STALL_BUTTONS_NUM   do
			STALL_BUTTON[i]:Hide();
		end
		StallBuy_ViewPets:Show();
	end

	StallBuy_UpdateFrame();
end


--===============================================
-- ��������б�
--===============================================
function StallBuy_PetList_Selected()

	g_nCutSelectPet = StallBuy_PetList:GetFirstSelectItem();
	
	--StallBuy_Buy:Enable();
	
	--��������Ʒ�ļ۸�
	if (g_nCutSelectPet == -1)   then
		return;
	end
	nMoney = StallBuy:GetPrice("pet",g_nPetID[g_nCutSelectPet]);
		
	-- ����ǽ�Ұ�̯
	local nCoinType = StallBuy:GetStallType()
	if (nCoinType == 0) then
		StallBuy_SetItemOrPetPrice(0, nMoney);
		--StallBuy_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));
	-- Ԫ����̯
	elseif( nCoinType == 1 ) then
		StallBuy_SetItemOrPetPrice(1, nMoney);
		--StallBuy_TargetPrice_Yuanbao:SetText("#Y"..tostring(nMoney).." Ԫ��");
	else
		PushDebugMessage("S�p h�ng b� l�i");
	end
end

--===============================================
-- �Ҽ����
--===============================================
function StallBuy_PetList_RClick()
	g_nCutSelectPet = StallBuy_PetList:GetFirstSelectItem();
	
	if(g_nCutSelectPet == -1)  then
		PushDebugMessage("H�y ch�n m�t con Tr�n Th� sau �� nh�n ki�m tra")
		return;
	end
	
	--��ʾ����
	StallSale:ViewPetDesc("other", g_nPetID[g_nCutSelectPet]);
end

--===============================================
-- ��ʾTab���������ɫ
--===============================================
function StallBuy_SetTabColor()
	
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	
	local newColor = "#e010101#c888888"

	if( PAGE_ITEM == g_CurrentPage ) then
		StallBuy_Item:SetText(selColor .. "V�t ph�m");
		StallBuy_Pet:SetText(noselColor .. "Th�");
		
		-- ����һҳ�����û�ж�����������Ϊ��ɫ
		-- Tab�ϵ�������ɫ
		local nObjNum = StallBuy:IsHaveObject("pet")
		if nObjNum == 0    then
			StallBuy_Pet:SetText(newColor .. "Th�");
		end
	
	else
		StallBuy_Item:SetText(noselColor .. "V�t ph�m");
		StallBuy_Pet:SetText(selColor .. "Th�");
		
		local nItemNum = StallBuy:IsHaveObject("item")
		if nItemNum == 0    then
			StallBuy_Item:SetText(newColor .. "V�t ph�m");
		end
	end

end

--===============================================
-- �ָ�ѡ��״̬�����ѡ�У�
--===============================================
function StallBuy_ClearSelect()
	g_nCutSelectPet = -1;
	g_nCurSelectItemID = -1;
	g_nCurSelectItem = -1;
end


--===============================================
-- �����ҵĽ�Ǯ�ı�
--===============================================
function StallBuy_modifymoney()
	--������ҵĽ�Ǯ
	--��д�Լ��Ľ�Ǯ��
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;
	
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
	StallBuy_Cash_Money:SetProperty("MoneyNumber",tostring(nMoney));
end


function StallBuy_SetItemOrPetPrice(nCoinType, nMoney)
	
	local nMoneyEnd = 0;
	local nMoneyBegin = 0
	local nMoneyMid = 0;
	local strMoney = "";
	
	-- ����ǽ�Ұ�̯
	if (nCoinType == 0) then
		StallBuy_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));
			-- Ԫ����̯
	elseif( nCoinType == 1 ) then
		if (nMoney <100 ) then
			strMoney = string.format("#cff9900%s", nMoney);
		elseif (nMoney < 10000) then
			nMoneyEnd = nMoney - math.floor(nMoney/100)*100;
			nMoneyMid = math.floor(nMoney/100) - math.floor((math.floor(nMoney/100))/100)*100;
			local strEnd = "00";
			if (nMoneyEnd < 10) then
				strEnd = string.format("0%d", nMoneyEnd);
			else
				strEnd = tostring(nMoneyEnd);
			end
			strMoney = string.format("#W%d#cff9900%s", nMoneyMid, strEnd);
		else
			nMoneyEnd = nMoney - math.floor(nMoney/100)*100;
			nMoneyMid = math.floor(nMoney/100) - math.floor((math.floor(nMoney/100))/100)*100;
			nMoneyBegin = math.floor(nMoney/10000);
			local strEnd = "00";
			if (nMoneyEnd < 10) then
				strEnd = string.format("0%d", nMoneyEnd);
			else
				strEnd = tostring(nMoneyEnd);
			end
			local strMid = "00";
			if (nMoneyMid < 10) then
				strMid = string.format("0%d", nMoneyMid);
			else
				strMid = tostring(nMoneyMid);
			end
			strMoney = string.format("#Y%d#W%s#cff9900%s", nMoneyBegin, strMid, strEnd);
		end
		StallBuy_TargetPrice_Yuanbao:SetText("#Y"..strMoney.." #WKNB");
	else
		PushDebugMessage("S�p h�ng b� l�i");
	end
end