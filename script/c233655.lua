--雷魂龙
function c233655.initial_effect(c)
    --todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(233655,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c233655.tdtg)
	e1:SetOperation(c233655.tdop)
	c:RegisterEffect(e1)
end	
function c233655.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0xc,0xc,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0xc,0xc,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c233655.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0xc,0xc,e:GetHandler())
	if g:GetCount()>0 then
	Duel.SendtoDeck(g,nil,2,0x40)
	end
end