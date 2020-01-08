(function () {
    'use strict';

    angular
        .module('app')
        .controller('LoginController', LoginController);

    LoginController.$inject = ['$location','$rootScope', 'AuthenticationService','UserService', 'FlashService'];
    function LoginController($location, $rootScope, AuthenticationService, UserService,FlashService) {
        var vm = this;

        vm.login = login;
        $rootScope.email_regex = /[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+/i;
        $rootScope.password_regex = /([A-Za-z0-9\.\-\#\$\%\&\!\@]){10,255}/i;

        (function initController() {
            // reset login status
            AuthenticationService.ClearCredentials();
        })();

        function login() {
            vm.dataLoading = true;
            AuthenticationService.Login(vm.email, vm.password, function (response) {
                if (response.success) {
                    console.log("this was a success!");
                    AuthenticationService.SetCredentials(vm.email, response.token);
                    UserService.set_master_password(vm.password);
                    $location.path('/');
                } else {
                    console.log("this failed..." + response.message);
                    FlashService.Error(response.message);
                }
                vm.dataLoading = false;
            });
        };
    }
})();
