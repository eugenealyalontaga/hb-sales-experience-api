%dw 2.0
output application/json skipNullOn = "everywhere"
var isOrange = payload.transactionId?
var isBlue   = payload.salesId?
---
{
	sales: {
		transactionId: if ( isOrange ) payload.transactionId
      else payload.salesId,
		customerName: if ( isOrange ) payload.customer_information.name
      else payload.fullName,
		deliveryAddress: if ( isOrange ) payload.customer_information.address
      else payload.deliveryLoc,
		customerContact: if ( isOrange ) payload.customer_information.phone
      else payload.contact,
		customerAge: if ( isOrange ) payload.customer_information.age
      else (payload.age as Number),
		customerGender: if ( isOrange ) payload.customer_information.gender
      else payload.gender,
		totalAmount: if ( isOrange ) payload.total
      else payload.amountDue,
		paymentType: if ( isOrange ) payload.mop
      else payload.paymentType,
		transactionDate: if ( isOrange ) (payload.timestamp as DateTime) as String {
			format: "yyyy-MM-dd'T'HH:mm:ss'Z'"
		}
      else
        (payload.creationDate as DateTime) as String {
			format: "yyyy-MM-dd'T'HH:mm:ss'Z'"
		},
		source: if ( isOrange ) "Orange App"
      else "Blue App"
	},
	salesItems: if ( isOrange ) payload.line_items map (item) -> {
		itemId: item.lineId,
		transactionId: payload.transactionId,
		productName: item.product,
		price: item.unitPrice,
		quantity: item.quantity
	}
    else
      payload.products map (item) -> {
		itemId: trim(item.id),
		transactionId: payload.salesId,
		productName: item.name,
		price: item.price,
		quantity: item.qty
	}
}
