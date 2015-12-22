Reply-To: kernel-hardening@lists.openwall.com
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
 <1450755641-7856-7-git-send-email-laura@labbott.name>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <567964F3.2020402@intel.com>
Date: Tue, 22 Dec 2015 06:57:55 -0800
MIME-Version: 1.0
In-Reply-To: <1450755641-7856-7-git-send-email-laura@labbott.name>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: kernel-hardening@lists.openwall.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <laura@labbott.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12/21/2015 07:40 PM, Laura Abbott wrote:
> +	  The tradeoff is performance impact. The noticible impact can vary
> +	  and you are advised to test this feature on your expected workload
> +	  before deploying it

What if instead of writing SLAB_MEMORY_SANITIZE_VALUE, we wrote 0's?
That still destroys the information, but it has the positive effect of
allowing a kzalloc() call to avoid zeroing the slab object.  It might
mitigate some of the performance impact.

If this is on at compile time, but booted with sanitize_slab=off, is
there a performance impact?
