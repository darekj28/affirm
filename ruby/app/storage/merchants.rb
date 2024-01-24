class Merchants
  include Singleton

  def initialize
    zelda_default = MerchantConfiguration.new(
      "4f572866-0e85-11ea-94a8-acde48001122",
      "Zelda's Stationery",
      100.00,
      3000.00
    )
    @merchants = {"4f572866-0e85-11ea-94a8-acde48001122" => zelda_default}
  end

  def get_merchant_configuration(merchant_id)
    @merchants[merchant_id]
  end
end
