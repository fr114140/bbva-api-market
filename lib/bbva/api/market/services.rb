module Bbva
  module Api
    module Market

      ACCOUNTS_PATH       = "https://apis.bbva.com/accounts-sbx/v1/me/accounts"
      IDENTITY_PATH       = "https://apis.bbva.com/customers-sbx/v1/me-basic"
      IDENTITY_OTP_PATH   = "https://apis.bbva.com/customers-sbx/v1/me-full"
      IDENTITY_FILE_PATH  = "https://apis.bbva.com/customers-sbx/v1/me/documents/dni"
      CARDS_PATH          = "https://apis.bbva.com/cards-sbx/v2/me/cards"
      LOANS_PATH          = "https://apis.bbva.com/loans-sbx/v1/me"
      PAYMENTS_PATH       = "https://apis.bbva.com/payments-sbx/v1/me"
      PAYSTATS_PATH       = "https://apis.bbva.com/paystats_sbx/4"
      TOKEN_PATH          = "https://connect.bbva.com/token"
      TOKEN_FULL_PATH     = "https://connect.bbva.com/token/authorize"
    end
  end
end
