Date: Tue, 10 Oct 2017 08:27:19 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171009212719.GC12785@eros>
References: <1507517945-27155-1-git-send-email-me@tobin.cc>
 <20171009151609.xcfushhda2mfc3ff@smitten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009151609.xcfushhda2mfc3ff@smitten>
Subject: Re: [kernel-hardening] [PATCH] lib/vsprintf: add default case to 'i'
 specifier
To: Tycho Andersen <tycho@docker.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 09, 2017 at 09:16:09AM -0600, Tycho Andersen wrote:
> On Mon, Oct 09, 2017 at 01:59:05PM +1100, Tobin C. Harding wrote:
> > %pi leaks kernel addresses if incorrectly specified.
> > 
> > Currently the printk specifier %pi (%pI) contains a switch statement
> > without a default clause. The %pi specifier requires a subsequent
> > character (4, 6, or S) controlling the output. If the specifier is
> > incomplete the switch statement will fall through and print the variable
> > argument address in hex instead of the value of the argument (as an IP
> > address).
> > 
> > If uncaught this leaks kernel addresses into dmesg. We can return an
> > error string to make the bug visible and stop addresses leaking.
> > 
> > Add a default clause returning an error string, stops leaking addresses
> > and makes the buggy code
> 
> ...? :)
> 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
> >  lib/vsprintf.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index 86c3385b9eb3..155702f05b14 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -1775,6 +1775,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >  			default:
> >  				return string(buf, end, "(invalid address)", spec);
> >  			}}
> > +		default:
> 
> Maybe a WARN(1, "invalid pointer format")? That way it'll be easy for
> people to figure out where to fix.

Thanks for the review. vsprintf.c uses custom error return logic so as not to create a function call
cycle, I assume the printf versions of WARN call into vsprintf to do their formatting also. Hence
(and without studying the WARN code) I avoided the printf versions of WARN.

Open to correction if I am wrong.

thanks,
Tobin.
