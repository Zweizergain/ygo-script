--特殊模式-RSX
function c10199010.initial_effect(c)
   if not c10199010.global_check then
		c10199010.Mode_On=false
		c10199010.Mode_IsAi=false
		c10199010.Mode_IsTag=false
		c10199010.Mode_IsBanPickMode=false
		c10199010.Mode_IsDoubleDeckMode=false
		c10199010.Mode_IsRandomBuffMode=false
		c10199010.Mode_IsSkillMode=false 
		c10199010.Mode_RandomBuffCount={}
		c10199010.Mode_RandomBuffCount[0]=0
		c10199010.Mode_RandomBuffCount[1]=0
		c10199010.LockLpCount={}
		c10199010.LockLpCount[0]=0
		c10199010.LockLpCount[1]=0
		c10199010.FlashPrintCount={}
		c10199010.FlashPrintCount[0]=0
		c10199010.FlashPrintCount[1]=0
		c10199010.BetterDrawCount={}
		c10199010.BetterDrawCount[0]=0
		c10199010.BetterDrawCount[1]=0
		c10199010.SuperChaosCount={}
		c10199010.SuperChaosCount[0]=0
		c10199010.SuperChaosCount[1]=0
		c10199010.BaseLp={}
		c10199010.BaseLp[0]=0
		c10199010.BaseLp[1]=0
		c10199010.card=c
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c10199010.mainop)
		Duel.RegisterEffect(ge1,0)
		ge1:SetLabel(0)
		local ge2=ge1:Clone()
		ge2:SetCondition(c10199010.maincon2)
		ge2:SetOperation(c10199010.mainop2)
		Duel.RegisterEffect(ge2,0)
		ge2:SetLabel(0)
		local ge3=ge1:Clone()
		ge3:SetCondition(c10199010.maincon2)
		ge3:SetOperation(c10199010.mainop2)
		Duel.RegisterEffect(ge3,0)
		ge3:SetLabel(1)
	end 
end
io=require('io')
os=require('os')
math.randomseed(os.time())
function c10199010.mainop(e)
	if not c10199010.Mode_On then
	   local c=e:GetHandler()
	   local tp=c:GetControler()
	   Duel.Hint(HINT_CARD,0,10199010)
	   local g=Duel.GetMatchingGroup(Card.IsCode,0,0xff,0xff,nil,10199010)
	   Duel.Remove(g,POS_FACEUP,REASON_RULE)
	   Duel.SendtoDeck(g,nil,-1,REASON_RULE)
	   local hg=Duel.GetFieldGroup(0,LOCATION_HAND,LOCATION_HAND)
	   Duel.SendtoDeck(hg,nil,2,REASON_RULE)
	   c10199010.Mode_Function_Main(e,c,tp,g)
	   Duel.ShuffleDeck(0)
	   Duel.ShuffleDeck(1)
	   Duel.Draw(0,5,REASON_RULE)
	   Duel.Draw(1,5,REASON_RULE)
	   c10199010.Mode_On=true
	   c10199010.Easy_Funtcion_SetAddCardFlag(Duel.GetFieldGroup(0,LOCATION_DECK,LOCATION_DECK),101990111)
	   e:Reset()
	end
end
function c10199010.maincon2(e)
	return Duel.GetTurnCount(e:GetLabel())==2
end
function c10199010.mainop2(e)
	local g=Duel.GetFieldGroup(0,LOCATION_DECK,LOCATION_DECK)
	if g:GetCount()>0 and not g:IsExists(c10199010.mainopfilter,1,nil) then 
	   c10199010.Mode_Function_Main_ChooseMode_Extra1(e,tp)
	   Duel.ShuffleDeck(0)
	   Duel.ShuffleDeck(1)
	   Duel.Draw(0,5,REASON_RULE)
	   Duel.Draw(1,5,REASON_RULE)
	end
	e:Reset()
end
function c10199010.mainopfilter(c)
	return c:GetFlagEffect(101990111)>0
end
function c10199010.Mode_Function_Main(e,c,tp,g)
	c10199010.Mode_Function_Main_AddCard(e,c,tp,g)
	c10199010.Mode_Function_Main_ChooseMode(e,tp)
end
function c10199010.Mode_Function_Main_AddCard(e,c,tp,g)
	local tc,p,ac,tk,tf,dg,tf2=g:GetFirst(),0,0,nil,true,nil,false
	while tc do
	   p=tc:GetOwner()
	   tf=true  
	   while tf do
		 Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(10199010,2))
		 c10199010.announce_filter={TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION,OPCODE_ISTYPE,OPCODE_AND}
		 ac=Duel.AnnounceCardFilter(p,table.unpack(c10199010.announce_filter))
		 tk=Duel.CreateToken(p,ac)
		 tf2=false
		 if Duel.GetFieldGroup(p,LOCATION_DECK+LOCATION_EXTRA,0):IsExists(Card.IsCode,3,nil,ac)
		 then
			Duel.Hint(HINT_MESSAGE,p,aux.Stringid(10199010,3))  
		 else
			Duel.SendtoDeck(tk,nil,2,REASON_RULE)
			tf=false
		 end
	   end
	tc=g:GetNext()
	end
end
function c10199010.Mode_Function_Main_ChooseMode(e,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(10199010,0)) then c10199010.Mode_IsAi=true end
	if Duel.SelectYesNo(tp,aux.Stringid(10199010,14)) and (c10199010.Mode_IsAi or Duel.SelectYesNo(1-tp,aux.Stringid(10199010,14))) then
	   c10199010.Mode_IsBanPickMode=true
	   Debug.Message("BanPick模式√")
	else
	   Debug.Message("BanPick模式×")
	end
	if Duel.SelectYesNo(tp,aux.Stringid(10199010,1)) and (c10199010.Mode_IsAi or Duel.SelectYesNo(1-tp,aux.Stringid(10199010,1))) then
	   c10199010.Mode_IsDoubleDeckMode=true
	   Debug.Message("双倍卡组模式√")
	else
	   Debug.Message("双倍卡组模式×")
	end
	if Duel.SelectYesNo(tp,aux.Stringid(10199010,4)) and (c10199010.Mode_IsAi or Duel.SelectYesNo(1-tp,aux.Stringid(10199010,4))) then
	   c10199010.Mode_IsRandomBuffMode=true
	   Debug.Message("随机Buff模式√")
	else
	   Debug.Message("随机Buff模式×")
	end
	if Duel.SelectYesNo(tp,aux.Stringid(10199010,5)) and (c10199010.Mode_IsAi or Duel.SelectYesNo(1-tp,aux.Stringid(10199010,5))) then
	   c10199010.Mode_IsSkillMode=true
	   Debug.Message("技能模式√")
	else
	   Debug.Message("技能模式×")
	end
	c10199010.Mode_Function_Main_ChooseMode_Extra1(e,tp)
	c10199010.BaseLp[0]=Duel.GetLP(0)
	c10199010.BaseLp[1]=Duel.GetLP(1)
end
function c10199010.Mode_Function_Main_ChooseMode_Extra1(e,tp)
	if c10199010.Mode_IsBanPickMode then
	   c10199010.Mode_Function_BanPick(e,tp)
	end
	if c10199010.Mode_IsDoubleDeckMode then
	   c10199010.Mode_Function_DoubleDeck(e,tp)
	end
	if c10199010.Mode_IsRandomBuffMode then
	   c10199010.Mode_Function_RandomBuff(e,tp)
	end
	if c10199010.Mode_IsSkillMode then
	   c10199010.Mode_Function_Skill(e,tp)
	end
end
function c10199010.Mode_Function_BanPick(e,tp)
	local tc,sg,g2=nil,Group.CreateGroup()
	local str="先攻玩家"
	for i=0,1 do
		if i==1 then str="后攻玩家" end
		Debug.Message(str.."正在禁用卡片")
		local dg,g=Duel.GetFieldGroup(1-i,LOCATION_DECK,0),Group.CreateGroup()
		Duel.ConfirmCards(i,dg)
		for m=1,3 do
			Duel.Hint(HINT_SELECTMSG,i,aux.Stringid(10199010,15))
			tc=dg:Select(i,1,1,nil):GetFirst()
			g:AddCard(tc)
			sg:AddCard(tc)
			dg:Remove(Card.IsCode,nil,tc:GetCode())
		end
		Duel.SendtoHand(g,nil,REASON_RULE)
		Duel.ConfirmCards(1-i,g)
	end
	Duel.SendtoDeck(sg,nil,-1,REASON_RULE)
	str="先攻玩家"
	sg:Clear()
	for i=0,1 do
		if i==1 then str="后攻玩家" end
		Debug.Message(str.."正在选用卡片")
		local dg,g=Duel.GetFieldGroup(1-i,LOCATION_DECK,0),Group.CreateGroup()
		Duel.ConfirmCards(i,dg)
		for m=1,3 do
			Duel.Hint(HINT_SELECTMSG,i,aux.Stringid(10199010,11))
			tc=dg:Select(i,1,1,nil):GetFirst()
			g:AddCard(Duel.CreateToken(i,tc:GetCode()))
			dg:Remove(Card.IsCode,nil,tc:GetCode())
			Duel.SendtoHand(g,nil,REASON_RULE)
			Duel.ConfirmCards(1-i,g)
			sg:Merge(g)
		end
	end
	Duel.SendtoDeck(sg,nil,2,REASON_RULE)
end
function c10199010.Mode_Function_DoubleDeck(e,tp)
	local tc,dg,tk,p,sg=nil,nil,nil,0,Group.CreateGroup()
	for i=0,1 do
	   p=i
	   Duel.Hint(HINT_SELECTMSG,i,aux.Stringid(10199010,9))
	   local dc=Duel.SelectOption(i,aux.Stringid(10199010,7),aux.Stringid(10199010,8))
	   if dc==1 then p=1-i end
	   dg=Duel.GetFieldGroup(p,LOCATION_DECK+LOCATION_EXTRA,0)
	   if sg:GetCount()>0 then dg:Sub(sg) end
	   tc=dg:GetFirst()
	   while tc do
		  tk=Duel.CreateToken(i,tc:GetCode())
		  Duel.SendtoDeck(tk,nil,2,REASON_RULE)
		  sg:AddCard(tk)
	   tc=dg:GetNext()
	   end
	end
end
function c10199010.Mode_Function_RandomBuff(e,tp)
	c10199010.Easy_Funtcion_ConfirmCards(10199002) 
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetCondition(c10199010.buffcon)
	e1:SetOperation(c10199010.buffop)
	Duel.RegisterEffect(e1,0)
end
function c10199010.buffcon(e)
	return Duel.GetFlagEffect(0,10199010)==0
end
function c10199010.buffop(e)
	local turnplayer=Duel.GetTurnPlayer()
	local str="tp"
	for i=1,2 do
		if i==2 then 
		   str="op"
		   turnplayer=1-turnplayer
		end
		c10199010.Mode_RandomBuffCount[turnplayer]=c10199010.Mode_RandomBuffCount[turnplayer]+1
		c10199010.Mode_RandomBuff_ChooseBuff(e,turnplayer,str)
	end
	Duel.RegisterFlagEffect(0,10199010,RESET_PHASE+PHASE_END,0,1)
end
function c10199010.Mode_RandomBuff_ChooseBuff(e,tp,str)
	local randomint=0
	for i=1,Duel.GetFlagEffect(tp,101990105)+1 do
		randomint=math.random(1,12)
		if i==Duel.GetFlagEffect(tp,101990105)+1 then 
		break
		end
		c10199010.Mode_RandomBuff_ChooseBuff_Extra1(e,tp,str,randomint,false)
		if not Duel.SelectYesNo(tp,aux.Stringid(10199004,6)) then
		break 
		end 
	end
	c10199010.Mode_RandomBuff_ChooseBuff_Extra1(e,tp,str,randomint,true)
end
function c10199010.Mode_RandomBuff_ChooseBuff_Extra1(e,tp,str,randomint,confirm)
	if randomint==0 then
	   randomint=math.random(1,12)
	end
	if   randomint==1 then c10199010.Mode_RandomBuff_1(e,tp,str,confirm)
	elseif randomint==2 then c10199010.Mode_RandomBuff_2(e,tp,str,confirm)
	elseif randomint==3 then c10199010.Mode_RandomBuff_3(e,tp,str,confirm)
	elseif randomint==4 then c10199010.Mode_RandomBuff_4(e,tp,str,confirm)
	elseif randomint==5 then c10199010.Mode_RandomBuff_5(e,tp,str,confirm)
	elseif randomint==6 then c10199010.Mode_RandomBuff_6(e,tp,str,confirm)
	elseif randomint==7 then c10199010.Mode_RandomBuff_7(e,tp,str,confirm)
	elseif randomint==8 then c10199010.Mode_RandomBuff_8(e,tp,str,confirm)
	elseif randomint==9 then c10199010.Mode_RandomBuff_9(e,tp,str,confirm)
	elseif randomint==10 then c10199010.Mode_RandomBuff_10(e,tp,str,confirm)
	elseif randomint==11 then c10199010.Mode_RandomBuff_11(e,tp,str,confirm)
	elseif randomint==12 then c10199010.Mode_RandomBuff_12(e,tp,str,confirm)
	end
end
function c10199010.Mode_RandomBuff_1(e,tp,str,confirm)
	--dobule summon
	local filter=(Duel.GetTurnPlayer()==tp and Duel.GetMatchingGroupCount(Card.IsSummonable,tp,LOCATION_HAND,0,nil,true,nil)>0)
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"二重召唤-通召+1","二重召唤-通召+2","二重召唤-通召+3",43422537,confirm)==true 
	then return 
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2+math.min(Duel.GetFlagEffect(tp,101990107),2))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10199010.Mode_RandomBuff_2(e,tp,str,confirm)
	--update atk&def by 500
	local filter=(Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0) or (Duel.GetTurnPlayer()==tp and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)>0)
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"团结之力-A/D+500","团结之力-A/D+1000","团结之力-A/D+1500",56747793,confirm)==true 
	then return
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(400+math.min(Duel.GetFlagEffect(tp,101990107),2)*300)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c10199010.Mode_RandomBuff_3(e,tp,str,confirm)
	--draw
	local filter=Duel.IsPlayerCanDraw(tp,Duel.GetFlagEffect(tp,101990107)+1)
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"暴发户-抽1","暴发户-抽2","暴发户-抽3",70368879,confirm)==true 
	then return 
	end
	Duel.Draw(tp,Duel.GetFlagEffect(tp,101990107)+1,REASON_RULE)
end
function c10199010.Mode_RandomBuff_4(e,tp,str,confirm)
	--destroy spell&trap
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local filter=(sg:GetCount()>0)
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"羽毛扫-对方魔陷全部破坏","羽毛扫-对方魔陷全部破坏并除外","羽毛扫-对方魔陷全部里侧除外",18144506,confirm)==true 
	then return 
	end
	if Duel.GetFlagEffect(tp,101990107)==0 then
	   Duel.Destroy(sg,REASON_RULE)
	elseif Duel.GetFlagEffect(tp,101990107)==1 then
	   Duel.Destroy(sg,REASON_RULE,LOCATION_REMOVED)
	else
	   Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end
function c10199010.Mode_RandomBuff_5(e,tp,str,confirm)
	--eat eat!
	local filter=true
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"海龟坏兽-随机1只坏兽加入手卡","海龟坏兽-宣言1只坏兽加入手卡","海龟坏兽-宣言1只坏兽，复制2份加手",55063751,confirm)==true 
	then return 
	end
	local group,rc,tkc={28674152,29726552,36956512,48770333,55063751,63941210,93332803,84769941},math.random(0,7),0
	c10199010.announce_filter2={0xd3,OPCODE_ISSETCARD,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND}
	if Duel.GetFlagEffect(tp,101990107)==0 then
	   tkc=group[rc]
	elseif Duel.GetFlagEffect(tp,101990107)==1 then 
	   tkc=Duel.AnnounceCardFilter(tp,table.unpack(c10199010.announce_filter2)) 
	else
	   tkc=Duel.AnnounceCardFilter(tp,table.unpack(c10199010.announce_filter2)) 
	end
	local g=Group.FromCards(Duel.CreateToken(tp,tkc))
	if Duel.GetFlagEffect(tp,101990107)>1 then
	   g:AddCard(Duel.CreateToken(tp,tkc))
	end
	Duel.SendtoHand(g,tp,REASON_RULE)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	c10199010.Easy_Funtcion_SetAddCardFlag(g,10199010)
end
function c10199010.Mode_RandomBuff_6(e,tp,str,confirm)
	--cannot be destroyed
	local filter=(Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0)
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"棉花糖-自己场上怪兽不被战破","棉花糖-自己场上怪兽不被对方效破·战破","棉花糖-自己场上怪兽威风抗性+不被战破",31305911,confirm)==true
	then return 
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabel(tp)
	if Duel.GetFlagEffect(tp,101990107)==1 then
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	   e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	   e2:SetValue(c10199010.desimmuevalue)
	   Duel.RegisterEffect(e2,tp)
	   e2:SetLabel(tp)
	end
	if Duel.GetFlagEffect(tp,101990107)>1 then
	   local e3=e1:Clone()
	   e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	   e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	   e3:SetValue(c10199010.desimmuevalue)
	   Duel.RegisterEffect(e3,tp)
	   e3:SetLabel(tp)
	end
end
function c10199010.desimmuevalue(e,re,rp)
	return rp~=e:GetLabel()
end
function c10199010.Mode_RandomBuff_7(e,tp,str,confirm)
	--hand trap
	local filter,g1,g2,g3=true,Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup()
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"丝袜-随机1手坑加手","丝袜-宣言1手坑加手","丝袜-宣言1手坑加手，随机1墓坑送墓",97268402,confirm)==true
	then return
	end
	local table2,randomcount={97268402,59438930,14558127,94145021,23434538},math.random(0,4)
	c10199010.announce_filter4={97268402,OPCODE_ISCODE,59438930,OPCODE_ISCODE,OPCODE_OR,14558127,OPCODE_ISCODE,OPCODE_OR,94145021,OPCODE_ISCODE,OPCODE_OR,23434538,OPCODE_ISCODE,OPCODE_OR}
	if Duel.GetFlagEffect(tp,101990107)==0 then
	   g1:AddCard(Duel.CreateToken(tp,table2[randomcount]))
	elseif Duel.GetFlagEffect(tp,101990107)>0 then
	   local ac=Duel.AnnounceCardFilter(tp,table.unpack(c10199010.announce_filter4))
	   g1:AddCard(Duel.CreateToken(tp,ac))
	   g3:Merge(g1)
	   if Duel.GetFlagEffect(tp,101990107)>1 then
		  table,randomcount={19254117,78474168,55623480},math.random(0,2)
		  g2=Group.FromCards(Duel.CreateToken(tp,table2[randomcount]))
		  g3:Merge(g2)
	   end
	end
	Duel.SendtoHand(g1,tp,REASON_RULE)
	Duel.ConfirmCards(1-tp,g1)
	if g2:GetCount()>0 then
	   Duel.SendtoGrave(g2,REASON_RULE)
	   Duel.ConfirmCards(1-tp,g2)
	end
	c10199010.Easy_Funtcion_SetAddCardFlag(g3,10199010)   
end
function c10199010.Mode_RandomBuff_8(e,tp,str,confirm)
	--real eye
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	g:Merge(Duel.GetFieldGroup(tp,0,LOCATION_HAND)) 
	local filter=g:GetCount()>0
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"真实之眼-公开对方手卡·盖卡","真实之眼-公开对方手卡·盖卡，选1张禁用","真实之眼-公开对方手卡·盖卡，选最多2张禁用",34694160,confirm)==true
	then return 
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFlagEffect(tp,101990107)>0 and g:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10199002,10))
	   g=g:Select(tp,1,math.min(Duel.GetFlagEffect(tp,101990107),2))
	   Duel.ConfirmCards(1-tp,g)
	   local tc=g:GetFirst()
	   while tc do
			 local e1=Effect.CreateEffect(tc)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_FORBIDDEN)
			 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
			 e1:SetReset(RESET_PHASE+PHASE_END)
			 tc:RegisterEffect(e1,true)
	   tc=g:GetNext()
	   end
	end
end
function c10199010.Mode_RandomBuff_9(e,tp,str,confirm)
	--Gain LP
	local filter=true
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"治疗之神-LP+4000","治疗之神-LP+8000","治疗之神-LP+12000",84257639,confirm)==true
	then return 
	end
	Duel.SkillSetLP(tp,Duel.GetLP(tp)+4000+4000*math.min(Duel.GetFlagEffect(tp,101990107),2))
end
function c10199010.Mode_RandomBuff_10(e,tp,str,confirm)
	--hand activate
	local g=Duel.GetMatchingGroup(c10199010.activatefilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local filter=g:GetCount()>0
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,false,confirm)==true or
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"处刑人-手发陷阱·速攻","处刑人-手发陷阱·速攻，持续2回合","处刑人-手发陷阱·速攻，持续3回合",21593977,confirm)==true
	then return 
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END,Duel.GetFlagEffect(tp,101990107)+1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	Duel.RegisterEffect(e2,tp)
end
function c10199010.Mode_RandomBuff_11(e,tp,str,confirm)
	--reborn
	local ct,nolimit=Duel.GetFlagEffect(tp,101990107),false
	if ct>1 then nolimit=true end
	local g=Duel.GetMatchingGroup(c10199010.spsummonablefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,nolimit) 
	local filter=g:GetCount()>0
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,true,confirm)==true or
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"死者苏生-复活自己墓地·除外1只怪兽","死者苏生-自定义属性的复活自己墓地·除外1只怪兽","死者苏生-无视苏生限制自定义属性的复活自己墓地·除外1只怪兽",83764718,confirm)==true
	then return 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	c10199010.Easy_Funtcion_Overlay(tc,tp,10199005,2)
	if Duel.SpecialSummon(tc,0,tp,tp,false,nolimit,POS_FACEUP)~=0 then
	   local t,i,p,att={},1,1,0
	   if tc:IsType(TYPE_XYZ) then
		  att=tc:GetRank()
	   end
	   for i=1,12 do 
		   if lv~=i then t[p]=i p=p+1 end
	   end
	   t[p]=nil
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10199004,7))
	   lv=Duel.AnnounceNumber(tp,table.unpack(t))
	   local e1=Effect.CreateEffect(tc)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   if tc:IsType(TYPE_XYZ) then
		  e1:SetCode(EFFECT_CHANGE_RANK)
	   else
		  e1:SetCode(EFFECT_CHANGE_LEVEL)
	   end
	   e1:SetValue(att)
	   e1:SetReset(RESET_EVENT+0x1ff0000)
	   tc:RegisterEffect(e1,true)
	   Duel.Hint(HINT_SELECTMSG,tp,562)
	   att=Duel.AnnounceAttribute(tp,1,0xffff)
	   local e2=Effect.CreateEffect(tc)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	   e2:SetValue(att)
	   e2:SetReset(RESET_EVENT+0x1ff0000)
	   tc:RegisterEffect(e2,true)
	   att=Duel.AnnounceRace(tp,1,0xffffff)
	   e3=e2:Clone()
	   e3:SetCode(EFFECT_CHANGE_RACE)
	   tc:RegisterEffect(e3,true)
	end
end
function c10199010.spsummonablefilter(c,e,tp,nolimit)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,nolimit) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c10199010.Mode_RandomBuff_12(e,tp,str,confirm)
	--easy fusion
	local ct,nocondition,sumtype,tc=Duel.GetFlagEffect(tp,101990107),false,0
	if ct>0 then nocondition=true end
	local g=Duel.GetMatchingGroup(c10199010.spsummonablefilter2,tp,LOCATION_EXTRA,0,nil,e,tp,nocondition) 
	local filter=g:GetCount()>0
	if c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,true,confirm)==true or 
	c10199010.Easy_Funtcion_ShowString_Randombuff(tp,"简易融合-随机特招额外卡组1只怪兽","简易融合-随机无视条件特招额外卡组1只怪兽","简易融合-随机2选1无视条件特招额外卡组1只怪兽",1845204,confirm)==true
	then return 
	end
	if ct>1 and g:GetCount()>1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   g=g:Select(tp,2,2,nil)
	end
	tc=g:RandomSelect(0,1):GetFirst()
	if tc:IsType(TYPE_XYZ) then sumtype=SUMMON_TYPE_XYZ 
	elseif tc:IsType(TYPE_FUSION) then sumtype=SUMMON_TYPE_FUSION 
	elseif tc:IsType(TYPE_SYNCHRO) then sumtype=SUMMON_TYPE_SYNCHRO 
	end
	c10199010.Easy_Funtcion_Overlay(tc,tp,10199005,2)
	Duel.SpecialSummon(tc,sumtype,tp,tp,nocondition,false,POS_FACEUP)
	tc:CompleteProcedure()
end
function c10199010.spsummonablefilter2(c,e,tp,nocondition)
	local sumtype=0
	if c:IsType(TYPE_XYZ) then sumtype=SUMMON_TYPE_XYZ 
	elseif c:IsType(TYPE_FUSION) then sumtype=SUMMON_TYPE_FUSION 
	elseif c:IsType(TYPE_SYNCHRO) then sumtype=SUMMON_TYPE_SYNCHRO 
	end
	return c:IsCanBeSpecialSummoned(e,sumtype,tp,false,nocondition) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c10199010.activatefilter(c,tp)
	return c:IsType(TYPE_QUICKPLAY+TYPE_TRAP) and ((c:IsLocation(LOCATION_DECK) and Duel.GetDecktopGroup(tp,Duel.GetDrawCount(tp)):IsContains(c)) or c:IsLocation(LOCATION_HAND)) and c:IsActivatable(tp)
end
function c10199010.Mode_Function_Skill(e,tp) 
	c10199010.Easy_Funtcion_ConfirmCards(10199003) 
	local op1,op2,op3,op4,str=0,0,0,0,"先攻玩家"
	Debug.Message("技能模式-双方玩家各有3个技能点可以用来分配不同技能。")
	for i=0,1 do
	  local SkillPoint=3
	  if i==1 then str="后攻玩家" end
	  Debug.Message(str.."选择技能中……")
	  while SkillPoint>0 do
		 Duel.Hint(HINT_SELECTMSG,i,aux.Stringid(10199010,6))
		 if SkillPoint>=3 then
			op1=Duel.SelectOption(i,aux.Stringid(10199003,0),aux.Stringid(10199003,1),aux.Stringid(10199003,2))
		 elseif SkillPoint>=2 then
			op1=Duel.SelectOption(i,aux.Stringid(10199003,0),aux.Stringid(10199003,1))
		 else
			op1=Duel.SelectOption(i,aux.Stringid(10199003,0))
		 end
		 Duel.Hint(HINT_SELECTMSG,i,aux.Stringid(10199010,6))
		 if op1==0 then
			if c10199010.Mode_IsRandomBuffMode then
			   op2=Duel.SelectOption(i,aux.Stringid(10199003,4),aux.Stringid(10199003,5),aux.Stringid(10199003,6),aux.Stringid(10199003,7),aux.Stringid(10199003,3))
			else
			   op2=Duel.SelectOption(i,aux.Stringid(10199003,5),aux.Stringid(10199003,6),aux.Stringid(10199003,7),aux.Stringid(10199003,3))
			end
			if op2==0 and c10199010.Mode_IsRandomBuffMode then
			   SkillPoint=SkillPoint-1
			   c10199010.Mode_Skill_BetterBuff(e,i)
			elseif op2==0 or (op2==1 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-1
			   c10199010.Mode_Skill_CardShopper(e,i)
			elseif op2==1 or (op2==2 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-1
			   c10199010.LockLpCount[i]=c10199010.LockLpCount[i]+1
			   c10199010.Mode_Skill_LockLp(e,i)
			elseif op2==2 or (op2==3 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-1
			   c10199010.FlashPrintCount[i]=c10199010.FlashPrintCount[i]+1
			   c10199010.Mode_Skill_FlashPrint(e,i)
			end
		 end
		 if op1==1 then
			if c10199010.Mode_IsRandomBuffMode then
			   op3=Duel.SelectOption(i,aux.Stringid(10199003,12),aux.Stringid(10199003,13),aux.Stringid(10199003,14),aux.Stringid(10199003,15),aux.Stringid(10199003,3))
			else
			   op3=Duel.SelectOption(i,aux.Stringid(10199003,13),aux.Stringid(10199003,14),aux.Stringid(10199003,15),aux.Stringid(10199003,3))
			end
			if op3==0 and c10199010.Mode_IsRandomBuffMode then
			   SkillPoint=SkillPoint-2
			   c10199010.Mode_Skill_ReselectBuff(e,i)
			elseif op3==0 or (op3==1 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-2
			   c10199010.BetterDrawCount[i]=c10199010.BetterDrawCount[i]+1
			   c10199010.Mode_Skill_BetterDraw(e,i)
			elseif op3==1 or (op3==2 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-2
			   c10199010.Mode_Skill_Atkup(e,i)
			elseif op3==2 or (op3==3 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-2
			   c10199010.Mode_Skill_DoubleHp(e,i)
			end
		 end
		 if op1==2 then
			if c10199010.Mode_IsRandomBuffMode then
			   op4=Duel.SelectOption(i,aux.Stringid(10199004,1),aux.Stringid(10199004,2),aux.Stringid(10199004,3),aux.Stringid(10199004,4),aux.Stringid(10199003,3))
			else
			   op4=Duel.SelectOption(i,aux.Stringid(10199004,2),aux.Stringid(10199004,3),aux.Stringid(10199004,4),aux.Stringid(10199003,3))
			end
			if op4==0 and c10199010.Mode_IsRandomBuffMode then
			   SkillPoint=SkillPoint-3
			   c10199010.Mode_Skill_SuperBuff(e,i)
			elseif op4==0 or (op4==1 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-3
			   c10199010.Mode_Skill_SuperDraw(e,i)
			elseif op4==1 or (op4==2 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-3
			   c10199010.Mode_Skill_SuperProtect(e,i)
			elseif op4==2 or (op4==3 and c10199010.Mode_IsRandomBuffMode) then
			   SkillPoint=SkillPoint-3
			   c10199010.SuperChaosCount[i]=c10199010.SuperChaosCount[i]+1
			   c10199010.Mode_Skill_SuperChaos(e,i)
			end
		 end
	  end
	end
end
function c10199010.Mode_Skill_SuperBuff(e,tp)
	Duel.RegisterFlagEffect(tp,101990107,0,0,0)
end
function c10199010.Mode_Skill_SuperDraw(e,tp)
	if Duel.GetFlagEffect(tp,101990108)==0 then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_DRAW)
	   e1:SetProperty(EFFECT_FLAG_DELAY)
	   e1:SetCondition(c10199010.superdrawcon)
	   e1:SetOperation(c10199010.superdrawop)
	   Duel.RegisterEffect(e1,tp)
	   e1:SetLabel(tp)
	end
	Duel.RegisterFlagEffect(tp,101990108,0,0,0)
end
function c10199010.superdrawcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return Duel.IsPlayerCanDraw(p,1) and ep==p and re~=e 
end
function c10199010.superdrawop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if c10199010.Mode_Skill_SuperDraw_Extra1(e,p,ep,re) then
	   c10199010.Mode_Skill_SuperDraw_Extra2(e,p)
	end
end
function c10199010.Mode_Skill_SuperDraw_Extra1(e,tp,ep,re)
	local ct,random=math.min(Duel.GetFlagEffect(tp,101990108)*4,10),math.random(1,10)
	if ct>=random then return true
	else return false
	end
end
function c10199010.Mode_Skill_SuperDraw_Extra2(e,tp)
	local str=c10199010.Easy_Funtcion_ShowString(tp)
	Duel.Hint(HINT_CARD,0,55144522)
	Debug.Message(str.."-Skill-超级抽卡")
	Duel.Draw(tp,1,REASON_RULE)
end
function c10199010.Mode_Skill_SuperProtect(e,tp)
	if Duel.GetFlagEffect(tp,101990109)==0 then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_IMMUNE_EFFECT)
	   e1:SetTargetRange(LOCATION_MZONE,0)
	   e1:SetTarget(aux.TargetBoolFunction(Card.IsStatus,STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SET_TURN))
	   e1:SetValue(c10199010.superprotectvl)
	   Duel.RegisterEffect(e1,tp)
	   Duel.RegisterFlagEffect(tp,101990109,0,0,0)
	end
end
function c10199010.superprotectvl(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10199010.Mode_Skill_SuperChaos(e,tp)
	if Duel.GetFlagEffect(tp,101990110)==0 then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	   e1:SetProperty(EFFECT_FLAG_DELAY)
	   e1:SetCondition(c10199010.superchaoscon)
	   e1:SetOperation(c10199010.superchaosop)
	   Duel.RegisterEffect(e1,tp)
	   e1:SetLabel(tp)
	   Duel.RegisterFlagEffect(tp,101990110,0,0,0)
	end
end
function c10199010.superchaoscon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return ep==p and ev>=Duel.GetLP(p)
end
function c10199010.superchaosop(e)
	local tp=e:GetLabel()
	if c10199010.Mode_Skill_SuperChaos_Extra1(e,tp) then
	   c10199010.Mode_Skill_SuperChaos_Extra2(e,tp)
	end
end
function c10199010.Mode_Skill_SuperChaos_Extra1(e,tp)
	if c10199010.SuperChaosCount[tp]>0 and Duel.SelectYesNo(tp,aux.Stringid(10199004,5)) then return true
	else return false
	end
end
function c10199010.Mode_Skill_SuperChaos_Extra2(e,tp)
	if Duel.GetAttacker()~=nil then 
	   Duel.SkillSetLP(tp,1)
	   Duel.NegateAttack() 
	end
	local str=c10199010.Easy_Funtcion_ShowString(tp)
	Duel.Hint(HINT_CARD,0,78706415)
	Debug.Message(str.."-Skill-终焉混沌")
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	Duel.SendtoDeck(g,nil,2,REASON_RULE)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	Duel.Draw(tp,5,REASON_RULE)
	Duel.Draw(1-tp,5,REASON_RULE)
	Duel.SkillSetLP(tp,c10199010.BaseLp[tp])
	Duel.SkillSetLP(1-tp,c10199010.BaseLp[1-tp])
	c10199010.SuperChaosCount[tp]=c10199010.SuperChaosCount[tp]-1
end
function c10199010.Mode_Skill_ReselectBuff(e,tp)
	Duel.RegisterFlagEffect(tp,101990105,0,0,0)
end
function c10199010.Mode_Skill_BetterDraw(e,tp)
	if Duel.GetFlagEffect(tp,101990106)==0 then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PREDRAW)
	   e1:SetProperty(EFFECT_FLAG_DELAY)
	   e1:SetCondition(c10199010.betterdrawcon)
	   e1:SetOperation(c10199010.betterdrawop)
	   Duel.RegisterEffect(e1,tp)
	   e1:SetLabel(tp) 
	   Duel.RegisterFlagEffect(tp,101990106,0,0,0)  
	end
end
function c10199010.betterdrawcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return Duel.GetDrawCount(p)>0
end
function c10199010.betterdrawop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if c10199010.Mode_Skill_BetterDraw_Extra1(p,Duel.GetDrawCount(p),true) then
	   c10199010.Mode_Skill_BetterDraw_Extra2(p,Duel.GetDrawCount(p),true)
	end
end
function c10199010.Mode_Skill_BetterDraw_Extra1(tp,count,normaldraw)
	if normaldraw and Duel.GetDrawCount(tp)==0 then return false end
	if c10199010.BetterDrawCount[tp]>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>count and Duel.SelectYesNo(tp,aux.Stringid(10199004,0)) then return true
	else return false
	end
end
function c10199010.Mode_Skill_BetterDraw_Extra2(tp,count,normaldraw)
	local ct,str=math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),c10199010.BetterDrawCount[tp]+count),c10199010.Easy_Funtcion_ShowString(tp)
	Duel.Hint(HINT_CARD,0,96677818)
	Debug.Message(str.."-Skill-抽卡辅助")
	Duel.SortDecktop(tp,tp,ct)
	if normaldraw then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetCode(EFFECT_DRAW_COUNT)
	   e1:SetTargetRange(1,0)
	   e1:SetReset(RESET_PHASE+PHASE_DRAW)
	   e1:SetValue(0)
	   Duel.RegisterEffect(e1,tp)
	   Duel.Draw(tp,count,REASON_RULE)
	   Duel.ShuffleDeck(tp)
	end
end
function c10199010.Mode_Skill_Atkup(e,tp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(300)
	Duel.RegisterEffect(e1,tp)
end
function c10199010.Mode_Skill_DoubleHp(e,tp)
	Duel.Hint(HINT_CARD,0,84257639)
	local str=c10199010.Easy_Funtcion_ShowString(tp)
	Debug.Message(str.."-Skill-翻倍LP")
	Duel.SkillSetLP(tp,Duel.GetLP(tp)+4000)
end
function c10199010.Mode_Skill_BetterBuff(e,tp)
	Duel.RegisterFlagEffect(tp,101990101,0,0,0)
end
function c10199010.Mode_Skill_CardShopper(e,tp)
	if Duel.GetFlagEffect(tp,101990102)==0 then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_DRAW)
	   e1:SetProperty(EFFECT_FLAG_DELAY)
	   e1:SetCondition(c10199010.cardshoppercon)
	   e1:SetOperation(c10199010.cardshopperop)
	   Duel.RegisterEffect(e1,tp)
	   e1:SetLabel(tp)
	end
	Duel.RegisterFlagEffect(tp,101990102,0,0,0)
end
function c10199010.cardshoppercon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	return Duel.IsPlayerCanDraw(p,eg:GetCount()) and ep==p and re~=e
end
function c10199010.cardshopperop(e,tp,eg,ep,ev,re,r,rp)
	local p,ct,sct=e:GetLabel(),eg:GetCount(),Duel.GetFlagEffect(tp,101990102)
	local str=c10199010.Easy_Funtcion_ShowString(p)
	for i=1,sct do
	  if Duel.SelectYesNo(p,aux.Stringid(10199003,8)) then
		 Duel.Hint(HINT_CARD,0,48712195)
		 Debug.Message(str.."-Skill-卡片商人")
		 Duel.SendtoDeck(eg,nil,2,REASON_RULE)
		 Duel.ShuffleDeck(p)
		 Duel.Draw(p,ct,REASON_RULE)
	  else
		 break
	  end
	end
end
function c10199010.Mode_Skill_LockLp(e,tp)
	if c10199010.LockLpCount[tp]>0 then
	return
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c10199010.locklpop)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabel(tp)
end
function c10199010.locklpop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if ep==p and c10199010.Mode_Skill_LockLp_Extra1(p) then
	   c10199010.Mode_Skill_LockLp_Extra2(p)
	end
end
function c10199010.Mode_Skill_LockLp_Extra1(tp)
	if Duel.GetFlagEffect(tp,101990103)>0 or (c10199010.LockLpCount[tp]>0 and Duel.SelectYesNo(tp,aux.Stringid(10199003,9))) then return true
	else return false
	end
end
function c10199010.Mode_Skill_LockLp_Extra2(tp)
	local str=c10199010.Easy_Funtcion_ShowString(tp)
	if Duel.GetFlagEffect(tp,101990103)==0 then
	   Debug.Message(str.."-Skill锁血")
	   c10199010.LockLpCount[tp]=c10199010.LockLpCount[tp]-1
	   Duel.RegisterFlagEffect(tp,101990103,RESET_PHASE+PHASE_END,0,1)
	else
	   Debug.Message(str.."技能锁血中")
	end
	c10199010.Mode_Skill_LockLp_Extra3(e,p)
end
function c10199010.Mode_Skill_LockLp_Extra3(e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,10199010) then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CHANGE_DAMAGE)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(1,0)
	   e1:SetValue(0)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e2,tp)
	   local e3=e1:Clone()
	   e3:SetCode(10199010)
	   Duel.RegisterEffect(e3,tp)
	end
end
Duel.SkillPayLPCost=Duel.PayLPCost
function Duel.PayLPCost(p,value)
	if c10199010.Mode_Skill_LockLp_Extra1(p) then
	   c10199010.Mode_Skill_LockLp_Extra2(p)
	   Duel.SkillPayLPCost(p,0)
	else
	   Duel.SkillPayLPCost(p,value)
	end
end
Duel.SkillSetLP=Duel.SetLP
function Duel.SetLP(p,value)
	if Duel.GetLP(p)>value and c10199010.Mode_Skill_LockLp_Extra1(p) then
	   c10199010.Mode_Skill_LockLp_Extra2(p)
	   Duel.SkillSetLP(p,Duel.GetLP(p))
	else
	   Duel.SkillSetLP(p,value)
	end
end
Duel.SkillDamage=Duel.Damage
function Duel.Damage(p,value,reason,step)
	if c10199010.Mode_Skill_LockLp_Extra1(p) then
	   c10199010.Mode_Skill_LockLp_Extra2(e,p)
	   Duel.SkillDamage2(p,value,reason,step)
	else
	   Duel.SkillDamage2(p,value,reason,step)
	end
end
function Duel.SkillDamage2(p,value,reason,step)
	if step then
	   Duel.SkillDamage(p,value,reason,step)
	else
	   Duel.SkillDamage(p,value,reason)
	end
end
function c10199010.Mode_Skill_FlashPrint(e,tp)
	if Duel.GetFlagEffect(tp,101990104)==0 then
	   local e1=Effect.GlobalEffect()
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PREDRAW)
	   e1:SetProperty(EFFECT_FLAG_DELAY)
	   e1:SetOperation(c10199010.flashprintop)
	   Duel.RegisterEffect(e1,tp)
	   e1:SetLabel(tp)
	   Duel.RegisterFlagEffect(tp,101990104,0,0,0)
	end
end
function c10199010.flashprintop(e)
	local tp=e:GetLabel()
	if Duel.GetDrawCount(tp)>0 and c10199010.Mode_Skill_FlashPrint_Extra1(tp) then
	   c10199010.Mode_Skill_FlashPrint_Extra2(tp)
	end
end
function c10199010.Mode_Skill_FlashPrint_Extra1(tp)
	if c10199010.FlashPrintCount[tp]>0 and (Duel.GetLP(tp)<=1000 or Duel.GetLP(tp)<=Duel.GetLP(1-tp)-4000) and Duel.SelectYesNo(tp,aux.Stringid(10199003,10)) then return true
	else return false
	end
end
function c10199010.Mode_Skill_FlashPrint_Extra2(tp)
	c10199010.FlashPrintCount[tp]=c10199010.FlashPrintCount[tp]-1
	local str=c10199010.Easy_Funtcion_ShowString(tp)
	Debug.Message(str.."-Skill-命运印卡！")
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	local tc=Duel.CreateToken(tp,ac)
	Duel.SendtoDeck(tc,tp,0,REASON_RULE)
end
Duel.SkillDraw=Duel.Draw
function Duel.Draw(p,count,reason)
	if c10199010.Mode_Skill_FlashPrint_Extra1(p) then
	   c10199010.Mode_Skill_FlashPrint_Extra2(p)
	end
	if c10199010.Mode_Skill_BetterDraw_Extra1(p,count) then
	   c10199010.Mode_Skill_BetterDraw_Extra2(p,count)
	   Duel.SkillDraw(p,count,reason)
	   Duel.ShuffleDeck(p)
	else
	   Duel.SkillDraw(p,count,reason)
	end
end
function c10199010.Easy_Funtcion_SetAddCardFlag(gc,flag)
	local g=c10199010.Easy_Funtcion_CompareGroupOrCard(gc)
	local tc=g:GetFirst()
	while tc do
		  tc:RegisterFlagEffect(flag,0,0,0)
	tc=g:GetNext()
	end
end
function c10199010.Easy_Funtcion_CompareGroupOrCard(gc)
	local g=Group.CreateGroup()
	if getmetatable(gc)==Group then
	   g:Merge(gc)
	else 
	   g:AddCard(gc)
	end
	return g   
end
function c10199010.Easy_Funtcion_Randombuff_Reselect(e,tp,str,filter,force,confirm)
	local ct,rct=math.min(Duel.GetFlagEffect(tp,101990101)*3,10),math.random(1,10)
	if (ct>0 and ct>=rct and filter~=true) or (filter~=true and force==true) then
	   c10199010.Mode_RandomBuff_ChooseBuff_Extra1(e,tp,str,0,confirm)
	return true
	else
	return false
	end
end
function c10199010.Easy_Funtcion_ShowString_Randombuff(tp,str1,str2,str3,code,confirm)
	local ct,str=Duel.GetFlagEffect(tp,101990107),c10199010.Easy_Funtcion_ShowString(tp)
	local buffstr=""
	if Duel.GetFlagEffect(tp,101990105)>0 and confirm==true then
	   buffstr="-Skill-重选"
	end
	Duel.Hint(HINT_CARD,0,code)
	if ct==1 then 
	   Debug.Message(str..buffstr.."-Buff☆"..c10199010.Mode_RandomBuffCount[tp].."-"..str2)
	elseif ct>1 then
	   Debug.Message(str..buffstr.."-Buff★"..c10199010.Mode_RandomBuffCount[tp].."-"..str3)
	elseif ct==0 then
	   Debug.Message(str..buffstr.."-Buff"..c10199010.Mode_RandomBuffCount[tp].."-"..str1)
	end
	if buffstr=="-Skill-重选" then
	   return true
	else 
	   return false
	end
end
function c10199010.Easy_Funtcion_ConfirmCards(code) 
	local tk=Duel.CreateToken(0,code)
	Duel.MoveToField(tk,0,0,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	Duel.HintSelection(Group.FromCards(tk))
	Duel.SendtoDeck(tk,0,-1,REASON_RULE)
end
function c10199010.Easy_Funtcion_Overlay(gc,tp,code,count)
   local g=c10199010.Easy_Funtcion_CompareGroupOrCard(gc)
   local tc=g:GetFirst()
   while tc do
	  if tc:IsType(TYPE_XYZ) then
		 local og=Group.CreateGroup()
		 for i=1,count do
			 og:AddCard(Duel.CreateToken(tp,code))
		 end
		 Duel.Remove(og,POS_FACEUP,REASON_RULE)
		 Duel.Overlay(tc,og)
		 c10199010.Easy_Funtcion_SetAddCardFlag(og,101990111)
	  end
   tc=g:GetNext()
   end
end
function c10199010.Easy_Funtcion_ShowString(tp)
   local str="tp"
   if Duel.GetTurnPlayer()~=tp then
	  str="op"
   end
   return str
end
Duel.SkillSendtoDeck=Duel.SendtoDeck
function Duel.SendtoDeck(gc,tp,seq,reason)
   local g=c10199010.Easy_Funtcion_CompareGroupOrCard(gc)
   local tg=g:Filter(c10199010.sendtodeckfilter,nil)
   if tg:GetCount()>0 then
	  Duel.SkillSendtoDeck(tg,tp,-1,REASON_RULE)
	  g:Sub(tg)
   end
   if g:GetCount()>0 then
	  Duel.SkillSendtoDeck(g,tp,seq,reason)
   end 
end
function c10199010.sendtodeckfilter(c)
   return c:GetFlagEffect(101990111)>0
end


















