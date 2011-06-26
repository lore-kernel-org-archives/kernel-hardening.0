Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 26 Jun 2011 12:39:15 +0200
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20110626103915.GB11093@elte.hu>
References: <20110623152137.GA2536@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623152137.GA2536@albatros>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-ID: <kernel-hardening.lists.openwall.com>


* Vasiliy Kulikov <segoon@openwall.com> wrote:

> This patch escapes control characters fed to printk() except '\n' and '\t'.
> 
> There are numerous printk() instances with user supplied input as "%s"
> data, and unprivileged user may craft log messages with substrings
> containing control characters via these printk()s.  Control characters
> might fool root viewing the logs via tty, e.g. using ^[1A to suppress
> the previous log line.
> 
> On the testing Samsung Q310 laptop there are no users of chars outside
> of the restricted charset. 
> 
> v2 - Allow chars with code >127.  Allow tabs.
> 
> Reported-by: Solar Designer <solar@openwall.com>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  kernel/printk.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> ---
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 3518539..727ff7d 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -41,6 +41,7 @@
>  #include <linux/cpu.h>
>  #include <linux/notifier.h>
>  #include <linux/rculist.h>
> +#include <linux/ctype.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -671,6 +672,20 @@ static void emit_log_char(char c)
>  		logged_chars++;
>  }
>  
> +static void emit_log_char_escaped(char c)
> +{
> +	char buffer[8];
> +	int i, len;
> +
> +	if (!iscntrl(c) || (c == '\n') || (c == '\t'))
> +		emit_log_char(c);
> +	else {
> +		len = sprintf(buffer, "#x%02x", c);
> +		for (i = 0; i < len; i++)
> +			emit_log_char(buffer[i]);
> +	}

Nit: please use balanced curly braces.

Also, i think it would be better to make this opt-out, i.e. exclude 
the handful of control characters that are harmful (such as backline 
and console escape), instead of trying to include the known-useful 
ones.

The whole non-ASCII-languages issue would not have happened if such 
an approach was taken.

It's also the better approach for the kernel: we handle known harmful 
things and are permissive otherwise.

Thanks,

	Ingo
