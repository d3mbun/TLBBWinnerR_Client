function FangChenMi_PreLoad()
	this:RegisterEvent("OPEN_FANGCHENGMI_DLG");
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	this:RegisterEvent("NET_HAS_CLOSED");
end

function FangChenMi_OnLoad()
end

-- OnEvent
function FangChenMi_OnEvent(event)
	if( event == "OPEN_FANGCHENGMI_DLG" ) then
		local haveMibao = tonumber(arg0);
		local haveShiming = tonumber(arg1);
		if(haveMibao == 1)then
			--����ʹ�����ܱ����󶨷��������Ʊ��ܺ�����ܱ�����ף����Ϸ��졣
			FangChenMi_MiBaoKa_Text : SetText("#{DHMB_0711_08}");
			FangChenMi_MiBaoKa : Disable()

		elseif(haveMibao == 2) then
			--�װ�����ң����ѿ�ͨ�绰�ܱ��󶨹��ܣ���½��Ϸǰ���Ȳ�����ѵ绰��010-6212-2299��������֤
			--FangChenMi_MiBaoKa_Text : SetText("#{DHMB_0711_07}");
			FangChenMi_SetMibaokaText(); -- add by cuiyj 
			FangChenMi_MiBaoKa	: Disable()
			
		else
			--�����˺���δ��ͨ��ѵĵ绰�ܱ��󶨹��ܡ�Ϊ���������˺ű�������Ϸ�Ʋ���������ռ����������ķ�����ǿ�ҽ�������½sde.sohu.game.com��ͨ�绰�ܱ��󶨷��񡣵绰�ܱ������ܱ����󶨲���ͬʱʹ�ã�������ʹ�õ绰�ܱ���ͬʱʹ�õ��԰󶨣�����˺Ű�ȫϵ����
			FangChenMi_MiBaoKa_Text : SetText("#{DHMB_0711_06}");
			FangChenMi_MiBaoKa	: Enable()
		end

		if(haveShiming == 1)then
			--�����ʺ�����д�û���ʵ���������֤������Ϣ��ף����Ϸ��졣
			FangChenMi_Info_Text : SetText("#{Interface_FangChenMi_txt8}");
			FangChenMi_Info	: Disable()
		else
			--ע�⣡�����ʺ���δ��д�û���ʵ���������֤������Ϣ���п��ܻᱻ����#cff0000������ϵͳ#Y��#cff0000�޷����������Ϸ����#Y��Ϊ��ȷ����������������Ϸ������ǿ�ҽ�������¼�����˲��ٷ���վ��д�����û���ʵ���������֤������Ϣ��
			FangChenMi_Info_Text : SetText("#{Interface_FangChenMi_txt7}");
			FangChenMi_Info	: Enable()
		end
		
		-- �����޸ģ�����������û�п�ͨ��������ȹر� ���� 2008.7.30
		--FangChenMi_MiBaoKa : Disable()
		
		this : Show();
	end
	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		this : Hide();
	end
	if( event == "NET_HAS_CLOSED" ) then
		this : Hide();
	end
end

--ͬ��
function FangChenMi_Accept_Clicked()
	SendSafeSignMsg();
	this : Hide();
end

--ȥ�ܱ�����վ
function FangChenMi_MiBaoKa_Clicked()
	if(Variable:GetVariable("System_CodePage") == "1258") then
		--do nothing
	else
		GameProduceLogin:OpenURL( "http://sde.game.sohu.com/bindphone/bindphoneindex.jsp" )
	end
end

--ȥʵ����֤��վ
function FangChenMi_Info_Clicked()
	if(Variable:GetVariable("System_CodePage") == "1258") then
		--do nothing
	else
		GameProduceLogin:OpenURL( "http://sde.game.sohu.com/fangchenmi/submitlogin.jsp" )
	end
end

function FangChenMi_Close_Clicked()
	-- Do Nothing
end

function FangChenMi_SetMibaokaText()
	local PasswdProctectTels = {"",""}
	local strStart = "#{DHMB_081014_002_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_002_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	
	-- �������ļ������ȡ3���绰
	--math.randomseed(os.time() + 2);
	math.random(0,100);math.random(0,100)
	local arrIdx = {-1,-1,-1};
	local MAX_TEL_SHOWCOUNT = 3
	local MiBaoDhCount = 0
	local iGetCount = 0
	MiBaoDhCount = GameProduceLogin:GetPasswdTelCount();
	if( MiBaoDhCount <= 0 or MiBaoDhCount > 5000 ) then
		return; --�ܱ��绰����������ֱ����ԭ���ĵ绰
	end
	while (iGetCount < MiBaoDhCount and iGetCount < MAX_TEL_SHOWCOUNT) do
		local iTmpIdx = math.random(0,MiBaoDhCount-1);
		local bExitIdx = 0;
		for i = 1, iGetCount do
			if (arrIdx[i] == iTmpIdx) then
				bExitIdx = 1;
				break;
			end;
		end;
		if ( 1 ~= bExitIdx ) then
		    iGetCount = iGetCount + 1;
			arrIdx[iGetCount] = iTmpIdx;
		end;
	end;
	
	if (MiBaoDhCount > MAX_TEL_SHOWCOUNT) then --���ǵ���ʾ���С�� �ܱ��绰�����޶�Ϊ3��
		MiBaoDhCount = MAX_TEL_SHOWCOUNT
	end
	
	for i=1,MiBaoDhCount do
		--local strTel = GameProduceLogin:GetPasswdTelByIndex(i - 1);
		local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
		PasswdProctectTels[i] = strTel;
	end
	
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount ) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;	
	end
	strTmp = strTmp..strEnd
	FangChenMi_MiBaoKa_Text : SetText(strTmp);
end