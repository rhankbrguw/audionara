package email

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/smtp"
	"os"
	"time"
)

type EmailService interface {
	SendOTP(to string, otp string) error
	SendResetLink(to string, token string) error
}

type SMTPEmailService struct {
	Host     string
	Port     string
	Username string
	Password string
	FromName string
	ResendKey string
	ResendFrom string
	client   *http.Client
}

func NewEmailService() EmailService {
	return NewSMTPEmailService()
}

func NewSMTPEmailService() *SMTPEmailService {
	from := os.Getenv("RESEND_FROM")
	if from == "" {
		from = "notifications@rhankbrguw.xyz"
	}
	fromName := os.Getenv("RESEND_FROM_NAME")
	if fromName == "" {
		fromName = os.Getenv("SMTP_FROM_NAME")
	}
	if fromName == "" {
		fromName = "AudioNara"
	}

	return &SMTPEmailService{
		Host:       os.Getenv("SMTP_HOST"),
		Port:       os.Getenv("SMTP_PORT"),
		Username:   os.Getenv("SMTP_USER"),
		Password:   os.Getenv("SMTP_PASS"),
		FromName:   fromName,
		ResendKey:  os.Getenv("RESEND_API_KEY"),
		ResendFrom: from,
		client:     &http.Client{Timeout: 10 * time.Second},
	}
}

func (s *SMTPEmailService) sendMail(to, subject, body string) error {
	if s.ResendKey != "" {
		return s.sendResend(to, subject, body)
	}
	addr := s.Host + ":" + s.Port
	auth := smtp.PlainAuth("", s.Username, s.Password, s.Host)

	from := fmt.Sprintf("%s <%s>", s.FromName, s.Username)
	msg := []byte("From: " + from + "\r\n" +
		"To: " + to + "\r\n" +
		"Subject: " + subject + "\r\n" +
		"MIME-Version: 1.0\r\n" +
		"Content-Type: text/html; charset=UTF-8\r\n\r\n" +
		body + "\r\n")

	return smtp.SendMail(addr, auth, s.Username, []string{to}, msg)
}

func (s *SMTPEmailService) sendResend(to, subject, html string) error {
	payload := map[string]any{
		"from":    fmt.Sprintf("%s <%s>", s.FromName, s.ResendFrom),
		"to":      []string{to},
		"subject": subject,
		"html":    html,
	}
	data, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("resend: json error: %w", err)
	}
	req, err := http.NewRequest("POST", "https://api.resend.com/emails", bytes.NewBuffer(data))
	if err != nil {
		return fmt.Errorf("resend: request error: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+s.ResendKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := s.client.Do(req)
	if err != nil {
		return fmt.Errorf("resend: http error: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode >= 400 {
		return fmt.Errorf("resend: status %d", resp.StatusCode)
	}
	return nil
}

func (s *SMTPEmailService) SendOTP(to string, otp string) error {
	subject := "Verify your AudioNara Account"
	return s.sendMail(to, subject, otpEmailTemplate(otp))
}

func (s *SMTPEmailService) SendResetLink(to string, otp string) error {
	subject := "Reset your AudioNara Password"
	return s.sendMail(to, subject, resetPasswordTemplate(otp))
}
