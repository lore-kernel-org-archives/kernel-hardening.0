Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20120311174953.GB2729@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
 <20120311174953.GB2729@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Mar 2012 11:02:35 -0700
Message-ID: <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: self_exec_id/parent_exec_id && CLONE_PARENT
To: Oleg Nesterov <oleg@redhat.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 10:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I am also asking because the change above looks like the fix to me.
> The child must not control its ->exit_signal, it is the parent who
> decides which signal the child should use for notification.
>
> And to me, clone(CLONE_PARENT | SIGXXX) looks like a violation of
> rule above.

SIGXXX is for doing things like AIO with threads, but it would never
be used together with CLONE_PARENT, that would be odd and wrong.

So I think we could disallow that - or at least try. See if anybody
notices, and if it breaks anything.

The rule about the Linux ABI is not that the ABI is set in stone. It's
that we can't break any existing binaries. And *maybe* there are users
of CLONE_PARENT and special signals, but it sounds unlikely and would
probably confuse real programs. So feel free to just try it (early in
the 3.4 merge window - not at this point, though).

                    Linus
