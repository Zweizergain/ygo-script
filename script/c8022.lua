--最后的沙耶
function c8022.initial_effect(c)
	--xyz summon	
	--aux.AddXyzProcedure(c,c8022.ff,2,2,c8022.ovfilter,aux.Stringid(8022,2))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c8022.xyzcon)
	e1:SetOperation(c8022.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--mian yi
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c8022.imcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8022,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,8022)
	e2:SetCost(c8022.damcost)
	e2:SetTarget(c8022.damtg)
	e2:SetOperation(c8022.damop)
	c:RegisterEffect(e2)
	--One Turn Kill
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(8022,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,8022)
	e6:SetCost(c8022.atkcost)
	e6:SetOperation(c8022.atkop)
	c:RegisterEffect(e6)
	--remove material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(8022,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c8022.rmcon)
	e5:SetOperation(c8022.rmop)
	c:RegisterEffect(e5)
end
function c8022.ff(c)		
	return c:IsSetCard(0x901)
end
function c8022.ovfilter(c)  
	return c:IsFaceup() and c:IsRankBelow(4) and c:IsSetCard(0x901) 
	and c:GetOverlayCount()==0
end
function c8022.mfilter(c,xyzc)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsCanBeXyzMaterial(xyzc) and c:GetLevel()>0 and c:IsSetCard(0x901)
end
function c8022.xyzfilter1(c,g)
	return g:IsExists(c8022.xyzfilter2,1,c,c:GetLevel())
end
function c8022.xyzfilter2(c,lv)
	return c:GetLevel()>0 and c:GetLevel()==lv and c:IsSetCard(0x901) 
end
function c8022.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc,maxc=2,2
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local mg=nil
	if og then
		mg=og:Filter(c8022.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c8022.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return mg:IsExists(c8022.xyzfilter1,1,nil,mg)
end
function c8022.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c8022.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c8022.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc,maxc=2,2
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c8022.xyzfilter1,1,1,nil,mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c8022.xyzfilter2,1,1,g:GetFirst(),g:GetFirst():GetLevel())
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c8022.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c8022.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c8022.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>Duel.GetLP(1-tp) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c8022.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=Duel.GetLP(1-p)-Duel.GetLP(p)
	if val>0 then
		Duel.Damage(p,val,REASON_EFFECT)
	end
end
function c8022.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function c8022.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c8022.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c8022.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end