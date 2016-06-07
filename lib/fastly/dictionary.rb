class Fastly
  class Dictionary < BelongsToServiceAndVersion
    attr_accessor :id, :name, :service_id

    def items
      fetcher.list_dictionary_items(:service_id => service_id, :dictionary_id => id)
    end

    def add_item(key, value)
      fetcher.create_dictionary_item(service_id: service_id, dictionary_id: id, item_key: key, item_value: value)
    end

    def update_item(key, value)
      begin
        di = fetcher.get_dictionary_item(service_id, id, key)
        di.item_value = value
        fetcher.update_dictionary_item(di)

      # Fastly eats the HTTP errors, really we only want to do this with 404s,
      # but we do it for all errors because that's the data we have.
      rescue Fastly::Error
        add_item(key, value)
      end
    end

    def delete_item(key)
      fetcher.delete_dictionary_item(service_id: service_id, dictionary_id: id, item_key: key)
    end

    def self.pluralize
      'dictionaries'
    end
  end
end
