--ロリドゥラの蟲惑魔
function c91812343.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c91812343.imcon)
	e1:SetValue(c91812343.efilter)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c91812343.atlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c91812343.atlimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
		--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c91812343.regcon)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(91812343,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,91812343)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c91812343.cost)
	e5:SetCondition(c91812343.drcon)
	e5:SetTarget(c91812343.drtg)
	e5:SetOperation(c91812343.drop)
	c:RegisterEffect(e5)

end

function c91812343.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c91812343.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c91812343.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c91812343.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c91812343.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return Duel.IsExistingMatchingCard(c91812343.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c91812343.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=math.min(Duel.GetMatchingGroupCount(c91812343.cfilter,tp,LOCATION_MZONE,0,nil),Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL),c:GetOverlayCount(),5)
	if chk==0 then return rt>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>2 then ct=2 end	
	
	c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	local rct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(rct)
end


function c91812343.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and e:GetHandler():GetFlagEffect(1)>0
end
function c91812343.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end

function c91812343.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(e:GetLabel(),REASON_EFFECT)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
