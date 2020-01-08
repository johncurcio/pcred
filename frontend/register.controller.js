(function () {
    'use strict';

    angular
        .module('app')
        .controller('RegisterController', RegisterController)
        .directive('pwCheck', [function () { //used for password match check in register form
          return {
            require: 'ngModel',
            link: function (scope, elem, attrs, ctrl) {
                var firstPassword = '#' + attrs.pwCheck;
                elem.add(firstPassword).on('keyup', function () {
                    scope.$apply(function () {
                        var v = elem.val()===$(firstPassword).val();
                        ctrl.$setValidity('pwmatch', v);
                    });
                });
            }
          }
        }]);

    RegisterController.$inject = ['UserService', '$location', '$rootScope', 'FlashService', 'AuthenticationService'];
    function RegisterController(UserService, $location, $rootScope, FlashService, AuthenticationService) {
        var vm = this;

        vm.register = register;
        vm.sq1="What is your Favorite Music Artist?";
        vm.sq2="What is 3?";
        vm.sq3="What is your Favorite Movie?";

        $rootScope.email_regex = /[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+/i;
        $rootScope.phone_regex = "\\d{10}";
        $rootScope.password_regex = /([A-Za-z0-9\.\-\#\$\%\&\!\@]){10,255}/i;

        function register() {
            vm.dataLoading = true;
            console.log(vm.user);
            UserService.CreateUser(vm.user)
                .then(function (response) {
                    console.log(response);
                    if (response.success) {
                        vm.dataLoading = true;
                        AuthenticationService.Login(vm.user.email, vm.user.pass, function (res) {
                            if (res.success) {
                                AuthenticationService.SetCredentials(vm.user.email, res.token);
                                $location.path('/');
                            } else {
                                FlashService.Error("Service Unavailable!");
                            }
                            vm.dataLoading = false;
                        });
                    } else {
                        FlashService.Error(response.message);
                        vm.dataLoading = false;
                    }
                });
        }
    }
})();
