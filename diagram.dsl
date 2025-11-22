workspace "Stellar Roofing" "System Diagram for Stellar Roofing Salesforce" {
    model {
        # Actors
        salesUser = person "Sales" "Description" "tag"
        callCenterUser = person "Call Center" "Description" "tag"
        canvasserUser = person "Canvasser" "Description" "tag"
        adminUser = person "Admin" "Description" "tag"
        accountingUser = person "Accounting" "Description" "tag"
        projectManagerUser = person "Project Manager" "Production Team Lead" "tag"
        dispatcherUser = person "Dispatcher" "Dispatches Sales People and Production Teams" "tag"

        # External Systems
        oneClickContractor = softwareSystem "One Click Contractor" "Quoting Software" "external"
        ringCentral = softwareSystem "Ring Central" "Telephony Software" "external"
        companyCam = softwareSystem "CompanyCam" "Project Management/Photo Storage" "external"
        Roofr = softwareSystem "Roofr" "Measurement Reporting Software" "external"
        quickBooks = softwareSystem "QuickBooks" "Accountsing Software" "external"{
            quickBooksInvoices = container "Invoices"
            quickBooksPayments = container "Payments"
        }
        leadAggregators = softwareSystem "Lead Aggregators" "Several external systems that collect leads" "external"{
            angiLeads = container "Angi Lead Aggregator"
            getTheReferral = container "Get The Referral"
            yelp = container "Yelp"
            angiAds = container "Angi Ads"
            thumbtack = container "Thumbtack"
            google = container "Google"
            meta = container "Meta"
            networx = container "Networx"
        }

        # Internal System
        salesforce = softwareSystem "Salesforce" "Salesforce CRM" {
            salesApp = container "Sales App" {
                salesOpportunityRecordPage = component "Opportunity Record Page"
                salesAvailabilityPage = component "Availibility Page"
            }
            productionApp = container "Production App" {
                productionAvailabilityPage = component "Availibility Page"
                
            }
            callCenterApp = container "Call Center App"{
                callCenterOpportunityRecordPage = component "Opportunity Record Page"
                appointmentScheduling = component "Appointment Scheduling"
            }
            canvasserApp = container "Canvasser App"{
                canvasserOpportunityRecordPage = component "Opportunity Record Page"
            }
            fieldService = container "Field Service" {
                dispatcherConsole = component "Dispatcher Console"
                fieldServiceMobile = component "Field Service Mobile"
            }

        }

        
        # System-to-System Relationships
        salesforce -> oneClickContractor "Creates Jobs"
        oneClickContractor -> salesforce "Creates Estimates"
        salesforce -> quickBooks "Reads Payments/Invoices"
        salesforce -> CompanyCam "Creates Projects/Views photos"


        # Lead Aggregators
        angiLeads -> salesforce "Creates Leads"
        getTheReferral -> salesforce "Creates Leads"
        yelp -> salesforce "Creates Leads"
        angiAds -> salesforce "Creates Leads"
        thumbtack -> salesforce "Creates Leads"
        google -> salesforce "Creates Leads"
        meta -> salesforce "Creates Leads"
        networx -> salesforce "Creates Leads"

        # User-to-System Relationships
        salesUser -> salesforce "Uses"
        callCenterUser -> salesforce "Uses"
        canvasserUser -> salesforce "Uses"
        adminUser -> salesforce "Uses"
        accountingUser -> salesforce "Uses"
        accountingUser -> quickBooks "Uses"
        projectManagerUser -> salesforce "Uses"
        dispatcherUser -> salesforce "Uses"

        # User Relationships
        salesUser -> salesAvailabilityPage "View/Set Availability"
        salesUser -> salesOpportunityRecordPage "Records Sales Data"
        callCenterUser -> callCenterOpportunityRecordPage "Uses"
        canvasserUser -> canvasserOpportunityRecordPage "Uses"
        projectManagerUser -> fieldServiceMobile "Uses"
        dispatcherUser -> dispatcherConsole "Dispatches sales people and production teams"
        dispatcherUser -> productionAvailabilityPage "Views all availabilities"
        accountingUser -> quickBooksInvoices "Creates Invoices"
        accountingUser -> quickbooksPayments "Records Payments"

    }
    views {
       systemContext salesforce {
           include *
           exclude accountingUser->quickBooks
           autolayout
       }
       
       systemContext quickBooks {
           include *
           autolayout
       }

        container quickBooks {
            include *
            autolayout
        }

       container leadAggregators {
           include *
           autolayout
       }
        
       container salesforce {
           include *
           autolayout
       }

       component salesApp {
           include *
           autolayout
       }

       component callCenterApp {
           include *
           autolayout
       }

       component canvasserApp {
           include *
           autolayout
       }

       component fieldService {
           include *
           autolayout
       }

    }
}
