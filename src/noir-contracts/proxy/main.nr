contract TestProxy {
    // Add storage
    struct Storage {
        secret_string: Set<str<12>>,
        contract_address: AztecAddress,
    }
    // Use this to test initialisation of contract State inside the proxy
    #[aztec(public)]
    fn test_delegate_call(targetAddress: AztecAddress, function_selector: FunctionSelector, fn_args: [Field;N]) {
        // DO something here with delegate_call_public_function(...);        
        context.delegate_call_function(targetAddress,function_selector, fn_args);
    }

    fn upgrade(new_c) {

    }
}