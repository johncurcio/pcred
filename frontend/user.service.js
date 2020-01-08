(function () {
    'use strict';

    angular
        .module('app')
        .factory('UserService', UserService);

    UserService.$inject = ['$http', '$rootScope', '$cookies'];
    function UserService($http, $rootScope, $cookies) {
        var service = {};
        var master_password = null;
        var first_name = '';
        var last_name = '';
        var config = {
              headers : {
                  'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;'
              }
        };

        service.TryLogin = TryLogin;
        service.GetWebsites = GetWebsites;
        service.GetPassword = GetPassword;
        service.EditPassword = EditPassword;
        service.DeletePassword = DeletePassword;
        service.CreatePassword = CreatePassword;
        service.CreateUser = CreateUser;
        service.UpdateUser = UpdateUser;
        service.get_master_password = get_master_password;
        service.set_master_password = set_master_password;
        service.recoverPassword = recoverPassword;

        service.DecryptPassword = DecryptPassword;

        return service;

        // Attempt to log in given the email and password
        function TryLogin(email, pwd) {
          var url = 'https://fierce-sea-94874.herokuapp.com/users/login';
          var data = $.param({
                email: email,
                password: pwd
          });
          var errormsg = 'Error logging in with provided email and password';
          return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));  
        }

        // Get all the websites that a user has a password for
        function GetWebsites() {
          var token = sessionStorage.token;//$cookies.get('curUserToken');
          var url = "https://fierce-sea-94874.herokuapp.com/passwords/get_list";
          var data = $.param({
                token: token
          });
          var errormsg = 'Error pulling up all the websites';
          return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        // Get the password for a specific website
        // this needs to be changed to not include a master password
        function GetPassword(website, master_password) {
          var token = sessionStorage.token;//$cookies.get('curUserToken');
          var url = "https://fierce-sea-94874.herokuapp.com/passwords/get";
          var data = $.param({
              token: token,
              website: website,
              master_password: master_password
          });
          var errormsg = 'Error retrieving password for ' + website;
          return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        function EditPassword(website, new_password, master_password) {
          var token = sessionStorage.token;
          var url = 'https://fierce-sea-94874.herokuapp.com/passwords/update';
          var data = $.param({
            token: token,
            website: website,
            password: new_password,
            master_password: master_password
          });
          var errormsg = 'Error editing password for ' + website;
          return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        function DeletePassword(website) {
            var token = sessionStorage.token;
            var url = "https://fierce-sea-94874.herokuapp.com/passwords/destroy";
            var data = $.param({
                token: token,
                website: website
            });
            var errormsg = 'Error deleting password for ' + website;
            return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        //needs to change this function to not include master password!
        function CreatePassword(website, password, master_password) {
            var token = sessionStorage.token;
            var url = "https://fierce-sea-94874.herokuapp.com/passwords/create";
            var data = $.param({
              token: token,
              website: website,
              password: password,
              master_password: master_password
            });
            var errormsg = 'Error creating the given password'; 
            return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        function CreateUser(user) {
          var url = "https://fierce-sea-94874.herokuapp.com/users/create";
          var data = $.param({
              first_name: user.first_name,
              last_name: user.last_name,
              email: user.email,
              phone_number: user.phone,
              password: user.pass,
              password_confirmation: user.pass_conf,
              answer_1: user.sq1,
              answer_2: user.sq2,
              answer_3: user.sq3
          });
          var errormsg = 'Error creating the user';
          return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        function UpdateUser(f_name, l_name, new_m, confirm_m, current_m) {
          var token = sessionStorage.token;

          var data, url = "https://fierce-sea-94874.herokuapp.com/users/update";
          if (f_name != null  && l_name == null) {
            data = $.param({
              token: token,
              first_name: f_name,
              last_name: $rootScope.last_name
            });
          } else if (f_name == null && l_name != null) {
            data = $.param({
              token: token,
              first_name: $rootScope.first_name,
              last_name: l_name
            });
          } else if (f_name != null && l_name != null) {
            data = $.param({
              token: token,
              first_name: f_name,
              last_name: l_name
            });
          } else {
            data = $.param({
              token: token,
              password: new_m,
              password_confirmation: confirm_m,
              old_password: current_m
            });
          }
          var errormsg = 'Error updating the user';
          return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }
        
        // horrible name of function, the server should not decrypt password
        // we should change this to ValidePhone or Two-Auth... something better.
        function DecryptPassword(key){
           var token = sessionStorage.token;//$cookies.get('curUserToken');
           var url = "https://fierce-sea-94874.herokuapp.com/passwords/validate_phone";
           var data = $.param({
              token: token,
              website: website, //where is it getting this website from?
              code: key
          });
           var errormsg = 'Error fetching the password';
            return $http.post(url, data, config).then(handleSuccess, handleError(errormsg));
        }

        // private functions
        function set_master_password(pass){
          master_password=pass;
        }

        function get_master_password(){
          return master_password;
        }

        function handleSuccess(res) {
            return { success: true, user: res.data };
        }

        function handleError(error) {
            return function () {
                return { success: false, user: null, message: error };
            };
        }

        function recoverPassword(user){
          var url = "https://fierce-sea-94874.herokuapp.com/users/recover_password";
          var data = $.param({
              email: user.email,
              answer_1: user.sq1,
              answer_2: user.sq2,
              answer_3: user.sq3
          });
          var errormsg = 'Error creating the user';
          return $http.post(url,data,config).then(handleSuccess, handleError(errormsg));
        }
    }

})();
