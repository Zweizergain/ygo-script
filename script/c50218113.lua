--地之数码兽LV3 巴鲁兽
function c50218113.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP+CATEGORY_LEAVE_GRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1,50218113)
    e1:SetCondition(c50218113.eqcon)
    e1:SetTarget(c50218113.eqtg)
    e1:SetOperation(c50218113.eqop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218113,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetCondition(c50218113.spcon)
    e2:SetCost(c50218113.spcost)
    e2:SetTarget(c50218113.sptg)
    e2:SetOperation(c50218113.spop)
    c:RegisterEffect(e2)
end
c50218113.lvupcount=1
c50218113.lvup={50218114}
function c50218113.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE))
        and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c50218113.eqfilter(c,tp)
    if not c:IsFaceup() or not c:IsControlerCanBeChanged() then return false end
    if c:IsType(TYPE_TRAPMONSTER) then return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE,tp,0)>=2 end
    return true
end
function c50218113.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c50218113.eqfilter(chkc,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c50218113.eqfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c50218113.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c50218113.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c50218113.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
        Duel.Equip(tp,c,tc,true)
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c50218113.eqlimit)
        e1:SetLabelObject(tc)
        c:RegisterEffect(e1)
        --control
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetCode(EFFECT_SET_CONTROL)
        e2:SetValue(tp)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e2)
        --Destroy
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetCode(EVENT_LEAVE_FIELD_P)
        e3:SetOperation(c50218113.checkop)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
        e4:SetCode(EVENT_LEAVE_FIELD)
        e4:SetOperation(c50218113.desop)
        e4:SetReset(RESET_EVENT+0x17e0000)
        e4:SetLabelObject(e3)
        c:RegisterEffect(e4)
    end
end
function c50218113.checkop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsDisabled() then
        e:SetLabel(1)
    else e:SetLabel(0) end
end
function c50218113.desop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabelObject():GetLabel()~=0 then return end
    local tc=e:GetHandler():GetEquipTarget()
    if tc and tc:IsLocation(LOCATION_MZONE) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c50218113.spcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c50218113.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50218113.spfilter(c,e,tp)
    return c:IsCode(50218114) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c50218113.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218113.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218113.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end