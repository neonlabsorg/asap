require 'net/http'
require 'uri'
require 'json'

class SlackNotificationService
  def self.notify(payload)
    return unless webhook_url.present?

    begin
      uri = URI.parse(webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      request.body = payload.to_json

      response = http.request(request)
      Rails.logger.info "Slack notification sent. Response: #{response.code}"
    rescue => e
      Rails.logger.error "Failed to send Slack notification: #{e.message}"
    end
  end

  def self.notify_new_alert(alert)
    severity_emoji = case alert.severity
      when 'Critical' then '❗'
      else '⚠️'
    end

    payload = {
      text: "#{severity_emoji} *#{alert.severity} Threat Detected*",
      blocks: [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "#{severity_emoji} *#{alert.severity} Threat Detected*"
          }
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: "*Title:*\n#{alert.title}"
            },
            {
              type: "mrkdwn",
              text: "*Asset:*\n#{alert.asset}"
            }
          ]
        }
      ]
    }
    notify(payload)
  end

  def self.notify_reopened_alert(alert)
    severity_emoji = case alert.severity
      when 'Critical' then '❗'
      else '⚠️'
    end

    payload = {
      text: "#{severity_emoji} *#{alert.severity} Threat Resurfaced*",
      blocks: [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "#{severity_emoji} *#{alert.severity} Threat Resurfaced*"
          }
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: "*Title:*\n#{alert.title}"
            },
            {
              type: "mrkdwn",
              text: "*Asset:*\n#{alert.asset}"
            }
          ]
        }
      ]
    }
    notify(payload)
  end

  private

  def self.webhook_url
    ENV['SLACK_WEBHOOK_URL']
  end
end 