from ranger.api.commands import Command


class decompression(Command):
    '''
    decompression file or marked file:
    Usage: decompression
    '''
    def execute(self):
        # 解压脚本
        process = 'myx.sh'

        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        p =''
        for filename in marked_files:
            p += str(filename) + ' '
        self.fm.execute_command(f'{process} {p}')
        self.fm.notify(f'{process} {p}')
        return
