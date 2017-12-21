Message-ID: <1513884657.4599.16.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Thu, 21 Dec 2017 11:30:57 -0800
In-Reply-To: <20171221122141.10604612@lwn.net>
References: <1513718237-24140-1-git-send-email-me@tobin.cc>
	 <20171221122141.10604612@lwn.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 0/3] doc: update printk documentation
To: Jonathan Corbet <corbet@lwn.net>, "Tobin C. Harding" <me@tobin.cc>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-12-21 at 12:21 -0700, Jonathan Corbet wrote:
> On Wed, 20 Dec 2017 08:17:14 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > This set converts printk-formats.txt -> core-api/printk-formats.rst
> > 
> > We also update the documentation around printing kernel addresses.
[]
> >  - There's a dangling reference to printk-formats.txt in lib/vsprintf.c
>    that we'll want to fix up.

patch 1/3 updates that reference.
