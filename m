Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 2 Jan 2013 23:06:34 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20130102190634.GA18462@cachalot>
References: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
 <20130102183351.GA28554@kroah.com>
 <CAGXu5jJ1oGh-ExwQ6f0CMNQjF2cAcLrgWRCz8ho0v4Ve+GjOuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ1oGh-ExwQ6f0CMNQjF2cAcLrgWRCz8ho0v4Ve+GjOuw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] debugfs: convert gid= argument from decimal, not octal
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Reisner <dreisner@archlinux.org>, LKML <linux-kernel@vgen.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

(CC'ed kernel-hardening ML)

On Wed, Jan 02, 2013 at 10:42 -0800, Kees Cook wrote:
> On Wed, Jan 2, 2013 at 10:33 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jan 02, 2013 at 08:54:37AM -0500, Dave Reisner wrote:
> >> This patch technically breaks userspace, but I suspect that anyone who
> >> actually used this flag would have encountered this brokenness, declared
> >> it lunacy, and already sent a patch.
> >
> > Kees is the one that originally did this change (I think, right?)
> 
> I recommended the default change, but I think it was Vasiliy that
> added the gid option, IIRC.

Wow.  It was not me :-)  IIRC, I haven't proposed debugfs uid/gid stuff
after Greg NACK'ed my sysfs uid/gid/umask mount options patch.  IIRC,
there were talks that debugfs must not be mounted on production systems
because it exists for debug reasons only, so no additional security
settings are needed.

My version of the patch (which was not posted on LKML):

http://www.openwall.com/lists/kernel-hardening/2011/06/05/4 (FWIW, it doesn't contain the bug in question.)

> 
> > Kees, any objection to this patch?  Will it break your existing systems?
> 
> Regardless, I have no objection -- this should be int, not octal.

No objection.  GID should be decimal.

> -Kees
> 
> >
> > thanks,
> >
> > greg k-h
> >
> >>
> >> Signed-off-by: Dave Reisner <dreisner@archlinux.org>

Reviewed-by: Vasiliy Kulikov <segoon@openwall.com>

> >> ---
> >>  fs/debugfs/inode.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
