Content-Type: text/plain;
	charset=euc-kr
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <20170221135807.GC8605@leverpostej>
Date: Wed, 22 Feb 2017 22:45:43 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <B05432A7-6A22-4F46-8B22-D5643D7C5822@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com> <1487498660-16600-3-git-send-email-hoeun.ryu@gmail.com> <20170220103008.GC9003@leverpostej> <BD3E52DE-98B0-4DC0-8DCB-540599FC876C@gmail.com> <20170221135807.GC8605@leverpostej>
Subject: Re: [kernel-hardening] [RFC 3/7] module: modify memory attrs for __ro_mostly_after_init during module_init/exit
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

Thank you for your detailed explanation. It helped a lot for understandings.=


> On Feb 21, 2017, at 10:58 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>=20
> On Tue, Feb 21, 2017 at 10:36:05PM +0900, Ho-Eun Ryu wrote:
>>> On 20 Feb 2017, at 7:30 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>>> On Sun, Feb 19, 2017 at 07:04:06PM +0900, Hoeun Ryu wrote:
>=20
>>>> @@ -3396,8 +3399,11 @@ static noinline int do_init_module(struct module=
 *mod)
>>>>=20
>>>>   do_mod_ctors(mod);
>>>>   /* Start the module */
>>>> -    if (mod->init !=3D NULL)
>>>> +    if (mod->init !=3D NULL) {
>>>> +        set_ro_mostly_after_init_rw();
>>>>       ret =3D do_one_initcall(mod->init);
>>>> +        set_ro_mostly_after_init_ro();
>>>> +    }
>>>=20
>>> This looks very much like the pax_{open,close}_kernel() approach for
>>> write-rarely data.
>>=20
>> I read the discussion [1] and I agree that __ro_mostly_after_init marker
>> looks very similar to __write_rarely.=20
>>=20
>>> I think it would be better to implement a first class write-rarely
>>> mechanism rather than trying to extend __ro_after_init to cover this
>>> case.
>>=20
>> I=A1=AFm not extending __ro_after_init. __ro_mostly_after_init resides in=

>> the same section of rodata though.
>=20
> Sorry; I was confused when I wrote that email. I now understand that
> you're adding a separate annotation.
>=20
>>> As mentioned previously, I *think* we can have a generic implementation
>>> that uses an mm to temporarily map a (thread/cpu-local) RW alias of the
>>> data in question in what would otherwise be the user half of the address=

>>> space. Regardless, we can have a generic interface [1] that can cater
>>> for that style of approach and/or something like ARM's domains or x86's
>>> pkeys.
>>=20
>> I=A1=AFm still learning cpu/kernel architectures, It would be very thankf=
ul if you tell me more about the detail of the implementation itself.
>>=20
>> The mm that maps temporary RW alias is like
>>   * special mm like idmap/init_mm which have its own page tables?
>>   * the page tables have the same content of page tables of
>>     init_mm=A1=AFs swapper_pg_dir except for RW permissions for a
>>     specific section (let=A1=AFs say __write_rarely)
>=20
> This would be a special mm, like a user mm, that only mapped the
> relevant VA(s).

we need a separate mm/pgd for ttbr0_el1 in kernel image section as idmap and=
 swapper_pg_dir currently do and we make VA alias mapping for RO section wit=
h RW permission under TASK_SIZE during kernel init. And then we can switch t=
o the mm by setting the pgd to ttbr0_el1. Right ?

It came to my mind that how about the relationship with SW_TTBR0_PAN .
What if copy_from_user tries to do something against RW alias ?

val_rw =3D __rw_ptr(&val);
__rw_map();
copy_from_user(&val_rw, user_ptr);
__re_unmap();

__rw_map() will install rw_mm->gpd to ttbr0_el1 but uaccess_enable() will im=
mediately reinstall thread_info->pgd to ttbr0_el1 and we loose RW alias.
Am I something wrong or confused ?

>=20
> That might map the relevant variable on-demand, or the mapping could
> cover the whole write_rarely area.
>=20
>>   * then use switch_mm(special_rw_mm) to change the address space
>>     before the access happens to the section
>>   * then use switch_mm(current->mm) to change the address space to
>>     original after the access is done
>=20
> Yes.
>=20
>> And the interface itself. rare_write(__val, __val), is it a single
>> value access interface.
>> I=A1=AFm intending to make data in __ro_mostly_after_init section RW duri=
ng
>> multiple accesses like during module_init/exit.
>> and __rare_rw_map()/unmap() used in rare_write() seems to work like
>> open/close api.
>=20
> The __rare_rw_{map,unmap}() functions would map in the RW alias, but do
> not necessarily change the RO alias to RW. This is why __rare_rw_ptr()
> would be necessary, and is the major difference to the open/close API.
>=20
> We could certainly allow several writes between a map/unmap. The key
> requirement is that each write is instrumented so that it goes via the
> RW alias.
>=20
>> How could __rare_rw_ptr() be implemented and what happens when
>> `__rw_var =3D __rare_rw_ptr(&(__var))` is done ?
>=20
> __rare_rw_ptr() would take a pointer to the usual RO alias, and derive
> its RW alias. What exactly this should do depends on how the RW alias is
> implemented.
>=20
> On a system using an RW mm, let's assume we place all __write_rarely
> variables in a region bounded by __rare_write_begin/__rare_write_end,
> and when the mm is installed place, we have an RW alias of this region
> beginning at __rw_alias_start. In this case, it'd look something like:
>=20
> #define __rare_rw_ptr(ptr) ({                \
>   unsigned long __ptr =3D (unsigned long)(ptr);    \
>   __ptr -=3D __rare_write_start;            \
>   __ptr +=3D __rw_alias_start;            \
>   (typeof(ptr))__ptr;                \
> })
>=20
> ... does that make sense?

Yes. Cool.

>=20
> For systems where you can freely/easily alter (local) permissions (e.g.
> using ARM's domains), that can be done within __rare_rw_{map,unmap}(),
> and __rare_rw_ptr can just return the original pointer.
>=20
>> However the interface will look like, Do we still need a special data
>> section that is mapped RO in general but RW in some cases ?
>=20
> With the above, I think the usual mapping can always be RO.
>=20
>> if then, doesn=A1=AFt __ro_mostly_after_init marker itself make sense and=

>> we still need it ?
>=20
> We may need a marker to bound the set of variables we wish to map in
> this way.
>=20
> Thanks,
> Mark.
