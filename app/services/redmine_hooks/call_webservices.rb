# frozen_string_literal: true

module RedmineHooks
  class CallWebservices < Base
    include HttpHelper

    attr_reader :payloads_to_send

    def initialize(*args)
      super

      @payloads_to_send = []
      set_payloads_to_send
    end

    def call
      execute_hook do |out|
        if needs_push?
          out << call_webservice
        else
          out << "#{skip_message}\n"
          logger.info skip_message
        end
      end
    end

    def post_receive_url
      object
    end

    def needs_push?
      return true if post_receive_url.mode == :post
      return false if payloads.empty?
      return true unless use_triggers?
      return false if post_receive_url.triggers.empty?

      !payloads_to_send.empty?
    end

    def start_message
      uri = URI post_receive_url.url
      if uri.password.present?
        uri.user = nil
        uri.password = nil
        "Notifying #{uri} (with base auth)"
      else
        "Notifying #{post_receive_url.url}"
      end
    end

    def skip_message
      "This url doesn't need to be notified"
    end

    private

    def set_payloads_to_send
      @payloads_to_send = if post_receive_url.mode == :post
                            {}
                          elsif use_triggers?
                            extract_payloads
                          else
                            payloads
                          end
    end

    def extract_payloads
      new_payloads = []
      payloads.each do |payload|
        data = RedmineGitHosting::Utils::Git.parse_refspec payload[:ref]
        new_payloads << payload if data[:type] == 'heads' && post_receive_url.triggers.include?(data[:name])
      end
      new_payloads
    end

    def use_method
      post_receive_url.mode == :get ? :http_get : :http_post
    end

    def use_triggers?
      post_receive_url.use_triggers?
    end

    def split_payloads?
      post_receive_url.split_payloads?
    end

    def call_webservice
      if use_method == :http_post && split_payloads?
        y = +''
        payloads_to_send.each do |payload|
          y << do_call_webservice(payload)
        end
        y
      else
        do_call_webservice payloads_to_send
      end
    end

    def do_call_webservice(payload)
      post_failed, post_message = send(use_method, post_receive_url.url, { data: { payload: payload } })

      if post_failed
        logger.error 'Failed!'
        logger.error post_message
        (split_payloads? ? failure_message.delete("\n") : failure_message)
      else
        log_hook_succeeded
        (split_payloads? ? success_message.delete("\n") : success_message)
      end
    end
  end
end
