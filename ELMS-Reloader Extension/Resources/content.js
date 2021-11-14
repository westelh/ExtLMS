function hasError() {
    return document.getElementById('error_message')
}

function makePostParamBack() {
    const url = new URL(location.href)
    return url.origin + url.searchParams.get('back')
}

function getSessId() {
    return document.getElementById('sessid').value
}

function requestToBackground(target) {
    const message = { requestType:"Identifier", name:target}
    return browser.runtime.sendMessage(message).then(response => response.value)
}

function post(path, params, method='post') {
  const form = document.createElement('form');
  form.method = method;
  form.action = path;

  for (const key in params) {
    if (params.hasOwnProperty(key)) {
      const hiddenField = document.createElement('input');
      hiddenField.type = 'hidden';
      hiddenField.name = key;
      hiddenField.value = params[key];

      form.appendChild(hiddenField);
    }
  }

  document.body.appendChild(form);
  form.submit();
}

function login(user, pass) {
    var params = {
        dummy:'',
        username: user,
        password: pass,
        op: 'login',
        back: makePostParamBack(),
        sessid: getSessId()
    }
    post(location.origin + location.pathname, params)
}

if(!hasError()) {
    let UserRequestValue = "UserRequest"
    let PassRequestValue = "PassRequest"
    
    const userPromise = requestToBackground(UserRequestValue)
    const passPromise = requestToBackground(PassRequestValue)
    Promise.all([userPromise, passPromise]).then(results => {
        const user = results[0]
        const pass = results[1]
        login(user, pass)
    })
}
