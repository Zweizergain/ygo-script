--厄神✿键山雏
function c100400.initial_effect(c)
	--summon with X tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100400,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c100400.otcon)
	e1:SetOperation(c100400.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100400,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c100400.spcost)
	e4:SetOperation(c100400.spop)
	c:RegisterEffect(e4)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100400.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c100400.descon)
	e3:SetOperation(c100400.operation)
	c:RegisterEffect(e3)	
end
function c100400.descon(e)
	local g=Duel.GetMatchingGroup(c100400.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE and g:GetCount()>0
end
function c100400.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100400.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,tp,100400) 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end 
function c100400.disable(e,c)
	return c:GetAttack()<c:GetDefense() and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
function c100400.filter(c,e)
	return c:GetAttack()<c:GetDefense() and not c:IsImmuneToEffect(e)
end
function c100400.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,2))
		or c:GetLevel()>1 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,1)
end
function c100400.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<=1 then ct=1 end 
	if c:GetLevel()>6 and ct<2 then ct=2 end 
	local g=Duel.SelectTribute(tp,c,ct,99)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c100400.mgfilter(c,e,tp,fusc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x12)==0x12 and c:GetReasonCard()==fusc 
		and c:IsAbleToDeckAsCost() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c100400.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=c:GetMaterial()
	if chk==0 then return ag:IsExists(c100400.mgfilter,1,nil,e,tp,c) end
	local dc=ag:FilterSelect(tp,c100400.mgfilter,1,1,nil,e,tp,c)
	Duel.SendtoDeck(dc,nil,2,REASON_COST)
end
function c100400.spop(e,tp,eg,ep,ev,re,r,rp)
		--Atk
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_ATTACK)
		--e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetValue(0)
		Duel.RegisterEffect(e2,tp)
end
function c100400.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end