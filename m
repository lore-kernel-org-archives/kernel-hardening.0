Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <20170220103008.GC9003@leverpostej>
Date: Tue, 21 Feb 2017 22:36:05 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD3E52DE-98B0-4DC0-8DCB-540599FC876C@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-3-git-send-email-hoeun.ryu@gmail.com>
 <20170220103008.GC9003@leverpostej>
Subject: Re: [kernel-hardening] [RFC 3/7] module: modify memory attrs for
 __ro_mostly_after_init during module_init/exit
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-ID: <kernel-hardening.lists.openwall.com>


> On 20 Feb 2017, at 7:30 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>=20
> On Sun, Feb 19, 2017 at 07:04:06PM +0900, Hoeun Ryu wrote:
>> `__ro_mostly_after_init` is almost like `__ro_after_init`. The =
section is
>> read-only as same as `__ro_after_init` after kernel init. This patch =
makes
>> `__ro_mostly_after_init` section read-write temporarily only during
>> module_init/module_exit.
>>=20
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>> kernel/module.c | 10 ++++++++--
>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 7eba6de..3b25e0e 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -987,8 +987,11 @@ SYSCALL_DEFINE2(delete_module, const char __user =
*, name_user,
>>=20
>> 	mutex_unlock(&module_mutex);
>> 	/* Final destruction now no one is using it. */
>> -	if (mod->exit !=3D NULL)
>> +	if (mod->exit !=3D NULL) {
>> +		set_ro_mostly_after_init_rw();
>> 		mod->exit();
>> +		set_ro_mostly_after_init_ro();
>> +	}
>> 	blocking_notifier_call_chain(&module_notify_list,
>> 				     MODULE_STATE_GOING, mod);
>> 	klp_module_going(mod);
>> @@ -3396,8 +3399,11 @@ static noinline int do_init_module(struct =
module *mod)
>>=20
>> 	do_mod_ctors(mod);
>> 	/* Start the module */
>> -	if (mod->init !=3D NULL)
>> +	if (mod->init !=3D NULL) {
>> +		set_ro_mostly_after_init_rw();
>> 		ret =3D do_one_initcall(mod->init);
>> +		set_ro_mostly_after_init_ro();
>> +	}
>=20
> This looks very much like the pax_{open,close}_kernel() approach for
> write-rarely data.

I read the discussion [1] and I agree that __ro_mostly_after_init marker
looks very similar to __write_rarely.=20

>=20
> I think it would be better to implement a first class write-rarely
> mechanism rather than trying to extend __ro_after_init to cover this
> case.

I=E2=80=99m not extending __ro_after_init. __ro_mostly_after_init =
resides in the same section of rodata though.

>=20
> As mentioned previously, I *think* we can have a generic =
implementation
> that uses an mm to temporarily map a (thread/cpu-local) RW alias of =
the
> data in question in what would otherwise be the user half of the =
address
> space. Regardless, we can have a generic interface [1] that can cater
> for that style of approach and/or something like ARM's domains or =
x86's
> pkeys.
>=20

I=E2=80=99m still learning cpu/kernel architectures, It would be very =
thankful if you tell me more about the detail of the implementation =
itself.

The mm that maps temporary RW alias is like
    * special mm like idmap/init_mm which have its own page tables?
    * the page tables have the same content of page tables of =
init_mm=E2=80=99s swapper_pg_dir except for RW permissions for a =
specific section (let=E2=80=99s say __write_rarely)
    * then use switch_mm(special_rw_mm) to change the address space =
before the access happens to the section
    * then use switch_mm(current->mm) to change the address space to =
original after the access is done

And the interface itself. rare_write(__val, __val), is it a single value =
access interface.
I=E2=80=99m intending to make data in __ro_mostly_after_init section RW =
during multiple accesses like during module_init/exit.
and __rare_rw_map()/unmap() used in rare_write() seems to work like =
open/close api.

How could __rare_rw_ptr() be implemented and what happens when `__rw_var =
=3D __rare_rw_ptr(&(__var))` is done ?

However the interface will look like, Do we still need a special data =
section that is mapped RO in general but RW in some cases ?
if then, doesn=E2=80=99t __ro_mostly_after_init marker itself make sense =
and we still need it ?

> Thanks,
> Mark.
>=20
> [1] http://www.openwall.com/lists/kernel-hardening/2016/11/18/3
