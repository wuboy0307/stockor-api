module Skr
    module API

        Root.build_route GlAccount,     indestructible: true
        Root.build_route GlPeriod,      indestructible: true
        Root.build_route GlTransaction, indestructible: true
        Root.build_route GlManualEntry, indestructible: true
        Root.build_route PaymentTerm,   indestructible: true
        Root.build_route Location,      indestructible: true
        Root.build_route Address
        Root.build_route Vendor
        Root.build_route Customer
        Root.build_route Sku
        Root.build_route SkuLoc
        Root.build_route Uom
        Root.build_route SkuVendor
        Root.build_route IaReason
        Root.build_route InventoryAdjustment
        Root.build_route IaLine,  path: 'lines', under: 'inventory-adjustments'
        Root.build_route SkuTran
        Root.build_route SalesOrder
        Root.build_route SoLine,  path: 'lines', under: 'sales-orders'
        Root.build_route PurchaseOrder
        Root.build_route PoLine,  path: 'lines', under: 'purchase-orders'
        Root.build_route PickTicket
        Root.build_route PtLine,  path: 'lines', under: 'pick-tickets'
        Root.build_route Invoice, immutable: true
        Root.build_route InvLine, path: 'lines', under: 'invoices', immutable: true
        Root.build_route Voucher
        Root.build_route VoLine,  path: 'lines', under: 'vouchers'
        Root.build_route PoReceipt
        Root.build_route PorLine, path: 'lines', under: 'po-receipts'

        Root.get "default-records" do
            { success: true, data: Skr::API.default_records }
        end

    end
end
