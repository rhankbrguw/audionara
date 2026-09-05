package http

import (
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/google/uuid"
	apperrors "github.com/user/audionara/backend/pkg/errors"
)

func saveUploadedFile(file io.Reader, filename string) error {
	if err := os.MkdirAll("./uploads", os.ModePerm); err != nil {
		return err
	}
	dst, err := os.Create(filepath.Join("./uploads", filename))
	if err != nil {
		return err
	}
	defer dst.Close()
	_, err = io.Copy(dst, file)
	return err
}

// uploadFile handles file uploads (e.g., profile pictures or cover arts).
func (h *Handler) uploadFile(w http.ResponseWriter, r *http.Request) {
	r.ParseMultipartForm(10 << 20)

	file, handler, err := r.FormFile("file")
	if err != nil {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, apperrors.MsgErrorRetrievingFile))
		return
	}
	defer file.Close()

	ext := filepath.Ext(handler.Filename)
	filename := uuid.New().String() + ext
	if err := saveUploadedFile(file, filename); err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusCreated, envelope{Data: map[string]string{"url": "/uploads/" + filename}})
}
