--星辉号·德鲁迦伯爵
function c10100024.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10100024.sprcon)
	e2:SetOperation(c10100024.sprop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100024,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,10100024)
	e3:SetTarget(c10100024.sptg)
	e3:SetOperation(c10100024.spop)
	c:RegisterEffect(e3)   
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	e4:SetCondition(c10100024.incon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5) 
end
function c10100024.incon(e)
	return not Duel.IsEnvironment(10107001)
end
function c10100024.filter(c,e,tp,id)
	return c:IsSetCard(0x3330) and c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10100024.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10100024.filter(chkc,e,tp,Duel.GetTurnCount()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10100024.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	local ft=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10100024.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c10100024.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c10100024.spfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x3330) and c:IsType(TYPE_MONSTER)
end
function c10100024.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10100024.spfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.IsCode)>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function c10100024.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c10100024.spfilter,tp,LOCATION_GRAVE,0,nil)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g1:Select(tp,1,1,nil):GetFirst()
		g:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end