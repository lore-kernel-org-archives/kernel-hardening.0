Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110712132723.GA3193@albatros>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros>
 <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
 <20110706185932.GB3299@albatros> <20110707075610.GA3411@albatros>
 <20110707081930.GA4393@albatros> <20110712132723.GA3193@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Jul 2011 14:16:10 -0700
Message-ID: <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 12, 2011 at 6:27 AM, Vasiliy Kulikov <segoon@openwall.com> wrot=
e:
>
> The NPROC can still be enforced in the common code flow of daemons
> spawning user processes. =A0Most of daemons do fork()+setuid()+execve().
> The check introduced in execve() enforces the same limit as in setuid()
> and doesn't create similar security issues.

Ok, this looks fine by me. I'd like to get some kind of comment from
the selinux etc people (James?) but I'd certainly be willing to take
this.

Failing when executing a suid application rather than when a suid
application releases its heightened credentials seems to be the
fundamentally saner approach. IOW, failing to raise privileges rather
than failing to lower them.

                   Linus
