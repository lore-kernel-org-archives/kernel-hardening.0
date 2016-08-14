Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 14 Aug 2016 18:22:26 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20160814162226.GA7583@amd>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] Re: [PATCH] [RFC] Introduce mmap randomization
To: william.c.roberts@intel.com
Cc: jason@lakedaemon.net, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, keescook@chromium.org, gregkh@linuxfoundation.org, nnk@google.com, jeffv@google.com, salyzyn@android.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue 2016-07-26 11:22:26, william.c.roberts@intel.com wrote:
> From: William Roberts <william.c.roberts@intel.com>
> 
> This patch introduces the ability randomize mmap locations where the
> address is not requested, for instance when ld is allocating pages for
> shared libraries. It chooses to randomize based on the current
> personality for ASLR.
> 
> Currently, allocations are done sequentially within unmapped address
> space gaps. This may happen top down or bottom up depending on scheme.
> 
> For instance these mmap calls produce contiguous mappings:
> int size = getpagesize();
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40026000
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40027000
> 
> Note no gap between.
> 
> After patches:
> int size = getpagesize();
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x400b4000
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40055000
> 
> Note gap between.

Ok, I guess you can do it... but... what will be the effect on
available address space for a process? By doing this, won't you
fragment it horribly? This might be nasty on 32-bit systems...

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
