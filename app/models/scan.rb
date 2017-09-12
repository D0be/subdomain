class Scan < ApplicationRecord
    enum status: [:queued, :running, :finished]
    VALID_DOMAIN_REGEX = /[a-z\d\-.]+\.[a-z]+\z/i
    validates :title, presence: true
    validates :target, presence: true, format: {with: VALID_DOMAIN_REGEX}
end
