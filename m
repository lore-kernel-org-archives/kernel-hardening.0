Message-ID: <1486770571.2192.36.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 10 Feb 2017 15:49:31 -0800
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305DB22@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305DB22@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, Andew Morton <akpm@linux-foundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Julia Lawall <julia.lawall@lip6.fr>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

(adding Emese Revfy and Julia Lawall)

On Fri, 2017-02-10 at 23:31 +0000, Roberts, William C wrote:
> The problem starts to get hairy when we think of how often folks roll their own logging macros (see some small sampling at the end).
> 
> I think we would want to add DEBUG DBG and sn?printf and maybe consider dropping the \b on the regex so it's a bit more matchy but still shouldn't
> end up matching on any ASM as you pointed out in the V2 nack.
> 
> Ill break this down into:
> 1. the patch as I know you'll take it, as you wrote it :-P
> 2. Adding to the logging macros
> 3. exploring making it less matchy

checkpatch is a line-oriented bunch of regexes
and doesn't know what is a __printf format.

It won't ever be "perfect" for this sort of
format verification checking.

Another way to do this is to write a gcc compiler
plugin that verifies the %p<foo> format types and
emits a warning/error.

That's probably the "best" solution.

Maybe coccinelle could help too.
