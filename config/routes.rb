# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  root to: 'users#status'

  get '/signup', to: 'users#new', as: :signup
  post '/signup', to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/user/update', to: 'users#complete_profile', as: :complete_profile
  patch '/user/update', to: 'users#update'

  get '/confirm-number', to: 'users#confirm_number_new', as: :confirm_user_number
  post '/confirm-number', to: 'users#confirm_number'

  patch '/user/opt-in/donor', to: 'users#register_as_a_donar', as: :donor_opt_in
  get '/user/recipient', to: 'users#enroll_blood_recipient', as: :enroll_blood_recipient
  post '/user/recipient', to: 'users#register_as_a_blood_recipient'

  get '/confirm/:token', to: 'donation_queues#confirm', as: :confirm_donation
  patch '/confirm/:token/available', to: 'donation_queues#available_status', as: :available
  delete '/confirm/:token/unavailable', to: 'donation_queues#unavailable_status', as: :unavailable
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
