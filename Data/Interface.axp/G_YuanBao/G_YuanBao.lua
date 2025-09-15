local g_Shouxu = 2000;
local g_limit = 10*10000;
function G_YuanBao_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
end
	
function G_YuanBao_OnLoad()
end

-- OnEvent
function G_YuanBao_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if(tonumber(arg0) == 19850424 and 4 == Get_XParam_INT(1)) then
		--���۽��
			local money = Player:GetData("MONEY");
			money = tonumber(money);
			if(g_limit + g_Shouxu > money) then
				PushDebugMessage("S� v�ng tr�n ng߶i c�c h� nh� h�n #{_MONEY102000}, ch� khi c� s� l��ng ti�n l�n h�n ho�c b�ng #{_MONEY102000} m�i c� th� g�i b�n.")
				this:Hide();
				return;
			end
			 xx =  Get_XParam_INT(0)
			objCared = DataPool : GetNPCIDByServerID(xx);
			G_YuanBao_Shown();
			this:Show();
			this:CareObject(objCared, 1, "CommisionStall");
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--ȡ������
			StopCareObject_Carriage(objCared);
		end
	elseif(event == "OPEN_EXCHANGE_FRAME") then
		this:Hide();
	end
	
end

function G_YuanBao_Shown()
	G_YuanBao_Type1:SetCheck(1);
	G_YuanBao_Type2:SetCheck(-1);
	G_YuanBao_Type3:SetCheck(-1);
	G_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True");
	G_YuanBao_InputYuanBao:SetText("0");
	G_YuanBao_InputYuanBao:SetSelected( 0, -1 );
end

function G_YuanBao_OK_Click()
	local nCoin =0; 
	local g_grad = 0;
	if(tonumber(G_YuanBao_Type1 : GetCheck()) == 1) then
		g_grad = 3;
		nCoin = 10*10000;
	elseif(tonumber(G_YuanBao_Type2 : GetCheck()) == 1)then
		g_grad = 4;
		nCoin = 50*10000;
	elseif(tonumber(G_YuanBao_Type3 : GetCheck()) == 1) then
		g_grad = 5;
		nCoin = 150*10000;
	end
	local nCount = G_YuanBao_InputYuanBao:GetText();
	local nMoney = Player:GetData("MONEY");	
	if(nCoin==0) then
		PushDebugMessage("Xin ch�n lo�i kim phi�u g�i b�n!")
		return;
	end
	if(nCount == nil or tonumber(nCount)== nil or tonumber(nCount)<= 0)then
		PushDebugMessage("S� l��ng nguy�n b�o v� hi�u!")
		return
	end
	if( nMoney < nCoin + nCoin*2/100) then
		local tmpnum = nCoin + nCoin*2/100
		PushDebugMessage("Ti�n tr�n ng߶i c�c h� kh�ng �� #{_MONEY"..tmpnum.."}, vui l�ng ch�n l�i!")
		return
	end
	--�ж�ok ��������ȥҲ
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Sell");
		Set_XSCRIPT_ScriptID(800116);
		Set_XSCRIPT_Parameter(0,tonumber(xx));
		Set_XSCRIPT_Parameter(1,tonumber(g_grad));
		Set_XSCRIPT_Parameter(2,tonumber(nCount));
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	this:Hide();
end

function G_YuanBao_CheckIfOK()
	nNum = tonumber(G_YuanBao_InputYuanBao : GetText());
	if(nNum == nil)then
		nNum = 0;
	end
	nNum = tostring(nNum);
	if(nNum ~=G_YuanBao_InputYuanBao : GetText())then
		G_YuanBao_InputYuanBao:SetText(nNum);
	end
end