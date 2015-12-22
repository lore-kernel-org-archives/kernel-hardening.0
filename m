Reply-To: kernel-hardening@lists.openwall.com
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
 <alpine.DEB.2.20.1512220952350.2114@east.gentwo.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <5679773B.6040903@intel.com>
Date: Tue, 22 Dec 2015 08:15:55 -0800
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1512220952350.2114@east.gentwo.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC][PATCH 0/7] Sanitization of slabs
 based on grsecurity/PaX
To: kernel-hardening@lists.openwall.com, Laura Abbott <laura@labbott.name>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12/22/2015 08:08 AM, Christoph Lameter wrote:
> 2. Add a mechanism that ensures that GFP_ZERO is set for each allocation.
>    That way every object you retrieve is zeroed and thus you have implied
>    sanitization. This also can be done in a rather simple way by changing
>    the  GFP_KERNEL etc constants to include __GFP_ZERO depending on a
>    Kconfig option. Or add some runtime setting of the gfp flags somewhere.

That's a more comprehensive barrier to leaking information than what we
have now, and it would _also_ cover a big chunk of normal
alloc_page()-style allocations which would be nice.

But, doing this on the allocation side is less comprehensive than doing
at free() time.  We (ideally) want to make sure that unallocated memory
at rest does not contain sensitive contents.

Also, the free path _tends_ to be a bit less performance-critical than
the allocation side.  For instance, I think we generally care about
fork() performance a lot more than exit(). :)
