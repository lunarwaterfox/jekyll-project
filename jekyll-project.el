(defun jekyll-project-org-export ()
  "export org file to md in _post"
  (interactive)
  (let ((outfile (file-name-base (buffer-file-name)))
        (outpath (concat (project-home-dir-by-key 'jekyll-project) "_post/")))
    (unless (file-exists-p outpath)
      (make-directory outpath))
    (if (fboundp 'org-gfm-export-to-markdown)
        (org-export-to-file 'gfm (concat outpath outfile ".md"))
      (message "Cannot find org-gfm-export-to-markdown"))))


(provide 'jekyll-project)
