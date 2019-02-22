function demoOnchange(input) {
    window.webkit.messageHandlers.InjectHTML.postMessage({title: "输入框失去焦点", message:input.target.value, id: input.target.id});
}
function demoOnInput(input) {
    window.webkit.messageHandlers.InjectHTML.postMessage({title: "输入框正在输入", message:input.target.value, id: input.target.id});
}
function demoSet() {
    var inputs=document.getElementsByTagName("input");
    for(var i=0;i < inputs.length;i++) {
        var input = inputs[i];
        input.addEventListener('change', demoOnchange);
        input.addEventListener('input', demoOnInput)
    }
}
demoSet();
