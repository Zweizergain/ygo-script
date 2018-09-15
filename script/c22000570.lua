--从者Archer 织田信长
function c22000570.initial_effect(c)
	c:EnableReviveLimit()
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22000570,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22000570.synchrocon)
	e1:SetTarget(c22000570.synchrotg)
	e1:SetOperation(c22000570.synchroop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22000570,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.XyzCondition(nil,4,2,2))
	e2:SetTarget(Auxiliary.XyzTarget(nil,4,2,2))
	e2:SetOperation(c22000570.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22000570,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c22000570.remcon)
	e3:SetTarget(c22000570.ttg)
	e3:SetOperation(c22000570.top)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22000570,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c22000570.atkcost)
	e4:SetTarget(c22000570.tktg)
	e4:SetOperation(c22000570.tkop)
	c:RegisterEffect(e4)
end
function c22000570.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if og and not min then
	   local sg=Group.CreateGroup()
	   for tc in aux.Next(og) do
		   local sg1=tc:GetOverlayGroup()
		   sg:Merge(sg1)
	   end
	   Duel.SendtoGrave(sg,REASON_RULE)
	   c:SetMaterial(og)
	   Duel.Overlay(c,og)
	else
	   local mg=e:GetLabelObject()
	   local sg=Group.CreateGroup()
	   local tc=mg:GetFirst()
	   for tc in aux.Next(mg) do
		   local sg1=tc:GetOverlayGroup()
		   sg:Merge(sg1)
	   end
	   Duel.SendtoGrave(sg,REASON_RULE)
	   c:SetMaterial(mg)
	   Duel.Overlay(c,mg)
	   mg:DeleteGroup()
	end
end
function c22000570.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(aux.SynMaterialFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	--if mg:IsExists(Card.GetHandSynchro,1,nil) then
	   --local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		--if mg2:GetCount()>0 then mg:Merge(mg2) end
	--end
	return mg
end
function c22000570.SynMixFilter1(c,minc,maxc,syncard,mg,smat)
	return c:IsType(TYPE_TUNER) and mg:IsExists(c22000570.SynMixFilter2,1,c,minc,maxc,syncard,mg,smat,c,nil,nil)
end
function c22000570.SynMixFilter2(c,minc,maxc,syncard,mg1,smat,c1,c2,c3)
	if not c:IsNotTuner() then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	mg=mg:Filter(Card.IsNotTuner,nil)
	return c22000570.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat)
end
function c22000570.SynMixCheck(mg,sg1,minc,maxc,syncard,smat)
	local tp=syncard:GetControler()
	for c in aux.Next(sg1) do
		mg:RemoveCard(c)
	end
	local sg=Group.CreateGroup()
	if minc==0 and c22000570.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat) then return true end
	if maxc==0 then return false end
	return mg:IsExists(c22000570.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat)
end
function c22000570.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if smat and not g:IsContains(smat) then return false end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	if pe and not g:IsContains(pe:GetOwner()) then return false end
	if not g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and not syncard:IsHasEffect(80896940) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,8,g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,8,g:GetCount(),g:GetCount(),syncard))
		then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he) then return false end
				if (hmin and ct<hmin) or (hmax and ct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	--for c in aux.Next(g) do
		--local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		--if le then
			--local ct=g:GetCount()-1
			--if lloc then
				--local lg=g:Filter(Card.IsLocation,c,lloc)
				--if lg:GetCount()~=ct then return false end
			--end
			--if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le) then return false end
			--if (lmin and ct<lmin) or (lmax and ct>lmax) then return false end
		--end
	--end
	return true
end
function c22000570.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat)
	sg:AddCard(c)
	ct=ct+1
	local res=c22000570.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
		or (ct<maxc and mg:IsExists(aux.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c22000570.synchrocon(e,c,smat,mg1)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg
	if mg1 then
	   mg=mg1
	else
	   mg=c22000570.GetSynMaterials(tp,c)
	end
	return mg:IsExists(c22000570.SynMixFilter1,1,nil,1,99,c,mg,smat)
end
function c22000570.synchrotg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
	local g=Group.CreateGroup()
	local mg
	if mg1 then
	   mg=mg1
	else
	   mg=c22000570.GetSynMaterials(tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local c1=mg:FilterSelect(tp,c22000570.SynMixFilter1,1,1,nil,1,99,c,mg,smat):GetFirst()
	g:AddCard(c1)
	local g2=Group.CreateGroup()
	for i=0,98 do
		local mg2=mg:Clone()
		--if f4 then
		   mg2=mg2:Filter(Card.IsNotTuner,nil)
		--end
		local cg=mg2:Filter(c22000570.SynMixCheckRecursive,g2,tp,g2,mg2,i,1,99,c,g,smat)
		if cg:GetCount()==0 then break end
		   local minct=1
		   if c22000570.SynMixCheckGoal(tp,g2,1,i,c,g,smat) then
			  if not Duel.SelectYesNo(tp,210) then break end
			  minct=0
		   end
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		   local tg=cg:Select(tp,minct,1,nil)
		   if tg:GetCount()==0 then 
		   break 
		   end
		   g2:Merge(tg)
		end
		g:Merge(g2)
		if g:GetCount()>0 then
		   g:KeepAlive()
		   e:SetLabelObject(g)
		   return true
		   else return false 
		end
end
function c22000570.synchroop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   local g=e:GetLabelObject()
   c:SetMaterial(g)
   Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
   g:DeleteGroup()
end
function c22000570.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22000570.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22000571,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c22000570.top(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22000571,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
		for i=1,3 do
			local token=Duel.CreateToken(tp,22000570+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
end
function c22000570.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22000570.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c22000570.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22000571,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22000571,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,1-tp) 
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token1=Duel.CreateToken(tp,22000571)
	local token2=Duel.CreateToken(tp,22000571)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
