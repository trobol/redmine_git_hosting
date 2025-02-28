# frozen_string_literal: true

FactoryBot.define do
  factory :gitolite_public_key do
    sequence(:title) { |n| "test-key#{n}" }
    key do
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDpqFJzsx3wTi3t3X/eOizU6rdtNQoqg5uSjL89F+Ojjm2/sah3ouzx+3E461FDYaoJL58Qs9eRhL+ev0BY7khYXp' \
      'h8nIVDzNEjhLqjevX+YhpaW9Ll7V807CwAyvMNm08aup/NrrlI/jO+At348/ivJrfO7ClcPhq4+Id9RZfvbrKaitGOURD7q6Bd7xjUjELUN8wmYxu5zvx/2n/5woVd' \
      'BUMXamTPxOY5y6DxTNJ+EYzrCr+bNb7459rWUvBHUQGI2fXDGmFpGiv6ShKRhRtwob1JHI8QC9OtxonrIUesa2dW6RFneUaM7tfRfffC704Uo7yuSswb7YK+p1A9QI' \
      't5 nicolas@tchoum'
    end
    key_type { 0 }
    association :user
  end
end
