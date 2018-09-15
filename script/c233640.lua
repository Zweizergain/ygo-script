--云游城
function c233640.initial_effect(c)
    --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(233640,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c233640.sumtg)
	e1:SetOperation(c233640.sumop)
	c:RegisterEffect(e1)
	--synchro summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(233640,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c233640.sycon)
	e2:SetTarget(c233640.sytg)
	e2:SetOperation(c233640.syop)
	c:RegisterEffect(e2)
end	
function c233640.filter(c,e,tp)
	return c:IsLevelBelow(5)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c233640.rfilter(c)
	return c:GetLevel()==9  and c:IsReleasable()
end
function c233640.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c233640.filter,tp,0x1,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c233640.rfilter,tp,0x4,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ct=Duel.GetMatchingGroupCount(c233640.filter,tp,0x1,0,nil,e,tp) 
	local g1=Duel.SelectTarget(tp,c233640.rfilter,tp,0x4,0,1,ct,nil)
    local ft=Duel.Release(g1,0x40) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c233640.filter,tp,0x1,0,ft,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,g2:GetCount(),0,0)
end
function c233640.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,0x5) 
	end
end
function c233640.sycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c233640.yfilter(c,e,tp)
    local lv=c:GetLevel()
	return c:IsType(0x2000) and lv>0 and Duel.IsExistingMatchingCard(c233640.filter2,tp,0x40,0,1,nil,lv,e,tp) and c:IsAbleToDeck()
end
function c233640.filter2(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0x46000000,tp,true,false)
end
function c233640.sytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c233640.yfilter,tp,0x4,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c233640.yfilter,tp,0x4,0,1,1,nil,e,tp)
    if Duel.SendtoDeck(g1,nil,2,0x40)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c233640.filter2,tp,0x40,0,1,1,nil,g1:GetFirst():GetLevel(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	end
end
function c233640.syop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0x46000000,tp,tp,true,false,0x5) 
		tc:CompleteProcedure() 
	end
end
