class SubDomain < ApplicationRecord
  VALID_DOMAIN_REGEX = /[a-z\d\-.]+\.[a-z]+\z/i
  VALID_IP_REGEX = /\d+\.\d+\.\d+\.\d+/
  belongs_to :domain
  validates :domain_id, presence: true
  validates :sname, presence: true, format: {with: VALID_DOMAIN_REGEX}
  validates :sip, format: {with: VALID_IP_REGEX}
end
