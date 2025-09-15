local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local MATERIAL_BUTTONS;
local MATERIAL_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local STILE_TYPE = -1 --´ò¿×ÀàÐÍ£¬1µã½ð£¬2º®Óñ

local x311200_Stiletto_four_ID = {
																	10514091,10514092,10514093,10514094,10514095,10514096,10514097,10514098,10515090,10515091,
																	10515092,10515093,10515094,10515095,10515096,10515097,10515098,10521090,10521091,10521092,
																	10521093,10521094,10521095,10521096,10521097,10521098,10522090,10522091,10522092,10522093,
																	10522094,10522095,10522096,10522097,10522098,10523090,10523091,10523092,10523093,10523094,
																	10523095,10523096,10523097,10523098,10514090,
																	-- ñÒÉÙÎ¢£¬2008.6.12¡£Ìí¼Ó102ÉñÆ÷¼«ÏÞ´ò¿×
																	10300100,10300101,10300102, 10301100,10301101,10301102, 10301200,10301201,10301202,
																	10302100,10302101,10302102, 10303100,10303101,10303102, 10303200,10303201,10303202,
																	10304100,10304101,10304102, 10305100,10305101,10305102, 10305200,10305201,10305202,
																	10422016,10423024,
																	--ºú¿­£¬2008.8.29¡£¾É100Ì×£¨Îå¼þÌ×£©¼°ÐÂ96Ì×¿ª·Å¼«ÏÞ´ò¿×
																	10510009,10510019,10510029,10510039,10510049,10510059,10510069,10510079,10510089,10511009,
																	10511019,10511029,10511039,10511049,10511059,10511069,10511079,10511089,10512009,10512019,
																	10512029,10512039,10512049,10512059,10512069,10512079,10512089,10513009,10513019,10513029,
																	10513039,10513049,10513059,10513069,10513079,10513089,
--																	10511096,10512092,10520092,10522101,
--																	10523101,10511097,10512093,10520093,10522102,10523102,10511098,10512094,10520094,10522103,
--																	10523103,10511099,10512095,10520095,10522104,10523104,
																	--ºú¿­£¬2008.9.18¡£90¼¶ÒÔÉÏ£¨º¬90£©Éú»î¼¼ÄÜ²ú³öµÄ½äÖ¸£¬»¤·û£¬¼ç¿ª·Å¼«ÏÞ´ò¿×
  																	10215020,10222020,10223020,10222035,10222036,10223035,10223036,
																	--ºú¿­£¬2008.11.11¡£90¼¶ÒÔÉÏ£¨º¬90£©ÊÖ¹¤×°±¸¿ª·Å¼«ÏÞ´ò¿×£¨Ð¬£¬Ñü´ø£¬»¤Íó£¬ÊÖÌ×£¬Í·¿ø£¬ÎäÆ÷£¬»¤¼×£¬ÏîÁ´£©
--																	10200019,10200020,10201019,10201020,10202019,10202020,10203019,10203020,10204019,10204020,
--																	10205019,10205020,
                                                                    10210020,10210040,10210060,10213020,10213040,10213060,10212020,10212040,
  																	10212060,10211020,10211040,10211060,10214020,10221020,10220020,
																	--zchw£¬2008-11-17  TT£º41140 90ÃÅÅÉÌ×£¬92¼¶ÉñÆ÷¿ª·ÅµÚËÄ¿×
																	10510008,10510038,10510068,
																	10511018,10511028,10511048,10511058,10511078,10511088,10512008,10512038,
																	10512068,10513008,10513018,10513028,10513038,10513048,10513058,10513068,
																	10513078,10513088,10514028,10514058,10514088,10520018,10520028,10520048,
																	10520058,10520078,10520088,10521028,10521058,10521088,10522018,10522048,
																	10522078,10552008,10552038,10552068,10553008,10553018,10553038,10553048,
																	10553068,10553078,
																	--msl 2010-06-21 
														            10300005,10302005,10304005,10305005,
																	--zchw 2008-11-26 TT£º41771
																	10410027, 10410035,
																	--lixiangx,2010-6-10,90¼¶ÍÃ¶ú¶ä¼«ÏÞ´ò¿×
																	10410026, 10410034,
--																	10423025, 10423026,
																	--houzhifang 2008-12-22: dark
--																	10150001,10150002,

}




local g_Object = -1;

function Stiletto_Four_PreLoad()

	this:RegisterEvent("UPDATE_STILETTO_FOUR");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");


end

function Stiletto_Four_OnLoad()
	EQUIP_BUTTONS = Stiletto_Four_Item
	MATERIAL_BUTTONS = Stiletto_Four_Material
end

function Stiletto_Four_OnEvent(event)

	--PushDebugMessage(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 75117) then

			local xx = Get_XParam_INT(0);
			local thistype = Get_XParam_INT(1);

			if thistype ~= STILE_TYPE then
				Stiletto_Four_Clear()
			end
			STILE_TYPE = thistype

			this:Show();

			if STILE_TYPE == 1 then
				Stiletto_Four_Explain1: SetText("#{INTERFACE_XML_JX_07}")
				Stiletto_Four_Explain3: SetText("#{INTERFACE_XML_1162}")
			else
				Stiletto_Four_Explain1: SetText("#{JXDK_080827_1}")
				Stiletto_Four_Explain3: SetText("#{INTERFACE_XML_1163}")
			end

			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("Dæ li®u cüa server truy«n tr· lÕi có v¤n ð«");
					return;
			end
			BeginCareObject_Stiletto_Four(objCared)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then

			--È¡Ïû¹ØÐÄ
			Stiletto_Four_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end


		if (EQUIP_QUALITY == tonumber(arg0) ) then
			Stiletto_Four_Clear()
			Stiletto_Four_Update(1,tonumber(arg0))
		end

		if (MATERIAL_QUALITY == tonumber(arg0) ) then
			Stiletto_Four_Clear()
			Stiletto_Four_Update(2,tonumber(arg0))
		end


	elseif ( event == "RESUME_Stiletto_Four_EQUIP" ) then
		Resume_Equip(1);
	elseif( event == "UPDATE_STILETTO_FOUR") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 == nil or arg1 == nil then
			return
		end

		Stiletto_Four_Update(tonumber(arg0),tonumber(arg1));

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 13) then
			Resume_Equip_Stiletto_Four(1);
		elseif(arg0~=nil and tonumber(arg0) == 53) then
			Resume_Equip_Stiletto_Four(2);
		end

	end
end

function Stiletto_Four_OnShown()
	Stiletto_Four_Clear()
end

function Stiletto_Four_Clear()
	if(EQUIP_QUALITY ~= -1) then
		EQUIP_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
	end

--	Stiletto_Four_Material_Bak : SetProperty("Image", "set:CommonItem image:ActionBK");
--	Stiletto_Four_Material_Bak	: SetToolTip("")
	if(MATERIAL_QUALITY ~= -1) then
		MATERIAL_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
		MATERIAL_QUALITY = -1;
	end
	Stiletto_Four_Money : SetProperty("MoneyNumber", "");
	Stiletto_Four_State: SetText("")
	LifeAbility : ClearSlotFour()
end

function Stiletto_Four_Update(pos1,pos0)
	local pos_packet,pos_ui;
	pos_packet = tonumber(pos0);
	pos_ui		 = tonumber(pos1)

	local theAction = EnumAction(pos_packet, "packageitem");
	if pos_ui == 1 then  --·ÅÈëÎïÆ·Ê±
		if theAction:GetID() ~= 0 then

			local Bore_Count1 = 0;
		  local Need_Item1 = -1;
		  local Need_Money1 = 0;
		  local Need_Item_Count1 =0;

			--Need_Item,Need_Money,Need_Item_Count,Bore_Count=LifeAbility : Stiletto_Preparation(pos_packet);
			Need_Item1,Need_Money1,Need_Item_Count1,Bore_Count1=LifeAbility : Stiletto_Preparation(pos_packet, STILE_TYPE);

			local taozhuangid = PlayerPackage : GetItemTableIndex( pos_packet )
			local istaozhuang = 0


		  for i, v in x311200_Stiletto_four_ID do
		    if taozhuangid == v then
			    istaozhuang = 1;
			    break
		    end
	    end

	    if(PlayerPackage:IsBagItemDark(pos_packet) == 1) then
	    	istaozhuang = 1;
	    end

	    if istaozhuang == 0 then
	    	--PushDebugMessage("#{XQC_20080509_02}")
				--return
	    end

			local WuhunID = theAction:GetDefineID()
			if WuhunID < 10308001 or WuhunID > 10308004 then
				if Bore_Count1 < 3 then --add:lby 20080523
					PushDebugMessage("#{XQC_20080509_03}")
					return
				end
			end

			if Bore_Count1 > 3 then --add:lby 20080523
				PushDebugMessage("#{XQC_20080509_04}")
				return
			end


			if WuhunID < 10308001 or WuhunID > 10308004 then
				if Need_Item1 < -1 then
					PushDebugMessage("#{XQC_20080509_01}")
					return
				end
			end

			Need_Item = Need_Item1
			Need_Money = Need_Money1
			Need_Item_Count = Need_Item_Count1
			Bore_Count = Bore_Count1

			--ÈÃÖ®Ç°µÄ¶«Î÷±äÁÁ
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				Stiletto_Four_Money : SetProperty("MoneyNumber", "");
				Stiletto_Four_State: SetText("")
			end

			EQUIP_BUTTONS:SetActionItem(theAction:GetID());
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			Stiletto_Four_Money : SetProperty("MoneyNumber", "");
			Stiletto_Four_State: SetText("")
			return;
		end
		Stiletto_Four_Money : SetProperty("MoneyNumber", tostring(Need_Money));
		Stiletto_Four_State : SetText("S¯ máng lõm hi®n tÕi: "..Bore_Count.."; có th¬ tång thêm s¯ máng lõm: "..tostring(4-Bore_Count))

	elseif pos_ui == 2 then --µã½ðÖ®¼å»òº®Óñ¾«´â

		--local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
	--	local Item_Quality = PlayerPackage : GetItemSubTableIndex(pos_packet,1)
		--local Item_Type = PlayerPackage : GetItemSubTableIndex(pos_packet,2)



		--if Item_Class ~= 2 or Item_Quality ~= 1 or Item_Type ~= 9 then
		--	return
		--end

		if theAction:GetID() ~= 0 then

			local itemindex = PlayerPackage : GetItemTableIndex(pos_packet)

			if STILE_TYPE == 1 then
				if itemindex ~= 20109101 then  --add:lby 20080523Ö»ÄÜ·ÅÈëµã½ðÖ®¼ý
	 				PushDebugMessage("#{XQC_20080509_05}")
	 				return
	  		end
			elseif STILE_TYPE == 2 then
				if itemindex ~= 20310111 then  --add:hukai Ö»ÄÜ·ÅÈëº®Óñ¾«´â
	 				PushDebugMessage("#{JCDK_80905_05}")
	 				return
	  		end
			else
				PushDebugMessage("Sai sót trong loÕi hình tiêu hao."..STILE_TYPE)
	 			return
			end

			MATERIAL_BUTTONS:SetActionItem(theAction:GetID());
			if MATERIAL_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			end
			--ÈÃÖ®Ç°µÄ¶«Î÷±äÁÁ
			MATERIAL_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,1);
		else
			MATERIAL_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			MATERIAL_QUALITY = -1;
			return;
		end
	end

end

function Stiletto_Four_Buttons_Clicked()
	if MATERIAL_QUALITY == -1 then
		PushDebugMessage("M¶i thêm vào v§t li®u ðøc l²")
		return
	end
	if EQUIP_QUALITY ~= -1 then
		-- if Need_Item == -2 then
			-- if STILE_TYPE == 1 then
				-- PushDebugMessage("#{XQC_20080509_07}")
			-- else
				-- PushDebugMessage("#{JCDK_80905_07}")
			-- end
		-- elseif Need_Item == -3 then
		if Need_Item == -3 then
			PushDebugMessage("#{XQC_20080509_04}")

		elseif Player:GetData("MONEY")+Player:GetData("MONEY_JZ") < Need_Money then
			if STILE_TYPE == 1 then
				PushDebugMessage("#{XQC_20080509_08}")
			else
				PushDebugMessage("#{JCDK_80905_08}")
			end
		else
			if LifeAbility : Is_SlotFour(EQUIP_QUALITY,MATERIAL_QUALITY,STILE_TYPE) == 1 then
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("OnStiletto_Four");
					Set_XSCRIPT_ScriptID(311200);
					Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
					Set_XSCRIPT_Parameter(1,MATERIAL_QUALITY);
					Set_XSCRIPT_Parameter(2,STILE_TYPE);
					Set_XSCRIPT_ParamCount(3);
				Send_XSCRIPT();
			end
		end
	else
		PushDebugMessage("#{XQC_20080509_06}")
	end

end

function Stiletto_Four_Close()
	--²¢ÉèÖÃ£¬ÈÃ±³°üÀïµÄÎ»ÖÃ±äÁÁ
	this:Hide();
	Stiletto_Four_Clear();
	StopCareObject_Stiletto_Four(objCared)
end

function Stiletto_Four_Cancel_Clicked()
	Stiletto_Four_Close();
	return;
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Stiletto_Four(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Stiletto_Four");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Stiletto_Four(objCaredId)
	this:CareObject(objCaredId, 0, "Stiletto_Four");
	g_Object = -1;

end

function Resume_Equip_Stiletto_Four(nIndex)

	if( this:IsVisible() ) then

		if(nIndex == 1) then
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTONS : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				Stiletto_Four_Money : SetProperty("MoneyNumber", "");
				Stiletto_Four_State: SetText("")
			end
		else
			if(MATERIAL_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
				MATERIAL_BUTTONS : SetActionItem(-1);
				MATERIAL_QUALITY	= -1;
			end
		end

	end

end
