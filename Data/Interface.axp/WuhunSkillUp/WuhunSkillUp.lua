--  WuhunSkillUp
local m_UI_NUM = 20090723
local WuhunSkillUp_Index = -1
local m_ObjCared = -1
local m_Equip_Idx = -1

local VoHon_Skill1ID = {}
	VoHon_Skill1ID[1] = {32002001}
	VoHon_Skill1ID[2] = {32002002}
	VoHon_Skill1ID[3] = {32002003}
	VoHon_Skill1ID[4] = {32002004}
	VoHon_Skill1ID[5] = {32002005}
	VoHon_Skill1ID[6] = {32002006}
	VoHon_Skill1ID[7] = {32002007}
	VoHon_Skill1ID[8] = {32002008}
	VoHon_Skill1ID[9] = {32002009}
	VoHon_Skill1ID[10] = {32002010}
	VoHon_Skill1ID[11] = {32002011}
	VoHon_Skill1ID[12] = {32002012}
	VoHon_Skill1ID[13] = {32002013}
	VoHon_Skill1ID[14] = {32002014}
	VoHon_Skill1ID[15] = {32002015}
	VoHon_Skill1ID[16] = {32002016}
	VoHon_Skill1ID[17] = {32002017}
	VoHon_Skill1ID[18] = {32002018}
	VoHon_Skill1ID[19] = {32002019}
	VoHon_Skill1ID[20] = {32002020}
	VoHon_Skill1ID[21] = {32002021}
	VoHon_Skill1ID[22] = {32002022}
	VoHon_Skill1ID[23] = {32002023}
	VoHon_Skill1ID[24] = {32002024}
	
local VoHon_Skill2ID = {}
	VoHon_Skill2ID[1] = {32002025}
	VoHon_Skill2ID[2] = {32002026}
	VoHon_Skill2ID[3] = {32002027}
	VoHon_Skill2ID[4] = {32002028}
	VoHon_Skill2ID[5] = {32002029}
	VoHon_Skill2ID[6] = {32002030}
	VoHon_Skill2ID[7] = {32002031}
	VoHon_Skill2ID[8] = {32002032}
	VoHon_Skill2ID[9] = {32002033}
	VoHon_Skill2ID[10] = {32002034}
	VoHon_Skill2ID[11] = {32002035}
	VoHon_Skill2ID[12] = {32002036}
	VoHon_Skill2ID[13] = {32002037}
	VoHon_Skill2ID[14] = {32002038}
	VoHon_Skill2ID[15] = {32002039}
	VoHon_Skill2ID[16] = {32002040}
	VoHon_Skill2ID[17] = {32002041}
	VoHon_Skill2ID[18] = {32002042}
	VoHon_Skill2ID[19] = {32002043}
	VoHon_Skill2ID[20] = {32002044}
	VoHon_Skill2ID[21] = {32002045}
	VoHon_Skill2ID[22] = {32002046}
	VoHon_Skill2ID[23] = {32002047}
	VoHon_Skill2ID[24] = {32002048}
	VoHon_Skill2ID[25] = {32002049}
	VoHon_Skill2ID[26] = {32002050}
	VoHon_Skill2ID[27] = {32002051}
	VoHon_Skill2ID[28] = {32002052}
	VoHon_Skill2ID[29] = {32002053}
	VoHon_Skill2ID[30] = {32002054}
	VoHon_Skill2ID[31] = {32002055}
	VoHon_Skill2ID[32] = {32002056}
	VoHon_Skill2ID[33] = {32002057}
	VoHon_Skill2ID[34] = {32002058}
	VoHon_Skill2ID[35] = {32002059}
	VoHon_Skill2ID[36] = {32002060}
	VoHon_Skill2ID[37] = {32002061}
	VoHon_Skill2ID[38] = {32002062}
	VoHon_Skill2ID[39] = {32002063}
	VoHon_Skill2ID[40] = {32002064}
	VoHon_Skill2ID[41] = {32002065}
	VoHon_Skill2ID[42] = {32002066}
	VoHon_Skill2ID[43] = {32002067}
	VoHon_Skill2ID[44] = {32002068}
	VoHon_Skill2ID[45] = {32002069}
	VoHon_Skill2ID[46] = {32002070}
	VoHon_Skill2ID[47] = {32002071}
	VoHon_Skill2ID[48] = {32002072}
	VoHon_Skill2ID[49] = {32002073}
	VoHon_Skill2ID[50] = {32002074}
	VoHon_Skill2ID[51] = {32002075}
	VoHon_Skill2ID[52] = {32002076}
	VoHon_Skill2ID[53] = {32002077}
	VoHon_Skill2ID[54] = {32002078}
	VoHon_Skill2ID[55] = {32002079}
	VoHon_Skill2ID[56] = {32002080}
	VoHon_Skill2ID[57] = {32002081}
	VoHon_Skill2ID[58] = {32002082}
	VoHon_Skill2ID[59] = {32002083}
	VoHon_Skill2ID[60] = {32002084}
	VoHon_Skill2ID[61] = {32002085}
	VoHon_Skill2ID[62] = {32002086}
	VoHon_Skill2ID[63] = {32002087}
	VoHon_Skill2ID[64] = {32002088}
	VoHon_Skill2ID[65] = {32002089}
	VoHon_Skill2ID[66] = {32002090}
	VoHon_Skill2ID[67] = {32002091}
	VoHon_Skill2ID[68] = {32002092}
	VoHon_Skill2ID[69] = {32002093}
	VoHon_Skill2ID[70] = {32002094}
	VoHon_Skill2ID[71] = {32002095}
	VoHon_Skill2ID[72] = {32002096}
	VoHon_Skill2ID[73] = {32002097}
	VoHon_Skill2ID[74] = {32002098}
	VoHon_Skill2ID[75] = {32002099}
	VoHon_Skill2ID[76] = {32002100}
	VoHon_Skill2ID[77] = {32002101}
	VoHon_Skill2ID[78] = {32002102}
	VoHon_Skill2ID[79] = {32002103}
	VoHon_Skill2ID[80] = {32002104}
	VoHon_Skill2ID[81] = {32002105}
	VoHon_Skill2ID[82] = {32002106}
	VoHon_Skill2ID[83] = {32002107}
	VoHon_Skill2ID[84] = {32002108}
	VoHon_Skill2ID[85] = {32002109}
	VoHon_Skill2ID[86] = {32002110}
	VoHon_Skill2ID[87] = {32002111}
	VoHon_Skill2ID[88] = {32002112}
	VoHon_Skill2ID[89] = {32002113}
	VoHon_Skill2ID[90] = {32002114}
	VoHon_Skill2ID[91] = {32002115}
	VoHon_Skill2ID[92] = {32002116}
	VoHon_Skill2ID[93] = {32002117}
	VoHon_Skill2ID[94] = {32002118}
	VoHon_Skill2ID[95] = {32002119}
	VoHon_Skill2ID[96] = {32002120}
	VoHon_Skill2ID[97] = {32002121}
	VoHon_Skill2ID[98] = {32002122}
	VoHon_Skill2ID[99] = {32002123}
	VoHon_Skill2ID[100] = {32002124}
	VoHon_Skill2ID[101] = {32002125}
	VoHon_Skill2ID[102] = {32002126}
	VoHon_Skill2ID[103] = {32002127}
	VoHon_Skill2ID[104] = {32002128}
	VoHon_Skill2ID[105] = {32002129}
	VoHon_Skill2ID[106] = {32002130}
	VoHon_Skill2ID[107] = {32002131}
	VoHon_Skill2ID[108] = {32002132}
	VoHon_Skill2ID[109] = {32002133}
	VoHon_Skill2ID[110] = {32002134}
	VoHon_Skill2ID[111] = {32002135}
	VoHon_Skill2ID[112] = {32002136}
	VoHon_Skill2ID[113] = {32002137}
	VoHon_Skill2ID[114] = {32002138}
	VoHon_Skill2ID[115] = {32002139}
	VoHon_Skill2ID[116] = {32002140}
	VoHon_Skill2ID[117] = {32002141}
	VoHon_Skill2ID[118] = {32002142}
	VoHon_Skill2ID[119] = {32002143}
	VoHon_Skill2ID[120] = {32002144}
	VoHon_Skill2ID[121] = {32002145}
	VoHon_Skill2ID[122] = {32002146}
	VoHon_Skill2ID[123] = {32002147}
	VoHon_Skill2ID[124] = {32002148}
	VoHon_Skill2ID[125] = {32002149}
	VoHon_Skill2ID[126] = {32002150}
	VoHon_Skill2ID[127] = {32002151}
	VoHon_Skill2ID[128] = {32002152}
	VoHon_Skill2ID[129] = {32002153}
	VoHon_Skill2ID[130] = {32002154}
	VoHon_Skill2ID[131] = {32002155}
	VoHon_Skill2ID[132] = {32002156}
	
local VoHon_Skill3ID = {}
	VoHon_Skill3ID[1] = {32002157}
	VoHon_Skill3ID[2] = {32002158}
	VoHon_Skill3ID[3] = {32002159}
	VoHon_Skill3ID[4] = {32002160}
	VoHon_Skill3ID[5] = {32002161}
	VoHon_Skill3ID[6] = {32002162}
	VoHon_Skill3ID[7] = {32002163}
	VoHon_Skill3ID[8] = {32002164}
	VoHon_Skill3ID[9] = {32002165}
	VoHon_Skill3ID[10] = {32002166}
	VoHon_Skill3ID[11] = {32002167}
	VoHon_Skill3ID[12] = {32002168}
	VoHon_Skill3ID[13] = {32002169}
	VoHon_Skill3ID[14] = {32002170}
	VoHon_Skill3ID[15] = {32002171}
	VoHon_Skill3ID[16] = {32002172}
	VoHon_Skill3ID[17] = {32002173}
	VoHon_Skill3ID[18] = {32002174}
	VoHon_Skill3ID[19] = {32002175}
	VoHon_Skill3ID[20] = {32002176}
	VoHon_Skill3ID[21] = {32002177}
	VoHon_Skill3ID[22] = {32002178}
	VoHon_Skill3ID[23] = {32002179}
	VoHon_Skill3ID[24] = {32002180}
	VoHon_Skill3ID[25] = {32002181}
	VoHon_Skill3ID[26] = {32002182}
	VoHon_Skill3ID[27] = {32002183}
	VoHon_Skill3ID[28] = {32002184}
	VoHon_Skill3ID[29] = {32002185}
	VoHon_Skill3ID[30] = {32002186}
	VoHon_Skill3ID[31] = {32002187}
	VoHon_Skill3ID[32] = {32002188}
	VoHon_Skill3ID[33] = {32002189}
	VoHon_Skill3ID[34] = {32002190}
	VoHon_Skill3ID[35] = {32002191}
	VoHon_Skill3ID[36] = {32002192}
	VoHon_Skill3ID[37] = {32002193}
	VoHon_Skill3ID[38] = {32002194}
	VoHon_Skill3ID[39] = {32002195}
	VoHon_Skill3ID[40] = {32002196}
	VoHon_Skill3ID[41] = {32002197}
	VoHon_Skill3ID[42] = {32002198}
	VoHon_Skill3ID[43] = {32002199}
	VoHon_Skill3ID[44] = {32002200}
	VoHon_Skill3ID[45] = {32002201}
	VoHon_Skill3ID[46] = {32002202}
	VoHon_Skill3ID[47] = {32002203}
	VoHon_Skill3ID[48] = {32002204}
	VoHon_Skill3ID[49] = {32002205}
	VoHon_Skill3ID[50] = {32002206}
	VoHon_Skill3ID[51] = {32002207}
	VoHon_Skill3ID[52] = {32002208}
	VoHon_Skill3ID[53] = {32002209}
	VoHon_Skill3ID[54] = {32002210}
	VoHon_Skill3ID[55] = {32002211}
	VoHon_Skill3ID[56] = {32002212}
	VoHon_Skill3ID[57] = {32002213}
	VoHon_Skill3ID[58] = {32002214}
	VoHon_Skill3ID[59] = {32002215}
	VoHon_Skill3ID[60] = {32002216}
	VoHon_Skill3ID[61] = {32002217}
	VoHon_Skill3ID[62] = {32002218}
	VoHon_Skill3ID[63] = {32002219}
	VoHon_Skill3ID[64] = {32002220}
	VoHon_Skill3ID[65] = {32002221}
	VoHon_Skill3ID[66] = {32002222}
	VoHon_Skill3ID[67] = {32002223}
	VoHon_Skill3ID[68] = {32002224}
	VoHon_Skill3ID[69] = {32002225}
	VoHon_Skill3ID[70] = {32002226}
	VoHon_Skill3ID[71] = {32002227}
	VoHon_Skill3ID[72] = {32002228}
	VoHon_Skill3ID[73] = {32002229}
	VoHon_Skill3ID[74] = {32002230}
	VoHon_Skill3ID[75] = {32002231}
	VoHon_Skill3ID[76] = {32002232}
	VoHon_Skill3ID[77] = {32002233}
	VoHon_Skill3ID[78] = {32002234}
	VoHon_Skill3ID[79] = {32002235}
	VoHon_Skill3ID[80] = {32002236}
	VoHon_Skill3ID[81] = {32002237}
	VoHon_Skill3ID[82] = {32002238}
	VoHon_Skill3ID[83] = {32002239}
	VoHon_Skill3ID[84] = {32002240}

local Skills = {}
local skillSelected = -1
local Kfs_Skill_ID = {}
--PreLoad
function WuhunSkillUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_SKILLUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

--OnLoad
function WuhunSkillUp_OnLoad()
	Skills[1] = WuhunSkillUp_Object2
	Skills[2] = WuhunSkillUp_Object3
	Skills[3] = WuhunSkillUp_Object4
end

function WuhunSkillUp_ClearItem()
	if WuhunSkillUp_Index ~= -1 then
		WuhunSkillUp_Object1:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunSkillUp_Index, 0 )
		WuhunSkillUp_Index = -1
		skillSelected = -1
		WuhunSkillUp_Object2:SetActionItem(-1)
		WuhunSkillUp_Object3:SetActionItem(-1)
		WuhunSkillUp_Object4:SetActionItem(-1)
	end

	if WuhunSkillUp_Index == -1 or skillSelected == -1 then
		WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 0)
		WuhunSkillUp_OK:Disable()
	end
end

function WuhunSkillUp_UpdateItem(Pos)
	if WuhunSkillUp_Index == -1 then
		local Index = EnumAction(Pos, "packageitem")
		local IndexID = Index:GetDefineID()
		if IndexID == -1 then
			return
		end
		
		if IndexID < 10308001 or IndexID > 10308004 then
			PushDebugMessage("N½i này chï có th¬ ð£t vào Võ H°n.")
			return
		end
		
		WuhunSkillUp_Object1:SetActionItem(Index:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunSkillUp_Index = Pos
		
		WuhunSkillUp_LoadSkill()
	end
	
	if WuhunSkillUp_Index ~= -1 and skillSelected ~= -1 then
		WuhunSkillUp_OK:Enable()
		WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunSkillUp_OK:Disable()
		WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

function WuhunSkillUp_LoadSkill()
	local WuhunAuthor = GlobalWuhunAuthor()
	if WuhunAuthor ~= "No_Author" then
		local VoHon_Skill1 = string.sub(WuhunAuthor,35,36);
		if VoHon_Skill1 ~= "--" then
			VoHon_Skill1 = tonumber(VoHon_Skill1);
			local VoHonID = VoHon_Skill1ID[VoHon_Skill1][1];
			local VoHonIDObject = GemCarve:UpdateProductAction( VoHonID )
			WuhunSkillUp_Object2:SetActionItem(VoHonIDObject:GetID())
		else
			WuhunSkillUp_Object2:SetActionItem(-1)
		end
		
		local VoHon_Skill2 = string.sub(WuhunAuthor,37,39);
		if VoHon_Skill2 ~= "---" then
			VoHon_Skill2 = tonumber(VoHon_Skill2);
			local VoHonID = VoHon_Skill2ID[VoHon_Skill2][1];
			local VoHonIDObject = GemCarve:UpdateProductAction( VoHonID )
			WuhunSkillUp_Object3:SetActionItem(VoHonIDObject:GetID())
		else
			WuhunSkillUp_Object3:SetActionItem(-1)
		end
		
		local VoHon_Skill3 = string.sub(WuhunAuthor,40,41);
		if VoHon_Skill3 ~= "--" then
			VoHon_Skill3 = tonumber(VoHon_Skill3);
			local VoHonID = VoHon_Skill3ID[VoHon_Skill3][1];
			local VoHonIDObject = GemCarve:UpdateProductAction( VoHonID )
			WuhunSkillUp_Object4:SetActionItem(VoHonIDObject:GetID())
		else
			WuhunSkillUp_Object4:SetActionItem(-1)
		end
	else
		WuhunSkillUp_Object2:SetActionItem(-1)
		WuhunSkillUp_Object3:SetActionItem(-1)
		WuhunSkillUp_Object4:SetActionItem(-1)
	end
end

--OnEvent
function WuhunSkillUp_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017) then
		if IsWindowShow("WuhunSkillUp") then
			WuhunSkillUp_UpdateItem(tonumber(arg1))
		end
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunSkillUp_OK:Disable()
		WuhunSkillUp_BeginCareObj( Get_XParam_INT(0) );
		
		WuhunSkillUp_Update(-1)
		this:Show();
	elseif (event == "UPDATE_KFS_SKILLUP" and this:IsVisible() ) then
		
		if arg0 ~= nil then
			WuhunSkillUp_Update( tonumber(arg0) )
		end
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunSkillUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunSkillUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		WuhunSkillUp_UICheck()
	end
end

--Update UI
function WuhunSkillUp_Update(itemIdx)
	WuhunSkillUp_UICheck()
end
--OnOK
function WuhunSkillUp_OK_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(45001)
		Set_XSCRIPT_Parameter(0, 1077) 
		Set_XSCRIPT_Parameter(1, WuhunSkillUp_Index)
		Set_XSCRIPT_Parameter(2, skillSelected)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	
	WuhunSkillUp_OnHiden()
end


--select a skill
function WuhunSkillUp_Select_Skill(skill_index)
	Skills[1]:SetPushed(0)
	Skills[2]:SetPushed(0)
	Skills[3]:SetPushed(0)

	skillSelected = skill_index + 1

	Skills[skillSelected]:SetPushed(1)

	if WuhunSkillUp_Index ~= -1 and skillSelected ~= -1 then
		WuhunSkillUp_OK:Enable()
		WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunSkillUp_OK:Disable()
		WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

--Right button clicked
function WuhunSkillUp_Resume_Equip()

	WuhunSkillUp_Update(-1)

end


--Care Obj
function WuhunSkillUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--handle Hide Event
function WuhunSkillUp_OnHiden()
	WuhunSkillUp_ClearItem();
	
	this:Hide();
end


function WuhunSkillUp_UICheck()
	WuhunSkillUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunSkillUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 

end