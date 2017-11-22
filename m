MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <be5b9100-4f60-1a10-6b32-b425cb2db05e@gmail.com>
References: <be5b9100-4f60-1a10-6b32-b425cb2db05e@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 22 Nov 2017 09:31:14 -0800
Message-ID: <CAGXu5jLM-NUZf71UzTHqRERAb6GZNO+Yi7OOrnDRuihv+m-pzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] a part of SLAB_FREELIST_HARDENED feature
 doesn't work well
To: zerons <zeronsaxm@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Alexander Popov <alex.popov@linux.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 22, 2017 at 6:33 AM, zerons <zeronsaxm@gmail.com> wrote:
> (commit-webpage)[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce6fa91b93630396ca220c33dd38ffc62686d499]
>
> Test it on kernel 4.14.0.
>
> When something goes like
> kfree(a);
> kfree(a);
> then `insmod` crashed 'Segment Fault'
>
> kfree(a);kfree(b);kfree(a);
> Got nothing.
>
> I add another kernel thread, just free some objects
> very close to the target object_a;
> kfree(a);
>                 another thread does some kfree(...)
> kfree(a);
> nothing happened, this patch didn't crash the `insmod` operation.

Yup, that's expected and that's why it's called "naive". It's a very
cheap check for a somewhat common condition, but it is not designed to
catch all double-free conditions. If you want that, try booting with
"slub_debug=FZP" (this is slower, but should catch a lot of bad
cases).

One thing to note is that the naive check works within a single cache,
which means that kmalloc()/kfree() will be less likely to be protected
by this due to the many concurrent users. Specific caches (via
kmem_cache_alloc()kmem_cache_free()) may be more well protected by
this since there may be less contention.

-Kees

-- 
Kees Cook
Pixel Security
