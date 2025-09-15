local RecycleItems = {};
local g_nCurSelectItem =-1;
local RECYCLEITEM_NUM =20;
local Type = -1;
local HaveNum = 0;
local TotalNum = 20;
function RecycleShop_PreLoad()
	this:RegisterEvent("OPEN_RECYCLESHOP_SELF");
	this:RegisterEvent("OPEN_RECYCLESHOP_PARTNER");
	this:RegisterEvent("OPEN_RECYCLESHOP_BUYER");
	this:RegisterEvent("UI_COMMAND");
end

function RecycleShop_OnLoad()
	RecycleItems[1] = RecycleShop_Item1;
	RecycleItems[2] = RecycleShop_Item2;
	RecycleItems[3] = RecycleShop_Item3;
	RecycleItems[4] = RecycleShop_Item4;
	RecycleItems[5] = RecycleShop_Item5;
	RecycleItems[6] = RecycleShop_Item6;
	RecycleItems[7] = RecycleShop_Item7;
	RecycleItems[8] = RecycleShop_Item8;
	RecycleItems[9] = RecycleShop_Item9;
	RecycleItems[10] = RecycleShop_Item10;
	RecycleItems[11] = RecycleShop_Item11;
	RecycleItems[12] = RecycleShop_Item12;
	RecycleItems[13] = RecycleShop_Item13;
	RecycleItems[14] = RecycleShop_Item14;
	RecycleItems[15] = RecycleShop_Item15;
	RecycleItems[16] = RecycleShop_Item16;
	RecycleItems[17] = RecycleShop_Item17;
	RecycleItems[18] = RecycleShop_Item18;
	RecycleItems[19] = RecycleShop_Item19;
	RecycleItems[20] = RecycleShop_Item20;
end
local objCared = -1;
function RecycleShop_OnEvent(event)
	if ( event == "OPEN_RECYCLESHOP_SELF" )   then
		objCared = DataPool : GetNPCIDByServerID(tonumber(arg0));
		if objCared == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
			return;
		end
		this:CareObject(objCared, 1, "RecycleShop");
		Type = 1;
		RecycleShop_InitDLG(1)
		RecycleShop_UpdateDLG(1);
		this:Show();
	end
	if(event == "OPEN_RECYCLESHOP_PARTNER" )   then
		objCared = DataPool : GetNPCIDByServerID(tonumber(arg0));
		if objCared == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
			return;
		end
		this:CareObject(objCared, 1, "RecycleShop");
		Type = 2;
		RecycleShop_InitDLG(2)
		RecycleShop_UpdateDLG(2);
		this:Show();
	end
	if(event == "OPEN_RECYCLESHOP_BUYER" )   then
		objCared = DataPool : GetNPCIDByServerID(tonumber(arg0));
		if objCared == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
			return;
		end
		this:CareObject(objCared, 1, "RecycleShop");
		Type = 3;
		RecycleShop_InitDLG(3)
		RecycleShop_UpdateDLG(3);
		this:Show();
	end
	if( event == "UI_COMMAND" )    then
	    if( tonumber(arg0) == 19810222 ) then
    	    this:Hide();
		
		    --ȡ������
		    this:CareObject(objCared, 0, "PS_ShopMag");
    	end
	 	
	end
end

function RecycleShop_InitDLG(idx)
	g_nCurSelectItem = -1;
	RecycleShop_Exit:Show();
	RecycleShop_Name_Text8:SetText("");
	RecycleShop_TargetItem_Money:SetProperty("MoneyNumber", tostring(0));
	RecycleShop_TargetItem_Name:SetText("");
	RecycleShop_Name_Text9:SetText("");
	RecycleShop_Name_Text:SetText("");
	--RecycleShop_Name_Text7:SetText("");
	RecycleShop_Name_Text11:SetText("");
	local shopName = PlayerShop:GetRecycleShopName(idx);
	if idx==1 or idx==2 then
		for i =1 ,TotalNum do
			RecycleItems[i]:SetProperty("DragAcceptName", "");
		end
		RecycleShop_Sell:Hide();
		RecycleShop_AddNewItem:Show();
		RecycleShop_GetItem:Show();
		RecycleShop_ReSetAD:Show();
		RecycleShop_CancelItem:Show();
		RecycleShop_DragTitle:SetText("#gFF0FA0Ta c�n thu mua nguy�n li�u");
	else
		for i =1 ,TotalNum do
			RecycleItems[i]:SetProperty("DragAcceptName", "X"..tostring(i-1));
		end
		RecycleShop_Sell:Show();
		RecycleShop_AddNewItem:Hide();
		RecycleShop_GetItem:Hide();
		RecycleShop_ReSetAD:Hide();
		RecycleShop_CancelItem:Hide();
		RecycleShop_DragTitle:SetText("#gFF0FA0"..shopName);	
	end
end

function RecycleShop_UpdateDLG(idx)
	HaveNum = 0;
	--������
	local shopName = PlayerShop:GetRecycleShopName(idx);
	RecycleShop_Name_Text:SetText("T�n ti�m: ".. shopName);

	--����ID
	local shopIndex = PlayerShop:GetRecycleShopIndex(idx)
	if (tonumber(shopIndex) <= 0) then
		RecycleShop_DPID_Text:SetText("ID c�a ti�m:")
	else
		RecycleShop_DPID_Text:SetText("ID c�a ti�m:" .. shopIndex)
	end

	--����	--��Ϊ������ by wangdw
	local szName = PlayerShop:GetRecycleShopOwnerName(idx);
	RecycleShop_Master_Text:SetChatString("#YCh� ti�m: #{_INFOUSR".. szName .."}");
	
	--����ID
	local szID = PlayerShop:GetRecycleShopOwnerID(idx);
	RecycleShop_ID_Text:SetText("ID ch� ti�m: "..szID);
	for i=1, RECYCLEITEM_NUM    do
		RecycleItems[i]:SetProperty("DraggingEnabled","False");
	end
	local Count = 0;
	for i=1, RECYCLEITEM_NUM    do
		local theAction, bLocked = PlayerShop:EnumRecycleItemAction(i-1, idx);
		if theAction:GetID() ~= 0 then
			HaveNum = HaveNum + 1;
			RecycleItems[i]:SetActionItem(theAction:GetID());
			if g_nCurSelectItem == i   then
				RecycleItems[i]:SetPushed(1);
			else
				RecycleItems[i]:SetPushed(0);
			end
			--�����϶�����
			
			local needToGet =  PlayerShop:GetRecycleItem(i-1,idx,"needtoget");
			local needToRec =  PlayerShop:GetRecycleItem(i-1,idx,"needtorecycle");
			if(idx == 1 or idx == 2)then
				if(needToRec == 0 and needToGet>0)then
					--RecycleItems[i]:SetProperty("DraggingEnabled","True");
					Count = Count+1;				
				end
			else
				if(needToRec<=0)then
					RecycleItems[i]:SetActionItem(-1);
				end
			end
		else
			RecycleItems[i]:SetActionItem(-1);
		end
	end
	if(Count>0)then
		RecycleShop_Name_Text9:SetText("�� thu mua th�nh c�ng"..Count.."Lo�i nguy�n li�u");
	end
end

--�����չ�
function RecycleShop_AddNewItem_Click()
	if(Type<=0 or Type >3) then
		return
	end
	if(HaveNum>=TotalNum)then
		PushDebugMessage("Kh�ng th� th�m m�i, c� th� kh�ng gian thu mua �� �y.")
		return
	end
	PlayerShop:OpenSelectRecycleItemDLG(Type);
end

--ȡ�ز���()
function RecycleShop_GetItem_Click()
	if g_nCurSelectItem<=0 or g_nCurSelectItem>RECYCLEITEM_NUM then 
		return ;
	end
	if Type <=0 then
		return;
	end
	local needToGet =  PlayerShop:GetRecycleItem(g_nCurSelectItem-1,Type,"needtoget");
	local needToRec =  PlayerShop:GetRecycleItem(g_nCurSelectItem-1,Type,"needtorecycle");
	if(needToGet == 0)then
		PushDebugMessage("Nguy�n li�u m� c�c h� thu mua v�n ch�a thu mua xong!")
		return
	end
	PlayerShop:SendTakeRecItemMsg(Type,g_nCurSelectItem-1);
end

--ȡ���չ�
function RecycleShop_CancelItem_Click()
	if g_nCurSelectItem<=0 or g_nCurSelectItem>RECYCLEITEM_NUM then 
		return ;
	end
	if Type <=0 then
		return;
	end
	local needToGet =  PlayerShop:GetRecycleItem(g_nCurSelectItem-1,Type,"needtoget");
	if(needToGet > 0)then
		PushDebugMessage("Trong thu mua nguy�n li�u, kh�ng th� h�y b�, xin h�y l�y v� b� ph�n �� thu mua r�i h�y ti�n h�nh thao t�c")
		return
	end
	PlayerShop:CancelRecItem(Type,g_nCurSelectItem-1);
end

--���ù��
function RecycleShop_ReSetAD_Click()
	if Type <=0 or Type>2 then
		return;
	end
	PlayerShop:OpenADDlg(Type);
end

function RecycleShop_Item_Click(idx)
	g_nCurSelectItem = idx;

	--RecycleShop_Name_Text7:SetText("");
	RecycleShop_Name_Text8:SetText("");
	RecycleShop_TargetItem_Money:SetProperty("MoneyNumber", tostring(0));
	RecycleShop_TargetItem_Name:SetText("");
	RecycleShop_Name_Text11:SetText("");

	local theAction, bLocked = PlayerShop:EnumRecycleItemAction(idx-1, Type);
	if theAction:GetID() ~= 0 then
		--name
		local name = PlayerShop:GetRecycleItem(idx-1,Type,"name");
		RecycleShop_TargetItem_Name:SetText(name);
		--�չ���
		local price = PlayerShop:GetRecycleItem(idx-1,Type,"price");
		RecycleShop_TargetItem_Money:SetProperty("MoneyNumber", tostring(price));
		--����
		local numToget = PlayerShop:GetRecycleItem(idx-1,Type,"needtoget");
		RecycleShop_Name_Text8:SetText(numToget);
		local numTorec = PlayerShop:GetRecycleItem(idx-1,Type,"needtorecycle");
		RecycleShop_Name_Text11:SetText(numTorec);
	end
	for i=1,RECYCLEITEM_NUM do
		if(i == idx)then
			RecycleItems[i]:SetPushed(1);
		else
			RecycleItems[i]:SetPushed(0);
		end
	end

	

end

function RecycleShop_ExitClick()
	this:Hide();
end

--����
function RecycleShop_Sell_Click()
	PlayerShop:RecycleShop_EnterSell();
end

function RecycleShop_Close()
	SetDefaultMouse();
	PlayerShop:CloseRecycleShop();
end
