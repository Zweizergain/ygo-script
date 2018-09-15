--Stars 真夏·T
local m=50008884
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c50008884.condition)
    e1:SetTarget(c50008884.target)
    e1:SetOperation(c50008884.activate)
    c:RegisterEffect(e1)
end
function c50008884.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsType(TYPE_TOKEN)
end

function c50008884.filter(c)
    return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c50008884.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008884.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c50008884.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c50008884.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c50008884.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end