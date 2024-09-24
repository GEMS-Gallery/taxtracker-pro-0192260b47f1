import Func "mo:base/Func";
import Hash "mo:base/Hash";

import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor TaxPayerManager {
    // Define the TaxPayer type
    public type TaxPayer = {
        tid: Text;
        firstName: Text;
        lastName: Text;
        address: Text;
    };

    // Create a stable variable to store the TaxPayer records
    private stable var taxPayerEntries : [(Text, TaxPayer)] = [];
    private var taxPayers = HashMap.HashMap<Text, TaxPayer>(0, Text.equal, Text.hash);

    // System functions for upgrades
    system func preupgrade() {
        taxPayerEntries := Iter.toArray(taxPayers.entries());
    };

    system func postupgrade() {
        taxPayers := HashMap.fromIter<Text, TaxPayer>(taxPayerEntries.vals(), 0, Text.equal, Text.hash);
    };

    // Function to add a new TaxPayer record
    public func addTaxPayer(tp: TaxPayer) : async () {
        taxPayers.put(tp.tid, tp);
    };

    // Function to get all TaxPayer records
    public query func getAllTaxPayers() : async [TaxPayer] {
        return Iter.toArray(taxPayers.vals());
    };

    // Function to search for a TaxPayer by TID
    public query func searchTaxPayer(tid: Text) : async ?TaxPayer {
        return taxPayers.get(tid);
    };
}
