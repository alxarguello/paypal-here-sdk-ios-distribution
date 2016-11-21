/**
 * PPRetailSecureEntryOptions.h
 *
 * DO NOT EDIT THIS FILE! IT IS AUTOMATICALLY GENERATED AND SHOULD NOT BE CHECKED IN.
 * Generated from: node_modules/retail-payment-device/src/EmvDevice.js
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
@class PPRetailTransactionContext;
@class PPRetailSignatureReceiver;
@class PPRetailReceiptOptionsViewContent;
@class PPRetailReceiptEmailEntryViewContent;
@class PPRetailReceiptSMSEntryViewContent;
@class PPRetailReceiptViewContent;
@class PPRetailCard;
@class PPRetailBatteryInfo;
@class PPRetailMagneticCard;
@class PPRetailPaymentDevice;
@class PPRetailEmvDevice;
@class PPRetailSecureEntryOptions;
@class PPRetailNumericEntryOptions;
@class PPRetailManuallyEnteredCard;
@class PPRetailDeviceUpdate;
@class PPRetailDeviceOperationResultHandler;
@class PPRetailVirtualPaymentDevice;
@class PPRetailPayer;
@class PPRetailTransactionRecord;

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
/**
 * SecureEntryOptions specify which values you would like the SDK
 * to gather from the terminal and which you would like to just gather
 * on your own
 */
@interface PPRetailSecureEntryOptions : PPRetailObject

    /**
    * true to gather the CVV value on terminal, false to skip that
    */
    @property (nonatomic,assign) BOOL cvv;
    /**
    * true to gather expiration month and year on terminal
    */
    @property (nonatomic,assign) BOOL expiration;








@end
