--从者Lancer 贞德·A·S·L
function c22000640.initial_effect(c)
	c:EnableReviveLimit()
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22000640,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22000640.synchrocon)
	e1:SetTarget(c22000640.synchrotg)
	e1:SetOperation(c22000640.synchroop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22000640,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.XyzCondition(nil,4,2,2))
	e2:SetTarget(Auxiliary.XyzTarget(nil,4,2,2))
	e2:SetOperation(c22000640.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22000640,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22000640)
	e3:SetCondition(c22000640.condition)
	e3:SetCost(c22000640.cost)
	e3:SetTarget(c22000640.target)
	e3:SetOperation(c22000640.activate)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22000640,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22000640)
	e4:SetCondition(c22000640.spcon)
	e4:SetCost(c22000640.spcost)
	e4:SetTarget(c22000640.sptg)
	e4:SetOperation(c22000640.spop)
	c:RegisterEffect(e4)
end
function c22000640.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c22000640.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(aux.SynMaterialFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	--if mg:IsExists(Card.GetHandSynchro,1,nil) then
	   --local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		--if mg2:GetCount()>0 then mg:Merge(mg2) end
	--end
	return mg
end
function c22000640.SynMixFilter1(c,minc,maxc,syncard,mg,smat)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0xffe) and mg:IsExists(c22000640.SynMixFilter2,1,c,minc,maxc,syncard,mg,smat,c,nil,nil)
end
function c22000640.SynMixFilter2(c,minc,maxc,syncard,mg1,smat,c1,c2,c3)
	if not c:IsNotTuner() then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	mg=mg:Filter(Card.IsNotTuner,nil)
	return c22000640.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat)
end
function c22000640.SynMixCheck(mg,sg1,minc,maxc,syncard,smat)
	local tp=syncard:GetControler()
	for c in aux.Next(sg1) do
		mg:RemoveCard(c)
	end
	local sg=Group.CreateGroup()
	if minc==0 and c22000640.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat) then return true end
	if maxc==0 then return false end
	return mg:IsExists(c22000640.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat)
end
function c22000640.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
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
function c22000640.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat)
	sg:AddCard(c)
	ct=ct+1
	local res=c22000640.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
		or (ct<maxc and mg:IsExists(aux.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c22000640.synchrocon(e,c,smat,mg1)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg
	if mg1 then
	   mg=mg1
	else
	   mg=c22000640.GetSynMaterials(tp,c)
	end
	return mg:IsExists(c22000640.SynMixFilter1,1,nil,1,99,c,mg,smat)
end
function c22000640.synchrotg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
	local g=Group.CreateGroup()
	local mg
	if mg1 then
	   mg=mg1
	else
	   mg=c22000640.GetSynMaterials(tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local c1=mg:FilterSelect(tp,c22000640.SynMixFilter1,1,1,nil,1,99,c,mg,smat):GetFirst()
	g:AddCard(c1)
	local g2=Group.CreateGroup()
	for i=0,98 do
		local mg2=mg:Clone()
		--if f4 then
		   mg2=mg2:Filter(Card.IsNotTuner,nil)
		--end
		local cg=mg2:Filter(c22000640.SynMixCheckRecursive,g2,tp,g2,mg2,i,1,99,c,g,smat)
		if cg:GetCount()==0 then break end
		   local minct=1
		   if c22000640.SynMixCheckGoal(tp,g2,1,i,c,g,smat) then
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
function c22000640.synchroop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   local g=e:GetLabelObject()
   c:SetMaterial(g)
   Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
   g:DeleteGroup()
end
function c22000640.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22000640.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22000640.filter(c,e,tp,lp)
	return bit.band(c:GetType(),0x81)==0x81 and (c:IsCode(22000240) or c:IsCode(22000250)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c22000640.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000640.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22000640.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22000640.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c22000640.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xfff)
end
function c22000640.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) and c:GetFlagEffect(22000640)==0 end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
	c:RegisterFlagEffect(22000640,RESET_CHAIN,0,1)
end
function c22000640.filter1(c,e,tp,rk)
	return c:IsCode(22000190) and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c22000640.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c22000640.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22000640.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22000640.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end