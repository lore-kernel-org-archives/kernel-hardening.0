Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 1 May 2014 08:06:02 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20140501040602.GA24961@openwall.com>
References: <20140430150844.GA10621@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430150844.GA10621@mwanda>
Subject: [kernel-hardening] Re: [patch] lib: check for strcpy() overflows to fixed length buffers
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 30, 2014 at 06:08:44PM +0300, Dan Carpenter wrote:
> There are sometimes where we know that we are doing an strcpy() into a
> fixed length buffer.  In those cases, we could verify that the strcpy()
> doesn't overflow.  This patch introduces DEBUG_STRICT_SLOW_STRCPY_CHECKS
> if you want to check for that.

FWIW, I had posted similar macros for userland strcpy() and friends to
the security-audit list (now defunct) in 1998.  Someone preserved a copy
here (although the indentation is lost):

http://www.opennet.ru/soft/0432.html

In (weird) use, with proper indentation:

http://www.merit.edu/mail.archives/nanog/2000-02/msg00366.html
https://github.com/tureba/trinoo/blob/master/strfix.h

Personally, I was using this at the time for building known-broken
software like wu-ftpd, where the risk of false positives felt lower than
the risk of buffer overflow bugs being in fact present in the code.

I used gcc's Statement Exprs extension, which is also used in the Linux
kernel a lot:

http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html

So maybe you should, too.  (That is, if you want to go ahead with this
approach for code that isn't meant to be as broken as wu-ftpd was.)
This lets us propagate the original return value.

To determine the destination buffer size, I simply used sizeof() and
skipped my added protection in case the size looked like that of a
pointer.  Now you have those nice new gcc features instead. :-)

> The downside is that it makes strcpy slower.

I guess the slowdown is mostly from the added strlen().  I avoided it by
using strncat(), so I had truncation instead of detection.  It is
unclear which is better.

Other functions I did this for are strcat(), sprintf(), vsprintf().

Alexander
