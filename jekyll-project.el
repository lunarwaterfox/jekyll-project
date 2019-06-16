(defgroup jekyll-project nil
  "Support a jekyll project environment."
  :group 'text)

(defcustom jekyll-project-post-dir "_post/"
  "Jekyll markdown folder."
  :type 'string
  :group 'jekyll-project)

(defcustom jekyll-project-org-dir "_org/"
  "Jekyll org folder."
  :type 'string
  :group 'jekyll-project)

(defcustom jekyll-project-home-key 'jekyll-project
  "Jekyll project key use in project-home."
  :type 'symbol
  :group 'jekyll-project)

(defcustom jekyll-project-serve-command "bundle exec jekyll serve"
  "Jekyll serve command."
  :type 'string
  :group 'jekyll-project)

(defcustom jekyll-project-url "http://127.0.0.1:4000"
  "Jekyll home url."
  :type 'string
  :group 'jekyll-project)



(defun jekyll-project-export-name ()
  "Get export name of current buffer."
  (if buffer-file-name
      (file-name-base buffer-file-name)
    (read-string "Output file name: ")))

(defun jekyll-project-get-subdir (subdir)
  "Get jekyll subdir."
  (let* ((home (project-home-dir-by-key jekyll-project-home-key))
         (path (concat home subdir)))
    (unless (file-exists-p path)
      (make-directory path))
    path))
  
(defun jekyll-project-org-export ()
  "Export org file to md in _post"
  (interactive)
  (let ((outfile (jekyll-project-export-name))
        (outpath (jekyll-project-get-subdir jekyll-project-post-dir)))
    (if (and (fboundp 'org-gfm-export-to-markdown)
             (fboundp 'org-export-to-file))
        (org-export-to-file 'gfm (concat outpath outfile ".md"))
      (message "Please load org-mode and ox-gfm first."))))

(defun jekyll-project-set-project-directory ()
  "Set jekyll project path"
  (interactive)
  (project-home-query-home 'jekyll-project))


(defun jekyll-project-org-open (name)
  "Create new org file in jekyll-project-org-dir"
  (interactive "sInput file name: ")
  (let* ((dir (jekyll-project-get-subdir jekyll-project-org-dir))
         (file (concat (file-name-sans-extension name) ".org"))
         (path (concat dir file)))
    (with-current-buffer (find-file path)
      (insert
       "#+OPTIONS: toc:nil\n\n"
       "#+BEGIN_EXPORT markdown\n"
       "---\n\n"
       "layout: default\n"
       "author: \n"
       "title: \n"
       "categories: \n\n"
       "---\n"
       "#+END_EXPORT\n\n"
       "* title"))))

(defun jekyll-project-run-serve ()
  "Jekyll start a serve."
  (interactive)
  (let ((default-directory (project-home-dir-by-key jekyll-project-home-key)))
    (async-shell-command jekyll-project-serve-command)))

(defun jekyll-project-show-web ()
  "Jekyll show web page."
  (interactive)
  (browse-url jekyll-project-url))

(provide 'jekyll-project)
