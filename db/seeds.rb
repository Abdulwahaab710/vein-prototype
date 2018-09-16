# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

blood_types = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-'
]

blood_compatiblity = {
  'A+': [
    'A+',
    'AB+'
  ],
  'A-': [
    'A+',
    'A-',
    'AB+',
    'AB-'
  ],
  'B+': [
    'B+',
    'AB+'
  ],
  'B-': [
    'B+',
    'B-',
    'AB+',
    'AB-'
  ],
  'AB+': [
    'AB+'
  ],
  'AB-': [
    'AB+',
    'AB-'
  ],
  'O+': [
    'A+',
    'B+',
    'AB+',
    'O+'
  ],
  'O-': [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ]
}

blood_types.each do |blood_type|
  BloodType.find_or_create_by(name: blood_type)
end

blood_compatiblity.keys.each do |blood_type|
  donator = BloodType.find_by(name: blood_type.to_s)
  blood_compatiblity[blood_type].each do |receiver|
    puts receiver.to_s
    receiver_blood_type = BloodType.find_by(name: receiver)
    BloodCompatibility.find_or_create_by!(donator_id: donator.id, receiver_id: receiver_blood_type.id)
  end
end

def blood_types
  BloodType.all
end

def generate_fake_data
  100.times do
    rand_boolean = [true, false].sample
    User.create(
      name: Faker::Name.unique.name,
      phone: Faker::PhoneNumber.phone_number,
      password: 'password',
      password_confirmation: 'password',
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      country: Faker::Address.country,
      blood_type: blood_types.sample,
      is_donar: rand_boolean,
      is_recipient: !rand_boolean
    )
  end
end
