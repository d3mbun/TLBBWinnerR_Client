
local g_Selectindex = -1;
local g_nShopIndex = {};
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local OpenType =0; --0:ÉÌµêÁÐ±í 1:ÊÕ¹ºÉÌµêÁÐ±í
local g_LastSelect_NormalShop =""
local g_LastSelect_RecycleShop =""
--===============================================
-- OnLoad
--===============================================
function PS_ShopList_PreLoad()
	this:RegisterEvent("PS_OPEN_SHOPLIST");						-- ´ò¿ªËùÓÐÉÌµêµÄÁÐ±í
	this:RegisterEvent("PS_UPDATE_SEARCH_SHOPLIST");	-- ´ò¿ª·ÖÀàÕÐÕÐºóµÄÁÐ±í
	this:RegisterEvent("PS_OPEN_RECYCLESHOPLIST");	-- ´ò¿ª·ÖÀàÕÐÕÐºóµÄÁÐ±í
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
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Shoplist");
		end	
	elseif(event == "PS_UPDATE_SEARCH_RECYCLESHOPLIST")then
		OpenType = 1;
		g_Selectindex = -1;
		PS_ShopList_Search_UpdateFrame();
	end

end

--===============================================
-- UpdateFrame()   ÒÑ¾­Ã»ÓÐÊ¹ÓÃÕâ¸öº¯ÊýÁË
--===============================================
function PS_ShopList_UpdateFrame()
	
	--ÉÌÒµÖ¸Êý
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("Chï s¯ thß½ng nghi®p; " .. szTemp);
	
	PS_ShopList_ShopList:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("all");
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		--	    Ãû×Ö,     ×ÜÊýÁ¿, ¿ªÕÅÊý, ÀàÐÍ
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
-- ÏÔÊ¾·ÖÀà²éÑ¯½á¹û
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
		PS_ShopList_Button_Accept:SetProperty("Text", "Mua bán");
		ListCtr = PS_ShopList_ShopList;
		PS_ShopList_Find:Show();
		PS_ShopList_Button_Remove:Show();
		PS_ShopList_Button_Manage:Show();
	else
		PS_ShopList_Check_Item2:SetCheck(0);
		PS_ShopList_Check_Item:SetCheck(1);
		PS_ShopList_RecycleShopList:Show();
		PS_ShopList_ShopList:Hide();
		PS_ShopList_Button_Accept:SetProperty("Text", "Ðem bán");
		ListCtr = PS_ShopList_RecycleShopList;
		PS_ShopList_Find:Hide();
		PS_ShopList_Button_Manage:Show();
		PS_ShopList_Button_Remove:Hide();
	end


	

	PS_ShopList_DragTitle:SetText("#gFF0FA0CØa hàng thß½ng hµi");

	local szType = PlayerShop:GetShopListType();
	if(szType == "panchu" and OpenType==0)  then
		PS_ShopList_Find:Hide()
		PS_ShopList_Check_Item:Hide();
		PS_ShopList_Check_Item2:Hide();
		PS_ShopList_Button_Remove:Hide();
		PS_ShopList_Button_Manage:Hide();
		PS_ShopList_Button_Accept:SetText("Xem");
		PS_ShopList_DragTitle:SetText("#gFF0FA0 tiêu chu¦n ðßa ra cØa hàng");

	end


	--Çå¿ÕËµÃ÷ÄÚÈÝ
	PS_ShopList_Since:SetText("");				-- ¿ªµêÊ±¼ä
	PS_ShopList_ShopOwner:SetText("");		-- µêÖ÷Ãû×Ö
	PS_ShopList_ShopOwnerID:SetText("");	-- µêÖ÷ID
	PS_ShopList_ShopInfo:SetText("");			-- ½éÉÜ

	g_Selectindex = -1;

	--ÉÌÒµÖ¸Êý
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("Chï s¯ thß½ng nghi®p: " .. szTemp);
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
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Shoplist");

end

--===============================================
-- Accept
--===============================================
function PS_ShopListAccept_Clicked(szType)
	--È¥´ò¿ªÑ¡ÖÐµÄÁÐ±í
	if( g_Selectindex >= 0 )      then
		if OpenType ==1 then
			--ÊÕ¹ºÉÌµê,¹ºÎï
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
		PushDebugMessage("M¶i ch÷n cØa hàng");
		return;
	end
	
--	this:Hide();
	--È¡Ïû¹ØÐÄ
--	this:CareObject(objCared, 0, "PS_Shoplist");
	
end

--===============================================
-- µã»÷ÁÐ±í
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
	
	--¸üÐÂÏÔÊ¾µÄÐÅÏ¢
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
	
	--¸üÐÂÏÔÊ¾µÄÐÅÏ¢
	UpdateShopInfo()
	
end

--===============================================
-- ¸üÐÂÉÌµêµÄÐÅÏ¢
--===============================================
function UpdateShopInfo()

	if g_Selectindex == -1    then
		return;
	end
	
	--¸üÐÂÐÅÏ¢
	-- ¿ªµêÊ±¼ä
	local szSince = PlayerShop:EnumShopInfo("since",g_nShopIndex[g_Selectindex]);
	PS_ShopList_Since:SetText("Th¶i gian tÕo: ".. szSince);
	
	-- µêÖ÷Ãû×Ö --¸ÄÎª³¬Á´½Ó by wangdw
	local szName = PlayerShop:EnumShopInfo("ownername",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwner:SetChatString("#YChü ti®m: #{_INFOUSR".. szName .. "}");
	
	-- µêÖ÷ID
	local szID = PlayerShop:EnumShopInfo("ownerid",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwnerID:SetText("ID:".. szID);
	
	-- ½éÉÜ
	local szInfo = "";
	if(OpenType == 0)then
		 szInfo = PlayerShop:EnumShopInfo("desc",g_nShopIndex[g_Selectindex]);
	else
		 szInfo = PlayerShop:EnumShopInfo("recdesc",g_nShopIndex[g_Selectindex]);
	end
		
	PS_ShopList_ShopInfo:SetText(szInfo);
	
	-- ¼ÓÈë/È¥³ý Ãûµê
	if( g_Selectindex == -1 )   then 
		return;
	end
	local szShopName,OpenNum,SaleNum,szType,nIsFavor = PlayerShop:EnumShop(g_nShopIndex[g_Selectindex]);
	if(nIsFavor == 1)   then
		PS_ShopList_Button_Remove:SetText("Bö tên ti®m");
	else
		PS_ShopList_Button_Remove:SetText("#{INTERFACE_XML_353}");
	end
	
end


--===============================================
-- Close
--===============================================
function PS_CreateShopClose_Clicked()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Shoplist");
end

--===============================================
-- ²éÕÒ
--===============================================
function PS_ShopList_Find_Clicked()
	PlayerShop:OpenFindShop();
end

--===============================================
-- ¼ÓÈë/È¥³ý Ãûµê
--===============================================
function PS_ShopList_Favor_Clicked()
	local selectIndex = PS_ShopList_ShopList:GetSelectItem();
	if(selectIndex < 0)     then
		return;
	end
	PlayerShop:AddFavor(g_nShopIndex[selectIndex]);
	
	local totalCount = PS_ShopList_ShopList:GetItemCount();
	
	--¼ÓÈëÃûµêºó£¬×Ô¶¯Ñ¡ÖÐÏÂÒ»¸öµê£¬Èç¹ûÒÑ¾­ÊÇ×îºóÒ»¸öµêÁË£¬ÔòÑ¡ÖÐÇ°Ò»¸ö£¬Èç¹ûÖ»ÓÐÒ»¸öµê£¬ÔòÑ¡ÖÐ×Ô¼º
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
