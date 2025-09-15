local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Exchange_Rate = 1;
local g_Point = 0;
local g_Object = -1;
local g_YuanbaoExchange_Frame_UnifiedPosition;

function YuanbaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function YuanbaoExchange_OnLoad()
	g_YuanbaoExchange_Frame_UnifiedPosition=YuanbaoExchange_Frame:GetProperty("UnifiedPosition");
	local str0 = "#YQu� T�ng B�o Th�ch khi quy �i Nguy�n B�o"
	local str1 = "#GL�n 1#W: Khi quy �i s� nguy�n b�o t� #G400 #Wtr� l�n s� nh�n ���c vi�n #GH�ng B�o Th�ch C�p 3#W."
	local str2 = "#GL�n 2#W: Khi quy �i s� nguy�n b�o t� #G1666 #Wtr� l�n s� nh�n ���c #GPhi�u бi B�o Th�ch C�p 4#W."
	local str3 = "#GL�n 3#W: Khi quy �i s� nguy�n b�o t� #G1666 #Wtr� l�n s� nh�n ���c #GPhi�u бi B�o Th�ch C�p 4#W."
	local str_note0 = "--------------------"
	local str_note = "L�u �: Khi quy �i, vui l�ng � tay n�i c� 2 � tr�ng trong t�i ��o c� v� t�i nguy�n li�u!"
	
	
	-- YuanbaoExchange_Text4:SetText(str0.."#r"..str1.."#r"..str2.."#r"..str3.."#r"..str_note)
end

function YuanbaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2001 ) then
			if this:IsVisible() then
				YuanbaoExchange_Close();
				return
			end
			g_Object = Get_XParam_INT(0);
			BeginCareObject_YuanbaoExchange(Target:GetServerId2ClientId(g_Object));
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			YuanbaoExchange_OnShown();
			this:Show();
			YuanbaoExchange_Count_Change();
			YuanbaoExchange_Max:Disable()
			YuanbaoExchange_OK : Disable()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2003 ) then
		if(this:IsVisible()) then
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			g_Point = Get_XParam_INT(0);
			YuanbaoExchange_Text1 : SetText("S� B�C t�n: "..(g_Point/1000))
			YuanbaoExchange_Max:Enable()
			YuanbaoExchange_OK:Enable()
			YuanbaoExchange_Moral_Value:Enable();
		end
	elseif ( event == "OBJECT_CARED_EVENT") then
		YuanbaoExchange_CareEventHandle(arg0,arg1,arg2);
	
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		YuanbaoExchange_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YuanbaoExchange_Frame_On_ResetPos()
	end

end

function YuanbaoExchange_OnShown()
	YuanbaoExchange_Clear();
	YuanbaoExchange_Update();
end

function YuanbaoExchange_Clear()
	YuanbaoExchange_Text1 : SetText("")
	YuanbaoExchange_Moral_Value : SetText("")
	YuanbaoExchange_Text3 : SetText("")
	g_Point = 0;
	Exchange_Rate = 1;
end

function YuanbaoExchange_Update()
	Exchange_Rate = Get_XParam_INT(1)/1000
	
	YuanbaoExchange_Text1 : SetText("#cff0000#bS� �i�m d� �ang ���c tra, xin ��i...")
	YuanbaoExchange_Text3 : SetText("S� �i�m Nguy�n B�o nh�n ���c:  0")
	
end

function YuanbaoExchange_OK_Clicked()
	local str = YuanbaoExchange_Moral_Value : GetText();
	
	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 1 "..tostring(str));

	if str == nil or str == "" then
		YuanbaoExchange_Text3 : SetText("S� �i�m Nguy�n B�o nh�n ���c:  0")
		PushDebugMessage("M�i �i�n v�o gi� tr� ng�n l��ng c�c h� �i")
		return
	end
	
	if tonumber(str) > 2000000 then
		PushDebugMessage("M�i l�n �i gi� tr� ng�n l��ng l�n nh�t l� 25.000, m�i �i�n v�o ch� s� nh� h�n ho�c b�ng 2.000.000!")
		return
	end
	if( tonumber(str) <= 0 ) then
		PushDebugMessage("S� l��ng nguy�n b�o m�i l�n �i �t nh�t l� 1 �i�m, xin vui l�ng nh�p con s� l�n h�n ho�c b�ng 1")
		return
	end
	
	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 2");
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("BuyYuanbao");
		Set_XSCRIPT_ScriptID(181000);
		Set_XSCRIPT_Parameter(0,tonumber(str));
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
	
	YuanbaoExchange_Close();
end

function YuanbaoExchange_Close()
	YuanbaoExchange_OnHiden();
	this:Hide()
end

function YuanbaoExchange_Cancel_Clicked()
	YuanbaoExchange_Close();
	return;
end

function YuanbaoExchange_OnHiden()
	StopCareObject_YuanbaoExchange(objCared)
	YuanbaoExchange_Clear()
	return
end

function YuanbaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			YuanbaoExchange_Close();
		end
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_YuanbaoExchange(objCaredId)

	g_Object = objCaredId;
	--AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "YuanbaoExchange");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_YuanbaoExchange(objCaredId)
	this:CareObject(objCaredId, 0, "YuanbaoExchange");
	g_Object = -1;

end

function YuanbaoExchange_Count_Change()
	local str = YuanbaoExchange_Moral_Value : GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	YuanbaoExchange_Moral_Value:SetTextOriginal( str );
	YuanbaoExchange_Text3 : SetText("S� �i�m Nguy�n B�o nh�n ���c: "..tostring( 1000*Exchange_Rate * strNumber ) )
end

function YuanbaoExchange_Max_Clicked()
	local maxYuanBao = 25000;
	local point2YuanBao = math.floor(g_Point/(Exchange_Rate*1000));
	if point2YuanBao < 0 then point2YuanBao = 0; end
	
	YuanbaoExchange_Moral_Value:SetProperty("ClearOffset", "True");
	if point2YuanBao > maxYuanBao then
		YuanbaoExchange_Moral_Value:SetText(tostring(maxYuanBao));
	else
		YuanbaoExchange_Moral_Value:SetText(tostring(point2YuanBao));
	end
	YuanbaoExchange_Moral_Value:SetProperty("CaratIndex", 1024);
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function YuanbaoExchange_Frame_On_ResetPos()
  YuanbaoExchange_Frame:SetProperty("UnifiedPosition", g_YuanbaoExchange_Frame_UnifiedPosition);
end