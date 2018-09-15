--Stars 真绪·T
local m=50008886
local cm=_G["c"..m]
function cm.initial_effect(c)
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,50008886)
    e1:SetCost(c50008886.indcost)
    e1:SetTarget(c50008886.indtg)
    e1:SetOperation(c50008886.indop)
    c:RegisterEffect(e1)
   --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008886,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,500088861)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c50008886.descost)
    e2:SetTarget(c50008886.destg)
    e2:SetOperation(c50008886.desop)
    c:RegisterEffect(e2)
end

function c50008886.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c50008886.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c50008886.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c50008886.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50008886.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c50008886.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50008886.indop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e2)
    end
end
--
function c50008886.cfilter(c)
    return c:IsType(TYPE_TOKEN)
end
function c50008886.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50008886.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c50008886.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50008886.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c50008886.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c50008886.desfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c50008886.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c50008886.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50008886.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end