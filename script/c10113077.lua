--合身一击
function c10113077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10113077.target)
	e1:SetOperation(c10113077.activate)
	c:RegisterEffect(e1)	
end
function c10113077.filter1(c,e,tp)
	local atk=c:GetBaseAttack()
	if atk<0 then atk=0 end
	return c:IsLevelBelow(4) and c:IsFaceup() and c:GetAttackAnnouncedCount()==0 and Duel.IsExistingMatchingCard(c10113077.filter2,tp,LOCATION_MZONE,0,1,c,e,tp,atk)
end
function c10113077.filter2(c,e,tp,atk1)
	local atk2=c:GetBaseAttack()
	if atk2<0 then atk2=0 end
	return c:IsLevelBelow(4) and c:IsFaceup() and c:GetAttackAnnouncedCount()==0 and Duel.IsExistingMatchingCard(c10113077.desfilter,tp,0,LOCATION_MZONE,1,nil,atk1+atk2) and c:IsCanBeEffectTarget(e)
end
function c10113077.desfilter(c,atk3)
	return c:IsFaceup() and c:IsAttackBelow(atk3)
end
function c10113077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10113077.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10113077.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c10113077.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local g2=Duel.SelectTarget(tp,c10113077.filter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetAttack())
	g1:Merge(g2)
	local tc,atk=g1:GetFirst(),0
	while tc do
	   atk=atk+tc:GetAttack()
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_OATH)
	   e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	   tc:RegisterEffect(e1)
	tc=g1:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c10113077.desfilter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c10113077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local atk1=g:GetFirst():GetBaseAttack()
	if atk1<0 then atk1=0 end
	local atk2=g:GetNext():GetBaseAttack()
	if atk2<0 then atk2=0 end
	local sg=Duel.GetMatchingGroup(c10113077.desfilter,tp,0,LOCATION_MZONE,nil,atk1+atk2)
	Duel.Destroy(sg,REASON_EFFECT)
end
