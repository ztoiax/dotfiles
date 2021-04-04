from ranger.api.commands import Command
from ranger.container.file import File


class nvim_file(Command):
    '''
    在已经启动的nvim打开文件,而不是新开一个nvim
    '''
    def execute(self):
        if self.arg(1):
            filename = self.rest(1)
        else:
            filename = str(self.fm.thisfile)

        from pynvim import attach

        try:
            nvim = attach('socket', path='/tmp/nvim')
        except :
            self.fm.notify('connect nvim error')
            self.fm.edit_file(filename)
            return

        from pathlib import Path
        p = Path(filename)
        if p.is_file():
            nvim.vars['filename'] = filename
            nvim.command('exe "edit " . g:filename')
            self.fm.notify(filename)
        else:
            self.fm.notify(filename + ' is not file')
        nvim.close
        return
