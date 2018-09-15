--Stars 整装待发·T
local m=50008881
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,50008881)
    e1:SetCondition(c50008881.con)
    e1:SetTarget(c50008881.tg)
    e1:SetOperation(c50008881.op)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008881,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,50008881)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetCondition(c50008881.atkcon)
    e2:SetCost(c50008881.cost)
    e2:SetTarget(c50008881.atktg)
    e2:SetOperation(c50008881.atkop)
    c:RegisterEffect(e2)
end
function c50008881.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c50008881.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c50008881.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c50008881.atkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c50008881.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50008881.atkfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50008881.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c50008881.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c50008881.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(1000)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
end

----
function c50008881.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x50b)
end
function c50008881.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c50008881.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c50008881.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and
        Duel.IsPlayerCanSpecialSummonMonster(tp,500088888,0,0x4011,2000,1000,2,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,tp)  end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c50008881.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,500088888,0,0x4011,2000,1000,2,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,tps)  then
        for i=1,2 do
            local token=Duel.CreateToken(tp,500088888)
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
        end
        Duel.SpecialSummonComplete()
    end
end