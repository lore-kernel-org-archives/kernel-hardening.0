Date: Tue, 19 Dec 2017 11:28:11 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171219002811.GG19604@eros>
References: <1513636145-30033-1-git-send-email-me@tobin.cc>
 <1513636145-30033-3-git-send-email-me@tobin.cc>
 <064efc24-fff2-0a3b-b7af-b64d53400fc0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <064efc24-fff2-0a3b-b7af-b64d53400fc0@infradead.org>
Subject: [kernel-hardening] Re: [PATCH v3 2/3] doc: update kpt_restrict documentation
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 18, 2017 at 03:50:06PM -0800, Randy Dunlap wrote:
> On 12/18/2017 02:29 PM, Tobin C. Harding wrote:
> > Recently the behaviour of printk specifier %pK was changed. The
> > documentation does not currently mirror this.
> > 
> > Update documentation for sysctl kpt_restrict.
> 
> Fix subject and here ............ ^^^^^^^^^^^^.

Oh thanks. Took quite a few minutes of staring to see the mistake ;)

Will fix and re-spin.

thanks,
Tobin.
