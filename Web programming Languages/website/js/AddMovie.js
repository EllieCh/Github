$("#btnSubmit").click(function() {
	var title = $("#title").val();
	var year = $("#year").val();
	var genre = $("#genre").val();
	var description = $("#description").val();

	var dataString = 'title=' + title + '&year=' + year + '&genre=' + genre + '&description=' + description;

	if ( title == null || title == "") {
		alert("Enter title");
	} else {
		$.ajax({
			type : "POST",
			dataType : "text",
			url : "php/AddMovie.php",
			data : dataString,
			cache : false,
			success : function(result) {
				result = strip(result);
				if (result == "added") {
					alert("Movie Added");
				} else {
					alert("Movie Addition Failed");
				}
			}
		});
	}
});
