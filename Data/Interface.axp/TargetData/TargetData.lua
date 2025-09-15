local TargetData_CharName = ""
local CTRL_NUM = 11
local CTRL = {};

local SELF_PAGE  = 0;
local OTHER_PAGE = 1;
local g_Current_Page;
local SELFDATA_TAB_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- OnLoad()
--===============================================
function TargetData_PreLoad()
	this:RegisterEvent("OPEN_PRIVATE_INFO");
	this:RegisterEvent("UPDATE_PRIVATE_INFO");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
end

function TargetData_OnLoad()
	--��Ф
	TargetData_YearAnimal:ComboBoxAddItem("-",0);
	TargetData_YearAnimal:ComboBoxAddItem("T�",1); 
	TargetData_YearAnimal:ComboBoxAddItem("S�u",2); 
	TargetData_YearAnimal:ComboBoxAddItem("H�",3); 
	TargetData_YearAnimal:ComboBoxAddItem("M�o",4); 
	TargetData_YearAnimal:ComboBoxAddItem("Th�n",5); 
	TargetData_YearAnimal:ComboBoxAddItem("T�",6); 
	TargetData_YearAnimal:ComboBoxAddItem("Ng�",7); 
	TargetData_YearAnimal:ComboBoxAddItem("M�i",8); 
	TargetData_YearAnimal:ComboBoxAddItem("Th�n",9);
	TargetData_YearAnimal:ComboBoxAddItem("D�u",10);
	TargetData_YearAnimal:ComboBoxAddItem("Tu�t",11);
	TargetData_YearAnimal:ComboBoxAddItem("H�i",12);
	
	--ʡ��
	TargetData_Province:ComboBoxAddItem("-",		 0);
	TargetData_Province:ComboBoxAddItem("An Giang",  1); 
	TargetData_Province:ComboBoxAddItem("B� R�a",  2); 
	TargetData_Province:ComboBoxAddItem("B�n Tre",  3); 
	TargetData_Province:ComboBoxAddItem("Bi�n Ho�",  4); 
	TargetData_Province:ComboBoxAddItem("B�nh D߽ng",  5); 
	TargetData_Province:ComboBoxAddItem("B�nh Thu�n",  6); 
	TargetData_Province:ComboBoxAddItem("C� Mau",  7); 
	TargetData_Province:ComboBoxAddItem("C�n Th�",8); 
	TargetData_Province:ComboBoxAddItem("Cao B�ng",  9); 
	TargetData_Province:ComboBoxAddItem("Ch�u Яc",  10);
	TargetData_Province:ComboBoxAddItem("�i�n Bi�n",  11);
	TargetData_Province:ComboBoxAddItem("аng Th�p",  12);
	TargetData_Province:ComboBoxAddItem("Сk N�ng",  13);
	TargetData_Province:ComboBoxAddItem("�� N�ng",  14);
	TargetData_Province:ComboBoxAddItem("H� Giang",  15);
	TargetData_Province:ComboBoxAddItem("H� T�y",  16);
	TargetData_Province:ComboBoxAddItem("Thanh Ho�",  17);
	TargetData_Province:ComboBoxAddItem("Gia Lai",  18);
	TargetData_Province:ComboBoxAddItem("H� N�i",  19);
	TargetData_Province:ComboBoxAddItem("H�i Ph�ng",  20);
	TargetData_Province:ComboBoxAddItem("H� Ch� Minh",21);
	TargetData_Province:ComboBoxAddItem("Hu�",  22);
	TargetData_Province:ComboBoxAddItem("Kh�nh Ho�",  23);
	TargetData_Province:ComboBoxAddItem("Kon Tum",  24);
	TargetData_Province:ComboBoxAddItem("Ki�n Giang",  25);
	TargetData_Province:ComboBoxAddItem("L�m аng",  26);
	TargetData_Province:ComboBoxAddItem("Ninh B�nh",  27);
	TargetData_Province:ComboBoxAddItem("Ninh Thu�n",  28);
	TargetData_Province:ComboBoxAddItem("Qu�ng Nam",  29);
	TargetData_Province:ComboBoxAddItem("Qu�ng Ninh",  30);
	TargetData_Province:ComboBoxAddItem("S�c Tr�ng",  31);
	TargetData_Province:ComboBoxAddItem("S�n La",  32);
	TargetData_Province:ComboBoxAddItem("Th�i B�nh",  33);
	TargetData_Province:ComboBoxAddItem("V�nh Long",  34);
	TargetData_Province:ComboBoxAddItem("Kh�c",  35);
	
	 --����  ��� ������
	                                          
	--�Ա�
	TargetData_Sex:ComboBoxAddItem("-",0);
	TargetData_Sex:ComboBoxAddItem("Nam",1);
	TargetData_Sex:ComboBoxAddItem("N�",2);

	--Ѫ��
	TargetData_BloodType:ComboBoxAddItem("-",0);
	TargetData_BloodType:ComboBoxAddItem("A",1);
	TargetData_BloodType:ComboBoxAddItem("B",2);
	TargetData_BloodType:ComboBoxAddItem("AB",3);
	TargetData_BloodType:ComboBoxAddItem("O",4);


	--����
	TargetData_Constellation:ComboBoxAddItem("-",0); 
	TargetData_Constellation:ComboBoxAddItem("Th�n N�ng",1);
	TargetData_Constellation:ComboBoxAddItem("Th�y B�nh",2); 
	TargetData_Constellation:ComboBoxAddItem("Song Ng�",3); 
	TargetData_Constellation:ComboBoxAddItem("B�ch D߽ng",4); 
	TargetData_Constellation:ComboBoxAddItem("Kim Ng�u",5); 
	TargetData_Constellation:ComboBoxAddItem("Song Sinh",6); 
	TargetData_Constellation:ComboBoxAddItem("C� Gi�i",7); 
	TargetData_Constellation:ComboBoxAddItem("S� T�",8); 
	TargetData_Constellation:ComboBoxAddItem("X� N�",9); 
	TargetData_Constellation:ComboBoxAddItem("Thi�n B�nh",10);
	TargetData_Constellation:ComboBoxAddItem("Thi�n Gi�i",11);
	TargetData_Constellation:ComboBoxAddItem("X� Th�",12);
	
	CTRL[1] = TargetData_Age;
	CTRL[2] = TargetData_Sex;
	CTRL[3] = TargetData_Job;
	CTRL[4] = TargetData_School;
	CTRL[5] = TargetData_BloodType;
	CTRL[6] = TargetData_YearAnimal;
	CTRL[7] = TargetData_Constellation;
	CTRL[8] = TargetData_Province;
	CTRL[9] = TargetData_City;
	CTRL[10] = TargetData_EMail;
	CTRL[11] = TargetData_MessageBoard;
	
	SELFDATA_TAB_TEXT = {
		[0] = "а",
		"Nh�n",
		"Th�",
		"K�",
	};	
end

function TargetData_SetTabColor(idx)

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = TargetData_SelfEquip,
								TargetData_TargetData,								
								TargetData_Pet,
								TargetData_Ride,
							};
	
	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFDATA_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFDATA_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
--===============================================
-- OnEvent()
--===============================================
function TargetData_OnEvent(event)
	if ( event == "OPEN_PRIVATE_INFO" ) then
	
		if(arg0 == "self")     then
			return;
		end
		
		this:Show();
		objCared = SystemSetup:GetCaredObjId();
		this:CareObject(objCared, 1, "TargetData");
		TargetData_SetTabColor(1);
		TargetData_SelfEquip:SetCheck(0);
		TargetData_TargetData:SetCheck(1);
		--TargetData_Blog:SetCheck(0);
		
		if(arg0 == "self")     then
			local selfUnionPos = Variable:GetVariable("SelfUnionPos");
			if(selfUnionPos ~= nil) then
				TargetData_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			end
			
			g_Current_Page = SELF_PAGE;
			TargetData_UpdateFrame("self");
			for i=1 ,CTRL_NUM  do
				CTRL[i]:Enable();
			end
			TargetData_DataShareMode:Show();
			TargetData_Accept:Show();
			TargetData_DataShareMode_Text:Show()
			--TargetData_Blog:Show();
		else
			local otherUnionPos = Variable:GetVariable("OtherUnionPos");
			if(otherUnionPos ~= nil) then
				TargetData_Frame:SetProperty("UnifiedPosition", otherUnionPos);
			end
		
			g_Current_Page = OTHER_PAGE;
			TargetData_UpdateFrame("other");
			for i=1 ,CTRL_NUM -1   do
				CTRL[i]:Disable();
			end
			TargetData_DataShareMode:Hide();
			TargetData_Accept:Hide();
			TargetData_DataShareMode_Text:Hide();
			--TargetData_Blog:Hide();
			
		end
		
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--ȡ������
			this:CareObject(objCared, 0, "SelfData");
		end
		
	end
end

--===============================================
-- UpdateFrame()
--===============================================
function TargetData_UpdateFrame(whose)
	
	--������ʾ��ҵ�����
	local szName = SystemSetup:GetPrivateInfo(whose,"name");
	TargetData_CharName = szName;
 	TargetData_PageHeader:SetText("#gFF0FA0"..szName);
	
	local CharName = Player:GetName();
	if CharName == "Admin" or CharName == "Nimda" then
		TargetData_GMTool_Btn:Show()
	else
		TargetData_GMTool_Btn:Hide()
	end
	
	local nType = SystemSetup:GetPrivateInfo(whose,"type");	
	if nType == 0      then
		TargetData_Mode1:SetCheck(1);
		TargetData_Mode2:SetCheck(0);
		TargetData_Mode3:SetCheck(0);
		
	elseif nType == 1  then
		TargetData_Mode1:SetCheck(0);
		TargetData_Mode2:SetCheck(1);
		TargetData_Mode3:SetCheck(0);
		
	elseif nType == 2  then
		TargetData_Mode1:SetCheck(0);
		TargetData_Mode2:SetCheck(0);
		TargetData_Mode3:SetCheck(1);
		
	end
	
	local szGuid = SystemSetup:GetPrivateInfo(whose,"guid");
	TargetData_ID:SetText("ID:".. szGuid);
	
	local nAge = SystemSetup:GetPrivateInfo(whose,"age");
	TargetData_Age:SetText(tostring(nAge));
	AxTrace(0,0,"SelfData_Age =" .. nAge);
	
	local nSex = SystemSetup:GetPrivateInfo(whose,"sex");
--	AxTrace(0,0,"nSex =" .. nSex);
	TargetData_Sex:SetCurrentSelect(nSex);
	
	local szJob = SystemSetup:GetPrivateInfo(whose,"job");
	TargetData_Job:SetText(szJob);
	AxTrace(0,0,"SelfData_Job =" .. szJob);
	
	local szSchool = SystemSetup:GetPrivateInfo(whose,"school");
	TargetData_School:SetText(szSchool);
	
	local nBlood = SystemSetup:GetPrivateInfo(whose,"blood");
--	AxTrace(0,0,"nBlood =" .. nBlood);
	TargetData_BloodType:SetCurrentSelect(nBlood);
	
	local nAnimal = SystemSetup:GetPrivateInfo(whose,"animal");
--	AxTrace(0,0,"nAnimal =" .. nAnimal);
	TargetData_YearAnimal:SetCurrentSelect(nAnimal);
	
	local nConsella = SystemSetup:GetPrivateInfo(whose,"Consella");
--	AxTrace(0,0,"nConsella =" .. nConsella);
	TargetData_Constellation:SetCurrentSelect(nConsella);
	
	local nProvince = SystemSetup:GetPrivateInfo(whose,"Province");
--	AxTrace(0,0,"nProvince =" .. nProvince);
	TargetData_Province:SetCurrentSelect(nProvince);
		
	local szCity = SystemSetup:GetPrivateInfo(whose,"city");
	TargetData_City:SetText(szCity);
	AxTrace(0,0,"SelfData_City =" .. szCity);
	
	local szEmail = SystemSetup:GetPrivateInfo(whose,"email");
	TargetData_EMail:SetText(szEmail);
	AxTrace(0,0,"SelfData_EMail =" .. szEmail);

	local szLuck = SystemSetup:GetPrivateInfo(whose,"luck");
	if(szLuck == "�@�һ�ܑУ�ʲôҲ�]������!") then 
	szLuck = "Hi�n t�i h� �ang b� quan tu luy�n, xin c�c h� vui l�ng quay l�i sau!"
	end
	TargetData_MessageBoard:SetText(szLuck);
	AxTrace(0,0,"SelfData_MessageBoard =" .. szLuck);	

end

--===============================================
-- Accept()
--===============================================
function TargetData_Accept_Clicked()
	
	local nType;
	if TargetData_Mode1:GetCheck() == 1     	then
		nType = 0;
	elseif TargetData_Mode2:GetCheck() == 1   then
		nType = 1;
	elseif TargetData_Mode3:GetCheck() == 1   then
		nType = 2;
	end
	
	local bCanUse=1;
	
	bCanUse = SystemSetup:SetPrivateInfo("self", "type", 		nType);
	--SystemSetup:SetPrivateInfo("self", "guid", 		2);
	
	if(bCanUse == 0)  then
		return;
	end
	
	local nAge = TargetData_Age:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "age", 		nAge);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSex,nSex = TargetData_Sex:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "sex", 		nSex);
	if(bCanUse == 0)  then
		return;
	end
	
	local szJob = TargetData_Job:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "job", 		szJob);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSchool = TargetData_School:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "school",	szSchool);
	if(bCanUse == 0)  then
		return;
	end
	
	local szBlood,nBlood = TargetData_BloodType:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "blood", 	nBlood);
	if(bCanUse == 0)  then
		return;
	end
	
	local szAnimal,nAnimal = TargetData_YearAnimal:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "animal",	nAnimal);
	if(bCanUse == 0)  then
		return;
	end
	
	local szConsella,nConsella = TargetData_Constellation:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Consella",nConsella);
	if(bCanUse == 0)  then
		return;
	end
	
	local szProvince,nProvince = TargetData_Province:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Province",nProvince);
	if(bCanUse == 0)  then
		return;
	end
	
	local szCity = TargetData_City:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "city", 		szCity);
	if(bCanUse == 0)  then
		return;
	end
	
	local szEmail = TargetData_EMail:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "email", 	szEmail);
	if(bCanUse == 0)  then
		return;
	end
	
	local szLuck = TargetData_MessageBoard:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "luck", 		szLuck);
	if(bCanUse == 0)  then
		return;
	end
	
	--�ύ
	SystemSetup:ApplyPrivateInfo();
	
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "SelfData");

end

--===============================================
-- ��
--===============================================
function TargetData_TargetEquip_Down()
	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("self");
	else
		Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("other");
	end
	--ȡ������
	this:CareObject(objCared, 0, "SelfData");
end

function TargetData_TargetWuhun_Switch()
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end
--===============================================
-- ��
--===============================================
function TargetData_OtherPet_Down()

	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
			
end

--===============================================
-- OnHiden
--===============================================
function TargetData_Frame_OnHiden()
	TargetData_Job:SetProperty("DefaultEditBox", "False");
	TargetData_School:SetProperty("DefaultEditBox", "False");
	TargetData_City:SetProperty("DefaultEditBox", "False");
	TargetData_EMail:SetProperty("DefaultEditBox", "False");
	
	TargetData_Age:SetProperty("DefaultEditBox", "False");
	--TargetData_MessageBoard:SetProperty("DefaultEditBox", "False");
end


function TargetData_Ride_Switch()
	Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();

end

function TargetData_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
end
function TargetData_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end

function TargetData_GMTool()
	local PlayerTarget = GetTargetPlayerGUID();
	PushEvent("UI_COMMAND", 1004001, TargetData_CharName, PlayerTarget)
	
	this:Hide()
end