--进化虫·西洛仙蜥
function c98790008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98790008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c98790008.cost)
	e1:SetTarget(c98790008.target)
	e1:SetOperation(c98790008.operation)
	c:RegisterEffect(e1)
	--xyzsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98790008,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98790008)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c98790008.xcost)
	e3:SetTarget(c98790008.xtg)
	e3:SetOperation(c98790008.xop)
	c:RegisterEffect(e3)
end
function c98790008.costfilter(c)
	return c:IsSetCard(0x304e) and c:IsReleasable()
end
function c98790008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(c98790008.costfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c98790008.costfilter,tp,LOCATION_MZONE,0,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c98790008.filter(c,e,tp)
	return c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,151,tp,false,false)
end
function c98790008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98790008.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98790008.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98790008.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,151,tp,tp,false,false,POS_FACEUP)
		local rf=tc.evolreg
		if rf then rf(tc) end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c98790008.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c98790008.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x504e)
end
function c98790008.filter2(c)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c98790008.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98790008.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c98790008.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
		and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98790008,2))
	local g1=Duel.SelectTarget(tp,c98790008.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c98790008.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst())
end
function c98790008.xop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		local sg=g:GetFirst()
		if sg:IsType(TYPE_XYZ) then
			local og=sg:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
		Duel.Overlay(tc,Group.FromCards(sg))
	end
end
