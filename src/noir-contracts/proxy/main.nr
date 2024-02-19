contract TestProxy {
    // Add storage
    struct Storage {
        secret_string: Set<str<12>>,
    }
    contract_address: AztecAddress,

    // Use this to test initialisation of contract State inside the proxy
    #[aztec(public)]
    fn test_delegate_call(targetAddress: AztecAddress, function_selector: FunctionSelector, fn_args: [Field;N]) {
        // DO something here with delegate_call_public_function(...);        
        context.delegate_call_function(targetAddress,function_selector, fn_args);
    }

    // todo: should be a private function, because only the owner is able to upgrade
    // todo: anyways the contract_address storage should only be modified by the owner
    fn upgrade(&mut self, new_contract: AztecAddress) {
        // todo: can we check this is a valid address?
        self.contract_address = new_contract;
        let migrate = FunctionSelector::from_signature("migrate"); //todo: how to find the proper signature?
        context.delegate_call_function(new_contract, migrate, []); // migrate could/should? have as argument the version we upgrade from: TODO we need to have a version number as well 
        //TODO; what todo in case of error? normally we should rollback to the previons address
        //but if the function does not complete, we can't get a proof of execution, so I imaging nothing is changed and this is fine.
    }

    #[aztec(fallback)]  //todo: make this works; we want to add a new aztec decorator, and it must be used inside the kernel circuit when calling
    // a contract function to fallback to this one.
    fn fall_back(&mut self, function_selector: FunctionSelector, fn_args: [Field;N]) {
        context.delegate_call_function(self.contract_address, function_selector, fn_args);
    }
}

//writing here because I can't create files somehow
contract Contract1 {
    fn check_signature() {
        //this contract is called by the proxy, and needs to use storage slot from the proxy, how does that work??
        let secret = "";//TODO the secret_string of the caller
        // not clear what we want to do here..?
    }
    fn migrate(secret: String) {
        //should this function initialise the secret_string? is passing the secret as argument ok? I suppose it is if secret is a private value.
    }
}

//the multisig contract
contract Contract2 {
    fn check_signature() {

    }
    fn migrate() {
        // we should delete the secret_string because we do not want somebody to use contract1 anymore.
    }
}
