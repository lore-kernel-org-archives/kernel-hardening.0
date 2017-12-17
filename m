Message-ID: <1513550065.31581.39.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Sun, 17 Dec 2017 14:34:25 -0800
In-Reply-To: <1513549807-20287-1-git-send-email-me@tobin.cc>
References: <1513549807-20287-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 0/3] doc: update printk documentation
To: "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-12-18 at 09:30 +1100, Tobin C. Harding wrote:
> This set converts printk-formats.txt -> core-api/printk-formats.rst
> 
> We also update the documentation around printing kernel addresses.

Please also update the comment in lib/vsprintf.c

 * ** Please update also Documentation/printk-formats.txt when making changes **

> I'd like to get it _realy_ correct so that future

sp: realy->really
