Subject: Re: [kbuild-all] [PATCH v3] ARM: smp: add support for per-task stack
 canaries
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <201812091807.4emRkZ7L%fengguang.wu@intel.com>
 <20181209103740.GB30658@n2100.armlinux.org.uk>
From: Rong Chen <rong.a.chen@intel.com>
Message-ID: <47a91e5a-0e97-334c-2f36-a0bd966a0050@intel.com>
Date: Thu, 13 Dec 2018 10:53:29 +0800
MIME-Version: 1.0
In-Reply-To: <20181209103740.GB30658@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Russell King - ARM Linux <linux@armlinux.org.uk>, kbuild test robot <lkp@intel.com>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>, kbuild-all@01.org, Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>



On 12/09/2018 06:37 PM, Russell King - ARM Linux wrote:
> On Sun, Dec 09, 2018 at 06:28:11PM +0800, kbuild test robot wrote:
>> Hi Ard,
>>
>> I love your patch! Perhaps something to improve:
> Hi,
>
> This looks to me like a false warning - how can a patch touching arch
> code affect the result of lib/test_ubsan.c?  Please can you double-
> check this result?

Hi,

I'm sorry for the trouble, It's a false warning, we will look into it.

Best Regards,
Rong Chen

> Thanks.
>
>> [auto build test WARNING on arm/for-next]
>> [also build test WARNING on v4.20-rc5]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/ARM-smp-add-support-for-per-task-stack-canaries/20181209-033321
>> base:   git://git.armlinux.org.uk/~rmk/linux-arm.git for-next
>> config: arm-allmodconfig (attached as .config)
>> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
>> reproduce:
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # save the attached .config to linux build tree
>>          GCC_VERSION=7.2.0 make.cross ARCH=arm
>>
>> All warnings (new ones prefixed by >>):
>>
>>     lib/test_ubsan.c: In function 'test_ubsan_vla_bound_not_positive':
>>>> lib/test_ubsan.c:48:2: warning: ISO C90 forbids variable length array 'buf' [-Wvla]
>>       char buf[size];
>>       ^~~~
>>     lib/test_ubsan.c: In function 'test_ubsan_out_of_bounds':
>>>> lib/test_ubsan.c:64:2: warning: ISO C90 forbids variable length array 'arr' [-Wvla]
>>       volatile int arr[i];
>>       ^~~~~~~~
>>
>> vim +/buf +48 lib/test_ubsan.c
>>
>> 854686f4 Jinbum Park 2018-04-10  44
>> 854686f4 Jinbum Park 2018-04-10  45  static void test_ubsan_vla_bound_not_positive(void)
>> 854686f4 Jinbum Park 2018-04-10  46  {
>> 854686f4 Jinbum Park 2018-04-10  47  	volatile int size = -1;
>> 854686f4 Jinbum Park 2018-04-10 @48  	char buf[size];
>> 854686f4 Jinbum Park 2018-04-10  49
>> 854686f4 Jinbum Park 2018-04-10  50  	(void)buf;
>> 854686f4 Jinbum Park 2018-04-10  51  }
>> 854686f4 Jinbum Park 2018-04-10  52
>> 854686f4 Jinbum Park 2018-04-10  53  static void test_ubsan_shift_out_of_bounds(void)
>> 854686f4 Jinbum Park 2018-04-10  54  {
>> 854686f4 Jinbum Park 2018-04-10  55  	volatile int val = -1;
>> 854686f4 Jinbum Park 2018-04-10  56  	int val2 = 10;
>> 854686f4 Jinbum Park 2018-04-10  57
>> 854686f4 Jinbum Park 2018-04-10  58  	val2 <<= val;
>> 854686f4 Jinbum Park 2018-04-10  59  }
>> 854686f4 Jinbum Park 2018-04-10  60
>> 854686f4 Jinbum Park 2018-04-10  61  static void test_ubsan_out_of_bounds(void)
>> 854686f4 Jinbum Park 2018-04-10  62  {
>> 854686f4 Jinbum Park 2018-04-10  63  	volatile int i = 4, j = 5;
>> 854686f4 Jinbum Park 2018-04-10 @64  	volatile int arr[i];
>> 854686f4 Jinbum Park 2018-04-10  65
>> 854686f4 Jinbum Park 2018-04-10  66  	arr[j] = i;
>> 854686f4 Jinbum Park 2018-04-10  67  }
>> 854686f4 Jinbum Park 2018-04-10  68
>>
>> :::::: The code at line 48 was first introduced by commit
>> :::::: 854686f4edf483db1e0d26d972bdb8fb65c8bfaa lib: add testing module for UBSAN
>>
>> :::::: TO: Jinbum Park <jinb.park7@gmail.com>
>> :::::: CC: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
>
