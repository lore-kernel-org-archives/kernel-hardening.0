Reply-To: kernel-hardening@lists.openwall.com
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <8737tp0zhr.fsf@x220.int.ebiederm.org>
 <CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
 <CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
 <CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
 <CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
 <87bn89sbc2.fsf@x220.int.ebiederm.org>
 <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
 <87zivtj5tv.fsf@x220.int.ebiederm.org>
 <20160128085655.GA9955@mail.hallyn.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AA0F62.7090905@gmail.com>
Date: Thu, 28 Jan 2016 07:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <20160128085655.GA9955@mail.hallyn.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?Q?Robert_=c5=9awi=c4=99cki?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2016-01-28 03:56, Serge E. Hallyn wrote:
> On Mon, Jan 25, 2016 at 10:57:32PM -0600, Eric W. Biederman wrote:
>> What sounds like a generally useful feature that would cover your use
>> case and many others is a per user limit on the number of user
>> namespaces users may create.
>
> Ok, I'm sorry, but after thinking about this quite awhile, I think this
> is a bad idea.  If I'm allowed to create exactly one, then (a) I won't
> be able to run two instances of chrome (does chrome use one userns per
> tab or per application?), yet (b) i can easily just not use chrome and
> use my allocation to run a vulnerability.
Ignore regular users WRT the ability to limit to one or two namespace 
instances, the advantage of being able to limit to one or two user 
namespaces for a given user is that it prevents daemons that use it for 
sand-boxing from being exploited to create more.  If we go with Eric's 
suggestion, there is absolutely no reason on a regular desktop system 
that the users used for a graphical login would have to be limited.
>
> IMO, having a (hopefully temporary, so cleanly separated out) sysctl,
> which perhaps goes so far as to kill all non-init user namespaces when
> set to -1, makes the most sense.  I still think the harm due to having
> userspace not being able to rely on user namespaces will, long term, be
> worse than the security implications of having user namespaces always
> enabled.
Userspace can't rely on them as it is right now.  The default kernel 
config has them disabled, and a number of distros are refusing to ship 
kernels with them enabled at least in the short term, wheras a number 
are only shipping kernels with them enabled (I'd be willing to bet that 
part of what prompted this originally was Chrome).  Just by virtue of 
this, you can't rely on them being there and need to gracefully handle 
the situation if they aren't.  Adding a sysctl allowing them to be 
disabled completely on a kernel that has support built in would not make 
them all that much more unreliable than they already are.
