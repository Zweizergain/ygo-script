--未知飞蛾
function c10150026.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10150026.spcon)
	e1:SetOperation(c10150026.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)   
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c10150026.con1)
	c:RegisterEffect(e2) 
	e2:SetLabelObject(e1)
	--atk&def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(2300)
	e3:SetCondition(c10150026.con2)
	c:RegisterEffect(e3) 
	e3:SetLabelObject(e1)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4) 
	e4:SetLabelObject(e1)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c10150026.indval)
	e5:SetCondition(c10150026.con3)
	c:RegisterEffect(e5)
	e5:SetLabelObject(e1)
	--change lp
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(aux.bdocon)
	e6:SetCondition(c10150026.con4)
	e6:SetOperation(c10150026.op)
	c:RegisterEffect(e6)
	e6:SetLabelObject(e1)
end

function c10150026.op(e,tp,eg,ep,ev,re,r,rp)
   Duel.SetLP(1-tp,100)
end

function c10150026.con4(e,tp,eg,ep,ev,re,r,rp)
	return c10150026.con(e,tp,eg,ep,ev,re,r,rp) and e:GetLabelObject():GetLabel()>=20
end

function c10150026.con3(e,tp,eg,ep,ev,re,r,rp)
	return c10150026.con(e,tp,eg,ep,ev,re,r,rp) and e:GetLabelObject():GetLabel()>=6
end

function c10150026.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

function c10150026.con2(e,tp,eg,ep,ev,re,r,rp)
	return c10150026.con(e,tp,eg,ep,ev,re,r,rp) and e:GetLabelObject():GetLabel()>=4
end

function c10150026.con1(e,tp,eg,ep,ev,re,r,rp)
	return c10150026.con(e,tp,eg,ep,ev,re,r,rp) and e:GetLabelObject():GetLabel()>=2
end

function c10150026.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 
end

function c10150026.rfilter(c)
	return c:IsCode(58192742) and c:GetEquipGroup():FilterCount(Card.IsCode,nil,40024595)>0
end

function c10150026.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c10150026.rfilter,1,nil)
end

function c10150026.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c10150026.rfilter,1,1,nil)
	local tg=g:GetFirst():GetEquipGroup():Filter(Card.IsCode,nil,40024595)
	local sg,sgc=tg:GetMaxGroup(Card.GetTurnCounter)
	e:SetLabel(sg:GetFirst():GetTurnCounter())
	Duel.Release(g,REASON_COST)
end
