jQuery(window).load(function() {
    $(".loader-centered").fadeOut();
    $(".loader").delay(400).fadeOut("slow");
});

$(document).ready(function() {

	// --------------------------------------------------------
	//	Navigation Bar
	// -------------------------------------------------------- 		
	$(window).scroll(function(){	
		"use strict";	
		var scroll = $(window).scrollTop();

		if( scroll < 10 ){		

			$(".navbar").removeClass("scroll-fixed-navbar");
		 	$("#imgLogo").css('display','none' );
			$(".scroll-up").css('display','none' );
						
		} else {
			$(".navbar").addClass("scroll-fixed-navbar");
			$("#imgLogo").attr('src','img/logo11.png' );
			$("#imgLogo").css('display','inline' );
			$(".scroll-up").css('display','inline' );
		}
	});	
	
	// --------------------------------------------------------
	// Pretty Photo for Lightbox Image
	// -------------------------------------------------------- 
   /* $("a[data-gal^='prettyPhoto']").prettyPhoto(); */
	
	
	// --------------------------------------------------------
	//	Smooth Scrolling
	// -------------------------------------------------------- 	
	$(".navbar-nav li a[href^='#']").on('click', function(e) {
		e.preventDefault();
		var hash = this.hash;
		$('html, body').animate({
			scrollTop: $(hash).offset().top
			}, 1000, function(){
			window.location.hash = hash;
		});
	});
	
	// --------------------------------------------------------
	//	Scroll Up
	// -------------------------------------------------------- 	
	$(window).scroll(function() {
		if ($(this).scrollTop() > 100) {
			$('.scroll-up').fadeIn();
		} else {
			$('.scroll-up').fadeOut();
		}
	});

	$('.scroll-up').click(function() {
		$("html, body").animate({
			scrollTop: 0
		}, 600);
		return false;
	});

});




// --------------------------------------------------------
//	Collapse Navigation (Mobile) on click
// -------------------------------------------------------- 	
$(document).on('click','.navbar-collapse.in',function(e) {
    if( $(e.target).is('a') ) {
        $(this).collapse('hide');
    }
});



// --------------------------------------------------------
//	Banner Form
// -------------------------------------------------------- 
$('.form-horizontal').on('submit', function(e) {
    e.preventDefault(); //Prevents default submit

    var form = $(this);
    var post_url = form.attr('action');
    var post_data = form.serialize(); //Serialized the form data for process.php
    $('.form-process').html('<p><i class="ion-ios-information-outline"></i> Please Wait...</p>');
    $.ajax({
        type: 'POST',
        url: 'mail.php', // Your form script
        data: post_data,
        success: function(msg) {
            /*$(form).fadeOut(500, function() {
                form.html(msg).fadeIn();
            });*/
			//$('.form-process').html('<p class="text-center">Submission Successful</p>');
			$('.form-process').html('<p></p>');

			$('#myModal').modal('hide');
			alert(msg);
			$("#IDuserName").val('');
			$("#IDEmail").val('');
			$("#IDPhone").val('');
			$("#IDTextArea").val('');

        }
    });
});


// --------------------------------------------------------
//	Contact Form
// -------------------------------------------------------- 
$('.sendContact').on('submit', function(e) {
    e.preventDefault(); //Prevents default submit
    var form = $(this);
    var post_url = form.attr('action');
    var post_data = form.serialize(); //Serialized the form data for process.php
       $.ajax({
        type: 'POST',
        url: 'mailContact.php', // Your form script
        data: post_data,
        success: function(msg) {
        	
			alert(msg);
			$("#InputName").val('');
			$("#InputEmail").val('');
			$("#InputPhone").val('');
			$("#InputMessage").val('');

			
        }
    });
});


$('#myModal').on('hidden.bs.modal', function (e) {
  
	  
});


  function changepath(data)
  {
  	document.getElementById("imgParent").src = data;
  }
  
  


