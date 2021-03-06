module RedmineDropbox
  module AttachmentsControllerPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        before_filter :redirect_to_dropbox, :except => :destroy
        skip_before_filter :file_readable
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def redirect_to_dropbox
        if @attachment.respond_to? :container
          if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
            @attachment.increment_download
          end
        end

        f = Attachment.dropbox_client.find(@attachment.dropbox_path)
        
        redirect_to f.direct_url[:url]
      end
    end
  end
end