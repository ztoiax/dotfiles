from ranger.api.commands import Command

class tmpfile(Command):
    ''' use mv file to /tmp instead of rm '''

    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        for filename in marked_files:
            self.fm.execute_command(f'mv {filename} /tmp')
        return
