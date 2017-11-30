MIME-Version: 1.0
In-Reply-To: <20171127011441.GA15063@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <20171127011441.GA15063@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Thu, 30 Nov 2017 15:37:29 +0100
Message-ID: <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-27 2:14 GMT+01:00 Solar Designer <solar@openwall.com>:
> Replying to kernel-hardening only, so we can consider the below thoughts
> in a smaller group before bothering LKML:
>
> On Wed, Nov 22, 2017 at 09:01:44AM +0100, Salvatore Mesoraca wrote:
> > This patch-set introduces two separate features aimed at restricting
> > dangerous open in world or group writable sticky directories.
> > The purpose is to prevent exploitable bugs in user-space programs
> > that don't access sticky directories in the proper way.
> > The first patch prevents the O_CREAT open of FIFOs and regular files
> > in world or group writable sticky directories, if they already exists
> > and are owned by someone else.
> > The second patch prevents O_CREAT open in world or group writable
> > sticky when the O_EXCL flag is not set, even if the file doesn't
> > exist yet.
>
> When I suggested the O_CREAT-without-O_EXCL checks, I didn't mean you'd
> try to introduce them at the same time with the restrictions on FIFOs
> and regular files.  I think that bundling these together might be a
> recipe for never getting any of them in, or for getting in the latter
> with unnecessarily limited scope.

Yes, I think you are right. I'll split them.

> I think we need an optional policy
> against O_CREAT-without-O_EXCL not only for sticky directories, but also
> for other directories writable by other than the current fsuid - there
> may be several levels or individual flags here.
>
> So maybe unbundle these or at least avoid forever limiting them to
> sticky directories (don't include "sticky" in the sysctl name).

Actually I never liked that sysctl name :) I'll try to come up with something
less ugly and that doesn't include the "sticky" word.
If I implement something like what Matthew proposed[1] it will be easy to
extend scope and functionalities of this feature without complicating too much
the interface.

> Meanwhile, here's a scenario where I think the FIFO restrictions are
> most obviously still worthwhile: attacks on system bootup scripts, where
> the attacker would plant a FIFO on a persistent /tmp or the like and the
> system would access it on next bootup.  The attacker's exploit program
> would not yet be running during the bootup, so it wouldn't be able to
> even try winning a race, but a FIFO would be able to keep the vulnerable
> service (or its startup script, etc.) stuck until the attacker has
> access again.  On the other hand, /tmp is commonly on tmpfs these days,
> whereas some other shared writable directories (not necessarily world
> writable and not necessarily sticky) are persistent (mail and cron job
> spools, preformatted man page cache, etc.)  So maybe this, too, is a
> reason to eventually extend these protections beyond sticky directories
> (of course, only as an option).  We shouldn't using naming that would be
> against such extension, or/and we shouldn't think of the
> O_CREAT-without-O_EXCL checks as permanently only for extra detection
> and reporting - they may also prevent more attacks if we eventually
> extend them to non-sticky, but not (yet) similarly extent the file type
> specific protections.

So, are you suggesting that I should extend "O_CREAT-without-O_EXCL"
and "FIFOs restrictions" to work (optionally) on non-sticky directories too,
while leaving untouched (for the moment) "normal files restrictions"?
Thank you very much for you suggestions,

Salvatore


[1] https://lkml.org/lkml/2017/11/22/319
