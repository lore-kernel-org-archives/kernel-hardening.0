Date: Tue, 21 Feb 2017 13:58:07 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170221135807.GC8605@leverpostej>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-3-git-send-email-hoeun.ryu@gmail.com>
 <20170220103008.GC9003@leverpostej>
 <BD3E52DE-98B0-4DC0-8DCB-540599FC876C@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BD3E52DE-98B0-4DC0-8DCB-540599FC876C@gmail.com>
Subject: Re: [kernel-hardening] [RFC 3/7] module: modify memory attrs for
 __ro_mostly_after_init during module_init/exit
To: Ho-Eun Ryu <hoeun.ryu@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 21, 2017 at 10:36:05PM +0900, Ho-Eun Ryu wrote:
> > On 20 Feb 2017, at 7:30 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Sun, Feb 19, 2017 at 07:04:06PM +0900, Hoeun Ryu wrote:

> >> @@ -3396,8 +3399,11 @@ static noinline int do_init_module(struct module *mod)
> >> 
> >> 	do_mod_ctors(mod);
> >> 	/* Start the module */
> >> -	if (mod->init != NULL)
> >> +	if (mod->init != NULL) {
> >> +		set_ro_mostly_after_init_rw();
> >> 		ret = do_one_initcall(mod->init);
> >> +		set_ro_mostly_after_init_ro();
> >> +	}
> > 
> > This looks very much like the pax_{open,close}_kernel() approach for
> > write-rarely data.
> 
> I read the discussion [1] and I agree that __ro_mostly_after_init marker
> looks very similar to __write_rarely. 
> 
> > I think it would be better to implement a first class write-rarely
> > mechanism rather than trying to extend __ro_after_init to cover this
> > case.
> 
> I’m not extending __ro_after_init. __ro_mostly_after_init resides in
> the same section of rodata though.

Sorry; I was confused when I wrote that email. I now understand that
you're adding a separate annotation.

> > As mentioned previously, I *think* we can have a generic implementation
> > that uses an mm to temporarily map a (thread/cpu-local) RW alias of the
> > data in question in what would otherwise be the user half of the address
> > space. Regardless, we can have a generic interface [1] that can cater
> > for that style of approach and/or something like ARM's domains or x86's
> > pkeys.
> > 
> 
> I’m still learning cpu/kernel architectures, It would be very thankful if you tell me more about the detail of the implementation itself.
> 
> The mm that maps temporary RW alias is like
>     * special mm like idmap/init_mm which have its own page tables?
>     * the page tables have the same content of page tables of
>       init_mm’s swapper_pg_dir except for RW permissions for a
>       specific section (let’s say __write_rarely)

This would be a special mm, like a user mm, that only mapped the
relevant VA(s).

That might map the relevant variable on-demand, or the mapping could
cover the whole write_rarely area.

>     * then use switch_mm(special_rw_mm) to change the address space
>       before the access happens to the section
>     * then use switch_mm(current->mm) to change the address space to
>       original after the access is done

Yes.

> And the interface itself. rare_write(__val, __val), is it a single
> value access interface.
> I’m intending to make data in __ro_mostly_after_init section RW during
> multiple accesses like during module_init/exit.
> and __rare_rw_map()/unmap() used in rare_write() seems to work like
> open/close api.

The __rare_rw_{map,unmap}() functions would map in the RW alias, but do
not necessarily change the RO alias to RW. This is why __rare_rw_ptr()
would be necessary, and is the major difference to the open/close API.

We could certainly allow several writes between a map/unmap. The key
requirement is that each write is instrumented so that it goes via the
RW alias.

> How could __rare_rw_ptr() be implemented and what happens when
> `__rw_var = __rare_rw_ptr(&(__var))` is done ?

__rare_rw_ptr() would take a pointer to the usual RO alias, and derive
its RW alias. What exactly this should do depends on how the RW alias is
implemented.

On a system using an RW mm, let's assume we place all __write_rarely
variables in a region bounded by __rare_write_begin/__rare_write_end,
and when the mm is installed place, we have an RW alias of this region
beginning at __rw_alias_start. In this case, it'd look something like:

#define __rare_rw_ptr(ptr) ({				\
	unsigned long __ptr = (unsigned long)(ptr);	\
	__ptr -= __rare_write_start;			\
	__ptr += __rw_alias_start;			\
	(typeof(ptr))__ptr;				\
})

... does that make sense?

For systems where you can freely/easily alter (local) permissions (e.g.
using ARM's domains), that can be done within __rare_rw_{map,unmap}(),
and __rare_rw_ptr can just return the original pointer.

> However the interface will look like, Do we still need a special data
> section that is mapped RO in general but RW in some cases ?

With the above, I think the usual mapping can always be RO.

> if then, doesn’t __ro_mostly_after_init marker itself make sense and
> we still need it ?

We may need a marker to bound the set of variables we wish to map in
this way.

Thanks,
Mark.
