function ShiMingRenZheng_PreLoad()
	this:RegisterEvent("OPEN_SHIMINGRENZHENG_DLG");
end

function ShiMingRenZheng_OnLoad()
end

-- OnEvent
function ShiMingRenZheng_OnEvent(event)
	if( event == "OPEN_SHIMINGRENZHENG_DLG" ) then
		local haveShiming = tonumber(arg0);
		if(haveShiming == 1)then
			--Y�����ڵ���Ϸʱ���ѳ���3Сʱ����ʱ�䣬����Ϸ������õ����潫����������޷�������棬����ǰ��������������Ϣ��֤ҳ������дʵ����֤��Ϣ����֤����18��󣬽����ᱻ����#cff0000������ϵͳ#Y�����������Ϸ�����ڳ���#cff00003Сʱ#Y������Ϸʱ��󣬻���#cff0000������ϵͳ#Yʱ������ƶ����٣�#cff00003Сʱ�������һ�룬6Сʱ����ȫû������#Y����
			ShiMingRenZheng_WarningText : SetText("#{Interface_ShiMingRenZheng_txt4}")
		else
			--#Y��δ��д������ʵ����֤��Ϣ����ң�����ǰ���ٷ���վ��������Ϣ��֤ҳ������дʵ����֤��Ϣ����֤����18��󣬽����ᱻ����#cff0000������ϵͳ#Y�����������Ϸ�����ڳ���#cff00003Сʱ#Y������Ϸʱ��󣬻���#cff0000������ϵͳ#Yʱ������ƶ����٣�#cff00003Сʱ�������һ�룬6Сʱ����ȫû������#Y����
			ShiMingRenZheng_WarningText : SetText("#{Interface_ShiMingRenZheng_txt3}")
		end
		ShiMingRenZheng_Init();
		this : Show()
	end

end

function ShiMingRenZheng_Init()

end

--ȥʵ����֤��վ
function ShiMingRenZheng_Info_Clicked()
	if(Variable:GetVariable("System_CodePage") == "1258") then
		--do nothing
	else
		GameProduceLogin:OpenURL(GetWeblink("WEB_FANGCHENMI"))
	end
end

function ShiMingRenZheng_Close_Clicked()
	--TO Do...
end