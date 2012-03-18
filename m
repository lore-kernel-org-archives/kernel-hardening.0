Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20120314185538.GB14172@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
 <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com>
 <20120314185510.GA14172@redhat.com> <20120314185538.GB14172@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2012 11:25:51 -0700
Message-ID: <CA+55aFzKc578eWYaq4+OaOM6hFjW+ePYCeC++_1p8f09YWV_hA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 1/1] CLONE_PARENT shouldn't allow to set ->exit_signal
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Djalal Harouni <tixxdz@opendz.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 14, 2012 at 11:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> + =A0 =A0 =A0 if (clone_flags & CLONE_THREAD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p->exit_signal =3D -1;
> + =A0 =A0 =A0 else if (clone_flags & CLONE_PARENT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p->exit_signal =3D current->group_leader->e=
xit_signal;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p->exit_signal =3D (clone_flags & CSIGNAL);

So why is it "current->group_leader->exit_signal" rather than the much
more logical (imho) and simpler "current->exit_signal"?

                      Linus
