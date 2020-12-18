from ranger.api.commands import Command
class tmpfile(Command):
    def execute(self):
        tmp = ' /tmp'
        command='mv ' + self.arg(1) + ' /tmp'
        self.fm.execute_command(command)
        return
