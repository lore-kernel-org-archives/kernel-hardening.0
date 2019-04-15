From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Mon, 15 Apr 2019 14:47:49 -0400
Message-ID: <3452959.b6JmBh7Lnt@x2>
In-Reply-To: <20181212144306.GA19945@quack2.suse.cz>
References: <20181212081712.32347-1-mic@digikod.net> <20181212081712.32347-2-mic@digikod.net> <20181212144306.GA19945@quack2.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: Jan Kara <jack@suse.cz>
Cc: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Matthew Bobrowski <mbobrowski@mbobrowski.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

On Wednesday, December 12, 2018 9:43:06 AM EDT Jan Kara wrote:
> On Wed 12-12-18 09:17:08, Micka=C3=ABl Sala=C3=BCn wrote:
> > When the O_MAYEXEC flag is passed, sys_open() may be subject to
> > additional restrictions depending on a security policy implemented by an
> > LSM through the inode_permission hook.
> >=20
> > The underlying idea is to be able to restrict scripts interpretation
> > according to a policy defined by the system administrator.  For this to
> > be possible, script interpreters must use the O_MAYEXEC flag
> > appropriately.  To be fully effective, these interpreters also need to
> > handle the other ways to execute code (for which the kernel can't help):
> > command line parameters (e.g., option -e for Perl), module loading
> > (e.g., option -m for Python), stdin, file sourcing, environment
> > variables, configuration files...  According to the threat model, it may
> > be acceptable to allow some script interpreters (e.g. Bash) to interpret
> > commands from stdin, may it be a TTY or a pipe, because it may not be
> > enough to (directly) perform syscalls.
> >=20
> > A simple security policy implementation is available in a following
> > patch for Yama.
> >=20
> > This is an updated subset of the patch initially written by Vincent
> > Strubel for CLIP OS:
> > https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb33=
0d
> > 6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch This patch has
> > been used for more than 10 years with customized script interpreters.=20
> > Some examples can be found here:
> > https://github.com/clipos-archive/clipos4_portage-overlay/search?q=3DO_=
MAYE
> > XEC
> >=20
> > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> > Reviewed-by: Philippe Tr=C3=A9buchet <philippe.trebuchet@ssi.gouv.fr>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.gouv.fr>
>=20
> ...
>=20
> > diff --git a/fs/open.c b/fs/open.c
> > index 0285ce7dbd51..75479b79a58f 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -974,6 +974,10 @@ static inline int build_open_flags(int flags,
> > umode_t mode, struct open_flags *o>=20
> >  	if (flags & O_APPEND)
> >  =09
> >  		acc_mode |=3D MAY_APPEND;
> >=20
> > +	/* Check execution permissions on open. */
> > +	if (flags & O_MAYEXEC)
> > +		acc_mode |=3D MAY_OPENEXEC;
> > +
> >=20
> >  	op->acc_mode =3D acc_mode;
> >  =09
> >  	op->intent =3D flags & O_PATH ? 0 : LOOKUP_OPEN;
>=20
> I don't feel experienced enough in security to tell whether we want this
> functionality or not. But if we do this, shouldn't we also set FMODE_EXEC
> on the resulting struct file? That way also security_file_open() can be
> used to arbitrate such executable opens and in particular
> fanotify permission event FAN_OPEN_EXEC will get properly generated which=
 I
> guess is desirable (support for it is sitting in my tree waiting for the
> merge window) - adding some audit people involved in FAN_OPEN_EXEC to CC.
> Just an idea...

Late in replying. But I think it's important to have a deep look into the=20
issue.

TL;DR - This is a gentle man's handshake. It won't _really_ solve the=20
problem.

This flag that is being proposed means that you would have to patch all=20
interpreters to use it. If you are sure that upstreams will accept that, wh=
y=20
not just change the policy to interpreters shouldn't execute anything unles=
s=20
the execute bit is set? That is simpler and doesn't need a kernel change. A=
nd=20
setting the execute bit is an auditable event.

The bottom line is that any interpreter has to become a security policy=20
enforcement point whether by indicating it wants to execute by setting a fl=
ag=20
or by refusing to use a file without execute bit set. But this just moves t=
he=20
problem to one that is harder to fix. Why in the world does any programming=
=20
language allow programs to be loaded via stdin?=20

It is possible to wget a program and pipe it into python which subsequently=
=20
pulls down an ELF shared object and runs it all without touching disk via=20
memfd_create (e.g. SnakeEater). This is all direct to memory execution. And=
=20
direct to memory bypasses anti-virus, selinux, IMA, application whitelistin=
g,=20
and other integrity schemes.

So, to fix this problem, you really need to not allow any programs to load =
via=20
stdin so that everything that executes has to touch disk. This way you can=
=20
get a fanotify event and see the application and vote yes/no on allowing it=
=2E=20
And this will be particularly harder with the memfd_create fix for the runc=
=20
container breakout. Prior to that, there were very few uses of that system=
=20
call. Now it may be very common which means finding malicious use just got=
=20
harder to spot.

But assuming these problems got fixed, then we have yet another place to lo=
ok.=20
Many interpreters allow you to specify a command to run via arguments. Some=
=20
have a small buffer and some allow lengthy programs to be entered as an=20
argument. One strategy might be that an attacker can bootstrap a lengthier=
=20
program across the network. Python for example allows loading modules acros=
s=20
a network. All you need to put in the commandline is the override for the=20
module loader and a couple modules to import. It then loads the modules=20
remotely. Getting rid of this hole will likely lead to some unhappy people =
=2D=20
meaning it can't be fixed.

And even if we get that fixed, we have one last hole to plug. Shells. One c=
an=20
simply start a shell and paste their program into the shell and then execut=
e=20
it. You can easily do this with bash or python or any language that has a=20
REPL (read=E2=80=93eval=E2=80=93print loop). To fix this means divorcing th=
e notion of a=20
language from a REPL. Production systems really do not need a Python shell,=
=20
they need the interpreter. I doubt that this would be popular. But fixing e=
ach=20
of these issues is what it would take to prevent unknown software from=20
running. Not going this far leaves holes.

Best Regards,
=2DSteve
