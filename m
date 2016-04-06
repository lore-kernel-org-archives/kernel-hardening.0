Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Apr 2016 13:54:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20160406205429.GA13901@kroah.com>
References: <1459971348-81477-1-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1459971348-81477-1-git-send-email-thgarnie@google.com>
Subject: Re: [kernel-hardening] [RFC v1] mm: SLAB freelist randomization
To: kernel-hardening@lists.openwall.com
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, gthelen@google.com, keescook@chromium.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, labbott@fedoraproject.org, Thomas Garnier <thgarnie@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 06, 2016 at 12:35:48PM -0700, Thomas Garnier wrote:
> Provide an optional config (CONFIG_FREELIST_RANDOM) to randomize the
> SLAB freelist. This security feature reduces the predictability of
> the kernel slab allocator against heap overflows.
> 
> Randomized lists are pre-computed using a Fisher-Yates shuffle and
> re-used on slab creation for performance.
> ---
> Based on next-20160405
> ---

No signed-off-by:?
