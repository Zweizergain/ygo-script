--毁灭之喷射白光
function c10150023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c10150023.cost)
	e1:SetTarget(c10150023.target)
	e1:SetOperation(c10150023.activate)
	c:RegisterEffect(e1)	
end

function c10150023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c10150023.filter(c)
	local atk=c:GetAttack()
	if atk<0 then atk=0 end
	return c:IsFaceup() and c:IsCode(89631139) and Duel.IsExistingMatchingCard(c10150023.dfilter,tp,0,LOCATION_ONFIELD,1,nil,atk)
end

function c10150023.dfilter(c,atk)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or (c:IsType(TYPE_MONSTER) and c:IsAttackBelow(atk)))
end

function c10150023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10150023.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150023.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10150023.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	local dg=Duel.GetMatchingGroup(c10150023.dfilter,tp,0,LOCATION_ONFIELD,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end

function c10150023.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10150023.dfilter,tp,0,LOCATION_ONFIELD,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end

