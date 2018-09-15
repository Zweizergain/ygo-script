--季雨 沉着白绀
function c10118005.initial_effect(c)
	c:EnableReviveLimit()
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118005,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10118005.synchrocon)
	e1:SetTarget(c10118005.synchrotg)
	e1:SetOperation(c10118005.synchroop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118005,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.LinkCondition(aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,2,nil))
	e2:SetOperation(c10118005.linkop)
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118005,2))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10118005.sumcon)
	e3:SetTarget(c10118005.sumtg)
	e3:SetOperation(c10118005.sumop)
	e3:SetLabel(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10118005,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10118005.sumcon)
	e4:SetLabel(SUMMON_TYPE_LINK)
	e4:SetTarget(c10118005.sptg)
	e4:SetOperation(c10118005.spop)
	c:RegisterEffect(e4)
end
function c10118005.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10118005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10118005.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10118005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10118005.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10118005.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(e:GetLabel())
end
function c10118005.sumfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSummonable(true,nil)
end
function c10118005.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10118005.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10118005.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10118005.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c10118005.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(aux.SynMaterialFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	--if mg:IsExists(Card.GetHandSynchro,1,nil) then
	   --local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		--if mg2:GetCount()>0 then mg:Merge(mg2) end
	--end
	return mg
end
function c10118005.SynMixFilter1(c,minc,maxc,syncard,mg,smat)
	return c:IsType(TYPE_TUNER) and mg:IsExists(c10118005.SynMixFilter2,1,c,minc,maxc,syncard,mg,smat,c,nil,nil)
end
function c10118005.SynMixFilter2(c,minc,maxc,syncard,mg1,smat,c1,c2,c3)
	if not c:IsNotTuner() then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	mg=mg:Filter(Card.IsNotTuner,nil)
	return c10118005.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat)
end
function c10118005.SynMixCheck(mg,sg1,minc,maxc,syncard,smat)
	local tp=syncard:GetControler()
	for c in aux.Next(sg1) do
		mg:RemoveCard(c)
	end
	local sg=Group.CreateGroup()
	if minc==0 and c10118005.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat) then return true end
	if maxc==0 then return false end
	return mg:IsExists(c10118005.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat)
end
function c10118005.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
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
function c10118005.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat)
	sg:AddCard(c)
	ct=ct+1
	local res=c10118005.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat)
		or (ct<maxc and mg:IsExists(aux.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c10118005.synchrocon(e,c,smat,mg1)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg
	if mg1 then
	   mg=mg1
	else
	   mg=c10118005.GetSynMaterials(tp,c)
	end
	return mg:IsExists(c10118005.SynMixFilter1,1,nil,1,99,c,mg,smat)
end
function c10118005.synchrotg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
	local g=Group.CreateGroup()
	local mg
	if mg1 then
	   mg=mg1
	else
	   mg=c10118005.GetSynMaterials(tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local c1=mg:FilterSelect(tp,c10118005.SynMixFilter1,1,1,nil,1,99,c,mg,smat):GetFirst()
	g:AddCard(c1)
	local g2=Group.CreateGroup()
	for i=0,98 do
		local mg2=mg:Clone()
		--if f4 then
		   mg2=mg2:Filter(Card.IsNotTuner,nil)
		--end
		local cg=mg2:Filter(c10118005.SynMixCheckRecursive,g2,tp,g2,mg2,i,1,99,c,g,smat)
		if cg:GetCount()==0 then break end
		   local minct=1
		   if c10118005.SynMixCheckGoal(tp,g2,1,i,c,g,smat) then
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
function c10118005.synchroop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   local g=e:GetLabelObject()
   c:SetMaterial(g)
   Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
   g:DeleteGroup()
end
function c10118005.linkop(e,tp,eg,ep,ev,re,r,rp,c)
   local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),c)
   local sg=Group.CreateGroup()
   for i=0,1 do
	   local cg=mg:Filter(aux.LCheckRecursive,sg,tp,sg,mg,c,i,1,2,nil)
	   if cg:GetCount()==0 then break end
	   local minct=1
	   if aux.LCheckGoal(tp,sg,c,1,i,nil) then
		  if not Duel.SelectYesNo(tp,210) then break end
		  minct=0
	   end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	   local g=cg:Select(tp,minct,1,nil)
	   if g:GetCount()==0 then return end
	   sg:Merge(g)
   end
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   c:SetMaterial(sg)
   Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end