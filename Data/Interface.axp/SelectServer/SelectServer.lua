-------------------------------------------------------------------------------------------------------------
--
-- ȫ�ֱ���
--
local g_LastServer = -1;
local g_LastArea   = -1;
local g_LastServerName = "";
local CriticalSpeed1 =250
local CriticalSpeed2 =500
local CriticalSpeed3 =1000

local CriticalSpeed =200; 
local CurPage = 0
local NetSpeed ={"#e010101T�c �: #c4CFA4CT�t","#e010101T�c �: #c4CFA4CB�n r�n","#e010101T�c �: Ch�a bi�t", "#e010101T�c � m�ng: #cff0000T�c ngh�n" }
local PageSize = 12

-- ����ť�ĸ���
local LOGIN_SERVER_AREA_COUNT = 4;
--Ŀǰ��Ч������ť���������ڽ���Ķ�̫�����Ժ������ַ��ڣ��������������Ҫ�ǲ���ȥ����ҳ���롣
local EFFECT_LOGIN_SERVER_AREA_COUNT = 12; 
-- ��������ť�ĸ���
local LOGIN_SERVER_TESTAREA_COUNT = 4;
-- ����ť
local g_BnArea = {};

-- ��������ť
local g_BntestArea = {};

-- ��ǰѡ�������
local g_iCurSelArea = 0;
-- login server �ͻ�������
local g_AreaIndex ={};
-- login server ����
local g_AreaName = {};
-- login server ����
local g_AreaDis = {};
-- testlogin server �ͻ�������
local g_testAreaIndex ={};
-- login server ����
local g_testAreaName = {};
-- login server ����
local g_testAreaDis = {};
-- ��ǰѡ�����������
local g_iCurSelAreaName;

--����tips
local g_AreaTip = {};
local g_testAreaTip = {};

-- ѡ������������
local g_iNetProvide = 0;					-- 0 : ����
								-- 1 : ��ͨ
								-- 2 : ����
								-- 3��Ĭ��


--����Ĭ����������̡�
local default_iNetProvide	=	1;

local g_idBackSound = -1;

-- ѡ�����	tongxi ,ע�͵�
--local g_UseProxy = 0;
-- �����Ƽ��������ĸ���
local indexForCommendable = 1;
------------------------------------------------------------------------------
--
-- login server ��Ϣ
--

-- login server �ĸ���
--local LOGIN_SERVER_COUNT = 55;    -- modify by zchw 45-->55
local LOGIN_SERVER_COUNT = 15;    

local COMMENDABLE_LOGIN_SERVER_COUNT = 9;

-- login server ��ť
local g_BnLoginServer = {};
-- login server ״̬
local g_LoginServerStatus = {};
-- login server ����
local g_LoginServerName = {};
-- login server �Ƽ��ȼ�
local g_LoginServerCommendableLevel = {};
-- login server �Ƿ��¿�
local g_LoginServerIsNew = {};



-- �Ƽ���������ť
local g_CommendableBnLoginServer = {};
-- �Ƽ�����������
local g_CommendableLoginServerName = {};
-- �Ƽ�������Index
local g_CommendableLoginServerServerIndex = {};
-- �Ƽ�����������Index
local g_CommendableLoginServerAreaIndex = {};
-- �Ƽ��������Ƽ��ȼ�
local g_CommendableLoginServerCommendableLevel = {};
-- �Ƽ��������Ƿ��·�
local g_CommendableLoginServerIsNew = {};
-- �Ƽ������� ״̬
local g_CommendableLoginServerStatus = {};



-------------------------------------------------------------------------------
--
-- ������Ϣ
--

-- ��ǰѡ���login server
local g_iCurSelLoginServer = -1;
-- ��ǰѡ����Ƽ�login server index
local g_iCurComSelLoginServer = -1;

-- ����ĸ���
local g_iCurAreaCount = 0;
--�����������
local g_iCurTestAreaCount = 0;

local g_FirstLogin = 1;


local StatMax = 10;

-------------------------------------------------------------------------------------------------------------
--
-- ������.
--
--

-- ע��onLoad�¼�
function LoginSelectServer_PreLoad()
	-- ��ѡ�����������
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_SERVER");

	-- ѡ������
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_SERVER");

	-- ��ѡ�����������
	this:RegisterEvent("GAMELOGIN_SELECT_AREA");

	-- ѡ��login
	this:RegisterEvent("GAMELOGIN_SELECT_LOGINSERVER");

	-- ѡ���Ƿ�ʹ�ô���
	this:RegisterEvent("GAMELOGIN_SELECT_USEPROXY");

	-- ע��ѡ��һ��login server�¼�
	this:RegisterEvent("GAMELOGIN_SELECT_LOGIN_SERVER");

	-- ��ҽ��볡��
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	--ping���
	this:RegisterEvent("PING_RESAULT");
	--�ϴε�¼�ķ�����
	this:RegisterEvent("GAMELOGIN_LASTSELECT_AREA_AND_SERVER");
	
end

function LoginSelectServer_OnLoad()
	
	-- �õ�����ť
	g_BnArea[1] = SelectServer_Subarea1;
	g_BnArea[2] = SelectServer_Subarea2;
	g_BnArea[3] = SelectServer_Subarea3;
	g_BnArea[4] = SelectServer_Subarea4;
	-- g_BnArea[5] = SelectServer_Subarea5;
	-- g_BnArea[6] = SelectServer_Subarea6;
	-- g_BnArea[7] = SelectServer_Subarea7;
	-- g_BnArea[8] = SelectServer_Subarea8;
	-- g_BnArea[9] = SelectServer_Subarea9;
	-- g_BnArea[10] = SelectServer_Subarea10;
	-- g_BnArea[11] = SelectServer_Subarea11;
	-- g_BnArea[12] = SelectServer_Subarea12;

	-- g_BnArea[13] = SelectServer_Subarea13;
	-- g_BnArea[14] = SelectServer_Subarea14;
	-- g_BnArea[15] = SelectServer_Subarea15;
	-- g_BnArea[16] = SelectServer_Subarea16;
	-- g_BnArea[17] = SelectServer_Subarea17;
	-- g_BnArea[18] = SelectServer_Subarea18;
	-- g_BnArea[19] = SelectServer_Subarea19;
	-- g_BnArea[20] = SelectServer_Subarea20;
	-- g_BnArea[21] = SelectServer_Subarea21;
	-- g_BnArea[22] = SelectServer_Subarea22;
	-- g_BnArea[23] = SelectServer_Subarea23;
	-- g_BnArea[24] = SelectServer_Subarea24;
	
	g_BntestArea[1] = SelectServer2_Subarea1;
	g_BntestArea[2] = SelectServer2_Subarea2;
	g_BntestArea[3] = SelectServer2_Subarea3;
	g_BntestArea[4] = SelectServer2_Subarea4;
	--g_BntestArea[5] = SelectServer2_Subarea5;
	--�õ��Ƽ��������б�
	g_CommendableBnLoginServer[1] = SelectServer_Commendable_Subarea1;
	g_CommendableBnLoginServer[2] = SelectServer_Commendable_Subarea2;
	g_CommendableBnLoginServer[3] = SelectServer_Commendable_Subarea3;
	g_CommendableBnLoginServer[4] = SelectServer_Commendable_Subarea4;
	g_CommendableBnLoginServer[5] = SelectServer_Commendable_Subarea5;
	g_CommendableBnLoginServer[6] = SelectServer_Commendable_Subarea6;
	g_CommendableBnLoginServer[7] = SelectServer_Commendable_Subarea7;
	g_CommendableBnLoginServer[8] = SelectServer_Commendable_Subarea8;
	g_CommendableBnLoginServer[9] = SelectServer_Commendable_Subarea9;	

	
	local i;
	for i = 1, LOGIN_SERVER_AREA_COUNT do
		
	 	g_BnArea[i]:SetProperty("CheckMode", "1");
		
		g_AreaName[i] = "";
		g_AreaDis[i] = "";
		g_AreaTip[i] = "";
		g_testAreaTip[i] = "";
	end
	
	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
	 	-- Login server ��ť
		
	 	g_CommendableBnLoginServer[i]:SetProperty("CheckMode", "1");
		-- login server ����
		g_CommendableLoginServerName[i] = "";
		--login server index
		g_CommendableLoginServerIndex[i]=-1;
	end
	-- �õ���������ť
	g_BnLoginServer[1] = SelectServer_Server1;
	g_BnLoginServer[2] = SelectServer_Server2;
	g_BnLoginServer[3] = SelectServer_Server3;
	g_BnLoginServer[4] = SelectServer_Server4;
	g_BnLoginServer[5] = SelectServer_Server5;
	g_BnLoginServer[6] = SelectServer_Server6;
	g_BnLoginServer[7] = SelectServer_Server7;
	g_BnLoginServer[8] = SelectServer_Server8;
	g_BnLoginServer[9] = SelectServer_Server9;
	g_BnLoginServer[10] = SelectServer_Server10;

	g_BnLoginServer[11] = SelectServer_Server11;
	g_BnLoginServer[12] = SelectServer_Server12;
	g_BnLoginServer[13] = SelectServer_Server13;
	g_BnLoginServer[14] = SelectServer_Server14;
	g_BnLoginServer[15] = SelectServer_Server15;
	g_BnLoginServer[16] = SelectServer_Server16;
	g_BnLoginServer[17] = SelectServer_Server17;
	g_BnLoginServer[18] = SelectServer_Server18;
	g_BnLoginServer[19] = SelectServer_Server19;
	g_BnLoginServer[20] = SelectServer_Server20;
	--
	g_BnLoginServer[21] = SelectServer_Server21;
	g_BnLoginServer[22] = SelectServer_Server22;
	g_BnLoginServer[23] = SelectServer_Server23;
	g_BnLoginServer[24] = SelectServer_Server24;
	g_BnLoginServer[25] = SelectServer_Server25;
	g_BnLoginServer[26] = SelectServer_Server26;
	g_BnLoginServer[27] = SelectServer_Server27;
	g_BnLoginServer[28] = SelectServer_Server28;
	g_BnLoginServer[29] = SelectServer_Server29;
	g_BnLoginServer[30] = SelectServer_Server30;
	g_BnLoginServer[31] = SelectServer_Server31;
	g_BnLoginServer[32] = SelectServer_Server32;
	g_BnLoginServer[33] = SelectServer_Server33;
	g_BnLoginServer[34] = SelectServer_Server34;
	g_BnLoginServer[35] = SelectServer_Server35;
  --
	g_BnLoginServer[36] = SelectServer_Server36;
	g_BnLoginServer[37] = SelectServer_Server37;
	g_BnLoginServer[38] = SelectServer_Server38;
	g_BnLoginServer[39] = SelectServer_Server39;
	g_BnLoginServer[40] = SelectServer_Server40;
	g_BnLoginServer[41] = SelectServer_Server41;
	g_BnLoginServer[42] = SelectServer_Server42;
	g_BnLoginServer[43] = SelectServer_Server43;
	g_BnLoginServer[44] = SelectServer_Server44;
	g_BnLoginServer[45] = SelectServer_Server45;
	--
	---- add by zchw
	--g_BnLoginServer[46] = SelectServer_Server46;
	--g_BnLoginServer[47] = SelectServer_Server47;
	--g_BnLoginServer[48] = SelectServer_Server48;
	--g_BnLoginServer[49] = SelectServer_Server49;
	--g_BnLoginServer[50] = SelectServer_Server50;
	--g_BnLoginServer[51] = SelectServer_Server51;
	--g_BnLoginServer[52] = SelectServer_Server52;
	--g_BnLoginServer[53] = SelectServer_Server53;
	--g_BnLoginServer[54] = SelectServer_Server54;
	--g_BnLoginServer[55] = SelectServer_Server55;
	
		
	for i = 1, LOGIN_SERVER_COUNT do
	 	-- Login server ��ť
	 	g_BnLoginServer[i]:SetProperty("CheckMode", "1");

		-- login server ״̬
		g_LoginServerStatus[i] = 0;

		-- login server ����
		g_LoginServerName[i] = "";
		
		g_LoginServerCommendableLevel[i]="";
	end
	-- ���������Ƽ�������
	HideAllCommendableBn();	
	-- �õ���������Ϣ
	LoginSelectServer_GetServerInfo();

	-- �õ��Ƽ��ķ�����

	-- �����ṩ��
	SelectServer_Line1:SetProperty("CheckMode", "1");
	SelectServer_Line2:SetProperty("CheckMode", "1");
	SelectServer_Line3:SetProperty("CheckMode", "1");
	SelectServer_Line4:SetProperty("CheckMode", "1");

	-- ��������̰�ť.
	SelectServer_Line1:SetText("�i�n t�n");
	SelectServer_Line2:SetText("M�ng internet");
	SelectServer_Line3:SetText("M�ng gi�o d�c");

	--ͯϲ ���Ĭ�ϰ�ť
	SelectServer_Line4:SetText("M�c �nh");

	local strNormalColor = "#cFFF263";
	SelectServer_Help_Text1:SetText(	strNormalColor.."#e010101#cff0000��: Хy#cffffff" );
	SelectServer_Help_Text2:SetText(	strNormalColor.."#e010101#cECE58DNh�t: T�t#cffffff" );
	SelectServer_Help_Text3:SetText(	strNormalColor.."#e010101#c959595X�m: B�o d��ng#cffffff" );
	SelectServer_Help_Text4:SetText(	strNormalColor.."#e010101#cff8a00Da cam: S�p �y#cffffff" );
	SelectServer_Help_Text5:SetText(	strNormalColor.."#e010101#c4CFA4CXanh l�: C�c t�t#cffffff" );


	-- �򿪽���
	SelectServer_Frame:SetProperty("AlwaysOnTop", "True");

	-- ���������а�ť��
	HideAreaBn();
	-- ���������а�ť��
	HideTestAreaBn();


end

function HideAllCommendableBn()
	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
		g_CommendableBnLoginServer[i]:Hide();
	end;
end
--�Ƿ��Զ���ѡ��ķ�������ű��0����ֹ.txt�ļ��д�ı䶯
local autoZero = 0;
-- OnEvent
function LoginSelectServer_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_SELECT_SERVER" ) then

		this:Show();

		-- ��ʾ���ڵ�����ť��
		ShowAreaBn();
		ShowTestAreaBn();
		--��ʾ���·�ҳ
		UpdateUpAddDownButton();

		-- ���ű�������
		if(g_idBackSound == -1) then
			g_idBackSound = Sound:PlaySound(113, true);
		end
		
		--if( 1 == g_FirstLogin ) then
           -- GameProduceLogin:ShowMessageBox( "    Ŀǰֻ������һ̨��ͨ���������ڲ��ԣ�������ǵ��ŵ��û������ڷ�����ѡ�������ұ�ѡ�񡰵��š����е�¼����������ʹ�û�����ͨ�����Ա�֤���������ٶȡ�", "OK", "1" );
		    --g_FirstLogin = 0
		--end
		
		return;
	end


	-- �رս���
	if( event == "GAMELOGIN_CLOSE_SELECT_SERVER") then

		this:Hide();
		return;
	end

	-- ѡ��һ��login server
	if( event == "GAMELOGIN_SELECT_LOGIN_SERVER") then
		local num = tonumber(arg0);
		for aindex = 1,g_iCurAreaCount do 
			if(num == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				SelectServer_SelectLoginServer(tonumber(arg1),1);
			return;
			end	
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(num == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				SelectServer_SelectLoginServer(tonumber(arg1),1);
				return;
			end
		end
		return;
	end

	-- ѡ������
	if( event == "GAMELOGIN_SELECT_AREA") then
		autoZero = 0;

		local num = tonumber(arg0);
		for aindex = 1,g_iCurAreaCount do 
			if(num == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				return;
			end	
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(num == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				return;
			end
		end
		--��ȫû���ҵ���˵���ļ����˴�ı仯
		CurPage = 0;
		autoZero = 1;
		SelectServer_SelectAreaServer(1 - CurPage*PageSize -1);
		return;
	end;

	-- ѡ��login
	if( event == "GAMELOGIN_SELECT_LOGINSERVER") then
		if ( g_BnLoginServer[tonumber(arg0)+1]:GetProperty("Disabled")=="False") then
			if(autoZero == 0 )then
				SelectServer_SelectLoginServer(tonumber(arg0),0);	
			else
				SelectServer_SelectLoginServer(0,0);	
				autoZero = 0;
			end	
		end;
		return;
	end;

	-- ʹ�ô���
	--ͯϲ
	if( event == "GAMELOGIN_SELECT_USEPROXY" ) then
		if tonumber(arg0) == 1 then
			--SelectServer_Deputize:SetCheck(1)
			SelectServer_SelectLine2();
		elseif tonumber(arg0) == 0 then
			--SelectServer_Deputize:SetCheck(0)
			SelectServer_SelectLine1();
		elseif tonumber(arg0) == 2 then
			SelectServer_SelectLine3();
		else
			SelectServer_SelectLine4();
		end
	
		return;
	end;
	
	-- ���볡����ֹͣ��������
	if( event == "PLAYER_ENTERING_WORLD") then
		if(g_idBackSound ~= -1) then
			Sound:StopSound(g_idBackSound);
			g_idBackSound = -1;
		end
	end
	--ping���
	if(event == "PING_RESAULT")then
		local num = tonumber(arg0)
		if(num ~=nil)then
			if(num>=0)then
				if(num<=CriticalSpeed)then
					SelectServer_Text2:SetText(NetSpeed[1]);
				elseif( num<=CriticalSpeed2 ) then
				    SelectServer_Text2:SetText(NetSpeed[2]);
				elseif( num<=CriticalSpeed3 ) then
				    SelectServer_Text2:SetText(NetSpeed[4]);
				else
				    SelectServer_Text2:SetText(NetSpeed[3]);
				--else
				--	SelectServer_Text2:SetText(NetSpeed[2]);
				end
				SelectServer_Text2:SetToolTip("K�o d�i th�i gian m�ng: "..num);
			else
				SelectServer_Text2:SetText(NetSpeed[3]);			
				SelectServer_Text2:SetToolTip("K�o d�i th�i gian m�ng: ch�a bi�t");			
			end
		end
	end

	--�ϴε�¼������
	if( event == "GAMELOGIN_LASTSELECT_AREA_AND_SERVER") then
		local numArea =-1;
		local numServer = -1;
		if(arg0~=nil)then
			numArea = tonumber(arg0);
			g_LastArea = numArea
		end
		if(arg1~=nil)then
			numServer = tonumber(arg1);
			g_LastServer = numServer
		end
		if(numArea ~= -1 and numServer~=-1)then
			local have = 0;
			for aindex = 1,g_iCurAreaCount do 
				if(numArea == g_AreaIndex[aindex]) then
					have = 1;
					break;
				end	
			end
			for bindex = 1,g_iCurTestAreaCount do
				if(numArea == g_testAreaIndex[bindex]) then
					have = 1;
					break;
				end
			end
			if(have == 1)then
				local tmpServerName= GameProduceLogin:GetAreaLoginServerInfo(numArea, numServer);
				g_LastServerName = tmpServerName;
				SelectServer_Server_Last:SetText(tmpServerName);
				SelectServer_Server_Last:Enable();
				if(g_iCurSelArea == g_LastArea and g_LastServer ==g_iCurSelLoginServer)then
					SelectServer_Server_Last:SetCheck(1);
				end
			else
				SelectServer_Server_Last:SetText("Kh�ng");
				SelectServer_Server_Last:Disable();
			end
		else
			SelectServer_Server_Last:SetText("Kh�ng");
			SelectServer_Server_Last:Disable();
		end
		return;
	end;
	

end

function SelectServer_SelectLastServer()
	if(g_LastArea ~=-1 and g_LastServer ~= -1)then
		for aindex = 1,g_iCurAreaCount do 
			if(g_LastArea == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				SelectServer_SelectLoginServer(g_LastServer,1);
				return;
			end	
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(g_LastArea == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				SelectServer_SelectLoginServer(g_LastServer,1);
				return;
			end
		end

	end
end

--------------------------------------------------------------------------------------------------------------
--
-- �õ���������Ϣ
--

function LoginSelectServer_GetServerInfo()

	 	local iCurAreaCount = GameProduceLogin:GetServerAreaCount();
	 	local strAreaName = "Kh�ng c� m�y ch� ph�c v�";
		local iLoginServerCount = -1;
		local ServerName;
		local ServerStatus;
		--�Ƽ��ȼ�
		local RecommendLevel; 
		local IsNew;
		indexForCommendable = 0;
		local testindex = 0;
		local nomalindex =0;
		local tuijian=0;
	 	for index = 0, iCurAreaCount - 1 do
			tuijian =0;
			if(testindex>=LOGIN_SERVER_TESTAREA_COUNT and nomalindex>=EFFECT_LOGIN_SERVER_AREA_COUNT) then
				break;
			end
			local areaname = GameProduceLogin:GetServerAreaName(index);
	 		-- �õ���������.
			local i = string.find(areaname,"-");
			if(i~=nil and i<string.len(areaname)) then
				if(string.sub(areaname,1,i-1)=="M�ng internet" and testindex<LOGIN_SERVER_TESTAREA_COUNT)then
					testindex = testindex +1;
					g_testAreaName[testindex] = string.sub(areaname,i+1);
					g_testAreaDis[testindex] = GameProduceLogin:GetServerAreaDis(index);
					g_testAreaIndex[testindex] = index;
					tuijian = 1;
					g_testAreaTip[testindex] = GameProduceLogin:GetServerAreaDis(index);
				elseif(string.sub(areaname,1,i-1)=="C�ng tr�c" and nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
					nomalindex = nomalindex +1;
	 				g_AreaName[nomalindex] = string.sub(areaname,i+1);
					g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
					g_AreaIndex[nomalindex] = index;
					tuijian = 1;
					g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				end
			elseif(nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
				nomalindex = nomalindex +1;
	 			g_AreaName[nomalindex] = GameProduceLogin:GetServerAreaName(index);
				g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				g_AreaIndex[nomalindex] = index;
				tuijian = 1;
				g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
			end;
	 		-- ��������.
			iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(index);
			if(iLoginServerCount > LOGIN_SERVER_COUNT) then
				iLoginServerCount=LOGIN_SERVER_COUNT;
			end
			--�õ��Ƽ��������б�
			if(tuijian==1)then 
				for i=0,iLoginServerCount-1 do
					if(indexForCommendable>=COMMENDABLE_LOGIN_SERVER_COUNT) then
							break;
					end;
					ServerName,
					ServerStatus,
					--ServerID,
					--AreaID,
					RecommendLevel,
					IsNew
						= GameProduceLogin:GetAreaLoginServerInfo(index, i);
						-- �Ƽ�������id
					if(RecommendLevel>0 and indexForCommendable <COMMENDABLE_LOGIN_SERVER_COUNT and ServerStatus ~= StatMax) then
						indexForCommendable = indexForCommendable + 1;
						g_CommendableLoginServerName[indexForCommendable] = ServerName;
						g_CommendableLoginServerServerIndex[indexForCommendable] = i;
						g_CommendableLoginServerAreaIndex[indexForCommendable] = index;
						g_CommendableLoginServerCommendableLevel[indexForCommendable] = RecommendLevel;
						g_CommendableLoginServerIsNew[indexForCommendable] = IsNew;
						g_CommendableLoginServerStatus[indexForCommendable] = ServerStatus;

					end;			
				end
			end;
	 	end
		if(indexForCommendable>=1)then
			SortCommendableLoginServer();
			
			local strName="";
			for i = 1,indexForCommendable do
				g_CommendableBnLoginServer[i]:Show();
				local tmpAreaName = GameProduceLogin:GetServerAreaName(g_CommendableLoginServerAreaIndex[i]);
				local _i = string.find(tmpAreaName,"-");
				if(_i~=nil and _i<string.len(tmpAreaName)) then
					if(string.sub(tmpAreaName,1,_i-1)=="C�ng tr�c" or string.sub(tmpAreaName,1,_i-1)=="M�ng internet")then
						tmpAreaName = string.sub(tmpAreaName,_i+1);
					end
				end
				strName =tmpAreaName.."-"..g_CommendableLoginServerName[i];								
				if(g_CommendableLoginServerIsNew[i]~=0)then
					strName =strName.."(M�i)";
				end
				if(0 == g_CommendableLoginServerStatus[i]) then
					strName = "#cff0000#e010101"..strName.."#cffffff";
				elseif(1 == g_CommendableLoginServerStatus[i]) then

					strName = "#cff8a00#e010101"..strName.."#cffffff";
				elseif(2 == g_CommendableLoginServerStatus[i]) then

					strName = "#cECE58D#e010101"..strName.."#cffffff";
				elseif(3 == g_CommendableLoginServerStatus[i]) then

					strName = "#c4CFA4C#e010101"..strName.."#cffffff";
				else

					strName = "#c959595#e010101"..strName.."#cffffff";
					g_CommendableBnLoginServer[i]:Disable();
				end				
			
				g_CommendableBnLoginServer[i]:SetText(strName);
				g_CommendableBnLoginServer[i]:SetCheck(0);
			end;
		end;
		g_iCurAreaCount =nomalindex ;
		g_iCurTestAreaCount = testindex;
end

--�����У���С����
function SortCommendableLoginServer()

	local TotalCount = indexForCommendable;
	local tmp ;
	local p=0;
	for j = 1 , TotalCount -1 do
		for i=1, TotalCount-j do
			if(g_CommendableLoginServerCommendableLevel[i]>g_CommendableLoginServerCommendableLevel[i+1]) then
				tmp = g_CommendableLoginServerCommendableLevel[i];
				g_CommendableLoginServerCommendableLevel[i] = g_CommendableLoginServerCommendableLevel[i+1];
				g_CommendableLoginServerCommendableLevel[i+1] = tmp;

				tmp = g_CommendableLoginServerName[i];
				g_CommendableLoginServerName[i] = g_CommendableLoginServerName[i+1];
				g_CommendableLoginServerName[i+1] = tmp;			
				
				tmp = g_CommendableLoginServerServerIndex[i];
				g_CommendableLoginServerServerIndex[i] = g_CommendableLoginServerServerIndex[i+1];
				g_CommendableLoginServerServerIndex[i+1] = tmp;	

				tmp = g_CommendableLoginServerAreaIndex[i];
				g_CommendableLoginServerAreaIndex[i] = g_CommendableLoginServerAreaIndex[i+1];
				g_CommendableLoginServerAreaIndex[i+1] = tmp;	

				tmp = g_CommendableLoginServerIsNew[i];
				g_CommendableLoginServerIsNew[i] = g_CommendableLoginServerIsNew[i+1];
				g_CommendableLoginServerIsNew[i+1] = tmp;	
				
				tmp = g_CommendableLoginServerStatus[i];
				g_CommendableLoginServerStatus[i] = g_CommendableLoginServerStatus[i+1];
				g_CommendableLoginServerStatus[i+1] = tmp;
			end
		end;
	end;
end;
--------------------------------------------------------------------------------------------------------------
--
-- ѡ��һ����������
--
function SelectServer_SelectTestAreaServer(index)
	-- ��¼��ǰѡ�����������.	
	g_iCurSelArea = g_testAreaIndex[index+1];

	-- ����ѡ�������
	g_iCurSelAreaName = g_testAreaName[index+1];

	-- ���ð�ťѡ��״̬.
	g_BntestArea[index+1]:SetCheck(1);

	-- ��������ť.
	SelectServer_HideLoginServerBn();

	-- �õ�login server����Ϣ
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);

	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	for indexLoginServer = 0, iLoginServerCount - 1 do	
		SelectServer_GetAndShowLoginServer(indexLoginServer);
	end
	for iArea = 1, g_iCurAreaCount do	
		g_BnArea[iArea]:SetCheck(0);
	end
	DisableSelect();
end
--------------------------------------------------------------------------------------------------------------
--
-- ѡ��һ������
--
function SelectServer_SelectAreaServer(index)

	-- ��¼��ǰѡ�����������.	
	g_iCurSelArea = g_AreaIndex[index+CurPage*PageSize+1];

	-- ����ѡ�������
	g_iCurSelAreaName = g_AreaName[index+CurPage*PageSize+1];

	-- ���ð�ťѡ��״̬.
	g_BnArea[index+1]:SetCheck(1);

	-- ��������ť.
	SelectServer_HideLoginServerBn();

	-- �õ�login server����Ϣ
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);

	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	for indexLoginServer = 0, iLoginServerCount - 1 do	
		SelectServer_GetAndShowLoginServer(indexLoginServer);
	end
	for itestArea = 1, g_iCurTestAreaCount do	
		g_BntestArea[itestArea]:SetCheck(0);
	end
	DisableSelect();
end

function DisableSelect()
		g_iCurSelLoginServer =-1;
		g_iCurComSelLoginServer = -1;
		for i = 1,indexForCommendable do
				g_CommendableBnLoginServer[i]:SetCheck(0)		
		end;
		NotFlashAll();
		SelectServer_Text2:SetToolTip("");
		SelectServer_Text1:SetText("");
		SelectServer_Text2:SetText("");
		SelectServer_Text3:SetText("");
		--SelectServer_Accept:Disable();
end
--function EnableSelect()
--		SelectServer_Accept:Enable();
--end
--------------------------------------------------------------------------------------------------------------
--
-- ���Ƽ��б���ѡ��һ��login server
--
--------------------------------------------------------------------------------------------------------------
function Commendable_SelectLoginServer(index)
	-- ���ð�ťѡ��״̬.
	if(g_CommendableBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end
	
	g_iCurComSelLoginServer = index;

	g_CommendableBnLoginServer[index]:SetCheck(1);

	local strLoginServerStatus = "???";
	
	if(0 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff0000Хy#cffffff";
	elseif(1 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff8a00S�p �y#cffffff";
	elseif(2 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cECE58DT�t#cffffff";
	elseif(3 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#c4CFA4CC�c t�t#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595B�o d��ng#cffffff";
	end
	
	i = g_CommendableLoginServerAreaIndex[index]
	SelectServer_ShowServerInfo(g_AreaName[i+1].."  "..g_CommendableLoginServerName[index], "", strLoginServerStatus);
	--ͬʱ��������ķ�������server
	g_iCurSelArea = g_CommendableLoginServerAreaIndex[index];
	for aindex = 1,g_iCurAreaCount do 
		if(g_iCurSelArea == g_AreaIndex[aindex]) then
			AxTrace(0,2,"5" )
			CurPage = math.floor((aindex-1)/PageSize);
			ShowPage();
			SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
			SelectServer_SelectLoginServer(g_CommendableLoginServerServerIndex[index],1);
			return;
		end	
	end
	for bindex = 1,g_iCurTestAreaCount do
		if(g_iCurSelArea == g_testAreaIndex[bindex]) then
			SelectServer_SelectTestAreaServer(bindex-1);
			SelectServer_SelectLoginServer(g_CommendableLoginServerServerIndex[index],1);
			return;
		end
	end
end;
--
-- ѡ��һ��login server
--
function SelectServer_SelectLoginServer(index,flash)
	if(g_BnLoginServer[index+1]:GetProperty("Disabled")=="True") then
		return;
	end
	
	GameProduceLogin:SetPingServer(g_iCurSelArea,index);
	--EnableSelect();
	-- ��¼��ǰѡ���login server
	g_iCurSelLoginServer = index;

	if(g_LastServer == g_iCurSelLoginServer and g_LastArea == g_iCurSelArea)then
		SelectServer_Server_Last:SetCheck(1);
	else
		SelectServer_Server_Last:SetCheck(0);
	end
	
	if(flash==1)then
		g_BnLoginServer[index+1]:FlashMe(1);
	else
		NotFlashAll();
	end
	-- ���ð�ťѡ��״̬.
	g_BnLoginServer[index+1]:SetCheck(1);
	local strLoginServerStatus = "???";

	if(0 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cff0000Хy#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c9E5705S�p �y#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cECE58DT�t#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c4CFA4CC�c t�t#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595B�o d��ng#cffffff";
	end

	-- ������Ϣ
	SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_LoginServerName[index+1], "", strLoginServerStatus);

	--�����Ƽ�������
	local tmpNum = 0
	--if(g_LoginServerCommendableLevel[index+1]>0) then
		for i = 1,indexForCommendable do
			if(g_CommendableLoginServerAreaIndex[i] == g_iCurSelArea and g_CommendableLoginServerServerIndex[i] == g_iCurSelLoginServer)then
				g_iCurComSelLoginServer = i;
				g_CommendableBnLoginServer[i]:SetCheck(1)
			else
				tmpNum = tmpNum+1;
				g_CommendableBnLoginServer[i]:SetCheck(0)	
			end;			
		end;
		if tmpNum>=indexForCommendable then
			g_iCurComSelLoginServer = -1
		end;
	--else 
	--	g_iCurComSelLoginServer = -1;
	--end;

end

function NotFlashAll()
	for i=1,LOGIN_SERVER_COUNT do
		g_BnLoginServer[i]:FlashMe(0);
		g_BnLoginServer[i]:SetCheck(0);
	end
end
--------------------------------------------------------------------------------------------------------------
--
-- �õ�һ��login server��Ϣ����ʾ
--
function SelectServer_GetAndShowLoginServer(index)

	g_LoginServerName[index+1]
	,g_LoginServerStatus[index+1]
	,g_LoginServerCommendableLevel[index+1]
	,g_LoginServerIsNew[index+1]
	= GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, index);
	g_BnLoginServer[index+1]:Enable();
	g_BnLoginServer[index+1]:Show();
	if(g_LoginServerStatus[index+1] == StatMax) then
		g_BnLoginServer[index+1]:Hide();
		return;
	end
	local strName = g_LoginServerName[index+1];

	if(g_LoginServerIsNew[index+1]==1)then
		strName = strName.."(M�i)";
	end;

	if(0 == g_LoginServerStatus[index+1]) then

		strName = "#cff0000#e010101"..strName.."#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strName = "#cff8a00#e010101"..strName.."#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strName = "#cECE58D#e010101"..strName.."#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strName = "#c4CFA4C#e010101"..strName.."#cffffff";
	else

		strName = "#c959595#e010101"..strName.."#cffffff";
		g_BnLoginServer[index+1]:Disable();
	end

	g_BnLoginServer[index+1]:SetText(strName);
	
	

end

--------------------------------------------------------------------------------------------------------------
--
-- ����login server ��ť
--
function SelectServer_HideLoginServerBn()

	local index;
	for index = 1, LOGIN_SERVER_COUNT  do
 		g_BnLoginServer[index]:Hide();
 	end

end

--------------------------------------------------------------------------------------------------------------
--
-- ����login server ��ť
--
function SelectServer_ShowServerInfo(ServerName, NetStatus, ServerStatus)
	SelectServer_Text2:SetToolTip("");
	SelectServer_Text1:SetText("#e010101M�y ch�: #cFFFF00"..ServerName);
	SelectServer_Text2:SetText(NetStatus);
	SelectServer_Text3:SetText("#e010101Tr�ng th�i: "..ServerStatus);

end

---------------------------------------------------------------------------------------------------------------
--
--  ȷ��ѡ��һ��������
--
function SelectServer_SelectOk()

	-- ���ӵ�login server
	--ͯϲ����ʹ�ô���,�����������Ӧ��
	AxTrace(0,2,"g_iCurSelArea="..g_iCurSelArea )
	AxTrace(0,2,"g_iCurComSelLoginServer ="..g_iCurComSelLoginServer )
	AxTrace(0,2,"g_iCurSelLoginServer ="..g_iCurSelLoginServer )
	AxTrace(0,2,"\n")
	GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, g_iNetProvide);
	return;
end

---------------------------------------------------------------------------------------------------------------
--
--   �Զ�ѡ��һ��������
--
function SelectServer_SelectAuto()
	GameProduceLogin:AutoSelLoginServer(g_iNetProvide);
end

---------------------------------------------------------------------------------------------------------------
--
--   �˳���Ϸ
--
function SelectServer_Exit()
	QuitApplication("quit");
end


---------------------------------------------------------------------------------------------------------------
--
-- ѡ�����
--
function SelectServer_SelectLine1()

	-- ѡ�����
	g_iNetProvide = 0;

	-- ѡ�е���
	SelectServer_Line1:SetCheck(1);
	SelectServer_Line2:SetCheck(0);
	SelectServer_Line3:SetCheck(0);

	--tongxi
	SelectServer_Line4:SetCheck(0)

end


---------------------------------------------------------------------------------------------------------------
--
-- ѡ����ͨ
--
function SelectServer_SelectLine2()

	-- ѡ����ͨ
	g_iNetProvide = 1;

	-- ѡ����ͨ
	SelectServer_Line1:SetCheck(0);
	SelectServer_Line2:SetCheck(1);
	SelectServer_Line3:SetCheck(0);

	--tongxi
	SelectServer_Line4:SetCheck(0);
end


---------------------------------------------------------------------------------------------------------------
--
-- ����
--
function SelectServer_SelectLine3()

	-- ѡ������
	g_iNetProvide = 2;

	-- ѡ������
	SelectServer_Line1:SetCheck(0);
	SelectServer_Line2:SetCheck(0);
	SelectServer_Line3:SetCheck(1);
	--tongxi
	SelectServer_Line4:SetCheck(0);
end


---------------------------------------------------------------------------------------------------------------
--
-- Ĭ�� tongxi
--
function SelectServer_SelectLine4()

	-- ѡ��Ĭ��
	g_iNetProvide = 3;

	-- ѡ������
	SelectServer_Line1:SetCheck(0);
	SelectServer_Line2:SetCheck(0);
	SelectServer_Line3:SetCheck(0);
	--tongxi
	SelectServer_Line4:SetCheck(1);
end

---------------------------------------------------------------------------------------------------------------
--
-- �������Ƽ�������
--
function Commendable_LoginServer_MouseEnter(index)

	SelectServer_Info:SetText(g_CommendableLoginServerName[index]..tostring(" M�y ch� ph�c v�"));
end

---------------------------------------------------------------------------------------------------------------
--
-- ����������ť
--
function SelectServer_LoginServer_MouseEnter(index)

	SelectServer_Info:SetText(g_LoginServerName[index+1]..tostring(" M�y ch� ph�c v�"));
end

---------------------------------------------------------------------------------------------------------------
--
-- ����������ť
--
function SelectServer_LastServer_MouseEnter()
	if(g_LastServerName~="") then
		SelectServer_Info:SetText(g_LastServerName..tostring(" M�y ch� ph�c v�"));
	else
		SelectServer_Info:SetText("");
	end
end
---------------------------------------------------------------------------------------------------------------
--
-- ����뿪����ť
--
function SelectServer_LastServer_MouseLeave()

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- ����뿪����ť
--
function SelectServer_LoginServer_MouseLeave(index)

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- ��깫������ ��ť
--
function SelectServer_TestArea_MouseEnter(index)

	SelectServer_Info:SetText(g_testAreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- ����뿪�������� ��ť
--
function SelectServer_TestArea_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


---------------------------------------------------------------------------------------------------------------
--
-- ������login server ��ť
--
function SelectServer_Area_MouseEnter(index)

	SelectServer_Info:SetText(g_AreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- ����뿪login server ��ť
--
function SelectServer_Area_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


function SelectServer_Accept_MouseEnter()

	SelectServer_Info:SetText("Nh�n v�o s� c� th� v�o c�c c�m m�y ch� �� ch�n.");
end;

function SelectServer_MouseLeave()

	SelectServer_Info:SetText("");
end;

function SelectServer_Automatic_MouseEnter()

	SelectServer_Info:SetText("Gi�p �� c�c h� l�a ch�n b� m�y ph�c v� t�t nh�t.");
end;


function SelectServer_Cancel_MouseEnter()

	SelectServer_Info:SetText("R�i kh�i Thi�n Long B�t B�.");
end;



function SelectServer_MouseEnter_Line(index)

	if(1 == index) then

		SelectServer_Info:SetText("N�u l� ti�p nh�n �i�n t�n, m�i ch�n �i�m d߾i c�ng \"L�a ch�n t� �ng\"");
		return;
	end

	if(2 == index) then

		SelectServer_Info:SetText("N�u l� ti�p nh�n mang internet, m�i ch�n �i�m d߾i c�ng \"L�a ch�n t� �ng\"");
		return;
	end

	if(3 == index) then

		SelectServer_Info:SetText("N�u l� ti�p nh�n m�ng gi�o d�c, m�i ch�n �i�m d߾i c�ng \"L�a ch�n t� �ng\"");
		return;
	end

	if(4 == index) then
		SelectServer_Info:SetText("Ti�p nh�n nh�n ng�m, m�i th� �ng l�a ch�n 1 b� m�y ph�c v�");
		return;
	end
end


function HideTestAreaBn()
	local index;
	--SelectServer2_Commendable_Text:Hide();
	for index = 1, LOGIN_SERVER_TESTAREA_COUNT  do
 		g_BntestArea[index]:Hide();
 	end
end
function HideAreaBn()
	local index;
	for index = 1, LOGIN_SERVER_AREA_COUNT  do
 		g_BnArea[index]:Hide();
 	end
end
function ShowTestAreaBn()
	local index;
	local index1 = 1;
	if g_iCurTestAreaCount<=0 then return; end
	--SelectServer2_Commendable_Text:Show();
	for index = 1,LOGIN_SERVER_TESTAREA_COUNT  do
 		if(index <= g_iCurTestAreaCount) then		
			g_BntestArea[index1]:SetText(g_testAreaName[index]);
			g_BntestArea[index1]:SetToolTip(g_testAreaTip[index]);
			g_BntestArea[index1]:Show();
 		end;
		index1 = index1+1
 	end
end

function ShowAreaBn()
	local index;
	local index1 = 1;
	AxTrace(3,3,"g_iCurAreaCount="..g_iCurAreaCount )
	for index = CurPage*PageSize+1, (CurPage+1)*PageSize do
			
 		if(index <= g_iCurAreaCount) then		
			g_BnArea[index1]:SetText(g_AreaName[index]);
			g_BnArea[index1]:SetToolTip(g_AreaTip[index]);
			g_BnArea[index1]:Show();
 		end;
		index1 = index1+1
 	end
end


-- ˫��ѡ��һ����������
function SelectServer_ConfirmSelectLine(index)
	AxTrace(0,2,"7" )
	-- ѡ��һ��login server
	SelectServer_SelectLoginServer(index,0);

	-- ȷ��ѡ��һ��������
	SelectServer_SelectOk();

end;
-- ˫��ѡ��һ����������
function SelectServer_LastConfirmSelectLine()

	-- ѡ��һ��login server
	SelectServer_SelectLastServer();

	-- ȷ��ѡ��һ��������
	SelectServer_SelectOk();

end;
-- ˫��ѡ��һ����������
function Commendable_ConfirmSelectLine(index)
	-- ѡ��һ��login server
	Commendable_SelectLoginServer(index);

	-- ȷ��ѡ��һ��������
	SelectServer_SelectOk();

end;

function SelectServer_PageUp()
	CurPage = CurPage - 1
	ShowPage()
	SelectServer_SelectAreaServer(0);

end

function SelectServer_PageDown()
	CurPage = CurPage + 1
	ShowPage()
	SelectServer_SelectAreaServer(0);
end;

function ShowPage()
	--���·�ҳ��ť
	--UpdateUpAddDownButton();
	--hide all
	--HideAreaBn();
	--show 
	--ShowAreaBn();
end;
function UpdateUpAddDownButton()
	--SelectServer_Subarea_PageUp:Hide();
	--SelectServer_Subarea_PageDown:Hide();
	--if(g_iCurAreaCount-CurPage*PageSize>PageSize)then
	--	SelectServer_Subarea_PageDown:Show()
	--end
	--if(CurPage>0)then
	--	SelectServer_Subarea_PageUp:Show()
	--end
end;

--�����ʺ�
function SelectServer_AccountReg()
--    GameProduceLogin:StartAccountReg()
	GameProduceLogin:OpenURL( "" )
end

--�ʺų�ֵ
function SelectServer_AccountChongZhi()
	--if(Variable:GetVariable("System_CodePage") == "1258") then
   -- GameProduceLogin:OpenURL( "http://www.tinhkiem.us/" )
  --elseif(Variable:GetVariable("System_CodePage") == "950") then --̨��
  --  GameProduceLogin:OpenURL( "http://www.tinhkiem.us/" )
	--else
   -- GameProduceLogin:OpenURL( "http://www.tinhkiem.us/" )
 -- end
end

function SelectServer_shangyibu_click()
	GameProduceLogin:GoToCampaignDlg();
end