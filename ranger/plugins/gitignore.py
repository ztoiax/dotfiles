from ranger.api.commands import Command


class gitignore(Command):
    """
    useage:

    :gitignore
    :gitignore filename
    """
    def execute(self):
        if self.arg(1):
            file = self.arg(1)
        else:
            file = f'{self.fm.thisdir}/.gitignore'

        with open(file) as f:
            str1 = f.read()
        list1 = str1.split()

        for f in list1:
            if f[0] == '!':
                f = f.replace('*', '.*')
                f = f.strip('!/*')
                self.fm.execute_console(f'filter_stack add name {f}')
                self.fm.execute_console(f'filter_stack add or')
            else:
                f = f.replace('*', '.*')
                f = f.strip('!/*')
                self.fm.execute_console(f'filter_stack add name {f}')
                self.fm.execute_console(f'filter_stack add not')
