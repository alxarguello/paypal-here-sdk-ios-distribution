/**
 * PPRetailInvoiceSearchRequest.h
 *
 * DO NOT EDIT THIS FILE! IT IS AUTOMATICALLY GENERATED AND SHOULD NOT BE CHECKED IN.
 * Generated from: node_modules/paypal-invoicing/lib/SearchRequest.js
 *
 * 
 */

#import "PayPalRetailSDKTypeDefs.h"
#import "PPRetailObject.h"


@class PPRetailSDK;
@class PPRetailError;
@class PPRetailPayPalErrorInfo;
@class PPRetailAccountSummary;
@class PPRetailAccountSummarySection;
@class PPRetailInvoiceAddress;
@class PPRetailInvoiceAttachment;
@class PPRetailInvoiceBillingInfo;
@class PPRetailInvoiceCCInfo;
@class PPRetailCountries;
@class PPRetailCountry;
@class PPRetailInvoiceCustomAmount;
@class PPRetailInvoice;
@class PPRetailInvoiceActions;
@class PPRetailInvoiceConstants;
@class PPRetailInvoiceListRequest;
@class PPRetailInvoiceListResponse;
@class PPRetailInvoiceMetaData;
@class PPRetailInvoiceTemplatesResponse;
@class PPRetailInvoicingService;
@class PPRetailInvoiceItem;
@class PPRetailInvoiceMerchantInfo;
@class PPRetailInvoiceNotification;
@class PPRetailInvoicePayment;
@class PPRetailInvoicePaymentTerm;
@class PPRetailInvoiceRefund;
@class PPRetailInvoiceSearchRequest;
@class PPRetailInvoiceShippingInfo;
@class PPRetailInvoiceTemplate;
@class PPRetailInvoiceTemplateSettings;
@class PPRetailMerchant;
@class PPRetailNetworkRequest;
@class PPRetailNetworkResponse;
@class PPRetailSdkEnvironmentInfo;
@class PPRetailRetailInvoice;
@class PPRetailRetailInvoicePayment;
@class PPRetailCaptureHandler;
@class PPRetailTransactionContext;
@class PPRetailTransactionManager;
@class PPRetailTransactionBeginOptions;
@class PPRetailReceiptDestination;
@class PPRetailDeviceManager;
@class PPRetailSignatureReceiver;
@class PPRetailReceiptOptionsViewContent;
@class PPRetailReceiptEmailEntryViewContent;
@class PPRetailReceiptSMSEntryViewContent;
@class PPRetailReceiptViewContent;
@class PPRetailOfflinePaymentStatus;
@class PPRetailTokenExpirationHandler;
@class PPRetailCard;
@class PPRetailBatteryInfo;
@class PPRetailMagneticCard;
@class PPRetailPaymentDevice;
@class PPRetailManuallyEnteredCard;
@class PPRetailDeviceUpdate;
@class PPRetailCardInsertedHandler;
@class PPRetailDeviceStatus;
@class PPRetailPayer;
@class PPRetailTransactionRecord;
@class PPRetailAuthorizedTransaction;
@class PPRetailPage;
@class PPRetailDiscoveredCardReader;
@class PPRetailCardReaderScanAndDiscoverOptions;
@class PPRetailDeviceConnectorOptions;
@class PPRetailSimulationOptions;


/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
/**
 * 
 */
@interface PPRetailInvoiceSearchRequest : PPRetailObject

    /**
    * Initial letters of the email address.
    */
    @property (nonatomic,strong,nullable) NSString* email;
    /**
    * Initial letters of the recipient's first name.
    */
    @property (nonatomic,strong,nullable) NSString* recipientFirstName;
    /**
    * Initial letters of the recipient's last name.
    */
    @property (nonatomic,strong,nullable) NSString* recipientLastName;
    /**
    * Initial letters of the recipient's business name.
    */
    @property (nonatomic,strong,nullable) NSString* recipientBusinessName;
    /**
    * The invoice number that appears on the invoice.
    */
    @property (nonatomic,strong,nullable) NSString* number;
    /**
    * Base object for all financial value
 * related fields (balance, payment due, etc.)
    */
    @property (nonatomic,strong,nullable) NSDecimalNumber* lowerTotalAmount;
    /**
    * Base object for all financial value
 * related fields (balance, payment due, etc.)
    */
    @property (nonatomic,strong,nullable) NSDecimalNumber* upperTotalAmount;
    /**
    * Start invoice date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* startInvoiceDate;
    /**
    * End invoice date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* endInvoiceDate;
    /**
    * Start invoice due date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* startDueDate;
    /**
    * End invoice due date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* endDueDate;
    /**
    * Start invoice payment date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* startPaymentDate;
    /**
    * End invoice payment date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* endPaymentDate;
    /**
    * Start invoice creation date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* startCreationDate;
    /**
    * End invoice creation date.
 * Date format yyyy-MM-dd z, as defined in ISO8601.
    */
    @property (nonatomic,strong,nullable) NSDate* endCreationDate;
    /**
    * A zero-relative index of the merchant's list of invoices
    */
    @property (nonatomic,assign) int startIndex;
    /**
    * Page size of the search results.
    */
    @property (nonatomic,assign) int pageSize;
    /**
    * A flag indicating whether total
 * count is required in the response.
    */
    @property (nonatomic,assign) BOOL totalCountRequired;
    /**
    * A flag indicating whether search is on invoices archived by
 * merchant. true - returns archived / false returns unarchived / null returns all.
    */
    @property (nonatomic,assign) BOOL archived;





    /**
     * Manticore doesn't support properties that are arrays of enum values, and it's complicated.
     * So instead of a property for the status array, we have this method.
     */
    -(void)addStatus:(PPRetailInvoiceStatus)status;




@end
