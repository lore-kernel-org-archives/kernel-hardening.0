Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 07:38:52 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Message-ID: <20160126073852.GC6652@ubuntumail>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <8737tp0zhr.fsf@x220.int.ebiederm.org>
 <CAGXu5jLzjqzp0WFT=NNuSqOEFzu7u7z8p+x9nouwS9ptaca8qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLzjqzp0WFT=NNuSqOEFzu7u7z8p+x9nouwS9ptaca8qQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER
 to be disabled
To: kernel-hardening@lists.openwall.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Kees Cook (keescook@chromium.org):
> On Fri, Jan 22, 2016 at 7:02 PM, Eric W. Biederman
> > So I have concerns about both efficacy and usability with the proposed
> > sysctl.
> 
> Two distros already have this sysctl because it was so strongly
> requested by their users. This needs to be upstream so we can manage
> the effects correctly.

Which two distros?  Was it in fact requested by their users?

My opinion remains that long-term this is a bad thing.  If we're going to
have this upstream, it should be clearly marked so as to be easily
removable at some point down the road.  Userspace that cannot count on a
feature (in the best case) won't use it or (much worse) will fall back
to broken behavior in one case or the other.
