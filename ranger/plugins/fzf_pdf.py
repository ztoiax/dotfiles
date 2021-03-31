from ranger.api.commands import Command


class fzf_pdf(Command):
    def execute(self):
        if self.arg(1):
            search_string = self.rest(1)
        else:
            self.fm.notify("Usage: fzf_rga_search_documents <search string>", bad=True)
            return

        import subprocess
        from ranger.container.file import File
        command = 'rga "{}" . --rga-adapters=pandoc,poppler | fzf'.format(search_string)
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()

        file_name = stdout.rsplit()[0]
        file_name = file_name.rsplit(':')[0]
        file_context = stdout.rsplit()[-1]
        command = 'zathura {0} -f {1}'.format(file_name, file_context)
        self.fm.execute_command(command)
        return
