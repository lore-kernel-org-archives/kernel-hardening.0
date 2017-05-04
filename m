MIME-Version: 1.0
In-Reply-To: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 4 May 2017 08:28:52 -0700
Message-ID: <CAJcbSZHcAi37FfFBKF4MsC3WM-RY5ar_e1pgMScb=S3+_-wqVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 4, 2017 at 3:02 AM, Daniel Gruss
<daniel.gruss@iaik.tugraz.at> wrote:
> After several recent works [1,2,3] KASLR on x86_64 was basically considered
> dead by many researchers. We have been working on an efficient but effective
> fix for this problem and found that not mapping the kernel space when
> running in user mode is the solution to this problem [4] (the corresponding
> paper [5] will be presented at ESSoS17).
>
> With this RFC patch we allow anybody to configure their kernel with the flag
> CONFIG_KAISER to add our defense mechanism.
>
> If there are any questions we would love to answer them.
> We also appreciate any comments!
>
> Cheers,
> Daniel (+ the KAISER team from Graz University of Technology)
>
> [1] http://www.ieee-security.org/TC/SP2013/papers/4977a191.pdf
> [2]
> https://www.blackhat.com/docs/us-16/materials/us-16-Fogh-Using-Undocumented-CPU-Behaviour-To-See-Into-Kernel-Mode-And-Break-KASLR-In-The-Process.pdf
> [3]
> https://www.blackhat.com/docs/us-16/materials/us-16-Jang-Breaking-Kernel-Address-Space-Layout-Randomization-KASLR-With-Intel-TSX.pdf
> [4] https://github.com/IAIK/KAISER
> [5] https://gruss.cc/files/kaiser.pdf
>
>

Please read the documentation on submitting patches [1] and coding style [2].

I have two questions:

 - How this approach prevent the hardware attacks you mentioned? You
still have to keep a part of _text in the pagetable and an attacker
could discover it no? (and deduce the kernel base address). You also
need to make it clear that btb attacks are still possible.
 - What is the perf impact?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst

Thanks,
-- 
Thomas
