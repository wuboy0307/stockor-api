require 'pry'

module Skr
    module API

        module ModelApiClassMethods


            def api_path
                self.to_s.demodulize.pluralize.underscore.dasherize
            end

            def from_api_path(path)
                name = path.underscore.camelize.singularize
                name = "Skr::#{name}" unless name=~/^Skr/
                name.safe_constantize
            end
        end

    end
end

Skr::Model.send :extend,  Skr::API::ModelApiClassMethods
