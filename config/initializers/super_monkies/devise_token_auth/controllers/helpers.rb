module DeviseTokenAuth::Controllers::Helpers
  module ClassMethods
    def devise_token_auth_group(group_name, opts = {})
      mappings = "[#{opts[:contains].map { |m| ":#{m}" }.join(',')}]"

      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def authenticate_#{group_name}!(favourite=nil, opts={})
          unless #{group_name}_signed_in?
            mappings = #{mappings}
            mappings.unshift mappings.delete(favourite.to_sym) if favourite
            mappings.each do |mapping|
              set_user_by_token(mapping)
            end
            unless current_#{group_name}
              render_authenticate_error
            end
          end
          authenticate_#{group_name}_hook if respond_to?(:authenticate_#{group_name}_hook)
        end
        def #{group_name}_signed_in?
          #{mappings}.any? do |mapping|
            set_user_by_token(mapping)
          end
        end
        def current_#{group_name}(favourite=nil)
          mappings = #{mappings}
          mappings.unshift mappings.delete(favourite.to_sym) if favourite
          mappings.each do |mapping|
            current = set_user_by_token(mapping)
            return current if current
          end
          nil
        end
        def current_#{group_name.to_s.pluralize}
          #{mappings}.map do |mapping|
            set_user_by_token(mapping)
          end.compact
        end
        def render_authenticate_error
          return render json: {
            errors: [I18n.t('devise.failure.unauthenticated')]
          }, status: 401
        end
        if respond_to?(:helper_method)
          helper_method(
            "current_#{group_name}",
            "current_#{group_name.to_s.pluralize}",
            "#{group_name}_signed_in?",
            "render_authenticate_error"
          )
        end
      METHODS
    end
  end
end
