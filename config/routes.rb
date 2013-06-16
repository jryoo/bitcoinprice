NOLAsafewater::Application.routes.draw do

  resources :members
  match '/members/unsubscribe', to: 'members#unsubscribe', as: "members_unsubscribe", :via => :post
  root :to => 'members#new'
end
