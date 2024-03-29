from ranger.api.commands import Command

class edit_file(Command):
    '''
    English: if editor is exists then open file, else open file after start editor
    Chinese: 使用已经启动的editor打开文件,如果editor没有启动,则启动后再打开

    use neovim open file:
    Usage: edit_file

    use vscode open file:
    Usage: edit_file code
    '''
    def execute(self):
        if self.arg(1) == 'code':
            editor = 'code -g'
            self.fm.notify('use vscode')
        else:
            # editor = 'nvr'
            editor = 'nvim --server /tmp/nvim.pipe --remote '
            self.fm.notify('use neovim')

        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        p =''
        for filename in marked_files:
            p += str(filename) + ' '

        self.fm.execute_command(f'{editor} {p}')
        return
