--原初八文-离
function c21520205.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520205.cfilter,1,1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520205,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520205.destg)
	e1:SetOperation(c21520205.desop)
	c:RegisterEffect(e1)
	--damage 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520205,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21520205.drcost)
	e2:SetTarget(c21520205.drtg)
	e2:SetOperation(c21520205.drop)
	c:RegisterEffect(e2)
end
function c21520205.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520205.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_FIRE) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520205))
	else
		return c:IsLinkAttribute(ATTRIBUTE_FIRE) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520205.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520205.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup()
end
function c21520205.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>=1 end
end
function c21520205.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		local tc=sg:GetFirst()
		Duel.ConfirmCards(1-tc:GetControler(),sg)
		if tc:IsType(TYPE_MONSTER) and tc:IsAttackAbove(e:GetHandler():GetAttack()) then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		else
			Duel.Destroy(tc,REASON_EFFECT)
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c21520205.pfliter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c21520205.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function c21520205.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520205.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520205.drfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c21520205.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	local sum=0
	for tc in aux.Next(g) do
		sum=sum+tc:GetAttack()
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(sum)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sum)
end
function c21520205.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
--	local cd=math.ceil(d/2)
	local g=Duel.GetMatchingGroup(c21520205.pfliter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21520205,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local pg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,pg)
		d=d+e:GetHandler():GetAttack()
	end
	Duel.Damage(p,d,REASON_EFFECT)
end
