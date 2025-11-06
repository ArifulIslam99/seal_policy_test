module seal_policy_test::seal_policy_test {
    use sui::table::{Self, Table};

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
}



