
namespace riskmanagement;

using {
        managed,
        cuid,
        User,
        sap.common.CodeList
} from '@sap/cds/common';

entity Risks : cuid, managed {
        title                    : String(100);
        owner                    : String;
        prio                     : Association to Priority;
        descr                    : String;
        miti                     : Association to Mitigations;
        impact                   : Integer;
        bp : Association to BusinessPartners;                           // uncommented - VDEORUKHKAR - Dec 5, 2023
        virtual criticality      : Integer;
        virtual PrioCriticality : Integer;
}

entity Mitigations : cuid, managed {
        descr    : String;
        owner    : String;
        timeline : String;
        risks    : Association to many Risks
                           on risks.miti = $self;
}

entity Priority : CodeList {
        key code : String enum {
                    high   = 'H';
                    medium = 'M';
                    low    = 'L';
            };
}


// using an external service from SAP S/4HANA Cloud
using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER.csn';


entity BusinessPartners as projection on external.A_BusinessPartner {
   key BusinessPartner, 
   FirstName,
   LastName  
   //BusinessPartnerFullName as FullName,
}


/*using {riskmanagement as rm} from '../db/schema';

@path: 'service/risk'
service RiskService {
    entity Risks as projection on rm.Risks;
    annotate Risks with @odata.draft.enabled;

    entity Mitigations as projection on rm.Mitigations;
    annotate Mitigations with @odata.draft.enabled;

    // BusinessPartner
    @readonly entity BusinessPartners as projection on rm.BusinessPartners;
}*/