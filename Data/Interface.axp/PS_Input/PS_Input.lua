
local g_MoneyType=-1;

local PS_IMMITBASE			= 1;
local PS_IMMIT					= 2;
local PS_DRAW						= 3;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Input_PreLoad()
	this:RegisterEvent("PS_INPUT_MONEY");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_SHOP_MAG");
end

--===============================================
-- OnLoad
--===============================================
function PS_Input_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_Input_OnEvent(event)

	if(event == "PS_INPUT_MONEY") then
		--����̵���뱾��
		if (arg0 == "immitbase") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMITBASE;
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("base","self");

			PS_Input_DragTitle:SetText("#gFF0FA0N�p ti�n v�o");
			PS_Input_Accept:SetText("N�p");
			PS_Input_Warning:SetText("N�p s� ti�n nh� nh�t l� 10#-02#rc� s� s� ti�n hi�n t�i l�".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(nBaseMoney));
			PS_Input_Text1:SetText("M�i n�p s� ti�n n�y v�o: ");
			PS_Input_Text2:SetText("S� ti�n hi�n t�i: ");
			
			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			
		--����̵����
		elseif (arg0 == "immit") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMIT;
			PS_Input_DragTitle:SetText("#gFF0FA0 nh�p v�o ti�n l�i nhu�n");
			PS_Input_Accept:SetText("N�p");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("input_profit","self");
			local szCom = PlayerShop:GetCommercialFactor()

			local szInfo = "S� ti�n l�i nhu�n nh�p v�o kh�ng ���c th�p h�n s� v�ng hi�n c�: s� v�ng hi�n c�: 30" .. "#-02" .. "*Ch� s� th߽ng nghi�p*s� qu�y h�ng, ch� s� th߽ng nghi�p tr߾c �� l�".. szCom .. ", c�c h� �t nh�t c�n n�p v�o".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04";
			PS_Input_Warning:SetText(szInfo);
			
			PS_Input_Text1:SetText("Xin nh�p v�o ti�n l�i nhu�n:");
			PS_Input_Text2:SetText("ti�n l�i nhu�n hi�n t�i:");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");

		--����̵�ȡ��
		elseif (arg0 == "draw") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_DRAW;
			PS_Input_DragTitle:SetText("#gFF0FA0R�t ti�n l�i nhu�n");
			PS_Input_Accept:SetText("L�nh");

			PS_Input_Warning:SetText("#{SHOPTIPS_090205_2}");--[tx44221]

			PS_Input_Text1:SetText("Mu�n r�t ti�n l�i nhu�n: ");
			PS_Input_Text2:SetText("ti�n l�i nhu�n hi�n t�i:");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
		end		
		PS_Input_Frame:SetForce();
		PS_Input_Gold:SetText("");
		PS_Input_Silver:SetText("");
		PS_Input_CopperCoin:SetText("");
		
	elseif ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--ȡ������
			this:CareObject(objCared, 0, "PS_Input");
		end	
	
	elseif( event == "PS_CLOSE_SHOP_MAG" )    then
	
		if( this:IsVisible() )   then
			this:Hide();
			--ȡ������
			this:CareObject(objCared, 0, "PS_Input");
		end
		
	end	
	
end

--===============================================
-- Accept
--===============================================
function PS_Input_Accept_Clicked()
	local szGold = PS_Input_Gold:GetText();
	local szSilver = PS_Input_Silver:GetText();
	local szCopperCoin = PS_Input_CopperCoin:GetText();
	
	--�ڳ�����ͷ�ټ�������ַ�����Ч�Ժ���ֵ
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	if(bAvailability == true) then
	
		if( g_nSaveOrGetMoney == PS_IMMITBASE ) then
			--���뱾��
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immitbase",nMoney)
			if( szResult == "ok" )   then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nMoney);
				
			elseif(szResult == "few" )  then
				

			elseif(szResult == "more" )  then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_IMMIT ) then
			--����
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immit",nMoney);
			
			if( szResult == "ok" )   then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nMoney);
			
			elseif(szResult == "few" )  then
				
			
			elseif(szResult == "more" )  then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_DRAW ) then
			--֧ȡ
			PlayerShop:ApplyMoney("draw_ok",nMoney);
			this:Hide();
			--ȡ������
			this:CareObject(objCared, 0, "PS_Input");
			
		end
	end
end

--===============================================
-- Cancel
--===============================================
function PS_Input_Cancel_Clicked()
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "PS_Input");
end


--===============================================
-- OnHiden
--===============================================
function PS_Input_Frame_OnHiden()
	PS_Input_Gold:SetProperty("DefaultEditBox", "False");
	PS_Input_Silver:SetProperty("DefaultEditBox", "False");
	PS_Input_CopperCoin:SetProperty("DefaultEditBox", "False");
end

