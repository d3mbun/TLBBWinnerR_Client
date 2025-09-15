--Bäng GM Tool 
--Coding by Sói and LucSirius
local nNumberQuality = 1
--====================================--
--====================================--
function GMToolSimple_PreLoad()
	
	--******************--
	this:RegisterEvent("UI_COMMAND")
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_OnLoad()

	--******************--
	GMToolSimple_InitData()
	--******************--

end

--====================================--
--====================================--
function GMToolSimple_OnEvent(event)
	--******************--
	if event=="UI_COMMAND" and tonumber(arg0)==11082015 then		--Truy«n v« Server ki¬m tra thông tin GM
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		GMToolSimple_ADRandom()	
		GMToolSimple_ItemQuality_Input:SetText(nNumberQuality)
	end
	--******************--
	if event=="UI_COMMAND" and tonumber(arg0)==15112015 then		--Ðã ðü ði«u ki®n ð¬ m· khung
		GMToolSimple_InitData()
		this:Show()
	end
	--******************--
	if event=="UI_COMMAND" and tonumber(arg0)==151120151 then		--Thông tin ngß¶i ch½i
		local ObjID=Get_XParam_INT(0)
		local Name=Get_XParam_STR(0)
		GMToolSimple_ObjID_Output_Screen:SetText(ObjID)
		GMToolSimple_Name_Output_Screen:SetText(Name)
	end
	--******************--
end
--====================================--
--====================================--
function GMToolSimple_Close()
	
	--******************--
	this:Hide()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_InitData()

	--******************--
	GMToolSimple_PageHeader:SetText("#b#GGameMaster Administration Tool")
	--******************--
	GMToolSimple_PlayerTextArea:SetText("#WM÷i thao tác ð«u c¥n có #Gð¯i tßþng thao tác#W, bÕn c¥n cung c¤p thông tin #GID ð¯i tßþng#W ð¬ h® th¯ng dò #GObjID#W cüa ð¯i tßþng ðó.")
	GMToolSimple_AddYuanBao_Text:SetText("Kim nguyên bäo")
	GMToolSimple_AddYuanBao_Input:SetText("")
	GMToolSimple_AddYuanBao_Btn:SetText("Duy®t")
	GMToolSimple_AddZengDian_Text:SetText("Ði¬m t£ng")
	GMToolSimple_AddZengDian_Input:SetText("")
	GMToolSimple_AddZengDian_Btn:SetText("Duy®t")
	GMToolSimple_AddMoney_Text:SetText("Vàng( 1 = 1 )")
	GMToolSimple_AddMoney_Input:SetText("")
	GMToolSimple_AddMoney_Btn:SetText("Duy®t")
	GMToolSimple_AddExp_Text:SetText("Kinh nghi®m")
	GMToolSimple_AddExp_Input:SetText("")
	GMToolSimple_AddExp_Btn:SetText("Duy®t")
	GMToolSimple_AddExpDark_Text:SetText("Add Exp Ám Khí")
	GMToolSimple_AddExpDark_Input:SetText("")
	GMToolSimple_AddExpDark_Btn:SetText("Duy®t")
	--******************--
	GMToolSimple_PlayerInfo_Text:SetText("Thông tin ngß¶i ch½i")
	GMToolSimple_ObjID_Text:SetText("ID ngß¶i ch½i:")
	GMToolSimple_ObjID_Input:SetText("")
	--GMToolSimple_ObjID_Btn:SetText("Tìm")
	GMToolSimple_ObjID_Output_Text:SetText("Object ID:")
	GMToolSimple_ObjID_Output_Screen:SetText("")
	GMToolSimple_Name_Output_Text:SetText("Tên ngß¶i ch½i:")
	GMToolSimple_Name_Output_Screen:SetText("")
	GMToolSimple_Boss_Create_Text:SetText("TÕo quái")
	GMToolSimple_BossID_Text:SetText("ID quái:")
	GMToolSimple_BossID_Input:SetText("")
	GMToolSimple_BossCreate_Btn:SetText("TÕo")
	GMToolSimple_Goto_Text:SetText("D¸ch chuy¬n")
	GMToolSimple_PosX_Text:SetText("T÷a ðµ X:")
	GMToolSimple_PosX_Input:SetText("")
	GMToolSimple_PosY_Text:SetText("T÷a ðµ Y:")
	GMToolSimple_PosY_Input:SetText("")
	GMToolSimple_SceneID_Text:SetText("ID cänh:")
	GMToolSimple_SceneID_Input:SetText("")
	GMToolSimple_Goto_Btn:SetText("D¸ch chuy¬n")
	GMToolSimple_SetMissionData_Text:SetText("C§p nh§t Mission-Data")
	GMToolSimple_MissionData_Text:SetText("ID:")
	GMToolSimple_MissionData_Input:SetText("")
	GMToolSimple_MissionDataValue_Text:SetText("Giá tr¸:")
	GMToolSimple_MissionDataValue_Input:SetText("")
	GMToolSimple_SetMissionData_Btn:SetText("Duy®t")
	GMToolSimple_CreatePet_Text:SetText("TÕo trân thú")
	GMToolSimple_PetID_Text:SetText("ID thú:")
	GMToolSimple_PetID_Input:SetText("")
	GMToolSimple_CreatePet_Btn:SetText("TÕo")
	--******************--
	GMToolSimple_ItemTextArea:SetText("#YCODE NEW BY LUCSIRIUS")
	GMToolSimple_ItemPos_Text:SetText("V¸ trí trang b¸ trên tay näi:")
	GMToolSimple_ItemPos_Input:SetText("")
	GMToolSimple_JudgeApt_Btn:SetText("Giám ð¸nh tß ch¤t")
	GMToolSimple_StrengThen_Btn:SetText("Cß¶ng hóa")
	GMToolSimple_Stileto_Btn:SetText("Ðøc l²")
	GMToolSimple_Bind_Btn:SetText("Kh¡c danh")
	GMToolSimple_GemPos_Text:SetText("V¸ trí ng÷c")
	GMToolSimple_GemPos_Input:SetText("")
	GMToolSimple_GemEnchase_Btn:SetText("Khäm ng÷c")
	GMToolSimple_DiaoWen_Btn:SetText("Ðiêu vån")
	GMToolSimple_XingZong_Btn:SetText("Tinh thông")
	GMToolSimple_Other_Text:SetText("Tính nång khác")
	GMToolSimple_XiuLian_Btn:SetText("Tu luy®n")
	GMToolSimple_SendImpact_Input:SetText("")
	GMToolSimple_SendImpact_Btn:SetText("Duy®t")
	GMToolSimple_YuanXing_Input:SetText("")
	GMToolSimple_YuanXing_Btn:SetText("Nguyên tinh")
	GMToolSimple_GMBuff_Btn:SetText("#GBUFF GAMEMASTER")
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_CharToNumber(c)

	--******************--
	local Alpha="0123456789ABCDEF"
	for i=1,string.len(Alpha) do
		if string.sub(Alpha,i,i)==c then
			return tostring(i-1)
		end
	end
	return "0"
	--******************--

end
--====================================--
--====================================--
function GMToolSimple_Power(a,n)

	--******************--
	local x="1"
	for i=1,n do
		x=GMToolSimple_Mul(x,a)
	end
	return x
	--******************--

end
--====================================--
--====================================--
function GMToolSimple_Add(a,b)
	while string.len(a)<string.len(b) do
		a="0"..a
	end
	while string.len(b)<string.len(a) do
		b="0"..b
	end
	local i=string.len(a)
	local tmp=0
	local c=""
	while i>0 do
		local x=tonumber(string.sub(a,i,i))
		local y=tonumber(string.sub(b,i,i))
		local z=x+y+tmp
		tmp=math.floor(z/10)
		z=math.mod(z,10)
		c=z..c
		i=i-1
	end
	if tmp>0 then
		c="1"..c
	end
	return c
end
--====================================--
--====================================--
function GMToolSimple_Mul(a,b)
	local i=string.len(a)
	local tmp
	local c
	local d="0"
	local j
	local count=0
	while i>0 do
		j=string.len(b)
		c=""
		tmp=0
		while j>0 do
			local x=tonumber(string.sub(a,i,i))
			local y=tonumber(string.sub(b,j,j))
			local z=x*y+tmp
			tmp=math.floor(z/10)
			z=math.mod(z,10)
			c=z..c
			j=j-1
		end
		if tmp>0 then
			c=tmp..c
		end
		for i=1,count do
			c=c.."0"
		end
		count=count+1
		d=GMToolSimple_Add(d,c)
		i=i-1
	end
	return d
end
--====================================--
--====================================--
function GMToolSimple_HexToDec(str)

	--******************--
	local Dec_Number="0"
	local i=string.len(str)
	local y={}
	local count=0
	while i>0 do
		local c=string.sub(str,string.len(str)-i+1,string.len(str)-i+1)
		local num=GMToolSimple_CharToNumber(c)
		local x=GMToolSimple_Power(16,i-1)
		x=GMToolSimple_Mul(x,num)
		Dec_Number=GMToolSimple_Add(Dec_Number,x)
		i=i-1
	end
	return tonumber(Dec_Number)
	--******************--

end
--====================================--
--====================================--
function GMToolSimple_AddYuanBao_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_AddYuanBao_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ Kim nguyên bäo c¥n thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,2)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end

function GMToolSimple_AddDMP_Clicked() -- diem mon phai
	
	--******************--
	local nNumber=tonumber(GMToolSimple_AddDMP_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ Ði¬m Môn Phái c¥n thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,22)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_AddZengDian_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_AddZengDian_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ Ði¬m t£ng c¥n thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,3)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_AddMoney_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_AddMoney_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ Vàng c¥n thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,4)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_AddExp_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_AddExp_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ Kinh nghi®m c¥n thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,5)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
-- !!!reloadscript =GMToolSimple
--====================================--
--====================================--
function GMToolSimple_AddExpDark_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_AddExpDark_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ Kinh nghi®m c¥n thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	-- if type(nNumber) >= 99999 then	
		-- PushDebugMessage("Không ðßþc nh§p quá 99999 exp")	
		-- return
	-- end	
	local str;	
	str = "adddarkexp ="..tostring( nNumber );	
	SendGMCommand( str );
	PushDebugMessage("Thao tác thành công ám khí gia tang "..nNumber.." ði¬m kinh ngi®m")	
end
function GMToolSimple_AddItemNew_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_ItemID_Input:GetText())
	local nNumberQuality=tonumber(GMToolSimple_ItemQuality_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=10000000 then
		PushDebugMessage("ID v§t ph¦m c¥n thêm vào phäi là mµt s¯ nguyên dß½ng có 8 chæ s¯!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
    if nNumberQuality < 1 then
		PushDebugMessage("M²i l¥n ít nh¤t 1 cái")
		return
	end
    if nNumberQuality > 250 then
		PushDebugMessage("T¯i ða m²i l¥n chï ðßþc 250 cái")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,6)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_Parameter(3,nNumberQuality)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	PushDebugMessage("Thao tác thành công")		
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_FindPlayer_Clicked()
	
	--******************--
	local nNumber=GMToolSimple_ObjID_Input:GetText()
	--******************--
	if string.len(nNumber)< 1 then
		PushDebugMessage("ID ngß¶i ch½i phäi có t¯i thi¬u 1 chæ s¯!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,1)
		--Set_XSCRIPT_Parameter(1,string.len(nNumber)) -- !!!reloadscript =GMToolSimple
		Set_XSCRIPT_Parameter(1,GMToolSimple_HexToDec(nNumber))
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_CreateBoss_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_BossID_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<0 then
		PushDebugMessage("ID quái c¥n thêm vào phäi là mµt s¯ nguyên không âm!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,7)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_Transfer_Clicked()
	--******************--
	local nPos_X=tonumber(GMToolSimple_PosX_Input:GetText())
	local nPos_Y=tonumber(GMToolSimple_PosY_Input:GetText())
	local nSceneID=tonumber(GMToolSimple_SceneID_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nPos_X)~="number" or nPos_X<=0 then
		PushDebugMessage("T÷a ðµ X phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nPos_Y)~="number" or nPos_Y<=0 then
		PushDebugMessage("T÷a ðµ Y phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	if nSceneID == nil then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,31)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nPos_X)
			Set_XSCRIPT_Parameter(3,nPos_Y)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	
		-- local str;
		-- str = "goto ="..tostring( nPos_X )..","..tostring( nPos_Y );
		-- SendGMCommand( str );	
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,8)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nSceneID)
			Set_XSCRIPT_Parameter(3,nPos_X)
			Set_XSCRIPT_Parameter(4,nPos_Y)
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
		this:Hide()				
	end
	PushDebugMessage("Thao tác thành công")	
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_SetMD_Clicked()
	
	--******************--
	local nMD_ID=tonumber(GMToolSimple_MissionData_Input:GetText())
	local nMD_Value=tonumber(GMToolSimple_MissionDataValue_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nMD_ID)~="number" then
		PushDebugMessage("ID biªn Mission-Data phäi là mµt s¯ nguyên!")
		return
	elseif type(nMD_Value)~="number" then
		PushDebugMessage("Giá tr¸ biªn Mission-Data phäi là mµt s¯ nguyên!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,9)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nMD_ID)
		Set_XSCRIPT_Parameter(3,nMD_Value)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_CreatePet_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_PetID_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<0 then
		PushDebugMessage("ID trân thú c¥n thêm vào phäi là mµt s¯ nguyên không âm!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,10)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipJudgeApt_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,11)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipStrengThen_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,12)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipAddSocket_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,13)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipBind_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,14)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipEnchaseGem_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nGem_Pos=tonumber(GMToolSimple_GemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nGem_Pos)~="number" or nGem_Pos<30 or nGem_Pos>=60 then
		PushDebugMessage("V¸ trí ng÷c c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [30..59]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,15)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_Parameter(3,nGem_Pos)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipDiaoWen_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,16)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_EquipXingZong_Clicked()
	
	--******************--
	local nEquip_Pos=tonumber(GMToolSimple_ItemPos_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nEquip_Pos)~="number" or nEquip_Pos<0 or nEquip_Pos>=30 then
		PushDebugMessage("V¸ trí trang b¸ c¥n thao tác phäi là mµt s¯ nguyên trong ðoÕn [0..29]!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,17)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nEquip_Pos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_XiuLian_Clicked()
	
	--******************--
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,18)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_Impact_Clicked(index)
	--******************--
	local nImpact_ID=tonumber(GMToolSimple_SendImpact_Input:GetText())
	local nImpact_ID2=tonumber(GMToolSimple_CancalImpact_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if  type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	if index == 1 then
		if type(nImpact_ID)~="number" or nImpact_ID<0 then
			PushDebugMessage("ID impact phäi là mµt s¯ nguyên không âm!")
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,19)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nImpact_ID)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif index == 2 then
		if type(nImpact_ID2)~="number" or nImpact_ID2<0 then
			PushDebugMessage("ID impact phäi là mµt s¯ nguyên không âm!")
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,29)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nImpact_ID2)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
	PushDebugMessage("Thao tác thành công!")	
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_AddYuanXing_Clicked()
	
	--******************--
	local nNumber=tonumber(GMToolSimple_YuanXing_Input:GetText())
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nNumber)~="number" or nNumber<=0 then
		PushDebugMessage("S¯ nguyên tinh thêm vào phäi là mµt s¯ nguyên dß½ng!")
		return
	elseif type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUpdate")
		Set_XSCRIPT_ScriptID(940020)
		Set_XSCRIPT_Parameter(0,20)
		Set_XSCRIPT_Parameter(1,nObjID)
		Set_XSCRIPT_Parameter(2,nNumber)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--******************--
	
end
--====================================--
--====================================--
function GMToolSimple_GMBuff_Clicked(index)
	
	--******************--
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	--******************--
	if type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	--******************--
	if index == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,21)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif index == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,30)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
	PushDebugMessage("Thao tác thành công")
end
function GMToolSimple_CharArtt_Clicked(idex)
	--******************--
	local nObjID=tonumber(GMToolSimple_ObjID_Output_Screen:GetText())
	local nNumber=tonumber(GMToolSimple_AddCuongLuc_Input:GetText())	
	local nNumber1=tonumber(GMToolSimple_AddNoiLuc_Input:GetText())	
	local nNumber2=tonumber(GMToolSimple_AddTheLuc_Input:GetText())	
	local nNumber3=tonumber(GMToolSimple_AddTriLuc_Input:GetText())	
	local nNumber4=tonumber(GMToolSimple_AddThanPhap_Input:GetText())	
	local nNumberpoint=tonumber(GMToolSimple_CongPoint_Input:GetText())	
	if type(nObjID)~="number" then
		PushDebugMessage("Obj ID không hþp l®!")
		return
	end
	-- !!!reloadscript =GMToolSimple
	if idex == 1 then
		if type(nNumber)~="number" or nNumber <=0 then
			PushDebugMessage("Ði¬m thuµc tính ði«n vào phäi l¾n h½n ho£c b¢ng 1!")
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,23)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nNumber)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif idex == 2 then
		if type(nNumber1)~="number" or nNumber1 <=0 then
			PushDebugMessage("Ði¬m thuµc tính ði«n vào phäi l¾n h½n ho£c b¢ng 1!")
			return
		end	
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,24)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nNumber1)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	
	elseif idex == 3 then
		if type(nNumber2)~="number" or nNumber2 <=0 then
			PushDebugMessage("Ði¬m thuµc tính ði«n vào phäi l¾n h½n ho£c b¢ng 1!")
			return
		end		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,25)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nNumber2)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	
	elseif idex == 4 then
		if type(nNumber3)~="number" or nNumber3 <=0 then
			PushDebugMessage("Ði¬m thuµc tính ði«n vào phäi l¾n h½n ho£c b¢ng 1!")
			return
		end			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,26)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nNumber3)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	
	elseif idex == 5 then
		if type(nNumber4)~="number" or nNumber4 <=0 then
			PushDebugMessage("Ði¬m thuµc tính ði«n vào phäi l¾n h½n ho£c b¢ng 1!")
			return
		end			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,27)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nNumber4)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	
	elseif idex == 6 then
		if type(nNumberpoint)~="number" or nNumberpoint <=0 then
			PushDebugMessage("Ði¬m thuµc tính ði«n vào phäi l¾n h½n ho£c b¢ng 1!")
			return
		end				
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(940020)
			Set_XSCRIPT_Parameter(0,28)
			Set_XSCRIPT_Parameter(1,nObjID)
			Set_XSCRIPT_Parameter(2,nNumberpoint)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
	PushDebugMessage("Thao tác thành công!")	
end
function GMToolSimple_ADRandom()
	GMToolSimple_ScrollInfo_Frame:ClearInfo()
	
	local ADInfo = {
				"#b#GTool này ðßþc LucSirius code và chïnh sØa lÕi",
				"#b#GAuthor By LucSirius 6/1/2023 8:05 PM",
				"#b#GGameMaster tool plus",
			}
	for i = 0 ,1 do
		local idx = math.random(1 ,3 - i)
		local str = ADInfo[idx]
		ADInfo[idx] = ADInfo[3 - i]
		ADInfo[3 - i] = str
	end
	
	for i = 1 ,3 do
		GMToolSimple_ScrollInfo_Frame:SetScrollInfoFixed(ADInfo[i])
	end
	
end

function GMToolSimple_TargetID_Clicked()
	local szGuid = SystemSetup:GetPrivateInfo("self","guid");
	GMToolSimple_ObjID_Input:SetText(szGuid)
	--PushDebugMessage("ID:"..szGuid);
--	PushEvent("UI_COMMAND",11082015)	
end
function GMToolSimple_ObjID_ListID_Changed()
end