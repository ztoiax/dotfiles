from ranger.api.commands import Command
from iterfzf import iterfzf


class fzf_history(Command):
    def execute(self):
        select = iterfzf(self.fm.ui.console.history.history)
        self.fm.execute_console(f'console {select}')
        self.fm.cd(self.fm.thisdir)
