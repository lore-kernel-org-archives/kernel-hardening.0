MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170407192930.GA1526@athena>
References: <20170406033550.32525-3-ewk@edkovsky.org> <201704070155.EM9TWkdW%fengguang.wu@intel.com>
 <20170407192930.GA1526@athena>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 7 Apr 2017 13:45:24 -0700
Message-ID: <CAGXu5j+TTp2RKsadApvVPhEGNuqfURGPXVnT_R0uKm9gZinnjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 2/2] extable: verify address is read-only
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 7, 2017 at 12:29 PM, Eddie Kovsky <ewk@edkovsky.org> wrote:
> On 04/07/17, kbuild test robot wrote:
>> Hi Eddie,
>>
>> [auto build test ERROR on next-20170330]
>> [cannot apply to linus/master linux/master jeyu/modules-next v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc5]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Eddie-Kovsky/module-verify-address-is-read-only/20170407-004322
>> config: i386-randconfig-x010-201714 (attached as .config)
>> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=i386
>>
>> All errors (new ones prefixed by >>):
>>
>>    kernel/extable.c: In function 'core_kernel_rodata':
>> >> kernel/extable.c:169:29: error: '__start_ro_after_init' undeclared (first use in this function)
>>      if (addr >= (unsigned long)__start_ro_after_init &&
>>                                 ^~~~~~~~~~~~~~~~~~~~~
>>    kernel/extable.c:169:29: note: each undeclared identifier is reported only once for each function it appears in
>> >> kernel/extable.c:170:28: error: '__end_ro_after_init' undeclared (first use in this function)
>>          addr < (unsigned long)__end_ro_after_init)
>>                                ^~~~~~~~~~~~~~~~~~~
>>
>> vim +/__start_ro_after_init +169 kernel/extable.c
>>
>>    163        int core_kernel_rodata(unsigned long addr)
>>    164        {
>>    165                if (addr >= (unsigned long)__start_rodata &&
>>    166                    addr < (unsigned long)__end_rodata)
>>    167                        return 1;
>>    168
>>  > 169                if (addr >= (unsigned long)__start_ro_after_init &&
>>  > 170                    addr < (unsigned long)__end_ro_after_init)
>>    171                        return 1;
>>    172
>>    173                return 0;
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
>
> This looks like a false alarm.
>
> The test build is based on next-20170330. Kees' patch for the section
> names [start|end]_ro_after_init didn't appear in next until 20170403.
>
> I cannot reproduce the build error using this config on recent versions
> of next. Am I missing something here?

I agree, this was built without the renaming from the latest -next trees.

-Kees

-- 
Kees Cook
Pixel Security
