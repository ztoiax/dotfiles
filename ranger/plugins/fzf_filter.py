from ranger.api.commands import Command
import pathlib
from iterfzf import iterfzf


class fzf_filter(Command):
    '''
    filter to suffix of file or type of file
    Useage:
        fzf_filter
        fzf_filter fzf
    '''
    def execute(self):
        if self.arg(1) == 'fzf':
            cwd = self.fm.thisdir
            self.fm.notify(cwd)

            dir = pathlib.Path(str(cwd))

            # 获取所有文件的拓展名(suffix)
            suffix_set = set()
            for file in dir.iterdir():
                suffix_set.add(''.join(file.suffixes))

            # 文件类型
            type_set = set()
            type_set.add('f')
            type_set.add('d')
            type_set.add('l')

            # fzf
            select = iterfzf(suffix_set | type_set)

            if select in type_set:
                self.fm.execute_console(f'filter_stack add type {select}')
                self.fm.execute_console(f'filter_stack add or')
                self.fm.notify(f'filter_stack add type {select}')
            else:
                self.fm.execute_console(f'filter_stack add name {select}')
                self.fm.execute_console(f'filter_stack add or')
                self.fm.notify(f'filter_stack add name {select}')
        else:
            select = self.fm.thisfile.basename
            file = pathlib.Path(str(select))
            select = ''.join(file.suffixes)
            self.fm.execute_console(f'filter {select}')
            self.fm.notify(f'filter {select}')
        return
