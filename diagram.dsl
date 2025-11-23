workspace "Stellar Roofing" "System Diagram for Stellar Roofing Salesforce" {
    model {
        # Actors
        salesUser = person "Sales"
        managerUser = person "Manager"
        callCenterUser = person "Call Center"
        canvasserUser = person "Canvasser"
        adminUser = person "Admin"
        accountingUser = person "Accounting"
        projectManagerUser = person "Project Manager"
        dispatcherUser = person "Dispatcher"

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
            salesApp = container "Sales App" "[Standard]" {
                salesOpportunityRecordPage = component "Opportunity Record Page"
                salesAvailabilityPage = component "Availibility Page"
                salesContactPage = component "Contact Page"
                salesAccountPage = component "Account Page"
                salesEstimatePage = component "Estimate Page"
                salesProjectPage = component "Project Page"
            }
            productionApp = container "Production App" "[Standard]" {
                productionAvailabilityPage = component "Availibility Page"
                projectScheduling = component "Project Scheduling"
            }
            callCenterApp = container "Call Center App" "[Console]"{
                appointmentScheduling = component "Appointment Scheduling"
                callCenterLeadRecordPage = component "Lead Record Page"
                omnichannel = component "Omnichannel"
                ringCentralSalesforcePackage = component "Ring Central Salesforce Package"
            }
            canvasserApp = container "Canvasser App" "[Standard]"{
                canvasserOpportunityRecordPage = component "Opportunity Record Page"
                canvasserLeadRecordPage = component "Lead Record Page"
            }
            fieldService = container "Field Service App" "[Standard]"{
                dispatcherConsole = component "Dispatcher Console"
                fieldServiceMobile = component "Field Service Mobile"
            }
            commissionCalculationService = container "Commission Calculation Service" {
                commissionsCalculationAutolaunchedFlow = component "Commissions Calculation Autolaunched Flow" "Calculates commissions based on opportunity amount, people associated, and other factors"
                commissionsProjectTriggeredFlow = component "Commissions Project Triggered Flow" "Triggers commissions calculation when a project is moved to 'Ready for Production'"
            }
            availabilityService = container "Availability Service" "LWC on a custom tab"{
                availabilityManagerView = component "Availability Manager View" "Allows users with proper permissions to view and set all availabilities"
                availabilitySalesView = component "Availability Sales View" "Allows sales people to view and set their own availabilities"
                availabilityCrewView = component "Availability Crew View" "Allows crew leads to view and set their own availabilities"
                availabilityCalendarBlocking = component "Availability Calendar Blocking" "Allows certain time periods to be blocked"
                availabilityShiftCreation = component "Availability Shift Creation" "Creates shift records behind the scenes"
            }
            database = container "Database"{
                leads = component "Leads"
                opportunities = component "Opportunities"
                accounts = component "Accounts"
                contacts = component "Contacts"
                estimates = component "Estimates"
                projects = component "Projects"
                serviceAppointments = component "Service Appointments"
                shifts = component "Shifts"
            }
            reports = container "Reports/Dashboards" {
                individualCanvasserDahsboard = component "Individual Canvasser Dashboard"
                managerCanvasserDashboard = component "Manager Canvasser Dashboard"
                individualSalesDashboard = component "Individual Sales Dashboard"
                managerSalesDashboard = component "Manager Sales Dashboard"
                individualProjectManagerDashboard = component "Individual Project Manager Dashboard"
                managerProjectManagerDashboard = component "Project Manager Dashboard"
                individualDispatcherDashboard = component "Individual Dispatcher Dashboard"
            }

            permissionSets = container "Permission Set Groups" {
                salesPermissionSet = component "Sales"
                managerPermissionSet = component "Manager"
                canvasserPermissionSet = component "Canvasser"
                dispatcherPermissionSet = component "Dispatcher"
                accountingPermissionSet = component "Accounting"
                projectManagerPermissionSet = component "Project Manager"
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
        roofr -> oneClickContractor "Sends Measurement Reports"
        callCenterUser -> ringCentral "Uses"

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
        productionAvailabilityPage -> availabilityCrewView "Sets availability"
        salesAvailabilityPage -> availabilitySalesView "Sets availability"
        salesProjectPage -> commissionCalculationService "Calculates Commissions"
        managerUser -> availabilityService "Views and sets all availability"

        # Availability Service Relationships
        availabilityManagerView -> availabilityShiftCreation "Creates Shifts"
        availabilitySalesView -> availabilityShiftCreation "Creates Shifts"
        availabilityCrewView -> availabilityShiftCreation "Creates Shifts"


        # Dashboard Relationships
        salesApp -> individualSalesDashboard "Has"
        canvasserApp -> individualCanvasserDahsboard "Has"
        productionApp -> individualProjectManagerDashboard "Has"
        fieldService -> managerProjectManagerDashboard "Has"
        fieldService -> individualDispatcherDashboard "Has"
        salesApp -> managerSalesDashboard "Has"
        canvasserApp -> managerCanvasserDashboard "Has"
        productionApp -> managerProjectManagerDashboard "Has"

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

        # Manager Relationships
        managerUser -> salesApp "Views Reports"
        managerUser -> canvasserApp "Views Reports"
        managerUser -> productionApp "Views Reports"

        #Sales User Relationships
        salesUser -> salesAvailabilityPage "Uses"
        salesUser -> salesOpportunityRecordPage "Uses"
        salesUser -> salesContactPage "Uses"
        salesUser -> salesProjectPage "Uses"
        salesUser -> salesEstimatePage "Uses"
        salesUser -> salesAccountPage "Uses"

        # User Relationships
        canvasserUser -> canvasserLeadRecordPage "Dials Leads"
        canvasserUser -> canvasserLeadRecordPage "Schedules Appointments"
        canvasserUser -> canvasserOpportunityRecordPage "Views Converted Opportunities"
        dispatcherUser -> dispatcherConsole "Dispatches sales people and production teams"
        dispatcherUser -> productionAvailabilityPage "Views all availabilities"
        accountingUser -> quickBooksInvoices "Creates Invoices"
        accountingUser -> quickbooksPayments "Records Payments"

        # Component-to-Component Relationships
        commissionsProjectTriggeredFlow -> commissionsCalculationAutolaunchedFlow "Uses to calculate commissions"

        # Permission Set Relationships
        salesUser -> salesPermissionSet "Has"
        managerUser -> managerPermissionSet "Has"
        canvasserUser -> canvasserPermissionSet "Has"
        dispatcherUser -> dispatcherPermissionSet "Has"
        accountingUser -> accountingPermissionSet "Has"
        projectManagerUser -> projectManagerPermissionSet "Has"

        # Database Relationships
        leads -> opportunities "Converts"
        leads -> accounts "Converts"
        leads -> contacts "Converts"
        leads -> estimates "Converts"
        leads -> projects "Converts"
        leads -> serviceAppointments "Converts"
        leads -> shifts "Converts"
        opportunities -> projects "Creates"
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
                exclude *->permissionSets
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
        component reports {
            include *
                autolayout
        }

        component permissionSets {
            include *
                autolayout
        }

        dynamic database {
            title "Sales Process"
            autolayout lr
            leads -> opportunities "Converts"
            leads -> accounts "Converts"
            leads -> contacts "Converts"
            opportunities -> projects "Creates"
        }
    }
}
