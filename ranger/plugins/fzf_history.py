from ranger.api.commands import Command
from iterfzf import iterfzf


class fzf_history(Command):
    def execute(self):
        select = iterfzf(self.fm.ui.console.history.history)
        if select:
            self.fm.execute_console(f'console {select}')

        # 刷新
        self.fm.execute_console('redraw_window')
