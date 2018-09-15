--真红眼刻蚀龙
function c10150046.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,5)
	c:EnableReviveLimit()
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10150046.reptg)
	c:RegisterEffect(e3)	
	--mat
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150046,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10150046.macon)
	e2:SetOperation(c10150046.maop)
	c:RegisterEffect(e2)
	--damage
	local e1=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150046,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e3:SetCost(c10150046.damcost)
	e2:SetTarget(c10150046.damtg)
	e2:SetOperation(c10150046.damop)
	c:RegisterEffect(e2)
end

function c10150046.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function c10150046.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetOverlayCount()*500)
end

function c10150046.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetOverlayCount()<=0 then return end
	  Duel.Damage(1-tp,c:GetOverlayCount()*500,REASON_EFFECT)
	  c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end

function c10150046.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10150046.filter,tp,0,LOCATION_MZONE,nil,c:GetAttack(),e)
	if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetCount()>0 then
		local tc=g:GetFirst()
		local og=Group.CreateGroup()
		while tc do
		   og:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
		end
		if og:GetCount()>0 then
		 Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,g)
	end
end

function c10150046.filter(c,atk,e)
	return c:IsFaceup() and c:IsAttackBelow(atk) and not c:IsImmuneToEffect(e)
end

function c10150046.macon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end

function c10150046.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(10150046,2)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end