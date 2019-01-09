Subject: Re: [kbuild-all] [PATCH v3] ARM: smp: add support for per-task stack
 canaries
From: Rong Chen <rong.a.chen@intel.com>
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <201812091807.4emRkZ7L%fengguang.wu@intel.com>
 <20181209103740.GB30658@n2100.armlinux.org.uk>
 <47a91e5a-0e97-334c-2f36-a0bd966a0050@intel.com>
Message-ID: <235f0830-a293-5b00-4510-7d7d4c829d26@intel.com>
Date: Wed, 9 Jan 2019 14:30:38 +0800
MIME-Version: 1.0
In-Reply-To: <47a91e5a-0e97-334c-2f36-a0bd966a0050@intel.com>
Content-Type: multipart/alternative;
 boundary="------------6B591BEF4023DD9EFC53DA3A"
To: Russell King - ARM Linux <linux@armlinux.org.uk>, kbuild test robot <lkp@intel.com>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>, kbuild-all@01.org, Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.
--------------6B591BEF4023DD9EFC53DA3A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12/13/2018 10:53 AM, Rong Chen wrote:
>
>
> On 12/09/2018 06:37 PM, Russell King - ARM Linux wrote:
>> On Sun, Dec 09, 2018 at 06:28:11PM +0800, kbuild test robot wrote:
>>> Hi Ard,
>>>
>>> I love your patch! Perhaps something to improve:
>> Hi,
>>
>> This looks to me like a false warning - how can a patch touching arch
>> code affect the result of lib/test_ubsan.c?  Please can you double-
>> check this result?
>
> Hi,
>
> I'm sorry for the trouble, It's a false warning, we will look into it.
>
> Best Regards,
> Rong Chen
>

Hi all,

I tested the commit on another machine and the warnings are exist.
I found "-Wno-vla" was lost after the commit, so I think it's a real 
problem.

-Werror=designated-init -fplugin-arg-arm_ssp_per_task_plugin-tso=1 
-fplugin-arg-arm_ssp_per_task_plugin-offset=24 
-fsanitize=shift-fsanitize=integer-divide-by-zero -fsanitize=unreachable 
-fsanitize=vla-bound -fsanitize=signed-integer-overflow 
-fsanitize=bounds -fsanitize=object-size -fsanitize=bool -fsanitize=enum 
-fsanitize=alignment -Wno-maybe-uninitialized 
-fsanitize-coverage=trace-pc -DMODULE -DKBUILD_BASENAME='"test_ubsan"' 
-DKBUILD_MODNAME='"test_ubsan"' -c -o lib/.tmp_test_ubsan.o lib/test_ubsan.c

-Werror=designated-init -Wno-vla 
-fsanitize=shift-fsanitize=integer-divide-by-zero -fsanitize=unreachable 
-fsanitize=vla-bound -fsanitize=signed-integer-overflow 
-fsanitize=bounds -fsanitize=object-size -fsanitize=bool -fsanitize=enum 
-fsanitize=alignment -Wno-maybe-uninitialized 
-fsanitize-coverage=trace-pc -DMODULE -DKBUILD_BASENAME='"test_ubsan"' 
-DKBUILD_MODNAME='"test_ubsan"' -c -o lib/.tmp_test_ubsan.o lib/test_ubsan.c

Best Regards,
Rong Chen

>> Thanks.
>>
>>> [auto build test WARNING on arm/for-next]
>>> [also build test WARNING on v4.20-rc5]
>>> [if your patch is applied to the wrong git tree, please drop us a 
>>> note to help improve the system]
>>>
>>> url: 
>>> https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/ARM-smp-add-support-for-per-task-stack-canaries/20181209-033321
>>> base:   git://git.armlinux.org.uk/~rmk/linux-arm.git for-next
>>> config: arm-allmodconfig (attached as .config)
>>> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
>>> reproduce:
>>>          wget 
>>> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross 
>>> -O ~/bin/make.cross
>>>          chmod +x ~/bin/make.cross
>>>          # save the attached .config to linux build tree
>>>          GCC_VERSION=7.2.0 make.cross ARCH=arm
>>>
>>> All warnings (new ones prefixed by >>):
>>>
>>>     lib/test_ubsan.c: In function 'test_ubsan_vla_bound_not_positive':
>>>>> lib/test_ubsan.c:48:2: warning: ISO C90 forbids variable length 
>>>>> array 'buf' [-Wvla]
>>>       char buf[size];
>>>       ^~~~
>>>     lib/test_ubsan.c: In function 'test_ubsan_out_of_bounds':
>>>>> lib/test_ubsan.c:64:2: warning: ISO C90 forbids variable length 
>>>>> array 'arr' [-Wvla]
>>>       volatile int arr[i];
>>>       ^~~~~~~~
>>>
>>> vim +/buf +48 lib/test_ubsan.c
>>>
>>> 854686f4 Jinbum Park 2018-04-10  44
>>> 854686f4 Jinbum Park 2018-04-10  45  static void 
>>> test_ubsan_vla_bound_not_positive(void)
>>> 854686f4 Jinbum Park 2018-04-10  46  {
>>> 854686f4 Jinbum Park 2018-04-10  47      volatile int size = -1;
>>> 854686f4 Jinbum Park 2018-04-10 @48      char buf[size];
>>> 854686f4 Jinbum Park 2018-04-10  49
>>> 854686f4 Jinbum Park 2018-04-10  50      (void)buf;
>>> 854686f4 Jinbum Park 2018-04-10  51  }
>>> 854686f4 Jinbum Park 2018-04-10  52
>>> 854686f4 Jinbum Park 2018-04-10  53  static void 
>>> test_ubsan_shift_out_of_bounds(void)
>>> 854686f4 Jinbum Park 2018-04-10  54  {
>>> 854686f4 Jinbum Park 2018-04-10  55      volatile int val = -1;
>>> 854686f4 Jinbum Park 2018-04-10  56      int val2 = 10;
>>> 854686f4 Jinbum Park 2018-04-10  57
>>> 854686f4 Jinbum Park 2018-04-10  58      val2 <<= val;
>>> 854686f4 Jinbum Park 2018-04-10  59  }
>>> 854686f4 Jinbum Park 2018-04-10  60
>>> 854686f4 Jinbum Park 2018-04-10  61  static void 
>>> test_ubsan_out_of_bounds(void)
>>> 854686f4 Jinbum Park 2018-04-10  62  {
>>> 854686f4 Jinbum Park 2018-04-10  63      volatile int i = 4, j = 5;
>>> 854686f4 Jinbum Park 2018-04-10 @64      volatile int arr[i];
>>> 854686f4 Jinbum Park 2018-04-10  65
>>> 854686f4 Jinbum Park 2018-04-10  66      arr[j] = i;
>>> 854686f4 Jinbum Park 2018-04-10  67  }
>>> 854686f4 Jinbum Park 2018-04-10  68
>>>
>>> :::::: The code at line 48 was first introduced by commit
>>> :::::: 854686f4edf483db1e0d26d972bdb8fb65c8bfaa lib: add testing 
>>> module for UBSAN
>>>
>>> :::::: TO: Jinbum Park <jinb.park7@gmail.com>
>>> :::::: CC: Linus Torvalds <torvalds@linux-foundation.org>
>>>
>>> ---
>>> 0-DAY kernel test infrastructure                Open Source 
>>> Technology Center
>>> https://lists.01.org/pipermail/kbuild-all Intel Corporation
>>
>>
>
> _______________________________________________
> kbuild-all mailing list
> kbuild-all@lists.01.org
> https://lists.01.org/mailman/listinfo/kbuild-all


--------------6B591BEF4023DD9EFC53DA3A
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p><br>
    </p>
    <br>
    <div class="moz-cite-prefix">On 12/13/2018 10:53 AM, Rong Chen
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:47a91e5a-0e97-334c-2f36-a0bd966a0050@intel.com">
      <br>
      <br>
      On 12/09/2018 06:37 PM, Russell King - ARM Linux wrote:
      <br>
      <blockquote type="cite">On Sun, Dec 09, 2018 at 06:28:11PM +0800,
        kbuild test robot wrote:
        <br>
        <blockquote type="cite">Hi Ard,
          <br>
          <br>
          I love your patch! Perhaps something to improve:
          <br>
        </blockquote>
        Hi,
        <br>
        <br>
        This looks to me like a false warning - how can a patch touching
        arch
        <br>
        code affect the result of lib/test_ubsan.c?  Please can you
        double-
        <br>
        check this result?
        <br>
      </blockquote>
      <br>
      Hi,
      <br>
      <br>
      I'm sorry for the trouble, It's a false warning, we will look into
      it.
      <br>
      <br>
      Best Regards,
      <br>
      Rong Chen
      <br>
      <br>
    </blockquote>
    <br>
    Hi all,<br>
    <br>
    I tested the commit on another machine and the warnings are exist.<br>
    I found "<span style="color: rgb(255, 0, 0); font-family:
       -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto,
      &quot;Noto Sans&quot;, Ubuntu, &quot;Droid Sans&quot;,
      &quot;Helvetica Neue&quot;, sans-serif; font-size: 14px;
      font-style: normal; font-variant-ligatures: normal;
      font-variant-caps: normal; font-weight: 400; letter-spacing:
      normal; orphans: 2; text-align: start; text-indent: 0px;
      text-transform: none; white-space: normal; widows: 2;
      word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(245, 245, 245); text-decoration-style:
      initial; text-decoration-color: initial; display: inline
      !important; float: none;"><span> </span>-Wno-vla</span>" was lost
    after the commit, so I think it's a real problem.<br>
    <br>
    <font style="outline: none !important; font-family:  -apple-system,
      BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Noto
      Sans&quot;, Ubuntu, &quot;Droid Sans&quot;, &quot;Helvetica
      Neue&quot;, sans-serif; font-size: 14px; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; background-color: rgb(245, 245, 245); text-decoration-style:
      initial; text-decoration-color: initial;" color="#FF0000">-Werror=designated-init
      -fplugin-arg-arm_ssp_per_task_plugin-tso=1
      -fplugin-arg-arm_ssp_per_task_plugin-offset=24 -fsanitize=shift<span> </span></font><span
      style="color: rgb(51, 51, 51); font-family:  -apple-system,
      BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Noto
      Sans&quot;, Ubuntu, &quot;Droid Sans&quot;, &quot;Helvetica
      Neue&quot;, sans-serif; font-size: 14px; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; background-color: rgb(245, 245, 245); text-decoration-style:
      initial; text-decoration-color: initial; display: inline
      !important; float: none;">-fsanitize=integer-divide-by-zero
      -fsanitize=unreachable -fsanitize=vla-bound
      -fsanitize=signed-integer-overflow -fsanitize=bounds
      -fsanitize=object-size -fsanitize=bool -fsanitize=enum
      -fsanitize=alignment -Wno-maybe-uninitialized
      -fsanitize-coverage=trace-pc -DMODULE
      -DKBUILD_BASENAME='"test_ubsan"' -DKBUILD_MODNAME='"test_ubsan"'
      -c -o lib/.tmp_test_ubsan.o lib/test_ubsan.c</span><br>
    <br>
    <font style="outline: none !important; font-family:  -apple-system,
      BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Noto
      Sans&quot;, Ubuntu, &quot;Droid Sans&quot;, &quot;Helvetica
      Neue&quot;, sans-serif; font-size: 14px; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; background-color: rgb(245, 245, 245); text-decoration-style:
      initial; text-decoration-color: initial;" color="#FF0000">-Werror=designated-init
      -Wno-vla -fsanitize=shift</font><span style="color: rgb(51, 51,
      51); font-family:  -apple-system, BlinkMacSystemFont, &quot;Segoe
      UI&quot;, Roboto, &quot;Noto Sans&quot;, Ubuntu, &quot;Droid
      Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-size:
      14px; font-style: normal; font-variant-ligatures: normal;
      font-variant-caps: normal; font-weight: 400; letter-spacing:
      normal; orphans: 2; text-align: start; text-indent: 0px;
      text-transform: none; white-space: normal; widows: 2;
      word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(245, 245, 245); text-decoration-style:
      initial; text-decoration-color: initial; display: inline
      !important; float: none;"><span> </span>-fsanitize=integer-divide-by-zero
      -fsanitize=unreachable -fsanitize=vla-bound
      -fsanitize=signed-integer-overflow -fsanitize=bounds
      -fsanitize=object-size -fsanitize=bool -fsanitize=enum
      -fsanitize=alignment -Wno-maybe-uninitialized
      -fsanitize-coverage=trace-pc -DMODULE
      -DKBUILD_BASENAME='"test_ubsan"' -DKBUILD_MODNAME='"test_ubsan"'
      -c -o lib/.tmp_test_ubsan.o lib/test_ubsan.c</span><br>
    <br>
    Best Regards,<br>
    Rong Chen<br>
    <br>
    <blockquote type="cite"
      cite="mid:47a91e5a-0e97-334c-2f36-a0bd966a0050@intel.com">
      <blockquote type="cite">Thanks.
        <br>
        <br>
        <blockquote type="cite">[auto build test WARNING on
          arm/for-next]
          <br>
          [also build test WARNING on v4.20-rc5]
          <br>
          [if your patch is applied to the wrong git tree, please drop
          us a note to help improve the system]
          <br>
          <br>
          url:   
<a class="moz-txt-link-freetext" href="https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/ARM-smp-add-support-for-per-task-stack-canaries/20181209-033321">https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/ARM-smp-add-support-for-per-task-stack-canaries/20181209-033321</a><br>
          base:   git://git.armlinux.org.uk/~rmk/linux-arm.git for-next
          <br>
          config: arm-allmodconfig (attached as .config)
          <br>
          compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
          <br>
          reproduce:
          <br>
                   wget
          <a class="moz-txt-link-freetext" href="https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross">https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross</a>
          -O ~/bin/make.cross
          <br>
                   chmod +x ~/bin/make.cross
          <br>
                   # save the attached .config to linux build tree
          <br>
                   GCC_VERSION=7.2.0 make.cross ARCH=arm
          <br>
          <br>
          All warnings (new ones prefixed by &gt;&gt;):
          <br>
          <br>
              lib/test_ubsan.c: In function
          'test_ubsan_vla_bound_not_positive':
          <br>
          <blockquote type="cite">
            <blockquote type="cite">lib/test_ubsan.c:48:2: warning: ISO
              C90 forbids variable length array 'buf' [-Wvla]
              <br>
            </blockquote>
          </blockquote>
                char buf[size];
          <br>
                ^~~~
          <br>
              lib/test_ubsan.c: In function 'test_ubsan_out_of_bounds':
          <br>
          <blockquote type="cite">
            <blockquote type="cite">lib/test_ubsan.c:64:2: warning: ISO
              C90 forbids variable length array 'arr' [-Wvla]
              <br>
            </blockquote>
          </blockquote>
                volatile int arr[i];
          <br>
                ^~~~~~~~
          <br>
          <br>
          vim +/buf +48 lib/test_ubsan.c
          <br>
          <br>
          854686f4 Jinbum Park 2018-04-10  44
          <br>
          854686f4 Jinbum Park 2018-04-10  45  static void
          test_ubsan_vla_bound_not_positive(void)
          <br>
          854686f4 Jinbum Park 2018-04-10  46  {
          <br>
          854686f4 Jinbum Park 2018-04-10  47      volatile int size =
          -1;
          <br>
          854686f4 Jinbum Park 2018-04-10 @48      char buf[size];
          <br>
          854686f4 Jinbum Park 2018-04-10  49
          <br>
          854686f4 Jinbum Park 2018-04-10  50      (void)buf;
          <br>
          854686f4 Jinbum Park 2018-04-10  51  }
          <br>
          854686f4 Jinbum Park 2018-04-10  52
          <br>
          854686f4 Jinbum Park 2018-04-10  53  static void
          test_ubsan_shift_out_of_bounds(void)
          <br>
          854686f4 Jinbum Park 2018-04-10  54  {
          <br>
          854686f4 Jinbum Park 2018-04-10  55      volatile int val =
          -1;
          <br>
          854686f4 Jinbum Park 2018-04-10  56      int val2 = 10;
          <br>
          854686f4 Jinbum Park 2018-04-10  57
          <br>
          854686f4 Jinbum Park 2018-04-10  58      val2 &lt;&lt;= val;
          <br>
          854686f4 Jinbum Park 2018-04-10  59  }
          <br>
          854686f4 Jinbum Park 2018-04-10  60
          <br>
          854686f4 Jinbum Park 2018-04-10  61  static void
          test_ubsan_out_of_bounds(void)
          <br>
          854686f4 Jinbum Park 2018-04-10  62  {
          <br>
          854686f4 Jinbum Park 2018-04-10  63      volatile int i = 4, j
          = 5;
          <br>
          854686f4 Jinbum Park 2018-04-10 @64      volatile int arr[i];
          <br>
          854686f4 Jinbum Park 2018-04-10  65
          <br>
          854686f4 Jinbum Park 2018-04-10  66      arr[j] = i;
          <br>
          854686f4 Jinbum Park 2018-04-10  67  }
          <br>
          854686f4 Jinbum Park 2018-04-10  68
          <br>
          <br>
          :::::: The code at line 48 was first introduced by commit
          <br>
          :::::: 854686f4edf483db1e0d26d972bdb8fb65c8bfaa lib: add
          testing module for UBSAN
          <br>
          <br>
          :::::: TO: Jinbum Park <a class="moz-txt-link-rfc2396E" href="mailto:jinb.park7@gmail.com">&lt;jinb.park7@gmail.com&gt;</a>
          <br>
          :::::: CC: Linus Torvalds
          <a class="moz-txt-link-rfc2396E" href="mailto:torvalds@linux-foundation.org">&lt;torvalds@linux-foundation.org&gt;</a>
          <br>
          <br>
          ---
          <br>
          0-DAY kernel test infrastructure                Open Source
          Technology Center
          <br>
          <a class="moz-txt-link-freetext" href="https://lists.01.org/pipermail/kbuild-all">https://lists.01.org/pipermail/kbuild-all</a>                  
          Intel Corporation
          <br>
        </blockquote>
        <br>
        <br>
      </blockquote>
      <br>
      _______________________________________________
      <br>
      kbuild-all mailing list
      <br>
      <a class="moz-txt-link-abbreviated" href="mailto:kbuild-all@lists.01.org">kbuild-all@lists.01.org</a>
      <br>
      <a class="moz-txt-link-freetext" href="https://lists.01.org/mailman/listinfo/kbuild-all">https://lists.01.org/mailman/listinfo/kbuild-all</a>
      <br>
    </blockquote>
    <br>
  </body>
</html>

--------------6B591BEF4023DD9EFC53DA3A--
