// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChannelNotificationController from "./channel_notification_controller"
application.register("channel-notification", ChannelNotificationController)

import ChannelsController from "./channels_controller"
application.register("channels", ChannelsController)

import DotNotificationController from "./dot_notification_controller"
application.register("dot-notification", DotNotificationController)

import FilesController from "./files_controller"
application.register("files", FilesController)

import FlashController from "./flash_controller"
application.register("flash", FlashController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import MessageController from "./message_controller"
application.register("message", MessageController)

import PreviewsController from "./previews_controller"
application.register("previews", PreviewsController)
