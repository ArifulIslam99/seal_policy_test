module seal_policy_test::seal_policy_test {
    use sui::table::{Self, Table};

    const EAlreadyWhitelisted: u64 = 1;
    const ENotWhitelisted: u64 = 2;

    const ADMIN: address = @0x2;

    public struct WhiteList has key {
        id: UID,
        addresses: Table<address, bool>
    }

    public struct AdminCap has key {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            WhiteList {
                id: object::new(ctx),
                addresses: table::new(ctx)
            }
        );

        transfer::transfer(
            AdminCap {
                id: object::new(ctx),
            },
            ADMIN
        );
    }

    public fun add(
        _cap: &AdminCap,
        white_list: &mut WhiteList,
        new_user: address
    ){
        assert!(!(white_list.addresses.contains(new_user)), EAlreadyWhitelisted);
        white_list.addresses.add(new_user, true);
    }

    public fun remove(
        _cap: &AdminCap,
        white_list: &mut WhiteList,
        user: address
    ){
        assert!((white_list.addresses.contains(user)), ENotWhitelisted);
        white_list.addresses.remove(user);
    }

    fun check_policy(
        caller: address,
        id: vector<u8>,
        white_list: &WhiteList
    ): bool{
        
        let prefix = white_list.id.to_bytes();
        if(prefix.length() > id.length()) {
            return false
        };
        let mut i = 0;
        while(i < prefix.length()){
            if(prefix[i] != id[i]) {
                return false
            };
            i = i + 1;
        };
        white_list.addresses.contains(caller)
    }

    entry fun seal_approve(
        id: vector<u8>, 
        white_list: &WhiteList,
        ctx: &TxContext
    ){
        assert!(check_policy(tx_context::sender(ctx), id, white_list));
    }
}



