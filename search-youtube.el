;;; youtube-search.el --- search youtube
;; Copyright (C) 2021 Lars Magne Ingebrigtsen

;; Author: Lars Magne Ingebrigtsen <larsi@gnus.org>
;; Keywords: music

;; This file is not part of GNU Emacs.

;; csid.el is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; csid.el is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;; Code:

(require 'cl-lib)

(defun youtube-search--fetch (url)
  (with-current-buffer (url-retrieve-synchronously url)
    (goto-char (point-min))
    (prog1
	(when (re-search-forward "\n\r?\n\r?" nil t)
	  (buffer-substring (point) (point-max)))
      (kill-buffer (current-buffer)))))

(defun youtube-search (words)
  "Return a list of youtube IDs that match WORDS."
  (youtube-search--parse
   (youtube-search--fetch
    (format "https://www.youtube.com/results?search_query=%s"
	    (url-encode-url words)))))

(defun youtube-search--parse (text)
  (let ((ids nil))
    (with-temp-buffer
      (insert text)
      (goto-char (point-min))
      (while (re-search-forward "videoId\":\"\\([^\"]+\\)" nil t)
	(push (match-string 1) ids)))
    (nreverse (delete-dups ids))))

(provide 'youtube-search)

;;; youtube-search.el ends here
