package email

import "fmt"

const (
	brandPrimary   = "#8B5CF6"
	brandLight     = "#A78BFA"
	bgMain         = "#09090B"
	bgCard         = "#18181B"
	bgCodeBox      = "#0F0F13"
	borderCard     = "#27272A"
	borderCodeBox  = "#3B2D54"
	textPrimary    = "#FAFAFA"
	textSecondary  = "#A1A1AA"
	textMuted      = "#71717A"
)

func renderEmailCard(title, subtitle, otp string) string {
	return fmt.Sprintf(`<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="color-scheme" content="dark">
<meta name="supported-color-schemes" content="dark">
<title>%s</title>
</head>
<body style="margin: 0; padding: 32px 16px; background-color: %s; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased;">
  <table role="presentation" width="100%%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td align="center">
        <table role="presentation" style="max-width: 460px; width: 100%%; background-color: %s; border: 1px solid %s; border-radius: 20px; padding: 36px 28px; text-align: center; box-shadow: 0 16px 36px rgba(0,0,0,0.5);" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center" style="padding-bottom: 24px;">
              <span style="font-size: 26px; font-weight: 800; color: %s; letter-spacing: -0.5px;">Audio<span style="color: %s;">Nara</span></span>
            </td>
          </tr>
          <tr>
            <td align="center" style="padding-bottom: 12px;">
              <h1 style="margin: 0; font-size: 20px; font-weight: 700; color: %s; line-height: 1.3;">%s</h1>
            </td>
          </tr>
          <tr>
            <td align="center" style="padding-bottom: 28px;">
              <p style="margin: 0; font-size: 14px; color: %s; line-height: 1.55; max-width: 380px;">%s</p>
            </td>
          </tr>
          <tr>
            <td align="center" style="padding-bottom: 28px;">
              <div style="background-color: %s; border: 1px solid %s; border-radius: 14px; padding: 18px 24px; display: inline-block; width: 85%%;">
                <span style="font-family: 'SF Mono', Consolas, Menlo, Monaco, monospace; font-size: 32px; font-weight: 700; color: %s; letter-spacing: 10px; margin-left: 10px; display: block;">%s</span>
              </div>
            </td>
          </tr>
          <tr>
            <td align="center">
              <p style="margin: 0; font-size: 12.5px; color: %s; line-height: 1.5;">
                This code will expire in <strong>15 minutes</strong>.<br>If you didn't request this code, you can safely ignore this email.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`,
		title,
		bgMain,
		bgCard,
		borderCard,
		textPrimary,
		brandPrimary,
		textPrimary,
		title,
		textSecondary,
		subtitle,
		bgCodeBox,
		borderCodeBox,
		brandLight,
		otp,
		textMuted,
	)
}

func otpEmailTemplate(otp string) string {
	title := "Verify your email"
	sub := "Welcome to AudioNara! Use the 6-digit verification code below to activate your account."
	return renderEmailCard(title, sub, otp)
}

func otpPlainText(otp string) string {
	return fmt.Sprintf("Welcome to AudioNara!\n\nYour 6-digit verification code is: %s\n\nThis code will expire in 15 minutes.\nIf you did not request this code, you can safely ignore this email.\n\nAudioNara Team", otp)
}

func resetPasswordTemplate(otp string) string {
	title := "Reset your password"
	sub := "We received a request to reset your password. Enter the 6-digit code below in the AudioNara app:"
	return renderEmailCard(title, sub, otp)
}

func resetPasswordPlainText(otp string) string {
	return fmt.Sprintf("AudioNara Password Reset\n\nYour 6-digit password reset code is: %s\n\nThis code will expire in 15 minutes.\nIf you did not request a password reset, please ignore this email.\n\nAudioNara Team", otp)
}
