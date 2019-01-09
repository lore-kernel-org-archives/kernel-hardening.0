Subject: Re: [PATCH] usercopy: skip the check if not a real usercopy
References: <20190102093137.17136-1-yanaijie@huawei.com>
 <CAG48ez3_oMX7Nzjaa4=QzipQ7i-BOOVojY5WVBNOBw0RZeik=g@mail.gmail.com>
 <CAGXu5jLGbAr9JLo=FtvSSF+EdTcj1J04PUUi65tY97zpdUAkRQ@mail.gmail.com>
 <5C355BD6.2010608@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <5C355EAB.7080008@huawei.com>
Date: Wed, 9 Jan 2019 10:38:35 +0800
MIME-Version: 1.0
In-Reply-To: <5C355BD6.2010608@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, zhaohongjiang@huawei.com, miaoxie@huawei.com, Li Bin <huawei.libin@huawei.com>, Wei Yongjun <weiyongjun1@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 2019/1/9 10:26, Jason Yan wrote:
> Hi all,
>
> On 2019/1/9 7:54, Kees Cook wrote:
>> I would think we'd still want to be performing bounds-checking even in
>> the kernel-to-kernel case. It seems like there is some other issue
>> here? Why would the check stall?
>>
>> Can you find out from your build what your top-of-dump line this
>> resolves to? (My various kernel version builds don't share the same
>> function size, so this doesn't resolve for me...)
>>
>> $ ./scripts/faddr2line vmlinux __check_object_size+0x1f1/0x460
>>
>> Maybe it's getting stuck in loop doing stack frame walking? I'd expect
>> that to show up in the backtrace though (since it's noinline).
>
>
> It's very easy to reproduce in qemu using my config with v4.20. Please
> refer to the attachment.
>
> I did some debug and found that check_object_size() did not stuck but
> check_object_size() sometimes takes more than 30 milliseconds, and
> ftrace will call __probe_kernel_write() thousands of times, which makes
> the whole process stuck for more than 20 seconds.

And I tried kernel v5.0-rc1，the system directly reboot and didn't print 
any thing.


[root@localhost ~]#
[root@localhost ~]# cat functiontracer.sh
ping 127.0.0.1 -i 0.01 > /dev/null &
sleep 1
echo function > /sys/kernel/debug/tracing/current_tracer
[root@localhost ~]#
[root@localhost ~]#
[root@localhost ~]# sh functiontracer.sh
[   43.972860] hrtimer: interrupt took 3515386 ns
[    0.000000] Linux version 5.0.0-rc1-514.55.6.9.x86_64 (yanaijie@138) 
(gcc version 7.3.1 20180712 (Red Hat 7.3.1-6) (GCC)) #72 SMP Wed Jan 9 
09:25:31 CST 2019
[    0.000000] Command line: console=ttyS0 IP=192.168.25.187 
root=/dev/vda rw
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffde000-0x00000000bfffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
