Date: Mon, 18 Dec 2017 10:56:42 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171217235642.GX2191@eros>
References: <1513549807-20287-1-git-send-email-me@tobin.cc>
 <1513550065.31581.39.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513550065.31581.39.camel@perches.com>
Subject: [kernel-hardening] Re: [PATCH v2 0/3] doc: update printk documentation
To: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 17, 2017 at 02:34:25PM -0800, Joe Perches wrote:
> On Mon, 2017-12-18 at 09:30 +1100, Tobin C. Harding wrote:
> > This set converts printk-formats.txt -> core-api/printk-formats.rst
> > 
> > We also update the documentation around printing kernel addresses.
> 
> Please also update the comment in lib/vsprintf.c
> 
>  * ** Please update also Documentation/printk-formats.txt when making changes **
> 
> > I'd like to get it _realy_ correct so that future
> 
> sp: realy->really
> 

Damn emphasis plays havoc with the spell checker. I do believe you have
made this comment before Joe ;) I'll learn to spell one day.

Will fix as suggested and re-spin.

thanks,
Tobin
