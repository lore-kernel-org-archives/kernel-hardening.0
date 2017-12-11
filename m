MIME-Version: 1.0
In-Reply-To: <20171207214737.GA8344@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122165144.07aea7ac@alans-desktop>
 <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com> <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com>
 <20171127002641.GA14743@openwall.com> <CAJHCu1+yjSCReBGG4=K2Kx-iTjVxbSTqacM9bNVPNdg74pGoow@mail.gmail.com>
 <1512053826.26048.8.camel@hellion.org.uk> <20171130163006.GA2391@openwall.com>
 <CAJHCu1KkTevQNoVZF0qTVfUzJbWmQsegHkVZSEpbJZAZhNdoew@mail.gmail.com> <20171207214737.GA8344@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 11 Dec 2017 13:08:46 +0100
Message-ID: <CAJHCu1LYLNMgMth-xFWEQevFpxHuz+QUb+Bj6eskr8gxu+hXUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: Solar Designer <solar@openwall.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, David Laight <David.Laight@aculab.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Karel Zak <kzak@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-12-07 22:47 GMT+01:00 Solar Designer <solar@openwall.com>:
> On Tue, Dec 05, 2017 at 11:21:00AM +0100, Salvatore Mesoraca wrote:
> > 2017-11-30 17:30 GMT+01:00 Solar Designer <solar@openwall.com>:
> > > $ strace flock /tmp/lockfile -c cat
> > > [...]
> > > open("/tmp/lockfile", O_RDONLY|O_CREAT|O_NOCTTY, 0666) = 3
> > > flock(3, LOCK_EX)                       = 0
> > >
> > > This use of flock(1) would be a worse vulnerability, not limited to DoS
> > > against the script itself but also allowing for privilege escalation
> > > unless (sym)link restrictions are enabled in the kernel.  Adding O_EXCL
> > > would help (reduce the impact back to DoS against itself), and would
> > > require that the retry logic (like what is seen in the lock directory
> > > example above) be present.
>
> > > > That behavior can be certainly avoided, but of course it isn't a
> > > > security problem per se.
> > >
> > > I think it is a security problem per se, except in the "subtle case"
> > > above, and it's great that our proposed policy would catch it.
> >
> > I agree on the DoS, though, at first, I didn't consider it a "bug" because
> > there isn't any open mode that can prevent the DoS in this case.
> > If you want to avoid it, you must avoid other-users-writable directories
> > at all. So, It think that, if you are using a sticky directory, it's
> > intended behavior to let someone else "lock" you.
>
> Right.  There's a worse DoS I had overlooked, though: flock(1) can also
> be made to create and/or lock another file (maybe in another directory).
> Perhaps adding O_NOFOLLOW (alongside flock(1)'s existing use of
> O_NOCTTY) would be a good idea, even though uses in a directory writable
> by someone else are inherently risky anyway.
>
> > But maybe many flock(1) users are not aware of the issue and so, sometimes,
> > it can be unintended.
> > I didn't consider privilege escalation as an issue because I always
> > looked at flock(1) under the assumption that the lockfile is never actually
> > read or modified in any way and so it shouldn't make too much difference if
> > it's an already existing regular file or a symlink etc.
> > Am I missing something?
>
> You made a good point, but yes: O_CREAT will follow a dangling symlink
> and there are cases where creating an empty file of an attacker-chosen
> pathname may allow for privilege escalation.  For example, crontab(1)
> man page on RHEL7 says regarding /etc/cron.allow and /etc/cron.deny:
>
> "If neither of these files exists, only the super user is allowed to
> use cron."
>
> In that configuration, simply creating empty /etc/cron.deny grants
> access to crontab(1) to all users.  As user:
>
> $ crontab -l
> You (solar) are not allowed to use this program (crontab)
> See crontab(1) for more information
> $ ln -s /etc/cron.deny /tmp/lockfile
>
> As root:
>
> # sysctl -w fs.protected_symlinks=0
> fs.protected_symlinks = 0
> # flock /tmp/lockfile -c echo
>
> As user:
>
> $ crontab -l
> no crontab for solar

Ah, right. I didn't think of it.

> There may also be side-effects on open of device files (the best known
> example is rewinding a tape), and we won't avoid those by retrying
> without O_CREAT|O_EXCL.  O_NOFOLLOW will help against symlinks to device
> files, but not against hard links (if on same device).  The kernel's
> symlink and hardlink protections help, but in this sub-thread we were
> discussing detecting userspace software issues without waiting for an
> attack.  Things like this fit David Laight's point well: programs trying
> to make risky (mis)uses less risky sometimes also avoid being detected
> by our proposed policy.  That's life.

Yes, unfortunately some bad behaviors will go unnoticed. But many others won't,
so I thinks this is still a useful feature to have.

Salvatore
