function boyscall(){
var str = document.getElementById("year").value;
	if (str=="") {
    document.getElementById("2").innerHTML="";
    return;
  } 
  if (window.XMLHttpRequest) {
        xmlhttp=new XMLHttpRequest();
  } else { 
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      document.getElementById("2").innerHTML=xmlhttp.responseText;
	  girlscall(str);
    }
  }
  xmlhttp.open("GET","babynames.php?q="+str+"&g=m",true);
  xmlhttp.send();
}

function girlscall(str){

	if (str=="") {
    document.getElementById("1").innerHTML="";
    return;
  } 
  if (window.XMLHttpRequest) {
        xmlhttp=new XMLHttpRequest();
  } else {
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      document.getElementById("1").innerHTML=xmlhttp.responseText;
    }
  }
  xmlhttp.open("GET","babynames.php?q="+str+"&g=f",true);
  xmlhttp.send();
}