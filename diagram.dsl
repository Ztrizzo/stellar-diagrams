workspace "Stellar Roofing" "System Diagram for Stellar Roofing Salesforce" {
    model {
        # Actors
        salesUser = person "Sales" "Description" "tag"
        managerUser = person "Manager" "Description" "tag"
        callCenterUser = person "Call Center" "Description" "tag"
        canvasserUser = person "Canvasser" "Description" "tag"
        adminUser = person "Admin" "Description" "tag"
        accountingUser = person "Accounting" "Description" "tag"
        projectManagerUser = person "Project Manager" "Production Team Lead" "tag"
        dispatcherUser = person "Dispatcher" "Dispatches Sales People and Production Teams" "tag"

        # External Systems
        oneClickContractor = softwareSystem "One Click Contractor" "Quoting Software" "external"{
            oneClickContractorJobs = container "Jobs"
            oneClickContractorEstimates = container "Estimates"
        }
        ringCentral = softwareSystem "Ring Central" "Telephony Software" "external"
        companyCam = softwareSystem "CompanyCam" "Project Management/Photo Storage" "external"
        Roofr = softwareSystem "Roofr" "Measurement Reporting Software" "external"
        quickBooks = softwareSystem "QuickBooks" "Accounting Software" "external"{
            quickBooksInvoices = container "Invoices"
            quickBooksPayments = container "Payments"
            quickBooksCustomer = container "Customers"
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
                salesContactPage = component "Contact Page"
                salesAccountPage = component "Account Page"
                salesEstimatePage = component "Estimate Page"
                salesProjectPage = component "Project Page"
            }
            productionApp = container "Production App" {
                productionAvailabilityPage = component "Availibility Page"
                projectScheduling = component "Project Scheduling"
            }
            callCenterApp = container "Call Center App"{
                appointmentScheduling = component "Appointment Scheduling"
                callCenterLeadRecordPage = component "Lead Record Page"
                omnichannel = component "Omnichannel"
                ringCentralSalesforcePackage = component "Ring Central Salesforce Package"
            }
            canvasserApp = container "Canvasser App"{
                canvasserOpportunityRecordPage = component "Opportunity Record Page"
                canvasserLeadRecordPage = component "Lead Record Page"
            }
            fieldService = container "Field Service App" {
                dispatcherConsole = component "Dispatcher Console"
                fieldServiceMobile = component "Field Service Mobile"
            }
            # database = container "Database"{
            #     leads = component "Leads"
            #     opportunities = component "Opportunities"
            #     accounts = component "Accounts"
            #     contacts = component "Contacts"
            #     estimates = component "Estimates"
            #     projects = component "Projects"
            #     serviceAppointments = component "Service Appointments"
            #     shifts = component "Shifts"
            # }
            commissionCalculationService = container "Commission Calculation Service" {
                commissionsCalculationAutolaunchedFlow = component "Commissions Calculation Autolaunched Flow" "Calculates commissions based on opportunity amount, people associated, and other factors"
                commissionsProjectTriggeredFlow = component "Commissions Project Triggered Flow" "Triggers commissions calculation when a project is moved to 'Ready for Production'"
            }
            availabilityService = container "Availability Service" "LWC on a custom tab"{
                availabilityManagerView = component "Availability Manager View" "Allows users with proper permissions to view and set all availabilities"
                availabilitySalesView = component "Availability Sales View" "Allows sales people to view and set their own availabilities"
                availabilityCrewView = component "Availability Crew View" "Allows crew leads to view and set their own availabilities"
                availabilityCalendarBlocking = component "Availability Calendar Blocking" "Allows certain time periods to be blocked"
            }

        }

        
        # System-to-System Relationships
        salesforce -> oneClickContractor "Creates Jobs"
        oneClickContractor -> salesforce "Creates Estimates"
        salesforce -> quickBooks "Reads Payments/Invoices"
        quickBooksCustomer -> salesforce "2-way Sync to Accounts"
        salesUser -> oneClickContractor "Uses"
        salesUser -> oneClickContractorEstimates "Creates Estimates"
        salesUser -> oneClickContractorJobs "Uses"
        # projects -> CompanyCam "Creates Projects/Views photos"
        # oneClickContractorEstimates -> estimates "Creates Estimates"
        # opportunities -> oneClickContractorJobs "Creates Jobs"
        roofr -> oneClickContractor "Sends Measurement Reports"
        # accounts -> quickBooksCustomer "Creates/Updates Customers"
        # quickbooksCustomer -> accounts "Creates/Updates Customers"

        # # Lightning Page Database Relationships
        # salesOpportunityRecordPage -> opportunities "Interacts with"
        # callCenterLeadRecordPage -> leads "Interacts with"
        # canvasserOpportunityRecordPage -> opportunities "Interacts with"
        # canvasserLeadRecordPage -> leads "Interacts with"
        # projectScheduling -> serviceAppointments "Creates"
        # appointmentScheduling -> serviceAppointments "Creates"
        # salesContactPage -> contacts "Interacts with"
        # salesAccountPage -> accounts "Interacts with"
        # salesEstimatePage -> estimates "Interacts with"
        # salesProjectPage -> projects "Interacts with"
        # availabilityService -> shifts "Creates"
        # availabilityService -> serviceAppointments "Reads"
        #
        #
        #
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
        dispatcherUser -> salesforce "Uses"
        ringCentralSalesforcePackage -> ringCentral "Calls Leads"

        # Container-to-Container Relationships
        productionAvailabilityPage -> availabilityService "Uses for setting availabilities"
        salesAvailabilityPage -> availabilityService "Uses for setting availabilities"


        # Call Center User Relationships
        callCenterUser -> callCenterLeadRecordPage "Dials Leads"
        callCenterUser -> appointmentScheduling "Schedules Sales Appointments"
        omniChannel -> callCenterUser "Notifies for new Leads"
        callCenterUser -> ringCentralSalesforcePackage "Uses"

        # Project ManagerUser Relationships
        projectManagerUser -> salesforce "Uses"
        projectManagerUser -> fieldServiceMobile "Uses"
        projectManagerUser -> projectScheduling "Schedules Crews"
        projectManagerUser -> productionAvailabilityPage "Checks Availabilities"

        # User Relationships
        salesUser -> salesAvailabilityPage "View/Set Availability"
        salesUser -> salesOpportunityRecordPage "Records Sales Data"
        canvasserUser -> canvasserLeadRecordPage "Dials Leads"
        canvasserUser -> canvasserLeadRecordPage "Schedules Appointments"
        dispatcherUser -> dispatcherConsole "Dispatches sales people and production teams"
        dispatcherUser -> productionAvailabilityPage "Views all availabilities"
        accountingUser -> quickBooksInvoices "Creates Invoices"
        accountingUser -> quickbooksPayments "Records Payments"

        # Component-to-Component Relationships
        commissionsProjectTriggeredFlow -> commissionsCalculationAutolaunchedFlow "Uses to calculate commissions"
    }
    views {
        systemContext salesforce {
            include *
                exclude accountingUser->quickBooks
                exclude salesforce->callCenterUser
                autolayout
        }

        systemContext quickBooks {
            include *
                autolayout
        }

        container oneClickContractor {
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

        component productionApp {
            include *
                autolayout
        }


        component commissionCalculationService {
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

        component availabilityService {
            include *
                autolayout
        }

        # component database {
        #     include *
        #         autolayout
        # }
    }
}
