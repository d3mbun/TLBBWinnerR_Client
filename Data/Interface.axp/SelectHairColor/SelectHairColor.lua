local nRed=0;
local nGreen=0;
local nBlue=0;
local nAlpha = 255;
local nLumination = 0;
local g_ChangeBy = 0;
local g_Lumination_ChangeBy = 0;
local g_UINT_COLOR = 0;
local ItemID = {20307001, 20307002}; -- zchw
local CostMoney = 50000
local g_Original_Red = 0;
local g_Original_Green = 0;
local g_Original_Blue = 0;
local g_Original_Alpha = 0;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

local g_SelectHairColor_Frame_UnifiedPosition;

function SelectHairColor_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SelectHairColor_OnLoad()
	SelectHairColor_Red:SetProperty( "DocumentSize","1" );
	SelectHairColor_Red:SetProperty( "PageSize","0.1" );
	SelectHairColor_Red:SetProperty( "StepSize","0.1" );
	
	SelectHairColor_Green:SetProperty( "DocumentSize","1" );
	SelectHairColor_Green:SetProperty( "PageSize","0.1" );
	SelectHairColor_Green:SetProperty( "StepSize","0.1" );
	
	SelectHairColor_Blue:SetProperty( "DocumentSize","1" );
	SelectHairColor_Blue:SetProperty( "PageSize","0.1" );
	SelectHairColor_Blue:SetProperty( "StepSize","0.1" );
	
	SelectHairColor_Brightness:SetProperty( "DocumentSize","1" );
	SelectHairColor_Brightness:SetProperty( "PageSize","0.1" );
	SelectHairColor_Brightness:SetProperty( "StepSize","0.1" );
	
	g_SelectHairColor_Frame_UnifiedPosition=SelectHairColor_Frame:GetProperty("UnifiedPosition");
	
end

function SelectHairColor_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 22) then
			
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
				PushDebugMessage("S� li�u truy�n l�i c�a m�y ch� c� v�n �");
				return;
			end

			if(IsWindowShow("SelectHairstyle")) then
				CloseWindow("SelectHairstyle", true);
			end

			if(IsWindowShow("SelectFacestyle")) then
				CloseWindow("SelectFacestyle", true);
			end
			if( this:IsVisible() and tonumber(g_Original_Red) and tonumber(g_Original_Green) and tonumber(g_Original_Blue) and tonumber(g_Original_Alpha) ) then
				DataPool : Change_MyHairColor(g_Original_Red,g_Original_Green,g_Original_Blue,g_Original_Alpha);
			end	
			BeginCareObject_SelectHairColor(objCared)
			SelectHairColor_OnShown();

	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
		
		if(tonumber(arg0) ~= objCared) then 
			Close_HairColor();
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then

			--ȡ������
			SelectHairColor_Cancel_Clicked();
		end			
	end

	if event == "SEX_CHANGED" and  this:IsVisible() then
			SelectHairColor_Model : Hide();
			SelectHairColor_Model : Show();
			SelectHairColor_Model:SetFakeObject("Player_Head");
	end
	
	if (event == "ADJEST_UI_POS" ) then
		SelectHairColor_Frame_On_ResetPos()
	end 
  if (event == "VIEW_RESOLUTION_CHANGED") then
		SelectHairColor_Frame_On_ResetPos()
	end
		
end


function SelectHairColor_OnShown()

	local name,icon = LifeAbility : GetPrescr_Material(ItemID[1]); -- zchw
	g_Original_Red,g_Original_Green,g_Original_Blue,g_Original_Alpha = DataPool : Get_MyHairColor();
	
	if (name == nil) then 
		PushDebugMessage("S� v�t ph�m sai s�t! V�n � t�i nguy�n, ch� cho tr� ho�ch.");
		return;
	end
	
	SelectHairColor_WarningText : SetText("C�n "..name .. ": 1#r C�n ti�u hao: #{_EXCHG"..CostMoney.."}#rM�i th�ng qua ph߽ng ph�p gi� tr� s� ��ng nh�p l�a ch�n m�u t�c, � s�ng c�a m�u kh�ng ���c v��t qu� 126, n�u � s�ng c�a m�u v��t qu� 126, � s�ng s� b� gi�m xu�ng, m�i l�n ti�u hao m�t ch�t m�u t�c, l�a ch�n ch�nh x�c r�i �n n�t \"Duy�t\"");

	nRed = g_Original_Red;
	nGreen = g_Original_Green;
	nBlue = g_Original_Blue;

	SelectHairColor_Update();
	this:Show();
end

function SelectHairColor_Update()

--	AxTrace(0,1,"update="..g_ChangeBy)
	if(g_ChangeBy == 0) then
		g_ChangeBy = 1;
	else
		return;
	end

	SelectHairColor_Red_NumericalValue : SetText(nRed);
	SelectHairColor_Red : SetPosition(nRed/200);
	
	SelectHairColor_Green_NumericalValue : SetText(nGreen);
	SelectHairColor_Green : SetPosition(nGreen/200);

	SelectHairColor_Blue_NumericalValue : SetText(nBlue);
	SelectHairColor_Blue :SetPosition(nBlue/200);

	SelectHairColor_Model : SetFakeObject( "" );
	SelectHairColor_Model : SetFakeObject( "Player_Head" );
--	AxTrace(0,1,"update");
--	AxTrace(0,1,"nRed="..nRed.." nGreen="..nGreen.." nBlue="..nBlue);
	local Lumination = DataPool : Change_MyHairColor(nRed,nGreen,nBlue,nAlpha);
	
	SelectHairColor_Brightness_NumericalValue : SetText(Lumination);
	SelectHairColor_Brightness : SetPosition(Lumination / 240);
	
	g_ChangeBy = 0;
end

--==================================
--ȷ��
--==================================
function SelectHairColor_OK_Clicked()

	local color_r,color_g,color_b,color_a,Ogre_Color = DataPool:Change_RectifyColor(nRed,nGreen,nBlue,nAlpha);
	
	-- ������
	if (DataPool:GetPlayerMission_ItemCountNow(ItemID[1]) < 1) and (DataPool:GetPlayerMission_ItemCountNow(ItemID[2]) < 1) then -- zchw
		PushDebugMessage("Kh�ng �� thu�c nhu�m t�c")
		SelectHairColor_Cancel_Clicked();
		return;
	end

	-- �õ���ҵĽ�Һͽ�����Ŀ
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")
	
	if (nMoney + nMoneyJZ) < 50000 then
		PushDebugMessage("Ng�n l��ng kh�ng ��");
		SelectHairColor_Cancel_Clicked();
		return
	end

	-- �õ�ѡ��ɫ������
	local Luminance = SelectHairColor_Brightness_NumericalValue:GetText()
	if(Luminance ~= nil and tonumber(Luminance) > 126 ) then
		PushDebugMessage("е s�ng m�u t�c kh�ng ���c l�n qu� 126")
		
		-- ������Ϣ
		--PushDebugMessage ("nRed = "..nRed..", nGreen = "..nGreen..", nBlue = "..nBlue)
		--PushDebugMessage ("color_r = "..color_r..", color_g = "..color_g..", color_b = "..color_b)
		return;   	
	end

	-- ������Ϣ
	--PushDebugMessage ("nRed = "..nRed..", nGreen = "..nGreen..", nBlue = "..nBlue)
	--PushDebugMessage ("color_r = "..color_r..", color_g = "..color_g..", color_b = "..color_b)
		
	-- ���ѡ��ķ�ɫ���Ȳ�����126����ʱ��(color_r,color_g,color_b) = (-1,-1,-1)��
	if( tonumber(color_r) < 0 ) then

		-- û�и��ķ�ɫ
		if(nRed == g_Original_Red and nGreen == g_Original_Green and nBlue == g_Original_Blue) then
			PushDebugMessage("Xin ch�n m�t m�u t�c m�i.")
			return;
		end
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(801011);
			Set_XSCRIPT_Parameter(0,Ogre_Color);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_HairColor();

	else

		nRed = color_r;
		nGreen = color_g;
		nBlue = color_b;
		nAlpha = color_a;
		SelectHairColor_Update();
		PushDebugMessage("е s�ng m�u t�c kh�ng ���c l�n qu� 126")
		
	end
	
end

function SelectHairColor_Cancel_Clicked()
	DataPool : Change_MyHairColor(g_Original_Red,g_Original_Green,g_Original_Blue,g_Original_Alpha);
	Close_HairColor();
end

----------------------------------------------------------------------------------
--
-- ��ת����ͷ��ģ�ͣ�����)
--
function Player_Hair_Color_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			SelectHairColor_Model:RotateBegin(-0.3);
		--������ת����
		else
			SelectHairColor_Model:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function Player_Hair_Color_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			SelectHairColor_Model:RotateBegin(0.3);
		--������ת����
		else
			SelectHairColor_Model:RotateEnd();
		end
	end
end

function SelectHairColor_SliderChanged()
	local temp;
	
--	AxTrace(0,1,"slider="..g_ChangeBy)
	if(g_ChangeBy == 0) then
		g_ChangeBy = 2;
	else
		return;
	end
	
	if(g_ChangeBy == 2) then
		temp = SelectHairColor_Red:GetPosition();
		nRed = temp* 200;
		SelectHairColor_Red_NumericalValue : SetText(nRed);
	
		temp = SelectHairColor_Green:GetPosition();
		nGreen = temp * 200;
		SelectHairColor_Green_NumericalValue : SetText(nGreen);
	
		temp = SelectHairColor_Blue:GetPosition();
		nBlue = temp * 200;
		SelectHairColor_Blue_NumericalValue : SetText(nBlue);
--		AxTrace(0,1,"slider");
--		AxTrace(0,1,"nRed="..nRed.." nGreen="..nGreen.." nBlue="..nBlue);
		local Lumination = DataPool : Change_MyHairColor(nRed,nGreen,nBlue,nAlpha);
		
		SelectHairColor_Brightness_NumericalValue : SetText(Lumination);
		SelectHairColor_Brightness : SetPosition(Lumination / 240);

	end
		
	g_ChangeBy = 0;
end

function Color_Change()
	local temp;
	
--	AxTrace(0,1,"text="..g_ChangeBy)
	if(g_ChangeBy == 0) then
		g_ChangeBy = 3;
	else
		return;
	end
	
	if(g_ChangeBy == 3) then
		temp = SelectHairColor_Red_NumericalValue:GetText();
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 200) then
			temp = 200;
		end
		nRed = tonumber(temp);
		SelectHairColor_Red:SetPosition(temp/200);
		
		temp = SelectHairColor_Green_NumericalValue:GetText();
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 200) then
			temp = 200;
		end
		nGreen = tonumber(temp);
		SelectHairColor_Green:SetPosition(temp/200);
		
		temp = SelectHairColor_Blue_NumericalValue:GetText();
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 200) then
			temp = 200;
		end
		nBlue = tonumber(temp);
		SelectHairColor_Blue:SetPosition(temp/200);
--		AxTrace(0,1,"textchange");
--		AxTrace(0,1,"nRed="..nRed.." nGreen="..nGreen.." nBlue="..nBlue);
		local Lumination = DataPool : Change_MyHairColor(nRed,nGreen,nBlue,nAlpha);
		
		SelectHairColor_Brightness_NumericalValue : SetText(Lumination);
		SelectHairColor_Brightness :SetPosition(Lumination / 240);
	end
	
	g_ChangeBy = 0;
end

function Text_Lost()
--	AxTrace(0,1,"text_lost");
--	AxTrace(0,1,"lost="..g_ChangeBy);
	SelectHairColor_Update()
end

function Close_HairColor()

	SelectHairColor_Model : SetFakeObject( "" );
	StopCareObject_SelectHairColor(objCared)
	this:Hide();
		
end


function Lumination_Change()
	local temp;
	
--	AxTrace(0,1,"text="..g_ChangeBy)
	if(g_ChangeBy == 0) then
		g_ChangeBy = 4;
	else
		return;
	end
	
	if(g_ChangeBy == 4) then

		temp = SelectHairColor_Brightness_NumericalValue:GetText();
	
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 240) then
			temp = 240;
		end
		
		SelectHairColor_Brightness_NumericalValue:SetText(temp)
		SelectHairColor_Brightness:SetPosition(temp/240);
				
		local color_r,color_g,color_b,color_a = DataPool:Change_GetColorLumination(nRed,nGreen,nBlue,nAlpha,temp);
		
		color_r,color_g,color_b,color_a,Lumination = Restrict_Color(color_r,color_g,color_b,color_a,Lumination)
		

		nRed = color_r;
		nGreen = color_g;
		nBlue = color_b;
		nAlpha = color_a;
		
		SelectHairColor_Red_NumericalValue : SetText(nRed);
		SelectHairColor_Red : SetPosition(nRed/200);
	
		SelectHairColor_Green_NumericalValue : SetText(nGreen);
		SelectHairColor_Green : SetPosition( nGreen/200);

		SelectHairColor_Blue_NumericalValue : SetText(nBlue);
		SelectHairColor_Blue : SetPosition(nBlue/200);
		
		local Lumination = DataPool : Change_MyHairColor(nRed,nGreen,nBlue,nAlpha);

	end
	
	g_ChangeBy = 0;
	
end

function SelectHairColor_Lumination_Changed()
	local temp;
	
--	AxTrace(0,1,"slider="..g_ChangeBy)
	if(g_ChangeBy == 0) then
		g_ChangeBy = 5;
	else
		return;
	end
	
	if(g_ChangeBy == 5) then
		temp = SelectHairColor_Brightness:GetPosition();
		local Lumination = temp * 240;

		SelectHairColor_Brightness_NumericalValue : SetText(Lumination);
		SelectHairColor_Brightness:SetPosition(Lumination/240);
	
		local color_r,color_g,color_b,color_a = DataPool:Change_GetColorLumination(nRed,nGreen,nBlue,nAlpha,Lumination);
		
		color_r,color_g,color_b,color_a,Lumination = Restrict_Color(color_r,color_g,color_b,color_a,Lumination)
		
	
		nRed = color_r;
		nGreen = color_g;
		nBlue = color_b;
		nAlpha = color_a;
		
		SelectHairColor_Red_NumericalValue : SetText(nRed);
		SelectHairColor_Red : SetPosition(nRed/200);
	
		SelectHairColor_Green_NumericalValue : SetText(nGreen);
		SelectHairColor_Green : SetPosition(nGreen/200);

		SelectHairColor_Blue_NumericalValue : SetText(nBlue);
		SelectHairColor_Blue : SetPosition(nBlue/200);
		
		local Lumination = DataPool : Change_MyHairColor(nRed,nGreen,nBlue,nAlpha);

	end
		
	g_ChangeBy = 0;
	
end



--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_SelectHairColor(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "SelectHairColor");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_SelectHairColor(objCaredId)
	this:CareObject(objCaredId, 0, "SelectHairColor");
	g_Object = -1;

end

function Restrict_Color(Red,Green,Blue,Alpha,Lumination)

	if Red > 200 then
		Red = 200
	end
	if Green > 200 then
		Green = 200
	end
	if Blue > 200 then
		Blue = 200
	end
	Lumination = DataPool : Change_MyHairColor(Red,Green,Blue,Alpha);
	
	return Red,Green,Blue,Alpha,Lumination
end

function SelectHairColor_Frame_On_ResetPos()
  SelectHairColor_Frame:SetProperty("UnifiedPosition", g_SelectHairColor_Frame_UnifiedPosition);
end