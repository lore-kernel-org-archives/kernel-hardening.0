Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20160711163110.GD7691@leverpostej>
References: <cover.1466974736.git.luto@kernel.org> <aeea9c1c41e889065b2c9ecd6d0694e4dfb529c8.1466974736.git.luto@kernel.org>
 <20160711100808.GB31221@leverpostej> <CALCETrWnw0WjionuGAT1F8r5y_t5CbYh+TmDL4s2d=ZbiinspA@mail.gmail.com>
 <CA+55aFy2Sno+bS0A2k0cMWpEJy-bpXufSAw3+ufrfQYbp9rcMQ@mail.gmail.com> <20160711163110.GD7691@leverpostej>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Jul 2016 09:42:42 -0700
Message-ID: <CA+55aFz7TTf-MaF+a=qF+KX=G0S51v97xsOsJJVsi8ahNUBtMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v4 26/29] sched: Allow putting
 thread_info into task_struct
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 11, 2016 at 9:31 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>>
>> So until you do the wire that actually disables preemption you can
>> schedule away as much as you want, and after that write you no longer
>> will.
>
> I was assuming a percpu pointer to current (or preempt count).

So for the same reason that is ok *iff* you have

 - some kind of dedicated percpu register (or other base pointer - x86
has the segment thing) that gets updated when you schedule.

 - an instruction that can load 'current' directly off that register atomically.

But yes, percpu data in general is obviously not safe to access
without preemption.

         Linus
