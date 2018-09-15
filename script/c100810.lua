--紧急回避「Optical Camouflage」
function c100810.initial_effect(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(c100810.atkcon)
	e2:SetTarget(c100810.atktg)
	e2:SetOperation(c100810.atkop)
	c:RegisterEffect(e2)
	--1 level
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100810,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(c100810.cost)
    e2:SetTarget(c100810.target)
    e2:SetOperation(c100810.operation)
    c:RegisterEffect(e2)   
end
function c100810.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=nil
	local d=nil
	if Duel.GetAttacker():GetControler()~=tp then 
		d=Duel.GetAttacker()
		a=Duel.GetAttackTarget()
	else
		a=Duel.GetAttacker()
		d=Duel.GetAttackTarget()	
	end 
	return d~=nil and a~=nil and d:IsFaceup() and ((a:GetControler()==tp and bit.band(a:GetSummonType(),SUMMON_TYPE_ADVANCE)~=0 and a:IsRelateToBattle())
		or (d:GetControler()==tp and bit.band(d:GetSummonType(),SUMMON_TYPE_ADVANCE)~=0 and d:IsRelateToBattle()))
end
function c100810.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=nil
	local d=nil
	if Duel.GetAttacker():GetControler()~=tp then 
		d=Duel.GetAttacker()
		a=Duel.GetAttackTarget()
	else
		a=Duel.GetAttacker()
		d=Duel.GetAttackTarget()	
	end 
	if chk==0 then return d~=nil and a~=nil and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (d:IsLocation(LOCATION_MZONE) and d:IsRelateToBattle() and d:IsAbleToChangeControler())
		and a:IsLocation(LOCATION_MZONE) and a:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,d,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100810.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100810.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local a=nil
	local d=nil
	if Duel.GetAttacker():GetControler()~=tp then 
		d=Duel.GetAttacker()
		a=Duel.GetAttackTarget()
	else
		a=Duel.GetAttacker()
		d=Duel.GetAttackTarget()	
	end 
	if a:IsRelateToBattle() and d:IsRelateToBattle() then
		if not Duel.Equip(tp,d,a,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(a)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c100810.eqlimit)
		d:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	else Duel.SendtoGrave(d,REASON_EFFECT) end
end

function c100810.cost(e,tp,eg,ep,ev,re,r,rp,chk)    
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100810.filter(c)
	return c:IsCode(100800) and c:IsAbleToHand()
end
function c100810.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100810.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100810.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100810.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end