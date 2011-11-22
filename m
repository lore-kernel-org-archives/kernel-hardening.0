Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 22 Nov 2011 14:07:03 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111122100703.GA3856@albatros>
References: <20111119110126.GA11468@albatros>
 <20111121163407.d8946ad8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121163407.d8946ad8.akpm@linux-foundation.org>
Subject: [kernel-hardening] Re: [RFC v2 1/3] procfs: parse mount options
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Andrew,

On Mon, Nov 21, 2011 at 16:34 -0800, Andrew Morton wrote:
> On Sat, 19 Nov 2011 15:01:26 +0400
> Vasiliy Kulikov <segooon@gmail.com> wrote:
> 
> > This patch adds support of procfs mount options.
> > Actual mount options are coming in the next patches.
> 
> The patches look sane to me.

Thank you for the review!


> I assume that `mount -o remount' has been tested and works as expected?

Yes.


> I also assume that any file which was opened prior to the remount will
> remain accessible to any process which has the fd.  Is this acceptable
> from a security/operational POV?

No, currently this "check permissions on open()" is violated at least in
getattr().  On each access the full permission checking is done.

It is trivial to fix (by moving hide_pid to inode), but does it worth it?
I see the scheme is totally constant during the system lifetime, i.e.
procfs policy is defined during the boot in boot mount scripts and is not
changed during the system lifetime at all.  I see it as an ability to
define different policies on per-container basis, but not a "change it
from time to time" thing.

If anybody see the case where it makes sense, I'll move hide_pid to
inode.


FWIW, in grsecurity it is a CONFIG_ option and there is no such problem
at all. :-)

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
