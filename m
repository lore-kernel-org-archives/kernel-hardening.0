Message-ID: <1497931790.11009.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 20 Jun 2017 00:09:50 -0400
In-Reply-To: <1497915397-93805-24-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
	 <1497915397-93805-24-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 23/23] mm: Allow slab_nomerge to be
 set at build time
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-06-19 at 16:36 -0700, Kees Cook wrote:
> Some hardened environments want to build kernels with slab_nomerge
> already set (so that they do not depend on remembering to set the
> kernel
> command line option). This is desired to reduce the risk of kernel
> heap
> overflows being able to overwrite objects from merged caches,
> increasing
> the difficulty of these attacks. By keeping caches unmerged, these
> kinds
> of exploits can usually only damage objects in the same cache (though
> the
> risk to metadata exploitation is unchanged).

It also further fragments the ability to influence slab cache layout,
i.e. primitives to do things like filling up slabs to set things up for
an exploit might not be able to deal with the target slabs anymore. It
doesn't need to be mentioned but it's something to think about too. In
theory, disabling merging can make it *easier* to get the right layout
too if there was some annoyance that's now split away. It's definitely a
lot more good than bad for security though, but allocator changes have
subtle impact on exploitation. This can make caches more deterministic.
