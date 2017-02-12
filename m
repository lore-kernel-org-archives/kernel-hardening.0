Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <alpine.DEB.2.20.1702112118120.3734@nanos>
Date: Sun, 12 Feb 2017 10:44:43 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <176AF453-1CEF-4AF3-8A5F-B8AFE16A16CD@gmail.com>
References: <201702111956.gS0EVcvY%fengguang.wu@intel.com> <alpine.DEB.2.20.1702112118120.3734@nanos>
Subject: [kernel-hardening] Re: [PATCH v5] fork: free vmapped stacks in cache when cpus are offline
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


> On Feb 12, 2017, at 5:19 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
>> On Sat, 11 Feb 2017, kbuild test robot wrote:
>>=20
>> Hi Hoeun,
>>=20
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on v4.10-rc7 next-20170210]
>> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>>=20
>> url:    https://github.com/0day-ci/linux/commits/Hoeun-Ryu/fork-free-vmap=
ped-stacks-in-cache-when-cpus-are-offline/20170211-183401
>> config: ia64-allmodconfig (attached as .config)
>> compiler: ia64-linux-gcc (GCC) 6.2.0
>> reproduce:
>>        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.gi=
t/plain/sbin/make.cross -O ~/bin/make.cross
>>        chmod +x ~/bin/make.cross
>>        # save the attached .config to linux build tree
>>        make.cross ARCH=3Dia64=20
>>=20
>> All errors (new ones prefixed by >>):
>>=20
>>   kernel/fork.c: In function 'fork_init':
>>>> kernel/fork.c:483:2: error: implicit declaration of function 'vm_stack_=
cache_init' [-Werror=3Dimplicit-function-declaration]
>>     vm_stack_cache_init();
>>     ^~~~~~~~~~~~~~~~~~~
>=20
> Right. This needs to move to a different place as that part is nested insi=
de
>=20
> #ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
>=20
> That's an horrible ifdef maze in that file.
>=20

I think we should rollback to v4. Do you agree?

> Thanks,
>=20
>    tglx
