--神影依·异花莉莉丝
function c98706001.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c98706001.fuscon)
	e1:SetOperation(c98706001.fusop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c98706001.splimit)
	c:RegisterEffect(e2)
	--Negate 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98706001,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98706001)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c98706001.ncon)
	e3:SetTarget(c98706001.ntg)
	e3:SetOperation(c98706001.nop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98706001,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c98706001.thtg)
	e4:SetOperation(c98706001.thop)
	c:RegisterEffect(e4)
end
function c98706001.ffilter1(c)
	return c:IsFusionSetCard(0x9d) and not c:IsHasEffect(6205579)
end
function c98706001.ffilter2(c)
	return (c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579)
end
function c98706001.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c98706001.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98706001.exfilter,tp,0,LOCATION_MZONE,nil,mg)
		exg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return (c98706001.ffilter1(gc) and (mg:IsExists(c98706001.ffilter2,1,gc) or exg:IsExists(c98706001.ffilter2,1,gc)))
			or (c98706001.ffilter2(gc) and (mg:IsExists(c98706001.ffilter1,1,gc) or exg:IsExists(c98706001.ffilter1,1,gc)))
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	local g4=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		if c98706001.ffilter1(tc) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g3:AddCard(tc) end
		end
		if c98706001.ffilter2(tc) then
			g2:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g4:AddCard(tc) end
		end
		tc=mg:GetNext()
	end
	local exg1=exg:Filter(c98706001.ffilter1,nil)
	local exg2=exg:Filter(c98706001.ffilter2,nil)
	if chkf~=PLAYER_NONE then
		return (g3:IsExists(aux.FConditionFilterF2,1,nil,g2)
			or g3:IsExists(aux.FConditionFilterF2,1,nil,exg2)
			or g4:IsExists(aux.FConditionFilterF2,1,nil,g1)
			or g4:IsExists(aux.FConditionFilterF2,1,nil,exg1))
	else
		return (g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
			or g1:IsExists(aux.FConditionFilterF2,1,nil,exg2)
			or g2:IsExists(aux.FConditionFilterF2,1,nil,exg1))
	end
end
function c98706001.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98706001.exfilter,tp,0,LOCATION_MZONE,nil,g)
		exg:Merge(sg)
	end
	if gc then
		local sg1=Group.CreateGroup()
		local sg2=Group.CreateGroup()
		if c98706001.ffilter1(gc) then
			sg1:Merge(g:Filter(c98706001.ffilter2,gc))
			sg2:Merge(exg:Filter(c98706001.ffilter2,gc))
		end
		if c98706001.ffilter2(gc) then
			sg1:Merge(g:Filter(c98706001.ffilter1,gc))
			sg2:Merge(exg:Filter(c98706001.ffilter1,gc))
		end
		local g1=nil
		if sg1:GetCount()==0 or (sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0))) then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g1=sg2:Select(tp,1,1,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g1=sg1:Select(tp,1,1,nil)
		end
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(aux.FConditionFilterF2c,nil,c98706001.ffilter1,c98706001.ffilter2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	if c98706001.ffilter1(tc1) then
		sg1:Merge(sg:Filter(c98706001.ffilter2,tc1))
		sg2:Merge(exg:Filter(c98706001.ffilter2,tc1))
	end
	if c98706001.ffilter2(tc1) then
		sg1:Merge(sg:Filter(c98706001.ffilter1,tc1))
		sg2:Merge(exg:Filter(c98706001.ffilter1,tc1))
	end
	local g2=nil
	if sg1:GetCount()==0 or (sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0))) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2=sg2:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2=sg1:Select(tp,1,1,nil)
	end
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c98706001.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98706001.ncon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and Duel.IsChainNegatable(ev)
end
function c98706001.filter(c)
	return c:IsSetCard(0x9d)
end
function c98706001.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98706001.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c98706001.nop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98706001.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c98706001.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98706001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98706001.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98706001.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98706001.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98706001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
