Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <9493.1467388521@turing-police.cc.vt.edu>
References: <9493.1467388521@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 1 Jul 2016 15:54:36 -0400
Message-ID: <CAGXu5jJAxawe2U-Uq_62imm3J2sSNtqWwBYrCToRv4B5gaZS7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] usercopy - goood news and bad news
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 1, 2016 at 11:55 AM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> The good news - I ran my laptop through pretty much all of the Linux Test
> Project code (20160510 release) - it ran pretty much everything except the NUMA
> tests and the deprecated 16-bit UID/GID stuff, and didn't trigger the usercopy
> code except for the already-known issue with ping/ping6.  So we're in
> reasonably good shape there - it isn't like there's zillions of corner cases
> we'll need to track down.
>
> The bad news:  Triggered another issue - ptrace this time, while trying to
> attach gdb to a running process:

Heh, okay.

I'm planning to do usercopy in several pieces, with this
"whitelisting" being later on. The first step will be the object size
checking. We'll still need all this research, though, so fear not. :)

I sure this task_struct thing for gdb is fixed in grsecurity. Maybe
see if you can find the code that does a memcpy work-around in the
register copying that would be great! (I haven't had time to look
yet.)

-Kees

>
>
> Jun 30 20:43:08 turing-police kernel: [ 1712.780889] usercopy: kernel memory exposure attempt detected from ffff8801c8102fc0 (task_struct) (576 bytes)
> Jun 30 20:43:08 turing-police kernel: [ 1712.780902] CPU: 3 PID: 24085 Comm: gdb Tainted: G           OE   4.7.0-rc5-next-20160628-dirty #305
> Jun 30 20:43:08 turing-police kernel: [ 1712.780908] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
> Jun 30 20:43:08 turing-police kernel: [ 1712.780914]  0000000000000000 000000008822eeb4 ffff88012ff1bd10 ffffffffa06e7dea
> Jun 30 20:43:08 turing-police kernel: [ 1712.780928]  ffff8801c8102fc0 000000008822eeb4 0000000000000240 0000000000000001
> Jun 30 20:43:08 turing-police kernel: [ 1712.780942]  ffff88012ff1bd60 ffffffffa03a0440 00007ffee54243b0 ffffea00072040a0
> Jun 30 20:43:08 turing-police kernel: [ 1712.780954] Call Trace:
> Jun 30 20:43:08 turing-police kernel: [ 1712.780969]  [<ffffffffa06e7dea>] dump_stack+0x7b/0xd1
> Jun 30 20:43:08 turing-police kernel: [ 1712.780975]  [<ffffffffa03a0440>] __check_object_size+0x70/0x3be
> Jun 30 20:43:08 turing-police kernel: [ 1712.780980]  [<ffffffffa004ada0>] xstateregs_get+0x110/0x140
> Jun 30 20:43:08 turing-police kernel: [ 1712.780984]  [<ffffffffa00ca4aa>] ptrace_regset+0x28a/0x450
> Jun 30 20:43:08 turing-police kernel: [ 1712.780988]  [<ffffffffa015c8ca>] ? do_raw_spin_lock+0x15a/0x210
> Jun 30 20:43:08 turing-police kernel: [ 1712.780992]  [<ffffffffa00cca90>] ptrace_request+0x440/0x780
> Jun 30 20:43:08 turing-police kernel: [ 1712.780997]  [<ffffffffa01055ca>] ? preempt_count_sub+0x4a/0x90
> Jun 30 20:43:08 turing-police kernel: [ 1712.781002]  [<ffffffffa10f3264>] ? _raw_spin_unlock_irqrestore+0x74/0x90
> Jun 30 20:43:08 turing-police kernel: [ 1712.781005]  [<ffffffffa010eb4e>] ? wait_task_inactive+0x25e/0x430
> Jun 30 20:43:08 turing-police kernel: [ 1712.781009]  [<ffffffffa00ca140>] ? ptrace_check_attach+0x160/0x200
> Jun 30 20:43:08 turing-police kernel: [ 1712.781013]  [<ffffffffa004ffc2>] arch_ptrace+0x522/0x7a0
> Jun 30 20:43:08 turing-police kernel: [ 1712.781016]  [<ffffffffa00cc561>] SyS_ptrace+0xa1/0x110
> Jun 30 20:43:08 turing-police kernel: [ 1712.781020]  [<ffffffffa10f3ae5>] entry_SYSCALL_64_fastpath+0x18/0xa8
> Jun 30 20:43:08 turing-police kernel: [ 1712.781024]  [<ffffffffa014f4df>] ? trace_hardirqs_off_caller+0x1f/0xf0
>
> So I'm up to 3 hits now (ptrace, sctp, and ping).



-- 
Kees Cook
Chrome OS & Brillo Security
