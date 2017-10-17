# Modle calss to hold the features for the vector layers.
class VectorFeature < ApplicationRecord
    belongs_to :vector_layer, autosave: true
    # after_save :update_vector_layer

    def geojson
        RGeo::GeoJSON.encode(geometry_collection.projection)
    end

    def layer_title
        vector_layer.title
    end

    def name
        properties['name'] || properties['NAME'] || properties['title'] || properties['NEIGHBORHOOD'] || 'Untitled'
    end

    def description
        properties['description']
    end

    def youtube
        return nil unless properties['gx_media_links'] || properties['video']
        return properties['gx_media_links'] if properties.key?('gx_media_links') and properties['gx_media_links'].include? 'youtube'
        return properties['video'] if properties.key?('video') and properties['video'].include? 'youtube'
    end

    def vimeo
        return if properties['gx_media_links'].include? 'vimeo'
        properties['video'].include? 'vimeo'
    rescue
        return nil
    end

    def images
        return nil if properties['images'].is_a? String
        properties['images'].to_a
    end

    def image
        return nil if properties['images'].is_a? String
        properties['image'].to_h['url']
    rescue
        return nil
    end

    def audio
        properties['audio']
    end

    def feature_id
        layer_title.parameterize + '-' + id.to_s
    end

    private

    def update_vector_layer
        vector_layer.save
    end
end
