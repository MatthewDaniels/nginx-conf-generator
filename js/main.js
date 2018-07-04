
// setup the template settings
// _.templateSettings = {
//   interpolate: /\{\{(.+?)\}\}/g
// }

var currentState = {
  type: null,
  index: null
}

var availableTypeIndexes = [0, 1, 2]

// load the templates
var $templateEls = document.querySelectorAll("script[type='text/template']")
var compiled = {}

var $form = $('#input-form')
var $confOutputEl = $('#nginx-conf-output')
var $upstreamContainer = $('#upstreamContainer')
var $phpOptionsContainer = $('#phpOptionsContainer')
var $updateCongifBtn = $('#updateConfig')

var siteTypeSelectorContainer = document.getElementById('siteTypeSelector')
var siteTypeSelectorList = document.getElementById('siteTypeSelectorList')
var selectedTypeDisplay = document.getElementById('selectedTypeDisplay')

var templates = []
var siteTypeTplText = ''

for (var i = 0, len = $templateEls.length; i < len; i++) {
  var el = $templateEls[i]
  var typeName = el.getAttribute('data-site-type')
  templates[i] = {
    el: el,
    name: typeName,
    index: i
  }
  siteTypeTplText += `<li><a href="#/${i}">${typeName}</a></li>`
}

// set the droppdown based on the tempaltes in the page
siteTypeSelectorList.innerHTML = siteTypeTplText

// ////////////////////////////////////////////////////////////////////////////////////////////////
// /Control

// listen for popstate events
window.onpopstate = typeChange

function typeChange () {
  var newTypeIndex = parseInt(window.location.hash.split('#/')[1])

  // set a default new type
  if (availableTypeIndexes.indexOf(newTypeIndex) === -1) {
    newTypeIndex = 0
  }

  console.log('typeChange', currentState, newTypeIndex)
  if (currentState.index !== newTypeIndex) {
    currentState.index = newTypeIndex
    currentState.type = templates[newTypeIndex].name

    selectedTypeDisplay.innerHTML = currentState.type

    if (/docker/i.test(currentState.type)) {
      // we are using docker - we need an upstream - show it
      $upstreamContainer.find('input').prop('disabled', false)
    } else {
      $upstreamContainer.find('input').prop('disabled', true)
    }

    if (/php/i.test(currentState.type)) {
      // we are using docker - we need an upstream - show it
      $phpOptionsContainer.find('input').prop('disabled', false)
    } else {
      $phpOptionsContainer.find('input').prop('disabled', true)
    }

    console.log('12312312321', /php/i.test(currentState.type))

    // clear / update the conf
    updateConfDisplay()
  }
}

function updateConfDisplay () {
  // grab the values from the form
  // render the appropriate template into the conf element
  var formData = $form.serializeArray()

  var type = currentState.type
  if (!compiled[type]) {
    compiled[type] = _.template(templates[currentState.index].el.innerHTML)
  }
  var tpl = compiled[type]
  var d = {}
  _.each(formData, function (value, key) {
    d[value.name] = value.value
  })
  $confOutputEl[0].innerHTML = tpl(d)
}

$(document).ready(function () {
  // force a type change to update all the values if we have deeplinked
  typeChange()

  // setup event listeners on the inputs
  $form.find('input').on('change.forms', updateConfDisplay)

  $updateCongifBtn.on('click.update', updateConfDisplay)
})

