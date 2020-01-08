(function () {
    'use strict';

    angular
        .module('app')
        .controller('RecoverController', RecoverController)
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

    RecoverController.$inject = ['UserService', '$location', '$rootScope', 'FlashService', 'AuthenticationService'];
    function RecoverController(UserService, $location, $rootScope, FlashService, AuthenticationService) {
        var vm = this;

        vm.register = register;
        vm.sq1="What is your Favorite Music Artist?";
        vm.sq2="What is 3?";
        vm.sq3="What is your Favorite Movie?";

        $rootScope.email_regex = /[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+/i;
        $rootScope.phone_regex = "\\d{10}";
        $rootScope.password_regex = /([A-Za-z0-9\.\-\#\$\%\&\!\@]){10,255}/i;

        function register() {
            vm.password = '';
            vm.dataLoading = true;
            console.log(vm.user);
            UserService.recoverPassword(vm.user)
                .then(function (response) {
                    console.log(response);

                    if (response.success) {
                        if(response.user.password != null){
                            vm.password="This is your Master Password: " + response.user.password;
                        }
                        vm.dataLoading = false;
                         } else {
                        vm.password = "Invalid Email or Security Answer!";
                        vm.dataLoading = false;
                    }

                });
        }
    }
})();