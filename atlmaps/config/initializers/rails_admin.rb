RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  
  config.model 'Project' do
    
    list do
      field :name
      field :saved
      field :published
    end
    
    edit do
      field :name
      field :description
      field :saved
      field :published
    end
    
  end
  
  config.model 'Layer' do
    
    list do
      field :name
      field :layer_type
      field :institution
    end
    
    edit do
      field :name
      field :description
      field :tags
      field :institution
      field :slug
      field :url
      field :layer
      field :layer_type
      field :minzoom
      field :maxzoom
      field :minx
      field :miny
      field :maxx
      field :maxy
    end
    
  end
  
  config.model 'Institution' do
    list do
      field :name
    end
    
    edit do
      field :name
      field :geoserver
      field :icon
    end
    
  end
  
  config.excluded_models << "Projectlayer"
  
end
