#=require styleguide/plugins/tbg-forms

describe "A Form Handler", ->
  beforeEach ->
    loadFixtures 'plugins/tbg-forms_fixture'

  describe "Should be a jQuery Plugin", ->
    it "should be defined on jquery object", ->
      expect( $('form').forms() ).toBeDefined()

    it "should return element", ->
      expect( $('form').forms()[0] ).toBe($('form')[0])

    it "should store the instantiated class on the elements", ->
      $form = $('[data-forms]')
      # Convoluted way to stop the form from sending but initializing constructor
      $form.data('forms', '')
      $form.submit()
      expect( $form.data('formsPlugin') ).toBeDefined()

  describe "when the user hits submit", ->
    beforeEach ->
      $form = $('[data-forms]')
      # Convoluted way to stop the form from sending but initializing constructor
      $form.data('forms', '')
      $form.submit()
      # Once initalized URL is added back
      $form.data('forms', '/testURL.json')

    it "will get form URL and data from the form itself", ->
      $form = $('[data-forms]')
      inst = $form.data('formsPlugin')

      spyOn(inst, 'sendRequest')
      $form.submit()
      expect( inst.sendRequest ).toHaveBeenCalledWith( 'mailinglist%5Bemail%5D=', '/testURL.json'   )
      $('.email').val('test@test.com')
      $form.data('forms', '/testURL2.json')
      $form.submit()
      expect( inst.sendRequest ).toHaveBeenCalledWith( 'mailinglist%5Bemail%5D=test%40test.com', '/testURL2.json'   )

    it "will report back errors if the form is not valid", ->
      $form = $('[data-forms]')
      inst = $form.data('formsPlugin')
      spyOn(inst, 'sendRequest').andCallFake ->
        @showErrors "email": ["can't be blank","is invalid"]
      $form.submit()
      $msg = $form.find('.form-msg')
      expect( $msg.text() ).toEqual( "email can't be blank & is invalid" )
      expect( $form.find('.is-error').length ).toEqual(3)

    it "will report success if form is valid", ->
      $form = $('[data-forms]')
      inst = $form.data('formsPlugin')
      spyOn(inst, 'sendRequest').andCallFake ->
        @showSuccess()
      $form.submit()
      expect($($form.data 'tbgforms-success-replace').html()).toEqual($form.data 'tbgforms-success-content')


