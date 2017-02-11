Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <alpine.DEB.2.20.1702110928390.3734@nanos>
Date: Sat, 11 Feb 2017 18:56:41 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <A2A3D2E8-EAC9-441B-A2DF-C2500174E7BC@gmail.com>
References: <1486770080-25007-1-git-send-email-hoeun.ryu@gmail.com> <alpine.DEB.2.20.1702110928390.3734@nanos>
Subject: [kernel-hardening] Re: [PATCH v4] fork: free vmapped stacks in cache when cpus are offline
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


> On Feb 11, 2017, at 5:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
>> On Sat, 11 Feb 2017, Hoeun Ryu wrote:
>> #define NR_CACHED_STACKS 2
>> static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]=
);
>> +
>> +static int free_vm_stack_cache(unsigned int cpu)
>> +{
>> +    struct vm_struct **cached_vm_stacks =3D per_cpu_ptr(cached_stacks, c=
pu);
>> +    int i;
>> +
>> +    for (i =3D 0; i < NR_CACHED_STACKS; i++) {
>> +        struct vm_struct *vm_stack =3D cached_vm_stacks[i];
>> +
>> +        if (!vm_stack)
>> +            continue;
>> +
>> +        vfree(vm_stack->addr);
>> +        cached_vm_stacks[i] =3D NULL;
>> +    }
>> +
>> +    return 0;
>> +}
>> #endif
>>=20
>> static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, in=
t node)
>> @@ -456,6 +474,11 @@ void __init fork_init(void)
>>    for (i =3D 0; i < UCOUNT_COUNTS; i++) {
>>        init_user_ns.ucount_max[i] =3D max_threads/2;
>>    }
>> +
>> +#ifdef CONFIG_VMAP_STACK
>> +    cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vmstack_cache",
>> +              NULL, free_vm_stack_cache);
>> +#endif
>=20
> If you wrap that in vm_stack_cache_init() and have a stub for !VMAP_STACK
> (add an #else to the #ifdef VMAP_STACK section above) then you spare the
> ugly ifdef in fork_init()

OK. I will.

> Thanks,
>=20
>    tglx
