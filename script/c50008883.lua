--Stars 盛演·T
local m=50008883
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCost(c50008883.cost)
    e1:SetCondition(c50008883.condition)
    e1:SetTarget(c50008883.target)
    e1:SetOperation(c50008883.activate)
    c:RegisterEffect(e1)
end
function c50008883.cosfilter(c)
    return c:IsType(TYPE_TOKEN)
end
function c50008883.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50008883.cosfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c50008883.cosfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50008883.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_TOKEN)
end
function c50008883.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c50008883.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c50008883.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c50008883.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end