Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 17:15:23 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Message-ID: <20160126171523.GA13715@ubuntumail>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <8737tp0zhr.fsf@x220.int.ebiederm.org>
 <CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
 <CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
 <CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
 <CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
 <87bn89sbc2.fsf@x220.int.ebiederm.org>
 <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
 <87zivtj5tv.fsf@x220.int.ebiederm.org>
 <CA+5PVA5Q0_sv5MsETa9u79MLOcYbsf-vdeEe3gdxgJ8f1KAbdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5Q0_sv5MsETa9u79MLOcYbsf-vdeEe3gdxgJ8f1KAbdQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER
 to be disabled
To: kernel-hardening@lists.openwall.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Josh Boyer (jwboyer@fedoraproject.org):
> On Mon, Jan 25, 2016 at 11:57 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > Kees Cook <keescook@chromium.org> writes:
> >
> >> On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman
> >> <ebiederm@xmission.com> wrote:
> >>> Kees Cook <keescook@chromium.org> writes:
> >>>>
> >>>> Well, I don't know about less weird, but it would leave a unneeded
> >>>> hole in the permission checks.
> >>>
> >>> To be clear the current patch has my:
> >>>
> >>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >>>
> >>> The code is buggy, and poorly thought through.  Your lack of interest in
> >>> fixing the bugs in your patch is distressing.
> >>
> >> I'm not sure where you see me having a "lack of interest". The
> >> existing cap-checking sysctls have a corner-case bug, which is
> >> orthogonal to this change.
> >
> > That certainly doesn't sound like you have any plans to change anything
> > there.
> >
> >>> So broken code, not willing to fix.  No. We are not merging this sysctl.
> >>
> >> I think you're jumping to conclusions. :)
> >
> > I think I am the maintainer.
> >
> > What you are proposing is very much something that is only of interst to
> > people who are not using user namespaces.  It is fatally flawed as
> > a way to avoid new attack surfaces for people who don't care as the
> > sysctl leaves user namespaces enabled by default.  It is fatally flawed
> > as remediation to recommend to people to change if a new user namespace
> > related but is discovered.  Any running process that happens to be
> > created while user namespace creation was enabled will continue to
> > exist.  Effectively a reboot will be required as part of a mitigation.
> > Many sysadmins will get that wrong.
> >
> > I can't possibly see your sysctl as proposed achieving it's goals.  A
> > person has to be entirely too aware of subtlety and nuance to use it
> > effectively.
> 
> What you're saying is true for the "oh crap" case of a new userns
> related CVE being found.  However, there is the case where sysadmins
> know for a fact that a set of machines should not allow user
> namespaces to be enabled.  Currently they have 2 choices, 1) use their

Hi - can you give a specific example of this?  (Where users really should
not be able to use them - not where they might not need them)  I think
it'll help the discussion tremendously.  Because so far the only good
arguments I've seen have been about actual bugs in the user namespaces,
which would not warrant a designed-in permanent disable switch.  If
there are good use cases where such a disable switch will always be
needed (and compiling out can't satisfy) that'd be helpful.

thanks,
-serge
