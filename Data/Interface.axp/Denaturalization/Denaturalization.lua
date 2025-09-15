local xx = nil;
function Denaturalization_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("UNIT_DEF_COLD");				--��������
	this:RegisterEvent("UNIT_DEF_FIRE");
	this:RegisterEvent("UNIT_DEF_LIGHT");
	this:RegisterEvent("UNIT_DEF_POSION");

	this:RegisterEvent("UNIT_RESISTOTHER_COLD");			--��������
	this:RegisterEvent("UNIT_RESISTOTHER_FIRE");
	this:RegisterEvent("UNIT_RESISTOTHER_LIGHT");
	this:RegisterEvent("UNIT_RESISTOTHER_POSION");
		
	this:RegisterEvent("UNIT_ATT_COLD");				--��������
	this:RegisterEvent("UNIT_ATT_FIRE");
	this:RegisterEvent("UNIT_ATT_LIGHT");
	this:RegisterEvent("UNIT_ATT_POSION");
end

function Denaturalization_OnLoad()
	Denaturalization_CleanData();
end

function Denaturalization_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if(tonumber(arg0) == 0147000) then
			Denaturalization_OnShow();
			this : Show();
			xx =  Get_XParam_INT(0)
			objCared = DataPool : GetNPCIDByServerID(xx);
			this:CareObject(objCared, 1, "Denaturalization");
			
		elseif (tonumber(arg0) == 0147005) then
			DoDenaturalization()
		end
		
	elseif(event == "UNIT_DEF_COLD" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_DEF_FIRE" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_DEF_LIGHT" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_DEF_POSION" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_COLD" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_FIRE" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_LIGHT" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_POSION" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	--������
	elseif(event == "UNIT_ATT_COLD" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
	--�𹥻�
	elseif(event == "UNIT_ATT_FIRE" and arg0 == "player") then
		Denaturalization_SetStateTooltip();
	--�繥��
	elseif(event == "UNIT_ATT_LIGHT" and arg0 == "player") then
		Denaturalization_SetStateTooltip();
	--������
	elseif(event == "UNIT_ATT_POSION" and arg0 == "player") then
		Denaturalization_SetStateTooltip();
		
	end
end

---------------------------------------------------------------------------------
--
-- ����״̬tooltip
--
function Denaturalization_SetStateTooltip()

	-- �õ�״̬����
	local iIceDefine  		= Player:GetData( "DEFENCECOLD" );
	local iFireDefine 		= Player:GetData( "DEFENCEFIRE" );
	local iThunderDefine	= Player:GetData( "DEFENCELIGHT" );
	local iPoisonDefine		= Player:GetData( "DEFENCEPOISON" );
	
	--����ʾ������ add by hukai#48117
	if iIceDefine < 0 then
		iIceDefine = 0
	end
	if iFireDefine < 0 then
		iFireDefine = 0
	end
	if iThunderDefine < 0 then
		iThunderDefine = 0
	end
	if iPoisonDefine < 0 then
		iPoisonDefine = 0
	end
	
	local iIceAttack  		= Player:GetData( "ATTACKCOLD" );
	local iFireAttack 		= Player:GetData( "ATTACKFIRE" );
	local iThunderAttack	= Player:GetData( "ATTACKLIGHT" );
	local iPoisonAttack		= Player:GetData( "ATTACKPOISON" );
	
	local iIceResistOther	= Player:GetData( "RESISTOTHERCOLD" );
	local iFireResistOther= Player:GetData( "RESISTOTHERFIRE" );
	local iThunderResistOther	= Player:GetData( "RESISTOTHERLIGHT" );
	local iPoisonResistOther= Player:GetData( "RESISTOTHERPOISON" );
	
	Denaturalization_IceFastness:SetToolTip("B�ng c�ng:"..tostring(iIceAttack).."#rKh�ng B�ng:"..tostring(iIceDefine).."#rGi�m kh�ng B�ng:"..tostring(iIceResistOther) );
	Denaturalization_FireFastness:SetToolTip("H�a c�ng:"..tostring(iFireAttack).."#rKh�ng H�a:"..tostring(iFireDefine).."#rGi�m kh�ng H�a:"..tostring(iFireResistOther) );
	Denaturalization_ThunderFastness:SetToolTip("Huy�n c�ng:"..tostring(iThunderAttack).."#rKh�ng Huy�n:"..tostring(iThunderDefine).."#rGi�m kh�ng Huy�n:"..tostring(iThunderResistOther) );
	Denaturalization_PoisonFastness:SetToolTip("еc c�ng:"..tostring(iPoisonAttack).."#rKh�ng еc:"..tostring(iPoisonDefine).."#rGi�m kh�ng еc:"..tostring(iPoisonResistOther) );
		
end

---------------------------------------------------------------------------------
--�������
--
function Denaturalization_CleanData()
	Denaturalization_FakeObject:SetFakeObject("");	

	Denaturalization_IceFastness:SetToolTip("");
	Denaturalization_FireFastness:SetToolTip("" );
	Denaturalization_ThunderFastness:SetToolTip("");
	Denaturalization_PoisonFastness:SetToolTip("");
end

---------------------------------------------------------------------------------
--OnShow
--
function Denaturalization_OnShow()
	Player : CreateDenaObj();
	Denaturalization_FakeObject:SetFakeObject("Denaturalization_MySelf");	
	
	Denaturalization_SetStateTooltip();

	local nNumber = Player:GetData( "LEVEL" );
	Denaturalization_Level : SetText(nNumber.." c�p")
end

----------------------------------------------------------------------------------
--
-- ѡװ���ģ�ͣ�����)
--
function Denaturalization_Modle_TurnLeft(start)
	--������ת��ʼ
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Denaturalization_FakeObject:RotateBegin(-0.3);
	--������ת����
	else
		Denaturalization_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- ѡװ���ģ�ͣ�����)
--
function Denaturalization_Modle_TurnRight(start)
	--������ת��ʼ
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Denaturalization_FakeObject:RotateBegin(0.3);
	--������ת����
	else
		Denaturalization_FakeObject:RotateEnd();
	end
end

function Denaturalization_Cancel_Click()
	this : Hide();
end

function DoDenaturalization()
	if(this : IsVisible()) then
		PushDebugMessage("Thao t�c d� th߶ng !");
		this:Hide();
		return;
	end
	

	local isCan = Player : CheckIfCanDena(30900048);
	if(isCan == -1) then
		PushDebugMessage("Thao t�c d� th߶ng !");
		return;
	end
	
	--����ȷ�Ͽ�
	
	
	if(isCan == 5)then
		PushDebugMessage("B�ng h�u thi�u s�t v�t ph�m Chuy�n T�nh �an, ho�c l� Chuy�n T�nh �an c�a b�ng h�u �� kh�a.")
		return;
	end
	if(isCan == 1)then
		PushDebugMessage("Trong tr�ng th�i c��i kh�ng th� th�c hi�n ���c thao t�c Chuy�n T�nh !")
		return;
	end
	if(isCan == 2)then
		PushDebugMessage("Trong tr�ng th�i b�y b�n kh�ng th� th�c hi�n ���c thao t�c Chuy�n T�nh !")
		return;
	end
	if(isCan == 3)then
		PushDebugMessage("Trong tr�ng th�i th� c��i, th� m�c kh�ng th� th�c hi�n ���c thao t�c Chuy�n T�nh !")
		return;
	end

	if(isCan == 4)then
		PushDebugMessage("Trong tr�ng th�i t� �i kh�ng th� th�c hi�n ���c thao t�c Chuy�n T�nh !")
		return;
	end
	--ȡ�ñ�������
	local sex,hairColor,hairModle,faceModle,nFaceId = Player : GetDenaAttr();
	--������ȥҲ
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnZhuanXingConfirm");
		Set_XSCRIPT_ScriptID(0147);
		Set_XSCRIPT_Parameter(0,tonumber(xx));
		Set_XSCRIPT_Parameter(1,tonumber(sex));
		Set_XSCRIPT_Parameter(2,tonumber(hairColor));
		Set_XSCRIPT_Parameter(3,tonumber(hairModle));
		Set_XSCRIPT_Parameter(4,tonumber(faceModle));
		Set_XSCRIPT_Parameter(5,tonumber(nFaceId));
		Set_XSCRIPT_ParamCount(6);
	Send_XSCRIPT();
end

function Denaturalization_OK_Click()
	--����ȷ�Ͻ���
	Clear_XSCRIPT();
		Set_XSCRIPT_ScriptID(0147);
		Set_XSCRIPT_Function_Name("OnZhuanXingRequest");
		Set_XSCRIPT_Parameter(0,tonumber(xx));
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	--�����������
	Player : SaveDenaAttr();
	this:Hide();
end

function Denaturalization_OnHide()
	Denaturalization_CleanData();
end