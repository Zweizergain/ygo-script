--植占师R8-锷之神光
function c16001004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,6,nil,aux.Stringid(16001004,0))
	c:EnableReviveLimit()
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16001004,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e1:SetCondition(c16001004.atkcon)
	e1:SetCost(c16001004.atkcost)
	e1:SetOperation(c16001004.atkop)
	c:RegisterEffect(e1)
end
c16001004.xyz_number=8
function c16001004.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget() and e:GetHandler():GetOverlayCount()~=0
end
function c16001004.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(16001004)==0 end
	e:GetHandler():RegisterFlagEffect(16001004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c16001004.atkop(e,tp,eg,ep,ev,re,r,rp)
end
