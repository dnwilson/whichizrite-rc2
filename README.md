#whichizrite: be heard!

whichizrite is a new social platform which allows you voice your upload and share your opinion on photos, videos and/or music. User are able to upload and view content on their Android and iOS devices, as well as, your favorite web browser. The idea is simple, if you like the posted content click the checkbox or "whichizrite" button, or click the "whichizwrong" button if you don't. So go ahead, sign up and be heard!

Dane Wilson
*Founder & CEO*

##Known issues
- [x] When you select a picture to upload if you remove the picture and try to add a new one. The new picture will not show up in the preview window.
- [x] Client Side Validation only works when validation is listed in the model. So it currently doesn't work with devise.
- [x] Post media is not validated client side
- [ ] Firefox textboxes don't display correctly. Check bootstrap scaffolding file and comment out 'background-image:none' for input fields.

##Todo
- [x] Finish Bootstrap 3 UI
	- [x] Add Image from link Preview
	- [x] Add Youtube Link Preview
	- [x] Disable image upload button if post has link & vice-versa
	- [x] Client-side validation
	- [x] Full Javascript implementation
	- [x] Implement Nokogiri
	- [x] Finalize Bootstrap Tweaks
		- [x] Add Image Attachment for WorldStar Videos
		- [x] Fix Profile Page
		- [ ] Fix error handling on Settings Page
- [x] Add SEO Support
		- [x] Implement Pretty Url
		- [x] Add Meta Data
- [x] Fix Single Post Page Styling
- [ ] Mailing System
	- [x] Welcome
	- [x] Forgot Password
	- [x] Follow Alert
	- [x] Profile Update
	- [x] Commented on Post
	- [x] Voted on Post
	- [x] Voted on Comment
- [ ] Optimize Turbolinks
- [ ] Notifications
- [ ] Ad Management
- [ ] Analytics
- [ ] Release Beta
- [ ] Auto Create Post from Link Using Nokogiri
- [ ] Android App
- [ ] iOS App