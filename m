References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <CAG48ez2UB0iv50091h8-Xucp93GKdx=uyqD_HQY2YfAP_zqwSg@mail.gmail.com>
 <CAG48ez1b0_WmjHABWukEcnLrV+beotynnAwz_scRss45uVB93g@mail.gmail.com>
From: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Message-ID: <dd7fd5dd-8038-a871-bdee-7b253078b933@iaik.tugraz.at>
Date: Sat, 6 May 2017 10:28:30 +0200
MIME-Version: 1.0
In-Reply-To: <CAG48ez1b0_WmjHABWukEcnLrV+beotynnAwz_scRss45uVB93g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, kirill.shutemov@linux.intel.com, Ingo
 Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-05-05 17:53, Jann Horn wrote:
> Ah, I think I understand. The kernel stacks are mapped, but
> cpu_current_top_of_stack isn't, so you can't find the stack until after the CR3
> switch in the syscall handler?

That's the idea. Only the absolute minimum that is required for a 
context switch remains mapped (+ it is mapped at an offset which does 
not depend on KASLR -> we do not leak the KASLR offsets).
