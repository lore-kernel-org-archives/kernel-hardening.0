Date: Thu, 1 Jun 2017 22:24:32 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170601222432.6f593538@lxorguk.ukuu.org.uk>
In-Reply-To: <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
References: <20170529213800.29438-1-matt@nmatt.com>
	<20170529213800.29438-3-matt@nmatt.com>
	<20170529232640.16211960@alans-desktop>
	<CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
	<3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
	<0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
	<b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
	<e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
	<20170530132427.016053da@alans-desktop>
	<2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
	<20170530235106.11aab25c@alans-desktop>
	<3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
	<20170531005633.484a2e14@alans-desktop>
	<CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
	<20170601140812.583cf0a5@alans-desktop>
	<CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Kees Cook <keescook@chromium.org>
Cc: Matt Brown <matt@nmatt.com>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> There's a difference between "bugs" and "security bugs". Letting

Not really, it's merely a matter of severity of result. A non security
bug that hoses your hard disk is to anyone but security nutcases at
least as bad as a security hole.

> security bugs continue to get exploited because we want to flush out
> bugs seems insensitive to the people getting attacked. I'd rather
> protect against a class of bug than have to endless fix each bug.

The others are security bugs too to varying degree

> > I'm not against doing something to protect the container folks, but that
> > something as with Android is a whitelist of ioctls. And if we need to do
> > this with a kernel hook lets do it properly.
> >
> > Remember the namespace of the tty on creation
> > If the magic security flag is set then
> >         Apply a whitelist to *any* tty ioctl call where the ns doesn't
> >                 match
> >
> > and we might as well just take the Android whitelist since they've kindly
> > built it for us all!
> >
> > In the tty layer it ends up being something around 10 lines of code and
> > some other file somewhere in security/ that's just a switch or similar
> > with the whitelisted ioctl codes in it.
> >
> > That (or a similar SELinux ruleset) would actually fix the problem.
> > SELinux would be better because it can also apply the rules when doing
> > things like su/sudo/...  
> 
> Just to play devil's advocate, wouldn't such a system continue to not
> address your physical-console concerns? I wouldn't want to limit the

It would for the cases that a whitelist and container check covers -
because the whitelist wouldn't allow you to do anything but boring stuff
on the tty. TIOCSTI is just one of a whole range of differently stupid
and annoying opportunities. Containers do not and should not be able to
set the keymap, change the video mode, use console selection, make funny
beepy noises, access video I/O registers and all the other stuff like
that. Nothing is going to break if we have a fairly conservative
whitelist.

> protection to only containers (but it's a good start), since it
> wouldn't protect people not using containers that still have a
> privileged TTY attached badly somewhere.

How are you going to magically fix the problem. I'm not opposed to fixing
the real problem but right now it appears to be a product of wishful
thinking not programming. What's the piece of security code that
magically discerns the fact you are running something untrusted at the
other end of your tty. SELinux can do it via labelling but I don't see
any generic automatic way for the kernel to magically work out when to
whitelist and when not to. If there is a better magic rule than
differing-namespace then provide the code.

You can't just disable TIOCSTI, it has users deal with it. You can
get away with disabling it for namespace crossing I think but if you do
that you need to disable a pile of others.

(If it breaks containers blocking TIOCSTI then we need to have a good
look at algorithms for deciding when to flush the input queue on exiting
a container or somesuch)

> If you're talking about wholistic SELinux policy, sure, I could
> imagine a wholistic fix. But for the tons of people without a
> comprehensive SELinux policy, the proposed protection continues to
> make sense.

No it doesn't. It's completely useless unless you actually bother to
address the other exploit opportunities.

Right now the proposal is a hack to do 

	if (TIOCSTI && different_namespace && magic_flag)

the proper solution is

	if (!whitelisted(ioctl) && different_namespace && magic_flag)

The former is snake oil, the latter actually deals with the problem space
for namespaced stuff comprehensively and is only a tiny amount more code.

For non namespaced stuff it makes it no worse, if you don't allocate a
pty/tty pair properly then the gods are not going to magically save you
from on high sorry. And if you want to completely kill TIOCSTI even
though it's kind of pointless you can use seccomp.

We can make things a bit better for the non-namespaced cases by providing
a new ioctl that turns on/off whitelisting for that tty so that the
process can do

	ioctl(tty_fd, TIOCTRUST, &zero);
	execl("/home/foo/stupid-idea", "ooops", NULL);

that's a simple per tty flag and a trivial one condition extra check to
the test above. We do need some way to change it back however and that's
a bit trickier given we don't want the stupid-idea tool to be able to but
we do want the invoking shell to - maybe you have to be session leader ?

Alan
