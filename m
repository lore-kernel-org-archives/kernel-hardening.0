Date: Thu, 21 Dec 2017 12:34:47 -0700
From: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20171221123447.3727a03b@lwn.net>
In-Reply-To: <1513884657.4599.16.camel@perches.com>
References: <1513718237-24140-1-git-send-email-me@tobin.cc>
	<20171221122141.10604612@lwn.net>
	<1513884657.4599.16.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v4 0/3] doc: update printk documentation
To: Joe Perches <joe@perches.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 21 Dec 2017 11:30:57 -0800
Joe Perches <joe@perches.com> wrote:

> > >  - There's a dangling reference to printk-formats.txt in lib/vsprintf.c  
> >    that we'll want to fix up.  
> 
> patch 1/3 updates that reference.

It updates one of them - there were two, one of which remains.  I'll just
toss in a patch to do that one too.

jon
