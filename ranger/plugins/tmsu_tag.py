from ranger.api.commands import Command

class tmsu_tag(Command):
    """:tmsu_tag

    Tags the current file with tmsu
    """

    def execute(self):
        cf = self.fm.thisfile

        self.fm.run("tmsu tag \"{0}\" {1}".format(cf.basename, self.rest(1)))
