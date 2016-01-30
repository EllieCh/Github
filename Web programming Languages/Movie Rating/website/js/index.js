$(document).ready(function() {
	$(":submit[value=Login]").click(function() {
		var username = $("#signin-email").val();
		var passw = $("#signin-password").val();

		if(username==""){
			$("#userspan").show().text("Please enter your Username");
		}
		else if(passw==""){
			$("#passspan").show().text("Please enter your Password");
		}
		else{
		var dataString = 'username=' + username + '&password=' + passw;

		var login = $.ajax({
			type : "POST",
			dataType : "text",
			url : "php/login.php",
			data : dataString,
			cache : false,
			success : function(result) {
				result = strip(result);
				if (result == "a") {
					window.location.replace("UserLogin.php");
				} else if (result == "") {
					window.location.replace("UserLogin.php");
				} else {
					$("#errormsg").show().text(result);
				}
			}
		});

		}
	});

	$(":submit[value='Create account']").click(function() {
		
			var name = $("#signup-fullname").val();
			var username = $("#signup-username").val();
			var email = $("#signup-email").val();
			var passw = $("#password").val();

			if(name==""){
				$("#error-name").show().text("Please enter your Name");
			}
			else if(name.search("[^A-za-z ]")>-1){
				$("#error-name").show().text("Only Alphabets are allowed in Full Name");
			}	
			else if(username==""){
				$("#error-username").show().text("Please enter your Username");
			}
			else if(username.search("[^0-9A-za-z ]")>-1){
				$("#error-username").show().text("Only Alphabets,Numbers are allowed in Username");
			}
			else if(email==""){
				$("#error-email").show().text("Please enter your Email ID");
			}
			else if(email.indexOf("@")<1 || email.lastIndexOf(".")<email.indexOf("@")+2 || email.lastIndexOf(".")+2>=email.length){
				$("#error-email").show().text("Invalid Email Address");
			}
			else if(passw==""){
				$("#error-pass").show().text("Please enter your Password");
			}
			else if(passw.length<8){
				$("#error-pass").show().text("Password should be at least 8 characters long");
			}
			else{
			
			var dataString = 'name=' + name + '&username=' + username + '&password=' + passw + '&email=' + email;

			var create = $.ajax({
				type : "POST",
				url : "php/createAccount.php",
				data : dataString,
				cache : false,
				success : function(result) {
					result = strip(result);
					if (result == "success") {
						window.location.replace("UserLogin.php");
					} else {
						$("#error-signup").show().text(result);
					}
				}
			});
		}
	});
});

function hidesignin(){
		$("#userspan").hide();
		$("#passspan").hide();
		$("#errormsg").hide();
}

function hidesignup(){
			$("#error-username").hide();
			$("#error-email").hide();
			$("#error-name").hide();
			$("#error-pass").hide();
			$("#error-signup").hide();
}

function strip(html) {
	var tmp = document.createElement("DIV");
	tmp.innerHTML = html;
	return tmp.textContent || tmp.innerText || "";
}