class RasterLayer < ActiveRecord::Base
  # include Filtering
  has_many :raster_layer_project
  has_many :projects, through: :raster_layer_project, dependent: :destroy
  belongs_to :institution

  has_and_belongs_to_many :tags, dependent: :destroy

  scope :by_institution, -> name { joins(:institution).where(institutions: {name: name}) if name.present?}
  scope :by_tags, -> tags { joins(:tags).where(tags: {name: tags}) if tags.present?}
  scope :search_by_year, -> (start_year,end_year) { where(year: start_year..end_year) }
  scope :text_search, ->(text_search) { joins(:text_search) if query.present?}
  scope :active, -> { where(active: true)}
  # Get random map taht has less than three tags
  scope :test, -> { all if :tags.length > 0 }
  scope :un_taged, -> { group("raster_layers.id").having( 'count( raster_layers ) < 3' ).order('RANDOM()').first! }

# conf.echo = false
# ActiveRecord::Base.logger = nil
  def self.by_year(start_year, end_year)
      if end_year > 0
          search_by_year(start_year, end_year)
      else
          all
      end
  end

  include PgSearch
  pg_search_scope :search, against: [:name, :title, :description],
    using: { tsearch: { prefix: true, dictionary: 'english' } }
    # associated_against: { tags: :name, institution: :name }

    def self.text_search(query)
        # Return no results if query isn't present
        search(query)
    end

  def self.browse_text_search(query)
      # If there is no query, return everything.
      # Not everything will be returned becuae other filters will be present.
    if query.present?
      search(query)
    else
      all
    end
  end


  # Attribute to use for html classes
  def slug
  	slug = self.name.parameterize
  	return "#{slug}-#{id}"
  end

  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end

  def slider_id
  	slug = self.name.parameterize
  	return "slider-#{slug}-#{id}"
  end

  def slider_value_id
  	slug = self.name.parameterize
  	return "slider-value-#{slug}-#{id}"
  end

  def url
      return "#{self.institution.geoserver}#{self.workspace}/wms"
  end

  def layers
      return "#{self.workspace}:#{self.name}"
  end
end
