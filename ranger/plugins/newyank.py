from ranger.api.commands import Command


class newyank(Command):
    """
    new yank command
    args dir | path | name | name_without_extension | context
    """

    def execute(self):
        import pyperclip
        from pathlib import Path
        path = str(self.fm.thisfile)
        p = Path(path)
        if self.rest(1) == 'dir':
            pyperclip.copy(str(p.parent))
            self.fm.notify('copy ' + str(p.parent))
        elif self.rest(1) == 'path':
            pyperclip.copy(str(p))
            self.fm.notify('copy ' + str(p))
        elif self.rest(1) == 'name':
            pyperclip.copy(p.name)
            self.fm.notify('copy ' + p.name)
        elif self.rest(1) == 'name_without_extension':
            pyperclip.copy(p.stem)
            self.fm.notify('copy ' + p.stem)
        elif self.rest(1) == 'context':
            with open(path, 'r') as file:
                context = file.read()
                pyperclip.copy(context)
            self.fm.notify('copy file context')
