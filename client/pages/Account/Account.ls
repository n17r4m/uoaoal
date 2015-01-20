# Account management handled by https://github.com/meteor-useraccounts/
# {{> navButton}} requires named route 'atSignIn'

Router.route '/account', (-> @render 'Account'), name: \atSignIn

AccountsTemplates.configure do
	# Behaviour
	confirmPassword: true
	enablePasswordChange: true
	forbidClientAccountCreation: false
	overrideLoginErrors: true
	sendVerificationEmail: false
	
	# Appearance
	showAddRemoveServices: false
	showForgotPasswordLink: true
	showLabels: true
	showPlaceholders: true
	
	# Client-side Validation
	continuousValidation: false
	negativeFeedback: false
	negativeValidation: true
	positiveValidation: true
	positiveFeedback: true
	showValidating: true
	
	# Privacy Policy and Terms of Use
	#privacyUrl: 'privacy',
	#termsUrl: 'terms-of-use',
	
	# Redirects
	homeRoutePath: '/'
	redirectTimeout: 4000
	
	# Hooks
	#onLogoutHook: myLogoutFunc,
	#onSubmitHook: mySubmitFunc,
	
	# Texts
	/*
	texts:
		button:
			signUp: "Register Now!"
		socialSignUp: "Register",
		socialIcons:
			"meteor-developer": "fa fa-rocket"
		title:
			forgotPwd: "Recover Your Passwod"
	*/

