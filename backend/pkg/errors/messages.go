package errors

const (
	MsgInvalidCreds           = "Incorrect email or password. Please try again."
	MsgEmailNotVerified       = "Your email address has not been verified. Please check your inbox for the verification code."
	MsgEmailAlreadyAssociated = "This email is already associated with an account. Please log in instead."
	MsgInvalidVerificationOTP = "Invalid or expired verification code. Please request a new one."
	MsgInvalidResetOTP        = "Invalid or expired reset code. Please request a new password reset."
	MsgInvalidSessionContext  = "Invalid session context."
	MsgUserNotFound           = "User not found."
	MsgErrorRetrievingFile    = "Error retrieving the file."
	MsgAlbumIDRequired        = "Album ID is required."
	MsgAlbumIDEmpty           = "Album ID must not be empty."
	MsgSearchQueryEmpty       = "Search query cannot be empty."
	MsgSameAsOldPassword      = "New password cannot be the same as your current password."

	// Validator Messages
	MsgEmailRequired       = "Email address is required."
	MsgEmailInvalidFormat  = "Please provide a valid email address (e.g., name@gmail.com)."
	MsgEmailTypo           = "Please check your email address for typos."
	MsgPasswordShort       = "Password must be at least 8 characters long."
	MsgPasswordNoUpper     = "Password must contain at least one uppercase letter."
	MsgPasswordNoDigit     = "Password must contain at least one number."
	MsgUsernameShort       = "Username must be at least 3 characters long."
	MsgUsernameLong        = "Username must be 30 characters or fewer."
	MsgUsernameFormat      = "Username can only contain letters, numbers, underscores, dots, or hyphens."
	MsgNameInvalidFormat   = "Name can only contain letters, spaces, and hyphens without numbers or special symbols."
	MsgPhoneInvalidFormat  = "Phone number can only contain digits."
	MsgPlaylistNameEmpty   = "Playlist name cannot be empty."
	MsgPlaylistNameLong    = "Playlist name must be 50 characters or fewer."
	MsgBioLong             = "Bio must be 250 characters or fewer."
	MsgInvalidOTPFormat    = "Please enter the 6-digit code sent to your email."
	MsgInvalidTokenFormat  = "Invalid reset token. Please copy the full token from your email."
)
