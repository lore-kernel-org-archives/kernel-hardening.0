References: <be5b9100-4f60-1a10-6b32-b425cb2db05e@gmail.com>
 <CAGXu5jLM-NUZf71UzTHqRERAb6GZNO+Yi7OOrnDRuihv+m-pzw@mail.gmail.com>
From: zerons <zeronsaxm@gmail.com>
Message-ID: <68739881-43ab-c446-cf4f-e979f1820d82@gmail.com>
Date: Thu, 30 Nov 2017 12:00:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLM-NUZf71UzTHqRERAb6GZNO+Yi7OOrnDRuihv+m-pzw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] a part of SLAB_FREELIST_HARDENED feature
 doesn't work well
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Alexander Popov <alex.popov@linux.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 11/23/2017 01:31 AM, Kees Cook wrote:
> On Wed, Nov 22, 2017 at 6:33 AM, zerons <zeronsaxm@gmail.com> wrote:
>> (commit-webpage)[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce6fa91b93630396ca220c33dd38ffc62686d499]
>>
>> Test it on kernel 4.14.0.
>>
>> When something goes like
>> kfree(a);
>> kfree(a);
>> then `insmod` crashed 'Segment Fault'
>>
>> kfree(a);kfree(b);kfree(a);
>> Got nothing.
>>
>> I add another kernel thread, just free some objects
>> very close to the target object_a;
>> kfree(a);
>>                 another thread does some kfree(...)
>> kfree(a);
>> nothing happened, this patch didn't crash the `insmod` operation.
> 
> Yup, that's expected and that's why it's called "naive". It's a very
> cheap check for a somewhat common condition, but it is not designed to
> catch all double-free conditions. If you want that, try booting with
> "slub_debug=FZP" (this is slower, but should catch a lot of bad
> cases).
> 
> One thing to note is that the naive check works within a single cache,
> which means that kmalloc()/kfree() will be less likely to be protected
> by this due to the many concurrent users. Specific caches (via
> kmem_cache_alloc()kmem_cache_free()) may be more well protected by
> this since there may be less contention.
> 
> -Kees
> 
After a few days of testing, I found that SLAB_FREELIST_HARDENED could
do well in defending double-free-flaws-exploit, with xor obfuscation and
`prefetch_freepointer` which would check the next-next freelist valid if
the next object is not NULL.

Now, I wonder if it's possible that a thread does `kfree(a) kfree(a)` and
another thread does `kmalloc` and get `a` returned just before the second
`kfree`?

Thanks.
