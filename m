Date: Thu, 30 May 2019 13:26:06 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: unrecognizable insn generated in plugin?
Message-ID: <20190530192606.GB5739@cisco>
References: <20190530170033.GA5739@cisco>
 <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
To: Andrew Pinski <pinskia@gmail.com>
Cc: GCC Mailing List <gcc@gcc.gnu.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Andrew,

On Thu, May 30, 2019 at 10:09:44AM -0700, Andrew Pinski wrote:
> On Thu, May 30, 2019 at 10:01 AM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > Hi all,
> >
> > I've been trying to implement an idea Andy suggested recently for
> > preventing some kinds of ROP attacks. The discussion of the idea is
> > here:
> > https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@amacapital.net/
> >
> > Right now I'm struggling to get my plugin to compile without crashing. The
> > basic idea is to insert some code before every "pop rbp" and "pop rsp"; I've
> > figured out how to find these instructions, and I'm inserting code using:
> >
> > emit_insn(gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
> >                       gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM))));
> 
> Simplely this xor does not set anything.
> I think you want something like:
> emit_insn(gen_rtx_SET(gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
>   gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
>       gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM)))));
> 
> But that might not work either, you might need some thing more.

Yes, thanks. You're also right that I still see the same problem:

kernel/seccomp.c: In function ‘seccomp_check_filter’:
kernel/seccomp.c:242:1: error: unrecognizable insn:
 }
 ^
(insn 698 645 699 17 (set (reg:DI 6 bp)
        (xor:DI (reg:DI 6 bp)
            (mem:DI (reg:DI 6 bp) [0  S8 A8]))) "kernel/seccomp.c":242 -1
     (nil))
during RTL pass: shorten
kernel/seccomp.c:242:1: internal compiler error: in insn_min_length, at config/i386/i386.md:14714

Thanks,

Tycho
