--糖果派 奶油酥
function c10108006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c10108006.fuscon)
	e0:SetOperation(c10108006.fusop)
	c:RegisterEffect(e0)
	--spsummon condition
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_SINGLE)
	ec:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ec:SetCode(EFFECT_SPSUMMON_CONDITION)
	ec:SetValue(c10108006.splimit)
	c:RegisterEffect(ec)
	--special summon
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_FIELD)
	es:SetCode(EFFECT_SPSUMMON_PROC)
	es:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	es:SetRange(LOCATION_EXTRA)
	es:SetCondition(c10108006.spcon)
	es:SetOperation(c10108006.spop)
	c:RegisterEffect(es)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c10108006.efftg)
	e1:SetCode(10108006)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10108006,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10108006.tdtg)
	e2:SetOperation(c10108006.tdop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetCondition(c10108006.recon)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
	--cannot be fusion material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	c10108006[c]=e2
end
function c10108006.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c10108006.sprfilter1(c,tp,fc)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and not c:IsFusionType(TYPE_TUNER) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable() and (c:IsControler(tp) or c:IsHasEffect(10108002)) and Duel.IsExistingMatchingCard(c10108006.sprfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp,fc)
end
function c10108006.sprfilter2(c,tp,fc)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and not c:IsFusionType(TYPE_TUNER) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable() and (c:IsControler(tp) or c:IsHasEffect(10108002))
end
function c10108006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE 
	if ft<=0 then loc=0 end
	return Duel.IsExistingMatchingCard(c10108006.sprfilter1,tp,LOCATION_MZONE,loc,1,nil,tp,c)
end
function c10108006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft,loc=Duel.GetLocationCount(tp,LOCATION_MZONE),LOCATION_MZONE 
	if ft<=0 then loc=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c10108006.sprfilter1,tp,LOCATION_MZONE,loc,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c10108006.sprfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst(),tp,c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c10108006.ffilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and not c:IsHasEffect(6205579) and not c:IsFusionType(TYPE_TUNER)
end
function c10108006.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsHasEffect(10108002) and not g:IsContains(c)
end
function c10108006.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local tp=e:GetHandlerPlayer()
	local exg=Group.CreateGroup()
	local sg=Duel.GetMatchingGroup(c10108006.exfilter,tp,0,LOCATION_MZONE,nil,mg)
	if sg:GetCount()>0 then
	   exg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return c10108006.ffilter2(gc) and (mg:IsExists(c10108006.ffilter1,1,gc)or exg:IsExists(c10108006.ffilter1,1,gc))	
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		if c10108012.ffilter1(tc) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g2:AddCard(tc) end
		end
		tc=mg:GetNext()
	end
	local exg1=exg:Filter(c10108006.ffilter1,nil,nil)
	if chkf~=PLAYER_NONE then
		return (g2:GetCount()>=2
			or g2:IsExists(aux.FConditionFilterF2,1,nil,exg1)
			or exg1:IsExists(aux.FConditionFilterF2,1,nil,g2))
	else
		return (g1:GetCount()>=2
			or g1:IsExists(aux.FConditionFilterF2,1,nil,exg1)
			or exg1:IsExists(aux.FConditionFilterF2,1,nil,g1))
	end
end
function c10108006.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local fg=Duel.GetMatchingGroup(c10108006.exfilter,tp,0,LOCATION_MZONE,nil,g)
	if fg:GetCount()>0 then
	   g:Merge(fg)
	end
	if gc then
		local sg1=Group.CreateGroup()
		if c10108006.ffilter1(gc) then
			sg1:Merge(g:Filter(c10108006.ffilter1,gc,nil))
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg1:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(c10108006.ffilter1,nil,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	sg1:Merge(sg:Filter(c10108006.ffilter1,tc1,nil))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg1:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c10108006.recon(e)
	return e:GetHandler():IsFaceup()
end
function c10108006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10108006.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c10108006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
	   local sg=Duel.GetMatchingGroup(c10108006.sumfilter,tp,LOCATION_HAND,0,nil)
	   if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10108006,1)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		  local sg2=sg:Select(tp,1,1,nil)
		  Duel.Summon(tp,sg2:GetFirst(),true,nil)
	   end
	end
end
function c10108006.sumfilter(c)
	return c:IsSetCard(0x9338) and c:IsSummonable(true,nil)
end
function c10108006.efftg(e,c)
	return c:IsSetCard(0x9338)
end