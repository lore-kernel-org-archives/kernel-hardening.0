Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJKa=dRX403On4iCLyNdjW6evT7TWAJCxMvV+qRJPYjag@mail.gmail.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <1476959131-6153-2-git-send-email-elena.reshetova@intel.com> <CAGXu5jJKa=dRX403On4iCLyNdjW6evT7TWAJCxMvV+qRJPYjag@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Oct 2016 17:28:16 -0700
Message-ID: <CAGXu5jLXGtPs4MMQT8+yjXNG1UhkHmSnHawKAePQQCXqX7vcDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2 PATCH 01/13] Add architecture independent hardened atomic base
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 24, 2016 at 4:04 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Oct 20, 2016 at 3:25 AM, Elena Reshetova
> <elena.reshetova@intel.com> wrote:
>> This series brings the PaX/Grsecurity PAX_REFCOUNT [1]
>> feature support to the upstream kernel. All credit for the
>> feature goes to the feature authors.
>>
>> The name of the upstream feature is HARDENED_ATOMIC
>> and it is configured using CONFIG_HARDENED_ATOMIC and
>> HAVE_ARCH_HARDENED_ATOMIC.
>>
>> This series only adds x86 support; other architectures are expected
>> to add similar support gradually.
>> [...]
>> Bugs Prevented
>> --------------
>> HARDENED_ATOMIC would directly mitigate these Linux kernel bugs:
>> [...]
>> CVE-2016-0728 - Keyring refcount overflow
>
> Exploit link is https://www.exploit-db.com/exploits/39277/

BTW, this is easy to test. By reverting 23567fd052a9, I can run the
exploit, and it gets killed. In dmesg, as expected, is:

[ 4546.204612] HARDENED_ATOMIC: overflow detected in:
CVE-2016-0728:3912, uid/euid: 1000/1000
[ 4546.205322] ------------[ cut here ]------------
[ 4546.205692] kernel BUG at kernel/panic.c:627!
[ 4546.206028] invalid opcode: 0000 [#1] SMP
[ 4546.206304] Modules linked in:
[ 4546.206304] CPU: 1 PID: 3912 Comm: CVE-2016-0728 Not tainted 4.9.0-rc2+ #265
[ 4546.206304] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 4546.206304] task: ffff993869d91640 task.stack: ffff9e20c4360000
[ 4546.206304] RIP: 0010:[<ffffffffb4067e56>]  [<ffffffffb4067e56>]
hardened_atomic_overflow+0x66/0x70
[ 4546.206304] RSP: 0018:ffff9e20c4363ca8  EFLAGS: 00010286
[ 4546.206304] RAX: 000000000000004e RBX: ffff993869d91640 RCX: 0000000000000000
[ 4546.206304] RDX: 0000000000000000 RSI: ffff99387fc8ccc8 RDI: ffff99387fc8ccc8
[ 4546.206304] RBP: ffff9e20c4363cb8 R08: 0000000000000001 R09: 0000000000000000
[ 4546.206304] R10: ffffffffb4f4e9c3 R11: 0000000000000001 R12: 00000000000003e8
[ 4546.206304] R13: ffff9e20c4363de8 R14: ffffffffb4f4e9c3 R15: 0000000000000000
[ 4546.206304] FS:  00007f01b632b700(0000) GS:ffff99387fc80000(0000)
knlGS:0000000000000000
[ 4546.206304] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4546.206304] CR2: 00007fff9c39e080 CR3: 000000042979e000 CR4: 00000000001406e0
[ 4546.206304] Stack:
[ 4546.206304]  0000000000000004 ffff993869d91640 ffff9e20c4363d08
ffffffffb401f1c6
[ 4546.206304]  ffff9e20c4363d08 0000000000000000 ffffffffb4f4e9c3
0000000000000004
[ 4546.206304]  ffff9e20c4363de8 000000000000000b ffffffffb4f4e9c3
0000000000000000
[ 4546.206304] Call Trace:
[ 4546.206304]  [<ffffffffb401f1c6>] do_trap+0xa6/0x160
[ 4546.206304]  [<ffffffffb401f32b>] do_error_trap+0xab/0x170
[ 4546.206304]  [<ffffffffb4002036>] ? trace_hardirqs_off_thunk+0x1a/0x1c
[ 4546.206304]  [<ffffffffb401fc90>] do_overflow+0x20/0x30
[ 4546.206304]  [<ffffffffb4ae3ef8>] overflow+0x18/0x20
[ 4546.206304]  [<ffffffffb409180e>] ? prepare_creds+0x9e/0x130
[ 4546.206304]  [<ffffffffb40917aa>] ? prepare_creds+0x3a/0x130
[ 4546.206304]  [<ffffffffb43559ae>] join_session_keyring+0x1e/0x180
[ 4546.206304]  [<ffffffffb43537d1>] keyctl_join_session_keyring+0x31/0x50
[ 4546.206304]  [<ffffffffb435506b>] SyS_keyctl+0xeb/0x110
[ 4546.206304]  [<ffffffffb4002ddc>] do_syscall_64+0x5c/0x140
[ 4546.206304]  [<ffffffffb4ae32a4>] entry_SYSCALL64_slow_path+0x25/0x25
[ 4546.206304] Code: 00 00 8b 93 60 04 00 00 48 8d b3 40 06 00 00 48
c7 c7 50 4d ea b4 45 89 e0 8b 48 14 83 f9 ff 0f 44 0d 9b 5d fe 00 e8
5d 65 10 00 <0f> 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 c7 c0
a0 ca
[ 4546.206304] RIP  [<ffffffffb4067e56>] hardened_atomic_overflow+0x66/0x70
[ 4546.206304]  RSP <ffff9e20c4363ca8>
[ 4546.224401] ---[ end trace 6aca77070d529c86 ]---

-Kees

-- 
Kees Cook
Nexus Security
