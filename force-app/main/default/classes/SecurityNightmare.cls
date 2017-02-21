public class SecurityNightmare {

    public SecurityNightmare() {
          List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
          upsert accounts;    
    }

    public void soqlInjection(String fragment) {
        List<Account> accounts = (List<Account>) Database.query('SELECT Id FROM Account WHERE ' + fragment + ';');
          upsert accounts;
    }

    public void badCrypto() {
        Blob key =  Blob.valueOf('Key to be encrypted');
        Blob data = Blob.valueOf('Data to be encrypted');
        Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
    }

      public void insecureEndpoint() {
          String endpoint = 'http://localhost:3300';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
    }

    public PageReference redirect() {
          String param = ApexPages.currentPage().getParameters().get('param');
        return new PageReference(param);
    }
}
