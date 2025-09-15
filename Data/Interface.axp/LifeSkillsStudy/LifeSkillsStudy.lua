local g_nAbilityID = -1;

local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

--===============================================
-- OnLoad()
--===============================================
function LifeSkillsStudy_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("TOGLE_ABILITY_STUDY");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("OBJECT_CARED_EVENT");

end

function LifeSkillsStudy_OnLoad()
	
end										

--===============================================
-- LifeSkillsStudy_OnEvent
--===============================================
function LifeSkillsStudy_OnEvent(event)
	if(event == "TOGLE_ABILITY_STUDY") then
		this:Show();
		
		--���ù���NPC
		objCared = LifeAbility:GetNpcId();
		this:CareObject(objCared, 1, "AbilityStudy");
	
		LifeSkillsStudy_UpdateFrame();
		LifeSkillsStudy_UpLevel:Enable();
		
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 713587 ) then
		if g_nAbilityID ~= -1 then
			local nLevel = Player:GetAbilityInfo(g_nAbilityID, "level");
			local nMaxLevel = Player:GetAbilityInfo(g_nAbilityID, "maxlevel");
			LifeSkillsStudy_SkillLevel:SetText("K� n�ng: ".. tostring(nLevel).."/"..tostring(nMaxLevel));
		end
				
	elseif(event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			Bank:Close();

			--ȡ������
			this:CareObject(objCared, 0, "AbilityStudy");
		end
		
	elseif(event == "UNIT_MONEY" and this:IsVisible()) then
		local nMoneyNow = Player:GetData("MONEY");
		LifeSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
		
	elseif(event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		
		LifeSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif(event == "UNIT_LEVEL" and this:IsVisible()) then 
		
		
	elseif(event == "UNIT_EXP" and this:IsVisible()) then
		local nExpNow = Player:GetData("EXP");
		LifeSkillsStudy_CurrentlyExp_Character_Text:SetText("EXP c�: " .. tostring(nExpNow));
		
	end
	
end

--===============================================
-- LifeSkillsStudy_UpdateFrame
--===============================================
function LifeSkillsStudy_UpdateFrame()

	--����ID
	g_nAbilityID = AbilityTeacher:GetAbilityID();
	
	
	--��ǰ�Ľ�Ǯ
	local nMoneyNow = Player:GetData("MONEY");
	LifeSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	
	--��ǰ�Ľ���
	LifeSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

	--��Ҫ�Ľ�Ǯ
	nMoneyNow,nGold,nSilverCoin,nCopperCoin = AbilityTeacher:GetNeedMoney();
	LifeSkillsStudy_Demand_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));

	--��ǰ�ľ���
	local nExpNow = Player:GetData("EXP");
	LifeSkillsStudy_CurrentlyExp_Character_Text:SetText("EXP c�: " .. tostring(nExpNow));
	
	--��Ҫ�ľ���
	local nNeedExp = AbilityTeacher:GetNeedExp();
	LifeSkillsStudy_DemandExp_Character_Text:SetText("EXP c�n: " .. tostring(nNeedExp));

	ActionSkillsStudy_UpdateAbility(g_nAbilityID);
end


--===============================================
-- ���������
--===============================================
function ActionSkillsStudy_UpdateAbility(nAbilityID)

	local nAbilityNum = GetActionNum("life");
	
	for i=0, nAbilityNum do
	
		local theAction = EnumAction(i, "life");
		if theAction:GetDefineID() == nAbilityID then
		
			if theAction:GetID() == 0 then
				LifeSkillsStudy_Icon:SetActionItem(-1);
			else
				LifeSkillsStudy_Icon:SetActionItem(theAction:GetID());
				
				-- ���������
				local szName = theAction:GetName();
				-- ����ܵĵȼ�
				local nLevel = Player:GetAbilityInfo(nAbilityID, "level");
				-- ����ܵ����ȼ�
				local nMaxLevel = Player:GetAbilityInfo(nAbilityID, "maxlevel");
				-- �����������
				local nSkillExp = Player:GetAbilityInfo(nAbilityID, "skillexp");
				-- ����ܽ���
				local szExplain = Player:GetAbilityInfo(nAbilityID, "explain");			
				
				local nNeedLevel    = AbilityTeacher:GetNeedLevel();
				-- local nLevel        = Player:GetData("LEVEL");
				
				local nNeedSkillExp = AbilityTeacher:GetNeedSkillExp();
				
				LifeSkillsStudy_SkillName:SetText(szName);
				LifeSkillsStudy_SkillLevel:SetText("K� n�ng: ".. tostring(nLevel).."/"..tostring(nMaxLevel));
				LifeSkillsStudy_skilledDegree:SetText("Th�ng th�o: "..tostring(nSkillExp) .. "/" .. tostring(nNeedSkillExp) );
				LifeSkillsStudy_PlayerLevel:SetText("��ng c�p: " .. tostring(nNeedLevel));
				
				LifeSkillsStudy_Explain_Desc:SetText("  "..szExplain);
			end
		end
	end

end

function LifeSkillsStudy_UpLevel_Click()


	-- ��÷������ű���һЩ���ݣ�Ȼ���ٴ�ȥ���÷���������Щ����
	local ScriptId = AbilityTeacher:GetServerData("scriptid");
	local NpcId    = AbilityTeacher:GetServerData("npcid");

	Player:AskLeanAbility(g_nAbilityID, NpcId);
	
	--���رմ��ڣ�ֻ������ѧϰ��ťDisable
	LifeSkillsStudy_UpLevel:Disable();
	--this:Hide()
		
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnDefaultEvent");
		Set_XSCRIPT_ScriptID(ScriptId);
		Set_XSCRIPT_Parameter(0,NpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
	--this:CareObject(objCared, 0, "AbilityStudy");

end 


function LifeSkillsStudy_Close()
	this:Hide()
	this:CareObject(objCared, 0, "AbilityStudy");

	
end