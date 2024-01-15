//
//  Constant.swift
//  Futbolist
//
//  Created by Adeel on 19/12/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

struct Constant {


    static let v2 = "v2"
    static let version = "api/"
    static let mainUrl = "https://buzzwaretech.com/bandy/" + version
    static let mainGoogleUrl = "https://maps.googleapis.com/maps/api"
    static let mainYelpUrl = "https://api.yelp.com/v3"
    static let mainCloudFunctionUrl = "https://us-central1-nearfeast-2227f.cloudfunctions.net"
    static let googleWeApiKey = "AIzaSyCThnHv1DQuBfm5gnj-_CrBxeUwoncQgqI"
    static let yelp_token_key = "jRPEl0gpkC0nhW1FxJwdu_KXMX-MR_mxlr2BVrbUbOzG9nUlFxb8oq5DMdzhHUjouFpaWvcE5mwaFOxIH3UuvmdsqFLNWF0M9rETGxuo8QnzuZpkUGGhp9gD8HWdZXYx"


    //Login Api Endpoints
    static let app_login = "app_login"
    static let app_login_time = 30
    static let login_cache_Key = "login_cache_Key"
    static let login_key = "login_key"
    static let userDetailUrl = "http://137.184.111.69/tattoo/customer/getDetail/"
    static let portalDetailUrl = "http://137.184.111.69/nearfestportal/login/login_link?timespan=3003210&user_id="
    static let restDetailUrl = "http://137.184.111.69/nearfest/site/viewres/"
    static let prodDetailUrl = "http://137.184.111.69/nearfest/site/viewdish/"
        //// model key's
    static let token_key = "token"

    // Product Api Endpoints
    static let user_coins = "user_coins"

    // Forgot Password Endpoints
    static let forget_Password = "forgetPassword"

    // Reward List Endpoints
    static let get_Availble_Reward_list = "getAvailbleRewardlist"
    // My Reward List Endpoints
    static let my_reward_list = "myrewardlist"
    // My Reward List Endpoints
    static let retrive_reward = "retrivereward"
    // SignUp Endpoints
    static let app_register_normal = "app_register/normal"

    static let origin = "origin"
    static let destination = "destination"

    static let routes = "routes"
    static let legs = "legs"
    static let steps = "steps"
    static let polyline = "polyline"
    static let distance = "distance"
    static let duration = "duration"
    static let value = "value"
    static let points = "points"
    static let error_message = "error_message"
    static let cus_id = "cus_id"
    static let subscription_id = "subscription_id"
    static let recurring = "recurring"
    static let interval_count = "interval_count"
    static let key = "key"
    static let amount = "amount"
    static let pm_id = "pm_id"
    static let Kilometers = "Kilometers"
    static let Miles = "Miles"



    static let NODE_USERS = "Users";
    static let NODE_DISHES = "Dishes";
    static let NODE_RESTAURANT = "Restaurant";
    static let NODE_REVIEWS = "Reviews";
    static let NODE_COUNTRY = "Country";
    static let NODE_FOODTYPE = "foodtype";
    static let NODE_DIETTYPE = "diettype";
    static let NODE_NOTIFICATION = "Notification";



    static let NODE_VISITS = "Visits";
    static let NODE_CATEGORIES = "Categories";
    static let NODE_CONVERSATIONS = "Conversations";
    static let NODE_CHATS = "Chat";
    static let NODE_MY_REQUESTS = "MyRequests"
    static let NODE_ADMINCHAT = "AdminChats"
    static let NODE_FEEDBACKS = "Feedbacks"

    static let NODE_SUBUSERS = "SubUser";
    static let NODE_SETTING = "Settings";
    static let NODE_ORDERS = "Orders";
    static let NODE_COMMENTS = "Comments";
    static let NODE_SERVICES = "Services";
    static let NODE_CATEGORY = "category";
    static let NODE_TRADITIONDISH = "traditiondish";


    static let cust_id = "cust_id"
    static let montserratMFont = "Montserrat-SemiBold"
    static let term = "term"
    static let restaurant = "restaurant"
    static let location = "location"

        //// model key's
    static let id = "id"
    static let name = "name"
    static let description = "description"
    static let price = "price"
    static let price_per_case = "price_per_case"
    static let qty_per_case = "qty_per_case"
    static let image_url = "image_url"
    static let metadata = "metadata"
    static let created_at = "created_at"
    static let favorite = "favorite"
    static let item_description = "item_description"
    static let reward_id = "reward_id"
    static let category = "category"
    static let avalibilty = "avalibilty"
    static let companey_name = "companey_name"

    static let items_id = "items_id"
    static let item_name = "item_name"
    static let no_of_coins = "no_of_coins"
    static let code = "code"
    static let PoppinsRegular = "Poppins-Regular"

    // SignUp With Socail Media Endpoints
    static let app_register_social = "app_register/social"

    // Categories Api Endpoints
    static let categories = "categories"
    static let subcategories = "subcategories"
    static let categories_cache_key = "categories_cache_key"
    static let product_cache_key = "product_cache_key"
    static let sp_key = "sp_key"
    static let language = "language"



    // Orders Api Endpoints
    static let orders = "orders/"
            //// Orders Model key's
    static let contact_person = "contact_person"
    static let phone_number = "phone_number"
    static let ordered_by = "ordered_by"
    static let delivery_address = "delivery_address"
    static let ordered_products = "ordered_products"
    static let order_status = "order_status"
    static let total_price = "total_price"

            ////// Order By Model Key's
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
            ////// Delivery Address Model Key's
    static let street_address_1 = "street_address_1"
    static let street_address_2 = "street_address_2"
    static let city = "city"
    static let zipcode = "zipcode"
    static let state_id = "state_id"
    static let country_id = "country_id"
    static let latitude = "latitude"
    static let longitude = "longitude"
            ////// Quantity model Key's
    static let quantity = "quantity"
    static let product = "product"
        ////// Store model Key's
    static let store = "store"
        ////// Order Status model Key's
    static let updated_at = "updated_at"


    static let certificatedoc = "certificatedoc"
    static let policeDoc = "policeDoc"
    static let Diplomadoc = "Diplomadoc"
    static let SigDoc = "SigDoc"







    static let gstPrice = 13.0
    static let servicePrice = 2.92
    static let defLatt = 43.54762429
    static let defLong = -79.62600543
    static let Card = "Card"
    static let card_id = "card_id"
    static let card_num = "card_num"
    static let card_month = "card_month"
    static let card_year = "card_year"
    static let card_cvv = "card_cvv"
    static let card_sid = "card_sid"
    static let card_postcode = "card_postcode"

    static let token = "token"
    static let success = "success"
    static let sucess = "sucess"
    static let return_data = "return_data"
    static let error = "error"
    static let message = "message"
    static let username = "username"
    static let password = "password"
    static let status = "status"
    static let unlike = "unlike"
    static let like = "like"
    static let data = "data"

    static let stripeId = "stripeId"
    static let fuel_added = "fuel_added"
    static let df1 = "df1"
    static let odo = "odo"
    static let address = "address"
    static let reward = "reward"
    static let address_lat = "address_lat"
    static let address_lng = "address_lng"
    static let address_name = "address_name"
    static let ca_image_url = "ca_image_url"
    static let image = "image"

    static var LanguageCheck = ""


    static let ca_id = "ca_id"
    static let ca_status = "ca_status"
    static let is_verify = "is_verify"
    static let ca_created_at = "ca_created_at"
    static let ca_create_day = "ca_create_day"
    static let ca_create_month = "ca_create_month"
    static let ca_create_year = "ca_create_year"
    static let ca_address = "ca_address"
    static let ca_lat = "ca_lat"
    static let ca_lng = "ca_lng"
    static let ca_age = "ca_age"


    static let result = "result"
    static let orderTypeDate = "orderTypeDate"
    static let type = "type"

    static let order_lat = "order_lat"
    static let order_lng = "order_lng"
    static let order_address = "order_address"
    static let lat = "lat"
    static let lng = "lng"
    static let main_cat_name = "main_cat_name"
    static let lowerlimittime = "lowerlimittime"
    static let upperlimittime = "upperlimittime"
    static let customer_id = "customer_id"
    static let user_id = "user_id"
    static let user_lat = "user_lat"
    static let user_long = "user_long"
    static let token_id = "token_id"
    static let user_name = "user_name"
    static let user_email = "user_email"
    static let user_password = "user_password"
    static let oath_id = "oath_id"
    static let login_type = "login_type"
    static let rewards_point = "rewards_point"
    static let tanksize = "tanksize"
    static let date = "date"
    static let purchase_item_id = "purchase_item_id"
    static let last_massage = "last_massage"
    static let convarsation_id = "convarsation_id"

    static let vahical_model = "vahical_model"
    static let vahical_make = "vahical_make"
    static let vahical_year = "vahical_year"

    static let cat_id = "id"
    static let cat_idd = "cat_id"
    static let cat_index = "cat_index"
    static let profile_image = "profile_image"
    static let rating = "rating"
    static let user_type = "user_type"
    static let sub_catid = "sub_catid"
    static let cat_name = "name"
    static let subcategorys_name = "subcategorys_name"
    //static let id = "id"
    static let preview = "preview"
    static let msg = "msg"


    static let feature_video = "feature_video"
    static let video_id = "video_id"
    static let video_url = "video_url"

    static let res_id = "res_id"
    static let res_index = "res_index"
    static let res_name = "res_name"



    static let restaurant_id = "restaurant_id"
    static let restaurant_name = "restaurant_name"
    static let restaurant_description = "restaurant_description"
    static let res_image_url = "res_image_url"
    static let meal_type = "meal_type"
    static let meal_prepration_start_time = "meal_prepration_start_time"
    static let meal_prepration_end_time = "meal_prepration_end_time"
    static let meal_real_price = "meal_real_price"
    static let meals_id = "meals_id"
    static let meals_image_url = "meals_image_url"
    static let meals_days_id = "meals_days_id"
    static let restaurant_lat = "restaurant_lat"
    static let restaurant_lng = "restaurant_lng"
    static let restaurant_address = "restaurant_address"
    static let res_complete_Address = "res_complete_Address"
    static let day = "day"
    static let discount_price = "discount_price"
    static let totalquantity = "totalquantity"
    static let fuel_id = "fuel_id"
    static let inserted_date = "inserted_date"
    static let inserted_time = "inserted_time"
    static let current_fuel = "current_fuel"

    static let meail = "meail"
    static let meal_status = "meal_status"
    static let meal_inserted_date = "meal_inserted_date"
    static let meals_days = "meals_days"
    //static let quantity = "quantity"
    static let meals_upload = "meals_upload"

    static let restaurant_branch_name = "restaurant_branch_name"
    static let restaurant_phone_no = "restaurant_phone_no"

    static let notification_id = "notification_id"
    static let notification_text = "notification_text"
    static let notification_inserted_date = "notification_inserted_date"
    static let isNotify = "isNotify"


    static let order_id = "order_id"
    //static let order_status = "order_status"
    static let order_deliver_time = "order_deliver_time"
    static let order_deliver_date = "order_deliver_date"
    static let bill = "bill"
    static let order_quantity = "order_quantity"
    static let order_type = "order_type"

    static let card_number = "card_number"


    // TableView Cell Identifiers
    static let Profile_Cell_Identifier = "ProfileCellIdentifier"
    static let Search_Location_Identifier = "SearchLocationIdentifier"
    static let Amazon_Cell_Identifier = "AmazonCellIdentifier"
    static let My_Rewards_Cell_Identifier =
    "MyRewardsCellIdentifier"
    static let Settings_Cell_Identifier =
    "SettingsCellIdentifier"
    static let Reward_Collection_Cell_Identifier = "RewardCollectionCell"

    // Segues Identifiers
    static let My_Reward_Segue = "MyRewardSegue"
    static let Profile_Segue = "ProfileSegue"
    static let Settings_Segue = "SittingsSegue"
    static let Change_Password_Segue = "ChangePasswordSegue"
    static let Forgot_Password_Segue = "forgotPasswordSegue"
    static let Amazon_Gift_Code_Segue = "AmazonGiftCodeSegue"
    static let Girft_Card_Success_Segue = "GirftCardSuccessSegue"
    static let Amazon_Gift_Card = "Amazon_Gift_Card"

    // View Controllers Identifiers
    static let Demo_View_Controller = "Demo_View_Controller"
    static let Sign_In_ViewController = "SignInViewController"
    static let tabbar_View_Controller = "ViewController"

    // User Default Key's
    static let user_Login_Default_Key = "user_Login_Default_Key"
    static let Facebook_Sign_Up = "Facebook_Sign_Up"

    // Cache Key's
    static let login_User_Cache_Key = "login_User_Cache_Key"
    // Update Profile Image Endpoint
    static let update_profile_photo = "update_profile_photo"
    // Edit Profile Endpoint
    static let edit_profile = "edit_profile"
    // Report Endpoint
    static let filter_fuel = "filterfuel"
}
