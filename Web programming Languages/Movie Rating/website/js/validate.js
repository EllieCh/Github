function validateField(fieldElem, infoMessage,flag,validateFn) {

var status=0;

		fieldElem.parent().append("<span></span>");
		fieldElem.parent().find("span").hide();

fieldElem.focus(function(){
	// TODO: Implement validateField.	
	if(flag==1){
		status=1;
	}
	if(flag==2){
		if($("#signup-fullname").val()==""){
			alert("Please fill the before field values");
		}
		else{
			status=1;
		}
	}
	if(flag==3){
		if($("#signup-username").val()==""){
			alert("Please fill the before field values");
		}
		else{
			status=1;
		}
	}
	if(flag==4){
		if($("#signup-email").val()==""){
			alert("Please fill the before field values");
		}
		else{
			status=1;
		}
	}

	if(status==1){
		fieldElem.parent().find("span").show();
		fieldElem.parent().find("span").removeClass("error ok").addClass("info");
		fieldElem.parent().find("span").text(infoMessage);

		fieldElem.blur(function(){
		if(fieldElem.val().length == 0){
			fieldElem.parent().find("span").removeClass("error ok").addClass("info");
			fieldElem.parent().find("span").text("Please enter the field");
		}
		else{
			//Not Empty
			//Ok
			if(validateFn()){
				fieldElem.parent().find("span").show();
				fieldElem.parent().find("span").removeClass("error info").addClass("ok");
				fieldElem.parent().find("span").text("OK");
			}
			else{
				//Error
				fieldElem.parent().find("span").show();
				fieldElem.parent().find("span").removeClass("ok info").addClass("error");
				fieldElem.parent().find("span").text("Error");
			}
		}
		});
	}

});

}



function validator_login() {

	// TODO: Use validateField to validate form fields on the page.	
	validateField(
		$("#signup-fullname"),
		"Full name should contain only alphabets.","1",
		function(){
			return /^[A-Za-z]+$/.test($("#signup-fullname").val());
		});


	validateField(
		$("#signup-username"),
		"Username should contain only alphanumeric characters.","2",
		function(){
			return /^[0-9A-Za-z]+$/.test($("#signup-username").val());
		});
	


	validateField(
		$("#password"), 
		"password should be at least 8 characters long","4",
		function(){
			var passLength = $("#password").val().length;
			if(passLength >= 8){
				return true;
			}
			else{
				return false;
			}
		});
	

	validateField(
		$("#signup-email"),
		"Enter a valid email address","3",
		function(){
			var atpos = $("#signup-email").val().indexOf("@");
		    //var dotpos = $("#email").val().lastIndexOf(".");
		    if (atpos< 1) {
		    	return false;
		    }
		    else{
		    	return true;
		    }
		});
	
}

//fieldElem, infoMessage, validateFn