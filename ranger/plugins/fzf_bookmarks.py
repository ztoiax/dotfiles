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

        self.fm.notify(list1[0])
        select = iterfzf(list1)
        self.fm.cd(select)

        # 刷新
        self.fm.execute_console('redraw_window')
