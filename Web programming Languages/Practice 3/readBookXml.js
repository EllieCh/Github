if (window.XMLHttpRequest)
{// code for IE7+, Firefox, Chrome, Opera, Safari
	xmlHttpReq=new XMLHttpRequest();
}
else
{
	xmlhttpReq = new ActiveXObject("Microsoft.XMLHTTP");
}

	xmlHttpReq.open("GET","books.xml",false);
	xmlHttpReq.send();
	xmlDoc = xmlHttpReq.responseXML;
	
	function fetch(){
		setTimeout(function(){
			
		});
	}
	
	document.write("<h1>" + "Information about the books" + "</h1>");
	var x=xmlDoc.getElementsByTagName("book");
	
	if(x!=null && x!='undefined' && x.length!=0){
		document.write("<table><tr><th>Title</th><th>Authors</th>\n\
	 <th>Year</th><th>Price</th><th>Category</th>\n\</tr>");
	 
	for (i=0;i<x.length;i++)
	{ 
		var authors='';
    if((x[i].getElementsByTagName("author").length)>1){
        authors = x[i].getElementsByTagName("author")[0].childNodes[0].nodeValue;
        for (var j = 1; j <=(x[i].getElementsByTagName("author").length)-1; j++) {
            authors=authors+", "+(x[i].getElementsByTagName("author")[j].childNodes[0].nodeValue);
        }
    }
    else{
        authors = x[i].getElementsByTagName("author")[0].childNodes[0].nodeValue;
    }
		document.write("<tr><td>");
		document.write(x[i].getElementsByTagName("title")[0].childNodes[0].nodeValue);
		document.write("</td><td>");
		document.write(authors);
		document.write("</td><td>");
		document.write(x[i].getElementsByTagName("year")[0].childNodes[0].nodeValue);
		document.write("</td><td>");
		document.write(x[i].getElementsByTagName("price")[0].childNodes[0].nodeValue);
		document.write("</td><td>");
		document.write(x[i].getAttribute('category'));
		document.write("</td></tr>");
	}
	document.write("</table><br>");
	}
	else{
		document.write("<b>No information about the books!!<b>");
	}