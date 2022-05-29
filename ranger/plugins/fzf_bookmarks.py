from ranger.api.commands import Command
from iterfzf import iterfzf

class fzf_bookmarks(Command):
    """:fzf_bookmarks
    select bookmarks with fzf
    """

    def execute(self):
        list1 = []
        for k, v in iter(self.fm.bookmarks):
            list1.append(str(v))

        select = iterfzf(list1)
        if select:
            self.fm.cd(select)

        # 刷新
        self.fm.execute_console('redraw_window')
