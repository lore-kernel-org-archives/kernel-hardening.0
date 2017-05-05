MIME-Version: 1.0
In-Reply-To: <CAG48ez2UB0iv50091h8-Xucp93GKdx=uyqD_HQY2YfAP_zqwSg@mail.gmail.com>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at> <CAG48ez2UB0iv50091h8-Xucp93GKdx=uyqD_HQY2YfAP_zqwSg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 5 May 2017 17:53:30 +0200
Message-ID: <CAG48ez1b0_WmjHABWukEcnLrV+beotynnAwz_scRss45uVB93g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: kernel list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, kirill.shutemov@linux.intel.com, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 5, 2017 at 5:49 PM, Jann Horn <jannh@google.com> wrote:
> On Thu, May 4, 2017 at 12:02 PM, Daniel Gruss
> <daniel.gruss@iaik.tugraz.at> wrote:
>> After several recent works [1,2,3] KASLR on x86_64 was basically considered
>> dead by many researchers. We have been working on an efficient but effective
>> fix for this problem and found that not mapping the kernel space when
>> running in user mode is the solution to this problem [4] (the corresponding
>> paper [5] will be presented at ESSoS17).
>>
>> With this RFC patch we allow anybody to configure their kernel with the flag
>> CONFIG_KAISER to add our defense mechanism.
>>
>> If there are any questions we would love to answer them.
>> We also appreciate any comments!
>
> Why do you need this SWITCH_KERNEL_CR3_NO_STACK logic? It would
> make sense if the kernel stacks weren't mapped, but if they weren't mapped,
> I don't see how the entry_INT80_compat entry point could work at all - the
> software interrupt itself already pushes values on the kernel stack. You could
> maybe work around that using some sort of trampoline stack, but I don't see
> anything like that. Am I missing something?

Ah, I think I understand. The kernel stacks are mapped, but
cpu_current_top_of_stack isn't, so you can't find the stack until after the CR3
switch in the syscall handler?
