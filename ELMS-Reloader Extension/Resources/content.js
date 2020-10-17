async function requestIdentifier(name, resolve) {
    const request = { requestType:"Identifier", "name":name}
    browser.runtime.sendMessage(request).then(response => {
        console.log("Got a response", response)
        if(response?.error) console.error("Error from background:", response?.error)
        return response?.value
    }).then(resolve)
}

requestIdentifier("User", (value) => {
    var pass_input = document.getElementById('username_input')
    if(pass_input) {
        pass_input.value = value
    } else {
        console.warn('Password input not found.')
    }
});

requestIdentifier("Pass", (value) => {
    var pass_input = document.getElementById('password_input')
    if(pass_input) {
        pass_input.value = value
    } else {
        console.warn('Password input not found.')
    }
});

if(false) {
    // TODO
    // セッション切れの場合リロード
}


var button = document.getElementById('login_button')
if(button) {
    var error_message = document.getElementById('error_message')
    if(!error_message) button.click()
}
