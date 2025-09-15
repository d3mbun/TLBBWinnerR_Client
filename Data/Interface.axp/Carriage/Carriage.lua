local Price_Down = 1;
local Price_Up = 0;
local mission_index = -1;
local Carriage_Before_NPC = 0;
local Current = -1;
local Sell_Price = -1;
local Caoyun_Circle = 15
local nTransNPC = -1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

function Carriage_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
end
	
function Carriage_OnLoad()
	if(IsWindowShow("Shop_Fitting")) then
		--RestoreShopFitting();
		--CloseShopFitting();
		CloseWindow("Shop_Fitting", true);
	end
end

-- OnEvent
function Carriage_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		Carriage_FreightGroup2_Frame : Show();
		Carriage_FreightGroup1_Frame : Show()
		Carriage_Enchiridion : Hide();
--		Carriage_Enchiridion_Bak : Hide();
		if(tonumber(arg0) == 0) then
			Carriage_Quest_Shown();
		elseif(tonumber(arg0) == 1) then
			Carriage_Trade_Shown();
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--È¡Ïû¹ØÐÄ
			StopCareObject_Carriage(objCared);
		end
	end
	
	if(IsWindowShow("Shop_Fitting")) then
			CloseWindow("Shop_Fitting", true);
	end
end


function Carriage_Quest_Shown()

	local UI_ID = Get_XParam_INT(0);
	local misIndex;
	
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	if UI_ID == 4 then
			
		Carriage_Redeem:Hide();
		Carriage_Draw:Show();


		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Hide();
		
		Carriage_Freight_Sell_1_1:Hide();
		Carriage_Freight_Sell_1_2:Hide();
		Carriage_Freight_Sell_2_2:Hide();
		Carriage_Freight_Sell_2_3:Hide();
		
		Carriage_ContrabandSalt_Freight:Hide();
		Carriage_Freight5:Hide();
		Carriage_Freight6:Hide();
		Carriage_Freight7:Hide();
		
		--Carriage_Abandon:Hide();
		
		Carriage_Down:Disable();
		Carriage_Up:Disable();
		
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_1:Show();
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Buy_1:Show();
		Carriage_Money_Buy_2:Show();
		
		Carriage_Freight_Buy_1_Info : SetText("")
		Carriage_Freight_Buy_2_Info : SetText("")
		Carriage_Freight_Sell_1_Info : SetText("")
		Carriage_Freight_Sell_2_Info : SetText("")
		
		Carriage_Info1:SetText("Ð±i phiªu: ")
		Carriage_Balance:SetProperty("MoneyNumber","");
		Carriage_Info3:SetText("Th¶i c½ giäm giá th¸ trß¶ng")
		Carriage_Info4:SetText("Nâng giá")

		this:Show();
		Carriage_Before_NPC = Get_XParam_INT(1);
		AxTrace(0,1,"Carriage_Before_NPC="..Carriage_Before_NPC);
		Carriage_Place = Get_XParam_INT(2);
		
		if Carriage_Place == 1 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_LuoYang");

		elseif Carriage_Place == 3 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Suzhou");

		elseif Carriage_Place == 2 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Dali");

		elseif Carriage_Place == 4 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Blackmarket");

		end
		
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ð«");
				return;
		end
		BeginCareObject_Carriage(objCared)
		
	elseif UI_ID == 3 then
		Carriage_Draw : Hide();
		Carriage_Redeem : Show();
		--Carriage_Abandon: Show();
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnPopupBargainingUI");
			Set_XSCRIPT_ScriptID(311010);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();

		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ð«");
				return;
		end
		BeginCareObject_Carriage(objCared)
				
	elseif UI_ID == 5 then
		local UI_Detail = Get_XParam_INT(1);
		AxTrace(0,6,"UI_Detail="..UI_Detail);
		
		if UI_Detail == 1 then
			PushDebugMessage("các hÕ ðã có quân phiªu trên ngß¶i r°i, không nhanh ði v§n chuy¬n hàng hóa ði!");

		elseif UI_Detail == 2 then
			PushDebugMessage("cho các hÕ quân phiªu, bây gi¶ các hÕ là sÑ giä v§n chuy¬n cüa ÐÕi T¯ng.");
			Carriage_Draw : Hide();
			Carriage_Redeem : Show();
	
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnEnumerate");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_Parameter(0,Carriage_Before_NPC);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
				
		elseif UI_Detail == 3 then
			PushDebugMessage("TÕi hÕ l§p tÑc ð±i quân phiªu cho các hÕ.");
				
		elseif UI_Detail == 4 then
			PushDebugMessage("các hÕ không có quân phiªu, s¨ không ðßþc tiªn hành ð±i .");
				
		elseif UI_Detail == 5 then
			PushDebugMessage("các hÕ ði ð±i quân phiªu ði, l¥n giao d¸ch này ðã vßþt vßþt mÑc gi¾i hÕn.");
				
		elseif UI_Detail == 6 then
			PushDebugMessage("các hÕ làm m¤t quân phiªu r°i à!");
		
		elseif UI_Detail == 7 then
			
			local cargo = Get_XParam_INT(2)
			local cargo_name;
			
			if cargo == 1 then
				cargo_name = "Mu¯i"
			elseif cargo == 2 then
				cargo_name = "Thiªt"
			elseif cargo == 3 then
				cargo_name = " GÕo"
			end
			
			PushDebugMessage("S¯ lßþng  "..cargo_name.." kho ðã ð¥y!");
			
		elseif UI_Detail == 8 then
			
			local cargo = Get_XParam_INT(2)
			local cargo_name;
			
			if cargo == 1 then
				cargo_name = "Mu¯i"
			elseif cargo == 2 then
				cargo_name = "Thiªt"
			elseif cargo == 3 then
				cargo_name = " GÕo"
			end
			PushDebugMessage("các hÕ không có"..cargo_name.."!");
			
		elseif UI_Detail == 9 then
			
			local time_caoyun = Get_XParam_INT(2);
			PushDebugMessage("Th¶i gian h°i phøc chßa hªt!");
			local Time_Str1 = math.floor(time_caoyun/60);
			local Time_Str2 = time_caoyun - Time_Str1*60;
			PushDebugMessage(" " .. math.floor(Time_Str1) .. "Phút" ..	math.floor(Time_Str2) .."giây sau, m¾i có th¬ sØ døng lÕi kÛ nång c¥n thiªt.")
			
		elseif UI_Detail == 10 then
			PushDebugMessage("Hôm nay là hôm qua cüa ngày mai!");
			
		elseif UI_Detail == 11 then
			Refresh_My_Freight()
		
		elseif UI_Detail == 12 then
			Current = 100;
			Carriage_Quest_GuanPiao_Show();
			return

		elseif UI_Detail == 13 then
			PushDebugMessage("Th¶i gian làm lÕnh buôn bán nóng h±i ðã kªt thúc r°i!");
			
		elseif UI_Detail == 14 then
			PushDebugMessage("Th¶i gian làm lÕnh ép giá ðã kªt thúc r°i!");

		end
				
	end
	Current = UI_ID;
		
end	

function Carriage_Quest_GuanPiao_Show()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Help");

		local CD_Time_Sell = Get_XParam_INT(2)
		local CD_Time_Buy = Get_XParam_INT(3)
		local circle = Get_XParam_INT(4)
		mission_index = Get_XParam_INT(5)
		Sell_Price = Get_XParam_INT(7)
		
		AxTrace(0,1,"CD_Time_Sell="..CD_Time_Sell)
		AxTrace(0,1,"CD_Time_Buy="..CD_Time_Buy)
		
		if CD_Time_Buy > 0 then
			CD_Time_Buy = CD_Time_Buy / 60;
			if CD_Time_Buy < 1 then
				CD_Time_Buy = 1;
			end
			CD_Time_Buy = tostring(math.floor(CD_Time_Buy)).."Phút";
		else
			CD_Time_Buy = "Bây gi¶ l§p tÑc có th¬"
		end
		Carriage_Down : Disable();
		
		if CD_Time_Sell > 0 then
			CD_Time_Sell = CD_Time_Sell / 60;
			if CD_Time_Sell < 1 then
				CD_Time_Sell = 1;
			end
			CD_Time_Sell = tostring(math.floor(CD_Time_Sell)).."Phút";
		else
			CD_Time_Sell = "Bây gi¶ l§p tÑc có th¬"
		end
		Carriage_Up : Disable();
		
		Carriage_Draw : Hide();
		Carriage_Redeem : Hide();

		
		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Hide();

		Carriage_Freight_Sell_1_1:Hide();
		Carriage_Freight_Sell_1_2:Hide();
		Carriage_Freight_Sell_2_2:Hide();
		Carriage_Freight_Sell_2_3:Hide();
		
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_1:Hide();
		Carriage_Money_Sell_2:Hide();
		Carriage_Money_Buy_1:Hide();
		Carriage_Money_Buy_2:Hide();
		
		Carriage_Freight_Buy_1_Info : SetText("")
		Carriage_Freight_Buy_2_Info : SetText("")
		Carriage_Freight_Sell_1_Info : SetText("")
		Carriage_Freight_Sell_2_Info : SetText("")
		
		Carriage_Info3:SetText("Th¶i c½ giäm giá th¸ trß¶ng"..CD_Time_Buy)
		Carriage_Info4:SetText("Nâng giá"..CD_Time_Sell)
--		Carriage_Enchiridion_Bak : Show();
		local my_level = Player:GetData( "LEVEL" );
		Carriage_Enchiridion : Show();
		Carriage_Enchiridion : SetText("C¤p nhi®m vø: "..my_level.."#rS¯ l¥n v§n chuy¬n trong ngày: "..Get_XParam_INT(6));
	
		Carriage_FreightGroup2_Frame : Hide();
		Carriage_FreightGroup1_Frame : Hide()
		Refresh_My_Freight();
		StopCareObject_Carriage(objCared);
		
end


function Carriage_Trade_Shown()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	local UI_ID = Get_XParam_INT(0);


	if UI_ID == 3 then

			mission_index = Get_XParam_INT(1);
			Carriage_Trade_Update()
			this:Show();
			
	elseif UI_ID == 4 then

			mission_index = Get_XParam_INT(1);
			Carriage_Trade_Update_Price(mission_index,Price_Up);
			this:Show();
			
	elseif UI_ID == 5 then

			mission_index = Get_XParam_INT(1);
			Carriage_Trade_Update_Price(mission_index,Price_Down);
			this:Show();
			
	end
	Current = UI_ID;
end

function Carriage_Trade_Update()
--1¾ÍÊÇÂôÑÎ£¬ÂòÌú¡¢Ã×µÄ
--2¾ÍÊÇÂôÌú£¬ÂòÑÎ¡¢Ã×µÄ
--3¾ÍÊÇÂôÃ×£¬ÂòÑÎ¡¢ÌúµÄ
--4¾ÍÊÇ»õÉÌ£¬É¶¶¼ÂôµÄ
	local misIndex = mission_index;

	AxTrace(0,1,"Carriage_Trade_Update mission_index="..mission_index)
	nTransNPC = Get_XParam_INT(8)

	local CD_Time_Sell = Get_XParam_INT(6);

	local CD_Time_Buy = Get_XParam_INT(7);
	AxTrace(0,1,"CD_Time_Sell="..CD_Time_Sell)
	AxTrace(0,1,"CD_Time_Buy="..CD_Time_Buy)

	Carriage_Money_Buy_1:Hide();
	Carriage_Money_Buy_2:Hide();

	if CD_Time_Buy > 0 then
		CD_Time_Buy = CD_Time_Buy / 60;
		if CD_Time_Buy < 1 then
			CD_Time_Buy = 1;
		end
		CD_Time_Buy = tostring(math.floor(CD_Time_Buy)).."phút sau";
		Carriage_Down : Disable();
	else
		CD_Time_Buy = "Bây gi¶ l§p tÑc có th¬"
		Carriage_Down : Enable();
	end
	
	if CD_Time_Sell > 0 then
		CD_Time_Sell = CD_Time_Sell / 60;
		if CD_Time_Sell < 1 then
			CD_Time_Sell = 1;
		end
		CD_Time_Sell = tostring(math.floor(CD_Time_Sell)).."phút sau";
		Carriage_Up : Disable();
	else
		CD_Time_Sell = "Bây gi¶ l§p tÑc có th¬"
		Carriage_Up : Enable();
	end
	local Balance = DataPool:GetPlayerMission_Variable(misIndex,5)
	local Round = DataPool:GetPlayerMission_DataRound(Caoyun_Circle);
	AxTrace(0,1,"round="..Round)
	AxTrace(0,1,"Balance="..Balance)
	AxTrace(0,1,"nTransNPC="..nTransNPC)
	if nTransNPC == 1 then
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_LuoYang");
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_1_1:Show();
		Carriage_Freight_Buy_1_1:SetToolTip("Mu¯i, sän xu¤t t× LÕc Dß½ng #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Get_XParam_INT(2).."}");
		Carriage_Freight_Buy_1_Info : SetText("Mu¯i")
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(2)));
		Carriage_Money_Buy_1:Show();
			
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Hide();
		Carriage_Freight_Buy_2_Info : SetText("")
			
		Carriage_Freight_Sell_1_1:Hide();
--			Carriage_Freight_Sell_1_2:Show();
--			Carriage_Freight_Sell_1_2:SetToolTip("Ìú£¬²ú×Ô´óÀí#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_1_Info:SetText("Thiªt")
		Carriage_Money_Sell_1:Show();
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			
		Carriage_Freight_Sell_2_2:Hide();
--			Carriage_Freight_Sell_2_3:Show();
--			Carriage_Freight_Sell_2_3:SetToolTip("Ã×£¬²ú×ÔËÕÖÝ#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_2_Info : SetText(" GÕo")
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
		Sell_Price = Get_XParam_INT(3);
						
		Carriage_Down:Show();
		Carriage_Up:Show();
						
	elseif nTransNPC == 2 then
		
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Dali");
		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Show();
		Carriage_Freight_Buy_1_2:SetToolTip("S¡t, sän xu¤t t× ÐÕi Lý #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Get_XParam_INT(2).."}");
		Carriage_Freight_Buy_1_Info : SetText("Thiªt")
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(2)));
		Carriage_Money_Buy_1:Show();
			
		Carriage_Freight_Buy_2_3:Hide();
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_Info : SetText("")
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
			
		Carriage_Freight_Sell_1_2:Hide();
--			Carriage_Freight_Sell_1_1:Show();
--			Carriage_Freight_Sell_1_1:SetToolTip("ÑÎ£¬²ú×ÔÂåÑô#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_1_Info : SetText("Mu¯i")
		Carriage_Money_Sell_1:Show()
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			
		Carriage_Freight_Sell_2_2:Hide();
--			Carriage_Freight_Sell_2_3:Show();
--			Carriage_Freight_Sell_2_3:SetToolTip("Ã×£¬²ú×ÔËÕÖÝ#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_2_Info : SetText(" GÕo")
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
		Sell_Price = Get_XParam_INT(3);
			
		Carriage_Down:Show();
		Carriage_Up:Show();
		
	elseif nTransNPC == 3 then
		
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Suzhou");
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Show();
		Carriage_Freight_Buy_2_3:SetToolTip("GÕo, sän xu¤t t× Tô Châu #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Get_XParam_INT(2).."}");
		Carriage_Freight_Buy_2_Info : SetText(" GÕo")
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(2)));
		Carriage_Money_Buy_2:Show();
			
		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_1_Info : SetText("")
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
			
		Carriage_Freight_Sell_1_2:Hide();
--			Carriage_Freight_Sell_1_1:Show();
--			Carriage_Freight_Sell_1_1:SetToolTip("ÑÎ£¬²ú×ÔÂåÑô#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_1_Info : SetText("Mu¯i")
		Carriage_Money_Sell_1:Show()
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			
		Carriage_Freight_Sell_2_3:Hide();
--			Carriage_Freight_Sell_2_2:Show();
--			Carriage_Freight_Sell_2_2:SetToolTip("Ìú£¬²ú×Ô´óÀí#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_2_Info : SetText("Thiªt")
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
		Sell_Price = Get_XParam_INT(3);
						
		Carriage_Down:Show();
		Carriage_Up:Show();
		
	elseif nTransNPC == 4 then
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Blackmarket");
		Carriage_Draw : Hide();
		Carriage_Redeem : Hide();
		if(Get_XParam_INT(5) == 1) then
			
			Carriage_Freight_Buy_1_2:Hide();
			Carriage_Freight_Buy_1_1:Hide();
			Carriage_Freight_Buy_1_Info : SetText("")
			Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Buy_2_2:Hide();
			Carriage_Freight_Buy_2_3:Hide();
			Carriage_Freight_Buy_2_Info : SetText("")
			Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Sell_1_1:Hide();
			Carriage_Freight_Sell_1_2:Hide();
--				Carriage_Freight_Sell_1_2:Show();
--				Carriage_Freight_Sell_1_2:SetToolTip("Ìú£¬²ú×Ô´óÀí#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_1_Info : SetText("Thiªt")
			Carriage_Money_Sell_1:Show()
			Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
				
			Carriage_Freight_Sell_2_3:Hide();
			Carriage_Freight_Sell_2_2:Hide();
--				Carriage_Freight_Sell_2_3:Show();
--				Carriage_Freight_Sell_2_3:SetToolTip("Ã×£¬²ú×ÔËÕÖÝ#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_2_Info : SetText(" GÕo")
			Carriage_Money_Sell_2:Show();
			Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			Sell_Price = Get_XParam_INT(3);
				
			Carriage_Down:Disable();
			Carriage_Up:Show();
				
		elseif(Get_XParam_INT(5) == 2) then
			
			Carriage_Freight_Buy_1_1:Hide();
			Carriage_Freight_Buy_1_2:Hide();
			Carriage_Freight_Buy_1_Info : SetText("")
			Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Buy_2_3:Hide();
			Carriage_Freight_Buy_2_2:Hide();
			Carriage_Freight_Buy_2_Info : SetText("")
			Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Sell_1_2:Hide();
			Carriage_Freight_Sell_1_1:Hide();
--				Carriage_Freight_Sell_1_1:Show();
--				Carriage_Freight_Sell_1_1:SetToolTip("ÑÎ£¬²ú×ÔÂåÑô#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_1_Info : SetText("Mu¯i")
			Carriage_Money_Sell_1:Show()
			Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
				
			Carriage_Freight_Sell_2_2:Hide();
			Carriage_Freight_Sell_2_3:Hide();
--				Carriage_Freight_Sell_2_3:Show();
--				Carriage_Freight_Sell_2_3:SetToolTip("Ã×£¬²ú×ÔËÕÖÝ#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_2_Info : SetText(" GÕo")
			Carriage_Money_Sell_2:Show();
			Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			Sell_Price = Get_XParam_INT(3);
				
			Carriage_Down:Disable();
			Carriage_Up:Show();
				
		elseif(Get_XParam_INT(5) == 3) then
			
			Carriage_Freight_Buy_2_2:Hide();
			Carriage_Freight_Buy_2_3:Hide();
			Carriage_Freight_Buy_1_Info : SetText("")
			Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Buy_1_1:Hide();
			Carriage_Freight_Buy_1_2:Hide();
			Carriage_Freight_Buy_2_Info : SetText("")
			Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Sell_1_2:Hide();
			Carriage_Freight_Sell_1_1:Hide();
--				Carriage_Freight_Sell_1_1:Show();
--				Carriage_Freight_Sell_1_1:SetToolTip("ÑÎ£¬²ú×ÔÂåÑô#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_1_Info : SetText("Mu¯i")
			Carriage_Money_Sell_1:Show()
			Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
				
			Carriage_Freight_Sell_2_3:Hide();
			Carriage_Freight_Sell_2_2:Hide();
--				Carriage_Freight_Sell_2_2:Show();
--				Carriage_Freight_Sell_2_2:SetToolTip("Ìú£¬²ú×Ô´óÀí#rµã»÷Âô³ö#rµ±Ç°¼Û¸ñ: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_2_Info : SetText("Thiªt")
			Carriage_Money_Sell_2:Show();
			Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			Sell_Price = Get_XParam_INT(3);
				
			Carriage_Down:Disable();
			Carriage_Up:Show();
		end
	

	end

	Carriage_Info1:SetText("Ð±i phiªu: ")
	Carriage_Balance:SetProperty("MoneyNumber",tostring(Balance));
	Carriage_Info3:SetText("Th¶i c½ giäm giá th¸ trß¶ng"..CD_Time_Buy)
	Carriage_Info4:SetText("Nâng giá"..CD_Time_Sell)
		
	Carriage_Freight_Sell_1_1:Hide();
	Carriage_Freight_Sell_1_2:Hide();
	Carriage_Freight_Sell_2_2:Hide();
	Carriage_Freight_Sell_2_3:Hide();

	Refresh_My_Freight();

end


function Carriage_Trade_Update_Price(misIndex,nPrice_UpOrDown)
		local misIndex = mission_index;
		nTransNPC = Get_XParam_INT(4);
		local Price;

		local CD_Time_Sell = Get_XParam_INT(2);
		local CD_Time_Buy = Get_XParam_INT(3);

		if CD_Time_Buy > 0 then
			CD_Time_Buy = CD_Time_Buy / 60;
			if CD_Time_Buy < 1 then
				CD_Time_Buy = 1;
			end
			CD_Time_Buy = tostring(math.floor(CD_Time_Buy)).."phút sau";
			Carriage_Down : Disable();
		else
			CD_Time_Buy = "Bây gi¶ l§p tÑc có th¬"
			Carriage_Down : Enable();
		end
		
		if CD_Time_Sell > 0 then
			CD_Time_Sell = CD_Time_Sell / 60;
			if CD_Time_Sell < 1 then
				CD_Time_Sell = 1;
			end
			CD_Time_Sell = tostring(math.floor(CD_Time_Sell)).."phút sau";
			Carriage_Up : Disable();
		else
			CD_Time_Sell = "Bây gi¶ l§p tÑc có th¬"
			Carriage_Up : Enable();
		end
		if nTransNPC == 1 or nTransNPC == 2 or nTransNPC == 3 then
			Carriage_Info3:SetText("Th¶i c½ giäm giá th¸ trß¶ng"..CD_Time_Buy)
			Carriage_Info4:SetText("Nâng giá"..CD_Time_Sell)
			if nPrice_UpOrDown == Price_Up then

				Price = DataPool:GetPlayerMission_Variable(misIndex,Price_Up)
				
				Carriage_Freight_Sell_1_1:SetToolTip("Giá cä: "..Price);
				Carriage_Freight_Sell_1_2:SetToolTip("Giá cä: "..Price);
				Carriage_Freight_Sell_2_2:SetToolTip("Giá cä: "..Price);
				Carriage_Freight_Sell_2_3:SetToolTip("Giá cä: "..Price);
				Carriage_Money_Sell_1:Show()
				Carriage_Money_Sell_2:Show()
				Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Price));
				Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Price));
				
				Sell_Price = Price;

--				if nTransNPC == 1 then
--					Carriage_Freight_Buy_1_1:SetToolTip("ÑÎ£¬²ú×ÔÂåÑô#rµã»÷ÂòÈë#rµ±Ç°¼Û¸ñ:"..Price);
--				elseif nTransNPC == 2 then
--					Carriage_Freight_Buy_1_2:SetToolTip("Ìú£¬²ú×Ô´óÀí#rµã»÷ÂòÈë#rµ±Ç°¼Û¸ñ:"..Price);
--				elseif nTransNPC == 3 then
--					Carriage_Freight_Buy_2_3:SetToolTip("Ã×£¬²ú×ÔËÕÖÝ#rµã»÷ÂòÈë#rµ±Ç°¼Û¸ñ:"..Price);
--				end

			elseif nPrice_UpOrDown == Price_Down then
			
				Price = DataPool:GetPlayerMission_Variable(misIndex,Price_Down)
	
				if nTransNPC == 1 then
					Carriage_Freight_Buy_1_1:SetToolTip("Mu¯i, sän xu¤t t× LÕc Dß½ng #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Price.."}");
				elseif nTransNPC == 2 then
					Carriage_Freight_Buy_1_2:SetToolTip("S¡t, sän xu¤t t× ÐÕi Lý #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Price.."}");
				elseif nTransNPC == 3 then
					Carriage_Freight_Buy_2_3:SetToolTip("GÕo, sän xu¤t t× Tô Châu #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Price.."}");
				end
				
				if nTransNPC == 3 then
					Carriage_Money_Buy_2:SetProperty("MoneyNumber", tostring(Price));
				else
					Carriage_Money_Buy_1:SetProperty("MoneyNumber", tostring(Price));
				end
				
			end

		elseif nTransNPC == 4 then
			if nPrice_UpOrDown == Price_Up then

				Price = DataPool:GetPlayerMission_Variable(misIndex,0)
				
				Carriage_Freight_Sell_1_1:SetToolTip("Giá cä: "..Price);
				Carriage_Freight_Sell_1_2:SetToolTip("Giá cä: "..Price);
				Carriage_Freight_Sell_2_2:SetToolTip("Giá cä: "..Price);
				Carriage_Freight_Sell_2_3:SetToolTip("Giá cä: "..Price);
				Carriage_Money_Sell_1:Show()
				Carriage_Money_Sell_2:Show()
				Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Price));
				Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Price));
				
				Sell_Price = Price;
				
				Carriage_Info3:SetText("Th¶i c½ giäm giá th¸ trß¶ng"..CD_Time_Buy)
				Carriage_Info4:SetText("Nâng giá"..CD_Time_Sell)

			end
		end
		Refresh_My_Freight();
end

function Carriage_Button1_Clicked()

	local UI_ID = Get_XParam_INT(0);
	
--	if UI_ID == 3 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnHaggleDown");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
--	end
	AxTrace(0,1,"button1 clicked")
	
end

function Carriage_Button2_Clicked()

	local UI_ID = Get_XParam_INT(0);
	
--	if UI_ID == 3 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnHaggleUp");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
--	end
	AxTrace(0,1,"button2 clicked")
end

function Carriage_Action_Clicked(nIndex)

	local UI_ID = Get_XParam_INT(0);
	local Send_Msg;
	local Text_Goods = {}
	
	Text_Goods[1] = "Mu¯i"
	Text_Goods[2] = "Thiªt"
	Text_Goods[3] = " GÕo"
	
	if nIndex < 1 then
		return ;
	end
	
	if Current == 100 then
		PushDebugMessage("Không ðßþc thông qua kho hàng tiªn hành thao tác.")
		return;
	end

--	misIndex = Get_XParam_INT(1);
	local misIndex = mission_index;
--	local nTransNPC = DataPool:GetPlayerMission_Variable(misIndex,6)

	AxTrace(0,1,"nTransNPC = "..nTransNPC .." nIndex="..nIndex)
	if nIndex>= 10 then
		if (nIndex / 10) == nTransNPC then
			
			PushDebugMessage("N½i ðây không thu mua "..Text_Goods[nTransNPC]);
			return ;
		end
	end
--ÒÔÏÂÊÇÒ»¶ÎÕä¹óµÄ´úÂë£¬ÏëÁËºÃ¾Ã²Å¸ã³öÀ´µÄ£¬ Çë²»ÒªÉ¾³ý¡£
--	if nTransNPC == 2 then
--			if nIndex == 1 then
--		 		Send_Msg = 2;
--			elseif nIndex == 2 then
--		 		Send_Msg = 1;
--		 	else
--		 		Send_Msg = 3;
--			end
--	elseif nTransNPC == 3 then
--			if nIndex == 1 then
--		 		 Send_Msg = 3;
--			else
--		 		Send_Msg = nIndex - 1;
--			end
--	else
--			Send_Msg = nIndex;
--	end
	if nIndex >=10 then
		Send_Msg = nIndex / 10;
	else
		Send_Msg = nIndex
	end
	AxTrace(0,1,"nTransNPC = "..nTransNPC .." nIndex="..nIndex .." Send_Msg ="..Send_Msg)
--	if UI_ID < 6 and UI_ID > 2 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnTrade");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_Parameter(0,Send_Msg);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
--			this:Hide();
--	end
end

function Get_Writ()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	AxTrace(0,1,"here, current="..Current)
	if Current == 4 then
			AxTrace(0,1,"haha")
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnAcceptMission");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
	end
	
	Carriage_Draw:Hide()
	--this:Hide();
end

function Convert_Writ()
		local Cargo = DataPool:GetPlayerMission_Variable(mission_index,2)
		
		if Cargo > 0 then
			PushDebugMessage("Làm sÕch khoang xong m¾i ðßþc ð±i quan phiªu")
			return
		end
--	if Current == 3 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnRedeemUI");
			Set_XSCRIPT_ScriptID(311010);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
		
		this:Hide();
			
--	end
	
end

function Refresh_My_Freight()
	local Cargo = DataPool:GetPlayerMission_Variable(mission_index,2)
	local Balance = DataPool:GetPlayerMission_Variable(mission_index,5)
	local Price_Display = DataPool:GetPlayerMission_Variable(mission_index,0)
			
	local Cargo_Standard = 100
	if Cargo < Cargo_Standard then
		Carriage_Freight5:Hide();
	else
		Carriage_Freight5:Show();
		Carriage_Freight5:SetToolTip("Mu¯i, sän xu¤t t× LÕc Dß½ng #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Sell_Price.."}");
	end
		
	Cargo_Standard = 10
	if math.mod(Cargo,100) < Cargo_Standard then
		Carriage_Freight6:Hide();
	else
		Carriage_Freight6:Show();
		Carriage_Freight6:SetToolTip("S¡t, sän xu¤t t× ÐÕi Lý #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Sell_Price.."}");
	end
		
	Cargo_Standard = 1
	if math.mod(Cargo,10) < Cargo_Standard then
		Carriage_Freight7:Hide();
	else
		Carriage_Freight7:Show();
		Carriage_Freight7:SetToolTip("GÕo, sän xu¤t t× Tô Châu #rÐi¬m mua vào #rGiá trß¾c m¡t: #{_EXCHG"..Sell_Price.."}");
	end
	
	Carriage_Info1:SetText("Ð±i phiªu: ")
	Carriage_Balance:SetProperty("MoneyNumber",tostring(Balance));
	local Round = DataPool:GetPlayerMission_DataRound(Caoyun_Circle);

	this:Show();

end


--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Carriage(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Carriage");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Carriage(objCaredId)
	this:CareObject(objCaredId, 0, "Carriage");
	g_Object = -1;

end

function Close_Carriage()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	StopCareObject_Carriage(objCared);
end

function Abandon_Carriage()
	DataPool:Mission_Abnegate_Special_Quest_Popup(311010,"V§n chuy¬n");
	this:Hide();
end

function Close_Carriage_UI()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Close_Carriage_UI");
		Set_XSCRIPT_ScriptID(311010);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
	this:Hide();
end
