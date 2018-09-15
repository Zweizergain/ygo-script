--水之数码兽LV9 维京兽
function c50218133.initial_effect(c) 
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c50218133.scon)
    e2:SetOperation(c50218133.sop)
    c:RegisterEffect(e2)
    --token
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218133,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,50218133)
    e3:SetCost(c50218133.spcost)
    e3:SetTarget(c50218133.sptg)
    e3:SetOperation(c50218133.spop)
    c:RegisterEffect(e3)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c50218133.efilter)
    c:RegisterEffect(e4)
    --indes2
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(50218133,0))
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,50218133)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetTarget(c50218133.target)
    e5:SetOperation(c50218133.operation)
    c:RegisterEffect(e5)
end
c50218133.lvupcount=1
c50218133.lvup={50218109}
c50218133.lvdncount=3
c50218133.lvdn={50218107,50218108,50218109}
function c50218133.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c50218133.spfilter(c,ft,tp)
    return c:IsCode(50218109)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c50218133.scon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,c50218133.spfilter,1,nil,ft,tp)
end
function c50218133.sop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,c50218133.spfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c50218133.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c50218133.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,50218143,0,0x4011,0,1000,1,RACE_AQUA,ATTRIBUTE_WATER) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50218133.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,50218143,0,0x4011,0,1000,1,RACE_AQUA,ATTRIBUTE_WATER) then
        local token=Duel.CreateToken(tp,50218143)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218133.filter(c)
    return c:IsFaceup()
end
function c50218133.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c50218133.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218133.filter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c50218133.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c50218133.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCountLimit(1)
        e1:SetValue(c50218133.valcon)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c50218133.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end