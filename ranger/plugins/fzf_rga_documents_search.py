from ranger.api.commands import Command

class fzf_rga_documents_search(Command):
    """
    :fzf_rga_search_documents
    Search in PDFs, E-Books and Office documents in current directory.
    Allowed extensions: .epub, .odt, .docx, .fb2, .ipynb, .pdf.

    Usage: fzf_rga_search_documents <search string>
    """
    def execute(self):
        import subprocess
        import os.path
        from ranger.container.file import File
        command="rga '' *"
        lastcommand=' --rga-adapters=pandoc,poppler | fzf +m'

        # set depth
        if self.quantifier:
            command += f' --max-depth={self.quantifier}'

        command += lastcommand
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()

        file_name = stdout.rsplit()[0]
        file_name = file_name.rsplit(':')[0]
        file_type = file_name.rsplit('.')[-1]

        if file_type == 'pdf':
            file_context = stdout.rsplit()[-1]
            command = 'zathura {0} -f {1}'.format(file_name, file_context)
            self.fm.execute_command(command)

        else:
            fzf_file = os.path.abspath(file_name.rstrip('\n'))
            self.fm.execute_file(File(fzf_file))
