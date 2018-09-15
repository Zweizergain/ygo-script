--白魔术化石龙
function c34340044.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c34340044.matcheck)
	c:RegisterEffect(e1)   
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340044,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c34340044.atkcon)
	e2:SetOperation(c34340044.atkop)
	c:RegisterEffect(e2) 
	--att
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e3)
end
c34340044.setname="WhiteMagician"
function c34340044.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetCount()>0 and g:GetSum(Card.GetBaseAttack)>0
end
function c34340044.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() or c:IsFacedown() then return end
	local g=c:GetLinkedGroup():Filter(Card.IsFaceup,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c34340044.matfilter(c)
	return c.setname=="WhiteMagician"
end
function c34340044.matcheck(e,c)
	local g=c:GetMaterial():Filter(c34340044.matfilter,nil)
	if g:GetCount()~=c:GetMaterialCount() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(3000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end