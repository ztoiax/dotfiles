from ranger.api.commands import Command
import pathlib
from iterfzf import iterfzf
from datetime import datetime

class mark_filetime(Command):
    '''
    Mark files at the same time
    '''
    def execute(self):
        self.fm.execute_console('unmark *')

        if self.arg(1) == 'atime':
            time_command = 'filename.stat().st_atime'
            self.fm.notify('atime')
        elif self.arg(1) == 'ctime':
            time_command = 'filename.stat().st_ctime'
            self.fm.notify('ctime')
        else:
            time_command = 'filename.stat().st_mtime'
            self.fm.notify('mtime')

        cwd = self.fm.thisdir

        # {filename : filetime, ...}
        filetime_dict = {}
        thisdir = pathlib.Path(str(cwd)).iterdir()
        for i in thisdir:
            filename = pathlib.Path(i)
            unixtime = eval(time_command)
            filetime_dict |= {str(filename.name) : datetime.utcfromtimestamp(unixtime).strftime('%Y-%m-%d_%H:%M:%S')}

        # ['filename  filetime', ...]
        filetime_list = []
        for k, v in filetime_dict.items():
            kv = f'{k} {v}'
            filetime_list.append(kv)

        select = iterfzf(filetime_list)
        select = select.split()[1]
        self.fm.notify(select)

        for k, v in filetime_dict.items():
            if v == select:
                self.fm.execute_console(f'mark {k}')

        # The refresh problem is not yet resolved
        # self.fm.ui.win.refresh()
        return
