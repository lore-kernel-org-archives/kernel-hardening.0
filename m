Date: Mon, 27 Nov 2017 02:14:41 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171127011441.GA15063@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Replying to kernel-hardening only, so we can consider the below thoughts
in a smaller group before bothering LKML:

On Wed, Nov 22, 2017 at 09:01:44AM +0100, Salvatore Mesoraca wrote:
> This patch-set introduces two separate features aimed at restricting
> dangerous open in world or group writable sticky directories.
> The purpose is to prevent exploitable bugs in user-space programs
> that don't access sticky directories in the proper way.
> The first patch prevents the O_CREAT open of FIFOs and regular files
> in world or group writable sticky directories, if they already exists
> and are owned by someone else.
> The second patch prevents O_CREAT open in world or group writable
> sticky when the O_EXCL flag is not set, even if the file doesn't
> exist yet.

When I suggested the O_CREAT-without-O_EXCL checks, I didn't mean you'd
try to introduce them at the same time with the restrictions on FIFOs
and regular files.  I think that bundling these together might be a
recipe for never getting any of them in, or for getting in the latter
with unnecessarily limited scope.  I think we need an optional policy
against O_CREAT-without-O_EXCL not only for sticky directories, but also
for other directories writable by other than the current fsuid - there
may be several levels or individual flags here.

So maybe unbundle these or at least avoid forever limiting them to
sticky directories (don't include "sticky" in the sysctl name).

Meanwhile, here's a scenario where I think the FIFO restrictions are
most obviously still worthwhile: attacks on system bootup scripts, where
the attacker would plant a FIFO on a persistent /tmp or the like and the
system would access it on next bootup.  The attacker's exploit program
would not yet be running during the bootup, so it wouldn't be able to
even try winning a race, but a FIFO would be able to keep the vulnerable
service (or its startup script, etc.) stuck until the attacker has
access again.  On the other hand, /tmp is commonly on tmpfs these days,
whereas some other shared writable directories (not necessarily world
writable and not necessarily sticky) are persistent (mail and cron job
spools, preformatted man page cache, etc.)  So maybe this, too, is a
reason to eventually extend these protections beyond sticky directories
(of course, only as an option).  We shouldn't using naming that would be
against such extension, or/and we shouldn't think of the
O_CREAT-without-O_EXCL checks as permanently only for extra detection
and reporting - they may also prevent more attacks if we eventually
extend them to non-sticky, but not (yet) similarly extent the file type
specific protections.

Alexander
