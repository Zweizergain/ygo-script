--天魔魔君-维克托斯
function c35300004.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c35300004.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c35300004.atkval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35300004,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c35300004.condition)
	e3:SetCost(c35300004.cost)
	e3:SetTarget(c35300004.target)
	e3:SetOperation(c35300004.operation)
	c:RegisterEffect(e3)
	--immue
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c35300004.efilter)
	c:RegisterEffect(e4)
	--atkkkkkkkkk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(35300004,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c35300004.tcost)
	e5:SetOperation(c35300004.top)
	c:RegisterEffect(e5)
end
c35300004.setname="skydemon"
function c35300004.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttackAbove,1,nil,1) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsAttackAbove,1,1,nil,1)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(sg:GetFirst():GetAttack())
end
function c35300004.top(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	if atk<=0 then return end
	local c=e:GetHandler() 
	local b1=c:IsRelateToEffect(e) and c:IsFaceup()
	if b1 and not Duel.SelectYesNo(tp,aux.Stringid(35300004,2)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	else
	   Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
function c35300004.splimit(e,se,sp,st)
	return se:GetHandler()~=e:GetHandler()
end
function c35300004.cfilter(c)
	return c:IsSetCard(0x1656)
end
function c35300004.atkval(e,c)
	return Duel.GetMatchingGroupCount(c35300004.cfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*800
end
function c35300004.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c35300004.cfilter(c)
	return c:IsSetCard(0x1656) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c35300004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35300004.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c35300004.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c35300004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35300004.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	end
end
function c35300004.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end

