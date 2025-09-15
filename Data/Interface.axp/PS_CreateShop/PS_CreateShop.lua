
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


--===============================================
-- OnLoad
--===============================================
function PS_CreateShop_PreLoad()
	this:RegisterEvent("PS_OPEN_CREATESHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_CREATESHOP");
	
end

function PS_CreateShop_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_CreateShop_OnEvent(event)
	if ( event == "PS_OPEN_CREATESHOP" ) then
		this:Show();
		-- objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_CreateShop");

		PS_CreateShop_InputShopName:SetProperty("DefaultEditBox", "True");
		
		--ÉÌÒµÖ¸Êý
		local szCommercialFactor = PlayerShop:GetCommercialFactor();
		PS_CreateShop_TradeIndex:SetText("Chï s¯ thß½ng nghi®p: " .. szCommercialFactor);

		--µ±Ç°ÄÜ¿ªµÄµê
		local nType = PlayerShop:GetCanOpenShopType();
		
		if(nType == 1)     then
			--Ö»ÄÜ¿ªÎïÆ·µê
			PS_CreateShop_Text3:Show();
			PS_CreateShop_Text4:Hide();
			PS_CreateShop_Prop:Show();
			PS_CreateShop_Pet:Hide();
			PS_CreateShop_Prop:SetCheck(1);
			
		elseif(nType == 2) then
			--Ö»ÄÜ¿ª³èÎïµê
			PS_CreateShop_Text3:Hide();
			PS_CreateShop_Text4:Show();
			PS_CreateShop_Prop:Hide();
			PS_CreateShop_Pet:Show();
			PS_CreateShop_Pet:SetCheck(1);
			
		elseif(nType == 3) then
			--Á½ÖÖµê¶¼ÄÜ¿ª
			PS_CreateShop_Text3:Show();
			PS_CreateShop_Text4:Show();
			PS_CreateShop_Prop:Show();
			PS_CreateShop_Pet:Show();
			PS_CreateShop_Prop:SetCheck(1);
			PS_CreateShop_Pet:SetCheck(0);
		end

		PS_CreateShop_Demand_Text:SetText("#cff0000Khai trß½ng ti®m m¾i c¥n mµt t§p bí quyªt chß·ng qu¥y#r#cFFF263Chï s¯ thß½ng nghi®p hi®n nay là".. szCommercialFactor .."Nªu m· 1 cØa hàng thì c¥n nhæng khoän phí nhß sau.");
		
		local nOpenNeedMoney = PlayerShop:GetMoney("open","self");
		PS_CreateShop_DemandMoney:SetProperty("MoneyNumber", tostring(nOpenNeedMoney));
	
		PS_CreateShop_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

		PS_CreateShop_InputShopName:SetText("");

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_CreateShop");
		end
		
	elseif ( event == "PS_CLOSE_CREATESHOP" )   then
		this:Hide();
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "PS_CreateShop");
		
	end

end

--===============================================
-- Refuse
--===============================================
function PS_CreateShopRefuse_Clicked()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_CreateShop");

end

--===============================================
-- Accept
--===============================================
function PS_CreateShopAccept_Clicked()

	local szName = PS_CreateShop_InputShopName:GetText();
	local bItem = PS_CreateShop_Prop:GetCheck();
	local bPet  = PS_CreateShop_Pet:GetCheck();

	local temp;
	if  ( bItem == 1 )  then
		temp = 1;
	else
		temp = 2;
	end

	if  (bItem == bPet)  then
		temp = 0 ;
	end

	PlayerShop:CreateShop(szName,temp);
	
end

--===============================================
-- OnHiden
--===============================================
function PS_CreateShop_OnHiden()
		PS_CreateShop_InputShopName:SetProperty("DefaultEditBox", "False");
	
end