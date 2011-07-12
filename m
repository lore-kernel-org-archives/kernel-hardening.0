Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2011 09:14:08 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110713091408.0d456352@notabene.brown>
In-Reply-To: <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
References: <20110612130953.GA3709@albatros>
	<20110706173631.GA5431@albatros>
	<CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
	<20110706185932.GB3299@albatros>
	<20110707075610.GA3411@albatros>
	<20110707081930.GA4393@albatros>
	<20110712132723.GA3193@albatros>
	<CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 12 Jul 2011 14:16:10 -0700 Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> On Tue, Jul 12, 2011 at 6:27 AM, Vasiliy Kulikov <segoon@openwall.com> wr=
ote:
> >
> > The NPROC can still be enforced in the common code flow of daemons
> > spawning user processes. =A0Most of daemons do fork()+setuid()+execve().
> > The check introduced in execve() enforces the same limit as in setuid()
> > and doesn't create similar security issues.
>=20
> Ok, this looks fine by me. I'd like to get some kind of comment from
> the selinux etc people (James?) but I'd certainly be willing to take
> this.
>=20
> Failing when executing a suid application rather than when a suid
> application releases its heightened credentials seems to be the
> fundamentally saner approach. IOW, failing to raise privileges rather
> than failing to lower them.
>=20
>                    Linus

I am happy with the patch in general - it adequately addresses the problem
which I fixed by adding the test to set_user which is now being removed.

However I don't think your characterisation is quite correct Linus.
There is no setuid application, and there is no raising of privileges.

The contrast is really "failing when trying to use reduced privileges is
safer than failing to reduce privileges - if the reduced privileges are not
available".

Note that there is room for a race that could have unintended consequences.

Between the 'setuid(ordinary-user)' and a subsequent 'exit()' after execve()
has failed, any other process owned by the same user (and we know where are
quite a few) would fail an execve() where it really should not.

I think it would be safer to add a test for PF_SUPERPRIV and PF_FORKNOEXEC
in current->flags and only fail the execve if both are set.
i.e.
    (current->flags & (PF_SUPERPRIV|PF_FORKNOEXEC)) =3D=3D (PF_SUPERPRIV|PF=
_FORKNOEXEC)

That should narrow it down to only failing in the particular case that we a=
re
interested in.

NeilBrown
