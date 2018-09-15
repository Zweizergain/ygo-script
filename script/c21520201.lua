--原初八文-乾
function c21520201.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520201.cfilter,1,1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520201,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c21520201.destg)
	e1:SetOperation(c21520201.desop)
	c:RegisterEffect(e1)
	--special summon self from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520201,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c21520201.spgcost)
	e2:SetTarget(c21520201.spgtg)
	e2:SetOperation(c21520201.spgop)
	c:RegisterEffect(e2)
	--special summon from grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520201,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c21520201.spcost)
	e3:SetTarget(c21520201.sptg)
	e3:SetOperation(c21520201.spop)
	c:RegisterEffect(e3)
end
function c21520201.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520201.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_LIGHT) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520201))
	else
		return c:IsLinkAttribute(ATTRIBUTE_LIGHT) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520201.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520201.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c21520201.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c21520201.spgfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000 and c:IsAbleToRemoveAsCost()
end
function c21520201.spgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520201.spgfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520201.spgfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	g:KeepAlive()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g)
end
function c21520201.spgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return Duel.GetMZoneCount(tp,g)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true) end
end
function c21520201.spgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,true,POS_FACEUP)
	end
end
function c21520201.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520201.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c21520201.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21520201.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21520201.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520201.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21520201.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
