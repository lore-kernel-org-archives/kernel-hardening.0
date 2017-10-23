References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <20171022131157.GB3165@worktop.lehotels.local>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <7c7fc24b-4bfb-cc8a-143e-0c28cf3247b7@linux.com>
Date: Mon, 23 Oct 2017 14:21:27 +0300
MIME-Version: 1.0
In-Reply-To: <20171022131157.GB3165@worktop.lehotels.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 0/5] Introduce the STACKLEAK feature and a test for
 it
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 22.10.2017 16:11, Peter Zijlstra wrote:
> On Sun, Oct 22, 2017 at 03:22:48AM +0300, Alexander Popov wrote:
>  
>> These numbers were obtained for the 4th version of the patch series.
>>
>> Size of vmlinux (x86_64_defconfig):
>>  file size:
>>   - STACKLEAK disabled: 35014784 bytes
>>   - STACKLEAK enabled: 35044952 bytes (+0.086%)
>>  .text section size (calculated by size utility):
>>   - STACKLEAK disabled: 10752983
>>   - STACKLEAK enabled: 11062221 (+2.876%)
> 
> Why no runtime costs? This should not be hard to measure.

Hello Peter,

Here are the results of a brief performance test on x86_64 (for the 2nd version
of the patch). The numbers are very different because the STACKLEAK performance
penalty depends on the workloads.

Hardware: Intel Core i7-4770, 16 GB RAM

Test #1: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
Average result on 4.11-rc8: 8.71s
Average result on 4.11-rc8+stackleak: 9.08s (+4.29%)

Test #2: building the Linux kernel with Ubuntu config (time make -j9)
Result on 4.11-rc8:
  real	32m14.893s
  user	237m30.886s
  sys	11m12.273s
Result on 4.11-rc8+stackleak:
  real	32m26.881s (+0.62%)
  user	238m38.926s (+0.48%)
  sys	11m36.426s (+3.59%)

Test #3: stress-ng --cpu 4 --io 2 --vm 2 --vm-bytes 2G --timeout 300s
 --metrics-brief
Result on 4.11-rc8:
  cpu bogo ops 269955
  iosync bogo ops 9809985
  vm bogo ops 17093608
Result on 4.11-rc8+stackleak:
  cpu bogo ops 270106 (+0.6%)
  iosync bogo ops 9474535 (-3.42%)
  vm bogo ops 17093608 (the same)

So the STACKLEAK description in Kconfig includes:
"The tradeoff is the performance impact: on a single CPU system kernel
compilation sees a 1% slowdown, other systems and workloads may vary and you are
advised to test this feature on your expected workload before deploying it".

Best regards,
Alexander
