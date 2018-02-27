Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
References: <20180227111532.1144-1-ppandit@redhat.com>
 <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <f5f8d06d-461f-f4ad-bc32-5a18f5359353@redhat.com>
Date: Tue, 27 Feb 2018 15:26:10 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, P J P <ppandit@redhat.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/27/2018 11:28 AM, Kees Cook wrote:
> On Tue, Feb 27, 2018 at 3:15 AM, P J P <ppandit@redhat.com> wrote:
>> Hello,
> 
> Hi!
> 
>>
>> Please see:
>>    -> https://gcc.gnu.org/ml/gcc-patches/2014-06/msg00615.html
>>
>> This experimental patch by Florian Weimer(CC'd) adds an option
>> '-finit-local-vars' to gcc(1) compiler. When a program(or kernel)
>> is built using this option, its automatic(local) variables are
>> initialised with zero(0). This could significantly reduce the kernel
>> information leakage issues.
>>
>> A dnf(8) repository of the latest gcc-7.3.1 package built with the above
>> patch and kernel-4.15.5 package built using '-finit-local-vars' option
>> on Fedora-27 is available below
>>
>>    -> https://pjp.fedorapeople.org/init-vars/
>>
>> This same kernel is running on my F27 test machine as I write this.
>> There is no slowness or notice-able performance impact as such.
> 
> Unfortunately "noticeable" isn't going to be a viable metric. You'll
> need to do some real-world benchmarks (i.e. kernel builds, hackbench,
> etc), and compare the results. Even just initializing
> passed-by-reference variables (GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) had
> measurable performance impact.
> 


For comparison (-300 is official Fedora, -301 is from the repo):

    text	   data	    bss	    dec	    hex	filename
16948437	6771094	1777872	25497403	1850f3b	/lib/debug/lib/modules/4.15.5-300.fc27.x86_64/vmlinux
16970359	6776078	1777872	25524309	1857855	/lib/debug/lib/modules/4.15.5-301.fc27.x86_64/vmlinux

Thanks,
Laura
