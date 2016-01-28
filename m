Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 28 Jan 2016 02:56:55 -0600
From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Message-ID: <20160128085655.GA9955@mail.hallyn.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <8737tp0zhr.fsf@x220.int.ebiederm.org>
 <CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
 <CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
 <CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
 <CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
 <87bn89sbc2.fsf@x220.int.ebiederm.org>
 <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
 <87zivtj5tv.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zivtj5tv.fsf@x220.int.ebiederm.org>
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER
 to be disabled
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 25, 2016 at 10:57:32PM -0600, Eric W. Biederman wrote:
> What sounds like a generally useful feature that would cover your use
> case and many others is a per user limit on the number of user
> namespaces users may create.

Ok, I'm sorry, but after thinking about this quite awhile, I think this
is a bad idea.  If I'm allowed to create exactly one, then (a) I won't
be able to run two instances of chrome (does chrome use one userns per
tab or per application?), yet (b) i can easily just not use chrome and
use my allocation to run a vulnerability.

IMO, having a (hopefully temporary, so cleanly separated out) sysctl,
which perhaps goes so far as to kill all non-init user namespaces when
set to -1, makes the most sense.  I still think the harm due to having
userspace not being able to rely on user namespaces will, long term, be
worse than the security implications of having user namespaces always
enabled.
