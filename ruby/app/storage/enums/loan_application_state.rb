class Enums::LoanApplicationState
  include Ruby::Enum

  define :PENDING_IDENTITY, "pending_identity"
  define :PENDING_UNDERWRITING, "pending_underwriting"
  define :DENIED, "denied"
  define :APPROVED, "approved"
  define :CONFIRMED, "confirmed"
end
