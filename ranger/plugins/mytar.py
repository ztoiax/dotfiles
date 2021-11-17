from ranger.api.commands import Command


class compression(Command):
    '''
    compression file or dir:
    Usage: compression file.tar.gz
    '''
    def execute(self):
        if not self.arg(1):
            self.fm.notify('compression file.tar.gz')
            return

        # 压缩脚本
        process = 'mytar.sh'

        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        p =''
        for filename in marked_files:
            p += str(filename) + ' '
        self.fm.execute_command(f'{process} {self.arg(1)} {p}')
        return
