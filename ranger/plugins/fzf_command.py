from ranger.api.commands import Command
from ranger.core.actions import Actions
from iterfzf import iterfzf

class fzf_command(Command):
    """:fzf_command
    select command with fzf
    """

    def execute(self):
        select = iterfzf(self.fm.commands.commands)
        if select:
            self.fm.execute_console(f'console {select}')

        # 刷新
        self.fm.execute_console('redraw_window')

        # self.fm.dump_commands()
        # for cmd_name in sorted(self.fm.commands.commands):
        #     cmd = self.commands.commands[cmd_name]
        #     self.fm.notify(cmd_name)


        # def callback(answer):
        #     if answer == "q":
        #         return
        #     elif answer == "m":
        #         self.fm.display_help()
        #     elif answer == "c":
        #         self.fm.dump_commands()
        #     elif answer == "k":
        #         self.fm.dump_keybindings()
        #     elif answer == "s":
        #         self.fm.dump_settings()

        # self.fm.ui.console.ask(
        #     "View [m]an page, [k]ey bindings, [c]ommands or [s]ettings? (press q to abort)",
        #     callback,
        #     list("mqkcs")
        # )
        return
