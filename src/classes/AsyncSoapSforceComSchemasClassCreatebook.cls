//Generated by wsdl2apex

public class AsyncSoapSforceComSchemasClassCreatebook {
    public class createBookResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class AsyncCreateBook {
        public String endpoint_x = 'https://eu9.salesforce.com/services/Soap/class/CreateBook';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public soapSforceComSchemasClassCreatebook.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public soapSforceComSchemasClassCreatebook.CallOptions_element CallOptions;
        public soapSforceComSchemasClassCreatebook.SessionHeader_element SessionHeader;
        public soapSforceComSchemasClassCreatebook.DebuggingInfo_element DebuggingInfo;
        public soapSforceComSchemasClassCreatebook.DebuggingHeader_element DebuggingHeader;
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/CreateBook';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/CreateBook';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/CreateBook';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/CreateBook';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/CreateBook';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/CreateBook', 'soapSforceComSchemasClassCreatebook'};
        public AsyncSoapSforceComSchemasClassCreatebook.createBookResponse_elementFuture beginCreateBook(System.Continuation continuation,String name) {
            soapSforceComSchemasClassCreatebook.createBook_element request_x = new soapSforceComSchemasClassCreatebook.createBook_element();
            request_x.name = name;
            return (AsyncSoapSforceComSchemasClassCreatebook.createBookResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassCreatebook.createBookResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/CreateBook',
              'createBook',
              'http://soap.sforce.com/schemas/class/CreateBook',
              'createBookResponse',
              'soapSforceComSchemasClassCreatebook.createBookResponse_element'}
            );
        }
    }
}