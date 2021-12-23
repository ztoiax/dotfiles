from ranger.api.commands import Command
import os
from pathlib import Path
from datetime import datetime

class tmpfile(Command):
    ''' use mv file to /tmp instead of rm '''

    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()
        now = datetime.now()
        now = now.strftime("%Y-%m-%d:%H:%M:%S")

        for filename in marked_files:
            p = Path(f'{filename}')
            if os.path.exists(f'/tmp/{p.name}'):
                self.fm.execute_command(f'mv {filename} /tmp/{p.name}.{now}')
            else:
                self.fm.execute_command(f'mv {filename} /tmp')
        return


class trash(Command):
    ''' use trash command instead of rm '''

    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        for filename in marked_files:
            self.fm.execute_command(f'trash {filename}')
        return
