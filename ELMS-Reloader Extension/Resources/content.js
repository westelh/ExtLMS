function requestIdentifier(name, resolve) {
    const request = { requestType:"Identifier", "name":name}
    return browser.runtime.sendMessage(request).then(response => {
        console.log("Got a response", response)
        if(response?.error) console.error("Error from background:", response?.error)
        return response?.value
    }).then(resolve)
}

const userPromise = requestIdentifier("User", (value) => {
    var pass_input = document.getElementById('username_input')
    if(pass_input) {
        pass_input.value = value
        return value
    } else {
        console.warn('User input not found.')
    }
});

const passPromise = requestIdentifier("Pass", (value) => {
    var pass_input = document.getElementById('password_input')
    if(pass_input) {
        pass_input.value = value
        return value
    } else {
        console.warn('Password input not found.')
    }
});

if(false) {
    // TODO
    // セッション切れの場合リロード
}

Promise.all([userPromise, passPromise]).then((user, pass) => {
    var button = document.getElementById('login_button')
    var error_message = document.getElementById('error_message')
    if(!error_message) {
        button?.click()
    }
});
