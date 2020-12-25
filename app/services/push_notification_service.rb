class PushNotificationService
  require "fcm"

  def initialize(message = nil, to = nil, notification_type = 'default', options = nil)
    @message = message #nội dung gói tin
    @to = to #người nhận
    @notification_type = notification_type #loại thông báo
    @options = options #các tùy chọn kèm theo
  end

  def deliver
    fcm = FCM.new(ENV["API_FIREBASE_KEY"])
    options = {
      data: {
        message: @message,
        sound: 'default'
      },
      notification: { body: 'message',
        title: 'title',
        sound: 'default',
        icon: 'image.png'
      },
      notification_type: @notification_type
    }
    registration_ids = @to.device_tokens.try(:pluck, :device_token)
    fcm.send(registration_ids, options) if registration_ids.present?
  end
end