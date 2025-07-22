// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import FlashController from "./flash_controller"
import OrderItemsController from "./order_items_controller"

eagerLoadControllersFrom("controllers", application)
application.register("flash", FlashController)
application.register("order-items", OrderItemsController)
