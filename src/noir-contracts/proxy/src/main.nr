contract Proxy {
    
    use dep::std::option::Option;

    use dep::aztec::{
        log::emit_unencrypted_log, state_vars::{public_state::PublicState, set::Set},
        protocol_types::{abis::{function_selector::FunctionSelector}, address::AztecAddress},
        note::{note_viewer_options::NoteViewerOptions, utils as note_utils, note_header::NoteHeader}
    };


    // Add storage
        struct Storage {
        secret_string: PublicState<Field>,
        contract_address: PublicState<AztecAddress>,
    }

    #[aztec(private)]
    fn constructor(){}

    // Use this to test initialisation of contract State inside the proxy
    #[aztec(private)]
    fn test_delegate_call(targetAddress: AztecAddress, function_selector: FunctionSelector, fn_args: [Field;2]) {
        // DO something here with delegate_call_public_function(...);        
        context.delegate_call_private_function(targetAddress,function_selector, fn_args);
    }

    // todo: anyways the contract_address storage should only be modified by the owner
    #[aztec(private)]
    fn upgrade(new_contract: AztecAddress) {
        // todo: can we check this is a valid address?
        storage.contract_address.write(new_contract);
        let migrate = FunctionSelector::from_signature("migrate()"); //todo: how to find the proper signature?
        let ret = context.delegate_call_private_function_no_args(new_contract, migrate); // migrate could/should? have as argument the version we upgrade from: TODO we need to have a version number as well 
        //TODO; what todo in case of error? normally we should rollback to the previons address
        //but if the function does not complete, we can't get a proof of execution, so I imaging nothing is changed and this is fine.
    }

    #[aztec(private)]
    // a contract function to fallback to this one.
    fn fall_back(function_selector: FunctionSelector, fn_args: [Field;10]) {
        context.delegate_call_private_function(storage.contract_address, function_selector, fn_args);
    }
}

//writing here because I can't create files somehow
//contract Contract1 {
//    fn check_signature() {
        //this contract is called by the proxy, and needs to use storage slot from the proxy, how does that work??
//        let secret = "";//TODO the secret_string of the caller
                        // not clear what we want to do here..?
//    }
//    fn migrate(secret: String) {
        //should this function initialise the secret_string? is passing the secret as argument ok? I suppose it is if secret is a private value.
//    }
//}

//the multisig contract
//contract Contract2 {
//    fn check_signature() {

//    }
//    fn migrate() {
        // we should delete the secret_string because we do not want somebody to use contract1 anymore.
//    }
//}
