--ロリドゥラの蟲惑魔(エラッタ後)
function c191812343.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c191812343.imcon)
	e1:SetValue(c191812343.efilter)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(c191812343.extg)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(191812343,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c191812343.rcon)
	e3:SetOperation(c191812343.rop)
	c:RegisterEffect(e3)
end
function c191812343.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c191812343.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c191812343.extg(e,c)
	return c:IsSetCard(0x108a)
end
function c191812343.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) 
	and re:IsActiveType(TYPE_XYZ) and re:GetOwner():IsSetCard(0x108a)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and ep==e:GetOwnerPlayer() and ev-1
end
function c191812343.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	if ct==1 then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		re:GetHandler():RemoveOverlayCard(tp,ct-2,ct-2,REASON_COST)
	end
end
