Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
Date: Wed, 05 Oct 2016 22:52:39 +0200
In-Reply-To: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
	(william c. roberts's message of "Wed, 5 Oct 2016 14:04:46 -0400")
Message-ID: <87eg3umsbs.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: william.c.roberts@intel.com
Cc: kernel-hardening@lists.openwall.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 05 2016, william.c.roberts@intel.com wrote:

> From: William Roberts <william.c.roberts@intel.com>
>
> Some out-of-tree modules do not use %pK and just use %p, as it's
> the common C paradigm for printing pointers. Because of this,
> kptr_restrict has no affect on the output and thus, no way to
> contain the kernel address leak.
>
> Introduce kptr_restrict level 3 that causes the kernel to
> treat %p as if it was %pK and thus always prints zeros.
>
> Sample Output:
> kptr_restrict == 2:
> p: 00000000604369f4
> pK: 0000000000000000
>
> kptr_restrict == 3:
> p: 0000000000000000
> pK: 0000000000000000
>
> Signed-off-by: William Roberts <william.c.roberts@intel.com>
> ---
>  Documentation/sysctl/kernel.txt |   3 ++
>  kernel/sysctl.c                 |   3 +-
>  lib/vsprintf.c                  | 107 ++++++++++++++++++++++++----------------

That's a lot of changed lines. Why isn't this just

--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1719,6 +1719,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
        case 'G':
                return flags_string(buf, end, ptr, fmt);
        }
+       if (kptr_restrict == 3)
+               ptr = NULL;
        spec.flags |= SMALL;
        if (spec.field_width == -1) {
                spec.field_width = default_width;

?
