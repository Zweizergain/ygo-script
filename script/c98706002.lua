--神影依·文迪戈
function c98706002.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c98706002.fuscon)
	e1:SetOperation(c98706002.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c98706002.splimit)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98706002,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,98706002)
	e3:SetTarget(c98706002.controltg)
	e3:SetOperation(c98706002.controlop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98706002,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c98706002.thtg)
	e4:SetOperation(c98706002.thop)
	c:RegisterEffect(e4)
end
function c98706002.ffilter1(c)
	return c:IsFusionSetCard(0x9d) and not c:IsHasEffect(6205579)
end
function c98706002.ffilter2(c)
	return (c:IsFusionAttribute(ATTRIBUTE_WIND) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579)
end
function c98706002.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c98706002.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98706002.exfilter,tp,0,LOCATION_MZONE,nil,mg)
		exg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return (c98706002.ffilter1(gc) and (mg:IsExists(c98706002.ffilter2,1,gc) or exg:IsExists(c98706002.ffilter2,1,gc)))
			or (c98706002.ffilter2(gc) and (mg:IsExists(c98706002.ffilter1,1,gc) or exg:IsExists(c98706002.ffilter1,1,gc)))
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	local g4=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		if c98706002.ffilter1(tc) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g3:AddCard(tc) end
		end
		if c98706002.ffilter2(tc) then
			g2:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g4:AddCard(tc) end
		end
		tc=mg:GetNext()
	end
	local exg1=exg:Filter(c98706002.ffilter1,nil)
	local exg2=exg:Filter(c98706002.ffilter2,nil)
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
function c98706002.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98706002.exfilter,tp,0,LOCATION_MZONE,nil,g)
		exg:Merge(sg)
	end
	if gc then
		local sg1=Group.CreateGroup()
		local sg2=Group.CreateGroup()
		if c98706002.ffilter1(gc) then
			sg1:Merge(g:Filter(c98706002.ffilter2,gc))
			sg2:Merge(exg:Filter(c98706002.ffilter2,gc))
		end
		if c98706002.ffilter2(gc) then
			sg1:Merge(g:Filter(c98706002.ffilter1,gc))
			sg2:Merge(exg:Filter(c98706002.ffilter1,gc))
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
	local sg=g:Filter(aux.FConditionFilterF2c,nil,c98706002.ffilter1,c98706002.ffilter2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	if c98706002.ffilter1(tc1) then
		sg1:Merge(sg:Filter(c98706002.ffilter2,tc1))
		sg2:Merge(exg:Filter(c98706002.ffilter2,tc1))
	end
	if c98706002.ffilter2(tc1) then
		sg1:Merge(sg:Filter(c98706002.ffilter1,tc1))
		sg2:Merge(exg:Filter(c98706002.ffilter1,tc1))
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
function c98706002.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98706002.controlfilter(c)
	return c:IsControlerCanBeChanged() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c98706002.filter(c)
	return c:IsSetCard(0x9d)
end
function c98706002.controltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and c98706002.controlfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98706002.controlfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c98706002.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c98706002.controlfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c98706002.controlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)~=nil then
		--target
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c98706002.tlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000+EVENT_CONTROL_CHANGED)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c98706002.tlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000+EVENT_CONTROL_CHANGED)
		e2:SetValue(aux.tgoval)
		tc:RegisterEffect(e2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98706002.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c98706002.tlimit(e,c)
	return c~=e:GetHandler()
end
function c98706002.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98706002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98706002.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98706002.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98706002.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98706002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
