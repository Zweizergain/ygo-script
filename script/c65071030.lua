--谐奏放射器
function c65071030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65071030,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,65071030+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65071030.cost)
	e1:SetTarget(c65071030.target)
	e1:SetOperation(c65071030.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(65071030,1))
	e2:SetTarget(c65071030.tg)
	e2:SetOperation(c65071030.op)
	c:RegisterEffect(e2)
end
function c65071030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,30000)/500)
	local t={}
	for i=1,m do
		t[i]=i*500
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c65071030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct/2)
end

function c65071030.operation(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
end

function c65071030.tgfil(c,e)
	local ct=e:GetLabel()
	return c:GetAttack()<=ct/2 and c:IsFaceup()
end
function c65071030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c65071030.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65071030.tgfil,tp,0,LOCATION_MZONE,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end