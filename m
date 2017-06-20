Date: Mon, 19 Jun 2017 21:04:03 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170620040403.GA610@zzz.localdomain>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
 <1497915397-93805-22-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497915397-93805-22-git-send-email-keescook@chromium.org>
Subject: Re: [kernel-hardening] [PATCH 21/23] usercopy: Restrict non-usercopy
 caches to size 0
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi David + Kees,

On Mon, Jun 19, 2017 at 04:36:35PM -0700, Kees Cook wrote:
> With all known usercopied cache whitelists now defined in the kernel, switch
> the default usercopy region of kmem_cache_create() to size 0. Any new caches
> with usercopy regions will now need to use kmem_cache_create_usercopy()
> instead of kmem_cache_create().
> 

While I'd certainly like to see the caches be whitelisted, it needs to be made
very clear that it's being done (the cover letter for this series falsely claims
that kmem_cache_create() is unchanged) and what the consequences are.  Is there
any specific plan for identifying caches that were missed?  If it's expected for
people to just fix them as they are found, then they need to be helped a little
--- at the very least by putting a big comment above report_usercopy() that
explains the possible reasons why the error might have triggered and what to do
about it.

- Eric
