Reply-To: kernel-hardening@lists.openwall.com
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros>
In-Reply-To: <20110813062246.GC3851@albatros>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 13 Aug 2011 10:41:54 -0500
Message-ID: <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy Kulikov <segoon@openwall.com> wrote:

>On Fri, Aug 12, 2011 at 15:08 -0500, H. Peter Anvin wrote:
>> On 08/12/2011 10:03 AM, Vasiliy Kulikov wrote:
>> > This patch allows x86-64 systems with 32 bit syscalls support to
>lock a
>> > pid namespace to 32 or 64 bitness syscalls/tasks.  By denying
>rarely
>> > used compatibility syscalls it reduces an attack surface for 32 bit
>> > containers.
>> > 
>> > The new sysctl is introduced, abi.bitness_locked.  If set to 1, it
>locks
>> > all tasks inside of current pid namespace to the bitness of init
>task
>> > (pid_ns->child_reaper).  After that:
>> > 
>> > 1) a task trying to do a syscall of other bitness would get a
>signal as
>> > if the corresponding syscall is not enabled (IDT entry/MSR is not
>> > initialized).
>> > 
>> > 2) loading ELF binaries of another bitness is prohibited (as if the
>> > corresponding CONFIG_BINFMT_*=N).
>[...]
>> However, I have to question the value of this... if this is enabled
>in
>> the system as a whole (as opposed to compiled out) it seems kind of
>> pointless...
>
>No, it is not for the system as a whole, but for containers (however,
>it's possible to lock the whole system).  We use OpenVZ kernels with
>multiple containers, some of them are 32 bit, some are 64 bit.  64 bit
>syscalls are not needed for 32 bit containers and 32 bit syscalls are
>not needed for 64 bit containers.  As a needless interfaces they
>unreasonably increase the kernel attack surface.  Some compatibility 32
>bit syscalls are rarely used, sometimes they are not tested well.
>
>In IA-64 the IA-32 compatibility support was broken for 2 years:
>
>http://www.spinics.net/lists/linux-ia64/msg07840.html
>
>In amd64 some specific rarely used syscalls might behave similar way.
>Removing this attack vector is the goal of the patch.
>
>> if there are bugs we need to deal with them anyway.
>
>Definitely.
>
>> > Qestions/thoughts:
>> > 
>> > The patch adds a check in syscalls code.  Is it a significant
>> > slowdown for fast syscalls?  If so, probably it worth moving the
>check
>> > into scheduler code and enabling/disabling corresponding
>interrupt/MSRs
>> > on each task switch?
>> > 
>> 
>> *YOU* are the person who needs to answer that question by providing
>> measurements.  Quite frankly I suspect checks in the syscall code
>*or*
>> task switching MSRs are going to be unacceptable from a performance
>> point of view.
>
>OK, I'll do it.
>
>Thank you,
>
>-- 
>Vasiliy Kulikov
>http://www.openwall.com - bringing security into open computing
>environments

IA64 is totally different.  I'm extremely sceptical to this patch; it feels like putting code in a super-hot path to paper over a problem that has to be fixed anyway.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
