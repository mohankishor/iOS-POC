
function showhide()
{
    if (document.getElementById){
        objG = document.getElementById("graph");
        if (objG.style.display == "none"){
            objG.style.display = "";
        } else {
            objG.style.display = "none";
        }

        objM = document.getElementById("notification");
        if (objM.style.display == "none"){
            objM.style.display = "";
        } else {
            objM.style.display = "none";
        }
    }
}