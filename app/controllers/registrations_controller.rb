class RegistrationsController < Milia::RegistrationsController

    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
    # TODO: options if non-standard path for new signups view
    # ------------------------------------------------------------------------------
    # create -- intercept the POST create action upon new sign-up
    # new tenant account is vetted, then created, then proceed with devise create user
    # CALLBACK: Tenant.create_new_tenant  -- prior to completing user account
    # CALLBACK: Tenant.tenant_signup      -- after completing user account
    # ------------------------------------------------------------------------------
    def create
        # have a working copy of the params in case Tenant callbacks
        # make any changes
      user_params   = sign_up_params_user.merge({ is_admin: true })
      coupon_params = sign_up_params_coupon
  
      sign_out_session!
         # next two lines prep signup view parameters
      prep_signup_view(user_params, coupon_params )
  
         # validate recaptcha first unless not enabled
      
              
             
            resource.valid?
            render :new
          end # if .. then .. else no tenant errors
          
          if flash[:error].blank? || flash[:error].empty? #payment successful
  
            devise_create( user_params )   # devise resource(user) creation; sets resource
  
            if resource.errors.empty?   #  SUCCESS!
  
              log_action( "signup user/tenant success", resource )
                # do any needed tenant initial setup
  
            else  # user creation failed; force tenant rollback
              log_action( "signup user create failed", resource )
              raise ActiveRecord::Rollback   # force the tenant transaction to be rolled back  
            end  # if..then..else for valid user creation
          else
            resource.valid?
            
            render :new and return
          end # if.. then .. else no tenant errors
        end  #  wrap tenant/user creation in a transaction
      else
        flash[:error] = "Recaptcha codes didn't match; please try again"
           # all validation errors are passed when the sign_up form is re-rendered
        resource.valid?
        log_action( "recaptcha failed", resource )
        render :new
      end
  
    end   # def create
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
  
      protected
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
      
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
    
  
    # ------------------------------------------------------------------------------
    # sign_up_params_coupon -- permit coupon parameter if used; else params
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
    # sign_out_session! -- force the devise session signout
    # ------------------------------------------------------------------------------
      def sign_out_session!()
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name) if user_signed_in?
      end
  
    # ------------------------------------------------------------------------------
    # devise_create -- duplicate of Devise::RegistrationsController
        # same as in devise gem EXCEPT need to prep signup form variables
    # ------------------------------------------------------------------------------
      def devise_create( user_params )
  
        build_resource(user_params)
  
          # if we're using milia's invite_member helpers
  
        if resource.save
          yield resource if block_given?
          log_action( "devise: signup user success", resource )
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, :location => after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          log_action( "devise: signup user failure", resource )
          respond_with resource
        end
      end
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
      def after_sign_up_path_for(resource)
        headers['refresh'] = "0;url=#{root_path}"
        root_path
      end
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
      def after_inactive_sign_up_path_for(resource)
        headers['refresh'] = "0;url=#{root_path}"
        root_path
      end
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
  
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
  
    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
  
  end  