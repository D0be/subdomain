class Domain < ApplicationRecord
    VALID_DOMAIN_REGEX = /[a-z\d\-.]+\.[a-z]+\z/i
    VALID_IP_REGEX = /\d+\.\d+\.\d+\.\d+/
    has_many :sub_domains, dependent: :destroy
    validates :dtitle, presence: true
    validates :dname, presence: true, format: {with: VALID_DOMAIN_REGEX}
    validates :dip, format: {with: VALID_IP_REGEX}
end
