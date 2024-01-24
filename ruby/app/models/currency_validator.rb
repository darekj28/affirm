class CurrencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, "invalid currency" unless value.present? && Set["usd", "cad", "gbp", "eur"].include?(value.downcase)
  end
end
